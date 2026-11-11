#!/usr/bin/env python3
"""Signoff check for the model-vs-model comparison (works on ICL files AND on raw GDS).

    python bench/agent_check.py <layout.icl | layout.gds> <task> [--log DIR] [--ranked]
    python bench/agent_check.py <layout.icl> <task> --sweep [--log DIR]

tasks: nand3, a21oi (standard cells), ota5t_small (analog). Runs magic DRC (full), netgen LVS against
the task's reference netlist (matching dummies ignored), and the geometric judge (L1: VGND/VPWR met1
rails at y=0 / y=2.72 and one transistor per device; L2: matching constraints and area budget).
Every run is logged to DIR/checks.jsonl. Exit code 0 = clean.
"""
import json
import os
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agents"))


L2_NAMES = None


def task_spec(name):
    global L2_NAMES
    if L2_NAMES is None:
        L2_NAMES = {c["name"] for c in json.load(open(os.path.join(ROOT, "bench", "l2_cells.json")))["cells"]}
    if name in L2_NAMES:
        import l2_common as C
        cell = json.loads(json.dumps(C.cell_spec(name)))
        for c in cell["constraints"]:
            if c["type"] == "area":
                c["max"] = 70.0          # footprint (diff/poly/li/metal bounding box) at the nominal point
        pv = C.nominal(cell)
        return {"level": "l2", "top": name, "cell": cell, "pv": pv, "ref": C.reference_spice(cell, pv)}
    import bench_harness as BH
    cell = next(c for c in BH.BENCH["cells"] if c["name"] == name)
    pv = BH.nominal(cell)
    devs = [dict(d, nf=1) for d in cell["devices"]]
    return {"level": "l1", "top": name, "cell": dict(cell, devices=devs, constraints=[]), "pv": pv,
            "ref": BH.reference_spice(cell, pv)}


def waived(errs):
    """Drop DRC rules waived for this benchmark (ICL_WAIVE, e.g. the tap rules for tapless library cells)."""
    w = [x.strip() for x in os.environ.get("ICL_WAIVE", "").split(",") if x.strip()]
    return [e for e in errs if not any(f"({x})" in e["rule"] for x in w)]


def tiling(gds, top, work):
    """[cell][cell][cell mirrored] edge to edge (width = VGND rail length); magic DRC on the row."""
    import klayout.db as kdb
    from icdsl.signoff import magic_drc
    ly = kdb.Layout()
    ly.read(gds)
    if abs(ly.dbu - 0.001) > 1e-9:
        ly.transform(kdb.DCplxTrans(ly.dbu / 0.001))
        ly.dbu = 0.001
    c = ly.cell(top)
    m1 = kdb.Region(c.begin_shapes_rec(ly.layer(68, 20)))
    rail = [p for p in m1.merged().each() if p.bbox().bottom <= 0 <= p.bbox().top]
    if not rail:
        return None, None
    b = max(rail, key=lambda p: p.bbox().width()).bbox()
    w = b.width()
    row = ly.create_cell("tilerow")
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(-b.left, 0)))
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(w - b.left, 0)))
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(kdb.Trans.M90, 3 * w + b.left, 0)))
    os.makedirs(work, exist_ok=True)
    out = os.path.join(work, "tilerow.gds")
    ly.write(out)
    errs, _ = magic_drc(out, "tilerow", work)
    errs = waived(errs)
    return len(errs), w / 1000


def ranked(path, task, T, log):
    """Technique mode (ICL files): the harness's ranked feedback (statements, lines, gaps vs rules,
    connectivity in object names, constraint fixes)."""
    out = os.path.join(log, "ranked")
    code = open(path).read()
    if T["level"] == "l2":
        import l2_common as C
        import feedback_l2 as FB
        rep = C.run_check(path, T["cell"], T["pv"], out)
        txt = FB.make(rep, T["pv"], "ranked", code, None, None)
    else:
        import bench_harness as BH
        import feedback as FB
        cell = next(c for c in BH.BENCH["cells"] if c["name"] == task)
        rep = BH.NS.run_check(path, task, T["pv"], out, BH.reference_spice(cell, T["pv"]))
        txt = FB.make(rep, T["pv"], "ranked", code, None)
    txt = txt.replace(" (the attached image is your layout, DRC errors boxed in red)", "")
    txt = txt.replace(" (the attached image is your layout)", "")
    return txt


