```python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
top_metal = tech.stack[-1]

# ---------------------------------------------------------------- cell
cell_w = 1.6
cell_h = 1.6
rail_h = 0.22
diff_w_n = 0.09
diff_w_p = 0.18
gate_l = 0.05
gate_ext = 0.07
diff_space = 0.08
nwell_w = 0.22
nwell_en = 0.055
tap_w = 0.30
tap_h = 0.30
tap_space = 0.105
via_size = 0.065
via_space = 0.075
m1_w = 0.065
m1_sp = 0.065
bl_pitch = cell_w

def node_x(col, node):
    return col * bl_pitch + (0.42 if node == "Q" else 1.18)

def make_sram6t(c, name):
    """One 6T SRAM cell.  All internal nets are local; ports are on the cell."""
    c = Cell(name)
    # power rails (m1, horizontal)
    vdd = c.rect(c1, x0=0, y0=cell_h - rail_h, x1=cell_w, y1=cell_h, net="VDD")
    vss = c.rect(c1, x0=0, y0=0, x1=cell_w, y1=rail_h, net="VSS")
    # n-well for PMOS
    nw = c.rect("nwell", x0=-nwell_en, y0=cell_h - rail_h - nwell_w + nwell_en,
                x1=cell_w + nwell_en, y1=cell_h + nwell_en, net="VDD")
    # ntap in n-well
    ntap = c.tap("ntap", x0=cell_w - tap_w - 0.05, y0=cell_h - tap_h - 0.05,
                 x1=cell_w - 0.05, y1=cell_h - 0.05, net="VDD")
    c.rect(c0, x0=ntap.strap.left, x1=ntap.strap.right,
           y0=vdd.bottom, y1=vdd.top, net="VDD")
    # ptap in substrate
    ptap = c.tap("ptap", x0=0.05, y0=0.05, x1=0.05 + tap_w, y1=0.05 + tap_h, net="VSS")
    c.rect(c0, x0=ptap.strap.left, x1=ptap.strap.right,
           y0=vss.bottom, y1=vss.top, net="VSS")
    # transistors
    mn_a = c.mos("nmos", w=diff_w_n, l=gate_l, nf=1, gates="WL", sd=("BL", "Q"),
                 at=(0.10, rail_h + 0.10), gate_ext=(gate_ext, gate_ext))
    mn_pd1 = c.mos("nmos", w=diff_w_n, l=gate_l, nf=1, gates="QB", sd=("VSS", "Q"),
                   at=(mn_a.diff.right + diff_space, rail_h + 0.10),
                   gate_ext=(gate_ext, gate_ext))
    mn_pd2 = c.mos("nmos", w=diff_w_n, l=gate_l, nf=1, gates="Q", sd=("VSS", "QB"),
                   at=(mn_pd1.diff.right + diff_space, rail_h + 0.10),
                   gate_ext=(gate_ext, gate_ext))
    mn_b = c.mos("nmos", w=diff_w_n, l=gate_l, nf=1, gates="WL", sd=("QB", "BLB"),
                 at=(mn_pd2.diff.right + diff_space, rail_h + 0.10),
                 gate_ext=(gate_ext, gate_ext))
    mp1 = c.mos("pmos", w=diff_w_p, l=gate_l, nf=1, gates="QB", sd=("VDD", "Q"),
                at=(0.10, cell_h - rail_h - 0.10 - diff_w_p),
                gate_ext=(gate_ext, gate_ext), well=False)
    mp2 = c.mos("pmos", w=diff_w_p, l=gate_l, nf=1, gates="Q", sd=("QB", "VDD"),
                at=(mp1.diff.right + diff_space, cell_h - rail_h - 0.10 - diff_w_p),
                gate_ext=(gate_ext, gate_ext), well=False)
    # gate straps: WL horizontal, Q/QB vertical poly
    wl = c.rect("poly", x0=mn_a.gates[0].left - 0.02, y0=mn_a.gates[0].bottom - 0.02,
                x1=mn_b.gates[0].right + 0.02, y1=mn_b.gates[0].top + 0.02, net="WL")
    q_strap = c.rect("poly", x0=node_x(0, "Q") - 0.035, y0=mn_pd1.gates[0].bottom - 0.02,
                     x1=node_x(0, "Q") + 0.035, y1=mn_pd2.gates[0].top + 0.02, net="Q")
    qb_strap = c.rect("poly", x0=node_x(0, "QB") - 0.035, y0=mn_pd1.gates[0].bottom - 0.02,
                      x1=node_x(0, "QB") + 0.035, y1=mn_pd2.gates[0].top + 0.02, net="QB")
    # cross-couple: Q strap over Mn0_1 gate, QB strap over Mn0_2 gate
    # contacts on Q/QB straps
    c.via("poly", c0, at=(q_strap.cx, mn_pd1.diff.top + 0.04), net="Q", dir="v")
    c.via("poly", c0, at=(qb_strap.cx, mn_pd2.diff.top + 0.04), net="QB", dir="v")
    # connect transistor drains to Q/QB straps (poly already overlaps diffusion)
    # access transistors: connect Q/QB to BL/BLB straps via m1
    q_m1 = c.rect(c1, x0=node_x(0, "Q") - 0.05, y0=mn_a.diff.top,
                  x1=node_x(0, "Q") + 0.05, y1=cell_h - rail_h, net="Q")
    qb_m1 = c.rect(c1, x0=node_x(0, "QB") - 0.05, y0=mn_b.diff.top,
                   x1=node_x(0, "QB") + 0.05, y1=cell_h - rail_h, net="QB")
    c.via(c0, c1, at=(mn_a.sd[1].cx, mn_a.sd[1].cy), net="Q", dir="h")
    c.via(c0, c1, at=(mn_b.sd[0].cx, mn_b.sd[0].cy), net="QB", dir="h")
    c.via(c0, c1, at=(mn_pd1.sd[1].cx, mn_pd1.sd[1].cy), net="Q", dir="h")
    c.via(c0, c1, at=(mn_pd1.sd[0].cx, mn_pd1.sd[0].cy), net="VSS", dir="h")
    c.via(c0, c1, at=(mn_pd2.sd[1].cx, mn_pd2.sd[1].cy), net="QB", dir="h")
    c.via(c0, c1, at=(mn_pd2.sd[0].cx, mn_pd2.sd[0].cy), net="VSS", dir="h")
    c.via(c0, c1, at=(mp1.sd[1].cx, mp1.sd[1].cy), net="Q", dir="h")
    c.via(c0, c1, at=(mp1.sd[0].cx, mp1.sd[0].cy), net="VDD", dir="h")
    c.via(c0, c1, at=(mp2.sd[0].cx, mp2.sd[0].cy), net="QB", dir="h")
    c.via(c0, c1, at=(mp2.sd[1].cx, mp2.sd[1].cy), net="VDD", dir="h")
    # BL / BLB straps (m1 vertical) - connect access sources/drains
    bl_m1 = c.rect(c1, x0=node_x(0, "BL") - 0.05, y0=rail_h,
                   x1=node_x(0, "BL") + 0.05, y1=cell_h - rail_h, net="BL")
    blb_m1 = c.rect(c1, x0=node_x(0, "BLB") - 0.05, y0=rail_h,
                    x1=node_x(0, "BLB") + 0.05, y1=cell_h - rail_h, net="BLB")
    c.via(c0, c1, at=(mn_a.sd[0].cx, mn_a.sd[0].cy), net="BL", dir="h")
    c.via(c0, c1, at=(mn_b.sd[1].cx, mn_b.sd[1].cy), net="BLB", dir="h")
    # ports
    c.port("BL", on=bl_m1, dir="inout")
    c.port("BLB", on=blb_m1, dir="inout")
    c.port("WL", on=wl, dir="in")
    c.port("VDD", on=vdd, dir="inout")
    c.port("VSS", on=vss, dir="inout")
    return c

# ---------------------------------------------------------------- top
TOP = Cell("sram16x8")
ncol, nrow = 8, 16
cell = make_sram6t(Cell, "sram6t")

# place array
insts = {}
for row in range(nrow):
    for col in range(ncol):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": f"BL{col}", "BLB": f"BLB{col}",
                 "WL": f"WL{row}"}
        insts[f"XB{row}_{col}"] = TOP.place(cell, at=(col * cell_w, row * cell_h),
                                            name=f"XB{row}_{col}", conns=conns)

# global rails
vdd_rail = TOP.rect(c1, x0=0, y0=nrow * cell_h - rail_h,
                    x1=ncol * cell_w, y1=nrow * cell_h, net="VDD")
vss_rail = TOP.rect(c1, x0=0, y0=0, x1=ncol * cell_w, y1=rail_h, net="VSS")
# connect cell rails to global rails
for row in range(nrow):
    for col in range(ncol):
        inst = insts[f"XB{row}_{col}"]
        TOP.rect(c1, x0=inst.pin("VDD").x0, y0=inst.pin("VDD").y0,
                 x1=inst.pin("VDD").x1, y1=vdd_rail.top, net="VDD")
        TOP.rect(c1, x0=inst.pin("VSS").x0, y0=vss_rail.bottom,
                 x1=inst.pin("VSS").x1, y1=inst.pin("VSS").y1, net="VSS")

# bit lines: m2 vertical over the array
bl_shapes = {}
blb_shapes = {}
for col in range(ncol):
    x = col * cell_w + cell_w / 2
    bl_shapes[col] = TOP.rect(c2, x0=x - 0.05, y0=0, x1=x + 0.05,
                              y1=nrow * cell_h, net=f"BL{col}")
    blb_shapes[col] = TOP.rect(c2, x0=x + cell_w / 2 + 0.05 - 0.1, y0=0,
                               x1=x + cell_w / 2 + 0.05 + 0.1, y1=nrow * cell_h,
                               net=f"BLB{col}")
    # connect m2 to cell m1 straps via vias
    for row in range(nrow):
        inst = insts[f"XB{row}_{col}"]
        TOP.via(c1, c2, at=(inst.pin("BL").cx, bl_shapes[col].cy), net=f"BL{col}", dir="v")
        TOP.via(c1, c2, at=(inst.pin("BLB").cx, blb_shapes[col].cy), net=f"BLB{col}", dir="v")

# word lines: m2 horizontal over the array
wl_shapes = {}
for row in range(nrow):
    y = row * cell_h + cell_h / 2
    wl_shapes[row] = TOP.rect(c2, x0=0, y0=y - 0.05, x1=ncol * cell_w,
                              y1=y + 0.05, net=f"WL{row}")
    for col in range(ncol):
        inst = insts[f"XB{row}_{col}"]
        TOP.via(c1, c2, at=(inst.pin("WL").cx, wl_shapes[row].cy), net=f"WL{row}", dir="v")

# ports
TOP.port("VDD", on=vdd_rail)
TOP.port("VSS", on=vss_rail)
for col in range(ncol):
    TOP.port(f"BL{col}", on=bl_shapes[col])
    TOP.port(f"BLB{col}", on=blb_shapes[col])
for row in range(nrow):
    TOP.port(f"WL{row}", on=wl_shapes[row])
```