"""FinFET device recipes: cell.mos / cell.tap on a PDK whose device records say recipe="finfet" (asap7).

A FinFET process fixes what a planar one leaves free, and the recipes follow that:
  * fins lie on a fixed pitch in y, so a transistor's width is a number of fins (w = nfin * fin_pitch)
    and the active's lower edge sits on the fin grid (y = k * fin_pitch);
  * gates have one length and one pitch in x; source/drain columns sit at x = k * gate_pitch;
  * every active ends between two gates, so a dummy gate is drawn on the next grid position at each end;
  * source/drain: active -> sdt -> the strap layer (asap7 lisd), full-height columns, no cuts.
A device occupies a footprint of (nf + 2) gate pitches (its select box); footprints of neighbours in a
row abut: handle.x_next is the x of the next active. Gates of devices stacked in a column (n under p)
must form one stripe: extend them with gate_ext until they meet and separate two nets with a rect on
the gate-cut layer.

All numbers come from the PDK data (`rules`, `finfet`, `devices`); nothing here names a PDK."""
from __future__ import annotations

from .core import Rect, CanvasError, _src


def _params(t):
    f = t.d.get("finfet")
    if not f:
        raise CanvasError(f"{t.name} has no `finfet` table in its PDK data")
    nm = t.nm
    p = dict(f)
    p.update(GP=nm(t.rule("gate_pitch")), LG=nm(t.rule("gate_length")), FP=nm(t.rule("fin_pitch")),
             FW=nm(t.rule("fin_width")), FE=nm(t.rule("fin_enc")), DX=nm(t.rule("diff_ext_gate")),
             DS=nm(t.rule("dummy_gate_space")), EC=nm(t.rule("poly_endcap")), CW=nm(f["col_w"]),
             SX=nm(f["select_enc"][0]), SY=nm(f["select_enc"][1]), FX=nm(f["fin_ext"]), TW=nm(f["tap_w"]),
             GMIN=nm(f.get("gate_min_len", 0)))
    p["half"] = (p["GP"] - p["LG"]) // 2                 # gate edge to the centre of the next column
    p["xoff"] = (p["half"] - p["DX"]) % p["GP"]          # x of an active's left edge, modulo the gate pitch
    return p


def _on_grid(t, what, x, y, p):
    for axis, v, pitch, off, grid in (("x", x, p["GP"], p["xoff"], "gate"), ("y", y, p["FP"], 0, "fin")):
        if (v - off) % pitch:
            lo = (v - off) // pitch * pitch + off
            raise CanvasError(f"{what}: {axis} = {v / 1000:g} um of the active's lower-left corner is not on the "
                              f"{grid} grid of {t.name}",
                              f"{axis} must be {off / 1000:g} + k * {pitch / 1000:g} um: {lo / 1000:g} or "
                              f"{(lo + pitch) / 1000:g} are the nearest" + (
                                  "; a neighbour in the same row starts at handle.x_next" if axis == "x" else ""))


def _nfin(t, kind, W, p, least=1):
    if W <= 0 or W % p["FP"] or W < least * p["FP"]:
        n = max(least, round(W / p["FP"]))
        raise CanvasError(f"{kind}: {W / 1000:g} um is not a whole number of fins on {t.name}",
                          f"the height of an active is nfin * {p['FP'] / 1000:g} um"
                          + (f" with at least {least} fins" if least > 1 else "")
                          + f": use {n * p['FP'] / 1000:g} ({n} fin{'s' if n > 1 else ''})")
    return W // p["FP"]


