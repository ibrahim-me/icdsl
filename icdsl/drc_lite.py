"""Fast in-process DRC (KLayout region engine) for agent feedback.

Not a signoff deck: it covers the rules the ICL libraries can violate (width, spacing,
cut sizes, enclosures incl. one-direction rules, gate endcap / extension, contact
to gate, implant / well coverage, minimum area) and reports every violation with
the DSL objects (and source lines) underneath it. Magic remains the authority.
"""
from __future__ import annotations

import klayout.db as kdb

from . import tech as T

PROJ = kdb.Metrics.Projection
EUC = kdb.Metrics.Euclidian


def _region(shapes, layer):
    r = kdb.Region()
    for s in shapes:
        if s.layer == layer:
            r.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
    r.merge()
    return r


def _boxes_of(obj):
    out = []
    if isinstance(obj, kdb.EdgePairs):
        for ep in obj.each():
            out.append(ep.bbox())
    elif isinstance(obj, kdb.Region):
        for p in obj.each():
            out.append(p.bbox())
    elif isinstance(obj, kdb.Edges):
        for e in obj.each():
            out.append(e.bbox())
    return out


def _one_dir(outer, inner, e1):
    """inner shapes whose enclosure by outer is < e1 on two adjacent edges (one-direction rule)."""
    low = outer.enclosing_check(inner, e1, False, PROJ).second_edges()
    corners = low.width_check(1, False, EUC, 100)
    return inner.interacting(corners.polygons(1))


