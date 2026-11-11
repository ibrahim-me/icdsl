```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------- PDK parameters (gf180mcuD) ----------------
L = 0.28
pw = 0.72   # pmos width
nw = 0.36   # nmos width
gx = 0.66   # column pitch
tw_p = pw   # pmos diffusion track width (= width)
tw_n = nw   # nmos diffusion track width
row_p = 2.9
row_n = 0.0
dx_ext = 0.45          # diff extension beyond gate
gate_ext_y = 0.55      # poly extension beyond diff
m1w = 0.30
m2w = 0.40
via_en = 0.06

def contact_pad(cx, cy, w=0.5, h=0.5):
    return (cx - w/2, cy - h/2, cx + w/2, cy + h/2)

# ---------------- dff cell ----------------
dff = Cell("dff")

def mos(kind, x, y, gate_net, s_net, d_net, w):
    tr = dff.mos(kind, w=w, l=L, gates=gate_net, sd=(s_net, d_net), at=(x, y))
    return tr

# column x positions
xs = [k * gx for k in range(11)]

# pmos row (top), nmos row (bottom)
tr = {}
# master latch pmos
tr['p0_0'] = mos('pmos', xs[0], row_p, 'CK', 'CKB', 'VDD', pw)
tr['p0_1'] = mos('pmos', xs[1], row_p, 'D',  'VDD', 'p1',  pw)
tr['p0_2'] = mos('pmos', xs[2], row_p, 'CK', 'p1',  'm',   pw)
tr['p0_3'] = mos('pmos', xs[3], row_p, 'CKB','m',   'p2',  pw)
tr['p0_4'] = mos('pmos', xs[4], row_p, 'mb', 'VDD', 'p2',  pw)
tr['p0_5'] = mos('pmos', xs[5], row_p, 'm',  'VDD', 'mb',  pw)
# master latch nmos
tr['n0_0'] = mos('nmos', xs[0], row_n, 'CK', 'CKB', 'VSS', nw)
tr['n0_1'] = mos('nmos', xs[1], row_n, 'D',  'VSS', 'n1',  nw)
tr['n0_2'] = mos('nmos', xs[2], row_n, 'CKB','n1',  'm',   nw)
tr['n0_3'] = mos('nmos', xs[3], row_n, 'CK', 'm',   'n2',  nw)
tr['n0_4'] = mos('nmos', xs[4], row_n, 'mb', 'n2',  'VSS', nw)
tr['n0_5'] = mos('nmos', xs[5], row_n, 'm',  'VSS', 'mb',  nw)
# slave latch pmos
tr['p7_0'] = mos('pmos', xs[6], row_p, 'Q',  'VDD', 'p3',  pw)
tr['p7_1'] = mos('pmos', xs[7], row_p, 'CK', 'p3',  's',   pw)
tr['p7_2'] = mos('pmos', xs[8], row_p, 'CKB','s',   'p4',  pw)
tr['p7_3'] = mos('pmos', xs[9], row_p, 'mb', 'VDD', 'p4',  pw)
tr['p7_4'] = mos('pmos', xs[10],row_p, 's',  'VDD', 'Q',   pw)
# slave latch nmos
tr['n7_0'] = mos('nmos', xs[6], row_n, 'Q',  'VSS', 'n3',  nw)
tr['n7_1'] = mos('nmos', xs[7], row_n, 'CKB','n3',  's',   nw)
tr['n7_2'] = mos('nmos', xs[8], row_n, 'CK', 's',   'n4',  nw)
tr['n7_3'] = mos('nmos', xs[9], row_n, 'mb', 'n4',  'VSS', nw)
tr['n7_4'] = mos('nmos', xs[10],row_n, 's',  'VSS', 'Q',   nw)

# helper: m1 contact on a diff strap (sd[i]) with c0->m1 via
def diff_contact(tr_obj, idx, net):
    sd = tr_obj.sd[idx]
    cx = sd.cx; cy = sd.cy
    pad = dff.rect(m1, *contact_pad(cx, cy, 0.5, 0.5), net=net)
    dff.via(c0, m1, at=(cx, cy), net=net)
    return pad

# helper: m1 contact on gate poly with c0->m1 via
def gate_contact(tr_obj, net):
    g = tr_obj.gates[0]
    cx = g.cx; cy = g.top + 0.30   # contact on poly extension above diff
    pad = dff.rect(m1, *contact_pad(cx, cy, 0.5, 0.5), net=net)
    dff.via(c0, m1, at=(cx, cy), net=net)
    return pad

# route each net: collect terminals and connect with m1
from collections import defaultdict
net_terminals = defaultdict(list)

def add_term(shape, net):
    net_terminals[net].append(shape)

# diffusion terminals (source/drain straps)
for name, t in tr.items():
    parts = name.split('_')
    # p0_0 -> kind p, latch 0, idx 0 ; sd[0]=source, sd[1]=drain
    # we connect both straps to their nets
    add_term(diff_contact(t, 0, t.sd_net[0] if hasattr(t,'sd_net') else None), None)

# Better: we know the nets from construction. Let me just connect sd straps directly.
# Rebuild: for each transistor, connect sd[0] and sd[1] to their nets.
# We stored nets in the mos call; re-derive from a parallel dict.
sd_nets = {
 'p0_0':('CKB','VDD'),'p0_1':('VDD','p1'),'p0_2':('p1','m'),'p0_3':('m','p2'),'p0_4':('VDD','p2'),'p0_5':('VDD','mb'),
 'n0_0':('CKB','VSS'),'n0_1':('VSS','n1'),'n0_2':('n1','m'),'n0_3':('m','n2'),'n0_4':('n2','VSS'),'n0_5':('VSS','mb'),
 'p7_0':('VDD','p3'),'p7_1':('p3','s'),'p7_2':('s','p4'),'p7_3':('VDD','p4'),'p7_4':('VDD','Q'),
 'n7_0':('VSS','n3'),'n7_1':('n3','s'),'n7_2':('s','n4'),'n7_3':('n4','VSS'),'n7_4':('VSS','Q'),
}
for name, t in tr.items():
    s_net, d_net = sd_nets[name]
    add_term(diff_contact(t, 0, s_net), s_net)
    add_term(diff_contact(t, 1, d_net), d_net)

# gate terminals
for name, t in tr.items():
    gate_net = t.gates[0].net  # may not be set; we know from construction
# We need gate nets. Re-derive:
gate_nets = {
 'p0_0':'CK','p0_1':'D','p0_2':'CK','p0_3':'CKB','p0_4':'mb','p0_5':'m',
 'n0_0':'CK','n0_1':'D','n0_2':'CKB','n0_3':'CK','n0_4':'mb','n0_5':'m',
 'p7_0':'Q','p7_1':'CK','p7_2':'CKB','p7_3':'mb','p7_4':'s',
 'n7_0':'Q','n7_1':'CKB','n7_2':'CK','n7_3':'mb','n7_4':'s',
}
for name, t in tr.items():
    gnet = gate_nets[name]
    add_term(gate_contact(t, gnet), gnet)

# Connect each net's terminals with m1: horizontal trunk per row + vertical drops
def connect_net(net, terminals):
    if not terminals:
        return
    # group terminals by row (y center)
    byrow = defaultdict(list)
    for t in terminals:
        byrow[round(t.cy, 3)].append(t)
    # for each row, run a horizontal m1 trunk spanning the terminals, with vertical drops
    trunk_ys = []
    for y, ts in sorted(byrow.items()):
        xs0 = min(t.left for t in ts); xs1 = max(t.right for t in ts)
        trunk = dff.rect(m1, xs0 - m1w/2, y - m1w/2, xs1 + m1w/2, y + m1w/2, net=net)
        trunk_ys.append((y, trunk))
        for t in ts:
            # vertical drop from terminal to trunk
            if t.cy < y:
                y0, y1 = t.top, trunk.bottom
            else:
                y0, y1 = trunk.top, t.bottom
            if y1 - y0 < 0.05:
                continue
            drop = dff.rect(m1, t.cx - m1w/2, y0, t.cx + m1w/2, y1, net=net)
            # via from terminal (c0 strap or poly) to m1 drop: terminal already has m1 pad via contact_pad
            # connect drop to the m1 pad that sits on the terminal
            pass
    # connect row trunks vertically at median x
    if len(trunk_ys) > 1:
        xs_all = [t.cx for ts in byrow.values() for t in ts]
        mx = sum(xs_all)/len(xs_all)
        ys = [y for y,_ in trunk_ys]
        for i in range(len(ys)-1):
            dff.rect(m1, mx - m1w/2, trunk_ys[i][1].top, mx + m1w/2, trunk_ys[i+1][1].bottom, net=net)

for net, terms in net_terminals.items():
    connect_net(net, terms)

# Expose D, Q, CK, VDD, VSS on edges with m1 shapes
# D input: left edge, connect to net D terminals (gates of p0_1/n0_1)
D_shape = dff.rect(m1, -1.2, row_n - m1w/2, -0.2, row_n + m1w/2, net="D")
# connect D_shape to D net terminals via horizontal m1 at row_n
d_terms = net_terminals['D']
if d_terms:
    dx = min(t.left for t in d_terms)
    dff.rect(m1, D_shape.right, row_n - m1w/2, dx - m1w/2, row_n + m1w/2, net="D")
# Q output: right edge
Q_shape = dff.rect(m1, dff.width + 0.2 if hasattr(dff,'width') else xs[-1]+gx, row_p - m1w/2,
                   dff.width + 1.2 if hasattr(dff,'width') else xs[-1]+gx+1.0, row_p + m1w/2, net="Q")
q_terms = net_terminals['Q']
if q_terms:
    dx = max(t.right for t in q_terms)
    dff.rect(m1, dx + m1w/2, row_p - m1w/2, Q_shape.left - m1w/2, row_p + m1w/2, net="Q")
# CK: top edge
CK_shape = dff.rect(m1, xs[0] - m1w/2, row_p + 1.6, xs[-1] + m1w/2, row_p + 1.6 + m1w, net="CK")
# connect CK to CK gate terminals
ck_terms = net_terminals['CK']
if ck_terms:
    # vertical drops from CK_shape down to each gate trunk
    for t in ck_terms:
        dff.rect(m1, t.cx - m1w/2, CK_shape.bottom, t.cx + m1w/2, row_p + tw_p/2 + gate_ext_y + m1w/2, net="CK")
# VDD rail top, VSS rail bottom
VDD_shape = dff.rect(m1, xs[0] - m1w/2, row_p + 2.6, xs[-1] + m1w/2, row_p + 2.6 + m1w, net="VDD")
VSS_shape = dff.rect(m1, xs[0] - m1w/2, row_n - 2.6 - m1w, xs[-1] + m1w/2, row_n - 2.6, net="VSS")
# connect VDD to VDD terminals (pmos straps)
for net, rail, row in (('VDD', VDD_shape, row_p), ('VSS', VSS_shape, row_n)):
    terms = net_terminals[net]
    for t in terms:
        if t.cy < rail.cy:
            y0, y1 = t.top, rail.bottom
        else:
            y0, y1 = rail.top, t.bottom
        dff.rect(m1, t.cx - m1w/2, y0, t.cx + m1w/2, y1, net=net)

dff.port("D", on=D_shape, dir="in")
dff.port("Q", on=Q_shape, dir="out")
dff.port("CK", on=CK_shape, dir="in")
dff.port("VDD", on=VDD_shape, dir="in")
dff.port("VSS", on=VSS_shape, dir="in")

# ---------------- top cell shreg16 ----------------
top = Cell("shreg16")
pitch = gx * 11 + 1.6
insts = []
for i in range(16):
    inst = top.place(dff, at=(i * pitch, 0), name="FF%d" % i,
                     conns={"VDD": "VDD", "VSS": "VSS", "CK": "CK",
                            "D": ("D" if i == 0 else "Q%d" % (i - 1)),
                            "Q": "Q%d" % i})
    insts.append(inst)

# CK bus on m2
ck_y = row_p + 1.6 + m2w + 0.6
ck_bus = top.rect(m2, 0, ck_y - m2w/2, 16 * pitch, ck_y + m2w/2, net="CK")
for inst in insts:
    ckpin = inst.pin("CK")
    drop = top.rect(m1, ckpin.cx - m1w/2, ckpin.top, ckpin.cx + m1w/2, ck_bus.bottom - m1w/2, net="CK")
    top.via(m1, m2, at=drop.cx, cy=(drop.top + ck_bus.bottom) / 2, net="CK")
top.port("CK", on=ck_bus, dir="in")

# Q bus and D chain
q_y = ck_y + 1.6 + m2w
q_bus = top.rect(m2, 0, q_y - m2w/2, 16 * pitch, q_y + m2w/2, net="Qbus")
# D input port
dport = top.rect(m1, -1.2, row_n - m1w/2, -0.2, row_n + m1w/2, net="D")
top.port("D", on=dport, dir="in")
ff0 = insts[0]
dpin = ff0.pin("D")
top.rect(m1, dport.right, row_n - m1w/2, dpin.left - m1w/2, row_n + m1w/2, net="D")
top.rect(m1, dpin.left - m1w/2, dpin.bottom - m1w/2, dpin.right + m1w/2, dpin.top + m1w/2, net="D")

for i, inst in enumerate(insts):
    qpin = inst.pin("Q")
    v = top.rect(m1, qpin.cx - m1w/2, qpin.top, qpin.cx + m1w/2, q_bus.bottom - m1w/2, net="Q%d" % i)
    top.via(m1, m2, at=v.cx, cy=(v.top + q_bus.bottom) / 2, net="Q%d" % i)
    qp = top.rect(m2, qpin.cx - m2w/2, q_bus.bottom - m2w/2, qpin.cx + m2w/2, q_bus.top + m2w/2, net="Q%d" % i)
    top.port("Q%d" % i, on=qp, dir="out")
    if i < 15:
        dpin_next = insts[i + 1].pin("D")
        h = top.rect(m1, qpin.right, qpin.cy - m1w/2, dpin_next.left - m1w/2, qpin.cy + m1w/2, net="Q%d" % i)
        top.rect(m1, dpin_next.left - m1w/2, dpin_next.bottom - m1w/2, dpin_next.right + m1w/2, dpin_next.top + m1w/2, net="Q%d" % i)

# VDD / VSS rails
vdd_y = q_y + 1.6 + m2w
vss_y = row_n - 2.6 - m2w - 0.6
vdd = top.rect(m2, 0, vdd_y - m2w/2, 16 * pitch, vdd_y + m2w/2, net="VDD")
vss = top.rect(m2, 0, vss_y - m2w/2, 16 * pitch, vss_y + m2w/2, net="VSS")
for inst in insts:
    for net, rail in (("VDD", vdd), ("VSS", vss)):
        pin = inst.pin(net)
        if net == "VDD":
            drop = top.rect(m1, pin.cx - m1w/2, pin.top, pin.cx + m1w/2, rail.bottom - m1w/2, net=net)
            cy = (drop.top + rail.bottom) / 2
        else:
            drop = top.rect(m1, pin.cx - m1w/2, rail.top + m1w/2, pin.cx + m1w/2, pin.bottom, net=net)
            cy = (drop.bottom + rail.top) / 2
        top.via(m1, m2, at=drop.cx, cy=cy, net=net)
top.port("VDD", on=vdd, dir="in")
top.port("VSS", on=vss, dir="in")

TOP = top
```