```python
"""ota_miller - two-stage Miller OTA, portable canvas layout (target: gf180mcuD)."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)
have_res = "res_poly" in tech.d.get("devices", {})
have_mim = "cap_mim" in tech.d.get("devices", {})

c = Cell("ota_miller")

# ---------------- input diff pair + tail (NMOS, bodies to VSS) ----------------
mn1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("tail", "d1"), at=(0, 0))
mn2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("tail", "d2"),
            at=(mn1.diff.right + 1.2, 0))
mt = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "tail"),
           at=((mn1.diff.left + mn2.diff.right) / 2, mn1.diff.top + 1.0))

# ---------------- PMOS mirror load (bodies/n-well to VDD) ----------------
mp3 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d1"),
            at=(mn2.diff.right + 2.6, mn1.diff.bottom))
mp4 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d2"),
            at=(mp3.diff.right + 0.6, mn1.diff.bottom))

# cross-couple the mirror gates to the drains
c.rect("poly", x0=mp3.gates[0].left, x1=mp3.sd[1].right,
       y0=mp3.gates[0].bottom, y1=mp3.sd[1].top, net="d1")
c.rect("poly", x0=mp4.gates[0].left, x1=mp3.sd[1].right,
       y0=mp4.gates[0].bottom, y1=mp4.sd[1].top, net="d1")

# ---------------- second stage: PMOS M6 + NMOS sink M7 ----------------
mp6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="d2", sd=("VDD", "OUT"),
            at=(mp4.diff.right + 2.6, mn1.diff.bottom))
mn7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS", "OUT"),
            at=(mp6.diff.right + 1.2, mt.diff.top + 1.0))

# ---------------- bias diode M8 (NMOS, diode connected) ----------------
mn8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS", "IB"),
            at=(mn7.diff.right + 1.2, mt.diff.top + 1.0))

# ---------------- compensation network ----------------
if have_res and have_mim:
    rz = c.resistor("res_poly", w=1, l=8, at=(mp6.diff.right + 0.5, mn7.diff.top + 1.0),
                    nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(rz.right + 1.0, rz.bottom),
                     nets=("x", "OUT"))
    c.via(c0, m1, at=rz.a.bbox, net="d2")
    c.via(c0, m1, at=rz.b.bbox, net="x")
    c.via(c0, m1, at=cc.top_pad.bbox, net="x")
    c.via(c0, m1, at=cc.bottom_pad.bbox, net="OUT")
else:
    # freepdk45 fallback: triode NMOS (gate=VDD) + NMOS capacitor (gate=OUT)
    m9 = c.mos("nmos", w=1, l=8, nf=1, gates="VDD", sd=("d2", "x"),
               at=(mp6.diff.right + 0.5, mn7.diff.top + 1.0))
    mc = c.mos("nmos", w=20, l=0.5, nf=1, gates="OUT", sd=("x", "x"),
               at=(m9.right + 0.5, mn7.diff.top + 1.0))

# ---------------- rails & taps ----------------
vss = c.tap("ptap", x0=mn1.diff.left - 0.4, y0=mn1.diff.bottom - 1.2,
            x1=mn8.diff.right + 0.4, y1=mn1.diff.bottom - 0.6, net="VSS")
vdd = c.tap("ntap", x0=mp3.diff.left - 0.4, y0=mp3.diff.top + 0.6,
            x1=mp6.diff.right + 0.4, y1=mp3.diff.top + 1.2, net="VDD")

def rail(src_straps, y0, y1, net):
    x0 = min(s.left for s in src_straps)
    x1 = max(s.right for s in src_straps)
    return c.rect(c0, x0=x0 - 0.3, x1=x1 + 0.3, y0=y0, y1=y1, net=net)

rail([mn1.sd[0], mn2.sd[0], mt.sd[1], mn7.sd[0], mn8.sd[0]],
     mn1.diff.bottom, vss.top, "VSS")
rail([mp3.sd[0], mp4.sd[0], mp6.sd[0]], mp3.diff.top, vdd.bottom, "VDD")
c.rect(c0, x0=vss.strap.left, x1=vss.strap.right, y0=vss.strap.bottom, y1=vss.top, net="VSS")
c.rect(c0, x0=vdd.strap.left, x1=vdd.strap.right, y0=vdd.bottom, y1=vdd.strap.top, net="VDD")
if mp3.well:
    c.rect(mp3.well.layer, x0=min(mp3.well.left, vdd.well.left),
           x1=max(mp6.well.right, vdd.well.right),
           y0=mp3.well.bottom, y1=vdd.well.top, net="VDD")

# ---------------- supply straps to top metal ----------------
for tap, net, xoff in ((vss, "VSS", -0.6), (vdd, "VDD", 0.6)):
    c.rect(m1, x0=tap.strap.cx - 0.15, x1=tap.strap.cx + 0.15,
           y0=tap.strap.top, y1=tap.strap.top + 2.5, net=net)
    c.via(m1, m2, at=(tap.strap.cx, tap.strap.top + 1.25), net=net)
    c.rect(m2, x0=tap.strap.cx - 0.2, x1=tap.strap.cx + 0.2,
           y0=tap.strap.top + 1.25 - 0.28 / 2, y1=tap.strap.top + 1.25 + 0.28 / 2, net=net)

# ---------------- input / bias / output pins on metal1 ----------------
def pin(net, shape, x0, x1, y):
    c.rect(m1, x0=x0, x1=x1, y0=y - 0.115, y1=y + 0.115, net=net)
    c.via(c0, m1, at=((x0 + x1) / 2, y), net=net)

pin("INP", mn2.gates[0], mn2.gates[0].left - 2.0, mn2.gates[0].left, mn2.gates[0].cy)
pin("INN", mn1.gates[0], mn1.gates[0].right, mn1.gates[0].right + 2.0, mn1.gates[0].cy)
pin("IB", mn8.gates[0], mn8.gates[0].right, mn8.gates[0].right + 2.0, mn8.gates[0].cy)
pin("OUT", mp6.sd[1], mp6.sd[1].right, mp6.sd[1].right + 2.0, mp6.sd[1].cy)

# ---------------- ports ----------------
c.port("INP", on=mn2.gates[0], dir="in")
c.port("INN", on=mn1.gates[0], dir="in")
c.port("IB", on=mn8.gates[0], dir="in")
c.port("OUT", on=mp6.sd[1], dir="out")
c.port("VDD", on=vdd.strap)
c.port("VSS", on=vss.strap)

TOP = c
```