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

def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2)))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, cl, ml, x, y, enc_outer=None):
    """Contact on lower layer cl, enclosed by upper metal ml."""
    c = TECH["contact"]; cs = c["size"]
    e = enc_outer if enc_outer is not None else c["enc_m1"]
    rect(cell, cl, x - cs/2, y - cs/2, x + cs/2, y + cs/2)
    rect(cell, ml, x - cs/2 - e, y - cs/2 - e, x + cs/2 + e, y + cs/2 + e)

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

# ---------------------------------------------------------------- build
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
LL = {name: ly.layer(*spec) for name, spec in TECH["label"].items()}

M1W = TECH["width"]["m1"]; M2W = TECH["width"]["m2"]
M2S = TECH["space"]["m2"]
PITCH = 6.0          # cell pitch
H = 6.0              # cell height
VDD_Y = H - 0.55
VSS_Y = 0.55
GL_P = H - 1.30      # pmos gate line (y center of pmos diffusion)
GL_N = 1.30          # nmos gate line (y center of nmos diffusion)
PW = 0.72            # pmos width
NW = 0.36            # nmos width
CS = TECH["contact"]["size"]
PWR = TECH["supplies"]["power"]
GND = TECH["supplies"]["ground"]
DE = TECH["enc"]["diff_ext_gate"]   # 0.23
PE = TECH["enc"]["poly_endcap"]     # 0.22
LT = 0.28                           # gate length

def transistor(cell, kind, xc, yc, gate_x, source_x, drain_x,
               nwell_layer, diff_layer, implant_layer,
               contact_layer, m1_layer, poly_layer, label_layer,
               term, gname, gate_contact_y=None):
    """One MOS transistor.
    Diffusion horizontal at y=yc, width W (y), from source_x to drain_x (x).
    Poly gate vertical at x=gate_x, width LT (x).
    Source/drain contacts on diffusion. Gate contact on poly extension
    (above or below diffusion), NOT over diffusion.
    """
    d = TECH["devices"][kind]
    W = d["w"]
    # diffusion bounds (must cover gate + extensions + source/drain contacts)
    x_left = min(source_x, drain_x, gate_x - LT/2) - DE
    x_right = max(source_x, drain_x, gate_x + LT/2) + DE
    rect(cell, diff_layer, x_left, yc - W/2, x_right, yc + W/2)
    rect(cell, implant_layer, x_left - 0.16, yc - W/2 - 0.16,
         x_right + 0.16, yc + W/2 + 0.16)
    if kind == "pmos":
        rect(cell, nwell_layer, x_left - TECH["enc"]["nwell_diff"],
             yc - W/2 - TECH["enc"]["nwell_diff"],
             x_right + TECH["enc"]["nwell_diff"],
             yc + W/2 + TECH["enc"]["nwell_diff"])
    # poly gate (vertical strip with endcap beyond diffusion)
    rect(cell, poly_layer, gate_x - LT/2, yc - W/2 - PE,
         gate_x + LT/2, yc + W/2 + PE)
    # source / drain contacts on diffusion
    contact(cell, contact_layer, m1_layer, source_x, yc)
    contact(cell, contact_layer, m1_layer, drain_x, yc)
    label(cell, label_layer, term + ":S", source_x, yc)
    label(cell, label_layer, term + ":D", drain_x, yc)
    # gate contact on poly extension (above diffusion)
    if gate_contact_y is None:
        gate_contact_y = yc + W/2 + PE + CS/2 + 0.07
    contact(cell, contact_layer, m1_layer, gate_x, gate_contact_y)
    label(cell, label_layer, gname, gate_x, gate_contact_y)
    return dict(xc=xc, yc=yc, W=W, gate_x=gate_x)

