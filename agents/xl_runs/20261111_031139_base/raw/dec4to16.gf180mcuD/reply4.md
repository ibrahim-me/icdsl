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

# ---------------------------------------------------------------- build
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
LL = {name: ly.layer(*spec) for name, spec in TECH["label"].items()}

M1W = 0.23; M2W = 0.28; M2S = 0.28
PITCH = 6.0
H = 6.0
VDD_Y = 5.45
VSS_Y = 0.55
GL_P = 4.70
GL_N = 1.30
PW = 0.72
NW = 0.36
CS = 0.22
PWR = "VDD"
GND = "VSS"
DE = 0.23
PE = 0.22
LT = 0.28

def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, cl, ml, x, y, enc=0.06):
    cs = 0.22
    rect(cell, cl, x - cs/2, y - cs/2, x + cs/2, y + cs/2)
    rect(cell, ml, x - cs/2 - enc, y - cs/2 - enc, x + cs/2 + enc, y + cs/2 + enc)

def via1(cell, x, y):
    vs = 0.26; e = 0.06
    rect(cell, L["via1"], x - vs/2, y - vs/2, x + vs/2, y + vs/2)
    rect(cell, L["m1"], x - vs/2 - e, y - vs/2 - e, x + vs/2 + e, y + vs/2 + e)

def wire(cell, layer, x1, y1, x2, y2, width):
    w = width
    if x1 == x2:
        rect(cell, layer, x1 - w/2, y1, x1 + w/2, y2)
    else:
        rect(cell, layer, x1, y1 - w/2, x2, y1 + w/2)

def mos(cell, kind, yc, gate_x, source_x, drain_x, W,
        diff_layer, implant_layer, nwell_layer,
        contact_layer, m1_layer, poly_layer, label_layer,
        term, gname):
    x_left = min(source_x, drain_x, gate_x - LT/2) - DE
    x_right = max(source_x, drain_x, gate_x + LT/2) + DE
    rect(cell, diff_layer, x_left, yc - W/2, x_right, yc + W/2)
    rect(cell, implant_layer, x_left - 0.16, yc - W/2 - 0.16,
         x_right + 0.16, yc + W/2 + 0.16)
    if kind == "pmos":
        rect(cell, nwell_layer, x_left - 0.43, yc - W/2 - 0.43,
             x_right + 0.43, yc + W/2 + 0.43)
    rect(cell, poly_layer, gate_x - LT/2, yc - W/2 - PE,
         gate_x + LT/2, yc + W/2 + PE)
    contact(cell, contact_layer, m1_layer, source_x, yc, TECH["contact"]["enc_m1"])
    contact(cell, contact_layer, m1_layer, drain_x, yc, TECH["contact"]["enc_m1"])
    label(cell, label_layer, term + ":S", source_x, yc)
    label(cell, label_layer, term + ":D", drain_x, yc)
    if kind == "pmos":
        gy = yc - W/2 - PE - CS/2 - 0.07
    else:
        gy = yc + W/2 + PE + CS/2 + 0.07
    contact(cell, contact_layer, m1_layer, gate_x, gy, TECH["contact"]["enc_m1"])
    label(cell, label_layer, gname, gate_x, gy)

def inv_cell(cell, x0, y0, ain, aout):
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    gx = x0 + PITCH/2
    mos(cell, "pmos", y0 + GL_P, gx, x0 + 0.6, x0 + PITCH - 0.6, PW,
        L["diff"], L["pplus"], L["nwell"],
        L["contact"], L["m1"], L["poly"], LL["m1"],
        "XMp0", ain)
    mos(cell, "nmos", y0 + GL_N, gx, x0 + 0.6, x0 + PITCH - 0.6, NW,
        L["diff"], L["nplus"], L["nwell"],
        L["contact"], L["m1"], L["poly"], LL["m1"],
        "XMn0", ain)
    rect(cell, L["m1"], gx - CS/2, y0 + GL_N - NW/2,
         gx + CS/2, y0 + GL_P + PW/2)
    wire(cell, L["m1"], gx, y0 + VDD_Y, x0 + PITCH - 0.3, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], aout, x0 + PITCH - 0.3, y0 + VDD_Y)
    gy_p = y0 + GL_P - PW/2 - PE - CS/2 - 0.07
    wire(cell, L["m1"], x0 + 0.3, gy_p, gx, gy_p, M1W)
    label(cell, LL["m1"], ain, x0 + 0.3, gy_p)

