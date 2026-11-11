import klayout.db as db

OUT = "/home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-raw-a21oi/a21oi.gds"
DX = 0.18          # global x shift so the n-well starts inside the cell
DBU = 1000         # 1 dbu = 0.001 um
CELL_W = 2.76      # 6 x 0.46 um

LAY = {
    "nwell": (64, 20), "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
    "licon": (66, 44), "npc": (95, 20), "nsdm": (93, 44), "psdm": (94, 20),
    "li": (67, 20), "mcon": (67, 44), "met1": (68, 20), "via": (68, 44),
    "met2": (69, 20), "li_pin": (67, 16), "met1_pin": (68, 16),
    "met2_pin": (69, 16), "li_lbl": (67, 5), "met1_lbl": (68, 5),
    "met2_lbl": (69, 5),
}

ly = db.Layout()
ly.dbu = 0.001
top = ly.create_cell("a21oi")
IDX = {k: ly.layer(*v) for k, v in LAY.items()}


def _ins(layer, x0, y0, x1, y1):
    top.shapes(IDX[layer]).insert(
        db.Box(round(x0 * DBU), round(y0 * DBU), round(x1 * DBU), round(y1 * DBU)))


def box(layer, x0, y0, x1, y1):
    """Rectangle in the device frame (x shifted by DX)."""
    _ins(layer, x0 + DX, y0, x1 + DX, y1)


def box_raw(layer, x0, y0, x1, y1):
    """Rectangle in absolute cell coordinates."""
    _ins(layer, x0, y0, x1, y1)


def label(layer, text, x, y):
    top.shapes(IDX[layer]).insert(
        db.Text(text, db.Trans(round((x + DX) * DBU), round(y * DBU))))


# ---------------- rails (met1, centred on y=0 and y=2.72) ----------------
box_raw("met1", 0, -0.17, CELL_W, 0.17)
box_raw("met1", 0, 2.55, CELL_W, 2.89)
label("met1_lbl", "VGND", 0.10, 0.0)
label("met1_lbl", "VPWR", 0.10, 2.72)
box_raw("met1_pin", 0, -0.17, CELL_W, 0.17)
box_raw("met1_pin", 0, 2.55, CELL_W, 2.89)
label("met1_pin", "VGND", 0.10, 0.0)
label("met1_pin", "VPWR", 0.10, 2.72)

# ---------------- wells and implants ----------------
box("nwell", -0.18, 1.50, 2.32, 2.61)
# nmos row
box("diff", 0.00, 0.36, 1.58, 0.85)
box("nsdm", -0.125, 0.235, 1.705, 0.975)
# p-tap (substrate tie, right end of nmos row)
box("diff", 1.85, 0.36, 2.14, 0.85)
box("tap", 1.85, 0.36, 2.14, 0.85)
box("psdm", 1.725, 0.235, 2.265, 0.975)
# pmos row
box("diff", 0.00, 1.68, 1.58, 2.43)
box("psdm", -0.125, 1.555, 1.705, 2.555)
# n-tap (well tie, right end of pmos row)
box("diff", 1.85, 1.68, 2.14, 2.43)
box("tap", 1.85, 1.68, 2.14, 2.43)
box("nsdm", 1.725, 1.555, 2.265, 2.555)

# ---------------- poly gates (B1, A2, A1 columns) ----------------
GATES = {"B1": (0.285, 0.435), "A2": (0.715, 0.865), "A1": (1.145, 1.295)}
for name, (x0, x1) in GATES.items():
    box("poly", x0, 0.23, x1, 2.56)

# poly pads + poly contacts in the gap between the rows
PADS = {"B1": (0.165, 0.435, 0.215, 0.385),
        "A2": (0.645, 0.915, 0.695, 0.865),
        "A1": (1.125, 1.395, 1.175, 1.345)}
for name, (px0, px1, cx0, cx1) in PADS.items():
    box("poly", px0, 1.075, px1, 1.405)
    box("licon", cx0, 1.155, cx1, 1.325)
    box("li", cx0, 1.075, cx1, 1.405)
    box("mcon", cx0, 1.155, cx1, 1.325)
    box("met1", cx0 - 0.07, 1.095, cx1 + 0.07, 1.385)
    box("met1_pin", cx0 - 0.07, 1.095, cx1 + 0.07, 1.385)
    label("met1_pin", name, (cx0 + cx1) / 2, 1.24)
    label("met1_lbl", name, (cx0 + cx1) / 2, 1.24)
