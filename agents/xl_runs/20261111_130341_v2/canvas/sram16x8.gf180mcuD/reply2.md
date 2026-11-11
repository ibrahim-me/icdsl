```
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
```

I have leftover placeholder junk in the WL trunk section (the `for col` loops with `inst = None` and `ref = c`) that will cause issues or at least are messy. Also I reference `c.place` return but don't capture instance refs to get pin locations for WL contacts. The WL m1 stubs in the cell go up to `y0+Hc-m1w-gcs`, and the m2 WL trunk is at `y = r*Hc + Hc/2` which is the MIDDLE of the cell, not the top. That's wrong — the m1 stubs go to the top of the cell but the m2 trunk is in the middle. They won't connect.

Let me rethink the WL connection. The m2 WL trunk runs horizontally through the middle of each row (y = r*Hc + Hc/2). Within each cell, the access gate poly is vertical spanning the nmos diffusion (y around yn_c). I have m1 stubs from gate contacts going UP to the top of the cell. That doesn't reach the middle trunk.

Better approach: Don't route WL to the top. Instead, within each cell, connect the two access gates together and bring ONE connection up to the m2 WL trunk which passes through the cell middle. Or run the m2 WL trunk and contact directly to the gate poly extensions within the cell at the trunk's y-level.

Cleanest: The m2 WL trunk passes horizontally through each cell at y = r*Hc + Hc/2. Within the cell, extend each access gate poly vertically (it already spans the nmos row). Add a contact from m2 trunk down to m1, then m1 to contact on poly gate. But m2->m1 needs via1, m1->poly needs contact. That's a stack: contact(poly-m1) at gate, m1 vertical to trunk level, via1(m1-m2) to trunk.

Alternatively, simpler: run WL in m1 horizontally within the cell connecting the two access gates, then one via stack up to m2 trunk at the cell's right edge or middle. But m1 WL segment would run horizontally across the cell at gate level — it would cross the pulldown/load diffusions? The gate poly strips are vertical; a horizontal m1 segment at the top of the gates (above nmos row) connecting them, staying above the nmos diffusions (y > nmos top) and below pmos row. That's the routing channel. Then one contact up to m2 WL trunk. But the m2 trunk is at cell middle height; the m1 WL segment is at gate-top height. Need vertical m1 + via1 to reach m2 trunk.

This is getting complicated. Let me simplify drastically:

**Run WL entirely in poly horizontally?** No.

