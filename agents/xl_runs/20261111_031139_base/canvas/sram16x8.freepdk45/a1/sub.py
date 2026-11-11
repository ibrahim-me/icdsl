from icdsl.canvas import *
from icdsl.canvas.route import Router
import math

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- 6T cell
def sram6t(c, wl, bl, blb, vdd, vss, at=(0, 0), name="sram6t"):
    """Compact 6T cell: access devices at the cell edges, cross-coupled
    inverter in the middle.  Bit lines leave on m2, word line and supplies
    run on m1."""
    x0, y0 = at
    # device sizes from the reference netlist
    nw, pw, l = 0.09, 0.18, 0.05
    # pitch large enough for all freepdk45 gate/diffusion/contact rules
    tp = 0.42
    # vertical placement: nfet access/pulldown, then pwell, then pfet pullup
    yn = y0 + 0.10
    yp = yn + 0.62

    # left access: gate WL, terminals BL / Q
    a = c.mos("nmos", w=nw, l=l, nf=1, gates=wl, sd=(bl, "Q"),
              at=(x0, yn), contacts=[0, 1], pitch=tp)
    # right access: gate WL, terminals BLB / QB
    b = c.mos("nmos", w=nw, l=l, nf=1, gates=wl, sd=(blb, "QB"),
              at=(x0 + 3 * tp, yn), contacts=[0, 1], pitch=tp)
    # pulldown Q->VSS, gate QB
    d1 = c.mos("nmos", w=nw, l=l, nf=1, gates="QB", sd=("Q", vss),
               at=(x0 + tp, yn), contacts=[0, 1], pitch=tp)
    # pulldown QB->VSS, gate Q
    d2 = c.mos("nmos", w=nw, l=l, nf=1, gates="Q", sd=("QB", vss),
               at=(x0 + 2 * tp, yn), contacts=[0, 1], pitch=tp)
    # pwell under the nfet diffusion row
    nd = c.rect("pwell",
                x0=min(a.diff.left, d1.diff.left, d2.diff.left, b.diff.left) - 0.12,
                x1=max(a.diff.right, d1.diff.right, d2.diff.right, b.diff.right) + 0.12,
                y0=min(a.diff.bottom, d1.diff.bottom, d2.diff.bottom, b.diff.bottom) - 0.10,
                y1=max(a.diff.top, d1.diff.top, d2.diff.top, b.diff.top) + 0.10)

    # pullup VDD->Q, gate QB
    p1 = c.mos("pmos", w=pw, l=l, nf=1, gates="QB", sd=(vdd, "Q"),
               at=(x0 + tp, yp), contacts=[0, 1], pitch=tp)
    # pullup QB->VDD, gate Q
    p2 = c.mos("pmos", w=pw, l=l, nf=1, gates="Q", sd=("QB", vdd),
               at=(x0 + 2 * tp, yp), contacts=[0, 1], pitch=tp)
    pd = c.rect("nwell",
                x0=min(p1.diff.left, p2.diff.left) - 0.12,
                x1=max(p1.diff.right, p2.diff.right) + 0.12,
                y0=min(p1.diff.bottom, p2.diff.bottom) - 0.10,
                y1=max(p1.diff.top, p2.diff.top) + 0.10, net=vdd)

    # local metal interconnect on m1
    c.rect(m1, x0=a.sd[1].left, x1=d1.sd[0].right,
           y0=min(a.sd[1].bottom, d1.sd[0].bottom),
           y1=max(a.sd[1].top, d1.sd[0].top), net="Q")
    c.rect(m1, x0=b.sd[1].left, x1=d2.sd[0].right,
           y0=min(b.sd[1].bottom, d2.sd[0].bottom),
           y1=max(b.sd[1].top, d2.sd[0].top), net="QB")
    c.rect(m1, x0=p1.sd[1].left, x1=d1.sd[0].right,
           y0=min(p1.sd[1].bottom, d1.sd[0].bottom),
           y1=max(p1.sd[1].top, d1.sd[0].top), net="Q")
    c.rect(m1, x0=p2.sd[1].left, x1=d2.sd[0].right,
           y0=min(p2.sd[1].bottom, d2.sd[0].bottom),
           y1=max(p2.sd[1].top, d2.sd[0].top), net="QB")
    c.rect(m1, x0=p1.sd[0].left, x1=p2.sd[0].right,
           y0=min(p1.sd[0].bottom, p2.sd[0].bottom),
           y1=max(p1.sd[0].top, p2.sd[0].top), net=vdd)
    c.rect(m1, x0=d1.sd[1].left, x1=d2.sd[1].right,
           y0=min(d1.sd[1].bottom, d2.sd[1].bottom),
           y1=max(d1.sd[1].top, d2.sd[1].top), net=vss)

    # word line crosses the cell on m1
    c.rect(m1, x0=x0 - 0.05, x1=x0 + 4 * tp + 0.05,
           y0=yn + 0.20, y1=yn + 0.20 + 0.11, net=wl)

    # bit-line contacts on m2, one via per access terminal
    for dev, term in ((a, "sd0"), (b, "sd0")):
        s = getattr(dev, term)
        c.via(m1, m2, at=(s.cx, s.cy + 0.30), net=bl if dev is a else blb,
              dir="v")
    # supply ports on the cell edges
    c.port(vdd, on=p1.sd[0], dir="in")
    c.port(vss, on=d1.sd[1], dir="in")
    c.port(wl, on=a.gates[0], dir="in")
    c.port(bl, on=a.sd[0], dir="in")
    c.port(blb, on=b.sd[0], dir="in")
    c._cell = c
    return type("Cell", (), {
        "bbox": c.bbox, "width": c.bbox[2] - c.bbox[0], "height": c.bbox[3] - c.bbox[1],
        "left": c.bbox[0], "right": c.bbox[2], "bottom": c.bbox[1], "top": c.bbox[3],
    })()

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
cols, rows = 8, 16
cp = sram6t(Cell("__tmp__"), "WL", "BL", "BLB", "VDD", "VSS", at=(0, 0))
pitch_x, pitch_y = 1.55, 1.49
cell_w, cell_h = cp.width, cp.height

