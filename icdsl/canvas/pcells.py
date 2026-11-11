"""Parameterised helpers built only from the Tech data, so the same call works on every PDK:
via stacks, MOS strips, taps, guard rings, resistors, MIM capacitors. They are conveniences, not a
fence: everything they draw can also be drawn shape by shape (rect / polygon on any layer) and
declared with cell.device(...).
"""
from __future__ import annotations

import math

from .core import Cell, Rect, Group, Geo, CanvasError, _src
from .tech import TechError


def _even(v, g):
    """round an nm value up to a multiple of 2 grids (so its half stays on grid)."""
    return int(math.ceil(v / (2 * g))) * 2 * g


def _cut_lo(size, g):
    """Distance (nm) from an on-grid centre to the low edge of a cut of this size, the cut kept on the
    grid: half the size, rounded up to the grid when the size is an odd number of grids (65 nm contacts
    on a 5 nm grid). The high edge is at size - _cut_lo. via() places its cuts the same way."""
    return -((-(size // 2)) // g * g)


def _up(v, g):
    return int(math.ceil(v / g - 1e-9)) * g


def _grow_area(t, layer, x0, y0, x1, y1, axis):
    """Grow a pad symmetrically along `axis` until it has the layer's minimum area and width."""
    g = t.grid
    wmin = t.nm(t.width(layer))
    if x1 - x0 < wmin:
        d = _even(wmin - (x1 - x0), g) // 2
        x0, x1 = x0 - d, x1 + d
    if y1 - y0 < wmin:
        d = _even(wmin - (y1 - y0), g) // 2
        y0, y1 = y0 - d, y1 + d
    a = t.area(layer) * 1e6
    if a and (x1 - x0) * (y1 - y0) < a - 1e-6:
        if axis == "v":
            need = _even(a / (x1 - x0) - (y1 - y0), g) // 2
            y0, y1 = y0 - need, y1 + need
        else:
            need = _even(a / (y1 - y0) - (x1 - x0), g) // 2
            x0, x1 = x0 - need, x1 + need
    return x0, y0, x1, y1


class Via(Group):
    """Handle of a via stack: .lower / .upper pads (Rect), .pads[layer], .cuts."""

    def __init__(self, pads, cuts):
        self.pads, self.cuts = pads, cuts
        super().__init__(list(pads.values()) + cuts)
        ks = list(pads)
        self.lower, self.upper = pads[ks[0]], pads[ks[-1]]


def via(self, frm, to, at=None, nx=1, ny=1, net=None, dir="v", inside=None, bottom_pad=None, top_dir=None):
    """Cut stack between two layers, pads included (enclosure and minimum area from the PDK data).
    frm / to: conductors of the stack, or a device layer (poly, diffusion, tap) as the lower end.
    at = centre (x, y) or a shape (its centre); nx, ny = cuts per level; dir = 'v' | 'h': the direction
    in which pads extend (asymmetric enclosure, minimum-area growth). top_dir overrides it for the
    top pad. The pad on a device layer is drawn for poly, not for diffusion/tap (draw your own)."""
    t = self.tech
    g = t.grid
    frm, to = t.lname(frm), t.lname(to)
    src = _src()
    levels = []
    lower_dev = None
    if frm not in t.stack or to not in t.stack:
        dev, other = (frm, to) if frm not in t.stack else (to, frm)
        if other not in t.stack:
            raise CanvasError(f"via: {other!r} is not a conductor of {t.name}", "stack: " + " < ".join(t.stack))
        cut = next((c for c, d in t.cuts.items()
                    if dev in ([d["lower"]] if isinstance(d["lower"], str) else d["lower"])), None)
        if cut is None:
            raise CanvasError(f"via: no cut lands on {dev!r} in {t.name}")
        up = t.cuts[cut]["upper"]
        levels.append((dev, cut, up))
        levels += t.cut_stack(up, other)
        lower_dev = dev
    else:
        levels = t.cut_stack(frm, to)
        if not levels:
            raise CanvasError(f"via: {frm} and {to} are the same layer",
                              f"on {t.name} the conductors are " + " < ".join(t.stack) + " (tech.c0 is the first); "
                              "a contact to a device is via('poly' | diffusion layer, tech.c0)")
    if inside is not None and at is None:
        at = inside
    if at is None:
        raise CanvasError("via: at=(x, y) or at=<shape> needed")
    cx, cy = self._pt(at)
    pads, cuts = {}, []
    boxes = {}     # layer -> bbox needed

    def need(layer, b):
        if layer in boxes:
            o = boxes[layer]
            b = (min(o[0], b[0]), min(o[1], b[1]), max(o[2], b[2]), max(o[3], b[3]))
        boxes[layer] = b

    top_layer = levels[-1][2]
    for (lo, cut, hi) in levels:
        s, sp = t.nm(t.cuts[cut]["size"]), t.nm(t.cuts[cut]["space"])
        tw, th = nx * s + (nx - 1) * sp, ny * s + (ny - 1) * sp
        x0 = (cx - tw // 2) // g * g
        y0 = (cy - th // 2) // g * g
        for i in range(nx):
            for j in range(ny):
                r = Rect(cut, x0 + i * (s + sp), y0 + j * (s + sp), x0 + i * (s + sp) + s, y0 + j * (s + sp) + s,
                         net, src)
                self.shapes.append(r)
                cuts.append(r)
        for layer in (lo, hi):
            d = (top_dir or dir) if layer == top_layer else dir
            ea, e2 = (t.nm(v) for v in t.enc(layer, cut))
            e2 = max(ea, e2)
            ex, ey = (ea, e2) if d == "v" else (e2, ea)
            need(layer, (x0 - ex, y0 - ey, x0 + tw + ex, y0 + th + ey))
        if lo == lower_dev:
            for (xl, e) in t.d.get("contact_extra", {}).get(lo, []):
                e = t.nm(e)
                self.shapes.append(Rect(xl, x0 - e, y0 - e, x0 + tw + e, y0 + th + e, None, src))
    for layer, b in boxes.items():
        if layer == lower_dev:
            draw = bottom_pad if bottom_pad is not None else (layer == t.roles.get("poly"))
            if not draw:
                continue
            r = Rect(layer, *b, net, src)
        else:
            if layer == levels[0][0] and bottom_pad is False:
                continue
            d = (top_dir or dir) if layer == top_layer else dir
            r = Rect(layer, *_grow_area(t, layer, *b, d), net, src)
        self.shapes.append(r)
        pads[layer] = r
    if not pads:
        pads["_"] = Rect(None, cx, cy, cx, cy)
    return Via(pads, cuts)


def via_size(self, frm, to, **kw):
    """Size of the pads `via(frm, to, **kw)` would draw, nothing drawn: {layer: (w, h)} in um.
    Use it to size the bars / straps a via will land on."""
    t = self.tech
    c = Cell("__via_size__", t)
    try:
        c.via(frm, to, at=(0, 0), **kw)
        out = {}
        for s in c.shapes:
            w, h = out.get(s.layer, (0, 0))
            out[s.layer] = (max(w, (s.x1 - s.x0) / 1000.0), max(h, (s.y1 - s.y0) / 1000.0))
        return out
    finally:
        Cell.registry.pop("__via_size__", None)


class Mos(Group):
    """Handle of a MOS strip. .diff, .gates[i] (poly Rect), .sd[i] (c0 strap Rect or None),
    .gx[i] gate centre x (um), .sx[i] source/drain column centre x (um), .implant, .well"""

    def g(self, i=0):
        return self.gates[i]

    def s(self, i=0):
        return self.sd[i]


def mos(self, kind, w, l=None, nf=1, at=(0, 0), gates="G", sd=("S", "D"), bulk=None, name=None,
        contacts=True, pitch=None, gate_ext=0.0, implant=True, well=True, strap_h=None, origin="diff"):
    """A strip of nf transistors sharing one diffusion; gates are vertical poly stripes.
    kind: a 'mos' recipe of the PDK (tech.describe()), e.g. 'nmos', 'pmos'.
    w, l: finger width / gate length (um); at = lower-left corner of the diffusion.
    gates: one net or a list of nf nets. sd: nf+1 nets left to right, or a (S, D) pair that alternates.
    contacts: True, or a list of nf+1 booleans (False = no contact column there, e.g. inside a stack).
    pitch: gate pitch (default: the minimum that fits a contact column between gates); columns sit
    midway between gates, the end columns half a pitch outside the end gates.
    origin='col': at is the centre of the first source/drain column instead of the diffusion corner.
    gate_ext: extra poly past the end cap, um, or a (bottom, top) pair.
    The devices are recorded for the reference netlist (drain = right column of each finger).
    Returns a Mos handle; connect to .sd[i] (c0 straps) and .gates[i] (poly)."""
    t = self.tech
    g = t.grid
    rec = t.device(kind)
    if rec.get("type") != "mos":
        raise CanvasError(f"{kind!r} is not a MOS recipe of {t.name}")
    src = _src()
    l = rec["lmin"] if l is None else l
    if l < rec["lmin"] - 1e-9 or w < rec["wmin"] - 1e-9:
        raise CanvasError(f"{kind}: w={w} l={l} below the minimum (w >= {rec['wmin']}, l >= {rec['lmin']})")
    W, L = t.nm(w), t.nm(l)
    poly, cut, c0 = t.roles["poly"], t.roles["contact"], t.c0
    diff = rec["diff"]
    cs, csp = t.nm(t.cuts[cut]["size"]), t.nm(t.cuts[cut]["space"])
    cg = t.nm(t.rule("gate_contact_space"))
    ea, e2 = (t.nm(v) for v in t.enc(diff, cut))
    e2 = max(ea, e2)
    endcap = t.nm(t.rule("poly_endcap"))
    dext = t.nm(t.rule("diff_ext_gate"))
    gates = [gates] * nf if isinstance(gates, str) else list(gates)
    sd = list(sd)
    if len(sd) == 2 and nf > 1:
        sd = [sd[i % 2] for i in range(nf + 1)]
    if len(gates) != nf or len(sd) != nf + 1:
        raise CanvasError(f"{kind}: nf={nf} needs {nf} gate net(s) and {nf + 1} source/drain nets "
                          f"(got {len(gates)} and {len(sd)})")
    cont = [contacts] * (nf + 1) if isinstance(contacts, bool) else list(contacts)
    if len(cont) != nf + 1:
        raise CanvasError(f"{kind}: contacts= needs {nf + 1} entries")
    hl = _cut_lo(cs, g)                      # column centre to the contact's left edge / right edge
    hr = cs - hl
    pmin = L + 2 * cg + 2 * max(hl, hr)
    P = max(pmin, t.nm(pitch) if pitch else 0, L + t.nm(t.rule("gate_space")))
    if (P - L) % (2 * g):
        P += g
    x, y = self._pt(at)
    half = (P - L) // 2                      # gate edge to the centre of the neighbouring column
    E0 = max(half + hl + ea, dext) if cont[0] else dext
    E1 = max(half + hr + ea, dext) if cont[-1] else dext
    if origin == "col":                      # at = centre of the first source/drain column
        x = x - (E0 - half)
    gx0 = [x + E0 + i * P for i in range(nf)]
    x1 = gx0[-1] + L + E1
    d = Rect(diff, x, y, x1, y + W, None, src)
    self.shapes.append(d)
    ge = gate_ext if isinstance(gate_ext, (tuple, list)) else (gate_ext, gate_ext)
    glo, ghi = y - endcap - t.nm(ge[0]), y + W + endcap + t.nm(ge[1])
    grects = []
    for i in range(nf):
        r = Rect(poly, gx0[i], glo, gx0[i] + L, ghi, gates[i], src)
        self.shapes.append(r)
        grects.append(r)
        for (xl, e) in rec.get("gate_extra", []):
            e = t.nm(e)
            self.shapes.append(Rect(xl, gx0[i] - e, y - e, gx0[i] + L + e, y + W + e, None, src))
    # source/drain columns
    cols = [gx0[0] - half + i * P for i in range(nf + 1)]
    n = max(1, (W - 2 * e2 + csp) // (cs + csp))
    if any(cont) and W < cs + 2 * ea:
        raise CanvasError(f"{kind}: w={w} is too narrow for a contact ({(cs + 2 * ea) / 1000} um needed)",
                          "use contacts=False columns or draw a wider contact landing by hand")
    ch = n * cs + (n - 1) * csp
    cy0 = y + (W - ch) // 2 // g * g
    sa, s2 = (t.nm(v) for v in t.enc(c0, cut))
    s2 = max(sa, s2)
    sw = max(t.nm(t.width(c0)), cs + 2 * sa)
    if (sw - cs) % (2 * g):
        sw += g
    straps = []
    for i, cx in enumerate(cols):
        if not cont[i]:
            straps.append(None)
            continue
        for j in range(n):
            self.shapes.append(Rect(cut, cx - hl, cy0 + j * (cs + csp), cx - hl + cs,
                                    cy0 + j * (cs + csp) + cs, sd[i], src))
        sx0 = cx - hl - (sw - cs) // 2
        b = (sx0, cy0 - s2, sx0 + sw, cy0 + ch + s2)
        if strap_h is not None:
            hh = t.nm(strap_h)
            if hh > b[3] - b[1]:
                dlt = _even(hh - (b[3] - b[1]), g) // 2
                b = (b[0], b[1] - dlt, b[2], b[3] + dlt)
        b = _grow_area(t, c0, *b, "v")
        r = Rect(c0, *b, sd[i], src)
        self.shapes.append(r)
        straps.append(r)
    imp = wl = None
    if implant and rec.get("implant"):
        e = t.nm(t.enc(rec["implant"], diff)[0])
        ey = max(e, t.nm(rec.get("implant_gate_ext", 0)) + endcap * 0)
        b = _grow_area(t, rec["implant"], x - e, y - ey, x1 + e, y + W + ey, "v")
        imp = Rect(rec["implant"], *b, None, src)
        self.shapes.append(imp)
    bulk = bulk or rec.get("bulk")
    if well and rec.get("well"):
        e = t.nm(t.enc(rec["well"], diff)[0])
        wl = Rect(rec["well"], x - e, y - e, x1 + e, y + W + e, bulk, src)
        self.shapes.append(wl)
    name = name or f"M{len(self.devices)}"
    for i in range(nf):
        self.device(f"{name}_{i}" if nf > 1 else name, rec["model"], [sd[i + 1], gates[i], sd[i], bulk],
                    prefix=rec.get("spice_prefix", "X"), w=W / 1000.0, l=L / 1000.0)
    h = Mos([d] + grects + [s for s in straps if s] + [q for q in (imp,) if q])
    h.diff, h.gates, h.sd, h.implant, h.well = d, grects, straps, imp, wl
    h.gx = [(a + L / 2) / 1000.0 for a in gx0]
    h.sx = [c / 1000.0 for c in cols]
    h.pitch, h.kind, h.nets_sd, h.nets_g = P / 1000.0, kind, sd, gates
    return h


class Tap(Group):
    """Handle of a tap: .diff, .strap (c0 Rect), .implant, .well"""


def tap(self, kind, x0=None, y0=None, x1=None, y1=None, net=None, at=None, w=None, h=None, well=True,
        implant=True, _inset=(0, 0)):
    """Substrate / well tie filled with contacts. kind: 'ptap' | 'ntap' (PDK recipes).
    Region by corners (x0, y0, x1, y1) or at=(x, y) lower-left + w, h (um). The c0 strap covers it."""
    t = self.tech
    g = t.grid
    rec = t.device(kind)
    if rec.get("type") != "tap":
        raise CanvasError(f"{kind!r} is not a tap recipe of {t.name}")
    src = _src()
    cut, c0, lay = t.roles["contact"], t.c0, rec["diff"]
    cs, csp = t.nm(t.cuts[cut]["size"]), t.nm(t.cuts[cut]["space"])
    ea, e2 = (t.nm(v) for v in t.enc(lay, cut))
    e2 = max(ea, e2)
    if at is not None:
        ax, ay = self._pt(at)
        bx0, by0 = ax, ay
        bx1 = ax + (t.nm(w) if w else cs + 2 * e2)
        by1 = ay + (t.nm(h) if h else cs + 2 * e2)
    else:
        if None in (x0, y0, x1, y1):
            raise CanvasError("tap: give x0, y0, x1, y1 or at= with w=, h=")
        bx0, by0, bx1, by1 = t.nm(x0), t.nm(y0), t.nm(x1), t.nm(y1)
    Wd, Hd = bx1 - bx0, by1 - by0
    horiz = Wd >= Hd
    exx, eyy = (e2, ea) if horiz else (ea, e2)
    if Wd < cs + 2 * exx or Hd < cs + 2 * eyy:
        raise CanvasError(f"{kind}: region {Wd / 1000:g} x {Hd / 1000:g} um is too small for a contact "
                          f"(needs {(cs + 2 * exx) / 1000:g} x {(cs + 2 * eyy) / 1000:g})")
    d = Rect(lay, bx0, by0, bx1, by1, None, src)
    self.shapes.append(d)
    nx = max(1, (Wd - 2 * max(exx, _inset[0]) + csp) // (cs + csp))
    ny = max(1, (Hd - 2 * max(eyy, _inset[1]) + csp) // (cs + csp))
    tw, th = nx * cs + (nx - 1) * csp, ny * cs + (ny - 1) * csp
    cx0 = bx0 + (Wd - tw) // 2 // g * g
    cy0 = by0 + (Hd - th) // 2 // g * g
    for i in range(nx):
        for j in range(ny):
            self.shapes.append(Rect(cut, cx0 + i * (cs + csp), cy0 + j * (cs + csp), cx0 + i * (cs + csp) + cs,
                                    cy0 + j * (cs + csp) + cs, net, src))
    sa, s2 = (t.nm(v) for v in t.enc(c0, cut))
    s2 = max(sa, s2)
    sx, sy = (s2, sa) if horiz else (sa, s2)
    b = (min(bx0, cx0 - sx), min(by0, cy0 - sy), max(bx1, cx0 + tw + sx), max(by1, cy0 + th + sy))
    b = _grow_area(t, c0, *b, "h" if horiz else "v")
    st = Rect(c0, *b, net, src)
    self.shapes.append(st)
    imp = wl = None
    if implant and rec.get("implant"):
        e = t.nm(t.enc(rec["implant"], lay)[0])
        b = _grow_area(t, rec["implant"], bx0 - e, by0 - e, bx1 + e, by1 + e, "h" if horiz else "v")
        imp = Rect(rec["implant"], *b, None, src)
        self.shapes.append(imp)
    if well and rec.get("well"):
        e = t.nm(rec["well_enc"]) if "well_enc" in rec else t.nm(t.enc(rec["well"], lay)[0])
        wl = Rect(rec["well"], bx0 - e, by0 - e, bx1 + e, by1 + e, net, src)
        self.shapes.append(wl)
    hnd = Tap([d, st] + [q for q in (imp,) if q])
    hnd.diff, hnd.strap, hnd.implant, hnd.well = d, st, imp, wl
    return hnd


def guard_ring(self, kind, around, space=None, width=None, net=None, well=True):
    """Closed tap ring around a box / shape / list of shapes. kind 'ptap' | 'ntap'. space = distance
    from the contents to the ring's inner edge (um), width = ring width. A ring whose recipe
    has a well (n-tap ring; p-tap ring on a PDK with a drawn p-well) fills its interior with that well;
    well=False leaves the well to you (needed when the contents sit in the other well). Returns a Group with .inner / .outer boxes (um) and .straps (c0, a closed ring)."""
    t = self.tech
    rec = t.device(kind)
    cut = t.roles["contact"]
    cs = t.cuts[cut]["size"]
    csn = t.nm(t.cuts[cut]["space"])
    e2 = max(t.enc(rec["diff"], cut))
    if width is None:                       # a contact with its enclosure, at least the minimum widths
        width = max(t.snap(cs + 2 * e2), t.width(rec["diff"]), t.width(t.c0))
    if isinstance(around, (list, tuple)) and around and isinstance(around[0], Geo):
        around = Group(list(around))
    b = around.bbox if isinstance(around, Geo) else tuple(around)
    if space is None:
        space = max(t.space(rec["diff"]), t.enc(rec["implant"], rec["diff"])[0] * 2 + 0.02, 0.3)
    ix0, iy0, ix1, iy1 = (t.snap(b[0] - space), t.snap(b[1] - space), t.snap(b[2] + space), t.snap(b[3] + space))
    ox0, oy0, ox1, oy1 = ix0 - width, iy0 - width, ix1 + width, iy1 + width
    parts = [
        tap(self, kind, ox0, oy0, ox1, iy0, net=net, well=False),
        tap(self, kind, ox0, iy1, ox1, oy1, net=net, well=False),
        tap(self, kind, ox0, iy0, ix0, iy1, net=net, well=False, _inset=(0, csn)),
        tap(self, kind, ix1, iy0, ox1, iy1, net=net, well=False, _inset=(0, csn)),
    ]
    grp = Group(parts)
    if well and rec.get("well"):
        e = rec["well_enc"] if "well_enc" in rec else t.enc(rec["well"], rec["diff"])[0]
        grp.well = self.rect(rec["well"], x0=ox0 - e, y0=oy0 - e, x1=ox1 + e, y1=oy1 + e, net=net)
    grp.inner, grp.outer = (ix0, iy0, ix1, iy1), (ox0, oy0, ox1, oy1)
    grp.straps = [p.strap for p in parts]
    grp.bottom_bar, grp.top_bar, grp.left_bar, grp.right_bar = parts
    return grp


class TwoTerm(Group):
    """Handle of a two-terminal device: .a / .b terminal pads (c0 or metal Rects), .body"""


def resistor(self, kind, w, l, at=(0, 0), nets=("A", "B"), bulk=None, name=None, orient="h"):
    """Strip resistor from a 'res' recipe (e.g. 'res_poly'): body w x l (um) with a contacted head at
    each end; at = lower-left of the body. Terminals: handle.a / handle.b (pads on the first conductor).
    The device is recorded for LVS with the PDK's model name."""
    t = self.tech
    g = t.grid
    rec = t.device(kind)
    if rec.get("type") != "res":
        raise CanvasError(f"{kind!r} is not a resistor recipe of {t.name}")
    if w < rec["wmin"] - 1e-9 or l < rec["lmin"] - 1e-9:
        raise CanvasError(f"{kind}: w >= {rec['wmin']} and l >= {rec['lmin']} needed")
    src = _src()
    body, cut = rec["body"], t.roles["contact"]
    cs, csp = t.nm(t.cuts[cut]["size"]), t.nm(t.cuts[cut]["space"])
    ea, e2 = (t.nm(v) for v in t.enc(body, cut))
    e2 = max(ea, e2)
    W, L = t.nm(w), t.nm(l)
    hs = t.nm(rec.get("head_space", 0.0))          # body end to the first contact
    head = hs + cs + e2
    x, y = self._pt(at)
    horiz = orient == "h"
    n = max(1, (W - 2 * ea + csp) // (cs + csp))
    span = n * cs + (n - 1) * csp
    pads = []

    def R(layer, a0, b0, a1, b1, net=None):
        """rect in (along, across) coordinates"""
        r = Rect(layer, x + a0, y + b0, x + a1, y + b1, net, src) if horiz else \
            Rect(layer, x + b0, y + a0, x + b1, y + a1, net, src)
        self.shapes.append(r)
        return r

    bd = R(body, -head, 0, L + head, W)
    for (ml, e) in rec.get("markers", []):
        e = t.nm(e)
        R(ml, 0, -e, L, W + e)
    for (ml, ea_, ec) in rec.get("covers", []):       # layers over the whole device: (layer, along enc, across enc)
        R(ml, -head - t.nm(ea_), -t.nm(ec), L + head + t.nm(ea_), W + t.nm(ec))
    c0 = t.c0
    sa, s2 = (t.nm(v) for v in t.enc(c0, cut))
    s2 = max(sa, s2)
    off = (W - span) // 2 // g * g
    for k, (a0, net) in enumerate(((-hs - cs, nets[0]), (L + hs, nets[1]))):
        for j in range(n):
            R(cut, a0, off + j * (cs + csp), a0 + cs, off + j * (cs + csp) + cs, net)
        for (xl, e) in t.d.get("contact_extra", {}).get(body, []):
            e = t.nm(e)
            R(xl, a0 - e, off - e, a0 + cs + e, off + span + e)
        b = (a0 - sa, off - s2, a0 + cs + sa, off + span + s2)
        if (b[2] - b[0]) < t.nm(t.width(c0)):
            dlt = _even(t.nm(t.width(c0)) - (b[2] - b[0]), g) // 2
            b = (b[0] - dlt, b[1], b[2] + dlt, b[3])
        a = t.area(c0) * 1e6
        if a and (b[2] - b[0]) * (b[3] - b[1]) < a:
            dlt = _even(a / (b[2] - b[0]) - (b[3] - b[1]), g) // 2
            b = (b[0], b[1] - dlt, b[2], b[3] + dlt)
        pads.append(R(c0, *b, net))
    bulk = bulk or rec.get("bulk")
    nodes = [nets[0], nets[1]] + ([bulk] if rec.get("terminals", 2) == 3 else [])
    pm = rec.get("params", {})
    self.device(name or f"R{len(self.devices)}", rec["model"], nodes,
                **{pm.get("w", "w"): W / 1000.0, pm.get("l", "l"): L / 1000.0})
    h = TwoTerm([bd] + pads)
    h.a, h.b, h.body = pads[0], pads[1], bd
    return h


def capacitor(self, kind, w, h, at=(0, 0), nets=("TOP", "BOT"), name=None):
    """MIM capacitor from a 'mim' recipe: plate w x h um, at = lower-left of the plate layer.
    handle.top_pad (= .a) = top-metal pad over the plate; handle.bottom_plate = the whole bottom-plate
    metal; handle.bottom_pad (= .b) = its left margin outside the plate: put the port / label and your
    own bottom-metal wires there (a label under the plate does not name the bottom net)."""
    t = self.tech
    rec = t.device(kind)
    if rec.get("type") != "mim":
        raise CanvasError(f"{kind!r} is not a MIM recipe of {t.name}")
    src = _src()
    W, H = t.nm(w), t.nm(h)
    if min(w, h) < rec["wmin"] - 1e-9:
        raise CanvasError(f"{kind}: w, h >= {rec['wmin']} needed")
    x, y = self._pt(at)
    be = t.nm(rec["bottom_enc"])
    cut = rec["cut"]
    cs, csp = t.nm(t.cuts[cut]["size"]), t.nm(t.cuts[cut]["space"]) * 2
    ce = t.nm(rec["cut_enc"])
    bot = Rect(rec["bottom"], x - be, y - be, x + W + be, y + H + be, nets[1], src)
    pl = Rect(rec["plate"], x, y, x + W, y + H, nets[0], src)
    self.shapes += [bot, pl]
    for (ml, e) in rec.get("markers", []):
        e = t.nm(e)
        self.shapes.append(Rect(ml, x - be - e, y - be - e, x + W + be + e, y + H + be + e, None, src))
    nx = max(1, (W - 2 * ce + csp) // (cs + csp))
    ny = max(1, (H - 2 * ce + csp) // (cs + csp))
    tw, th = nx * cs + (nx - 1) * csp, ny * cs + (ny - 1) * csp
    g = t.grid
    cx0, cy0 = x + (W - tw) // 2 // g * g, y + (H - th) // 2 // g * g
    for i in range(nx):
        for j in range(ny):
            self.shapes.append(Rect(cut, cx0 + i * (cs + csp), cy0 + j * (cs + csp), cx0 + i * (cs + csp) + cs,
                                    cy0 + j * (cs + csp) + cs, nets[0], src))
    te = max(t.nm(v) for v in t.enc(rec["top"], cut))
    top = Rect(rec["top"], cx0 - te, cy0 - te, cx0 + tw + te, cy0 + th + te, nets[0], src)
    self.shapes.append(top)
    nodes = [nets[0], nets[1]]
    pm = rec.get("params", {})
    self.device(name or f"C{len(self.devices)}", rec["model"], nodes,
                **{pm.get("w", "w"): W / 1000.0, pm.get("l", "l"): H / 1000.0})
    hnd = TwoTerm([bot, pl, top])
    hnd.top_pad, hnd.bottom_plate, hnd.plate = top, bot, pl
    # the bottom-plate metal that is not under the plate: label / connect the bottom terminal here
    hnd.bottom_pad = Rect(rec["bottom"], x - be, y - be, x, y + H + be, nets[1], src)
    hnd.a, hnd.b = top, hnd.bottom_pad
    return hnd


for _f in (via, via_size, mos, tap, guard_ring, resistor, capacitor):
    setattr(Cell, _f.__name__, _f)
