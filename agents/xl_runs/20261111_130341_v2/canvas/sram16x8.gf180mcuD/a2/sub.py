from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2

L = 0.28          # gate length (all devices)
Wn = 0.36         # nmos width
Wp = 0.72         # pmos width
m1w = tech.width(c0)          # 0.23
m2w = tech.width(c2)          # 0.28
cs = 0.22                     # contact size
csp = 0.25                    # contact space
gcs = tech.rule("gate_contact_space")   # 0.15
peg = tech.rule("poly_endcap")          # 0.22
deg = tech.rule("diff_ext_gate")        # 0.23
tds = tech.rule("tap_diff_space")       # 0.32
nwsp = tech.rule("nwell_space") if "nwell_space" in tech.d else 0.6

Wc = 5.0          # cell width  (pitch of columns = bit-line pitch)
Hc = 5.6          # cell height (pitch of rows    = word-line pitch)
COLS, ROWS = 8, 16

def sram6t(c, at):
    x0, y0 = at
    # ---------- rails ----------
    vss = c.rect(c0, x0=x0, x1=x0+Wc, y0=y0, y1=y0+m1w, net="VSS")
    vdd = c.rect(c0, x0=x0, x1=x0+Wc, y0=y0+Hc-m1w, y1=y0+Hc, net="VDD")

    # ---------- transistor x-centres (4 nmos across, 2 pmos above) ----------
    gx = [x0+0.62, x0+1.77, x0+2.92, x0+4.07]   # accessL, pulldownL, pulldownR, accessR
    pgx = [x0+1.195, x0+3.795]                  # loadL (gate QB), loadR (gate Q)

    # ---------- y-levels ----------
    yn_c = y0 + 0.56            # nmos diffusion centre
    yp_c = y0 + Hc - 0.56 - Wp  # pmos diffusion centre

    # ---------- nmos ----------
    MnAL = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("Q", "BL"), at=(gx[0], yn_c))
    MnPL = c.mos("nmos", w=Wn, l=L, nf=1, gates="QB", sd=("VSS", "Q"), at=(gx[1], yn_c))
    MnPR = c.mos("nmos", w=Wn, l=L, nf=1, gates="Q",  sd=("QB", "VSS"), at=(gx[2], yn_c))
    MnAR = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BLB", "QB"), at=(gx[3], yn_c))

    # ---------- pmos (in nwell) ----------
    nwell = c.rect("nwell", x0=x0-0.2, x1=x0+Wc+0.2,
                   y0=yp_c-Wp/2-0.2, y1=yp_c+Wp/2+0.2, net=None)
    MpL = c.mos("pmos", w=Wp, l=L, nf=1, gates="QB", sd=("VDD", "Q"), at=(pgx[0], yp_c), well=False)
    MpR = c.mos("pmos", w=Wp, l=L, nf=1, gates="Q",  sd=("QB", "VDD"), at=(pgx[1], yp_c), well=False)

    # ---------- storage nodes Q / QB (m1) ----------
    def node(rects, net):
        b = c.rect(c0, x0=min(r.left for r in rects), x1=max(r.right for r in rects),
                   y0=min(r.bottom for r in rects), y1=max(r.top for r in rects), net=net)
        for r in rects:
            if not (r.left >= b.left and r.right <= b.right and r.bottom >= b.bottom and r.top <= b.top):
                c.rect(c0, bbox=r.bbox, net=net)
        return b

    # Q: accessL drain(sd[1]), pulldownL source(sd[0]), loadL drain(sd[1])
    Q = node([MnAL.sd[1], MnPL.sd[0], MpL.sd[1]], "Q")
    # QB: accessR source(sd[0]), pulldownR drain(sd[0]), loadR drain(sd[0])
    QB = node([MnAR.sd[0], MnPR.sd[0], MpR.sd[0]], "QB")

    # ---------- WL: m2 horizontal line per row, contact to each access gate ----------
    # (the m2 WL trunk is drawn in the top cell; here we make the local gate tap)
    for mn in (MnAL, MnAR):
        gp = mn.gates[0]
        # extend poly above diffusion for a clean contact landing pad
        c.rect("poly", x0=gp.left, x1=gp.right, y0=gp.top, y1=gp.top+peg, net="WL")
        c.rect("poly", x0=gp.left, x1=gp.right, y0=gp.bottom-peg, y1=gp.bottom, net="WL")
        # contact on the upper poly extension -> m1
        ct = c.via("poly", c0, at=(gp.cx, gp.top+peg/2), net="WL", dir="v")
        # m1 stub from contact up to where the m2 WL trunk will pass (top of cell)
        c.rect(c0, x0=ct.lower.left, x1=ct.lower.right, y0=ct.lower.top, y1=y0+Hc-m1w-gcs, net="WL")

    # ---------- bit-line contacts on access sources (m1 stub up to m2 trunk) ----------
    for mn, net in ((MnAL, "BL"), (MnAR, "BLB")):
        sd = mn.sd[0] if mn is MnAR else mn.sd[1]
        # MnAL: sd=("Q","BL") -> BL is sd[1]; MnAR: sd=("BLB","QB") -> BLB is sd[0]
        src = MnAL.sd[1] if mn is MnAL else MnAR.sd[0]
        ct = c.via("diff", c0, at=(src.cx, src.top-cs/2-gcs), net=net, dir="v")
        c.rect(c0, x0=ct.lower.left, x1=ct.lower.right, y0=ct.lower.top, y1=y0+Hc-m1w-gcs, net=net)

    # ---------- VSS / VDD straps ----------
    # pulldown drains to VSS rail
    for mn in (MnPL, MnPR):
        d = mn.sd[1] if mn is MnPL else mn.sd[0]   # MnPL drain=VSS(sd[1]); MnPR drain=VSS(sd[0])
        c.rect(c0, x0=d.left, x1=d.right, y0=vss.top-m1w, y1=vss.top, net="VSS")
        c.via("diff", c0, at=(d.cx, vss.top-m1w/2), net="VSS", dir="v")
    # pmos sources to VDD rail
    for mp in (MpL, MpR):
        s = mp.sd[0]   # both have source=VDD as sd[0]
        c.rect(c0, x0=s.left, x1=s.right, y0=vdd.bottom, y1=vdd.bottom+m1w, net="VDD")
        c.via("diff", c0, at=(s.cx, vdd.bottom+m1w/2), net="VDD", dir="v")

    # ---------- ports ----------
    c.port("WL", on=MnAL.gates[0])
    c.port("BL", on=MnAL.sd[1])
    c.port("BLB", on=MnAR.sd[0])
    c.port("VDD", on=vdd)
    c.port("VSS", on=vss)
    return dict(w=Wc, h=Hc)

