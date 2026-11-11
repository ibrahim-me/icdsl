"""Feedback strategies for the benchmark harness.

basic   - the original report (rule list, magic objects near each error, LVS table, image)
ranked  - root causes first:
          * connectivity (opens / shorts / unmatched transistors) named by statement and line
          * DRC errors clustered by the user's statements involved, with the measured gap vs. the
            rule value between the two named shapes, a plain-language reading of the rule and the
            statement(s) that position the offending shape
          * compile errors quoted with the offending source line
"""
from __future__ import annotations

import re
from collections import Counter, defaultdict

import nemotron_stdcells as NS

TEMPLATE = {"vgnd", "vpwr", "vgnd_li", "vpwr_li", "ptap", "ntap", "nwell", "cell"}

# rule id -> plain reading + usual cause in a standard cell
RULE_HELP = {
    "poly.2": "two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; "
              "stagger them vertically (one gate contact higher than the next) or widen the gate pitch",
    "licon.14": "a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in "
                "the empty band between the n and p diffusions, not over a diffusion and not near the tap rows",
    "var.2": "poly over the template n-tap/n-well tap forms a varactor - some poly (a gate or a gate-contact pad) "
             "reaches into the top tap row; keep all poly below ntap.bottom",
    "var.1": "poly over the n-tap (varactor) - keep poly out of the top tap row",
    "var.4": "poly over the n-tap (varactor) - keep poly out of the top tap row",
    "varac.7": "poly over the n-tap (varactor) - keep poly out of the top tap row",
    "licon.10": "a contact is near poly that sits over a tap (varactor) - keep poly out of the tap rows",
    "licon.7": "something overlaps the template tap contacts - keep your shapes out of the tap rows",
    "licon.1": "a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template "
               "contact (often your shape sits on the tap row)",
    "mcon.2": "two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon",
    "mcon.1": "mcon not 0.17 x 0.17 - two mcons overlap",
    "li.3": "two li shapes of different nets closer than 0.17 um",
    "li.c2": "two li shapes closer than 0.14 um",
    "licon.9": "a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the "
               "p row",
    "licon.11": "a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>`"
                " / right_of so the contacts keep their distance, or widen the gap between gates",
    "licon.8": "the poly pad does not enclose the gate contact by 0.05 um - use `enclose <gc> poly by=minx`",
    "licon.8a": "the poly pad must enclose the gate contact by 0.08 um on one axis - `enclose <gc> poly by=minx`",
    "licon.2": "two licons closer than 0.17 um",
    "licon.5a": "diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion",
    "diff/tap.1": "a diffusion strip narrower than 0.15 um",
    "diff/tap.2": "transistor width below 0.42 um",
    "diff/tap.3": "two diffusions closer than 0.27 um",
    "poly.1a": "poly narrower than 0.15 um",
    "poly.4": "poly closer than 0.075 um to a diffusion it does not cross",
    "poly.7": "the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)",
    "poly.8": "the gate must extend 0.13 um beyond the diffusion (end cap)",
    "met1.2": "two met1 shapes closer than 0.14 um",
    "met1.1": "met1 narrower than 0.14 um",
}

KEYWORDS = [("poly contact", "licon"), ("p-diffusion contact", "licon"), ("n-diffusion contact", "licon"),
            ("diffusion contact", "licon"), ("n-tap contact", "licon"), ("contact", "licon"),
            ("local interconnect", "li"), ("metal1", "m1"), ("metal2", "m2"), ("mcon", "mcon"),
            ("varactor", "poly"), ("n-tap", "tap"), ("tap", "tap"), ("poly", "poly"),
            ("diffusion", "diff"), ("gate", "poly"), ("transistor", "diff"), ("nfet", "poly"), ("pmos", "poly")]


def rule_id(rule):
    m = re.search(r"\(([^()]*)\)\s*$", rule)
    rid = m.group(1) if m else rule
    return rid.split("+")[0].strip()