box("npc", 0.115, 1.055, 1.445, 1.425)

# ---------------- diffusion contacts ----------------
def diff_contact(x0, y0, x1, y1, to_met1=False):
    box("licon", x0, y0, x1, y1)


# nmos row, licon y 0.52..0.69
box("licon", 0.06, 0.52, 0.23, 0.69)   # Y (left end, under B1)
box("li", 0.06, 0.44, 0.23, 0.77)
box("mcon", 0.06, 0.52, 0.23, 0.69)
box("met1", 0.015, 0.445, 0.275, 0.765)
box("via", 0.07, 0.53, 0.22, 0.68)

box("licon", 0.49, 0.52, 0.66, 0.69)   # VGND (middle)
box("li", 0.49, -0.165, 0.66, 0.77)
box("mcon", 0.49, -0.085, 0.66, 0.085)

box("licon", 1.35, 0.52, 1.52, 0.69)   # Y (right end, under A1)
box("li", 1.35, 0.44, 1.52, 0.77)
box("mcon", 1.35, 0.52, 1.52, 0.69)
box("met1", 1.305, 0.445, 1.565, 0.765)
box("via", 1.36, 0.53, 1.51, 0.68)

box("licon", 1.91, 0.52, 2.08, 0.69)   # p-tap to VGND
box("li", 1.91, -0.165, 2.08, 0.77)
box("mcon", 1.91, -0.085, 2.08, 0.085)

# pmos row, licon y 1.97..2.14
box("licon", 0.06, 1.97, 0.23, 2.14)   # Y (left end, under B1)
box("li", 0.06, 1.89, 0.23, 2.22)
box("mcon", 0.06, 1.97, 0.23, 2.14)
box("met1", 0.015, 1.895, 0.275, 2.215)
box("via", 0.07, 1.98, 0.22, 2.13)

box("licon", 0.49, 1.97, 0.66, 2.14)   # n2 (under B1 / A2)
box("li", 0.49, 1.89, 0.66, 2.22)
box("mcon", 0.49, 1.97, 0.66, 2.14)
box("met1", 0.445, 1.895, 0.705, 2.215)
box("via", 0.50, 1.98, 0.65, 2.13)

box("licon", 0.92, 1.97, 1.09, 2.14)   # VPWR (middle, under A2 / A1)
box("li", 0.92, 1.89, 1.09, 2.885)
box("mcon", 0.92, 2.635, 1.09, 2.805)

box("licon", 1.35, 1.97, 1.52, 2.14)   # n2 (right end, under A1)
box("li", 1.35, 1.89, 1.52, 2.22)
box("mcon", 1.35, 1.97, 1.52, 2.14)
box("met1", 1.305, 1.895, 1.565, 2.215)
box("via", 1.36, 1.98, 1.51, 2.13)

box("licon", 1.91, 1.97, 2.08, 2.14)   # n-tap to VPWR
box("li", 1.91, 1.89, 2.08, 2.885)
box("mcon", 1.91, 2.635, 2.08, 2.805)

# ---------------- met2 routing ----------------
# Y: left-end nmos and pmos contacts, bottom bar, right-end nmos contact
box("met2", 0.015, 0.445, 0.275, 0.765)
box("met2", 0.015, 1.895, 0.275, 2.215)
box("met2", 0.075, 0.46, 0.215, 2.215)
box("met2", 0.075, 0.14, 1.565, 0.46)
box("met2", 1.305, 0.14, 1.565, 0.765)
# n2: horizontal bar over the pmos row joining the two n2 contacts
box("met2", 0.445, 1.895, 1.565, 2.215)

# ---------------- pin datatypes (ports) ----------------
# Y pin: rectangle on the 69/16 pin datatype on top of the met2 wire, with label
box("met2_pin", 0.075, 0.46, 0.215, 1.00)
label("met2_pin", "Y", 0.145, 0.80)
label("met2_lbl", "Y", 0.145, 0.80)

ly.write(OUT)
print("wrote", OUT)