def nand4_cell(cell, x0, y0, ins, out):
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    ng = [x0 + 1.0, x0 + 2.2, x0 + 3.4, x0 + 4.6]
    x_start = x0 + 0.6
    x_end = x0 + PITCH - 0.6
    rect(cell, L["diff"], x_start - DE, y0 + GL_N - NW/2,
         x_end + DE, y0 + GL_N + NW/2)
    rect(cell, L["nplus"], x_start - DE - 0.16, y0 + GL_N - NW/2 - 0.16,
         x_end + DE + 0.16, y0 + GL_N + NW/2 + 0.16)
    for gx in ng:
        rect(cell, L["poly"], gx - LT/2, y0 + GL_N - NW/2 - PE,
             gx + LT/2, y0 + GL_N + NW/2 + PE)
    contact(cell, L["contact"], L["m1"], x_start, y0 + GL_N, TECH["contact"]["enc_m1"])
    contact(cell, L["contact"], L["m1"], x_end, y0 + GL_N, TECH["contact"]["enc_m1"])
    label(cell, LL["m1"], "XMn0_0:S", x_start, y0 + GL_N)
    label(cell, LL["m1"], "XMn0_3:D", x_end, y0 + GL_N)
    for i, gx in enumerate(ng):
        gy = y0 + GL_N + NW/2 + PE + CS/2 + 0.07
        contact(cell, L["contact"], L["m1"], gx, gy, TECH["contact"]["enc_m1"])
        label(cell, LL["m1"], "XMn0_%d:G" % i, gx, gy)
    pg = [x0 + 0.8, x0 + 2.0, x0 + 3.2, x0 + 4.4]
    for i, gx in enumerate(pg):
        px1 = gx - LT/2 - DE
        px2 = gx + LT/2 + DE
        rect(cell, L["diff"], px1, y0 + GL_P - PW/2, px2, y0 + GL_P + PW/2)
        rect(cell, L["pplus"], px1 - 0.16, y0 + GL_P - PW/2 - 0.16,
             px2 + 0.16, y0 + GL_P + PW/2 + 0.16)
        rect(cell, L["nwell"], px1 - 0.43, y0 + GL_P - PW/2 - 0.43,
             px2 + 0.43, y0 + GL_P + PW/2 + 0.43)
        rect(cell, L["poly"], gx - LT/2, y0 + GL_P - PW/2 - PE,
             gx + LT/2, y0 + GL_P + PW/2 + PE)
        sx = px1 + 0.15
        dx = px2 - 0.15
        contact(cell, L["contact"], L["m1"], sx, y0 + GL_P, TECH["contact"]["enc_m1"])
        contact(cell, L["contact"], L["m1"], dx, y0 + GL_P, TECH["contact"]["enc_m1"])
        label(cell, LL["m1"], "XMp0_%d:S" % i, sx, y0 + GL_P)
        label(cell, LL["m1"], "XMp0_%d:D" % i, dx, y0 + GL_P)
        gy = y0 + GL_P - PW/2 - PE - CS/2 - 0.07
        contact(cell, L["contact"], L["m1"], gx, gy, TECH["contact"]["enc_m1"])
        label(cell, LL["m1"], "XMp0_%d:G" % i, gx, gy)
    for i, gx in enumerate(pg):
        px1 = gx - LT/2 - DE
        px2 = gx + LT/2 + DE
        sx = px1 + 0.15
        dx = px2 - 0.15
        wire(cell, L["m1"], sx, y0 + GL_P, sx, y0 + VDD_Y, M1W)
        wire(cell, L["m1"], dx, y0 + GL_P, x_end, y0 + GL_P, M1W)
    rect(cell, L["m1"], x_end - CS/2, y0 + VSS_Y - M1W/2,
         x_end + CS/2, y0 + VDD_Y + M1W/2)
    wire(cell, L["m1"], x_end, y0 + GL_P, x0 + PITCH - 0.3, y0 + GL_P, M1W)
    label(cell, LL["m1"], out, x0 + PITCH - 0.3, y0 + GL_P)
    for i, gx in enumerate(ng):
        gy = y0 + GL_N + NW/2 + PE + CS/2 + 0.07
        wire(cell, L["m1"], x0 + 0.3, gy, gx, gy, M1W)
        label(cell, LL["m1"], ins[i], x0 + 0.3, gy)
    for i, gx in enumerate(pg):
        gy = y0 + GL_P - PW/2 - PE - CS/2 - 0.07
        wire(cell, L["m1"], x0 + 0.3, gy, gx, gy, M1W)
        label(cell, LL["m1"], ins[i], x0 + 0.3, gy)