# ------------------------------------------------------------------ top
c = Cell("sram16x8")
cell = sram6t(c, (0, 0))
Wc, Hc = cell["w"], cell["h"]

bl_nets  = ["BL%d"  % i for i in range(8)]
blb_nets = ["BLB%d" % i for i in range(8)]
wl_nets  = ["WL%d"  % i for i in range(16)]

# place the 128 cells
for r in range(ROWS):
    for col in range(COLS):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": bl_nets[col], "BLB": blb_nets[col],
                 "WL": wl_nets[r]}
        c.place(sram6t, at=(col*Wc, r*Hc), name="XB%d_%d" % (r, col), conns=conns)

# ---------- global word lines: m2 horizontal trunks, one per row ----------
for r in range(ROWS):
    y = r*Hc + Hc/2
    c.rect(c2, x0=0, x1=COLS*Wc, y0=y-m2w/2, y1=y+m2w/2, net=wl_nets[r])
    # contact from each cell's WL m1 stub up to the m2 trunk
    for col in range(COLS):
        x = col*Wc + (0.62 if col%2==0 else 4.07)  # access gate x (approx; use cell port)
        inst = None
    # simpler: use the placed instance pin
    for col in range(COLS):
        ref = c  # placeholder

# ---------- global bit lines: m2 vertical trunks, one per column ----------
for col in range(COLS):
    x = col*Wc + Wc/2
    c.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=bl_nets[col])
    c.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=blb_nets[col])

# ---------- ports on top ----------
for i in range(COLS):
    x = i*Wc + Wc/2
    c.port("BL%d" % i,  on=c.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=ROWS*Hc, y1=ROWS*Hc+0.4, net="BL%d" % i))
    c.port("BLB%d" % i, on=c.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=ROWS*Hc, y1=ROWS*Hc+0.4, net="BLB%d" % i))
for r in range(ROWS):
    y = r*Hc + Hc/2
    c.port("WL%d" % r, on=c.rect(c2, x0=0, x1=0.4, y0=y-m2w/2, y1=y+m2w/2, net="WL%d" % r))
c.port("VDD", on=c.rect(c1, x0=0, x1=0.4, y0=ROWS*Hc-m1w, y1=ROWS*Hc, net="VDD"))
c.port("VSS", on=c.rect(c1, x0=0, x1=0.4, y0=0, y1=m1w, net="VSS"))

TOP = c
