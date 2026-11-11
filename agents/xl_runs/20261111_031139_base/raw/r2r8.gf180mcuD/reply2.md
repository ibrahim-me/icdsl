```python
import klayout.db as kdb

# ------------------------------------------------------------------ PDK data
TECH = dict(
    layers={
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0),
        "contact": (33, 0), "m1": (34, 0),
    },
    label={"poly": (30, 10), "m1": (34, 10)},
    cuts={"contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1")},
    width={"poly": 0.18, "m1": 0.23},
    space={
        ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("m1", "m1"): 0.23, ("diff", "diff"): 0.28,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07),
        ("m1", "contact"): (0.005, 0.06),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        polycontact_implant_space=0.0,
        gate_space=0.24,
        tap_diff_space=0.32,
        latchup_dist=15.0,
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

CUT = TECH["cuts"]["contact"]
CS = CUT["size"]          # 0.22
CP = CUT["space"]         # 0.25
M1W = TECH["width"]["m1"] # 0.23
M1H = M1W
ENC_PC = TECH["enc"]["poly"]["contact"][0]   # 0.07
HEAD = TECH["devices"]["res_poly"]["head_space"]  # 0.22

RW = 1.0   # resistor width
RL = 6.0   # resistor length (active)

# ------------------------------------------------------------------ helpers
def dbox(cell, layer, x0, y0, x1, y1):
    cell.shapes(layer).insert(kdb.DBox(x0, y0, x1, y1))

def dtext(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, x, y, layer_upper=L["m1"], layer_lower=L["poly"]):
    """MIM-style contact: cut on cut layer, upper metal, lower enc."""
    dbox(cell, L["contact"], x - CS / 2, y - CS / 2, x + CS / 2, y + CS / 2)
    dbox(cell, layer_upper, x - M1H / 2, y - M1H / 2, x + M1H / 2, y + M1H / 2)
    dbox(cell, layer_lower, x - CS / 2 - ENC_PC, y - CS / 2 - ENC_PC,
         x + CS / 2 + ENC_PC, y + CS / 2 + ENC_PC)

def m1_wire(cell, x0, y0, x1, y1):
    """Horizontal or vertical m1 wire of width M1W."""
    if abs(y0 - y1) < 1e-9:
        dbox(cell, L["m1"], x0, y0 - M1W / 2, x1, y0 + M1W / 2)
    else:
        dbox(cell, L["m1"], x0 - M1W / 2, y0, x0 + M1W / 2, y1)

def via_on_poly(cell, x, y):
    """Contact landing on poly (lower enc = poly)."""
    contact(cell, x, y, L["m1"], L["poly"])

# ------------------------------------------------------------------ resistor
# Poly strip: active RL in the middle, head regions of HEAD on each side so
# contacts sit HEAD away from the active body. Poly extends ENC_PC beyond each
# contact to satisfy the poly/contact enclosure rule.
PW = RW
PL = RL + 2 * (HEAD + CS / 2 + ENC_PC)   # total poly length
HALF_PL = PL / 2
HALF_PW = PW / 2
ACT_X0 = -RL / 2          # active body starts here (relative to resistor centre)
ACT_X1 = RL / 2
# contact centres: HEAD from active edge, contact half-width CS/2 inside head
CONTACT_OFF = HEAD + CS / 2          # distance from resistor centre line to contact centre
LX = -CONTACT_OFF                    # left contact x (relative)
RX = +CONTACT_OFF                    # right contact x (relative)

def res_unit(cell, cx, cy):
    """One unit poly resistor centred at (cx, cy), active length along x."""
    # poly body
    dbox(cell, L["poly"], cx - HALF_PL, cy - HALF_PW, cx + HALF_PL, cy + HALF_PW)
    # res_mk marker (same size as poly body)
    dbox(cell, L["pplus"], cx - HALF_PL, cy - HALF_PW, cx + HALF_PL, cy + HALF_PW)
    # sab marker: 0.28 beyond poly
    dbox(cell, L["sab"], cx - HALF_PL - 0.28, cy - HALF_PW - 0.28,
         cx + HALF_PL + 0.28, cy + HALF_PW + 0.28)
    # pplus cover around res_mk (0.30 beyond poly on all sides)
    dbox(cell, L["pplus"], cx - HALF_PL - 0.30, cy - HALF_PW - 0.30,
         cx + HALF_PL + 0.30, cy + HALF_PW + 0.30)
    # two contacts on poly, in the head regions
    via_on_poly(cell, cx + LX, cy)
    via_on_poly(cell, cx + RX, cy)
    return (cx + LX, cy), (cx + RX, cy)

# ------------------------------------------------------------------ placement
PITCH_X = 6.0          # horizontal pitch between resistor centres
ROW_PITCH = 7.0        # vertical pitch between the two rows
ROW_H = ROW_PITCH / 2  # half row pitch (row centre offset)

# (name, node_a, node_b, cx_index, row)  cx_index -> x = cx_index * PITCH_X
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
    cy = row * ROW_PITCH
    cx = ci * PITCH_X
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
        return None  # handled by rail
    raise ValueError("node %s not found" % name)

# ------------------------------------------------------------------ VSS rail
# Horizontal m1 rail at y = -ROW_H - M1W (below row 0), spanning all resistors.
rail_y = -ROW_H - M1W - 0.5
rail_x0 = -PITCH_X
rail_x1 = 24 * PITCH_X + PITCH_X
dbox(top, L["m1"], rail_x0 - M1W / 2, rail_y - M1W / 2,
     rail_x1 + M1W / 2, rail_y + M1W / 2)
dtext(top, LAB["m1"], "VSS", rail_x0 - 1.5, rail_y, )

# connect every resistor port that is VSS to the rail
for nm, (cx, cy, a, b, p1, p2) in unit_info.items():
    for node, pt in ((a, p1), (b, p2)):
        if node == "VSS":
            m1_wire(top, pt[0], pt[1], pt[0], rail_y)

# ------------------------------------------------------------------ series resistors RS0..RS6 (horizontal m1)
for i in range(7):
    nm = "RS%d" % i
    cx, cy, a, b, p1, p2 = unit_info[nm]
    m1_wire(top, p1[0], p1[1], p2[0], p2[1])

# ------------------------------------------------------------------ bit inputs B0..B7 (vertical m1 at resistor centre)
for i in range(8):
    nm = "RB%d" % i
    cx, cy, a, b, p1, p2 = unit_info[nm]
    top_y = ROW_H + M1W + 0.5
    dbox(top, L["m1"], cx - M1H / 2, p2[1], cx + M1H / 2, top_y)
    dtext(top, LAB["m1"], "B%d" % i, cx, top_y + 0.3)

# ------------------------------------------------------------------ OUT (vertical m1 at RS6 right port)
cx, cy, a, b, p1, p2 = unit_info["RS6"]
out_top_y = ROW_H + M1W + 0.5
dbox(top, L["m1"], p2[0] - M1H / 2, p2[1], p2[0] + M1H / 2, out_top_y)
dtext(top, LAB["m1"], "OUT", p2[0], out_top_y + 0.3)

# ------------------------------------------------------------------ write
ly.write("r2r8.gds")
print("written r2r8.gds")
```