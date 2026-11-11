#!/usr/bin/env python3
"""Score every run of the ICL vs raw-GDS comparison: re-check the deliverable with the shared checker,
count the agent's own checker runs, time between its first and last check, and (ICL only) the sweep."""
import glob
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PY = os.path.join(ROOT, ".venv", "bin", "python")
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agents"))


def sweep_icl(path, task):
    """Sweep points (ICL only): standard cells use the L1 bench sweep, analog the L2 sweep."""
    if task == "ota5t_small":
        import l2_common as C
        cell = C.cell_spec(task)
        pts = [C.point_params(cell, p) for p in C.BENCH["sweep"]]
        ok = 0
        for i, pv in enumerate(pts):
            rep = C.run_check(path, cell, pv, f"/tmp/cmp_sweep/{task}/{os.getpid()}/p{i}")
            ok += rep.get("status") == "CLEAN"
        return f"{ok}/{len(pts)}"
    import bench_harness as BH
    cell = next(c for c in BH.BENCH["cells"] if c["name"] == task)
    ok = 0
    for i, pt in enumerate(BH.BENCH["sweep"]):
        pv = BH.point_params(cell, pt)
        rep = BH.NS.run_check(path, task, pv, f"/tmp/cmp_sweep/{task}/{os.getpid()}/p{i}", BH.reference_spice(cell, pv))
        ok += rep.get("status") == "CLEAN"
    return f"{ok}/{len(BH.BENCH['sweep'])}"


def abut_check(gds, top, work):
    """Standard cells must tile: place [cell][cell][cell mirrored] edge to edge (width = VGND rail
    length) and count magic DRC errors of the row."""
    import klayout.db as kdb
    from icdsl.signoff import magic_drc
    ly = kdb.Layout()
    ly.read(gds)
    c = ly.cell(top)
    m1 = kdb.Region(c.begin_shapes_rec(ly.layer(68, 20)))
    rail = [p for p in m1.merged().each() if p.bbox().bottom <= 0 <= p.bbox().top]
    if not rail:
        return None, None
    b = max(rail, key=lambda p: p.bbox().width()).bbox()
    w = b.width()
    row = ly.create_cell("abutrow")
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(-b.left, 0)))
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(w - b.left, 0)))
    row.insert(kdb.CellInstArray(c.cell_index(), kdb.Trans(kdb.Trans.M90, 3 * w + b.left, 0)))
    os.makedirs(work, exist_ok=True)
    out = os.path.join(work, "abutrow.gds")
    ly.write(out)
    errs, _ = magic_drc(out, "abutrow", work)
    return len(errs), w / 1000


rows = []
usage = json.load(open(os.path.join(ROOT, "agent_compare", "usage.json"))) if os.path.exists(
    os.path.join(ROOT, "agent_compare", "usage.json")) else {}
for d in sorted(glob.glob(os.path.join(ROOT, "agent_compare", "*-*-*"))):
    if not os.path.isdir(d):
        continue
    name = os.path.basename(d)
    model, cond, task = name.split("-", 2)
    deliver = os.path.join(d, f"{task}.{'icl' if cond == 'icl' else 'gds'}")
    log = os.path.join(d, "checks.jsonl")
    checks = [json.loads(l) for l in open(log)] if os.path.exists(log) else []
    first_clean = next((i + 1 for i, c in enumerate(checks) if c.get("status") == "CLEAN"), None)
    span = (checks[-1]["t"] - checks[0]["t"]) / 60 if len(checks) > 1 else 0
    status, size, sweep = "missing", None, "-"
    rows_extra = {"abut_drc": None}
    if os.path.exists(deliver):
        fl = os.path.join(d, "final_score")
        os.makedirs(fl, exist_ok=True)
        for f in glob.glob(os.path.join(fl, "checks.jsonl")):
            os.remove(f)
        subprocess.run([PY, os.path.join(ROOT, "bench", "agent_check.py"), deliver, task, "--log", fl],
                       capture_output=True, text=True, timeout=900)
        rec = [json.loads(l) for l in open(os.path.join(fl, "checks.jsonl"))][-1]
        status = rec.get("status")
        if status == "VIOLATIONS":
            status = f"drc={rec.get('drc')} lvs={'ok' if rec.get('lvs') else 'FAIL'} cons_failed={rec.get('constraints_failed')}"
        size = rec.get("size_um")
        if cond == "icl" and rec.get("status") == "CLEAN":
            sweep = sweep_icl(deliver, task)
        if task != "ota5t_small" and rec.get("status") == "CLEAN":
            g = deliver if cond == "raw" else glob.glob(os.path.join(fl, "check_*", f"{task}.gds"))[0]
            abut, width = abut_check(g, task, os.path.join(fl, "abut"))
            size = [width, 2.72] if width else size
            rows_extra = {"abut_drc": abut}
        else:
            rows_extra = {"abut_drc": None}
    u = usage.get(name, {})
    rows.append({"run": name, "model": model, "cond": cond, "task": task, "final": status, "size_um": size,
                 "checks": len(checks), "first_clean_at": first_clean, "minutes": round(span, 1), "sweep": sweep,
                 "tokens": u.get("tokens"), "tool_uses": u.get("tool_uses"), "agent_minutes": u.get("minutes"),
                 **rows_extra})
json.dump(rows, open(os.path.join(ROOT, "agent_compare", "results.json"), "w"), indent=1)
print(f"{'run':28s} {'final':38s} {'size um':14s} {'checks':>6s} {'clean@':>6s} {'min':>5s} {'sweep':>5s} "
      f"{'tokens':>8s} {'tools':>5s} {'abut':>5s}")
for r in rows:
    print(f"{r['run']:28s} {str(r['final']):38s} {str(r['size_um']):14s} {r['checks']:>6d} "
          f"{str(r['first_clean_at'] or '-'):>6s} {r['minutes']:>5} {r['sweep']:>5s} {str(r['tokens'] or '-'):>8s} "
          f"{str(r['tool_uses'] or '-'):>5s} {str(r['abut_drc'] if r['abut_drc'] is not None else '-'):>5s}")
