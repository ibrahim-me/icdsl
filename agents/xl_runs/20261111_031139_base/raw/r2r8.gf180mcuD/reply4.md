```
import klayout.db as kdb

# ------------------------------------------------------------------ PDK data
TECH = dict(
    layers={
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0),
        "sab": (49, 0), "res_mk": (110, 5),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0),
    },
    label={"poly": (30, 10), "m1": (34, 10), "m2": (36, 10)},
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
    },
    width={"poly": 0.18, "m1": 0.23, "m2": 0.28},
    space={
        ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("diff", "diff"): 0.28,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07),
        ("m1", "contact"): (0.005, 0.06), ("m1", "via1"): (0.0, 0.06),
        ("m2", "via1"): (0.01, 0.06),
    },
    rules=dict(
        gate_contact_space=0.15, poly_endcap=0.22, diff_ext_gate=0.23,
        polycontact_diff_space=0.17, polycontact_implant_space=0.0,
        gate_space=0.24, tap_diff_space=0.32, latchup_dist=15.0,
        wide_metal=10.0,
    ),
    devices={
        "res_poly": dict(type="res", model="ppolyf_u", body="poly",
                         markers=[("res_mk", 0.0), ("sab", 0.28)],
                         covers=[("pplus", 0.30, 0.30)], head_space=0.22,
                         wmin=0.80, lmin=1.0, terminals=3, bulk="VSS",
                         params={"w": "r_width", "l": "r_length"}),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("r2r8")

L = {k: ly.layer(*v) for k, v in TECH["layers"].items()}
LAB = {k: ly.layer(*v) for k, v in TECH["label"].items()}

CONTACT = TECH["cuts"]["contact"]
CS = CONTACT["size"]          # 0.22
CP = CONTACT["space"]         # 0.25
VIA1 = TECH["cuts"]["via1"]
VS = VIA1["size"]             # 0.26
VP = VIA1["space"]            # 0.26
M1W = TECH["width"]["m1"]     # 0.23
M2W = TECH["width"]["m2"]     # 0.28
ENC_PC = TECH["enc"][("poly", "contact")][0]   # 0.07
ENC_M1V1 = TECH["enc"][("m1", "via1")][0]      # 0.0
ENC_M2V1 = TECH["enc"][("m2", "via1")][0]      # 0.01
HEAD = TECH["devices"]["res_poly"]["head_space"]  # 0.22

RW = 1.0   # resistor width
RL = 6.0   # resistor length (active)

# ------------------------------------------------------------------ helpers
def dbox(cell, layer, x0, y0, x1, y1):
    cell.shapes(layer).insert(kdb.DBox(x0, y0, x1, y1))

def dtext(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, x, y):
    """Contact on poly: cut + m1 pad + poly enclosure."""
    dbox(cell, L["contact"], x - CS / 2, y - CS / 2, x + CS / 2, y + CS / 2)
    dbox(cell, L["m1"], x - M1W / 2, y - M1W / 2, x + M1W / 2, y + M1W / 2)
    dbox(cell, L["poly"], x - CS / 2 - ENC_PC, y - CS / 2 - ENC_PC,
         x + CS / 2 + ENC_PC, y + CS / 2 + ENC_PC)

def via1(cell, x, y):
    """Via1 between m1 and m2."""
    dbox(cell, L["via1"], x - VS / 2, y - VS / 2, x + VS / 2, y + VS / 2)
    dbox(cell, L["m1"], x - M1W / 2, y - M1W / 2, x + M1W / 2, y + M1W / 2)
    dbox(cell, L["m2"], x - M2W / 2, y - M2W / 2, x + M2W / 2, y + M2W / 2)

def m1_h(cell, x0, x1, y):
    dbox(cell, L["m1"], x0, y - M1W / 2, x1, y + M1W / 2)

def m1_v(cell, x, y0, y1):
    dbox(cell, L["m1"], x - M1W / 2, y0, x + M1W / 2, y1)

def m2_v(cell, x, y0, y1):
    dbox(cell, L["m2"], x - M2W / 2, y0, x + M2W / 2, y1)

# ------------------------------------------------------------------ resistor
PW = RW
PL = RL + 2 * (HEAD + CS / 2 + ENC_PC)   # total poly length
HALF_PL = PL / 2
HALF_PW = PW / 2
CONTACT_OFF = HEAD + CS / 2              # body edge to contact centre
LX = -CONTACT_OFF
RX = +CONTACT_OFF

def res_unit(cell, cx, cy):
    """One unit poly resistor centred at (cx, cy), active length along x.
    Returns (left_contact, right_contact) as (x, y) tuples."""
    # poly body (active resistor + head regions)
    dbox(cell, L["poly"], cx - HALF_PL, cy - HALF_PW, cx + HALF_PL, cy + HALF_PW)
    # res_mk marker = active body only
    dbox(cell, L["res_mk"], cx - RL / 2, cy - HALF_PW, cx + RL / 2, cy + HALF_PW)
    # sab marker: 0.28 beyond res_mk
    dbox(cell, L["sab"], cx - RL / 2 - 0.28, cy - HALF_PW - 0.28,
         cx + RL / 2 + 0.28, cy + HALF_PW + 0.28)
    # pplus cover: 0.30 beyond res_mk
    dbox(cell, L["pplus"], cx - RL / 2 - 0.30, cy - HALF_PW - 0.30,
         cx + RL / 2 + 0.30, cy + HALF_PW + 0.30)
    # two contacts on poly, in the head regions
    contact(cell, cx + LX, cy)
    contact(cell, cx + RX, cy)
    return (cx + LX, cy), (cx + RX, cy)

# ------------------------------------------------------------------ placement
PITCH_X = 8.0          # horizontal pitch between resistor centres
ROW_PITCH = 9.0        # vertical pitch between the two rows

# (name, node_a, node_b, cx_index, row)
units = [
    ("RT1", "VSS", "t",   0,  0),
    ("RT2", "n0",  "t",   1,  0),
    ("RA0", "n0",  "x0",  2,  0),
    ("RB0", "B0",  "x0",  3,  0),
    ("RS0", "n0",  "n1",  4,  0),
    ("RA1", "n1",  "x1",  5,  0),
    ("RB1", "B1",  "x1",  6,  0),
    ("RS1", "n1",  "n2",  7,  0),
    ("RA2", "n2",  "x2",  8,  0),
    ("RB2", "B2",  "x2",  9,  0),
    ("RS2", "n2",  "n3", 10,  0),
    ("RA3", "n3",  "x3", 11,  0),
    ("RB3", "B3",  "x3", 12,  0),
    ("RS3", "n3",  "n4", 13,  0),
    ("RA4", "n4",  "x4", 14,  0),
    ("RB4", "B4",  "x4", 15,  0),
    ("RS4", "n4",  "n5", 16,  0),
    ("RA5", "n5",  "x5", 17,  0),
    ("RB5", "B5",  "x5", 18,  0),
    ("RS5", "n5",  "n6", 19,  0),
    ("RA6", "n6",  "x6", 20,  0),
    ("RB6", "B6",  "x6", 21,  0),
    ("RS6", "n6",  "OUT",22,  0),
    ("RA7", "OUT", "x7", 23,  0),
    ("RB7", "B7",  "x7", 24,  0),
]

unit_info = {}
for name, a, b, ci, row in units:
    cx = ci * PITCH_X
    cy = row * ROW_PITCH
    p1, p2 = res_unit(top, cx, cy)
    unit_info[name] = (cx, cy, a, b, p1, p2)

def port(name):
    """Return the contact point of a named node on a resistor."""
    for nm, (cx, cy, a, b, p1, p2) in unit_info.items():
        if name == a:
            return p1
        if name == b:
            return p2
    if name == "VSS":
        return None
    raise ValueError("node %s not found" % name)

# ------------------------------------------------------------------ VSS rail (m2 vertical + m1 horizontal)
VSS_X = -PITCH_X
VSS_TOP = ROW_PITCH + M2W + 0.5
VSS_BOT = -ROW_PITCH - M2W - 0.5
m2_v(top, VSS_X, VSS_BOT, VSS_TOP)
dtext(top, LAB["m2"], "VSS", VSS_X, VSS_TOP + 0.4)

# via1 from VSS rail (m2) down to m1 at y = -ROW_PITCH/2
VSS_M1_Y = -ROW_PITCH / 2
via1(top, VSS_X, VSS_M1_Y)
# m1 horizontal segment from via to RT1 left contact
rt1_cx, rt1_cy, _, _, rt1_p1, _ = unit_info["RT1"]
m1_h(top, VSS_X, rt1_p1[0], VSS_M1_Y)
m1_v(top, rt1_p1[0], VSS_M1_Y, rt1_p1[1])

# connect every resistor port that is VSS to the rail (via m1 vertical to m2)
for nm, (cx, cy, a, b, p1, p2) in unit_info.items():
    for node, pt in ((a, p1), (b, p2)):
        if node == "VSS":
            m1_v(top, pt[0], pt[1], VSS_M1_Y)
            m1_h(top, VSS_X, pt[0], VSS_M1_Y)

# ------------------------------------------------------------------ series resistors RS0..RS6 (m1 horizontal)
for i in range(7):
    nm = "RS%d" % i
    cx, cy, a, b, p1, p2 = unit_info[nm]
    m1_h(top, p1[0], p2[0], cy)

# ------------------------------------------------------------------ bit inputs B0..B7 (m2 vertical to m1 at x port)
for i in range(8):
    nm = "RB%d" % i
    cx, cy, a, b, p1, p2 = unit_info[nm]
    bx = cx
    m2_v(top, bx, cy - ROW_PITCH / 2 - M2W, cy + ROW_PITCH / 2 + M2W)
    dtext(top, LAB["m2"], "B%d" % i, bx, cy + ROW_PITCH / 2 + M2W + 0.4)
    via1(top, bx, cy)
    m1_v(top, bx, cy, p2[1])

# ------------------------------------------------------------------ OUT (m2 vertical at RS6 right port)
cx, cy, a, b, p1, p2 = unit_info["RS6"]
ox = p2[0]
m2_v(top, ox, cy - ROW_PITCH / 2 - M2W, cy + ROW_PITCH / 2 + M2W)
dtext(top, LAB["m2"], "OUT", ox, cy + ROW_PITCH / 2 + M2W + 0.4)
via1(top, ox, cy)
m1_v(top, ox, cy, p2[1])

# ------------------------------------------------------------------ write
ly.write("r2r8.gds")
print("written r2r8.gds")


```