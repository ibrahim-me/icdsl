#!/usr/bin/env python
"""Judge for the XL benchmark: is this layout a solution of the task on this PDK?

    .venv/bin/python bench/xl/judge.py TASK PDK SUBMISSION [--out DIR] [--json]

SUBMISSION is a GDS file (top cell named like the task), a canvas script (.py) or an ICL file (.icl,
sky130A only). The verdict does not depend on how the GDS was made:

    DRC    magic drc(full) of the PDK, zero violations
    DRC2   the foundry's KLayout DRC deck, zero violations (die-level density rules waived)
    LVS    netgen, extracted layout vs tasks/TASK/PDK.spice (devices, W/L, nets, pin names)
    area   bounding box of the top cell within the task's budget
    spiral (no netlist) geometry checks instead of LVS: open coil, turns, width, 45-degree edges, underpass

Exit code 0 = solved, 1 = not solved, 2 = the submission could not be built / read.
"""
import argparse
import json
import math
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, ROOT)
from icdsl.canvas import tech as T, signoff                    # noqa: E402
from icdsl.canvas.core import CanvasError                      # noqa: E402


def build(sub, top, pdk, out):
    """-> path of a GDS that holds the top cell."""
    ext = os.path.splitext(sub)[1].lower()
    if ext in (".gds", ".gds2", ".oas"):
        return sub
    if ext == ".py":
        from icdsl.canvas.check import run_script
        from icdsl.canvas.gds import write_gds
        from icdsl.canvas.core import Cell
        cell, _ = run_script(sub, pdk=pdk, do_check=False)
        cell = Cell.registry.get(top, cell)
        if cell.name != top:
            raise CanvasError(f"the script's top cell is {cell.name!r}; the task needs a cell named {top!r}")
        return write_gds(cell, os.path.join(out, top + ".gds"))
    if ext == ".icl":
        if not pdk.startswith("sky130"):
            raise CanvasError("ICL (.icl) files only build on sky130")
        p = subprocess.run([os.path.join(ROOT, "bin", "icl"), "build", sub, "--top", top, "--out", out],
                           capture_output=True, text=True)
        gds = os.path.join(out, top + ".gds")
        if p.returncode != 0 or not os.path.exists(gds):
            raise CanvasError("icl build failed:\n" + (p.stdout + p.stderr)[-2000:])
        return gds
    raise CanvasError(f"unknown submission type {ext!r} (use .gds, .py or .icl)")


def top_bbox(gds, top):
    import klayout.db as kdb
    ly = kdb.Layout()
    ly.read(gds)
    c = ly.cell(top)
    if c is None:
        raise CanvasError(f"{gds} has no cell named {top!r}", "cells: " + ", ".join(x.name for x in ly.each_cell()))
    b = c.dbbox()
    return ly, c, (b.left, b.bottom, b.right, b.top)


