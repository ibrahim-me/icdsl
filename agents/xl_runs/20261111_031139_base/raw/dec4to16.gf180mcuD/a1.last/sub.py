import klayout.db as kdb

# ---------------------------------------------------------------- technology (gf180mcuD)
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers=dict(
        nwell=(21, 0), diff=(22, 0), poly=(30, 0), pplus=(31, 0),
        nplus=(32, 0), contact=(33, 0), m1=(34, 0), via1=(35, 0), m2=(36, 0),
    ),
    label=dict(poly=(30, 10), m1=(34, 10), m2=(36, 10), nwell=(21, 10)),
    contact=dict(size=0.22, space=0.25, enc_diff=0.07, enc_poly=0.07, enc_m1=0.06),
    via1=dict(size=0.26, space=0.26, enc_m1=0.06, enc_m2=0.06),
    width=dict(diff=0.22, poly=0.18, m1=0.23, m2=0.28),
    space=dict(diff=0.28, poly=0.24, m1=0.23, m2=0.28),
    enc=dict(nwell_diff=0.43, poly_endcap=0.22, diff_ext_gate=0.23),
    devices=dict(
        nmos=dict(l=0.28, w=0.36),
        pmos=dict(l=0.28, w=0.72),
    ),
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------- geometry helpers
def dbu(um):
    return int(round(um / 0.001))

def box(x1, y1, x2, y2):
    return kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2))

def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(box(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, cl, ml, x, y, enc=None):
    c = TECH["contact"]; cs = c["size"]
    e = c["enc_m1"] if enc is None else enc
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

def transistor(cell, kind, x, y, gl, gs, gd, nwell_layer, diff_layer,
               implant_layer, contact_layer, m1_layer, poly_layer,
               label_layer, term, gname):
    d = TECH["devices"][kind]; W = d["w"]; Lt = d["l"]
    de = TECH["enc"]["diff_ext_gate"]; pe = TECH["enc"]["poly_endcap"]
    cs = TECH["contact"]["size"]; ce = TECH["contact"]["enc_diff"]
    cenc = TECH["contact"]["enc_m1"]
    rect(cell, diff_layer, x - W/2, y - Lt/2 - de, x + W/2, y + Lt/2 + de)
    if kind == "pmos":
        nd = TECH["enc"]["nwell_diff"]
        rect(cell, nwell_layer, x - W/2 - nd, y - Lt/2 - de - nd,
             x + W/2 + nd, y + Lt/2 + de + nd)
    rect(cell, implant_layer, x - W/2 - 0.16, y - Lt/2 - de - 0.16,
         x + W/2 + 0.16, y + Lt/2 + de + 0.16)
    rect(cell, poly_layer, x - W/2 - pe, gl - Lt/2,
         x + W/2 + pe, gl + Lt/2)
    contact(cell, contact_layer, m1_layer, x, gl, enc=cenc)
    contact(cell, contact_layer, m1_layer, x, gs, enc=cenc)
    contact(cell, contact_layer, m1_layer, x, gd, enc=cenc)
    label(cell, label_layer, gname, x, gl)
    label(cell, label_layer, term + ":S", x, gs)
    label(cell, label_layer, term + ":D", x, gd)

# ---------------------------------------------------------------- layout
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
LL = {name: ly.layer(*spec) for name, spec in TECH["label"].items()}

M1W = TECH["width"]["m1"]; M2W = TECH["width"]["m2"]
M1S = TECH["space"]["m1"]; M2S = TECH["space"]["m2"]
PITCH = 6.0
HCELL = 5.6
GL_P = HCELL - 1.15
GL_N = 1.15
VDD_Y = HCELL - 0.55
VSS_Y = 0.55
PW = 0.72; NW = 0.36
CS = TECH["contact"]["size"]
PWR = TECH["supplies"]["power"]; GND = TECH["supplies"]["ground"]

def inv_cell(cell, x0, y0, ain, aout):
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    gx = x0 + PITCH/2
    transistor(cell, "pmos", gx, y0 + GL_P, GL_P, VDD_Y, VSS_Y,
               L["nwell"], L["diff"], L["pplus"], L["contact"], L["m1"],
               L["poly"], LL["m1"], "XMp0", ain)
    transistor(cell, "nmos", gx, y0 + GL_N, GL_N, VSS_Y, VSS_Y,
               L["nwell"], L["diff"], L["nplus"], L["contact"], L["m1"],
               L["poly"], LL["m1"], "XMn0", ain)
    rect(cell, L["m1"], gx - CS/2, y0 + VSS_Y - M1W/2, gx + CS/2, y0 + VDD_Y + M1W/2)
    wire(cell, L["m1"], gx, y0 + VDD_Y, x0 + PITCH - 0.2, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], aout, x0 + PITCH - 0.2, y0 + VDD_Y)
    label(cell, LL["poly"], ain, x0 + 0.15, y0 + GL_P)