def tap_cell(cell, x0, y0, kind):
    """kind: 'nwell' (p+ in nwell to VDD) or 'sub' (n+ in substrate to VSS)"""
    W = 2.0; Ld = 2.0
    xc = x0 + PITCH/2; yc = y0 + PITCH/2
    rect(cell, L["diff"], xc - Ld/2, yc - W/2, xc + Ld/2, yc + W/2)
    if kind == "nwell":
        rect(cell, L["pplus"], xc - Ld/2 - 0.16, yc - W/2 - 0.16,
             xc + Ld/2 + 0.16, yc + W/2 + 0.16)
        rect(cell, L["nwell"], xc - Ld/2 - 0.43, yc - W/2 - 0.43,
             xc + Ld/2 + 0.43, yc + W/2 + 0.43)
        contact(cell, L["contact"], L["m1"], xc, yc, TECH["contact"]["enc_m1"])
        label(cell, LL["m1"], PWR, xc, yc)
        wire(cell, L["m1"], xc, yc, xc, y0 + VDD_Y, M1W)
    else:
        rect(cell, L["nplus"], xc - Ld/2 - 0.16, yc - W/2 - 0.16,
             xc + Ld/2 + 0.16, yc + W/2 + 0.16)
        contact(cell, L["contact"], L["m1"], xc, yc, TECH["contact"]["enc_m1"])
        label(cell, LL["m1"], GND, xc, yc)
        wire(cell, L["m1"], xc, yc, xc, y0 + VSS_Y, M1W)

# ---------------------------------------------------------------- placement
x = 0.0
for i in range(4):
    inv_cell(top, x, i * PITCH, "A%d" % i, "AB%d" % i)
x += PITCH

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

for col in range(4):
    for row in range(4):
        k = col * 4 + row
        inv_cell(top, x + col * PITCH, row * PITCH, "YB%d" % k, "Y%d" % k)
x += 4 * PITCH

# Add tap cells in corners
tap_cell(top, 0, 0, "sub")
tap_cell(top, x - PITCH, 0, "sub")
tap_cell(top, 0, 3 * PITCH, "nwell")
tap_cell(top, x - PITCH, 3 * PITCH, "nwell")

# Global rails
rail_y = H + 1.8
wire(top, L["m2"], 0, rail_y, x, rail_y, M2W)
wire(top, L["m2"], 0, rail_y + M2W + M2S, x, rail_y + M2W + M2S, M2W)
label(top, LL["m2"], PWR, x/2, rail_y)
label(top, LL["m2"], GND, x/2, rail_y + M2W + M2S)

for cx in range(0, int(x / PITCH) + 1):
    cxf = cx * PITCH + PITCH/2
    if cxf > x:
        continue
    via1(top, cxf, rail_y)
    via1(top, cxf, rail_y + M2W + M2S)
    wire(top, L["m1"], cxf, VDD_Y, cxf, rail_y, M1W)
    wire(top, L["m1"], cxf, VSS_Y, cxf, rail_y + M2W + M2S, M1W)

# Input pins
for i in range(4):
    rect(top, L["m1"], -0.6, i * PITCH + GL_N - M1W/2, -0.2,
         i * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "A%d" % i, -0.4, i * PITCH + GL_N)

# Output pins
for k in range(16):
    col = k // 4; row = k % 4
    rect(top, L["m1"], x + 0.2, row * PITCH + GL_N - M1W/2,
         x + 0.6, row * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "Y%d" % k, x + 0.4, row * PITCH + GL_N)

# Supply pins
rect(top, L["m1"], -0.6, rail_y - M1W/2, -0.2, rail_y + M1W/2)
label(top, LL["m1"], PWR, -0.4, rail_y)
rect(top, L["m1"], -0.6, rail_y + M2W + M2S - M1W/2,
     -0.2, rail_y + M2W + M2S + M1W/2)
label(top, LL["m1"], GND, -0.4, rail_y + M2W + M2S)

# Boundary
top.shapes(ly.layer(0, 0)).insert(kdb.DBox(-1, -1, x + 1, H + 5.0))
ly.write("dec4to16.gds")
print("bbox um: %.3f x %.3f = %.1f um^2" % (x + 2, H + 6.0, (x + 2) * (H + 6.0)))
```