def spiral_checks(tech, ly, cell, spec):
    """Geometry of a spiral inductor. -> [(check, ok, detail)]"""
    import klayout.db as kdb
    dbu = ly.dbu
    topm, under = tech.stack[-1], tech.stack[-2]
    cut = tech.cut_between(under, topm)
    reg = lambda name: kdb.Region(cell.begin_shapes_rec(ly.layer(*tech.layer(name)))).merged()
    M, U, C = reg(topm), reg(under), reg(cut)
    out = []
    if M.is_empty():
        return [("top metal present", False, f"nothing on {topm}")]
    polys = sorted(M.each(), key=lambda p: -p.area())
    coil = polys[0]
    out.append(("one coil, no closed loop", coil.holes() == 0 and coil.area() >= 0.9 * M.area(),
                f"{len(polys)} polygon(s) on {topm}, largest has {coil.holes()} hole(s) and "
                f"{100 * coil.area() / M.area():.0f}% of the metal"))
    # edges: only Manhattan or 45 degrees, and some at 45
    n45 = nbad = 0
    for e in coil.each_edge():
        dx, dy = abs(e.dx()), abs(e.dy())
        if dx and dy:
            if dx == dy:
                n45 += 1
            else:
                nbad += 1
    out.append(("edges Manhattan or 45 degrees, some at 45", n45 >= 8 and nbad == 0, f"{n45} at 45 degrees, {nbad} at other angles"))
    # width: shrunk by half the width, the coil must still be one piece (a neck, or a throat between two
    # parts that only meet at a corner, cuts it; a trace that is too thin everywhere leaves nothing). Parts
    # that the shrinking removes for good (opening = shrink, then grow) may only be small dead ends, such
    # as the pad of the via at the inner end sticking out of the trace: at most (width / 2)^2 in area.
    wmin = int(round(spec["width_um"] / dbu))
    tol = 2 * tech.grid // max(1, int(round(dbu * 1000))) + 2
    R0 = kdb.Region(coil)
    half = (wmin - tol) // 2
    core = R0.sized(-half).merged()
    opened = (core.sized(half) & R0).merged()
    gone = (R0 - opened).merged()
    stub_max = (wmin // 2) ** 2
    big = [q for q in gone.each() if q.area() > stub_max]
    stubs = gone.count() - len(big)
    narrow = R0.width_check(wmin - tol)
    spots = []
    for ep in list(narrow.each())[:3]:
        eb = ep.bbox()
        spots.append(f"{ep.distance() * dbu:.3f} um wide at ({eb.left * dbu:.2f}, {eb.bottom * dbu:.2f})..("
                     f"{eb.right * dbu:.2f}, {eb.top * dbu:.2f})")
    wok = core.count() == 1 and not big
    if wok:
        detail = f"no narrow part in the trace on {topm}" + (
            f" ({stubs} dead end(s) of at most {stub_max * dbu * dbu:g} um2 not counted)" if stubs else "")
    else:
        why = []
        if core.count() == 0:
            why.append(f"no part of the coil is {spec['width_um']} um wide")
        elif core.count() > 1:
            why.append(f"the trace is cut where it is narrower than {spec['width_um']} um: {core.count()} pieces are left "
                       f"(also where two parts of the trace only meet at a corner)")
        for q in big[:2]:
            qb = q.bbox()
            why.append(f"a narrow part of {q.area() * dbu * dbu:.1f} um2 at ({qb.left * dbu:.2f}, {qb.bottom * dbu:.2f})..("
                       f"{qb.right * dbu:.2f}, {qb.top * dbu:.2f})")
        detail = (f"{narrow.count()} narrow spot(s) on {topm}: " + "; ".join(why) + (". Measured: " + "; ".join(spots) if spots else "")
                  + f" (a dead end of at most {stub_max * dbu * dbu:g} um2, such as a via pad at the end of the trace, is not counted)")
    out.append((f"trace width >= {spec['width_um']} um", wok, detail))
    # turns: the best point p (off the metal) for min over the 4 axis rays of the number of crossings
    R = R0
    b = coil.bbox()
    # half a trace width, but never more than 200 points per axis (a layout drawn 1000 times too large
    # would otherwise take hours)
    step = max(wmin // 2, max(b.width(), b.height()) // 200, 1)
    best, centre, reach = 0, None, 0

    def crossings(p, d):
        box = {0: kdb.Box(p.x, p.y - 1, b.right + 1, p.y + 1), 1: kdb.Box(b.left - 1, p.y - 1, p.x, p.y + 1),
               2: kdb.Box(p.x - 1, p.y, p.x + 1, b.top + 1), 3: kdb.Box(p.x - 1, b.bottom - 1, p.x + 1, p.y)}[d]
        pieces = (R & kdb.Region(box)).merged()
        far = 0
        for q in pieces.each():
            qb = q.bbox()
            far = max(far, [qb.right - p.x, p.x - qb.left, qb.top - p.y, p.y - qb.bottom][d])
        return pieces.count(), far
    xs = range(b.left + step, b.right, step)
    ys = range(b.bottom + step, b.top, step)
    for x in xs:
        for y in ys:
            p = kdb.Point(x, y)
            if coil.inside(p):
                continue
            cr = [crossings(p, d) for d in range(4)]
            n = min(k for k, _ in cr)
            if n > best:
                best, centre, reach = n, p, min(f for _, f in cr)
    out.append((f"at least {spec['turns']} turns around the centre", best >= spec["turns"],
                f"{best} turn(s)" + (f" around ({centre.x * dbu:.1f}, {centre.y * dbu:.1f})" if centre else "")))
    # underpass: a cut on the coil whose lower-metal polygon leaves the coil
    ok, detail = False, f"no {cut} cut on the coil joins a {under} wire that leaves the coil"
    if centre is not None:
        for u in U.each():
            ub = u.bbox()
            joined = not (kdb.Region(u) & C & R).is_empty()
            leaves = (ub.right - centre.x > reach or centre.x - ub.left > reach or ub.top - centre.y > reach
                      or centre.y - ub.bottom > reach)
            if joined and leaves:
                ok, detail = True, f"{under} wire {ub.width() * dbu:.1f} x {ub.height() * dbu:.1f} um joined by {cut}"
                break
    out.append(("underpass from the inner end to outside the coil", ok, detail))
    return out


def judge(task, pdk, sub, out=None):
    tdir = os.path.join(HERE, "tasks", task)
    meta = json.load(open(os.path.join(tdir, "task.json")))
    if pdk not in meta["pdks"]:
        raise CanvasError(f"task {task} has no reference for {pdk}", "PDKs: " + ", ".join(meta["pdks"]))
    info, top = meta["pdks"][pdk], meta["top"]
    out = os.path.abspath(out or os.path.join(ROOT, "build", "judge", f"{task}.{pdk}"))
    os.makedirs(out, exist_ok=True)
    os.environ["ICL_PDK"] = pdk
    T._default[0] = None
    tech = T.use(pdk)
    gds = build(sub, top, pdk, out)
    ly, cell, bb = top_bbox(gds, top)
    area = (bb[2] - bb[0]) * (bb[3] - bb[1])
    rep = dict(task=task, pdk=pdk, submission=sub, gds=gds, checks=[])
    add = lambda name, ok, detail: rep["checks"].append(dict(check=name, ok=bool(ok), detail=detail))
    detail = []                                  # per rule: count, text, the first boxes (um) - for the submitter

    def drc_check(name, title, run, clean):
        try:
            errs = run()
        except RuntimeError as e:                # a tool that did not finish (signoff.TIMEOUT) fails the check
            add(name, False, str(e)[:300])
            return
        by = {}
        for e in errs:
            by.setdefault(e["rule"], []).append(e["box_um"])
        top_rules = sorted(by.items(), key=lambda kv: -len(kv[1]))
        add(name, not errs, clean if not errs else f"{title}{len(errs)} violation(s): "
            + "; ".join(f"{len(b)} x {r[:90]}" for r, b in top_rules[:6]))
        if errs:
            detail.append(f"{name} ({title.strip(': ') or 'magic drc(full)'}): {len(errs)} violation(s), boxes in um")
            for r, b in top_rules[:12]:
                detail.append(f"  {len(b):4d} x {r[:150]}   e.g. at " + "  ".join(
                    "(%.3f %.3f %.3f %.3f)" % tuple(x) for x in b[:3]))
    drc_check("DRC", "", lambda: signoff.drc(tech, gds, top, out)[0], "clean")
    if signoff.klayout_ready(tech):
        drc_check("DRC2", "foundry KLayout deck: ", lambda: signoff.klayout_drc(tech, gds, top, out)[0],
                  "foundry KLayout deck clean")
    if meta["kind"] == "lvs":
        try:
            ext, _ = signoff.extract(tech, gds, top, out)
            res = signoff.lvs(tech, ext, os.path.join(tdir, info["netlist"]), top, out)
        except RuntimeError as e:
            res = dict(match=False, final=str(e)[:300], pins_equivalent=True, report="-")
        dv = res.get("devices_layout_vs_ref", ["?", "?"])
        add("LVS", res["match"], res["final"] + f"  (devices layout/ref {dv[0]}/{dv[1]}; report {res['report']})")
        add("pins", res["match"] and res["pins_equivalent"], "top-level pin names differ from the task netlist"
            if not res["pins_equivalent"] else "pin lists equivalent" if res["match"] else "not confirmed (LVS failed)")
        if not res["match"]:
            nv = res.get("nets_layout_vs_ref", ["?", "?"])
            detail.append(f"LVS: {res['final']}   devices layout/ref {dv[0]}/{dv[1]}, nets layout/ref {nv[0]}/{nv[1]}")
            detail += ["  " + l for l in res.get("details", [])[:40]]
    else:
        for name, ok, detail in spiral_checks(tech, ly, cell, meta["spiral"]):
            add(name, ok, detail)
    add("area", area <= info["area_budget_um2"] * (1 + 1e-9),
        f"{bb[2] - bb[0]:.2f} x {bb[3] - bb[1]:.2f} = {area:.1f} um2, budget {info['area_budget_um2']:g}, "
        f"reference {info['ref_area_um2']:g}")
    rep["area_um2"] = round(area, 2)
    rep["area_vs_reference"] = round(area / info["ref_area_um2"], 3)
    rep["solved"] = all(c["ok"] for c in rep["checks"])
    rep["detail"] = "\n".join(detail)
    json.dump(rep, open(os.path.join(out, "judge.json"), "w"), indent=1)
    return rep


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("task"), ap.add_argument("pdk"), ap.add_argument("submission")
    ap.add_argument("--out"), ap.add_argument("--json", action="store_true")
    ap.add_argument("--detail", action="store_true", help="also print the rules with example boxes and the LVS diff")
    a = ap.parse_args()
    try:
        rep = judge(a.task, a.pdk, a.submission, a.out)
    except (CanvasError, T.TechError, FileNotFoundError, RuntimeError) as e:
        print(f"ERROR {e}")
        return 2
    if a.json:
        print(json.dumps(rep, indent=1))
    else:
        for c in rep["checks"]:
            print(f"  {'ok  ' if c['ok'] else 'FAIL'} {c['check']:8s} {c['detail']}")
        if a.detail and rep["detail"]:
            print(rep["detail"])
        print(f"{a.task} on {a.pdk}: {'SOLVED' if rep['solved'] else 'NOT SOLVED'}   area {rep['area_vs_reference']:.2f} x reference")
    return 0 if rep["solved"] else 1


if __name__ == "__main__":
    sys.exit(main())