def rule_value(rule):
    m = re.search(r"<\s*([\d.]+)\s*um", rule)
    return float(m.group(1)) if m else None


def rule_layers(rule):
    t = rule.lower().split("(")[0]
    found = []
    for kw, lay in KEYWORDS:
        i = t.find(kw)
        if i >= 0 and lay not in [f[1] for f in found]:
            found.append((i, lay))
            t = t.replace(kw, " " * len(kw), 1)
    found.sort()
    lays = [l for _, l in found]
    if "diff" in lays and "tap" not in lays:
        lays.append("tap")
    return lays


def gap(a, b):
    """Signed gap between two boxes [x0,y0,x1,y1]: >0 separation, <0 overlap depth."""
    dx = max(b[0] - a[2], a[0] - b[2])
    dy = max(b[1] - a[3], a[1] - b[3])
    if dx >= 0 or dy >= 0:
        return round(max(dx, dy), 3)
    return round(max(dx, dy), 3)


def statements(code):
    out = {}
    for i, line in enumerate(code.splitlines(), 1):
        m = re.match(r"\s*([A-Za-z_]\w*)\s*=\s*(.*)$", line)
        if m:
            out[m.group(1)] = (i, line.strip())
    return out


def refs(text):
    body = text.split("=", 1)[1] if "=" in text else text
    body = body.split("#")[0]
    return set(re.findall(r"\b([A-Za-z_]\w*)\b", body))


WELLS = {"nwell", "nsdm", "psdm", "npc"}


def rule_kind(rule):
    t = rule.lower()
    if "overlap of" in t or "overhang" in t or "enclos" in t or "extension" in t:
        return "enclosure"
    if "width" in t or "length" in t or " size" in t or "must be exactly" in t or "must not contain" in t:
        return "size"
    return "spacing"


def move_hint(root, a, b, amount, text, line):
    """Concrete edit that moves `root` (whose shape a must clear b by `amount` more)."""
    amount = round(amount + 0.004, 2)
    side_by_side = min(a[3], b[3]) - max(a[1], b[1]) > 0      # y ranges overlap -> separate in x
    if side_by_side:
        axis, d = "x", ("left" if (a[0] + a[2]) < (b[0] + b[2]) else "right")
        keys = ("cx", "left", "right")
    else:
        axis, d = "y", ("down" if (a[1] + a[3]) < (b[1] + b[3]) else "up")
        keys = ("cy", "bottom", "top")
    sign = "-" if d in ("left", "down") else "+"
    for k in keys:
        m = re.search(rf"\b{k}=(\([^()]*(?:\([^()]*\)[^()]*)*\)|[^\s]+)", text)
        if m:
            v = m.group(1)
            return (f"one fix: move {root} {d} by {amount} um - line {line}: `{k}={v}` -> "
                    f"`{k}=({v.strip('()') if v.startswith('(') and v.count('(') == 1 else v} {sign} {amount})` "
                    f"(or move the other shape the opposite way)")
    return f"one fix: move {root} {d} by {amount} um (or move the other shape the opposite way)"