def inv_cell(cell, x0, y0, ain, aout):
    """Inverter: pmos top, nmos bottom, shared gate poly."""
    # rails
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    gx = x0 + PITCH/2
    # pmos: source=VDD (left), drain=output (right)
    transistor(cell, "pmos", gx, y0 + GL_P, gx,
               x0 + 0.55, x0 + PITCH - 0.55,
               L["nwell"], L["diff"], L["pplus"],
               L["contact"], L["m1"], L["poly"], LL["m1"],
               "XMp0", ain, gate_contact_y=y0 + GL_P + PW/2 + PE + CS/2 + 0.07)
    # nmos: source=VSS (left), drain=output (right)
    transistor(cell, "nmos", gx, y0 + GL_N, gx,
               x0 + 0.55, x0 + PITCH - 0.55,
               L["nwell"], L["diff"], L["nplus"],
               L["contact"], L["m1"], L["poly"], LL["m1"],
               "XMn0", ain, gate_contact_y=y0 + GL_N - NW/2 - PE - CS/2 - 0.07)
    # join drains: m1 vertical at gx from nmos drain to pmos drain
    rect(cell, L["m1"], gx - CS/2, y0 + GL_N - NW/2,
         gx + CS/2, y0 + GL_P + PW/2)
    # output route to right edge
    wire(cell, L["m1"], gx, y0 + VDD_Y, x0 + PITCH - 0.25, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], aout, x0 + PITCH - 0.25, y0 + VDD_Y)
    # input: m1 from left edge to gate contact (on poly above pmos)
    gy = y0 + GL_P + PW/2 + PE + CS/2 + 0.07
    wire(cell, L["m1"], x0 + 0.25, gy, gx, gy, M1W)
    label(cell, LL["m1"], ain, x0 + 0.25, gy)

