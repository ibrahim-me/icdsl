"""icl - command line for the ICL layout language.

    icl check   design.icl     build + magic DRC + magic extract + netgen LVS (+ route report)
    icl build   design.icl     compile -> GDS + reference SPICE + PNG (no signoff)
    icl inspect design.icl     text dump of placement, objects, pins, routes (for agents)
    icl render  design.icl     PNG/SVG only

Options: --top CELL, --out DIR, --json, --no-lvs, --ref SCHEMATIC.spice
Exit codes: 0 clean, 1 DRC/LVS/constraint violations, 2 compile/route error.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
from collections import defaultdict

from . import tech as T
from .design import compile_file
from .export import write_gds, write_spice
from .geom import Rect
from .render import to_png
from .syntax import ICLError


def _compile(args):
    params = {}
    for kv in args.param or []:
        k, _, v = kv.partition("=")
        params[k.strip()] = v.strip()
    top, lib = compile_file(args.file, args.top, params)
    os.makedirs(args.out, exist_ok=True)
    gds = os.path.join(args.out, f"{top.name}.gds")
    ref = os.path.join(args.out, f"{top.name}.ref.spice")
    write_gds(top, lib, gds)
    write_spice(top, ref)
    return top, lib, gds, ref


def _owners_at(top, box_um, margin=20):
    x0, y0, x1, y1 = (int(round(v * 1000)) for v in box_um)
    r = Rect(x0 - margin, y0 - margin, x1 + margin, y1 + margin)
    hits = defaultdict(set)
    for s in top.all_shapes(True):
        if s.layer != "boundary" and s.rect.touches(r):
            hits[s.owner or "?"].add(s.layer)
    return {k: sorted(v) for k, v in hits.items()}


def _drc_report(top, errs):
    groups = defaultdict(list)
    for e in errs:
        groups[e["rule"]].append(e)
    return [{"rule": rule, "count": len(es),
             "examples": [{"box_um": e["box_um"], "objects": _owners_at(top, e["box_um"])} for e in es[:4]]}
            for rule, es in sorted(groups.items(), key=lambda kv: -len(kv[1]))]


def _lvs_summary(res):
    log = res["log"]
    s = {"match": res["match"], "result": res["final"]}
    m = re.findall(r"Circuit 1 contains (\d+) devices, Circuit 2 contains (\d+) devices", log)
    if m:
        s["devices_layout_vs_ref"] = [int(m[-1][0]), int(m[-1][1])]
    m = re.findall(r"Circuit 1 contains (\d+) nets,\s+Circuit 2 contains (\d+) nets", log)
    if m:
        s["nets_layout_vs_ref"] = [int(m[-1][0]), int(m[-1][1])]
    if not res["match"]:
        txt = open(res["report"]).read() if os.path.exists(res["report"]) else ""
        keep, grab = [], False
        for l in [l for l in txt.splitlines() if l.strip()]:
            if "mismatch" in l.lower() or "no matching" in l.lower() or "Net:" in l:
                grab = True
            if grab:
                keep.append(l)
            if len(keep) > 60:
                break
        s["details"] = keep
    s["pins_equivalent"] = res["pins_equivalent"]
    return s


def _warnings(lib):
    out = []
    for name, L in lib.items():
        out += [f"{name}: {w}" for w in L.warnings]
        for n in (L.route_report or {}).get("notes", []):
            out.append(f"{name}: {n}")
    return out


def _constraints(lib):
    bad = []
    for name, L in lib.items():
        rr = L.route_report or {}
        for net, r in rr.get("nets", {}).items():
            if r.get("maxres_ok") is False:
                bad.append(f"{name}: net {net} resistance {r['res_ohm']} ohm exceeds maxres")
        for c in rr.get("coupling", []):
            if not c["ok"]:
                bad.append(f"{name}: coupling {c['nets'][0]}-{c['nets'][1]} {c['fF']} fF > {c['max_fF']} fF")
    return bad


def cmd_build(args):
    top, lib, gds, ref = _compile(args)
    png = to_png(top, os.path.join(args.out, f"{top.name}.png"))
    return {"status": "built", "cell": top.name, "gds": gds, "reference_spice": ref, "image": png,
            "size_um": [top.width / 1000, top.height / 1000], "warnings": _warnings(lib),
            "routes": top.route_report}, 0


def cmd_check(args):
    from .signoff import magic_drc, magic_extract, netgen_lvs
    t0 = time.time()
    top, lib, gds, ref = _compile(args)
    rep = {"cell": top.name, "gds": gds, "reference_spice": args.ref or ref,
           "size_um": [top.width / 1000, top.height / 1000], "warnings": _warnings(lib)}
    errs, _ = magic_drc(gds, top.name, args.out)
    if args.waive:                      # e.g. tapless library cells: the tap rules are met by the row's tap cells
        waive = [w.strip() for w in args.waive.split(",") if w.strip()]
        rep["waived"] = sum(1 for e in errs if any(f"({w})" in e["rule"] for w in waive))
        errs = [e for e in errs if not any(f"({w})" in e["rule"] for w in waive)]
    rep["drc"] = {"tool": "magic drc(full) sky130A", "violations": len(errs), "by_rule": _drc_report(top, errs),
                  "all": [{"rule": e["rule"], "box_um": e["box_um"], "objects": _owners_at(top, e["box_um"])}
                          for e in errs[:150]]}
    if not args.no_lvs:
        ext, _ = magic_extract(gds, top.name, args.out)
        ref_used, ext_used, dummies = args.ref or ref, ext, 0
        if args.ref:                 # independent reference: compare without matching dummies
            from .signoff import strip_dummies
            ext_used = os.path.join(args.out, f"{top.name}.extracted.nodummy.spice")
            dummies = strip_dummies(ext, ext_used)
            ref_used = os.path.join(args.out, f"{top.name}.reference.nodummy.spice")
            strip_dummies(args.ref, ref_used)
        res = netgen_lvs(ext_used, ref_used, top.name, args.out)
        rep["lvs"] = {"tool": "netgen sky130A_setup", **_lvs_summary(res), "extracted_spice": ext,
                      "report": res["report"], "dummies_ignored": dummies}
    rep["routes"] = top.route_report
    rep["precheck"] = [{k: v for k, v in x.items() if k != "box"} for x in top.info.get("precheck", [])[:25]]
    rep["constraint_violations"] = _constraints(lib)
    rep["objects"] = top.info.get("geom_objects", {}) or top.info.get("objects", {})
    conn = top.info.get("conn")
    if conn:
        from .conncheck import summary
        rep["connectivity"] = summary(conn) if "error" not in conn else [conn["error"]]
    markers = [(Rect(*(int(round(v * 1000)) for v in e["box_um"])), e["rule"].split("(")[-1].rstrip(")"))
               for e in errs[:40]]
    labels = {}
    if getattr(top, "kind", "") == "stdcell":
        for n, o in top.info.get("geom_objects", {}).items():
            if o.get("line") and o["layer"] in ("poly", "li", "m1", "m2", "diff", "licon", "mcon"):
                b = [int(round(v * 1000)) for v in o["bbox_um"]]
                labels[n] = (Rect(*b), o["layer"])
    rep["image"] = to_png(top, os.path.join(args.out, f"{top.name}.png"), markers=markers,
                          scale=220 if labels else 120, labels=labels or None)
    rep["route_failed"] = top.info.get("route_failed", [])
    clean = len(errs) == 0 and (args.no_lvs or rep["lvs"]["match"]) and not rep["constraint_violations"] \
        and not rep["route_failed"]
    rep["status"] = "CLEAN" if clean else "VIOLATIONS"
    rep["seconds"] = round(time.time() - t0, 1)
    return rep, 0 if clean else 1


def cmd_inspect(args):
    top, lib, gds, ref = _compile(args)
    G = T.GRID
    out = [f"{top.kind} {top.name}: {top.width/1000:.2f} x {top.height/1000:.2f} um "
           f"(routing grid {G/1000} um: node (c,r) is at ({G/1000}*c, {G/1000}*r))"]
    info = top.info
    for r in info.get("rows", []):
        out.append(f"row [{r['kind']}, strap={r['strap']}, gate row {r['gate_row']}]: " +
                   "  ".join(f"{n}@col{c}" for n, c in r["items"]))
    for n, o in info.get("objects", {}).items():
        out.append(f"{o['kind']:8s} {n:14s} at {tuple(o['at_um'])} orient {o['orient']} "
                   f"bbox {tuple(round(v, 3) for v in o['bbox_um'])}")
    for n, s in info.get("shapes", {}).items():
        out.append(f"shape    {n:14s} {s}")
    for n, b in info.get("blocks", {}).items():
        out.append(f"block    {n:14s} {b}")
    for line in info.get("proximity", []):
        out.append(f"proximity: {line}")
    rr = top.route_report or {}
    if rr.get("nets"):
        out.append("routes:")
        for net, r in rr["nets"].items():
            out.append(f"  {net}: {r}")
    for c in rr.get("coupling", []):
        out.append(f"coupling {c}")
    out.append("ports: " + ", ".join(f"{n}({d}) {s.layer}@({s.rect.cx/1000:.2f},{s.rect.cy/1000:.2f})"
                                     for (n, d, s) in top.ports))
    for w in _warnings(lib):
        out.append("WARNING " + w)
    return {"text": "\n".join(out)}, 0


def cmd_render(args):
    top, lib, gds, ref = _compile(args)
    return {"image": to_png(top, os.path.join(args.out, f"{top.name}.png"))}, 0


def _print_human(cmd, rep):
    if "text" in rep:
        print(rep["text"])
        return
    if cmd != "check":
        for k, v in rep.items():
            if k != "routes":
                print(f"{k}: {v}")
        return
    print(f"== {rep['cell']}  {rep['size_um'][0]:.2f} x {rep['size_um'][1]:.2f} um  ->  {rep['status']}  ({rep['seconds']}s)")
    for w in rep.get("warnings", []):
        print(f"WARNING {w}")
    d = rep["drc"]
    print(f"DRC ({d['tool']}): {d['violations']} violation(s)")
    for g in d["by_rule"]:
        print(f"  [{g['count']}x] {g['rule']}")
        for ex in g["examples"][:2]:
            objs = "; ".join(f"{k}:{'/'.join(v)}" for k, v in ex["objects"].items())
            print(f"      at {ex['box_um']}  near {objs}")
    if "lvs" in rep:
        l = rep["lvs"]
        print(f"LVS ({l['tool']}): {'MATCH' if l['match'] else 'MISMATCH'} - {l.get('result', '')}"
              f"  devices {l.get('devices_layout_vs_ref')} nets {l.get('nets_layout_vs_ref')}"
              f"  pins_equivalent={l.get('pins_equivalent')}")
        for line in l.get("details", [])[:40]:
            print("   | " + line)
    for c in rep.get("constraint_violations", []):
        print(f"CONSTRAINT {c}")
    rr = rep.get("routes") or {}
    for c in rr.get("coupling", []):
        print(f"coupling {c['nets'][0]}-{c['nets'][1]}: {c['fF']} fF (max {c['max_fF']}) "
              f"{'ok' if c['ok'] else 'VIOLATED'}")
    for net, r in (rr.get("nets") or {}).items():
        if "maxres_ok" in r:
            print(f"resistance {net}: {r['res_ohm']} ohm {'ok' if r['maxres_ok'] else 'VIOLATED'} "
                  f"(width {r['width_um']})")
    print(f"image: {rep['image']}   gds: {rep['gds']}")


def _script_lines(e, limit=3):
    """The lines of the user's script on the way to an error (not the library's own frames)."""
    import linecache
    import traceback
    here = os.path.dirname(os.path.abspath(__file__))
    own = [f for f in traceback.extract_tb(e.__traceback__)
           if not os.path.abspath(f.filename).startswith(here) and "runpy" not in f.filename
           and not f.filename.startswith("<frozen")]
    return "".join(f"\n  {os.path.basename(f.filename)}, line {f.lineno}: "
                   f"{(f.line or linecache.getline(f.filename, f.lineno)).strip()}" for f in own[-limit:])


def _script_error(e, script):
    """A Python error raised while a canvas script ran, as text for the script's author: the script's own
    lines (not the library's), the error, and - for a wrong attribute or keyword - what exists instead."""
    import inspect
    import linecache
    import traceback
    here = os.path.dirname(os.path.abspath(__file__))
    o = []
    if isinstance(e, SyntaxError):
        o.append(f"{type(e).__name__}: {e.msg} ({os.path.basename(e.filename or script)}, line {e.lineno})")
        if e.text:
            o.append("    " + e.text.rstrip())
        return "\n".join(o)
    frames = traceback.extract_tb(e.__traceback__)
    own = [f for f in frames if not os.path.abspath(f.filename).startswith(here) and "runpy" not in f.filename
           and not f.filename.startswith("<frozen")]
    lib = [f for f in frames if os.path.abspath(f.filename).startswith(os.path.join(here, "canvas"))
           and f.name != "run_script"]
    o.append(f"{type(e).__name__}: {e}")
    for f in own[-4:]:
        o.append(f"  {os.path.basename(f.filename)}, line {f.lineno}: {(f.line or linecache.getline(f.filename, f.lineno)).strip()}")
    if lib:
        o.append(f"  (raised inside {lib[-1].name}() of the canvas library)")
    import icdsl.canvas as K
    if isinstance(e, AttributeError) and getattr(e, "obj", None) is not None:
        obj = e.obj
        cls = obj if inspect.isclass(obj) or inspect.ismodule(obj) else type(obj)
        if getattr(cls, "__module__", getattr(cls, "__name__", "")).startswith("icdsl.canvas"):
            names = sorted(a for a in dir(obj) if not a.startswith("_"))
            data = [a for a in names if not callable(getattr(obj, a, None))]
            meth = [a for a in names if callable(getattr(obj, a, None))]
            o.append(f"  hint: a {cls.__name__} has" + (" values " + ", ".join(data) if data else "")
                     + ("; methods " + ", ".join(meth) if meth else ""))
        elif isinstance(obj, (dict, list, tuple, str, float, int)):
            o.append(f"  hint: this value is a {type(obj).__name__}"
                     + (f" with keys {', '.join(map(str, list(obj)[:12]))}" if isinstance(obj, dict) else "")
                     + ", not a canvas object; see CANVAS.md for what the function returns")
    m = re.search(r"([\w.]+)\(\) (got an unexpected keyword|missing \d+ required|takes )", str(e))
    if isinstance(e, TypeError) and m:
        fn = None
        for root in (K, K.Cell, getattr(K, "Router", None)):
            cur = root
            for part in m.group(1).split("."):
                cur = getattr(cur, part, None) if cur is not None else None
            if callable(cur):
                fn = cur
                break
            cur = getattr(root, m.group(1).split(".")[-1], None) if root is not None else None
            if callable(cur):
                fn = cur
                break
        if fn is not None:
            try:
                o.append(f"  hint: the call is {m.group(1)}{inspect.signature(fn)}")
            except (TypeError, ValueError):
                pass
            doc = (inspect.getdoc(fn) or "").strip().split("\n\n")[0]
            if doc:
                o.append("        " + " ".join(doc.split())[:400])
    if isinstance(e, NameError) and getattr(e, "name", None):
        if callable(getattr(K.Cell, e.name, None)):
            o.append(f"  hint: {e.name} is a method of a cell: cell.{e.name}{inspect.signature(getattr(K.Cell, e.name))}"
                     .replace("(self, ", "("))
        elif e.name in ("from_spice", "stick_auto", "Router"):
            o.append(f"  hint: from icdsl.canvas.{'route' if e.name == 'Router' else 'synth'} import {e.name}")
    if isinstance(e, TypeError) and "not subscriptable" in str(e):
        o.append("  hint: a number was used where a point (x, y) or a shape was expected, or a shape where a list was")
    return "\n".join(o)


def _canvas(args):
    """Canvas scripts (plain Python, any PDK): icl check|build|render|inspect file.py [--top C] [--pdk P]."""
    import importlib
    C = importlib.import_module("icdsl.canvas.check")
    from .canvas.core import CanvasError
    from .canvas.tech import TechError
    try:
        cell, rep = C.run_script(args.file, top=args.top, pdk=args.pdk, out=args.out, lvs=not args.no_lvs,
                                 ref=args.ref, do_check=args.command == "check", klayout=not args.no_klayout)
        if args.command == "inspect":
            print(cell.tech.describe())
            return 0
        if rep is None:
            out = args.out or os.path.join("build", os.path.splitext(os.path.basename(args.file))[0]
                                           + "." + cell.tech.name)
            rep = C.check(cell, out=out, drc=False, lvs=False, quiet=True, precheck=args.command == "build")
            rep["status"] = "built"
    except (CanvasError, TechError) as e:
        msg = str(e) + _script_lines(e)
        if args.json:
            print(json.dumps({"status": "ERROR", "error": msg}, indent=1))
        else:
            print("ERROR " + msg, file=sys.stderr)
        return 2
    except Exception as e:                      # an error in the script itself: its own lines, plus what the API offers
        msg = _script_error(e, args.file)
        if args.json:
            print(json.dumps({"status": "ERROR", "error": msg}, indent=1))
        else:
            print("ERROR " + msg, file=sys.stderr)
        return 2
    print(json.dumps(rep, indent=1, default=str) if args.json else C.render(rep))
    return 0 if rep["status"] in ("CLEAN", "built") else 1


def main(argv=None):
    ap = argparse.ArgumentParser(prog="icl", description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("command", choices=["build", "check", "inspect", "render"])
    ap.add_argument("file")
    ap.add_argument("--top", default=None)
    ap.add_argument("--out", default=None)
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--no-lvs", action="store_true")
    ap.add_argument("--ref", default=None, help="LVS against this SPICE netlist instead of the derived one")
    ap.add_argument("--param", action="append", help="override a file-level parameter, e.g. --param WN=0.84")
    ap.add_argument("--waive", default="", help="DRC rule ids to ignore, e.g. LU.2,LU.3,nwell.4 (tapless cells)")
    ap.add_argument("--no-klayout", action="store_true",
                    help="canvas scripts: skip the foundry KLayout DRC deck (magic DRC + LVS only, faster)")
    ap.add_argument("--pdk", default=None, help="canvas scripts (.py): PDK to build on (default $ICL_PDK or sky130A)")
    args = ap.parse_args(argv)
    if args.file.endswith(".py"):
        return _canvas(args)
    if args.out is None:
        args.out = os.path.join("build", os.path.splitext(os.path.basename(args.file))[0])
    fn = {"build": cmd_build, "check": cmd_check, "inspect": cmd_inspect, "render": cmd_render}[args.command]
    try:
        rep, code = fn(args)
    except ICLError as e:
        rep, code = {"status": "ERROR", "error": e.msg, "line": e.line, "hint": e.hint}, 2
        if args.json:
            print(json.dumps(rep, indent=1))
        else:
            print("ERROR " + e.render(), file=sys.stderr)
        return code
    if args.json:
        print(json.dumps(rep, indent=1, default=str))
    else:
        _print_human(args.command, rep)
    return code


if __name__ == "__main__":
    sys.exit(main())