def run(shapes):
    """Return a list of violations: {rule, box (nm), msg}."""
    L = {l: _region(shapes, l) for l in ("nwell", "diff", "tap", "poly", "licon", "npc", "nsdm", "psdm",
                                           "li", "mcon", "m1", "via", "m2", "via2", "m3", "via3", "m4")}
    out = []

    def add(rule, obj, msg):
        for b in _boxes_of(obj):
            out.append({"rule": rule, "box": (b.left, b.bottom, b.right, b.top), "msg": msg})

    # widths / spacings
    for lay, w in (("diff", 150), ("tap", 150), ("poly", 150), ("li", 170), ("m1", 140), ("m2", 140),
                   ("m3", 300), ("m4", 300), ("nwell", 840), ("nsdm", 380), ("psdm", 380), ("npc", 270)):
        add(f"{lay}.width", L[lay].width_check(w), f"{lay} narrower than {w/1000:.3f} um")
    difftap = (L["diff"] + L["tap"]).merged()
    add("difftap.space", difftap.space_check(270), "diff/tap spacing < 0.270 um")
    for lay, s in (("poly", 210), ("licon", 170), ("li", 170), ("mcon", 190), ("m1", 140), ("via", 170),
                   ("m2", 140), ("via2", 200), ("m3", 300), ("via3", 200), ("m4", 300), ("nwell", 1270),
                   ("nsdm", 380), ("psdm", 380), ("npc", 270)):
        add(f"{lay}.space", L[lay].space_check(s), f"{lay} spacing < {s/1000:.3f} um")
    # cut sizes
    for cut, sz in (("licon", 170), ("mcon", 170), ("via", 150), ("via2", 200), ("via3", 200)):
        bad = kdb.Region()
        for p in L[cut].each():
            b = p.bbox()
            if not p.is_box() or b.width() != sz or b.height() != sz:
                bad.insert(p)
        add(f"{cut}.size", bad, f"{cut} must be exactly {sz/1000:.2f} x {sz/1000:.2f} um")
    # contacts: classify licons
    lic_poly = L["licon"].interacting(L["poly"])
    lic_diff = L["licon"].interacting(L["diff"])
    lic_tap = L["licon"].interacting(L["tap"])
    add("licon.17", lic_poly & lic_diff.interacting(L["poly"]) & L["diff"], "licon overlaps both poly and diff")
    add("licon.cover", L["licon"] - L["diff"] - L["tap"] - L["poly"], "licon not on diff, tap or poly")
    add("licon.5a", L["diff"].enclosing_check(lic_diff, 40), "diff enclosure of licon < 0.040 um")
    add("licon.5c", _one_dir(L["diff"], lic_diff - L["poly"], 60), "diff enclosure of licon < 0.060 um on two adjacent sides")
    add("licon.7", _one_dir(L["tap"], lic_tap, 120), "tap enclosure of licon < 0.120 um on two adjacent sides")
    add("licon.8", L["poly"].enclosing_check(lic_poly, 50), "poly enclosure of licon < 0.050 um")
    add("licon.8a", _one_dir(L["poly"], lic_poly, 80), "poly enclosure of licon < 0.080 um on two adjacent sides")
    add("li.cover", L["licon"] - L["li"], "licon not covered by li")
    add("li.5", _one_dir(L["li"], L["licon"], 80), "li enclosure of licon < 0.080 um on two adjacent sides")
    add("ct.4", L["mcon"] - L["li"], "mcon not covered by li")
    add("m1.cover", L["mcon"] - L["m1"], "mcon not covered by met1")
    add("m1.4", L["m1"].enclosing_check(L["mcon"], 30), "met1 enclosure of mcon < 0.030 um")
    add("m1.5", _one_dir(L["m1"], L["mcon"], 60), "met1 enclosure of mcon < 0.060 um on two adjacent sides")
    for m, cut, e0, e1 in (("m1", "via", 55, 85), ("m2", "via", 55, 85), ("m2", "via2", 40, 85),
                           ("m3", "via2", 65, 65), ("m3", "via3", 60, 90), ("m4", "via3", 65, 65)):
        add(f"{m}.cover.{cut}", L[cut] - L[m], f"{cut} not covered by {m}")
        add(f"{m}.enc.{cut}", L[m].enclosing_check(L[cut], e0), f"{m} enclosure of {cut} < {e0/1000:.3f} um")
        if e1 > e0:
            add(f"{m}.enc1.{cut}", _one_dir(L[m], L[cut], e1), f"{m} enclosure of {cut} < {e1/1000:.3f} um on two adjacent sides")
    add("npc.enc", L["npc"].enclosing_check(lic_poly, 100), "npc enclosure of poly licon < 0.100 um")
    add("licon.13", L["npc"].separation_check(lic_diff - L["poly"], 90), "npc closer than 0.090 um to a diff contact")
    # transistors
    gate = L["poly"] & L["diff"]
    add("licon.11", (lic_diff - L["poly"]).separation_check(gate, 55), "diff contact closer than 0.055 um to a gate")
    add("licon.14", (lic_poly - L["diff"]).separation_check(L["diff"], 190), "poly contact closer than 0.190 um to diff")
    add("licon.9", (lic_poly - L["diff"]).separation_check(L["psdm"], 110), "poly contact closer than 0.110 um to psdm")
    for g in gate.each():
        b = g.bbox()
        probe_up = kdb.Region(kdb.Box(b.left, b.top, b.right, b.top + 5))
        vertical = (probe_up - L["diff"]).area() > 0 and (probe_up - L["poly"]).is_empty()
        if vertical:
            caps = [kdb.Box(b.left, b.top, b.right, b.top + 130), kdb.Box(b.left, b.bottom - 130, b.right, b.bottom)]
            exts = [kdb.Box(b.left - 250, b.bottom, b.left, b.top), kdb.Box(b.right, b.bottom, b.right + 250, b.top)]
        else:
            caps = [kdb.Box(b.left - 130, b.bottom, b.left, b.top), kdb.Box(b.right, b.bottom, b.right + 130, b.top)]
            exts = [kdb.Box(b.left, b.bottom - 250, b.right, b.bottom), kdb.Box(b.left, b.top, b.right, b.top + 250)]
        for c in caps:
            if not (kdb.Region(c) - L["poly"]).is_empty():
                add("poly.8", kdb.Region(c), "poly extends less than 0.130 um past the diffusion (gate endcap)")
        for e in exts:
            if not (kdb.Region(e) - L["diff"]).is_empty():
                add("poly.7", kdb.Region(e), "diffusion extends less than 0.250 um past the gate")
    for p in L["poly"].each():                       # poly vs diffusions it does not gate
        pr = kdb.Region(p)
        others = L["diff"].not_interacting(pr)
        if not others.is_empty():
            add("poly.4", pr.separation_check(others, 75), "poly closer than 0.075 um to diffusion")
    add("poly.5", L["poly"].separation_check(L["tap"], 55), "poly closer than 0.055 um to tap")
    # implants and wells
    add("sdm.cover", difftap - L["nsdm"] - L["psdm"], "diff/tap not covered by nsdm or psdm")
    add("sdm.both", difftap & L["nsdm"] & L["psdm"], "diff/tap covered by both nsdm and psdm")
    ndiff, pdiff = L["diff"] & L["nsdm"], L["diff"] & L["psdm"]
    ntap, ptap = L["tap"] & L["nsdm"], L["tap"] & L["psdm"]
    add("nsd.enc", L["nsdm"].enclosing_check(ndiff + ntap, 125), "nsdm enclosure of diff/tap < 0.125 um")
    add("psd.enc", L["psdm"].enclosing_check(pdiff + ptap, 125), "psdm enclosure of diff/tap < 0.125 um")
    add("nwell.pdiff", pdiff - L["nwell"], "p-diffusion outside n-well")
    add("nwell.enc", L["nwell"].enclosing_check(pdiff + ntap, 180), "n-well enclosure of p-diff / n-tap < 0.180 um")
    add("nwell.ndiff", L["nwell"].separation_check(ndiff, 340), "n-diffusion closer than 0.340 um to n-well")
    add("nwell.ndiff_in", ndiff & L["nwell"], "n-diffusion inside n-well")
    add("nwell.ntap", ntap - L["nwell"], "n-tap outside n-well")
    add("nwell.ptap", L["nwell"].separation_check(ptap, 130), "p-tap closer than 0.130 um to n-well")
    # areas
    for lay in ("li", "m1", "m2", "m3", "m4"):
        add(f"{lay}.area", L[lay].with_area(0, T.AREA[lay] - 1, False), f"{lay} area below {T.AREA[lay]/1e6:.4f} um2")
    return out


def attribute(viol, shapes, named=None, margin=10):
    """Attach the DSL objects under each violation box."""
    for v in viol:
        x0, y0, x1, y1 = v["box"]
        hits = []
        for s in shapes:
            r = s.rect
            if r.x0 <= x1 + margin and x0 - margin <= r.x1 and r.y0 <= y1 + margin and y0 - margin <= r.y1:
                tag = s.owner or "?"
                if named and s.owner in named:
                    tag = f"{s.owner} (line {named[s.owner]})"
                if tag not in hits:
                    hits.append(tag)
        v["objects"] = hits[:6]
        v["box_um"] = [round(c / 1000, 3) for c in v["box"]]
    return viol