def drc_ranked(rep, code, k_roots=4):
    objs = rep.get("objects", {})
    st = statements(code)
    src = code.splitlines()
    allv = rep["drc"].get("all") or [dict(ex, rule=g["rule"]) for g in rep["drc"]["by_rule"] for ex in g["examples"]]

    def text_of(o):
        ln = objs.get(o, {}).get("line") or 0
        return src[ln - 1].strip() if 0 < ln <= len(src) else ""

    # credit derived shapes to the object they are built from (gp = enclose gc -> gc)
    def root_of(o):
        r, seen = o, set()
        while r in st and r not in seen:
            seen.add(r)
            m = (re.match(r"\s*\w+\s*=\s*(enclose|copy|mirror)\s+\[?(\w+)", st[r][1]) or
                 re.match(r"\s*\w+\s*=\s*(contact)\s+\w+\s+in=(\w+)", st[r][1]))
            if m and m.group(2) in objs and objs[m.group(2)].get("line"):
                r = m.group(2)
            else:
                break
        return r

    per_root = Counter()
    rules_of = defaultdict(Counter)
    members = defaultdict(set)
    pairs = defaultdict(list)
    for v in allv:
        rule = v["rule"]
        rid = rule_id(rule)
        owners = v.get("objects", {})
        wells_rule = any(w in rule.lower() for w in ("well", "implant", "nsdm", "psdm", "npc"))
        user = [o for o in owners if o in objs and objs[o].get("line")
                and (wells_rule or objs[o]["layer"] not in WELLS)]
        if not user:
            continue
        roots = set()
        for o in user:
            r = root_of(o)
            roots.add(r)
            members[r].add(o)
        for r in roots:
            per_root[r] += 1
            rules_of[r][rid] += 1
        kind = rule_kind(rule)
        if kind != "spacing":
            continue
        lays = rule_layers(rule)
        need = rule_value(rule)
        if lays:
            A = {lays[0]}
            B = set(lays[1:]) or set(A)
            for S in (A, B):
                if "diff" in S:
                    S.add("tap")
        else:
            A = B = None
        best = None
        vb = v["box_um"]
        reach = (need or 0.2) + 0.02
        near = [o for o in objs if gap(objs[o]["bbox_um"], vb) <= reach
                and (wells_rule or objs[o]["layer"] not in WELLS)]
        cands = [o for o in near if objs[o].get("line")]
        for o in cands:
            ol = {objs[o]["layer"]}
            for p in near:
                if p == o:
                    continue
                pls = {objs[p]["layer"]}
                if A and not ((ol & A and pls & B) or (ol & B and pls & A)):
                    continue
                if objs[p].get("net") and objs[p].get("net") == objs[o].get("net"):
                    continue
                g = gap(objs[o]["bbox_um"], objs[p]["bbox_um"])
                if need is not None and g >= need:
                    continue
                if root_of(p) == root_of(o):
                    continue                # a shape and its own pad / enclosure
                if ol == pls and g <= 0:
                    continue                # same layer and touching = one merged shape
                if best is None or g < best[2]:
                    best = (o, p, g)
        if best:
            pairs[root_of(best[0])].append((rid, best[0], best[1], best[2], need))
            if objs[best[1]].get("line") and root_of(best[1]) != root_of(best[0]):
                pairs[root_of(best[1])].append((rid, best[1], best[0], best[2], need))
    if not per_root:
        return []
    out = []
    total = len(allv)
    for r, n in per_root.most_common(k_roots):
        line = objs.get(r, {}).get("line")
        others = sorted(members[r] - {r})
        rules = ", ".join(f"{k} x{c}" for k, c in rules_of[r].most_common(4))
        out.append(f"* {r} (line {line}: `{text_of(r)}`)" + (f" and shapes built from it ({', '.join(others)})"
                                                             if others else "") + f" - in {n} of {total} errors: {rules}")
        b = objs.get(r, {}).get("bbox_um")
        if b:
            out.append(f"    {r} spans x {b[0]:.3f}..{b[2]:.3f}, y {b[1]:.3f}..{b[3]:.3f} um")
        seen = set()
        for (rid, m, other, g, need) in pairs.get(r, []):
            key = (m, other, rid)
            if key in seen:
                continue
            seen.add(key)
            ob = objs[other]["bbox_um"]
            who = f"template {other}" if not objs[other].get("line") else f"{other} (line {objs[other]['line']})"
            rel = f"they overlap by {-g:.3f} um" if g < 0 else ("they touch" if g == 0 else f"gap {g:.3f} um")
            more = f", rule needs >= {need} um (short by {need - g:.3f} um)" if need is not None else ""
            out.append(f"    {rid}: {m} [{objs[m]['layer']}] vs {who} [{objs[other]['layer']} x {ob[0]:.3f}..{ob[2]:.3f}"
                       f", y {ob[1]:.3f}..{ob[3]:.3f}]: {rel}{more}")
            if need is not None and len(seen) == 1:
                hint = move_hint(r, objs[m]["bbox_um"], ob, need - g, text_of(r), objs[r].get("line"))
                if hint:
                    out.append("    " + hint)
            if len(seen) >= 3:
                break
        t = text_of(r)
        if t:
            used = [x for x in refs(t) if x in st and x != r and x not in objs]
            for x in used[:2]:
                out.append(f"    its position uses {x} (line {st[x][0]}: `{st[x][1]}`)")
        for k in [k for k, _ in rules_of[r].most_common(3) if k in RULE_HELP][:2]:
            out.append(f"    rule {k}: {RULE_HELP[k]}")
    return out


