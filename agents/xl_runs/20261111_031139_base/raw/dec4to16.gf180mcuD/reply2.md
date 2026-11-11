```
import klayout.db as kdb

# ---------------------------------------------------------------- technology
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers=dict(
        nwell=(21, 0), diff=(22, 0), poly=(30, 0),
        pplus=(31, 0), nplus=(32, 0), contact=(33, 0), m1=(34, 0),
        via1=(35, 0), m2=(36, 0),
    ),
    label=dict(poly=(30, 10), m1=(34, 10), m2=(36, 10), nwell=(21, 10)),
    contact=dict(size=0.22, space=0.25, enc_diff=0.07, enc_poly=0.07,
                 enc_m1=0.06),
    via1=dict(size=0.26, space=0.26, enc_m1=0.06, enc_m2=0.06),
    width=dict(diff=0.22, poly=0.18, m1=0.23, m2=0.28),
    space=dict(diff=0.28, poly=0.24, m1=0.23, m2=0.28),
    enc=dict(nwell_diff=0.43, poly_endcap=0.22, diff_ext_gate=0.23,
             gate_contact=0.15),
    devices=dict(
        nmos=dict(diff="diff", implant="nplus", l=0.28, w=0.36),
        pmos=dict(diff="diff", implant="pplus", well="nwell", l=0.28, w=0.72),
    ),
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------- helpers
def dbu(um):
    return int(round(um / 0.001))

def G(um):
    return int(round(um / TECH["grid"]))

def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2)))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, cl, ml, x, y):
    c = TECH["contact"]; cs = c["size"]
    rect(cell, cl, x - cs/2, y - cs/2, x + cs/2, y + cs/2)
    rect(cell, ml, x - cs/2 - c["enc_m1"], y - cs/2 - c["enc_m1"],
         x + cs/2 + c["enc_m1"], y + cs/2 + c["enc_m1"])

def via1(cell, x, y):
    v = TECH["via1"]; vs = v["size"]; e = v["enc_m1"]
    rect(cell, TECH["layers"]["via1"], x - vs/2, y - vs/2, x + vs/2, y + vs/2)
    rect(cell, TECH["layers"]["m1"], x - vs/2 - e, y - vs/2 - e,
         x + vs/2 + e, y + vs/2 + e)

def wire(cell, layer, x1, y1, x2, y2, width):
    w = width
    if x1 == x2:
        rect(cell, layer, x1 - w/2, y1, x1 + w/2, y2)
    else:
        rect(cell, layer, x1, y1 - w/2, x2, y1 + w/2)

def transistor(cell, kind, xc, yc, glx, sw, dw, nwell_layer, diff_layer,
               implant_layer, contact_layer, m1_layer, poly_layer,
               label_layer, term, gname):
    """One MOS transistor.
    Diffusion runs horizontally (long in x), y-width = transistor width w.
    Poly gate is a vertical strip at x=glx, width l.
    sw = source contact x, dw = drain contact x (on the diffusion).
    """
    d = TECH["devices"][kind]
    W = d["w"]; Lt = d["l"]
    de = TECH["enc"]["diff_ext_gate"]; pe = TECH["enc"]["poly_endcap"]
    cs = TECH["contact"]["size"]; ce = TECH["contact"]["enc_diff"]
    cenc = TECH["contact"]["enc_m1"]
    # diffusion: long in x from sw to dw (must cover gate + extensions)
    x1 = min(sw, dw) - de
    x2 = max(sw, dw) + de
    rect(cell, diff_layer, x1, yc - W/2, x2, yc + W/2)
    rect(cell, implant_layer, x1 - 0.16, yc - W/2 - 0.16,
         x2 + 0.16, yc + W/2 + 0.16)
    if kind == "pmos":
        rect(cell, nwell_layer, x1 - TECH["enc"]["nwell_diff"],
             yc - W/2 - TECH["enc"]["nwell_diff"],
             x2 + TECH["enc"]["nwell_diff"],
             yc + W/2 + TECH["enc"]["nwell_diff"])
    # gate poly (vertical strip)
    rect(cell, poly_layer, glx - Lt/2, yc - W/2 - pe,
         glx + Lt/2, yc + W/2 + pe)
    # gate contact
    contact(cell, contact_layer, m1_layer, glx, yc)
    label(cell, label_layer, gname, glx, yc)
    # source / drain contacts on diffusion
    contact(cell, contact_layer, m1_layer, sw, yc)
    contact(cell, contact_layer, m1_layer, dw, yc)
    label(cell, label_layer, term + ":S", sw, yc)
    label(cell, label_layer, term + ":D", dw, yc)
    return dict(xc=xc, yc=yc, W=W, glx=glx)

# ---------------------------------------------------------------- build
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
LL = {name: ly.layer(*spec) for name, spec in TECH["label"].items()}

M1W = TECH["width"]["m1"]; M2W = TECH["width"]["m2"]
M2S = TECH["space"]["m2"]
PITCH = 5.6          # cell pitch (x and y)
H = 5.6              # cell height
VDD_Y = H - 0.55
VSS_Y = 0.55
GL_P = H - 1.35      # pmos gate line (y)
GL_N = 1.35          # nmos gate line (y)
PW = 0.72            # pmos width
NW = 0.36            # nmos width
CS = TECH["contact"]["size"]
PWR = TECH["supplies"]["power"]
GND = TECH["supplies"]["ground"]

def inv_cell(cell, x0, y0, ain, aout):
    # rails
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    gx = x0 + PITCH/2
    # pmos: source VDD (left), drain output (right)
    transistor(cell, "pmos", gx, y0 + GL_P, gx,
               x0 + 0.45, x0 + PITCH - 0.45,
               L["nwell"], L["diff"], L["pplus"], L["contact"], L["m1"],
               L["poly"], LL["m1"], "XMp0", ain)
    # nmos: source VSS (left), drain output (right)
    transistor(cell, "nmos", gx, y0 + GL_N, gx,
               x0 + 0.45, x0 + PITCH - 0.45,
               L["nwell"], L["diff"], L["nplus"], L["contact"], L["m1"],
               L["poly"], LL["m1"], "XMn0", ain)
    # join drains to output net (m1 vertical at gx, then out to right edge)
    rect(cell, L["m1"], gx - CS/2, y0 + VSS_Y - M1W/2,
         gx + CS/2, y0 + VDD_Y + M1W/2)
    wire(cell, L["m1"], gx, y0 + VDD_Y, x0 + PITCH - 0.2, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], aout, x0 + PITCH - 0.2, y0 + VDD_Y)
    # input pin on poly at left edge
    label(cell, LL["poly"], ain, x0 + 0.15, y0 + GL_P)

def nand4_cell(cell, x0, y0, ins, out):
    # rails
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    cx = x0 + PITCH/2
    # nmos series chain along x: gates at cx-0.9, cx-0.3, cx+0.3, cx+0.9
    ng = [cx - 0.9, cx - 0.3, cx + 0.3, cx + 0.9]
    # diffusion chain from VSS (left) to output (right), shared between transistors
    x_start = x0 + 0.45
    x_end   = x0 + PITCH - 0.45
    # draw one continuous diffusion for the whole chain
    rect(cell, L["diff"], x_start - TECH["enc"]["diff_ext_gate"],
         y0 + GL_N - NW/2, x_end + TECH["enc"]["diff_ext_gate"],
         y0 + GL_N + NW/2)
    rect(cell, L["nplus"], x_start - 0.16 - TECH["enc"]["diff_ext_gate"],
         y0 + GL_N - NW/2 - 0.16,
         x_end + 0.16 + TECH["enc"]["diff_ext_gate"],
         y0 + GL_N + NW/2 + 0.16)
    # 4 nmos transistors sharing the diffusion (series)
    segs = [x_start, (x_start+x_end)/2 - 0.3, (x_start+x_end)/2 + 0.3, x_end]
    # Actually series: source of t0 = VSS, drain of t0 = source of t1, ... drain of t3 = output
    # contacts at x_start (VSS) and x_end (output); internal nodes are just diffusion (no contact)
    for i, inn in enumerate(ins):
        transistor(cell, "nmos", (ng[i] + cx)/2, y0 + GL_N, ng[i],
                   segs[i], segs[(i+1) % 4] if i < 3 else x_end,
                   L["nwell"], L["diff"], L["nplus"], L["contact"], L["m1"],
                   L["poly"], LL["m1"], "XMn0_%d" % i, inn)
    # fix: rebuild chain contacts properly (source t0 at x_start to VSS, drain t3 at x_end to output)
    # the transistor() already put contacts at segs[i] and segs[i+1]; internal shared nodes get two
    # contacts on same diffusion - that's fine (they connect source/drain of adjacent devices).
    # Ensure t0 source at x_start and t3 drain at x_end:
    # (transistor calls above handle it: t0 sw=x_start, t3 dw=x_end)
    # output node: m1 vertical at x_end from VSS to VDD, route out
    rect(cell, L["m1"], x_end - CS/2, y0 + VSS_Y - M1W/2,
         x_end + CS/2, y0 + VDD_Y + M1W/2)
    wire(cell, L["m1"], x_end, y0 + VDD_Y, x0 + PITCH - 0.2, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], out, x0 + PITCH - 0.2, y0 + VDD_Y)
    # pmos: 4 parallel, each source VDD, drain output, gates at ins
    pg = [x0 + 0.55, x0 + 1.45, x0 + 2.35, x0 + 3.25]
    for i, inn in enumerate(ins):
        transistor(cell, "pmos", pg[i], y0 + GL_P, pg[i],
                   x0 + 0.45, x0 + PITCH - 0.45,
                   L["nwell"], L["diff"], L["pplus"], L["contact"], L["m1"],
                   L["poly"], LL["m1"], "XMp0_%d" % i, inn)
    # join pmos drains to output: all pmos drains at x_end already (same diffusion x range),
    # connect output m1 rail at x_end to each pmos drain via the shared vertical m1 at x_end
    # (drains are on the same diffusion strip which is contacted at x_end)
    for i in range(4):
        label(cell, LL["poly"], ins[i], pg[i] - 0.35, y0 + GL_P)

# ---------------------------------------------------------------- placement
x = 0.0
# column 0: input inverters (4 rows)
for i in range(4):
    inv_cell(top, x, i * PITCH, "A%d" % i, "AB%d" % i)
x += PITCH
# columns 1..4: NAND array 4x4
nand_ins = [
    ["AB0","AB1","AB2","AB3"], ["A0","AB1","AB2","AB3"],
    ["AB0","A1","AB2","AB3"], ["A0","A1","AB2","AB3"],
    ["AB0","AB1","A2","AB3"], ["A0","AB1","A2","AB3"],
    ["AB0","A1","A2","AB3"], ["A0","A1","A2","AB3"],
    ["AB0","AB1","AB2","A3"], ["A0","AB1","AB2","A3"],
    ["AB0","A1","AB2","A3"], ["A0","A1","AB2","A3"],
    ["AB0","AB1","A2","A3"], ["A0","AB1","A2","A3"],
    ["AB0","A1","A2","A3"], ["A0","A1","A2","A3"],
]
nand_out = ["YB%d" % k for k in range(16)]
for row in range(4):
    for col in range(4):
        k = row * 4 + col
        nand4_cell(top, x + col * PITCH, row * PITCH, nand_ins[k], nand_out[k])
x += 4 * PITCH
# columns 5..8: output inverters 4x4
for col in range(4):
    for row in range(4):
        k = col * 4 + row
        inv_cell(top, x + col * PITCH, row * PITCH, "YB%d" % k, "Y%d" % k)
x += 4 * PITCH

# global supply rails (m2) across the top
rail_y = H + 1.6
wire(top, L["m2"], 0, rail_y, x, rail_y, M2W)
wire(top, L["m2"], 0, rail_y + M2W + M2S, x, rail_y + M2W + M2S, M2W)
label(top, LL["m2"], PWR, x/2, rail_y)
label(top, LL["m2"], GND, x/2, rail_y + M2W + M2S)
# connect each cell's rails to global rails
for cx in range(0, int(x / PITCH) + 1):
    cxf = cx * PITCH + PITCH/2
    if cxf > x:
        continue
    via1(top, cxf, rail_y)
    via1(top, cxf, rail_y + M2W + M2S)
    wire(top, L["m1"], cxf, VDD_Y, cxf, rail_y, M1W)
    wire(top, L["m1"], cxf, VSS_Y, cxf, rail_y + M2W + M2S, M1W)

# input pins A0..A3 on left (m1) - expose the poly gate labels to m1
for i in range(4):
    rect(top, L["m1"], -0.6, i * PITCH + GL_N - M1W/2, -0.2,
         i * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "A%d" % i, -0.4, i * PITCH + GL_N)

# output pins Y0..Y15 on right (m1)
for k in range(16):
    col = k // 4; row = k % 4
    rect(top, L["m1"], x + 0.2, row * PITCH + GL_N - M1W/2,
         x + 0.6, row * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "Y%d" % k, x + 0.4, row * PITCH + GL_N)

# supply pins on far left
rect(top, L["m1"], -0.6, rail_y - M1W/2, -0.2, rail_y + M1W/2)
label(top, LL["m1"], PWR, -0.4, rail_y)
rect(top, L["m1"], -0.6, rail_y + M2W + M2S - M1W/2,
     -0.2, rail_y + M2W + M2S + M1W/2)
label(top, LL["m1"], GND, -0.4, rail_y + M2W + M2S)

# boundary
top.shapes(ly.layer(0, 0)).insert(kdb.DBox(dbu(-1), dbu(-1),
                                           dbu(x + 1), dbu(H + 3.2)))
ly.write("dec4to16.gds")
print("bbox um: %.3f x %.3f = %.1f um^2" % (x + 2, H + 4.2, (x + 2) * (H + 4.2)))

```