def sweep(path, task, T, log):
    if T["level"] == "l2":
        import l2_common as C
        pts = [C.point_params(T["cell"], p) for p in C.BENCH["sweep"]]
        run = lambda pv, d: C.run_check(path, T["cell"], pv, d)
    else:
        import bench_harness as BH
        cell = next(c for c in BH.BENCH["cells"] if c["name"] == task)
        pts = [BH.point_params(cell, p) for p in BH.BENCH["sweep"]]
        run = lambda pv, d: BH.NS.run_check(path, task, pv, d, BH.reference_spice(cell, pv))
    ok = 0
    for i, pv in enumerate(pts):
        rep = run(pv, os.path.join(log, "sweep", f"p{i}"))
        good = rep.get("status") == "CLEAN"
        ok += good
        prob = "" if good else (rep.get("error") or f"DRC {rep.get('drc', {}).get('violations')} LVS "
                                f"{rep.get('lvs', {}).get('match')} " + "; ".join(
                                    r["detail"][:100] for r in rep.get("judge", {}).get("results", []) if not r["ok"]))
        print(f"  {pv}: {'CLEAN' if good else 'FAIL ' + str(prob)[:220]}")
    print(f"sweep: {ok}/{len(pts)} points clean")
    return ok, len(pts)


def main():
    args = sys.argv[1:]
    if len(args) < 2:
        sys.exit(__doc__)
    if "--sweep" in args:
        path, task = os.path.abspath(args[0]), args[1]
        log = os.path.abspath(args[args.index("--log") + 1]) if "--log" in args else os.path.dirname(path)
        if not path.endswith(".icl"):
            sys.exit("--sweep needs an ICL file (raw GDS has fixed geometry)")
        ok, n = sweep(path, task, task_spec(task), log)
        open(os.path.join(log, "sweeps.jsonl"), "a").write(json.dumps({"t": time.time(), "ok": ok, "n": n}) + "\n")
        sys.exit(0 if ok == n else 1)
    path, task = os.path.abspath(args[0]), args[1]
    log = os.path.abspath(args[args.index("--log") + 1]) if "--log" in args else os.path.dirname(path)
    T = task_spec(task)
    n = len([1 for _ in open(os.path.join(log, "checks.jsonl"))]) if os.path.exists(os.path.join(log, "checks.jsonl")) else 0
    out = os.path.join(log, f"check_{n + 1:03d}")
    os.makedirs(out, exist_ok=True)
    rec = {"t": time.time(), "file": path, "task": task}
    top = T["top"]
    from icdsl.signoff import magic_drc, magic_extract, netgen_lvs, strip_dummies
    import gds_judge
    if path.endswith(".icl"):
        cmd = [os.path.join(ROOT, "bin", "icl"), "build", path, "--top", top, "--out", out, "--json"]
        for k, v in T["pv"].items():
            cmd += ["--param", f"{k}={v}"]
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
        try:
            b = json.loads(p.stdout)
        except Exception:
            b = {"status": "ERROR", "error": (p.stderr or p.stdout)[-600:]}
        if b.get("status") == "ERROR" or "gds" not in b:
            print("COMPILE ERROR:", b.get("error"), ("\nhint: " + b["hint"]) if b.get("hint") else "")
            rec.update(status="ERROR", error=str(b.get("error"))[:300])
            open(os.path.join(log, "checks.jsonl"), "a").write(json.dumps(rec) + "\n")
            sys.exit(2)
        gds = b["gds"]
    else:
        gds = path
    try:                                    # a missing file / wrong top cell must not look like "0 DRC errors"
        import klayout.db as kdb
        if not os.path.exists(gds):
            raise ValueError(f"no such file: {gds}")
        _ly = kdb.Layout()
        _ly.read(gds)
        if _ly.cell(top) is None:
            raise ValueError(f"the GDS has no cell named '{top}' (cells: "
                             f"{', '.join(c.name for c in _ly.each_cell())[:200]})")
    except Exception as e:
        print("CHECK FAILED:", e)
        rec.update(status="ERROR", error=str(e)[:300])
        open(os.path.join(log, "checks.jsonl"), "a").write(json.dumps(rec) + "\n")
        sys.exit(2)
    ref = os.path.join(out, f"{top}.reference.spice")
    open(ref, "w").write(T["ref"])
    try:
        errs, _ = magic_drc(gds, top, out)
        errs = waived(errs)
        ext, _ = magic_extract(gds, top, out)
        e2, r2 = os.path.join(out, "ext.nodummy.spice"), os.path.join(out, "ref.nodummy.spice")
        strip_dummies(ext, e2)
        strip_dummies(ref, r2)
        lvs = netgen_lvs(e2, r2, top, out)
        j = gds_judge.judge(gds, top, T["cell"], T["pv"], T["level"])
    except Exception as e:
        print("CHECK FAILED:", repr(e)[:500])
        rec.update(status="ERROR", error=repr(e)[:300])
        open(os.path.join(log, "checks.jsonl"), "a").write(json.dumps(rec) + "\n")
        sys.exit(2)
    if T["level"] == "l1" and not errs:
        n_abut, wcell = tiling(gds, top, os.path.join(out, "tiling"))
        j["results"].append({"constraint": {"type": "tiling"}, "ok": n_abut == 0,
                             "detail": (f"cell (width {wcell} um from the VGND rail) next to a copy and a mirrored copy: "
                                        f"{n_abut} DRC error(s) in the row") if n_abut is not None else
                             "no VGND met1 rail found at y=0 to tile with"})
        j["ok"] = j["ok"] and n_abut == 0
    clean = not errs and lvs["match"] and j["ok"]
    print(f"== {task} ({os.path.basename(path)})  size {j['size_um'][0]} x {j['size_um'][1]} um  ->  "
          f"{'CLEAN' if clean else 'NOT CLEAN'}")
    print(f"DRC (magic full): {len(errs)} violation(s)")
    by = {}
    for e in errs:
        by.setdefault(e["rule"], []).append(e["box_um"])
    for rule, boxes in sorted(by.items(), key=lambda kv: -len(kv[1]))[:10]:
        print(f"  [{len(boxes)}x] {rule}   e.g. at {boxes[0]}")
    print(f"LVS (netgen vs reference): {'MATCH' if lvs['match'] else 'MISMATCH'} - {lvs['final']}")
    if not lvs["match"]:
        txt = open(lvs["report"]).read() if os.path.exists(lvs["report"]) else ""
        keep = [l for l in txt.splitlines() if "|" in l or "Mismatch" in l or "match" in l.lower()][:30]
        print("\n".join("   " + l for l in keep))
    for r in j["results"]:
        print(("  OK   " if r["ok"] else "  FAIL ") + f"{r['constraint'].get('type')}: {r['detail']}")
    if "--ranked" in args and path.endswith(".icl") and not clean:
        print("\n--- diagnosis (ranked) ---")
        print(ranked(path, task, T, out))
    for s_ in j.get("shorts", []):
        print(f"  short (from labels): {s_['nets']}")
    print(f"reports in {out}")
    rec.update(status="CLEAN" if clean else "VIOLATIONS", drc=len(errs), lvs=lvs["match"],
               constraints_failed=sum(1 for r in j["results"] if not r["ok"]), size_um=j["size_um"])
    open(os.path.join(log, "checks.jsonl"), "a").write(json.dumps(rec) + "\n")
    sys.exit(0 if clean else 1)


if __name__ == "__main__":
    main()
