"""Feedback for the level-2 benchmark (analog assembly).

basic  - status, DRC rules with the objects under each error, LVS table, constraint results
ranked - constraint failures first, each with the ICL statement that satisfies it, then compile errors
         quoted with their source line, LVS in plain words, DRC grouped by the objects (and lines)
         involved
"""
from __future__ import annotations

from collections import Counter

HOW = {
    "interdigitated": "put both devices into ONE pattern object in a single row: "
                      "`interdigitate {a} {b} pattern=ABBA dummies=1 name=X` (each letter is one finger: "
                      "A appears nf({a}) times), then place X",
    "common_centroid": "put the devices into ONE pattern whose letters are symmetric about the centre: 2-D "
                       "`common_centroid {devs} pattern=AB/BA dummies=1 name=X`, or 1-D `interdigitate ... "
                       "pattern=ABBBBA` for a 1:2 ratio (letter counts = finger counts)",
    "mirror_symmetric": "place every pair with `pair A B axis=<x> above=<obj>` using the SAME axis expression for "
                        "all pairs (e.g. axis=MT.cx), and keep unpaired objects centred on that axis",
    "guard_ring": "`guardring G around=[{devs}] kind={kind} net=<supply>` (leave room: vgap= / gap= around it)",
    "route_width": "`route {net} width={min}`",
    "spacing": "`route {a} avoid={b}:{min}` (the router keeps the wires apart; pins may still be close)",
    "maxres": "`route {net} maxres={max}` or a wider route",
    "route_symmetric": "`route {a} {b} symmetric axis=<the pairs' axis>` (the pins must be mirror images)",
    "fingers": "keep the device line exactly as given; every finger must be drawn (no merging into one wide finger)",
    "area": "make it smaller: stack the pattern rows tightly (gap=min), put taps next to the devices instead "
            "of in separate rows, fewer dummies, align objects so the bounding box has no empty corners",
    "devices": "a transistor in the layout matches no device: check gate/source/drain nets and dummies",
}


def _how(c):
    t = c.get("type")
    h = HOW.get(t, "")
    try:
        if t in ("interdigitated",):
            return h.format(a=c["devices"][0], b=c["devices"][1])
        if t == "common_centroid":
            return h.format(devs=" ".join(c["devices"]))
        if t == "guard_ring":
            return h.format(devs=", ".join(c["devices"]), kind=c["kind"])
        if t == "route_width":
            return h.format(net=c["net"], min=c["min"])
        if t == "spacing":
            return h.format(a=c["nets"][0], b=c["nets"][1], min=c["min"])
        if t == "maxres":
            return h.format(net=c["net"], max=c["max"])
        if t == "route_symmetric":
            return h.format(a=c["nets"][0], b=c["nets"][1])
    except (KeyError, IndexError):
        pass
    return h


def _constraints(rep, with_how):
    out = []
    j = rep.get("judge") or {}
    if j.get("error"):
        out.append(f"  (constraint judge could not run: {j['error'][:200]})")
    for r in j.get("results", []):
        if r["ok"]:
            continue
        c = r["constraint"]
        out.append(f"  FAILED {c.get('type')}: {r['detail']}")
        if with_how:
            h = _how(c)
            if h:
                out.append(f"     how: {h}")
    ok = [r for r in j.get("results", []) if r["ok"]]
    if ok:
        out.append("  satisfied: " + "; ".join(f"{r['constraint'].get('type')} ({r['detail'][:70]})" for r in ok))
    return out


def make(rep, pv, mode, code, prev_code=None, cell=None):
    lines = []
    if prev_code is not None and prev_code.strip() == code.strip():
        lines.append("NOTE: this file is identical to your previous attempt - change the statements named below.")
    if rep.get("status") == "ERROR":
        ln = rep.get("line") or 0
        src = code.splitlines()[ln - 1].strip() if 0 < ln <= len(code.splitlines()) else ""
        lines += [f"The file did not compile (params {pv}):", f"line {ln}: `{src}`" if src else f"line {ln}",
                  f"error: {rep.get('error')}"]
        if rep.get("hint"):
            lines.append(f"hint: {rep['hint']}")
        lines.append("Fix it (only statements and keys from the reference) and return the complete file.")
        return "\n".join(lines)
    drc = rep["drc"]
    lvs = rep.get("lvs", {})
    lines.append(f"Check result at {pv}: {rep['status']}  (DRC {drc['violations']} errors, LVS "
                 f"{'MATCH' if lvs.get('match') else 'MISMATCH'}, size {rep.get('size_um')} um)")
    cons = _constraints(rep, mode == "ranked")
    if any("FAILED" in c for c in cons):
        lines.append("LAYOUT CONSTRAINTS (measured on your geometry):")
    lines += cons
    if not lvs.get("match", True):
        lines.append(f"LVS vs the reference netlist: {lvs.get('result', '')}; devices layout/reference "
                     f"{lvs.get('devices_layout_vs_ref')}, nets {lvs.get('nets_layout_vs_ref')} (matching dummies "
                     f"are ignored)")
        if mode == "ranked":
            lines.append("  -> keep every device line exactly as given; a net missing a connection usually means a "
                         "route could not be made or a pin was left out")
        lines += ["   | " + x for x in lvs.get("details", [])[:16]]
    if drc["violations"]:
        if mode == "ranked":
            objs = rep.get("objects", {})
            cnt = Counter()
            rules = {}
            for v in drc.get("all", []):
                for o in v.get("objects", {}):
                    if o in ("well", "implant", "boundary", "?"):
                        continue
                    cnt[o] += 1
                    rules.setdefault(o, Counter())[v["rule"]] += 1
            lines.append("DRC errors by the objects involved (most first):")
            for o, n in cnt.most_common(5):
                base = o.split(":")[0] if not o.startswith("route:") else o
                ln = objs.get(o, {}).get("line") or objs.get(o.split("_r")[0], {}).get("line")
                src = code.splitlines()[ln - 1].strip() if ln and ln <= len(code.splitlines()) else ""
                top = ", ".join(f"{r} x{c}" for r, c in rules[o].most_common(2))
                lines.append(f"  {base}" + (f" (line {ln}: `{src}`)" if src else "") + f" - {n} errors: {top}")
            lines.append("  -> objects placed with gap= below the legal minimum, overlapping placements or pattern "
                         "objects too close: use gap=min (default) or a larger gap / vgap")
        else:
            lines.append(f"magic DRC: {drc['violations']} violation(s)")
        for g in drc["by_rule"][:5]:
            ex = g["examples"][0] if g["examples"] else {}
            objs_s = "; ".join(f"{k}:{'/'.join(v)}" for k, v in ex.get("objects", {}).items())
            lines.append(f"  [{g['count']}x] {g['rule']} at {ex.get('box_um')} near {objs_s}")
    for w in rep.get("warnings", [])[:5]:
        lines.append("WARNING " + w[:300])
    lines.append("Fix the first items first (the attached image is your layout). Return the complete corrected file.")
    return "\n".join(lines)