def nand4_cell(cell, x0, y0, ins, out):
    """4-input NAND: 4 series nmos + 4 parallel pmos."""
    # rails
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    cx = x0 + PITCH/2
    # ---- NMOS series chain (shared diffusion) ----
    # 4 gates at x positions
    ng = [x0 + 1.10, x0 + 2.10, x0 + 3.10, x0 + 4.10]
    # diffusion runs from x0+0.55 to x0+5.05 at GL_N
    x_start = x0 + 0.55
    x_end   = x0 + PITCH - 0.55
    rect(cell, L["diff"], x_start - DE, y0 + GL_N - NW/2,
         x_end + DE, y0 + GL_N + NW/2)
    rect(cell, L["nplus"], x_start - DE - 0.16, y0 + GL_N - NW/2 - 0.16,
         x_end + DE + 0.16, y0 + GL_N + NW/2 + 0.16)
    # poly gates crossing diffusion
    for i, gx in enumerate(ng):
        rect(cell, L["poly"], gx - LT/2, y0 + GL_N - NW/2 - PE,
             gx + LT/2, y0 + GL_N + NW/2 + PE)
    # source of t0 at x_start -> VSS; drain of t3 at x_end -> output
    # internal shared nodes: no contacts (diffusion is continuous)
    contact(cell, L["contact"], L["m1"], x_start, y0 + GL_N)
    contact(cell, L["contact"], L["m1"], x_end, y0 + GL_N)
    label(cell, LL["m1"], "XMn0_0:S", x_start, y0 + GL_N)
    label(cell, LL["m1"], "XMn0_3:D", x_end, y0 + GL_N)
    # gate contacts on poly extensions (above nmos diffusion)
    for i, gx in enumerate(ng):
        gy = y0 + GL_N + NW/2 + PE + CS/2 + 0.07
        contact(cell, L["contact"], L["m1"], gx, gy)
        label(cell, LL["m1"], "XMn0_%d:G" % i, gx, gy)
    # ---- PMOS parallel (4 separate diffusions) ----
    pg = [x0 + 0.85, x0 + 1.95, x0 + 3.05, x0 + 4.15]
    for i, gx in enumerate(pg):
        # each pmos diffusion: small rectangle around gate
        px1 = gx - LT/2 - DE
        px2 = gx + LT/2 + DE
        rect(cell, L["diff"], px1, y0 + GL_P - PW/2, px2, y0 + GL_P + PW/2)
        rect(cell, L["pplus"], px1 - 0.16, y0 + GL_P - PW/2 - 0.16,
             px2 + 0.16, y0 + GL_P + PW/2 + 0.16)
        rect(cell, L["nwell"], px1 - TECH["enc"]["nwell_diff"],
             y0 + GL_P - PW/2 - TECH["enc"]["nwell_diff"],
             px2 + TECH["enc"]["nwell_diff"],
             y0 + GL_P + PW/2 + TECH["enc"]["nwell_diff"])
        rect(cell, L["poly"], gx - LT/2, y0 + GL_P - PW/2 - PE,
             gx + LT/2, y0 + GL_P + PW/2 + PE)
        # source = VDD (left side of diffusion), drain = output (right side)
        sx = px1 + 0.15
        dx = px2 - 0.15
        contact(cell, L["contact"], L["m1"], sx, y0 + GL_P)
        contact(cell, L["contact"], L["m1"], dx, y0 + GL_P)
        label(cell, LL["m1"], "XMp0_%d:S" % i, sx, y0 + GL_P)
        label(cell, LL["m1"], "XMp0_%d:D" % i, dx, y0 + GL_P)
        # gate contact on poly extension (below pmos diffusion)
        gy = y0 + GL_P - PW/2 - PE - CS/2 - 0.07
        contact(cell, L["contact"], L["m1"], gx, gy)
        label(cell, LL["m1"], "XMp0_%d:G" % i, gx, gy)
    # connect all pmos sources to VDD rail and drains to output
    # VDD rail is at VDD_Y, sources at GL_P. Connect with m1 verticals.
    for gx in pg:
        wire(cell, L["m1"], gx, y0 + GL_P, gx, y0 + VDD_Y, M1W)
    # output: m1 vertical at x_end connecting nmos drain and all pmos drains
    # route pmos drains to x_end vertical
    rect(cell, L["m1"], x_end - CS/2, y0 + VSS_Y - M1W/2,
         x_end + CS/2, y0 + VDD_Y + M1W/2)
    # connect pmos drains to output rail: horizontal m1 at GL_P from each drain to x_end
    for gx in pg:
        dx = gx + LT/2 + DE - 0.15
        wire(cell, L["m1"], dx, y0 + GL_P, x_end, y0 + GL_P, M1W)
    # output to right edge
    wire(cell, L["m1"], x_end, y0 + GL_P, x0 + PITCH - 0.25, y0 + GL_P, M1W)
    label(cell, LL["m1"], out, x0 + PITCH - 0.25, y0 + GL_P)
    # inputs: m1 from left edge to each gate contact
    for i, gx in enumerate(ng):
        gy = y0 + GL_N + NW/2 + PE + CS/2 + 0.07
        wire(cell, L["m1"], x0 + 0.25, gy, gx, gy, M1W)
        label(cell, LL["m1"], ins[i], x0 + 0.25, gy)
    for i, gx in enumerate(pg):
        gy = y0 + GL_P - PW/2 - PE - CS/2 - 0.07
        wire(cell, L["m1"], x0 + 0.25, gy, gx, gy, M1W)
        label(cell, LL["m1"], ins[i], x0 + 0.25, gy)

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
    ["A0","AB1","AB2","A3"], ["AB0","A1","AB2","A3"],
    ["A0","A1","AB2","A3"], ["AB0","AB1","A2","A3"],
    ["A0","AB1","A2","A3"], ["AB0","A1","A2","A3"],
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
rail_y = H + 1.8
wire(top, L["m2"], 0, rail_y, x, rail_y, M2W)
wire(top, L["m2"], 0, rail_y + M2W + M2S, x, rail_y + M2W + M2S, M2W)
label(top, LL["m2"], PWR, x/2, rail_y)
label(top, LL["m2"], GND, x/2, rail_y + M2W + M2S)
# connect each cell's rails to global rails with via1
for cx in range(0, int(x / PITCH) + 1):
    cxf = cx * PITCH + PITCH/2
    if cxf > x:
        continue
    via1(top, cxf, rail_y)
    via1(top, cxf, rail_y + M2W + M2S)
    wire(top, L["m1"], cxf, VDD_Y, cxf, rail_y, M1W)
    wire(top, L["m1"], cxf, VSS_Y, cxf, rail_y + M2W + M2S, M1W)

# input pins A0..A3 on left (m1)
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
                                           dbu(x + 1), dbu(H + 3.6)))
ly.write("dec4to16.gds")
print("bbox um: %.3f x %.3f = %.1f um^2" % (x + 2, H + 4.6, (x + 2) * (H + 4.6)))