def nand4_cell(cell, x0, y0, ins, out):
    rect(cell, L["m1"], x0, y0 + VDD_Y - M1W/2, x0 + PITCH, y0 + VDD_Y + M1W/2)
    rect(cell, L["m1"], x0, y0 + VSS_Y - M1W/2, x0 + PITCH, y0 + VSS_Y + M1W/2)
    label(cell, LL["m1"], PWR, x0 + PITCH/2, y0 + VDD_Y)
    label(cell, LL["m1"], GND, x0 + PITCH/2, y0 + VSS_Y)
    cx = x0 + PITCH/2
    ng = [GL_N - 0.9, GL_N - 0.3, GL_N + 0.3, GL_N + 0.9]
    ny = [VSS_Y, GL_N - 0.6, GL_N + 0.0, GL_N + 0.6, None]
    for i, inn in enumerate(ins):
        dn = ny[i+1] if ny[i+1] is not None else (y0 + GL_N + 0.6)
        transistor(cell, "nmos", cx, y0 + ng[i], ng[i], ny[i], dn,
                   L["nwell"], L["diff"], L["nplus"], L["contact"], L["m1"],
                   L["poly"], LL["m1"], "XMn0_%d" % i, inn)
    rect(cell, L["m1"], cx - CS/2, y0 + GL_N + 0.6 - M1W/2,
         cx + CS/2, y0 + VDD_Y + M1W/2)
    pg = [x0 + 0.30, x0 + 0.75, x0 + 1.20, x0 + 1.65]
    out_y = y0 + GL_N + 0.6
    for i, inn in enumerate(ins):
        transistor(cell, "pmos", pg[i], y0 + GL_P, GL_P, VDD_Y, out_y,
                   L["nwell"], L["diff"], L["pplus"], L["contact"], L["m1"],
                   L["poly"], LL["m1"], "XMp0_%d" % i, inn)
    rect(cell, L["m1"], x0 + 0.15, out_y - M1W/2, x0 + PITCH - 0.15, out_y + M1W/2)
    wire(cell, L["m1"], cx, y0 + out_y, cx, y0 + VDD_Y, M1W)
    label(cell, LL["m1"], out, x0 + PITCH - 0.2, y0 + out_y)
    for i, inn in enumerate(ins):
        label(cell, LL["poly"], inn, pg[i] - 0.35, y0 + GL_P)

# ---------------------------------------------------------------- placement
x = 0.0
for i in range(4):
    inv_cell(top, x, 0.0, "A%d" % i, "AB%d" % i)
x += PITCH

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
for row in range(4):
    for col in range(4):
        k = row * 4 + col
        nand4_cell(top, x + col * PITCH, row * PITCH, nand_ins[k], "YB%d" % k)
x += 4 * PITCH
for col in range(4):
    for row in range(4):
        k = col * 4 + row
        inv_cell(top, x + col * PITCH, row * PITCH, "YB%d" % k, "Y%d" % k)
x += 4 * PITCH

# global supply rails (m2)
wire(top, L["m2"], 0, HCELL + 1.2, x, HCELL + 1.2, M2W)
wire(top, L["m2"], 0, HCELL + 1.2 + M2W + M2S, x, HCELL + 1.2 + M2W + M2S, M2W)
label(top, LL["m2"], PWR, x/2, HCELL + 1.2)
label(top, LL["m2"], GND, x/2, HCELL + 1.2 + M2W + M2S)
for cx in range(0, int(round(x / PITCH)) * 4 + 4):
    cxf = (cx % 4) * PITCH + PITCH/2 + (cx // 4) * 0  # placeholder
# place via1 at every cell column
ncols = 1 + 4 + 4
for c in range(ncols):
    cxf = c * PITCH + PITCH/2
    via1(top, cxf, HCELL + 1.2)
    via1(top, cxf, HCELL + 1.2 + M2W + M2S)
    wire(top, L["m1"], cxf, VDD_Y, cxf, HCELL + 1.2, M1W)
    wire(top, L["m1"], cxf, VSS_Y, cxf, HCELL + 1.2 + M2W + M2S, M1W)

# input pins A0..A3 (left, m1)
for i in range(4):
    rect(top, L["m1"], -0.6, i * PITCH + GL_N - M1W/2, -0.2, i * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "A%d" % i, -0.4, i * PITCH + GL_N)

# output pins Y0..Y15 (right, m1)
for k in range(16):
    col = k // 4; row = k % 4
    rect(top, L["m1"], x + 4 * PITCH + 0.2, row * PITCH + GL_N - M1W/2,
         x + 4 * PITCH + 0.6, row * PITCH + GL_N + M1W/2)
    label(top, LL["m1"], "Y%d" % k, x + 4 * PITCH + 0.4, row * PITCH + GL_N)

# supply pins
rect(top, L["m1"], x - 0.6, HCELL + 1.2 - M1W/2, x - 0.2, HCELL + 1.2 + M1W/2)
label(top, LL["m1"], PWR, x - 0.4, HCELL + 1.2)
rect(top, L["m1"], x - 0.6, HCELL + 1.2 + M2W + M2S - M1W/2,
     x - 0.2, HCELL + 1.2 + M2W + M2S + M1W/2)
label(top, LL["m1"], GND, x - 0.4, HCELL + 1.2 + M2W + M2S)

top.shapes(ly.layer(0, 0)).insert(box(0, 0, x, HCELL + 3.0))
ly.write("dec4to16.gds")
print("bbox um: %.3f x %.3f = %.1f um^2" % (x, HCELL + 3.0, x * (HCELL + 3.0)))
