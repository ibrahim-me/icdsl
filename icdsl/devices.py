"""PCells (SKY130 1.8 V MOSFET arrays, taps, guard rings), correct by construction.

MosArray: one diffusion strip holding fingers of one or more devices in any order
(e.g. "A", "ABBA", "AABB", "DABBAD" with D = dummy). Contact column k is at x = k*P
(P = finger pitch, a multiple of the routing grid). Column nets are solved so that
every finger sits between its own source and drain; gate straps go above
("top") or below ("bottom") the diffusion, two-coloured so interleaved devices
never touch. Frame: the top gate strap (or the single strap) is centred on y = 0
with the diffusion below it; strap="bottom" mirrors the device.
"""
from __future__ import annotations

from dataclasses import dataclass, field

from . import tech as T
from .geom import Pin, Rect, Shape, rect_c

G = T.GRID
BREAK_W = -(-(2 * (T.R['licon.size'] // 2 + T.R['licon.diff_enc']) + T.R['diff.space']) // G) * G  # extra x for a diffusion break


class DeviceError(Exception):
    pass


@dataclass
class Dev:
    """A logical transistor (what appears in the netlist)."""
    name: str
    kind: str
    w: int
    l: int
    nf: int
    nets: dict            # d, g, s, b
    line: int = 0

    @property
    def model(self):
        return "sky130_fd_pr__nfet_01v8" if self.kind == "nmos" else "sky130_fd_pr__pfet_01v8"


@dataclass
class MosArray:
    name: str
    kind: str
    w: int
    l: int
    fingers: list                 # device name per finger, or "dummy"
    devs: dict                    # name -> Dev
    strap: str = "top"            # orientation of the primary strap (single-device arrays)
    dummy_gate: str = ""          # net for dummy gates (bulk supply)
    line: int = 0
    shapes: list = field(default_factory=list)
    pins: list = field(default_factory=list)            # Pin (net-level, for routing)
    dev_pins: dict = field(default_factory=dict)        # dev -> term -> [Shape]
    cols: list = field(default_factory=list)            # column nets
    pitch: int = 0
    sides: dict = field(default_factory=dict)           # dev -> top|bottom
    gsides: dict = field(default_factory=dict)          # gate net -> top|bottom
    dummies: list = field(default_factory=list)         # (finger index, net)

    @property
    def nf(self):
        return len(self.fingers)

    @property
    def nbreaks(self):
        return sum(1 for c in self.cols if isinstance(c, tuple))

    @property
    def span(self):
        return self.nf * self.pitch + self.nbreaks * BREAK_W

    @property
    def ncols(self):
        return self.span // G

    def net_after(self, k):
        return _after(self.cols[k])

    def net_before(self, k):
        return _before(self.cols[k])

    # compatibility with the single-device API
    @property
    def nets(self):
        d = self.devs[self.fingers_real()[0]]
        return d.nets

    @property
    def model(self):
        return "sky130_fd_pr__nfet_01v8" if self.kind == "nmos" else "sky130_fd_pr__pfet_01v8"

    def fingers_real(self):
        return [f for f in self.fingers if f != "dummy"]


def _check(c, msg):
    if not c:
        raise DeviceError(msg)


BREAK_COST = 100


def solve_columns(fingers, devs, name):
    """Assign a net to each of the len(fingers)+1 contact columns.

    Neighbouring fingers share a column when they have a common source/drain net; where they cannot,
    the diffusion is broken there and that slot holds two columns (left_net, right_net). The number
    of breaks is minimised."""
    real = [i for i, f in enumerate(fingers) if f != "dummy"]
    _check(real, f"{name}: array has no real fingers")
    _check(all(f != "dummy" for f in fingers[real[0]:real[-1] + 1]),
           f"{name}: dummies are only allowed at the ends of a pattern")
    lo, hi = real[0], real[-1] + 1

    def sd(i):
        n = devs[fingers[i]].nets
        return n["s"], n["d"]
    # layer for slot k: right_net -> (cost, prev_right_net, left_net)
    s0, d0 = sd(lo)
    layers = [{s0: (0, None, s0)}]
    if d0 != s0:
        layers[0][d0] = (1, None, d0)
    for i in range(lo, hi):
        s_i, d_i = sd(i)
        nxt = {}
        for net, (cost, _, _) in layers[-1].items():
            if net == s_i:
                out = d_i
            elif net == d_i:
                out = s_i
            else:
                continue
            opts = [(out, 0)]
            if i + 1 < hi:
                for cand in sd(i + 1):
                    if cand != out:
                        opts.append((cand, BREAK_COST))
            for right, extra in opts:
                c = cost + extra
                if right not in nxt or c < nxt[right][0]:
                    nxt[right] = (c, net, out)
        if not nxt:
            raise DeviceError(f"{name}: finger {i} ({fingers[i]}) cannot be connected")
        layers.append(nxt)
    end = min(layers[-1].items(), key=lambda kv: (kv[1][0], 0 if kv[0] == sd(hi - 1)[0] else 1))[0]
    slots = []                         # (left_net, right_net) for slots hi..lo
    right = end
    for k in range(len(layers) - 1, -1, -1):
        cost, prev, left = layers[k][right]
        slots.append((left, right))
        right = prev
    slots = slots[::-1]
    full = [None] * (len(fingers) + 1)
    for k, (l, r) in enumerate(slots):
        full[lo + k] = l if l == r else (l, r)
    for k in range(lo - 1, -1, -1):
        full[k] = _after(full[k + 1])          # dummy columns: shorted to their neighbour
    for k in range(hi + 1, len(fingers) + 1):
        full[k] = _before(full[k - 1])
    return full


def _before(c):
    """Net of a column slot as seen from the finger on its left."""
    return c[0] if isinstance(c, tuple) else c


def _after(c):
    """Net of a column slot as seen from the finger on its right."""
    return c[1] if isinstance(c, tuple) else c


def assign_sides(fingers, devs, prefer):
    """Two-colour gate nets so straps on the same side never interleave.

    Fingers whose devices share a gate net share one strap (e.g. a current mirror)."""
    span = {}
    for i, f in enumerate(fingers):
        if f != "dummy":
            g = devs[f].nets["g"]
            a, b = span.get(g, (i, i))
            span[g] = (min(a, i), max(b, i))
    names = list(span)
    if len(names) == 1:
        return {names[0]: prefer}
    adj = {n: set() for n in names}
    for a in names:
        for b in names:
            if a < b:
                (a0, a1), (b0, b1) = span[a], span[b]
                if not (a1 + 1 < b0 or b1 + 1 < a0):     # overlap or adjacent fingers
                    adj[a].add(b)
                    adj[b].add(a)
    side = {}
    for n in names:
        if n in side:
            continue
        side[n] = prefer
        stack = [n]
        while stack:
            u = stack.pop()
            for v in adj[u]:
                want = "bottom" if side[u] == "top" else "top"
                if v not in side:
                    side[v] = want
                    stack.append(v)
                elif side[v] != want:
                    raise DeviceError(f"gate nets {u} and {v} (and others) interleave so that their gate straps "
                                      f"need more than two levels; reorder the pattern or use separate rows")
    return side


def build_array(a: MosArray):
    R = T.R
    _check(a.kind in ("nmos", "pmos"), f"{a.name}: unknown device type {a.kind}")
    _check(a.w >= R["fet.wmin"], f"{a.name}: w={a.w/1000}um below minimum {R['fet.wmin']/1000}um")
    _check(a.l >= R["poly.width"], f"{a.name}: l={a.l/1000}um below minimum 0.15um")
    _check(a.w % 10 == 0 and a.l % 10 == 0, f"{a.name}: w and l must be multiples of 0.01um")
    _check(1 <= a.nf <= 128, f"{a.name}: 1..128 fingers")
    lic = R["licon.size"]
    P = -(-(a.l + 2 * R["licon.gate_space"] + lic) // G) * G
    a.pitch = P
    nf, L, W = a.nf, a.l, a.w
    a.cols = solve_columns(a.fingers, a.devs, a.name)
    a.gsides = assign_sides(a.fingers, a.devs, "top")
    a.sides = {d: a.gsides[a.devs[d].nets["g"]] for d in set(a.fingers) if d != "dummy"}
    multi = len(a.gsides) > 1
    single_E = lic // 2 + (R["licon.poly_psdm_space"] + R["sdm.enc_diff"] if a.kind == "pmos" else R["licon.poly_diff_space"])
    E2 = R["poly.endcap"] + R["poly.space"] + lic // 2 + R["licon.poly_enc"]       # 475: strap clears foreign endcaps
    Et = E2 if multi else single_E
    need_bottom = multi or "dummy" in a.fingers
    Eb = E2 if multi else single_E
    # frame: top strap at y=0, diffusion [db, dt]
    dt = -Et
    db = dt - W
    yb = -(-(Et + W + Eb) // G) * G          # bottom strap distance below 0, on grid
    yb = -yb
    dk = ("diff_n",) if a.kind == "nmos" else ("diff_p",)
    S = []
    xd0 = -(lic // 2 + R["licon.diff_enc"])
    # column positions: a diffusion break shifts everything to its right by BREAK_W
    xl, xr, shift = [], [], 0
    for k in range(nf + 1):
        xl.append(k * P + shift)
        if isinstance(a.cols[k], tuple):
            shift += BREAK_W
        xr.append(k * P + shift)
    a.col_x = list(zip(xl, xr))
    start = 0
    for k in range(1, nf + 1):
        if isinstance(a.cols[k], tuple) or k == nf:
            S.append(Shape("diff", Rect(xr[start] + xd0, db, xl[k] - xd0, dt), None, a.name, dk))
            start = k
    gx = [(xr[i] + P // 2) for i in range(nf)]
    pe1, ne = R["licon.poly_enc1"], R["npc.enc_pcon"]
    ph = lic + 2 * R["licon.poly_enc"]
    a.dev_pins = {d: {"g": [], "s": [], "d": []} for d in a.devs if d in a.fingers}
    li_bars = {"top": [], "bottom": []}

    def strap(idx, net, side, owner, term_key):
        """Poly bar + licons + npc + li bar over fingers idx (list), on side."""
        yc = 0 if side == "top" else yb
        x0 = min(gx[idx[0]] - lic // 2 - pe1, gx[idx[0]] - L // 2)
        x1 = max(gx[idx[-1]] + lic // 2 + pe1, gx[idx[-1]] + L // 2)
        S.append(Shape("poly", Rect(x0, yc - ph // 2, x1, yc + ph // 2), net, owner))
        for i in idx:
            S.append(Shape("licon", rect_c(gx[i], yc, lic, lic), net, owner, ("pcon",)))
        S.append(Shape("npc", Rect(gx[idx[0]] - lic // 2 - ne, yc - lic // 2 - ne,
                                   gx[idx[-1]] + lic // 2 + ne, yc + lic // 2 + ne), None, owner))
        # li bar reaches the contact columns on both sides of its fingers (grid access)
        if not multi and term_key is not None and "dummy" not in a.fingers:
            lx0, lx1 = xr[0] - lic // 2, xl[nf] + lic // 2
        else:
            lx0, lx1 = xr[idx[0]] - lic // 2, xl[idx[-1] + 1] + lic // 2
        lx0 = min(lx0, gx[idx[0]] - lic // 2 - R["li.enc_licon1"])
        lx1 = max(lx1, gx[idx[-1]] + lic // 2 + R["li.enc_licon1"])
        sh = Shape("li", Rect(lx0, yc - lic // 2, lx1, yc + lic // 2), net, owner)
        S.append(sh)
        li_bars[side].append(sh)
        acc = [(c * G, yc) for c in range(lx0 // G - 1, lx1 // G + 2)
               if lx0 <= c * G - lic // 2 and c * G + lic // 2 <= lx1]
        return sh, acc

    # gates: one strap per gate net
    for net, side in a.gsides.items():
        idx = [i for i, f in enumerate(a.fingers) if f != "dummy" and a.devs[f].nets["g"] == net]
        for i in idx:
            x = gx[i]
            y0 = db - R["poly.endcap"] if side == "top" else yb
            y1 = 0 if side == "top" else dt + R["poly.endcap"]
            S.append(Shape("poly", Rect(x - L // 2, y0, x + L // 2, y1), net, a.name))
        sh, acc = strap(idx, net, side, a.name, "g")
        users = sorted({a.fingers[i] for i in idx})
        for d in users:
            a.dev_pins[d]["g"].append(sh)
        a.pins.append(Pin(net, sh, acc, "+".join(users) + ".g"))
    # dummies: gate to the bulk supply, pad on the side away from the neighbour's strap
    for i, f in enumerate(a.fingers):
        if f != "dummy":
            continue
        nb = next((a.fingers[j] for j in (i + 1, i - 1) if 0 <= j < nf and a.fingers[j] != "dummy"), None)
        side = "bottom" if a.sides.get(nb, "top") == "top" else "top"
        x = gx[i]
        y0 = db - R["poly.endcap"] if side == "top" else yb
        y1 = 0 if side == "top" else dt + R["poly.endcap"]
        S.append(Shape("poly", Rect(x - L // 2, y0, x + L // 2, y1), a.dummy_gate, a.name))
        sh, acc = strap([i], a.dummy_gate, side, a.name, None)
        a.pins.append(Pin(a.dummy_gate, sh, acc, f"{a.name}.dummy{i}.g"))
        a.dummies.append((i, a.net_after(i)))

    # source / drain columns
    e1 = R["licon.diff_enc1"]
    n = (W - 2 * e1 - lic) // (lic + R["licon.space"]) + 1
    span = n * lic + (n - 1) * R["licon.space"]
    y0 = db + (W - span) // 2
    y0 -= y0 % 5
    top_lim = -lic // 2 - R["li.space"]                       # below top strap li
    bot_lim = (yb + lic // 2 + R["li.space"]) if need_bottom else None
    parts = []
    for k in range(nf + 1):
        c = a.cols[k]
        if isinstance(c, tuple):
            parts += [(k, xl[k], c[0], (k - 1,)), (k, xr[k], c[1], (k,))]
        else:
            parts.append((k, xl[k], c, (k - 1, k)))
    for (k, x, net, users) in parts:
        for j in range(n):
            yc = y0 + j * (lic + R["licon.space"])
            S.append(Shape("licon", Rect(x - lic // 2, yc, x + lic // 2, yc + lic), net, a.name, ("dcon",)))
        ly0, ly1 = y0 - R["li.enc_licon1"], y0 + span + R["li.enc_licon1"]
        rows = _rows_inside(ly0, ly1)
        if not rows:
            r_dn = (ly0 - lic // 2) // G * G - lic // 2      # extend down to the row below
            if bot_lim is None or r_dn >= bot_lim:
                ly0 = r_dn
            else:
                r_up = -(-(ly1 + lic // 2) // G) * G + lic // 2
                _check(r_up <= top_lim, f"{a.name}: no grid row reachable for column {k}; increase w")
                ly1 = r_up
            rows = _rows_inside(ly0, ly1)
        sd = Shape("li", Rect(x - lic // 2, ly0, x + lic // 2, ly1), net, a.name)
        S.append(sd)
        a.pins.append(Pin(net, sd, [(x, y) for y in rows], f"{a.name}.col{k}" + ("" if len(users) == 2 else
                                                                                ("L" if users[0] == k - 1 else "R"))))
        for side_f in users:
            if 0 <= side_f < nf and a.fingers[side_f] != "dummy":
                d = a.fingers[side_f]
                dn = a.devs[d].nets
                term = "s" if net == dn["s"] else "d"
                if sd not in a.dev_pins[d][term]:
                    a.dev_pins[d][term].append(sd)
    if a.strap == "bottom" and not multi:
        S = [s.mirrored_y() for s in S]
        for p in a.pins:
            p.shape = p.shape.mirrored_y()
            p.access = [(x, -y) for (x, y) in p.access]
        for d in a.dev_pins:
            for t in a.dev_pins[d]:
                a.dev_pins[d][t] = [s.mirrored_y() for s in a.dev_pins[d][t]]
    a.shapes = S
    return a


def _rows_inside(y0, y1):
    h = T.R["mcon.size"] // 2
    r0 = -(-(y0 + h) // G)
    r1 = (y1 - h) // G
    return [r * G for r in range(r0, r1 + 1)]


def single(dev: Dev, strap="top", line=0):
    """A MosArray holding one device with nf fingers (the classic transistor)."""
    return MosArray(dev.name, dev.kind, dev.w, dev.l, [dev.name] * dev.nf, {dev.name: dev}, strap=strap, line=line)


def implants(a: MosArray, well=True):
    """Per-array implant (and n-well for pmos) enclosing the diffusion (free placement mode)."""
    ds = [s.rect for s in a.shapes if s.layer == "diff"]
    d = ds[0]
    for r in ds[1:]:
        d = d.union(r)
    e = T.R["sdm.enc_diff"]
    out = [Shape("nsdm" if a.kind == "nmos" else "psdm", d.bloat(e), None, a.name)]
    if a.kind == "pmos" and well:
        out.append(Shape("nwell", d.bloat(T.R["nwell.enc_pdiff"]), a.dummy_gate or None, a.name))
    return out


def tap_strip(kind, net, width, y, owner):
    """Full-width tap strip centred on y, licons/li/mcons every grid column (row template)."""
    R = T.R
    lic = R["licon.size"]
    th = lic + 2 * R["licon.diff_enc1"]
    inset = R["nwell.enc_ntap"]
    S = [Shape("tap", Rect(inset, y - th // 2, width - inset, y + th // 2), net, owner,
               ("tap_p",) if kind == "ptap" else ("tap_n",))]
    for k in range(width // G):
        x = k * G + G // 2
        if x - lic // 2 - R["licon.tap_enc"] >= inset and x + lic // 2 + R["licon.tap_enc"] <= width - inset:
            S.append(Shape("licon", rect_c(x, y, lic, lic), net, owner, ("dcon",)))
        S.append(Shape("mcon", rect_c(x, y, lic, lic), net, owner))
    S.append(Shape("li", Rect(0, y - lic // 2, width, y + lic // 2), net, owner))
    return S


def tap_bar(kind, net, x0, x1, y, owner, metal=True):
    """A free-standing tap bar from x0 to x1 (grid columns) centred on grid row y, with implant,
    n-well (ntap), li, and optionally a met1 strap. Contacts at every grid column."""
    R = T.R
    lic = R["licon.size"]
    th = lic + 2 * R["licon.diff_enc1"]
    xl, xr = x0 - lic // 2 - R["licon.tap_enc"], x1 + lic // 2 + R["licon.tap_enc"]
    tk = ("tap_p",) if kind == "ptap" else ("tap_n",)
    S = [Shape("tap", Rect(xl, y - th // 2, xr, y + th // 2), net, owner, tk)]
    for x in range(x0, x1 + 1, G):
        S.append(Shape("licon", rect_c(x, y, lic, lic), net, owner, ("dcon",)))
        if metal:
            S.append(Shape("mcon", rect_c(x, y, lic, lic), net, owner))
    S.append(Shape("li", Rect(x0 - lic // 2 - R["li.enc_licon1"], y - lic // 2,
                              x1 + lic // 2 + R["li.enc_licon1"], y + lic // 2), net, owner))
    e = R["sdm.enc_diff"]
    tr = S[0].rect
    S.append(Shape("psdm" if kind == "ptap" else "nsdm", tr.bloat(e), None, owner))
    if kind == "ntap":
        en = R["nwell.enc_ntap"]
        ey = max(en, -(-(R["nwell.width"] - th) // 10) * 5)        # keep the well >= 0.84 um wide
        ex = max(en, -(-(R["nwell.width"] - tr.w) // 10) * 5)
        S.append(Shape("nwell", tr.bloat(ex, ey), net, owner))
    if metal:
        mw = T.PAD_MCON_M1
        S.append(Shape("m1", Rect(x0 - mw // 2, y - mw // 2, x1 + mw // 2, y + mw // 2), net, owner))
    return S