**Simplest robust approach:** Make the m2 WL trunk run horizontally, and within each cell place a via stack from m2 trunk down to the access gate poly. Since both access gates in a cell connect to the same WL net, and they're at left (x=0.62) and right (x=4.07), I can run a short m1 horizontal segment at the trunk's y-level connecting two m1 pads, each with a contact to a gate poly extension that reaches that height. But gate poly extensions reaching the trunk height (middle of cell) would cross the routing channel — poly crossing diffusion is fine (it's a gate) but crossing other poly? No other horizontal poly. Poly vertical strips already exist. Extending them vertically to the trunk level just makes longer poly strips — but they'd cross the pmos row / nwell? The trunk is at cell middle (y=Hc/2=2.8), pmos row is at top (yp_c ~ 4.3-0.36=3.94 center). So trunk at 2.8 is below pmos row. Extending access gate poly from nmos row (0.56) up to trunk (2.8) — crosses the middle channel, no diffusion there (only pmos row above at 3.94). OK so poly extension from 0.56 up to ~2.6 is fine (no diffusion in between except nmos at 0.56 which the gate already crosses). Good.

So plan: access gate poly = vertical strip from nmos bottom up to just below the m2 WL trunk. Then contact from that poly up to m1 stub, via1 to m2 trunk. Actually I can put contact directly on poly at trunk height, m1 pad, via1 to m2.

But c.via("poly", c0, ...) makes contact poly->m1 (c0=m1). Then I need m1->m2 via1. Let me do: contact on poly (c.via poly->c0) at (gate_x, trunk_y), then c0 (m1) small pad, then via1 (c0->c2) to m2 trunk. But the m2 trunk is a solid rect; the via1 landing on it connects.

Hmm, but c.via with dir="v" gives lower (on poly) and upper (on c0). Then I need another via c0->c2. Let me just use c.via(c0, c2, at=(gate_x, trunk_y)) for m1->m2, but I need m1 present there. The contact poly->c0 gives me c0 pad. Then via1 c0->c2 at same spot. Then m2 trunk rect covers it. 

Actually, even simpler: since m2 trunk is a solid horizontal rect spanning the cell, and I need to connect it to poly gate, I can do the full stack in one place: contact(poly->m1) + via1(m1->m2) overlapping, sitting on the m2 trunk. Let me place:
- poly gate extended up to trunk_y.
- c.via("poly", c0, at=(gate_x, trunk_y - something)) — contact from poly to m1, the m1 pad is at trunk_y area.
- c.via(c0, c2, at=(gate_x, trunk_y)) — via1 from m1 to m2 trunk.

But the contact (poly->m1) needs the poly to extend to it, and m1 pad needs to be between poly and via1. Let me just place contact on poly with its m1 pad, then via1 on top of that m1 pad going to m2. The m2 trunk rect must cover the via1 upper pad.

This is workable but fiddly. Given I can't run DRC, let me reduce risk by using a **single metal layer for WL within the cell and trunk**: Actually, let me route WL in m1 horizontally across the whole array row? m1 is local; WL needs to go across 8 columns = 40 um. m1 can do that (no restriction). But m1 is also used for VDD/VSS rails and local node metal. WL in m1 horizontal per row, spanning all columns, connecting to access gates via contacts on poly. Then port WL from m1 at the left edge. That avoids m2 for WL entirely! And m2 is free for bit lines.

But wait, can m1 run horizontally across the whole row (40 um) at the gate-top level? Yes, m1 has no issue with length. But it would cross over the pmos row/nwell and other cells' local metal — crossing is fine (different nets crossing on same layer is NOT fine — m1 crossing m1 of different nets would short). Within a row, all cells share the same WL net, so m1 WL line across the row is all one net — good. But it crosses bit-line m2 trunks (different layer, fine) and crosses VDD/VSS m1 rails? VDD/VSS rails are m1 horizontal per cell (or per row?). I made VDD/VSS rails per cell (each cell has its own m1 rail segments). If WL m1 runs continuously across the row, it would cross each cell's VDD/VSS m1 rails (different nets) on the same layer m1 -> short! Bad.

So WL can't be a continuous m1 line crossing VDD/VSS rails. Unless VDD/VSS rails are also continuous and we use m2 for them... Let me use m2 for WL (horizontal trunks) and m2 for bit lines (vertical trunks) — they cross at right angles on the same layer m2 -> that would short BL to WL where they cross! Bad. m2 horizontal WL and m2 vertical BL cross -> same layer crossing different nets = short.

So I need WL and BL on different metal layers. Options:
- WL on m2 (horizontal), BL on m3 (vertical). gf180 has m1..m5. Use m3 for bit lines. Then WL (m2) crosses BL (m3) — different layers, fine (via at crossing? No, they just cross; on different layers they don't connect unless via). Good. But crossings of m2 and m3 create unintended vias? No, crossing different metal layers without a via is just an overlap in projection but they're insulated by dielectric. In GDS they're on different layers, no connection. Fine.

But the router uses c2/c3... I'm not using the router; manual. Let me use:
- WL: m2 horizontal trunks (one per row).
- BL/BLB: m3 vertical trunks (one per column).
- Contacts from m3 BL down to access source: need m3->via3->m2->via1->m1->contact->diffusion? That's a tall stack. Or run BL in m2 vertically and WL in m3 horizontally? Same crossing issue solved by different layers. But then WL (m3) horizontal crosses BL (m2) vertical — different layers, fine.

Either way one of them needs to cross the other on different layers — fine. The issue is contacting from the trunk layer down to the cell devices which are on m1/c0 level.

Let me choose:
- WL: m2 horizontal trunk per row (through cell middle). Connect to access gates via contact stack within cell (poly->m1 contact, m1->m2 via1). 
- BL/BLB: m2 vertical trunk per column? Can't, m2 used for WL. Use m3 for BL/BLB vertical. Connect m3 BL to access source: m3->via3->m2->via1->m1->contact->diffusion. Too many layers; but I can run a short m2 vertical segment in each cell from the access source up to the m3 BL trunk, with via3 to m3. So within cell: contact(diff->m1) on access source, m1 vertical segment up, via1(m1->m2), m2 vertical segment up to m3 trunk level, via3(m2->m3) to m3 BL trunk. That's a lot per cell but workable.

Hmm, this is getting really complex and error-prone without DRC feedback. Let me simplify by using fewer metal layers and accepting a slightly larger cell:

**Simpler scheme:**
- Use m1 for all LOCAL cell connections (rails, storage nodes, bit-line taps, WL taps).
- Use m2 for GLOBAL trunks: WL horizontal (m2) and BL vertical (m2)? They cross on same layer -> short. No.

OK the fundamental issue: WL (horizontal) and BL (vertical) must be on different metal layers. Use m2 for WL (horizontal) and m3 for BL (vertical). Within each cell, connect devices (on c0/m1) to both trunks via short vertical segments.

Let me just commit to this and implement carefully:

Cell internals (m1/c0/poly/diff):
- VSS rail m1 bottom, VDD rail m1 top.
- Storage nodes Q, QB as m1 rectangles in the middle channel.
- Access gate poly vertical strips; WL connection: extend poly up, contact to m1, m1 stub up to m2 WL trunk level, via1 to m2.
- Access source (BL/BLB): contact diff->m1, m1 stub up to m3 BL trunk level... but m3 is high. Instead, run BL trunk in m2 vertically? No, m2 is WL horizontal.

Ugh. Let me swap: **WL on m3 (horizontal), BL on m2 (vertical).** Then:
- BL (m2 vertical trunk) contacts access source: contact(diff->m1), m1 stub up, via1(m1->m2) to m2 BL trunk. Only 2 layers up. Good, m2 is right above m1.
- WL (m3 horizontal trunk) contacts access gate: contact(poly->m1), m1 stub up, via1(m1->m2), m2 stub up, via3(m2->m3) to WL trunk. 3 layers. More complex but WL has only 2 gates per cell; BL has 2 sources per cell.

Actually both WL and BL need 2 connections per cell. Let me balance: put BL on m2 (easier, 2-layer stack) and WL on m3 (3-layer stack). Or vice versa. Number of contacts equal. Let me put **WL on m2** (horizontal trunks, 2-layer stack to gates) and **BL on m3** (vertical trunks, 3-layer stack to sources). WL gates: 2 per cell. BL sources: 2 per cell. Same count. Fine.

Wait, but m2 WL horizontal trunks cross m3 BL vertical trunks — different layers, fine. And m2 WL trunks (horizontal) cross m2? No other m2 horizontal. m3 BL vertical trunks cross each other? No, parallel. Good. m2 WL also crosses VDD/VSS m1 rails — different layers (m2 over m1), fine (insulated). Good.

So:
- m1: VSS rail, VDD rail, storage nodes Q/QB, local stubs.
- m2: WL horizontal trunks (one per row).
- m3: BL/BLB vertical trunks (one per column).

Connections per cell:
1. WL trunk (m2, horizontal at row middle y) to each access gate (poly): contact(poly->m1) on gate extension, m1 vertical to trunk height, via1(m1->m2) to trunk. Actually I can route m1 from gate up to trunk_y then via1 to m2 trunk which passes right there. Since trunk spans the cell horizontally at trunk_y, the via1 just needs to land on the trunk. Good.
2. BL trunk (m3, vertical at column center x) to each access source (diffusion): contact(diff->m1), m1 vertical up, via1(m1->m2), m2 vertical up to trunk height, via3(m2->m3) to m3 trunk. The m3 trunk spans vertically at column center x. So within cell, route from access source up to column-center x then up to trunk. The access sources are at x=0.62 (BL) and x=4.07 (BLB), but column center is x=2.5. So I need m1/m2 to jog horizontally to x=2.5. That adds complexity.

To avoid the horizontal jog, place the BL trunks NOT at column center but... they need to serve all 16 rows at one x per column. The access sources are at fixed x within each cell (0.62 and 4.07). A single vertical trunk can't contact both unless it jogs. 

Alternative: run BL/BLB trunks in m2 vertically but at the access-source x positions? There are two sources per cell (BL at 0.62, BLB at 4.07) and they differ per column. BL trunk for column i must connect to all cells' BL source (x=col*Wc+0.62). So BL trunk x = col*Wc+0.62, BLB trunk x = col*Wc+4.07. Two vertical trunks per column, at the source x positions. They run vertically through all rows. At each cell, contact from m2 trunk down to access source (2-layer stack: contact diff->m1, via1 m1->m2). The m2 trunk passes right over the access source. 

But m2 is also WL horizontal! Conflict again. So BL can't be m2 if WL is m2.

Therefore: WL and BL on different layers, AND BL trunks at source x positions (no jog), AND WL trunks at row middle y (no jog). 

- WL: m3 horizontal trunks at row middle y. Connect to gates: contact(poly->m1), m1 up, via1(m1->m2), m2 up, via3(m2->m3) to trunk. (3-layer stack, but no horizontal jog since gate x is fixed and trunk passes at that x? No—WL trunk is horizontal spanning all columns at row middle y; it passes over every gate x. So via3 from m2 stub up to m3 trunk at the gate's x. Good, no jog.)
- BL: m2 vertical trunks at each access-source x (col*Wc+0.62 for BL, col*Wc+4.07 for BLB). Connect to source: contact(diff->m1), via1(m1->m2) to trunk. (2-layer stack, trunk passes over source.) 

Now m2 BL vertical trunks cross m3 WL horizontal trunks — different layers, fine. m2 BL trunks cross m1 rails — fine. m3 WL trunks cross m1 rails and m2 BL trunks — fine (different layers). 

But wait: m2 BL vertical trunks at x=col*Wc+0.62 and col*Wc+4.07. Adjacent columns: column i BLB at col*Wc+4.07, column i+1 BL at (col+1)*Wc+0.62 = col*Wc+5.62. Gap = 5.62-4.07 = 1.55 between BLB trunk of col i and BL trunk of col i+1. m2 width 0.28, space 0.28. Fine. Within a column, BL at +0.62 and BLB at +4.07, gap 3.45. Fine.

But these m2 vertical trunks run the FULL array height (16*5.6=89.6 um) at x positions that are NOT column centers. The bit-line ports are at the top. Fine. But they pass through every cell; at each cell they contact the access source. Good. However, the m2 vertical trunk also passes over the pmos row, nmos row, storage nodes, etc. of each cell — on m2, crossing m1 storage nodes (different layer, fine) and crossing poly gates (different layer, fine). No shorts since different layers. Good.

Hold on, m2 trunk crossing over the access GATE poly: the gate is poly (different layer), m2 is metal — crossing is fine, no connection unless via. We only put vias at the source contact location. Good.

Now, the m2 BL trunk contacts the access SOURCE diffusion. But the access source is also connected to... MnAL: sd=("Q","BL") so BL is the drain (sd[1]). MnAR: sd=("BLB","QB") so BLB is source (sd[0]). Either way it's a diffusion terminal; contact on it connects to BL/BLB net. Good. And the OTHER terminal (Q or QB) connects to storage node m1. Good.

Now WL connection to gates: MnAL gate=WL, MnAR gate=WL. Both access gates connect to WL trunk. I'll extend both gate polys up to trunk level and contact each. Or connect the two gates with m1 and one contact to trunk. Two contacts is simpler and symmetric. Let me do two contacts (one per gate) each with full stack to m3 WL trunk.

Wait, I said WL on m3. Stack: poly->m1 (contact), m1->m2 (via1), m2->m3 (via3). That's two vias plus contact. The m2 segment is a short vertical stub from m1 up to m3 trunk. Since m3 trunk is horizontal at row-middle y, and m2 BL trunks are vertical at various x — the m2 WL stub is vertical at gate x, going up to m3 trunk. It might cross m2 BL trunks? m2 BL trunks are also m2 — same layer! The m2 WL stub (vertical) and m2 BL trunk (vertical) are parallel, both m2, at different x. No crossing. But the m2 WL stub is vertical and m2 BL trunks are vertical — fine. However, is there any m2 HORIZONTAL segment? No, WL is m3 horizontal. So m2 only has vertical BL trunks and short vertical WL stubs. All vertical m2, at different x. No same-layer crossings. 

But the m2 WL stub goes from m1 (gate contact) up to m3 trunk. It passes through the cell vertically. It might cross m1 storage node metal (Q/QB) — different layer, fine. It might cross poly — fine.

OK this is a workable plan. Let me also reconsider: do I even need m3? gf180 has m1..m5. Using m3 for WL is fine. But the via stack contact->via1->via3 needs m1 and m2 present. c.via handles stacks? `c.via(c0, c2, ...)` cuts a stack with pads. For poly->m1->m2->m3 I'd need multiple vias. Let me just place them individually:
- ct1 = c.via("poly", c0, at=(gate_x, y_contact))  # poly->m1, lower on poly, upper on m1
- m1 pad = ct1.lower (on m1) — actually c.via returns .lower and .upper shapes. For ("poly",c0): lower on poly, upper on c0(m1).
- ct2 = c.via(c0, c2, at=(gate_x, y_mid))  # m1->m2
- ct3 = c.via(c2, c3, at=(gate_x, y_trunk))  # m2->m3, but needs m2 present at that point.

The m2 must exist between ct2 and ct3. I'll draw a small m2 rect connecting ct2.upper to ct3.lower. This is doable but many shapes per cell * 128 cells * 2 gates = lots. It's fine for GDS but let me make sure coordinates are right.

Given the complexity and no DRC run, I'm worried about errors. Let me simplify the WL connection to reduce via stack: 

**Alternative: Run WL in m2 horizontally, and BL in m2 vertically is impossible (same layer cross).** 

**Alternative: Use m1 for WL within cell but make VDD/VSS rails on m2?** Then WL m1 horizontal per row doesn't cross VDD/VSS (m2). But VDD/VSS rails on m2 horizontal per row would cross BL m2 vertical -> same layer short. No.

**Alternative: Put VDD/VSS rails as continuous m1 horizontal lines per ROW (spanning all columns), and WL also m1 per row?** Can't, same layer same row but different nets (WL vs VDD) -> short.

OK the different-layer approach is necessary. Let me just implement m2=BL vertical, m3=WL horizontal. Let me reduce via stack for WL by connecting the two access gates with a local m1 segment and doing ONE via stack to the m3 WL trunk per cell. The two access gates are at x=0.62 and x=4.07 within the cell. Connect them with m1 horizontal segment at some y (above nmos row, in the channel), with contacts on each gate poly. Then one stack from that m1 segment up to m3 WL trunk. But the m1 segment is horizontal at gate-top y; the m3 trunk is at row-middle y (higher). Need vertical m1 + via1 + m2 vertical + via3 to m3. The vertical m1 at some x between the gates. Doable: one vertical m1 jog.

Hmm, still a jog. Two separate stacks (one per gate) avoid the horizontal m1 segment but each is a full 3-layer stack. Let me just do two stacks per cell for WL. It's more vias but conceptually simpler (each gate independently connects to the WL trunk which passes horizontally right above it).

Actually, the WL m3 trunk is horizontal at row-middle y, spanning all columns. At each cell, both access gates (x=0.62 and x=4.07) are under the trunk. So for each gate: contact(poly->m1) at gate, m1 pad, via1(m1->m2), short m2 vertical, via3(m2->m3) to trunk. The m2 vertical stub is at the gate x, from m1 level up to trunk y. Fine.

Let me just implement it. I'll write helper to place a via stack.

Actually, let me reconsider the trunk heights to minimize vertical travel:
- nmos row center yn_c = y0+0.56, diffusion [0.56-0.18, 0.56+0.18] = [0.38, 0.74]. Gate poly spans diffusion height roughly [0.38, 0.74] plus extensions. c.mos gate height = w = Wn = 0.36, so poly [yn_c-0.18, yn_c+0.18] = [0.38, 0.74]. I extend poly up with peg.
- WL m3 trunk at row-middle y = r*Hc + Hc/2 = r*Hc + 2.8. Within cell (y0=r*Hc), trunk at y=2.8.
- Gate poly top at 0.74. Need to get from 0.74 to 2.8. m1 vertical, via1, m2 vertical, via3 to m3 at 2.8.

For BL m2 trunk at x = col*Wc + 0.62 (BL) and col*Wc+4.07 (BLB), running full height. Access source diffusion: MnAL BL is sd[1] (drain). Where is sd[1]? For MnAL at (gx[0]=0.62, yn_c=0.56), sd straps are on the diffusion left/right. sd=("Q","BL"): sd[0]=Q (source side), sd[1]=BL (drain side). The two sd straps are at left and right ends of diffusion. Which x? Probably sd[0] at left, sd[1] at right, or based on orientation. I'll just use the actual shape coords: MnAL.sd[1] is a rect; I contact it.

The BL m2 trunk at x=col*Wc+0.62 must pass over MnAL.sd[1]. Is sd[1] centered at x=0.62? The transistor is placed at at=(gx[0], yn_c) = (0.62, 0.56). Likely the gate/diffusion is centered at at. So sd straps are at x = 0.62 ± (L/2 + extension). The BL strap (sd[1]) is at one end, say x = 0.62 + something. The m2 trunk at x=0.62 might not land on sd[1] which is offset. 

To be safe, don't fix trunk x to gate x. Instead, place the m2 BL trunk and contact the access source wherever it is, with the trunk passing over it. But the trunk is vertical and shared across all rows at fixed x; the access source x is the same in every cell (col*Wc + 0.62 + offset). So trunk x = col*Wc + 0.62 + offset. I can compute offset from the first cell's sd shape. But I place cells via c.place (hierarchy), so I can't easily see inside. 

Better: place cells with known, fixed internal coordinates by defining the cell with absolute coordinates and using `at` as offset. Since c.place(sram6t, at=(col*Wc, r*Hc)) places the cell (which I drew at (0,0) internally) at that offset, everything inside shifts by (col*Wc, r*Hc). So internal coords are predictable: access source BL at x = 0.62 + offset_sd. I need to know offset_sd. 

To avoid depending on c.mos internal strap positions, let me NOT use c.mos's sd straps for the BL connection. Instead, I'll draw the access transistor diffusion myself and place a contact exactly where I want, OR use c.mos but connect BL to the diffusion rect (m.diff) via a contact at a chosen point on the diffusion.

Hmm, c.mos creates the diffusion; I can read m.diff bbox and place a contact on it at a chosen x (e.g., the gate x, but contact on gate area is bad). Let me place contact on the diffusion at the end away from gate.

This is getting too deep. Let me step back and use a cleaner, well-trodden approach: **use the stick/rows or just place transistors and route with the Router?** No.

Given the constraints (no DRC run, must be correct), let me simplify the cell to minimize routing:

**Simplify: Make WL and BL connect using the SAME layer as much as possible by choosing trunk layers that don't cross within the cell.**

New simplest scheme:
- All global trunks on m2: WL horizontal AND BL vertical would cross -> no.
- Use m2 for BL (vertical trunks at source x), m3 for WL (horizontal trunks). Accept the via stacks.

Let me just commit and write it carefully, computing all coordinates explicitly WITHOUT c.mos for the critical connections. I'll draw transistors manually with rect/polygon to have full control over contact locations. Actually c.mos is fine for creating the device (LVS needs the mos device). I'll use c.mos for the transistor itself (so LVS sees it), and route connections using the shape coords I read back.

Let me write the cell with explicit coordinate math and read back strap positions. I'll place transistors at known `at` positions and assume c.mos centers the gate/diffusion at `at`. From inv.py usage, `at=(0,0)` then reading `n.diff.top` works, suggesting diff is positioned relative to at. I'll assume `at` = center of the transistor (gate center = at). Then:
- gate poly: x in [at.x - L/2, at.x + L/2], y in [at.y - W/2, at.y + W/2].
- diffusion: slightly larger, x in [at.x - L/2 - ext, at.x + L/2 + ext], y in [at.y - W/2, at.y + W/2].
- sd straps: two c0 rects at the left and right ends of diffusion.

I'll verify by reading m.diff, m.gates[0], m.sd[0], m.sd[1] bboxes after placement and use THOSE for routing (robust to c.mos internals). For the BL trunk x, I'll set it to the x of the access source strap. Since all cells are identical copies, the strap x relative to cell origin is constant. I'll compute it from the first (0,0) cell placement... but sram6t draws directly into c at `at`, not via place. For the top array I use c.place which creates Refs; I can't read inside Refs easily. 

Solution: Draw the FIRST cell directly to learn coordinates, OR just compute trunk x from the known `at` + assumed strap offset. Risky.

Cleanest: Don't use c.place hierarchy for the array; instead draw all 128 cells directly into the top cell with absolute coordinates (loop calling sram6t(c, at=(col*Wc, r*Hc))). Then I have all shapes in one cell and can read coordinates. Hierarchy is free ("hierarchy is free"), so a flat top is acceptable for LVS. But 128 cells * 6 transistors flat = 768 mos in one cell — fine.

But then ports and trunks: I can route everything with absolute coords. Let me do FLAT: draw all cells directly, then draw trunks and contacts using absolute coordinates computed from cell origin + internal offsets.

But I still need internal strap offsets. Let me have sram6t return the key strap positions (relative to cell origin) so the top can route. I'll return a dict with BL_strap_x, BLB_strap_x, WL_gate_xs, etc. relative to (0,0). Then top uses col*Wc + rel_x.

Let me have sram6t place transistors and return relative coordinates of:
- accessL gate cx, accessR gate cx (for WL)
- accessL BL strap (sd[1]) cx, accessR BLB strap (sd[0]) cx (for BL trunks)
- Q, QB node rects (already local)
- VSS, VDD rails

Then top routes trunks using these relative coords + cell offset.

Let me write it. I'll make sram6t draw into cell c at offset (x0,y0) and return relative info.

For the BL trunk: m2 vertical at x = cell_x0 + rel_BL_x, spanning all rows. Contact at each cell: contact(diff->m1) on the BL strap, via1(m1->m2) to trunk. The trunk passes over the strap. Good, no jog.

For WL trunk: m3 horizontal at y = cell_y0 + rel_WL_y (row middle), spanning all columns. Contact at each cell's each access gate: stack poly->m1->m2->m3. The trunk passes over the gate x. Good.

Wait, but m3 WL trunk horizontal at row-middle y, and m2 BL trunks vertical — they cross (m2 over m3 or m3 over m2) at every (col,row) — different layers, fine, no via unless we place one. We place vias only at gate x (for WL) and source x (for BL). At a crossing where gate x == source x? Gate x (0.62 or 4.07) and source x (0.62 for BL, 4.07 for BLB) — for MnAL, gate x=0.62 and BL source x=0.62 (same!). So at (col*Wc+0.62, row*Hc+2.8) we'd have both a WL via stack (to gate) and a BL via (to source) — same location, different nets (WL and BL) — that would be a short if they connect! They're at the same x but the WL stack goes up to m3 and BL via goes to m2; they share the m1/m2 area? The BL contact is on diffusion (y~0.56) with via1 to m2 trunk at y=2.8? No—BL m2 trunk is vertical spanning all y at x=0.62. The BL contact: contact(diff->m1) at diffusion (y~0.56), via1(m1->m2) connecting m1 to the m2 trunk which passes at x=0.62, all y. So the via1 is at (0.62, ~1.0) connecting to m2 trunk. The WL stack at (0.62, 2.8) connects poly->m1->m2->m3. The m2 at (0.62) is shared between BL trunk and WL stub — but they're the SAME net? No, BL and WL are different nets, both touching m2 at x=0.62 -> SHORT via the m2 metal!

Problem: m2 BL trunk (vertical at x=0.62) and m2 WL stub (vertical at x=0.62) are the same layer m2 and same x -> they'd merge into one m2 shape shorting BL and WL. Bad.

So I can't have both BL trunk and WL stub on m2 at the same x. 

Fix: Put WL on m3 and connect gate directly to m3 without m2 stub? Need poly->m1->m2->m3 (m2 needed as intermediate). The m2 for WL is a stub; if it's at same x as BL m2 trunk, conflict.

Alternative: route WL gate connection on m1 only within the cell, and bring WL trunk in on m1 too but... WL trunk horizontal m1 crosses VDD/VSS m1 rails.

Alternative: Make BL trunks on m3 and WL on m2? Then BL (m3 vertical) crosses WL (m2 horizontal) — different layers fine. BL contact to source: m3->via3->m2->via1->m1->contact (3 layers). WL contact to gate: m2 horizontal trunk, contact poly->m1->m2 (2 layers). Now m2 WL horizontal trunks and m2 WL stubs — all m2 horizontal, fine. m3 BL vertical trunks cross m2 WL horizontals — different layers fine. m3 BL trunk contacts source via stack going down through m2 — but m2 has WL horizontals crossing! The BL via stack (m3->m2->m1) passes through m2 at the source x; if a WL m2 horizontal crosses there, same layer m2 -> the m2 pad of BL stack and WL horizontal merge -> short. 

The fundamental issue: any vertical trunk and horizontal trunk on the same layer short at crossings. So vertical and horizontal trunks MUST be on different layers, AND the via stacks connecting down must not create same-layer conflicts at crossings.

Standard solution: use m2 for one direction (say WL horizontal), m3 for the other (BL vertical). Crossings are m2-over-m3 (different layers, fine). Contacts from devices (m1) up:
- To WL (m2 horizontal): contact poly->m1, via1 m1->m2. m2 stub vertical at gate x up to WL trunk. But m2 also has... only WL horizontals (no vertical m2 trunks if BL is m3). So m2 = WL horizontals only + short vertical stubs at gates. The vertical stubs at gate x: do they cross any m2 horizontal? They connect TO the WL horizontal (same net WL) — merging is fine (same net). Do they cross other WL horizontals? Different rows, different y. Fine. So m2 = WL net only, no conflict with BL (BL is m3). 
- To BL (m3 vertical): contact diff->m1, via1 m1->m2, m2 vertical stub, via3 m2->m3. But m2 is WL net! The m2 vertical stub for BL would be on m2 (WL net) -> shorting BL to WL. Bad.

So the intermediate layer m2 carries WL net; BL can't use m2. BL needs to go from m1 to m3 without m2? via3 is m2->m3, needs m2. There's no direct m1->m3 via. So BL must pass through m2. But m2 is WL net. Conflict.

Resolution: Use m2 for BL (vertical) and m3 for WL (horizontal), and for WL gate connection use m1->m2->m3 but the m2 is shared with BL vertical trunks -> conflict at crossings of WL stub (m2 vertical) with BL trunk (m2 vertical)? They're both vertical, parallel, different x — no crossing. But WL stub (m2 vertical at gate x) and BL trunk (m2 vertical at source x): if gate x == source x (0.62 case), they're the same x -> merge -> short WL and BL on m2. 

For MnAL: gate x=0.62, BL source x = ? If BL source strap is at x=0.62 (same as gate), conflict. But I can choose the BL trunk x to be the source strap x, and the WL stub x to be the gate x. If they differ, no conflict. For MnAL, is the BL strap at the same x as the gate? The gate is at center x=0.62. The BL strap (sd[1]) is at one END of the diffusion, offset from center by ~L/2+extension. So BL strap x ≠ gate x. Good! So WL stub at gate x (0.62), BL trunk at source strap x (0.62 + offset). Different x. No m2 conflict. 

But wait, the BL m2 trunk is vertical at source-strap x, spanning all rows. The WL m2 stub is vertical at gate x, from m1 up to m3 WL trunk. These are both m2 vertical at different x. Do they cross m2 WL horizontals? There are no m2 WL horizontals (WL is m3). m2 only has: BL vertical trunks + WL vertical stubs. All vertical, different x. No same-layer crossings. 

And m3 = WL horizontals only. m3 WL horizontal crosses m2 BL vertical and m2 WL stub — different layers, fine. m3 WL horizontal at row-middle y; the WL stub (m2 vertical) connects to it via via3 at gate x. Fine.

So final scheme:
- m1: rails, storage nodes, local contacts.
- m2: BL/BLB vertical trunks (at source strap x) AND WL vertical stubs (at gate x, short, up to m3). All m2 vertical.
- m3: WL horizontal trunks (at row middle y).

Wait, but then m2 has both BL (net BL) and WL stubs (net WL) — different nets, both m2, vertical, at different x. They run parallel. Do any BL trunk x coincide with any WL stub x? BL trunk x = source strap x of access transistors. WL stub x = gate x of access transistors. For a given cell: MnAL gate x=0.62, MnAL BL strap x = 0.62 + offset1. MnAR gate x=4.07, MnAR BLB strap x = 4.07 + offset2. As long as offset ≠ 0, gate x ≠ source strap x. And across columns, column i BL trunk at col*Wc + (0.62+offset1), column i WL stub at col*Wc+0.62 and col*Wc+4.07. Could column i's WL stub at 4.07 coincide with column i-1's BLB trunk at (i-1)*Wc + (4.07+offset2) = i*Wc - Wc + 4.07 + offset2 = i*Wc + (4.07 - 5.0 + offset2) = i*Wc + (-0.93 + offset2). For this to equal i*Wc+4.07, need offset2 = 5.0, no. So no coincidence generally. But to be safe, offsets are small (~0.3), so all distinct. Good. But DRC might flag m2 shapes of different nets close together — space rule 0.28. BL trunk and WL stub at different x; minimum horizontal gap? WL stub at gate x=0.62 (width via1 ~0.26), BL trunk at source strap x=0.62+offset. If offset ~0.4, gap = 0.4 - widths/2. Might be < 0.28. Risky.

This is getting too risky without DRC. Let me simplify by ELIMINATING m2 sharing: 

**Final clean scheme: separate layers completely, no shared intermediate.**
- m2: WL horizontal trunks only.
- m3: BL/BLB vertical trunks only.
- For WL (m2) to gate: contact poly->m1, via1 m1->m2. m2 stub vertical at gate x up to WL trunk. m2 only has WL (horizontals + vertical stubs, all same net WL). No BL on m2. 
- For BL (m3) to source: contact diff->m1, via1 m1->m2, m2 vertical stub, via3 m2->m3. But this uses m2 for BL! Conflict (m2 is WL net).

Argh, BL needs m2 as intermediate (via3 is m2-m3). Unless I route BL on m2 and WL on m3, symmetric problem.

The only way to avoid intermediate-layer sharing: connect devices directly to the trunk layer with a single via type. Devices are on c0=m1. Trunks:
- If trunk is m2: contact->m1, via1->m2. One intermediate (m1, which is local and net-specific, fine). 
- If trunk is m3: contact->m1, via1->m2, via3->m3. Needs m2 intermediate (shared).

So trunks on m2 are easy (1 via), trunks on m3 need m2 intermediate. 

Solution: Put BOTH WL and BL trunks on m2 but on... they cross (horizontal vs vertical same layer) -> short. 

UNLESS: WL horizontal on m2, BL vertical on m2, but they don't cross because... they must cross (grid). 

OK so one direction must be m3. Let me put WL on m2 (easy, 1 via to gate) and BL on m3 (needs m2 intermediate). For BL, the m2 intermediate is a local stub within the cell (not a global trunk), net BL. But m2 also has WL trunks (net WL) running horizontally. The BL m2 stub (vertical) crosses WL m2 horizontals (same layer m2, different nets) -> SHORT at crossings. 

Unless the BL m2 stub is very short and doesn't reach the WL horizontals? The WL m2 horizontals are at row-middle y (spanning all columns). The BL m2 stub goes from source (y~0.56) up to m3 trunk (high). It MUST cross the WL m2 horizontal at row-middle y (same cell). Same layer m2, different nets BL and WL -> short. 

So m2 intermediate for BL conflicts with m2 WL trunks. 

Therefore: **WL and BL trunks must be on m2 and m3, and the m3 trunk's devices must connect without using m2 where m2 carries the other trunk.** Impossible with single via stack... 

Standard real solution: Use m2 for WL (horizontal), m3 for BL (vertical). Connect BL source to m3 via a stack that goes contact->m1->via1->m2->via3->m3, but route the m2 portion NOT crossing WL by... it has to cross. 

Real SRAMs handle this because the bit line and word line crossings are on different layers and the via stacks are placed at non-crossing locations, OR they use the fact that m2 (BL) and m3 (WL) — wait in real SRAM WL is often polysilicon or a lower metal and BL is higher metal. 

Let me reconsider: **Make WL run in POLY (or m1) locally and m2 for BL only, with WL trunk on m2 horizontal and BL trunk on m3 vertical, and connect WL (m2) to gates via contact->m1->via1->m2 (m2 stub vertical at gate).** m2 = WL only (horizontals + vertical stubs, all net WL). Good, no BL on m2. 
**BL on m3 vertical:** connect source to m3. Needs m2 intermediate but m2 is WL net. CONFLICT.

So BL can't use m3 if m2 is WL. 

**Put BL on m2 (vertical, easy 1-via from source) and WL on m3 (horizontal).** WL to gate: needs m2 intermediate -> m2 is BL net -> conflict (WL m2 stub crosses BL m2 vertical trunks). 

Same problem mirrored.

**Real fix: use m1 for one trunk direction locally and accept crossing via a different layer.** 

Actually, the cleanest: **WL on m2 horizontal, BL on m2 vertical is forbidden.** So:
- WL: m2 horizontal trunks. Connect to gates via m1 local + via1 to m2. (m2 = WL net only.)
- BL: m3 vertical trunks. Connect to sources via m1 local + via1 to m2 + via3 to m3. The m2 here is a LOCAL stub (net BL) within the cell. But m2 also carries WL trunks (net WL) horizontally across the cell. The BL m2 stub (vertical) crosses the WL m2 horizontal (same layer, different net) -> short.

To avoid: route the BL m2 stub in a gap where no WL horizontal is? WL horizontal spans the whole cell width at row-middle y. The BL stub must cross y=row-middle to reach m3. Conflict unavoidable if both on m2.

**Conclusion: I need 3 metal layers with the middle one (m2) used by only ONE trunk direction, and the other trunk direction (m3) connects to devices via m2 — conflict.** 

The actual way SRAMs do it: Word line is often on a DEDICATED layer (like poly or a special WL metal) and bit lines on metal above, so they don't share intermediate. In our PDK, let me use:
- WL: m2 horizontal.
- BL: m3 vertical.
- Connect BL source to m3: but instead of via stack through m2, run a LOCAL m3? No.

Hmm, what if BL connects: source -> contact -> m1 -> (m1 vertical) -> and m1 runs up to m3? via3 is m2-m3, not m1-m3. There's via2 (m2-m3)? gf180 cuts: via1 m1-m2, via2 m2-m3, via3 m3-m4, via4 m4-m5. So m1->m3 needs via1 then via2 (m1->m2->m3). m2 intermediate again.

OK so any m3 connection needs m2. If m2 is WL net, BL can't use m2. 

**Therefore: dedicate m2 to BL (vertical trunks, easy), and put WL on m3 (horizontal), connecting WL to gates via m1->m2->m3 where m2 is a LOCAL WL stub.** But m2 is BL net (vertical trunks). The WL local m2 stub (vertical at gate x, up to m3 WL trunk) crosses BL m2 vertical trunks? Both vertical, parallel, different x — no crossing. But does the WL m2 stub cross BL m2 trunks? No (parallel). Does it cross anything on m2? m2 = BL vertical trunks only (plus WL local vertical stubs). All vertical. The WL stub at gate x and BL trunk at source x — different x. No same-layer crossing. And WL m3 horizontal trunks cross m2 BL vertical trunks — different layers, fine. 

Wait, this works! Let me restate:
- m2: BL/BLB vertical trunks (net BL/BLB) + WL local vertical stubs (net WL, short, from gate up to m3). All m2 shapes are vertical. BL trunks at source-strap x; WL stubs at gate x. Different x (offset ≠ 0). No same-layer crossings. Different nets but separated in x. Need space rule 0.28 between them — ensure x separation ≥ 0.28 + widths. Offset between gate and source strap: diffusion extends ~L/2+ext beyond gate; source strap at the end. Gate at center, source strap at center ± (L/2 + contact_offset). The separation ≈ contact_offset from gate edge. Should be ≥ 0.3. Probably OK but tight. I'll place WL stub and BL trunk at clearly different x.

Actually, simpler: since WL stub and BL trunk are both m2 vertical at different x within a cell, and adjacent cells repeat, the minimum gap between a WL stub (gate x) and nearest BL trunk (source x of same or neighboring cell) must be ≥ 0.28. Let me ensure by choosing geometry: gate x = 0.62, source strap x = 0.62 + 0.5 = 1.12 (say). Gap 0.5 > 0.28. Good. But I don't control strap x precisely. Let me just make the WL stub connect to m3 at the gate x, and BL trunk at source x, and trust they're separated by the diffusion length (~0.28+). The gate and the source contact are on opposite ends of the diffusion typically, separated by ~L = 0.28 plus. Might be exactly 0.28 — borderline. 

To be safe, let me NOT use m2 stubs for WL. Instead:

**Final final scheme (cleanest, no m2 sharing):**
- m2: WL horizontal trunks ONLY (net WL). Connect gate->m1(contact)->via1->m2. m2 stub vertical at gate x. m2 = all WL net. No BL on m2. 
- m3: BL/BLB vertical trunks ONLY. Connect source->m1(contact)->via1->m2->via2->m3. The m2 here is a BL-net stub. CONFLICT with m2 WL net.

No good.

**Use m4 for BL?** m3->m4 via3, m4 trunks vertical. BL: source->m1->via1->m2->via2->m3->via3->m4. Too many, and m2/m3 intermediates conflict.

I think the real intended solution: **WL and BL on different metal layers, and accept that the intermediate m2 is used by both but route so they don't short.** The key insight: the m2 intermediate for the m3 trunk is a SHORT stub inside the cell that does NOT span the full cell, and the m2 trunk of the other direction is also inside... they will cross.

Let me just look at this differently: **Make one of WL/BL run on m1 within the cell and only go up to the trunk layer at the cell edge.** 

- WL trunk: m2 horizontal per row. Within each cell, connect gate to WL trunk via contact->m1->via1->m2 (m2 stub at gate x). m2 = WL net (horizontals + stubs). Fine.
- BL trunk: m3 vertical per column. Within each cell, connect source to BL trunk. Instead of via stack through m2 (WL net), run the source connection in m1 vertically to the TOP of the cell, then... m1 to m3 needs m2. 

No escape from m2 intermediate for m3.

**Therefore the only conflict-free assignment: m2 carries ONE trunk direction globally; the other trunk direction is on m3 and connects to devices using m2 as intermediate ONLY in regions where m2 (the global trunk) isn't present.** Since m2 global trunks span everything, impossible.

UNLESS the global trunk on m2 is only in one direction and the m3 trunk's devices connect via m2 stubs that are the SAME net as... no.

OK, I'll accept: **m2 = WL horizontal trunks (net WL) + m2 vertical stubs for BL (net BL)** and ensure BL m2 stubs don't cross WL m2 horizontals by making the BL m2 stubs NOT go up through the WL horizontal level. But BL trunk is m3 (above m2); to reach m3 from m1 must pass m2. The m2 segment crosses the WL m2 horizontal. Same layer -> short.

I'm convinced: with WL on m2 and BL on m3, the BL connection MUST use m2 which conflicts with WL m2. So swap: **WL on m3, BL on m2.** Then WL connection uses m2 intermediate which conflicts with BL m2 trunks. Symmetric.

The ONLY way out: use a layer ABOVE both for one trunk so its devices connect without crossing the other trunk's layer. E.g.:
- WL: m2 horizontal.
- BL: m4 vertical (skip m3). BL: source->m1->via1->m2->via2->m3->via3->m4. Uses m2 and m3 as intermediates. m2 has WL horizontals -> BL m2/m3 vertical stubs cross WL m2 horizontals -> short on m2. Still conflict on m2.

Any path from m1 to a higher layer passes through m2. If m2 carries WL horizontals (a different net), the vertical stub shorts. 

**So m2 cannot carry WL horizontals if any net needs to pass vertically through m2.** 

Resolution: **m2 carries BL vertical trunks (net BL). WL on m3 horizontal. WL devices connect: gate->m1->via1->m2->via2->m3.** The m2 segment is a WL-net vertical stub at gate x. m2 also has BL vertical trunks (net BL) at source x. Both vertical, parallel, different x -> no crossing. m3 WL horizontals cross m2 BL verticals -> different layers, fine. m3 WL horizontals cross m2 WL stubs -> same net WL, fine (merge). 

This is the scheme I had before that works! m2 = BL vertical trunks + WL vertical stubs (all vertical). m3 = WL horizontal trunks. The only concern is m2 BL trunk (net BL) vs m2 WL stub (net WL) at nearby x — different nets same layer, must maintain 0.28 space. They're at gate x vs source strap x. Let me ensure separation.

Actually, even simpler and safer: **put the WL stub and BL trunk far apart.** WL stub at gate x (center of transistor). BL trunk at source strap x (end of diffusion). Separation ≈ half diffusion length + contact offset ≈ 0.28/2 + ... Let me just make the access transistor diffusion long enough that gate and source-contact are well separated, OR place the BL trunk at the source strap x and WL stub at gate x and verify separation ≥ 