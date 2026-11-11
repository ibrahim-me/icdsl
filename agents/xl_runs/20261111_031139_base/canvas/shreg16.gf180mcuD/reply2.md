I'll write a clean, complete script. Let me build it carefully with the canvas API.
```
```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0          # first conductor (m1 on gf180mcuD)
m1 = tech.metal(1)
m2 = tech.metal(2)

# ---------------- device sizing (gf180mcuD) ----------------
L   = 0.28            # channel length
WN  = 0.36            # nmos width
WP  = 0.72            # pmos width
gx  = 0.72            # column pitch
row_p = 1.9           # pmos row centre y
row_n = -1.9          # nmos row centre y
gext = 0.55           # gate poly extension beyond diff (y)
dxext = 0.40          # diff extension beyond gate (x)
m1w = 0.30            # m1 wire width
m2w = 0.38            # m2 wire width
cpad = 0.42           # m1 contact pad size

# ---------------- dff cell ----------------
def build_dff(c):
    # each transistor: (kind, gate_net, net_a, net_b, k, row, w)
    # net_a -> sd[0] (left strap), net_b -> sd[1] (right strap)
    trlist = [
        # master latch
        ("pmos","CK","CKB","VDD",0,row_p,WP), ("nmos","CK","CKB","VSS",0,row_n,WN),
        ("pmos","D", "VDD","p1",1,row_p,WP),  ("nmos","D", "VSS","n1",1,row_n,WN),
        ("pmos","CK","p1","m",2,row_p,WP),    ("nmos","CKB","n1","m",2,row_n,WN),
        ("pmos","CKB","m","p2",3,row_p,WP),   ("nmos","CK","m","n2",3,row_n,WN),
        ("pmos","mb","VDD","p2",4,row_p,WP),  ("nmos","mb","n2","VSS",4,row_n,WN),
        ("pmos","m", "VDD","mb",5,row_p,WP),  ("nmos","m", "VSS","mb",5,row_n,WN),
        # slave latch
        ("pmos","Q", "VDD","p3",6,row_p,WP),  ("nmos","Q", "VSS","n3",6,row_n,WN),
        ("pmos","CK","p3","s",7,row_p,WP),    ("nmos","CKB","n3","s",7,row_n,WN),
        ("pmos","CKB","s","p4",8,row_p,WP),   ("nmos","CK","s","n4",8,row_n,WN),
        ("pmos","mb","VDD","p4",9,row_p,WP),  ("nmos","mb","n4","VSS",9,row_n,WN),
        ("pmos","s", "VDD","Q",10,row_p,WP),  ("nmos","s", "VSS","Q",10,row_n,WN),
        # local clock buffer: CK -> CKB
        ("pmos","CK","VDD","CKB",11,row_p,WP),("nmos","CK","VSS","CKB",11,row_n,WN),
    ]

    trs = []
    for kind, gnet, na, nb, k, row, w in trlist:
        t = c.mos(kind, w=w, l=L, nf=1, gates=gnet, sd=(na, nb), at=(k*gx, row),
                  gate_ext=gext)
        trs.append(t)

    # collect terminals per net: m1 contact pads over gate poly and sd straps
    from collections import defaultdict
    terms = defaultdict(list)

    def add_term(shape, net):
        # m1 contact pad over a poly gate or c0 sd strap
        pad = c.rect(m1, w=cpad, h=cpad, center=shape.cx, cy=shape.cy, net=net)
        c.via(c0, m1, at=pad.cx, cy=pad.cy, net=net)
        terms[net].append(pad)

    for t in trs:
        add_term(t.gates[0], t.gates[0].net if hasattr(t.gates[0],'net') else None)
    # The gate net is known from trlist; re-add with correct net:
    terms.clear()
    for (kind, gnet, na, nb, k, row, w), t in zip(trlist, trs):
        add_term(t.gates[0], gnet)
        add_term(t.sd[0], na)
        add_term(t.sd[1], nb)

    # route with two-layer router: columns on m1, trunks on m2, pins on m1
    r = Router(c, v=m1, h=m2, pin_layer=m1)
    for net, pads in terms.items():
        r.add(net, *pads)
    r.run()

    # expose ports on cell edges (m1 shapes at the boundary)
    # D input: left edge, CK input: left edge above D, Q output: right edge
    # VDD/VSS: top/bottom rails
    # Find the m1 contact pads for D, CK, Q nets and extend to edge.
    def edge_port(net, x, y, w, h, dir_):
        pad = c.rect(m1, x0=x, y0=y-w/2, x1=x+w, y1=y+w/2, net=net)
        c.port(net, on=pad, dir=dir_)

    # We need actual terminal locations. Re-derive from terms: use the pads already drawn.
    # Place ports at cell boundary by extending m1 from a terminal of that net to the edge.
    # Simpler: create port pads at fixed edge locations and route a short m1 to a terminal.
    # We'll do that at top level instead; here just mark the nets by leaving terminal pads.
    c.port("D", on=terms["D"][0], dir="in")
    c.port("CK", on=terms["CK"][0], dir="in")
    c.port("Q", on=terms["Q"][-1], dir="out")
    c.port("VDD", on=terms["VDD"][0], dir="in")
    c.port("VSS", on=terms["VSS"][0], dir="in")
    return trs

