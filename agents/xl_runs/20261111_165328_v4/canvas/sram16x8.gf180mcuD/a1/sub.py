from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
top = tech.stack[-1]

# ------------------------------------------------------------------ cell
def sram6t(c, x, y, bl, blb, wl, vdd, vss):
    """One 6T cell.  Returns dict of port shapes (c1) for the router."""
    Wn, Wp, L = 0.36, 0.72, 0.28
    pw, ps = tech.width("poly"), tech.space("poly")
    cw = max(tech.width(c0), 0.3)
    cs = tech.space(c0)
    m1w = max(tech.width(c1), 0.3)
    m1s = tech.space(c1)
    via = tech.via_size(c0, c1)
    vw, vh = via[c0]
    pad = max(vw, vh) + 2 * m1s          # m1 pad around a c0 contact

    # diffusion columns (x) and gate columns (x)
    g0 = x + 0.62                        # gate of M0/M3 (WL)  -> poly column
    g1 = x + 1.30                        # gate of M1/P1 (QB)
    g2 = x + 1.98                        # gate of M2/P2 (Q)
    dBL = x + 0.10                       # BL  diffusion column
    dQ  = x + 0.96                       # Q   diffusion column
    dQB = x + 1.64                       # QB  diffusion column
    dBLB = x + 2.32                      # BLB diffusion column
    dVDD = x + 3.00                      # VDD diffusion column (P drains)
    dVSS = x + 3.68                      # VSS diffusion column (M drains)
    cell_w = 4.40
    cell_h = 4.60
    ybot, ytop = y, y + cell_h
    yA = ybot + 0.62                     # access transistors (nmos row)
    yP = ytop - 0.62                     # pmos row
    yN = ybot + 1.62                     # nmos pull-down row

    # ---- n-well for the pmos row
    nw = c.rect("nwell", x0=x + 0.25, x1=x + cell_w - 0.25,
                y0=yP - 0.75, y1=ytop - 0.05, net="VDD")

    # ---- transistors ------------------------------------------------
    # access nmos: M0 (BL-Q), M3 (BLB-QB), common gate WL at g0
    m0 = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BL", "Q"),
               at=(g0, yA), gate_ext=(0.18, 0.18))
    m3 = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BLB", "QB"),
               at=(g0, yA), gate_ext=(0.18, 0.18))
    # move m3 to the right diffusion column: rebuild at proper x
    c.delete(m3) if hasattr(c, "delete") else None
    m3 = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BLB", "QB"),
               at=(g0 + (dBLB - dBL), yA), gate_ext=(0.18, 0.18))
    # pull-down nmos: M1 (Q-VSS, gate QB at g1), M2 (QB-VSS, gate Q at g2)
    m1 = c.mos("nmos", w=Wn, l=L, nf=1, gates="QB", sd=("Q", "VSS"),
               at=(g1, yN), gate_ext=(0.18, 0.18))
    m2 = c.mos("nmos", w=Wn, l=L, nf=1, gates="Q",  sd=("QB", "VSS"),
               at=(g2, yN), gate_ext=(0.18, 0.18))
    # pull-up pmos: P1 (Q-VDD, gate QB at g1), P2 (QB-VDD, gate Q at g2)
    p1 = c.mos("pmos", w=Wp, l=L, nf=1, gates="QB", sd=("Q", "VDD"),
               at=(g1, yP), gate_ext=(0.18, 0.18), well=False)
    p2 = c.mos("pmos", w=Wp, l=L, nf=1, gates="Q",  sd=("QB", "VDD"),
               at=(g2, yP), gate_ext=(0.18, 0.18), well=False)

    # ---- local metal (m1) ------------------------------------------
    def pad_at(obj, net):
        """m1 pad with a c0 contact on shape obj (diffusion or gate)."""
        cx = obj.cx if obj.w > obj.h else obj.cx
        cy = obj.cy if obj.h > obj.w else obj.cy
        # contact centred on the shape, on the side that gives most room
        v = c.via("poly" if obj.layer == "poly" else "diff", c0,
                  at=(cx, cy), net=net, dir="h")
        c.rect(c1, x0=v.lower.cx - pad / 2, x1=v.lower.cx + pad / 2,
               y0=v.lower.cy - pad / 2, y1=v.lower.cy + pad / 2, net=net)
        return v.upper

    # node Q: m1 strap joining M0 drain, M1 source, P1 source
    q = c.rect(c1, x0=dQ - m1w / 2, x1=dQ + m1w / 2,
               y0=min(m0.sd[1].bottom, m1.sd[0].bottom, p1.sd[0].bottom) - m1s,
               y1=max(m0.sd[1].top, m1.sd[0].top, p1.sd[0].top) + m1s, net="Q")
    for s in (m0.sd[1], m1.sd[0], p1.sd[0]):
        c.via("diff", c0, at=(s.cx, s.cy), net="Q", dir="v")
    # node QB
    qb = c.rect(c1, x0=dQB - m1w / 2, x1=dQB + m1w / 2,
                y0=min(m3.sd[1].bottom, m2.sd[0].bottom, p2.sd[0].bottom) - m1s,
                y1=max(m3.sd[1].top, m2.sd[0].top, p2.sd[0].top) + m1s, net="QB")
    for s in (m3.sd[1], m2.sd[0], p2.sd[0]):
        c.via("diff", c0, at=(s.cx, s.cy), net="QB", dir="v")

    # gate drive: QB -> gates of M1/P1 ; Q -> gates of M2/P2
    for g, net, node in ((m1.gates[0], "QB", qb), (p1.gates[0], "QB", qb),
                         (m2.gates[0], "Q", q), (p2.gates[0], "Q", q)):
        c.rect(c1, x0=g.left - m1s, x1=g.right + m1s,
               y0=g.bottom - m1s, y1=g.top + m1s, net=net)
        c.via("poly", c0, at=(g.cx, (g.top + node.bottom) / 2 if net == "QB" else (g.bottom + node.top) / 2),
              net=net, dir="v")

    # WL: m1 strap over the two access gates, contacted to poly
    wl = c.rect(c1, x0=g0 - m1w / 2, x1=g0 + m1w / 2,
                y0=yA - 0.30, y1=yA + 0.30, net="WL")
    c.via("poly", c0, at=(g0, wl.cy), net="WL", dir="v")

    # bit lines: m1 pads on source diffusions
    c.via("diff", c0, at=(m0.sd[0].cx, m0.sd[0].cy), net="BL", dir="v")
    c.via("diff", c0, at=(m3.sd[0].cx, m3.sd[0].cy), net="BLB", dir="v")

    # supplies: shared VDD diffusion (P drains) and VSS diffusion (M drains)
    vddr = c.rect(c1, x0=dVDD - m1w / 2, x1=dVDD + m1w / 2,
                  y0=min(p1.sd[1].bottom, p2.sd[1].bottom) - m1s,
                  y1=max(p1.sd[1].top, p2.sd[1].top) + m1s, net="VDD")
    vssr = c.rect(c1, x0=dVSS - m1w / 2, x1=dVSS + m1w / 2,
                  y0=min(m1.sd[1].bottom, m2.sd[1].bottom) - m1s,
                  y1=max(m1.sd[1].top, m2.sd[1].top) + m1s, net="VSS")
    for s in (p1.sd[1], p2.sd[1]):
        c.via("diff", c0, at=(s.cx, s.cy), net="VDD", dir="v")
    for s in (m1.sd[1], m2.sd[1]):
        c.via("diff", c0, at=(s.cx, s.cy), net="VSS", dir="v")

    # taps: ptap under nmos row, ntap inside nwell
    tp = c.tap("ptap", x0=x + 0.2, x1=x + cell_w - 0.2,
               y0=ybot + 0.15, y1=ybot + 0.55, net="VSS")
    tn = c.tap("ntap", x0=x + 0.2, x1=x + cell_w - 0.2,
               y0=ytop - 0.55, y1=ytop - 0.15, net="VDD")
    c.rect(c1, x0=tp.strap.left - m1s, x1=tp.strap.right + m1s,
           y0=tp.strap.bottom - m1s, y1=tp.strap.top + m1s, net="VSS")
    c.rect(c1, x0=tn.strap.left - m1s, x1=tn.strap.right + m1s,
           y0=tn.strap.bottom - m1s, y1=tn.strap.top + m1s, net="VDD")
    c.via("diff", c0, at=(tp.strap.cx, tp.strap.cy), net="VSS", dir="v")
    c.via("diff", c0, at=(tn.strap.cx, tn.strap.cy), net="VDD", dir="v")

    # well tie: nwell to VDD
    c.rect(c1, x0=x + cell_w / 2 - m1w / 2, x1=x + cell_w / 2 + m1w / 2,
           y0=tn.strap.bottom - m1s, y1=nw.top + m1s, net="VDD")
    c.via("nwell", c0, at=(x + cell_w / 2, nw.top - 0.15), net="VDD", dir="v")

    # ports on c1 for the router (horizontal strips spanning the cell)
    ports = {}
    for net, obj in (("BL", m0.sd[0]), ("BLB", m3.sd[0]), ("WL", wl),
                     ("VDD", vddr), ("VSS", vssr)):
        ports[net] = c.rect(c1, x0=x, x1=x + cell_w,
                            y0=obj.bottom - m1s, y1=obj.top + m1s, net=net)
    return ports, cell_w, cell_h