def _gate_span(y, H, ge, p, t):
    """y extent of the gate stripes of an active at y .. y + H."""
    ge = ge if isinstance(ge, (tuple, list)) else (ge, ge)
    ec = p["EC"]
    lo, hi = y - ec - t.nm(ge[0]), y + H + ec + t.nm(ge[1])
    if hi - lo < p["GMIN"]:                              # one-fin devices: the minimum gate length
        d = -(-(p["GMIN"] - (hi - lo)) // 2)
        lo, hi = lo - d, hi + d
    return lo, hi


def _body(self, rec, p, x, y, x1, H, src, implant, well, wnet):
    """fins, select and well of an active at (x, y) .. (x1, y + H) -> fins, implant Rect, well Rect."""
    fins = []
    for k in range(H // p["FP"]):
        fy = y + p["FE"] + k * p["FP"]
        fins.append(Rect(p["fin"], x - p["FX"], fy, x1 + p["FX"], fy + p["FW"], None, src))
    self.shapes.extend(fins)
    box = (x - p["SX"], y - p["SY"], x1 + p["SX"], y + H + p["SY"])
    imp = wl = None
    if implant and rec.get("implant"):
        imp = Rect(rec["implant"], *box, None, src)
        self.shapes.append(imp)
    if well and rec.get("well"):
        wl = Rect(rec["well"], *box, wnet, src)
        self.shapes.append(wl)
    return fins, imp, wl


def mos_finfet(self, handle, kind, rec, w, l, nf, at, gates, sd, bulk, name, contacts, pitch, gate_ext,
               implant, well, strap_h, origin):
    t = self.tech
    p = _params(t)
    src = _src()
    GP, LG = p["GP"], p["LG"]
    L = LG if l is None else t.nm(l)
    if L != LG:
        raise CanvasError(f"{kind}: l = {l} um; {t.name} has one gate length",
                          f"use l = {LG / 1000:g} (or leave l out); a longer channel is nf gates in series")
    if pitch is not None and t.nm(pitch) != GP:
        raise CanvasError(f"{kind}: pitch = {pitch} um; the gate pitch of {t.name} is fixed at {GP / 1000:g} um")
    H = t.nm(w)
    _nfin(t, kind, H, p)
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
    x, y = self._pt(at)
    if origin == "col":                                  # at = centre of the first source/drain column
        x -= p["DX"] - p["half"]
    _on_grid(t, kind, x, y, p)
    x1 = x + 2 * p["DX"] + LG + (nf - 1) * GP
    d = Rect(rec["diff"], x, y, x1, y + H, None, src)
    self.shapes.append(d)
    glo, ghi = _gate_span(y, H, gate_ext, p, t)
    gx0 = [x + p["DX"] + i * GP for i in range(nf)]
    grects = [Rect(p["gate"], gx, glo, gx + LG, ghi, gates[i], src) for i, gx in enumerate(gx0)]
    dummies = [Rect(p["gate"], gx, glo, gx + LG, ghi, None, src) for gx in (gx0[0] - GP, gx0[-1] + GP)] \
        if p.get("dummy_gates") else []
    self.shapes.extend(grects + dummies)
    cols = [gx0[0] - p["half"] + i * GP for i in range(nf + 1)]
    sh = max(H, t.nm(strap_h) if strap_h else 0)
    sy0 = y - (sh - H) // 2
    straps = []
    for i, cx in enumerate(cols):
        if not cont[i]:
            straps.append(None)
            continue
        cx0 = cx - p["CW"] // 2
        self.shapes.append(Rect(p["sdt"], cx0, y, cx0 + p["CW"], y + H, sd[i], src))
        r = Rect(p["strap"], cx0, sy0, cx0 + p["CW"], sy0 + sh, sd[i], src)
        self.shapes.append(r)
        straps.append(r)
    bulk = bulk or rec.get("bulk")
    fins, imp, wl = _body(self, rec, p, x, y, x1, H, src, implant, well, bulk)
    name = name or f"M{len(self.devices)}"
    for i in range(nf):
        self.device(f"{name}_{i}" if nf > 1 else name, rec["model"], [sd[i + 1], gates[i], sd[i], bulk],
                    prefix=rec.get("spice_prefix", "M"), w=H / 1000.0, l=L / 1000.0)
    h = handle([d] + grects + dummies + [s for s in straps if s] + [q for q in (imp,) if q])
    h.diff, h.gates, h.sd, h.implant, h.well = d, grects, straps, imp, wl
    h.dummies, h.fins = dummies, fins
    h.gx = [(a + L / 2) / 1000.0 for a in gx0]
    h.sx = [c / 1000.0 for c in cols]
    h.pitch, h.kind, h.nets_sd, h.nets_g = GP / 1000.0, kind, sd, gates
    h.x_next = (x1 + 2 * p["SX"]) / 1000.0               # active x of the next device in this row
    return h


def tap_finfet(self, handle, kind, rec, x0, y0, x1, y1, net, at, w, h, well, implant, gate_ext):
    t = self.tech
    p = _params(t)
    src = _src()
    if at is not None:
        x, y = self._pt(at)
        H = t.nm(h) if h else 3 * p["FP"]
        W = t.nm(w) if w else p["TW"]
    else:
        if None in (x0, y0, y1):
            raise CanvasError("tap: give at=(x, y) with h=, or x0, y0, y1")
        x, y, H = t.nm(x0), t.nm(y0), t.nm(y1) - t.nm(y0)
        W = t.nm(x1) - x if x1 is not None else p["TW"]
    if W != p["TW"]:
        raise CanvasError(f"{kind}: a tap on {t.name} is one column, {p['TW'] / 1000:g} um wide (got {W / 1000:g})",
                          "leave w / x1 out; for more tie area use more fins (h=) or more tap columns")
    _nfin(t, kind, H, p, least=-(-int(round(t.area(rec["diff"]) * 1e6)) // (p["TW"] * p["FP"])) or 1)
    _on_grid(t, kind, x, y, p)
    xr = x + W
    d = Rect(rec["diff"], x, y, xr, y + H, None, src)
    self.shapes.append(d)
    dummies = []
    if p.get("dummy_gates"):
        glo, ghi = _gate_span(y, H, gate_ext, p, t)
        for gx in (x - p["DS"] - p["LG"], x - p["DS"] - p["LG"] + p["GP"]):
            dummies.append(Rect(p["gate"], gx, glo, gx + p["LG"], ghi, None, src))
        self.shapes.extend(dummies)
    cx0 = x + W // 2 - p["CW"] // 2
    self.shapes.append(Rect(p["sdt"], cx0, y, cx0 + p["CW"], y + H, net, src))
    st = Rect(p["strap"], cx0, y, cx0 + p["CW"], y + H, net, src)
    self.shapes.append(st)
    fins, imp, wl = _body(self, rec, p, x, y, xr, H, src, implant, well, net)
    hnd = handle([d, st] + dummies + [q for q in (imp,) if q])
    hnd.diff, hnd.strap, hnd.implant, hnd.well = d, st, imp, wl
    hnd.dummies, hnd.fins = dummies, fins
    hnd.x_next = (xr + 2 * p["SX"]) / 1000.0
    return hnd