# ---------------- top cell ----------------
top = Cell("shreg16")
dff = Cell("dff")
build_dff(dff)

# measure dff size from its shapes
import itertools
allb = [s.bbox for s in dff.shapes] if hasattr(dff,'shapes') else None

# place 16 dffs in a row
pitch = 12*gx + 1.6   # width of dff + gap
insts = []
for i in range(16):
    inst = top.place(dff, at=(i*pitch, 0), name="FF%d"%i,
                     conns={"VDD":"VDD","VSS":"VSS","CK":"CK",
                            "D": ("D" if i==0 else "Q%d"%(i-1)),
                            "Q": "Q%d"%i})
    insts.append(inst)

# route CK bus on m2 across all instances
ck_y = row_p + 1.6 + m2w/2
ck_bus = c.rect(m2, x0=0, y0=ck_y-m2w/2, x1=16*pitch, y1=ck_y+m2w/2, net="CK")
# connect each FF CK pin to the bus with m1 drop + via1
for inst in insts:
    ckpin = inst.pin("CK")
    drop = c.rect(m1, x0=ckpin.cx-m1w/2, y0=ckpin.top, x1=ckpin.cx+m1w/2, y1=ck_bus.bottom-m1w/2, net="CK")
    c.via(m1, m2, at=drop.cx, cy=(drop.top+ck_bus.bottom)/2, net="CK")

# route D chain and bring Q outputs to ports on m2
q_y = ck_y + 1.2 + m2w
q_bus = c.rect(m2, x0=0, y0=q_y-m2w/2, x1=16*pitch, y1=q_y+m2w/2, net="Qbus")
# D input port at left
dport = c.rect(m1, x0=-1.0, y0=row_n-1.2-m1w/2, x1=0.0, y1=row_n-1.2+m1w/2, net="D")
top.port("D", on=dport, dir="in")
# connect D port to FF0.D
ff0 = insts[0]
dpin = ff0.pin("D")
c.rect(m1, x0=dport.right, y0=dport.cy-m1w/2, x1=dpin.left-m1w/2, y1=dport.cy+m1w/2, net="D")
c.rect(m1, x0=dpin.left-m1w/2, y0=dpin.bottom-m1w/2, x1=dpin.right+m1w/2, y1=dpin.top+m1w/2, net="D")

# chain Q(i) -> D(i+1), and bring each Q to q_bus then to port
qorder = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
for i,inst in enumerate(insts):
    qpin = inst.pin("Q")
    # vertical m1 from qpin up to q_bus
    v = c.rect(m1, x0=qpin.cx-m1w/2, y0=qpin.top, x1=qpin.cx+m1w/2, y1=q_bus.bottom-m1w/2, net="Q%d"%i)
    c.via(m1, m2, at=v.cx, cy=(v.top+q_bus.bottom)/2, net="Q%d"%i)
    # port on q_bus at this x
    qp = c.rect(m2, x0=qpin.cx-m2w/2, y0=q_bus.bottom-m2w/2, x1=qpin.cx+m2w/2, y1=q_bus.top+m2w/2, net="Q%d"%i)
    top.port("Q%d"%i, on=qp, dir="out")
    if i < 15:
        dpin_next = insts[i+1].pin("D")
        # m1 horizontal from qpin to dpin_next at qpin row, then up
        h = c.rect(m1, x0=qpin.right, y0=qpin.cy-m1w/2, x1=dpin_next.left-m1w/2, y1=qpin.cy+m1w/2, net="Q%d"%i)
        c.rect(m1, x0=dpin_next.left-m1w/2, y0=dpin_next.bottom-m1w/2, x1=dpin_next.right+m1w/2, y1=dpin_next.top+m1w/2, net="Q%d"%i)

# VDD / VSS rails on m2 top and bottom
vdd_y = ck_y + 2.6 + m2w
vss_y = row_n - 1.6 - m2w
vdd = c.rect(m2, x0=0, y0=vdd_y-m2w/2, x1=16*pitch, y1=vdd_y+m2w/2, net="VDD")
vss = c.rect(m2, x0=0, y0=vss_y-m2w/2, x1=16*pitch, y1=vss_y+m2w/2, net="VSS")
for inst in insts:
    for net, rail in (("VDD",vdd),("VSS",vss)):
        pin = inst.pin(net)
        drop = c.rect(m1, x0=pin.cx-m1w/2, y0=pin.top if net=="VDD" else pin.bottom,
                      x1=pin.cx+m1w/2, y1=rail.bottom-m1w/2 if net=="VDD" else rail.top+m1w/2, net=net)
        c.via(m1, m2, at=drop.cx, cy=(drop.top+rail.bottom)/2 if net=="VDD" else (drop.bottom+rail.top)/2, net=net)

top.port("VDD", on=vdd, dir="in")
top.port("VSS", on=vss, dir="in")
top.port("CK", on=ck_bus, dir="in")

TOP = top
```