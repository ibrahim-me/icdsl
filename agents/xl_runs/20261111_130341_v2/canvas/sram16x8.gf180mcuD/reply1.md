```python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
topm = tech.stack[-1]

# ------------------------------------------------------------------ cell
def sram6t(c, name="sram6t", at=(0, 0)):
    """6T SRAM cell, gf180-scalable (all dims from tech rules)."""
    l = tech.rule("lmin") if "lmin" in tech.d else 0.28
    wn = tech.rule("wn") if "wn" in tech.d else 0.36
    wp = tech.rule("wp") if "wp" in tech.d else 0.72
    poly_w = tech.width("poly")
    diff_w = tech.width("diff")
    m1_w = tech.width(c0)
    cs = tech.rule("contact_size") if "contact_size" in tech.d else 0.22
    csp = tech.rule("contact_space") if "contact_space" in tech.d else 0.25
    gcs = tech.rule("gate_contact_space")
    peg = tech.rule("poly_endcap")
    deg = tech.rule("diff_ext_gate")
    tds = tech.rule("tap_diff_space")
    mw = max(m1_w, cs + 2 * tech.enc(c0, "diff") if False else m1_w)

    # geometry
    aw = max(wn, diff_w) + 2 * deg                      # active width (x)
    ap = max(wp, diff_w) + 2 * deg                      # p active width
    cell_h = 4.0 * deg + 3.0 * poly_w + 2.0 * mw + 2.0 * gcs + 2.0 * cs
    cell_w = 2.0 * aw + 4.0 * poly_w + 6.0 * gcs + 4.0 * cs + 2.0 * mw
    x0, y0 = at

    # rails
    vdd = c.rect(c0, x0=x0, x1=x0 + cell_w, y0=y0 + cell_h - mw, y1=y0 + cell_h, net="VDD")
    vss = c.rect(c0, x0=x0, x1=x0 + cell_w, y0=y0, y1=y0 + mw, net="VSS")

    # n-well over pmos row
    nw_y0 = y0 + cell_h - mw - gcs - cs - ap
    nw = c.rect("nwell", x0=x0 - 0.2, x1=x0 + cell_w + 0.2,
                y0=nw_y0, y1=y0 + cell_h, net=None)

    def act(xc, yc, wd, ht, net, well=None):
        r = c.rect("diff", x0=xc - wd / 2, x1=xc + wd / 2,
                   y0=yc - ht / 2, y1=yc + ht / 2, net=net)
        if well is not None:
            c.rect(well, x0=r.left - 0.2, x1=r.right + 0.2,
                   y0=r.bottom - 0.2, y1=r.top + 0.2, net=None)
        return r

    def poly(xc, yc, wd, ht, net):
        return c.rect("poly", x0=xc - wd / 2, x1=xc + wd / 2,
                      y0=yc - ht / 2, y1=yc + ht / 2, net=net)

    def cont(xc, yc, net):
        return c.via("diff", c0, at=(xc, yc), net=net, dir="h")

    # transistor centres
    yp = y0 + cell_h - mw - gcs - cs - ap / 2          # pmos row
    yn = y0 + mw + gcs + cs + aw / 2                   # nmos row
    xa = x0 + aw / 2 + gcs + cs                        # access left
    xd = x0 + cell_w - aw / 2 - gcs - cs               # access right
    xb = xa + aw + 2 * gcs + 2 * cs                    # pulldown left
    xc_ = xd - aw - 2 * gcs - 2 * cs                   # pulldown right
    xg1 = xa + aw / 2 + gcs                            # gate access-left
    xg2 = xb - aw / 2 - gcs                            # gate pulldown-left (QB)
    xg3 = xc_ + aw / 2 + gcs                           # gate pulldown-right (Q)
    xg4 = xd - aw / 2 - gcs                            # gate access-right

    # transistors
    act(xa, yn, aw, aw, "BL")                          # access-left diffusion
    act(xd, yn, aw, aw, "BLB")                         # access-right diffusion
    act(xb, yn, aw, aw, "VSS")                         # pulldown-left diffusion
    act(xc_, yn, aw, aw, "VSS")                        # pulldown-right diffusion
    act(xa, yp, ap, ap, "Q", well="nwell")             # load-left diffusion (node Q)
    act(xd, yp, ap, ap, "QB", well="nwell")            # load-right diffusion (node QB)
    poly(xg1, yn, poly_w, cell_h - 2 * mw, "WL")       # word line (both access gates)
    poly(xg2, yn, poly_w, cell_h - 2 * mw, "QB")       # gate of pulldown-left & load-left
    poly(xg3, yn, poly_w, cell_h - 2 * mw, "Q")        # gate of pulldown-right & load-right

    # contacts: storage nodes Q / QB
    cont(xa, yn, "Q")                                  # access-left drain -> Q
    cont(xb, yn, "Q")                                  # pulldown-left drain -> Q
    cont(xa, yp, "Q")                                  # load-left drain -> Q
    cont(xd, yn, "QB")                                 # access-right drain -> QB
    cont(xc_, yn, "QB")                                # pulldown-right drain -> QB
    cont(xd, yp, "QB")                                 # load-right drain -> QB

    # VSS straps from pulldown sources
    c.rect(c0, x0=xb - aw / 2, x1=xb + aw / 2, y0=vss.top - mw, y1=vss.top, net="VSS")
    c.rect(c0, x0=xc_ - aw / 2, x1=xc_ + aw / 2, y0=vss.top - mw, y1=vss.top, net="VSS")
    cont(xb, vss.top - mw / 2, "VSS")
    cont(xc_, vss.top - mw / 2, "VSS")

    # VDD straps from load sources
    c.rect(c0, x0=xa - ap / 2, x1=xa + ap / 2, y0=vdd.bottom, y1=vdd.bottom + mw, net="VDD")
    c.rect(c0, x0=xd - ap / 2, x1=xd + ap / 2, y0=vdd.bottom, y1=vdd.bottom + mw, net="VDD")
    cont(xa, vdd.bottom + mw / 2, "VDD")
    cont(xd, vdd.bottom + mw / 2, "VDD")

    # bit-line contacts on access sources (top of access diffusions)
    cont(xa, yn + aw / 2 - cs / 2 - gcs, "BL")
    cont(xd, yn + aw / 2 - cs / 2 - gcs, "BLB")

    # ports
    c.port("WL", on=poly(xg1, yn, poly_w, cell_h - 2 * mw, "WL") if False else None)
    wl_shape = c.rect("poly", x0=xg1 - poly_w / 2, x1=xg1 + poly_w / 2,
                      y0=y0 + mw, y1=y0 + cell_h - mw, net="WL")
    bl_shape = c.rect(c0, x0=xa - cs / 2, x1=xa + cs / 2,
                      y0=yn + aw / 2 - cs, y1=yn + aw / 2 + cs, net="BL")
    blb_shape = c.rect(c0, x0=xd - cs / 2, x1=xd + cs / 2,
                       y0=yn + aw / 2 - cs, y1=yn + aw / 2 + cs, net="BLB")
    c.port("WL", on=wl_shape)
    c.port("BL", on=bl_shape)
    c.port("BLB", on=blb_shape)
    c.port("VDD", on=vdd)
    c.port("VSS", on=vss)
    return dict(w=cell_w, h=cell_h, x0=x0, y0=y0)

# ------------------------------------------------------------------ top
c = Cell("sram16x8")
cell = sram6t(c)
cw, ch = cell["w"], cell["h"]
cols, rows = 8, 16
pitch_x = cw
pitch_y = ch

bl_nets = ["BL%d" % i for i in range(8)]
blb_nets = ["BLB%d" % i for i in range(8)]
wl_nets = ["WL%d" % i for i in range(16)]

# place array
for r in range(rows):
    for col in range(cols):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": bl_nets[col], "BLB": blb_nets[col],
                 "WL": wl_nets[r]}
        c.place(sram6t, at=(col * pitch_x, r * pitch_y),
                name="XB%d_%d" % (r, col), conns=conns)

# word lines: horizontal m2 strips per row
for r in range(rows):
    y = r * pitch_y + ch / 2
    wl = c.rect(c2, x0=0, x1=cols * pitch_x, y0=y - c2_w / 2 if False else y - 0.115,
                y1=y + 0.115, net=wl_nets[r])
    for col in range(cols):
        inst = c.place  # placeholder
    # contact from WL port of each cell to the m2 line
    for col in range(cols):
        pass

# bit lines: vertical m2 strips per column
for col in range(cols):
    x = col * pitch_x + cw / 2
    c.rect(c2, x0=x - 0.115, x1=x + 0.115, y0=0, y1=rows * pitch_y, net=bl_nets[col])
    c.rect(c2, x0=x - 0.115, x1=x + 0.115, y0=0, y1=rows * pitch_y, net=blb_nets[col])

# rails
c.rect(c1, x0=0, x1=cols * pitch_x, y0=0, y1=0.3, net="VSS")
c.rect(c1, x0=0, x1=cols * pitch_x, y0=rows * pitch_y - 0.3, y1=rows * pitch_y, net="VDD")

# ports
for i in range(8):
    c.port("BL%d" % i, on=c.rect(c2, x0=i * pitch_x + cw / 2 - 0.115, x1=i * pitch_x + cw / 2 + 0.115,
                                 y0=rows * pitch_y, y1=rows * pitch_y + 0.3, net="BL%d" % i))
    c.port("BLB%d" % i, on=c.rect(c2, x0=i * pitch_x + cw / 2 - 0.115, x1=i * pitch_x + cw / 2 + 0.115,
                                  y0=rows * pitch_y, y1=rows * pitch_y + 0.3, net="BLB%d" % i))
for r in range(16):
    c.port("WL%d" % r, on=c.rect(c2, x0=0, x1=0.3, y0=r * pitch_y + ch / 2 - 0.115,
                                 y1=r * pitch_y + ch / 2 + 0.115, net="WL%d" % r))
c.port("VDD", on=c.rect(c1, x0=0, x1=0.3, y0=rows * pitch_y - 0.3, y1=rows * pitch_y, net="VDD"))
c.port("VSS", on=c.rect(c1, x0=0, x1=0.3, y0=0, y1=0.3, net="VSS"))

TOP = c
``````python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2

# ---------------- technology numbers (portable) ----------------
l  = tech.rule("lmin") if "lmin" in tech.d else 0.28
wn = tech.rule("wn")   if "wn"   in tech.d else 0.36
wp = tech.rule("wp")   if "wp"   in tech.d else 0.72
pw = tech.width("poly")
dw = tech.width("diff")
m1w = tech.width(c0)
cs  = tech.rule("contact_size") if "contact_size" in tech.d else 0.22
csp = tech.rule("contact_space") if "contact_space" in tech.d else 0.25
gcs = tech.rule("gate_contact_space")
peg = tech.rule("poly_endcap")
deg = tech.rule("diff_ext_gate")

def enc(outer, inner):
    e = tech.enc(outer, inner)
    return e[0] if isinstance(e, (tuple, list)) else e

# ---------------- 6T SRAM cell -------------------------------------
def sram6t(c, name="sram6t", at=(0, 0)):
    x0, y0 = at
    aw = max(wn, dw) + 2 * deg          # n active width
    ap = max(wp, dw) + 2 * deg          # p active width
    ch = 4 * deg + 3 * pw + 2 * m1w + 2 * gcs + 2 * cs
    cw = 2 * aw + 4 * pw + 6 * gcs + 4 * cs + 2 * m1w

    # rails
    vdd = c.rect(c0, x0=x0, x1=x0 + cw, y0=y0 + ch - m1w, y1=y0 + ch, net="VDD")
    vss = c.rect(c0, x0=x0, x1=x0 + cw, y0=y0, y1=y0 + m1w, net="VSS")
    nw = c.rect("nwell", x0=x0 - 0.2, x1=x0 + cw + 0.2,
                y0=y0 + ch - m1w - gcs - cs - ap, y1=y0 + ch, net=None)

    def act(xc, yc, wd, ht, net):
        return c.rect("diff", x0=xc - wd / 2, x1=xc + wd / 2,
                      y0=yc - ht / 2, y1=yc + ht / 2, net=net)

    def poly(xc, yc, wd, ht, net):
        return c.rect("poly", x0=xc - wd / 2, x1=xc + wd / 2,
                      y0=yc - ht / 2, y1=yc + ht / 2, net=net)

    def cont(xc, yc, net):
        return c.via("diff", c0, at=(xc, yc), net=net, dir="h")

    yp = y0 + ch - m1w - gcs - cs - ap / 2
    yn = y0 + m1w + gcs + cs + aw / 2
    xa = x0 + aw / 2 + gcs + cs
    xd = x0 + cw - aw / 2 - gcs - cs
    xb = xa + aw + 2 * gcs + 2 * cs
    xc_ = xd - aw - 2 * gcs - 2 * cs
    xg1 = xa + aw / 2 + gcs
    xg2 = xb - aw / 2 - gcs
    xg3 = xc_ + aw / 2 + gcs
    xg4 = xd - aw / 2 - gcs

    act(xa, yn, aw, aw, "BL")      # access-left diffusion
    act(xd, yn, aw, aw, "BLB")     # access-right diffusion
    act(xb, yn, aw, aw, "VSS")     # pulldown-left diffusion
    act(xc_, yn, aw, aw, "VSS")    # pulldown-right diffusion
    act(xa, yp, ap, ap, "Q")       # load-left diffusion (node Q)
    act(xd, yp, ap, ap, "QB")      # load-right diffusion (node QB)
    poly(xg1, yn, pw, ch - 2 * m1w, "WL")   # word line = both access gates
    poly(xg2, yn, pw, ch - 2 * m1w, "QB")   # gate of pulldown-left & load-left
    poly(xg3, yn, pw, ch - 2 * m1w, "Q")    # gate of pulldown-right & load-right

    # storage node contacts
    cont(xa, yn, "Q"); cont(xb, yn, "Q"); cont(xa, yp, "Q")
    cont(xd, yn, "QB"); cont(xc_, yn, "QB"); cont(xd, yp, "QB")

    # VSS straps (pulldown sources)
    c.rect(c0, x0=xb - aw / 2, x1=xb + aw / 2, y0=vss.top - m1w, y1=vss.top, net="VSS")
    c.rect(c0, x0=xc_ - aw / 2, x1=xc_ + aw / 2, y0=vss.top - m1w, y1=vss.top, net="VSS")
    cont(xb, vss.top - m1w / 2, "VSS"); cont(xc_, vss.top - m1w / 2, "VSS")

    # VDD straps (load sources)
    c.rect(c0, x0=xa - ap / 2, x1=xa + ap / 2, y0=vdd.bottom, y1=vdd.bottom + m1w, net="VDD")
    c.rect(c0, x0=xd - ap / 2, x1=xd + ap / 2, y0=vdd.bottom, y1=vdd.bottom + m1w, net="VDD")
    cont(xa, vdd.bottom + m1w / 2, "VDD"); cont(xd, vdd.bottom + m1w / 2, "VDD")

    # bit-line contacts on access sources
    cont(xa, yn + aw / 2 - cs / 2 - gcs, "BL")
    cont(xd, yn + aw / 2 - cs / 2 - gcs, "BLB")

    # ports (exposed cell edges)
    c.port("WL", on=poly(xg1, yn, pw, ch - 2 * m1w, "WL"))
    c.port("BL", on=c.rect(c0, x0=xa - cs / 2, x1=xa + cs / 2,
                           y0=yn + aw / 2 - cs, y1=yn + aw / 2 + cs, net="BL"))
    c.port("BLB", on=c.rect(c0, x0=xd - cs / 2, x1=xd + cs / 2,
                            y0=yn + aw / 2 - cs, y1=yn + aw / 2 + cs, net="BLB"))
    c.port("VDD", on=vdd)
    c.port("VSS", on=vss)
    return cw, ch

# ---------------- top: 16 rows x 8 cols ----------------------------
c = Cell("sram16x8")
cw, ch = sram6t(c)
cols, rows = 8, 16
bl  = ["BL%d"  % i for i in range(8)]
blb = ["BLB%d" % i for i in range(8)]
wl  = ["WL%d"  % i for i in range(16)]

for r in range(rows):
    for col in range(cols):
        c.place(sram6t, at=(col * cw, r * ch),
                name="XB%d_%d" % (r, col),
                conns={"VDD": "VDD", "VSS": "VSS",
                       "BL": bl[col], "BLB": blb[col], "WL": wl[r]})

# word lines: m2 horizontal per row, contact to cell WL port (poly)
m2w = max(tech.width(c2), 0.3)
for r in range(rows):
    y = r * ch + ch / 2
    tr = c.rect(c2, x0=0, x1=cols * cw, y0=y - m2w / 2, y1=y + m2w / 2, net=wl[r])
    for col in range(cols):
        # cell port is the poly WL strip; bring it up to m2 with a via stack
        c.via(c0, c2, at=(col * cw + cw / 2, y), net=wl[r], dir="v")

# bit lines: m2 vertical per column
for col in range(cols):
    x = col * cw + cw / 2
    c.rect(c2, x0=x - m2w / 2, x1=x + m2w / 2, y0=0, y1=rows * ch, net=bl[col])
    c.rect(c2, x0=x - m2w / 2, x1=x + m2w / 2, y0=0, y1=rows * ch, net=blb[col])
    # contacts from cell BL/BLB (c0) up to m2 at each row
    for r in range(rows):
        y = r * ch + ch / 2
        c.via(c0, c2, at=(x, y), net=bl[col], dir="v")
        c.via(c0, c2, at=(x, y), net=blb[col], dir="v")

# global rails on m1 (already span the array via cell rails) + edge ports
c.rect(c1, x0=0, x1=cols * cw, y0=0, y1=0.3, net="VSS")
c.rect(c1, x0=0, x1=cols * cw, y0=rows * ch - 0.3, y1=rows * ch, net="VDD")

for i in range(8):
    c.port("BL%d"  % i, on=c.rect(c2, x0=i * cw + cw / 2 - m2w / 2,
                                  x1=i * cw + cw / 2 + m2w / 2,
                                  y0=rows * ch, y1=rows * ch + 0.4, net="BL%d" % i))
    c.port("BLB%d" % i, on=c.rect(c2, x0=i * cw + cw / 2 - m2w / 2,
                                  x1=i * cw + cw / 2 + m2w / 2,
                                  y0=rows * ch, y1=rows * ch + 0.4, net="BLB%d" % i))
for r in range(16):
    c.port("WL%d" % r, on=c.rect(c2, x0=0, x1=0.4,
                                 y0=r * ch + ch / 2 - m2w / 2,
                                 y1=r * ch + ch / 2 + m2w / 2, net="WL%d" % r))
c.port("VDD", on=c.rect(c1, x0=0, x1=0.4, y0=rows * ch - 0.3, y1=rows * ch, net="VDD"))
c.port("VSS", on=c.rect(c1, x0=0, x1=0.4, y0=0, y1=0.3, net="VSS"))

TOP = c
```