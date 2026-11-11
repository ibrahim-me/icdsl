"""ota_miller: two-stage Miller OTA. Hand-placed analog layout: 8 MOS strips of different W/L/fingers
in two guard rings, a poly resistor (Rz) and a MIM capacitor (Cc); signal nets routed by the trunk
router, supplies by hand. PDK-generic: every dimension comes from the tech data.
On a PDK without resistor / MIM recipes (freepdk45: MOS devices only) the compensation network is made
of transistors: Rz = NMOS in triode (M9, gate at VDD), Cc = NMOS capacitor (MC, gate OUT, source = drain)."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
c = Cell("ota_miller")
r = Router(c)
PASSIVES = "res_poly" in tech.d["devices"] and "cap_mim" in tech.d["devices"]

s01 = c.via_size(c0, c1, dir="v", top_dir="h")
sg = c.via_size("poly", c1, dir="h", top_dir="h")
BAR = max(s01[c1][1], sg[c1][1], c.via_size(c1, c2, dir="h", top_dir="v")[c1][1])   # pin bar height
GAP = max(tech.rule("polycontact_diff_space"), tech.space(c0), tech.space(c1)) + 0.1


def strip(kind, name, w, l, nf, g, s, d, at, row, supply=None):
    """MOS strip with pin bars on c1: drain bar along the top of the diffusion, source bar along the
    bottom (unless the source is the supply), gate bar on poly outside the diffusion (above an nmos,
    below a pmos). Returns (handle, everything drawn)."""
    n0 = len(c.shapes)
    p = kind.startswith("p")
    m = c.mos(kind, w=w, l=l, nf=nf, gates=g, sd=(s, d), at=at, name=name, well=not p)
    st = m.sd[0]
    ys, yd = st.bottom + max(BAR, s01[c0][1]) / 2, st.top - max(BAR, s01[c0][1]) / 2
    if p:
        ys, yd = yd, ys                                 # pmos: sources next to the top (VDD) side
    for net, y, cols in ((s, ys, m.sd[0::2]), (d, yd, m.sd[1::2])):
        if net == supply:
            continue
        vs = [c.via(c0, c1, at=(k.cx, y), net=net, dir="v", top_dir="h") for k in cols]
        x0, x1 = vs[0].upper.left, vs[-1].upper.right
        if x1 - x0 < 1.0:                               # room for the router's via
            x0, x1 = (x0 + x1) / 2 - 0.5, (x0 + x1) / 2 + 0.5
        r.add(net, c.rect(c1, x0=x0, x1=x1, y0=y - BAR / 2, y1=y + BAR / 2, net=net), group=row)
    # gate bar
    hp = max(sg["poly"][1], BAR, sg[c0][1])
    yg = (m.diff.bottom - GAP - hp / 2) if p else (m.diff.top + GAP + hp / 2)
    xa, xb = m.gates[0].left, m.gates[-1].right
    xc = (xa + xb) / 2
    xa, xb = min(xa, xc - sg["poly"][0] / 2), max(xb, xc + sg["poly"][0] / 2)
    pad = c.via("poly", c1, at=(xc, yg), net=g, dir="h", top_dir="h").lower     # the bar has the pad's height
    c.rect("poly", x0=xa, x1=xb, y0=pad.bottom, y1=pad.top, net=g)
    for gt in m.gates:
        c.rect("poly", x0=gt.left, x1=gt.right, y0=min(gt.bottom, yg), y1=max(gt.top, yg), net=g)
    r.add(g, c.rect(c1, x0=min(xa, xc - 0.5), x1=max(xb, xc + 0.5), y0=yg - BAR / 2, y1=yg + BAR / 2, net=g), group=row)
    return m, Group(c.shapes[n0:])


def row(specs, y, name, supply):
    x, out = 0.0, []
    for kind, nm, w, l, nf, g, s, d in specs:
        m, grp = strip(kind, nm, w, l, nf, g, s, d, (x, y), name, supply)
        out.append((m, grp))
        x = grp.right + 1.2
    return out


# ---------------------------------------------------------------- placement
sinks = row([("nmos", "M8", 2.0, 1.0, 2, "IB", "VSS", "IB"),
             ("nmos", "M5", 2.0, 1.0, 4, "IB", "VSS", "tail"),
             ("nmos", "M7", 2.0, 1.0, 8, "IB", "VSS", "OUT")], 0.0, "sinks", "VSS")
y1 = max(g.top for _, g in sinks) + 1.0
pair = row([("nmos", "M1", 4.0, 0.5, 2, "INN", "tail", "d1"),
            ("nmos", "M2", 4.0, 0.5, 2, "INP", "tail", "d2")]
           + ([] if PASSIVES else [("nmos", "M9", 2.0, 0.5, 1, "VDD", "d2", "x"),
                                   ("nmos", "MC", 4.0, 1.0, 8, "OUT", "x", "x")]), y1, "pair", "VSS")
nring = c.guard_ring("ptap", around=[g for _, g in sinks + pair], net="VSS", space=1.0)
y2 = nring.outer[3] + 3.0
loads = row([("pmos", "M3", 4.0, 1.0, 2, "d1", "VDD", "d1"),
             ("pmos", "M4", 4.0, 1.0, 2, "d1", "VDD", "d2"),
             ("pmos", "M6", 4.0, 0.5, 8, "d2", "VDD", "OUT")], y2, "loads", "VDD")
pring = c.guard_ring("ntap", around=[g for _, g in loads], net="VDD", space=1.0)

# supplies: source straps run on c0 into the rings
for m, _ in sinks:
    for st in m.sd[0::2]:
        c.rect(c0, x0=st.left, x1=st.right, y0=nring.inner[1] - 0.1, y1=st.bottom, net="VSS")
for m, _ in loads:
    for st in m.sd[0::2]:
        c.rect(c0, x0=st.left, x1=st.right, y0=st.top, y1=pring.inner[3] + 0.1, net="VDD")

# ---------------------------------------------------------------- Rz and Cc, right of the rings
if PASSIVES:
    xr = max(nring.outer[2], pring.outer[2]) + 3.0
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(xr, 1.0), nets=("d2", "x"), name="RZ", orient="v")
    for pad, net in ((rz.a, "d2"), (rz.b, "x")):
        v = c.via(c0, c1, at=pad, net=net, dir="h", top_dir="h")
        r.add(net, c.rect(c1, x0=v.upper.cx - 0.6, x1=v.upper.cx + 0.6, y0=v.upper.cy - BAR / 2, y1=v.upper.cy + BAR / 2,
                          net=net), group="rc")

    rec = tech.device("cap_mim")
    xc = rz.right + 12.0
    cc = c.capacitor("cap_mim", w=20.0, h=20.0, at=(xc, 0.0), nets=("x", "OUT"), name="CC")
    bp = cc.bottom_pad


    def plate_pin(net, layer, y):
        """Stack from a plate metal down to c1, 2 um left of the capacitor, and a c1 pin bar that keeps
        the router's wires well away from the capacitor metal."""
        v = c.via(c1, layer, at=(bp.left - 2.0, y), net=net, dir="h", top_dir="h")
        c.rect(c1, x0=v.lower.cx - 6.0, x1=v.lower.cx, y0=y - BAR / 2, y1=y + BAR / 2, net=net)
        r.add(net, c.rect(c1, x0=v.lower.cx - 6.0, x1=v.lower.cx - 3.5, y0=y - BAR / 2, y1=y + BAR / 2, net=net), group="rc")


    # bottom plate (OUT): tab to the left
    c.rect(rec["bottom"], x0=bp.left - 3.0, x1=bp.left + 0.1, y0=bp.bottom + 2.0, y1=bp.bottom + 4.0, net="OUT")
    plate_pin("OUT", rec["bottom"], bp.bottom + 3.0)
    # top plate (x): top-metal strap to the left, past the bottom plate
    yt = bp.bottom + 9.0
    c.rect(rec["top"], x0=bp.left - 3.0, x1=cc.top_pad.left + 0.5, y0=yt - 1.0, y1=yt + 1.0, net="x")
    plate_pin("x", rec["top"], yt)
else:
    # M9's gate is at VDD: a pin on the n-tap ring's bottom bar for the router
    st = pring.bottom_bar.strap
    v = c.via(c0, c1, at=(st.cx, st.cy), net="VDD", dir="h", top_dir="h")
    r.add("VDD", c.rect(c1, x0=v.upper.cx - 0.6, x1=v.upper.cx + 0.6, y0=v.upper.cy - BAR / 2, y1=v.upper.cy + BAR / 2,
                        net="VDD"), group="vdd")

# ---------------------------------------------------------------- routing and ports
h = r.run()
for net in ("INP", "INN", "OUT", "IB"):
    c.port(net, on=h[net])
c.port("VDD", on=pring.straps[0])
c.port("VSS", on=nring.straps[0])
TOP = c
