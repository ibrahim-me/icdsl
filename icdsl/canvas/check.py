"""check(cell): write GDS, connectivity pre-check, magic DRC, magic extraction + netgen LVS, PNG.

Every DRC violation is attributed to the script lines that drew the shapes under it, so an agent can
go from the report straight to the statement to change.
"""
from __future__ import annotations

import json
import os
import re
import time
from collections import defaultdict

from . import conn, signoff
from .core import CanvasError
from .gds import write_gds


def _short(path):
    try:
        r = os.path.relpath(path)
    except ValueError:
        return path
    return r if not r.startswith("..") else os.path.basename(path)


class _Attr:
    """Which script lines drew the shapes under a box (flattened layout, bucketed)."""
    B = 4000

    def __init__(self, cell):
        self.items = []
        self.b = defaultdict(list)
        skip = cell.tech.roles.get("boundary")
        for s, path in cell.flat():
            if s.layer == skip or s.src is None:
                continue
            i = len(self.items)
            self.items.append((s, path))
            for gx in range(s.x0 // self.B, s.x1 // self.B + 1):
                for gy in range(s.y0 // self.B, s.y1 // self.B + 1):
                    self.b[(gx, gy)].append(i)

    def at(self, box_um, margin=15, limit=5):
        x0, y0, x1, y1 = (int(round(v * 1000)) for v in box_um)
        x0, y0, x1, y1 = x0 - margin, y0 - margin, x1 + margin, y1 + margin
        seen, hits = set(), {}
        for gx in range(x0 // self.B, x1 // self.B + 1):
            for gy in range(y0 // self.B, y1 // self.B + 1):
                for i in self.b.get((gx, gy), ()):
                    if i in seen:
                        continue
                    seen.add(i)
                    s, path = self.items[i]
                    if s.x0 <= x1 and x0 <= s.x1 and s.y0 <= y1 and y0 <= s.y1:
                        key = f"{_short(s.src[0])}:{s.src[1]}"
                        hits.setdefault(key, set()).add(s.layer)
        small = sorted(hits.items(), key=lambda kv: kv[0])
        return [f"{k} [{','.join(sorted(v))}]" for k, v in small[:limit]] + \
            ([f"(+{len(small) - limit} more lines)"] if len(small) > limit else [])


def render_png(tech, gds, png, width=1600, markers=None):
    """PNG of a GDS with the PDK's own KLayout layer colours (headless)."""
    try:
        import klayout.lay as lay
        import klayout.db as kdb
    except Exception:
        return None
    lv = lay.LayoutView()
    lv.load_layout(gds, True)
    lyp = tech.d.get("lyp")
    lyp = os.path.join(tech.root, lyp) if lyp else None
    if lyp and os.path.exists(lyp):
        lv.load_layer_props(lyp)
    disp = {tuple(tech.alias[k]): v for k, v in tech.d.get("display", {}).items() if k in tech.alias}
    it = lv.begin_layers()                   # optional per-PDK colours on top of the PDK's layer table
    while disp and not it.at_end():
        lp = it.current()
        v = disp.get((lp.source_layer, lp.source_datatype))
        if v:
            lp.fill_color = lp.frame_color = int(v[0].lstrip("#"), 16)
            lp.dither_pattern = v[1]
        it.next()
    lv.max_hier()
    bb = lv.active_cellview().cell.dbbox()
    m = 0.03 * max(bb.width(), bb.height(), 1e-3)
    bb = kdb.DBox(bb.left - m, bb.bottom - m, bb.right + m, bb.top + m)
    asp = bb.height() / max(bb.width(), 1e-9)
    w, h = (width, int(width * asp)) if asp <= 1 else (int(width / asp), width)
    w, h = max(w, 240), max(h, 240)
    lv.save_image_with_options(png, w, h, 0, 0, 0.0, bb, False)
    return png


def _case_check(cell):
    """SPICE (and so LVS) is case-insensitive: nets 'y' and 'Y' in one cell would silently be one net."""
    from .core import CanvasError
    for c in cell.all_cells():
        if getattr(c, "foreign", False):
            continue
        seen = {}
        names = [s.net for s in c.shapes if s.net] + list(c.ports) + [n for d in c.devices for n in d["nodes"]]
        for r in c.refs:
            names += list((r.conns or {}).values()) if hasattr(r, "conns") else []
        for n in names:
            o = seen.setdefault(str(n).lower(), n)
            if o != n:
                raise CanvasError(f"cell {c.name}: nets {o!r} and {n!r} differ only by case; SPICE and LVS "
                                  f"treat them as one net", "rename one of them")


def check(cell, out=None, lvs=True, ref=None, drc=True, png=True, quiet=False, precheck=True, klayout=True):
    """Full verification of a canvas cell. Returns a report dict; report['status'] is 'CLEAN' only when
    magic DRC has no violation, the foundry KLayout DRC deck (if the PDK data names one and klayout=True)
    has none either, and (if the cell has a netlist or ref= is given) netgen LVS matches.
    A PDK without a magic tech file (asap7) is judged by its KLayout deck alone, and its layout netlist
    comes from the KLayout extraction described in the PDK data (signoff.extract).
    ref = path of a SPICE netlist to compare against instead of the script's own device declarations."""
    t = cell.tech
    t0 = time.time()
    _case_check(cell)
    out = out or os.path.join("build", "canvas", f"{cell.name}.{t.name}")
    os.makedirs(out, exist_ok=True)
    gds = write_gds(cell, os.path.join(out, f"{cell.name}.gds"))
    nshape, ndev = cell.count()
    b = cell.bbox
    rep = {"cell": cell.name, "pdk": t.name, "gds": gds, "shapes": nshape, "devices_declared": ndev,
           "size_um": [round(b[2] - b[0], 3), round(b[3] - b[1], 3)],
           "area_um2": round((b[2] - b[0]) * (b[3] - b[1]), 2)}
    if precheck:
        rep["connectivity"] = conn.analyze(cell)
    notes = [n for c in cell.all_cells() for n in c.__dict__.get("notes", [])]
    if notes:
        rep["notes"] = notes[:8] + ([f"(+{len(notes) - 8} more of this kind)"] if len(notes) > 8 else [])
    clean = True

    def tool(run):              # a DRC tool that failed or did not finish counts as one violation, with its message
        try:
            return run()
        except RuntimeError as e:
            return [{"rule": "TOOL: " + str(e)[:400], "box_um": [0, 0, 0, 0]}], [], ""
    attr = []

    def grouped(name, errs, waived=None):
        if errs and not attr:
            attr.append(_Attr(cell))
        groups = defaultdict(list)
        for e in errs:
            groups[e["rule"]].append(e)
        d = {"tool": name, "violations": len(errs),
             "by_rule": [{"rule": r, "count": len(es),
                          "examples": [{"box_um": e["box_um"], "drawn_by": attr[0].at(e["box_um"])} for e in es[:3]]}
                         for r, es in sorted(groups.items(), key=lambda kv: -len(kv[1]))]}
        if waived is not None:
            d["waived_rules"] = waived
        return d

    def deck_name():
        return f"KLayout, {os.path.basename(t.d['signoff']['klayout']['deck'])}"
    if drc and signoff.magic_ready(t):
        errs = tool(lambda: signoff.drc(t, gds, cell.name, out))[0]
        rep["drc"] = grouped(f"magic {t.d['signoff'].get('drc_style', 'drc')} {t.name}", errs)
        clean &= not errs
        if klayout and signoff.klayout_ready(t):
            errs, waived, _ = tool(lambda: signoff.klayout_drc(t, gds, cell.name, out))
            rep["drc_klayout"] = grouped(deck_name(), errs, waived)
            clean &= not errs
    elif drc:
        # A PDK without a magic tech file: its KLayout deck is the only DRC judge, so it always runs
        # (klayout=False / ICL_KLAYOUT=0 do not apply) and a missing deck or binary is a failure.
        if not t.d["signoff"].get("klayout"):
            errs, waived = [{"rule": f"TOOL: the PDK data of {t.name} names no DRC deck (signoff.magicrc or "
                                     "signoff.klayout)", "box_um": [0, 0, 0, 0]}], []
        elif not signoff.klayout_ready(t, force=True):
            errs, waived = [{"rule": f"TOOL: the DRC deck of {t.name} or the klayout program was not found "
                                     f"(deck {signoff.klayout_deck(t)}; run tools/build_tools.sh)",
                             "box_um": [0, 0, 0, 0]}], []
        else:
            errs, waived, _ = tool(lambda: signoff.klayout_drc(t, gds, cell.name, out))
        rep["drc"] = grouped(deck_name() if t.d["signoff"].get("klayout") else "none", errs, waived)
        clean &= not errs
    do_lvs = lvs and (ref or cell.has_netlist())
    if do_lvs:
        refp = ref
        if not refp:
            refp = os.path.join(out, f"{cell.name}.ref.spice")
            open(refp, "w").write(cell.netlist())
        try:
            ext, _ = signoff.extract(t, gds, cell.name, out, ports=cell.port_order)
            res = signoff.lvs(t, ext, refp, cell.name, out)
            res.pop("log", None)
            res["devices_extracted"] = signoff.count_devices(ext)
        except RuntimeError as e:               # a tool that failed or did not finish: the DRC report stays
            ext, res = "-", dict(match=False, final=str(e)[:400], pins_equivalent=False, report="-")
        res["extracted_spice"], res["reference_spice"] = ext, refp
        rep["lvs"] = res
        clean &= res["match"]
    elif lvs:
        rep["lvs"] = None
    if png:
        try:
            rep["image"] = render_png(t, gds, os.path.join(out, f"{cell.name}.png"))
        except Exception as e:                                # rendering must never fail a check
            rep["image"] = f"(render failed: {e})"
    rep["status"] = "CLEAN" if clean else "VIOLATIONS"
    rep["seconds"] = round(time.time() - t0, 1)
    json.dump(rep, open(os.path.join(out, f"{cell.name}.report.json"), "w"), indent=1, default=str)
    if not quiet:
        print(render(rep))
    return rep


def render(rep):
    o = [f"{rep['cell']} on {rep['pdk']}: {rep['size_um'][0]:g} x {rep['size_um'][1]:g} um "
         f"({rep['area_um2']:g} um2), {rep['shapes']} shapes, {rep['devices_declared']} declared devices"]
    if rep.get("connectivity"):
        o += conn.render(rep["connectivity"])
    o += ["note: " + n for n in rep.get("notes", [])]
    for d in (rep.get("drc"), rep.get("drc_klayout")):
        if not d:
            continue
        if not d["violations"]:
            o.append(f"DRC ({d['tool']}): clean" + (f"  (not judged on a block: {' '.join(d['waived_rules'])})"
                                                     if d.get("waived_rules") else ""))
        else:
            o.append(f"DRC ({d['tool']}): {d['violations']} violation(s), {len(d['by_rule'])} rule(s)")
            for g in d["by_rule"][:14]:
                o.append(f"  {g['count']:4d} x {g['rule']}")
                for e in g["examples"][:2]:
                    bx = e["box_um"]
                    o.append(f"         at ({bx[0]:g}, {bx[1]:g})..({bx[2]:g}, {bx[3]:g})  drawn by "
                             + ("; ".join(e["drawn_by"]) or "?"))
            if len(d["by_rule"]) > 14:
                o.append(f"  ... {len(d['by_rule']) - 14} more rules (see the report json)")
    l = rep.get("lvs")
    if l:
        cnt = ""
        if "devices_layout_vs_ref" in l:
            cnt = f"  devices layout/ref {l['devices_layout_vs_ref'][0]}/{l['devices_layout_vs_ref'][1]}" \
                  f", nets {l.get('nets_layout_vs_ref', ['?', '?'])[0]}/{l.get('nets_layout_vs_ref', ['?', '?'])[1]}"
        o.append(f"LVS (netgen): {'match' if l['match'] else 'MISMATCH'} - {l['final']}{cnt}")
        if not l["match"]:
            for ln in l.get("details", [])[:40]:
                o.append("    " + ln)
            o.append(f"    full report: {l['report']}   extracted: {l['extracted_spice']}")
    elif "lvs" in rep:
        o.append("LVS: skipped (no devices declared and no ref= netlist)")
    o.append(f"result: {rep['status']}   ({rep['seconds']} s)   gds: {rep['gds']}"
             + (f"   image: {rep['image']}" if rep.get("image") else ""))
    return "\n".join(o)


def run_script(path, top=None, pdk=None, out=None, lvs=True, ref=None, as_json=False, do_check=True,
               png=True, klayout=True):
    """Run a canvas script and check one of its cells (CLI: icl check file.py --top NAME --pdk PDK)."""
    import runpy
    import sys
    from . import tech as T
    from .core import Cell
    if pdk:
        os.environ["ICL_PDK"] = pdk
        T._default[0] = None
    Cell.registry.clear()
    sys.path.insert(0, os.path.dirname(os.path.abspath(path)))
    try:
        ns = runpy.run_path(path, run_name="__icl__")
    finally:
        sys.path.pop(0)
    cell = None
    if top:
        cell = Cell.registry.get(top)
        if cell is None:
            raise CanvasError(f"no cell {top!r} was created by {path}",
                              "cells: " + ", ".join(Cell.registry) if Cell.registry else "the script made no Cell")
    else:
        cell = ns.get("TOP") if isinstance(ns.get("TOP"), Cell) else None
        if cell is None:
            if not Cell.registry:
                raise CanvasError(f"{path} created no Cell")
            cell = list(Cell.registry.values())[-1]
    if not do_check:
        return cell, None
    o = out or os.path.join("build", os.path.splitext(os.path.basename(path))[0] + "." + cell.tech.name)
    rep = check(cell, out=o, lvs=lvs, ref=ref, quiet=True, png=png, klayout=klayout)
    return cell, rep