# place cells and remember instances for the router
insts = []
for r in range(rows):
    for ccol in range(cols):
        inst = top.place(cp, at=(ccol * pitch_x, r * pitch_y),
                         name=f"XB{r}_{ccol}",
                         conns={"VDD": "VDD", "VSS": "VSS",
                                "BL": f"BL{ccol}", "BLB": f"BLB{ccol}",
                                "WL": f"WL{r}"})
        insts.append(inst)

# bit lines on m2, one vertical strip per column
for ccol in range(cols):
    bls = [inst.pin("BL", ix=ccol, iy=r) for r in range(rows)]
    blbs = [inst.pin("BLB", ix=ccol, iy=r) for r in range(rows)]
    y0 = min(p.bottom for p in bls + blbs) - 0.05
    y1 = max(p.top for p in bls + blbs) + 0.05
    x = bls[0].cx
    top.rect(m2, x0=x - 0.06, x1=x + 0.06, y0=y0, y1=y1, net=f"BL{ccol}")
    top.rect(m2, x0=x + pitch_x / 2 - 0.06, x1=x + pitch_x / 2 + 0.06,
             y0=y0, y1=y1, net=f"BLB{ccol}")

# word lines on m1, one horizontal strip per row
for r in range(rows):
    wls = [inst.pin("WL", ix=c, iy=r) for c in range(cols)]
    x0 = min(p.left for p in wls) - 0.05
    x1 = max(p.right for p in wls) + 0.05
    y = wls[0].cy
    top.rect(m1, x0=x0, x1=x1, y0=y - 0.055, y1=y + 0.055, net=f"WL{r}")

# global supply rails on m2
vdds = [inst.pin("VDD", ix=c, iy=r) for r in range(rows) for c in range(cols)]
vsss = [inst.pin("VSS", ix=c, iy=r) for r in range(rows) for c in range(cols)]
x0 = min(p.left for p in vdds + vsss) - 0.05
x1 = max(p.right for p in vdds + vsss) + 0.05
y_vdd = min(p.bottom for p in vdds) - 0.05
y_vss = max(p.top for p in vsss) + 0.05
top.rect(m2, x0=x0, x1=x1, y0=y_vdd - 0.055, y1=y_vdd + 0.055, net="VDD")
top.rect(m2, x0=x0, x1=x1, y0=y_vss - 0.055, y1=y_vss + 0.055, net="VSS")

# top-level pins
for name in ["VDD", "VSS"]:
    top.port(name, on=top.rect(m2, x0=x0, x1=x1,
                               y0=(y_vdd if name == "VDD" else y_vss) - 0.055,
                               y1=(y_vdd if name == "VDD" else y_vss) + 0.055,
                               net=name))
for ccol in range(cols):
    for sufx, net in (("BL", f"BL{ccol}"), ("BLB", f"BLB{ccol}")):
        x = ccol * pitch_x + (0 if sufx == "BL" else pitch_x / 2)
        top.port(net, on=top.rect(m2, x0=x - 0.06, x1=x + 0.06,
                                  y0=y0 - 0.2, y1=y1 + 0.2, net=net))
for r in range(rows):
    y = r * pitch_y + cp.height / 2
    top.port(f"WL{r}", on=top.rect(m1, x0=x0 - 0.2, x1=x1 + 0.2,
                                   y0=y - 0.055, y1=y + 0.055, net=f"WL{r}"))

TOP = top