def make(rep, pv, mode, code, prev_code=None):
    if mode == "basic":
        return NS.feedback(rep, pv)
    if mode != "ranked":
        raise NotImplementedError(mode)
    head = []
    if prev_code is not None and prev_code.strip() == code.strip():
        head.append("NOTE: this file is identical to your previous attempt - the same errors come back. "
                    "Change the statements named below.")
    if rep.get("status") == "ERROR":
        ln = rep.get("line") or 0
        src = code.splitlines()[ln - 1].strip() if 0 < ln <= len(code.splitlines()) else ""
        msg = [f"The file did not compile (params {pv}):", f"line {ln}: `{src}`", f"error: {rep.get('error')}"]
        if rep.get("hint"):
            msg.append(f"hint: {rep.get('hint')}")
        msg.append("Fix it (only use statements and keys from the reference) and return the complete file.")
        return "\n".join(head + msg)
    lines = head + [f"Check result at {pv}: {rep['status']}  (DRC {rep['drc']['violations']} errors, LVS "
                    f"{'MATCH' if rep.get('lvs', {}).get('match') else 'MISMATCH'})"]
    rf = rep.get("route_failed") or []
    if rf:
        lines.append("ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):")
        for f in rf:
            lines.append(f"  line {f['line']}: {f['error']}")
        lines.append("  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of "
                     "other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the "
                     "blocking met1.")
    conn = rep.get("connectivity") or []
    lvs_ok = rep.get("lvs", {}).get("match", False)
    if conn and not lvs_ok:
        lines.append("CONNECTIVITY (fix these first - they are why LVS fails):")
        lines += ["  " + c for c in conn]
    elif not lvs_ok and "lvs" in rep:
        lines.append("LVS mismatch (netgen): " + rep["lvs"].get("result", ""))
        nets = rep["lvs"].get("nets_layout_vs_ref") or [0, 0]
        devs = rep["lvs"].get("devices_layout_vs_ref") or [0, 0]
        lines.append(f"  layout/reference devices {devs}, nets {nets}")
    if rep["drc"]["violations"]:
        lines.append("DRC root causes (ranked; by the statements in your file):")
        lines += drc_ranked(rep, code) or ["  (all errors are in template shapes - something of yours overlaps the "
                                           "rails or tap rows)"]
    for w in rep.get("warnings", [])[:6]:
        if "fast pre-check" not in w and "ROUTING FAILED" not in w:
            lines.append("WARNING " + w[:300])
    lines.append("Fix the first items first (the attached image is your layout, DRC errors boxed in red). "
                 "Return the complete corrected file.")
    return "\n".join(lines)


def images(rep, mode, out_dir, k):
    if mode == "none" or not rep:
        return []
    if mode == "full":
        p = NS.image_part(rep.get("image"))
        return [p] if p else []
    raise NotImplementedError(mode)


def retrieved_examples(cell, library, k):
    import tasks
    import bench_harness as BH
    near = tasks.similar(cell, BH.BENCH["cells"], k)
    out = []
    for c in near:
        if c["name"] in library:
            out.append(f"\n\nVerified example: `{c['name']}` ({c['function']}), DRC/LVS clean over the whole sweep:\n"
                       f"```icl\n{library[c['name']]}```")
    return "".join(out)