# ------------------------------------------------------------------ top
TOP = Cell("sram16x8")
cell_w, cell_h = 4.40, 4.60
cols, rows = 8, 16
pitch_x, pitch_y = cell_w + 0.10, cell_h + 0.10

bl_nets = ["BL%d" % i for i in range(8)]
blb_nets = ["BLB%d" % i for i in range(8)]
wl_nets = ["WL%d" % i for i in range(16)]

# place cells and collect per-net port shapes
port_shapes = {n: [] for n in bl_nets + blb_nets + wl_nets + ["VDD", "VSS"]}
for r in range(rows):
    for ccol in range(8):
        wl = wl_nets[r]
        ports, cw, ch = sram6t(TOP, ccol * pitch_x, r * pitch_y,
                               bl_nets[ccol], blb_nets[ccol], wl, "VDD", "VSS")
        for n in bl_nets + blb_nets + wl_nets + ["VDD", "VSS"]:
            port_shapes[n].append(ports[n])

# ------------------------------------------------------------------ global routing
R = Router(TOP, v=c2, h=c3, pin_layer=c1)

# bit lines: one vertical c2 column per column, all cell pins overlap in x
for ccol in range(8):
    pins = [port_shapes[bl_nets[ccol]][r] for r in range(rows)] + \
           [port_shapes[blb_nets[ccol]][r] for r in range(rows)]
    R.add("BL%d" % ccol, *pins)
    R.add("BLB%d" % ccol, *pins)

# word lines: one horizontal c3 trunk per row
for r in range(rows):
    pins = [port_shapes["WL%d" % r][ccol] for ccol in range(8)]
    R.add("WL%d" % r, *pins)

# supplies: vertical c2 rails spanning the array
vdd_pins = [port_shapes["VDD"][r * 8 + ccol] for r in range(rows) for ccol in range(8)]
vss_pins = [port_shapes["VSS"][r * 8 + ccol] for r in range(rows) for ccol in range(8)]
R.add("VDD", *vdd_pins)
R.add("VSS", *vss_pins)

done = R.run()

# ------------------------------------------------------------------ ports
for net, shape in done.items():
    TOP.port(net, on=shape)
for net in ("VDD", "VSS"):
    if net not in done:
        TOP.port(net, on=port_shapes[net][0])

# array bounding box
TOP.bbox  # (0, 0, 8*pitch_x, 16*pitch_y)
