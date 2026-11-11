import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK: freepdk45  (all units in um)
# ----------------------------------------------------------------------
TECH = dict(
    grid=0.005,
    gds_dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0),
        "nplus": (4, 0), "pplus": (5, 0), "poly": (9, 0),
        "contact": (10, 0), "m1": (11, 0), "via1": (12, 0), "m2": (13, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    cuts={
        "contact": dict(size=0.065, space=0.075),
        "via1": dict(size=0.07, space=0.075),
    },
    devices={
        "nmos": dict(diff="diff", implant="nplus", well="pwell",
                     w=0.09, l=0.05, bulk="VSS", gate_ext=0.07),
        "pmos": dict(diff="diff", implant="pplus", well="nwell",
                     w=0.18, l=0.05, bulk="VDD", gate_ext=0.07),
    },
)

ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]

DIFF   = ly.layer(*TECH["layers"]["diff"])
PWELL  = ly.layer(*TECH["layers"]["pwell"])
NWELL  = ly.layer(*TECH["layers"]["nwell"])
NPLUS  = ly.layer(*TECH["layers"]["nplus"])
PPLUS  = ly.layer(*TECH["layers"]["pplus"])
POLY   = ly.layer(*TECH["layers"]["poly"])
CONT   = ly.layer(*TECH["layers"]["contact"])
M1     = ly.layer(*TECH["layers"]["m1"])
M1LAB  = ly.layer(*TECH["label"]["m1"])
VIA1   = ly.layer(*TECH["layers"]["via1"])
M2     = ly.layer(*TECH["layers"]["m2"])
M2LAB  = ly.layer(*TECH["label"]["m2"])

C_SIZE = TECH["cuts"]["contact"]["size"]   # 0.065
C_HALF = C_SIZE / 2.0                      # 0.0325
C_ENC  = 0.035                             # m1 enclosure of contact
V_SIZE = TECH["cuts"]["via1"]["size"]      # 0.07
V_HALF = V_SIZE / 2.0                      # 0.035
V_ENC  = 0.035                             # m1/m2 enclosure of via1

def box(cell, layer, x1, y1, x2, y2):
    """DBox takes micrometres directly."""
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    """DTrans takes micrometres directly."""
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, x, y):
    """65x65 contact on diff/poly, m1 extends 35nm beyond on all sides."""
    box(cell, CONT, x - C_HALF, y - C_HALF, x + C_HALF, y + C_HALF)
    box(cell, M1, x - C_HALF - C_ENC, y - C_HALF - C_ENC,
             x + C_HALF + C_ENC, y + C_HALF + C_ENC)

def via1(cell, x, y):
    """70x70 via1, m1 and m2 extend 35nm beyond on all sides."""
    box(cell, VIA1, x - V_HALF, y - V_HALF, x + V_HALF, y + V_HALF)
    box(cell, M1, x - V_HALF - V_ENC, y - V_HALF - V_ENC,
             x + V_HALF + V_ENC, y + V_HALF + V_ENC)
    box(cell, M2, x - V_HALF - V_ENC, y - V_HALF - V_ENC,
             x + V_HALF + V_ENC, y + V_HALF + V_ENC)

# ----------------------------------------------------------------------
# DFF cell  (22 transistors, compact two-row standard cell)
# ----------------------------------------------------------------------
def build_dff(cell):
    W, H = 4.6, 2.6   # cell dimensions

    yn, yp = 0.65, 1.95   # nmos / pmos row centre lines
    pitch = 0.38
    x0 = 0.55

    terms = []   # (net, x, y, kind)

    def add_mos(x, y, dev, gate, src, drn, bulk):
        d = TECH["devices"][dev]
        w, l = d["w"], d["l"]
        ge = d["gate_ext"]
        well_layer = NWELL if dev == "pmos" else PWELL
        impl_layer = PPLUS if dev == "pmos" else NPLUS
        we = 0.055

        # diffusion bounds (horizontal in x)
        dx1 = x - l / 2 - ge
        dx2 = x + l / 2 + ge
        dy1 = y - w / 2
        dy2 = y + w / 2

        # well: 55nm enclosure of diffusion
        box(cell, well_layer, dx1 - we, dy1 - we, dx2 + we, dy2 + we)

        # diffusion
        box(cell, DIFF, dx1, dy1, dx2, dy2)

        # implant
        box(cell, impl_layer, dx1 - ge, dy1 - ge, dx2 + ge, dy2 + ge)

        # poly gate (vertical strip, 50nm wide = gate length)
        box(cell, POLY, x - l / 2, dy1 - ge, x + l / 2, dy2 + ge)

        # poly contact pad: horizontal tab so 65nm contact fits with 5nm poly enclosure
        pad_w = 0.075   # 65nm contact + 2*5nm enclosure
        pad_h = 0.065   # contact height
        box(cell, POLY, x - pad_w / 2, y - pad_h / 2, x + pad_w / 2, y + pad_h / 2)

        # contacts: source/drain on diffusion, gate on poly pad
        cs = C_HALF + 0.020   # contact inset from diffusion edge
        contact(cell, dx1 + cs, y)     # source on diffusion
        contact(cell, dx2 - cs, y)     # drain on diffusion
        contact(cell, x, y)            # gate on poly pad

        terms.append((src, dx1 + cs, y, "diff"))
        terms.append((drn, dx2 - cs, y, "diff"))
        terms.append((gate, x, y, "poly"))
        terms.append((bulk, x, y, "well"))

    # ---------- nmos ----------
    add_mos(x0 + 0*pitch, yn, "nmos", "CK", "CKB", "VSS", "VSS")      # Mn0_0
    add_mos(x0 + 1*pitch, yn, "nmos", "D",  "n1",  "VSS", "VSS")      # Mn0_1
    add_mos(x0 + 2*pitch, yn, "nmos", "CKB","m",   "n1",  "VSS")      # Mn0_2
    add_mos(x0 + 3*pitch, yn, "nmos", "CK", "n2",  "m",   "VSS")      # Mn0_3
    add_mos(x0 + 4*pitch, yn, "nmos", "mb", "n2",  "VSS", "VSS")      # Mn0_4
    add_mos(x0 + 5*pitch, yn, "nmos", "m",  "mb",  "VSS", "VSS")      # Mn0_5
    add_mos(x0 + 0*pitch, yn + 1.05, "nmos", "Q", "n3",  "VSS", "VSS")# Mn7_0
    add_mos(x0 + 1*pitch, yn + 1.05, "nmos", "CKB","s",  "n3",  "VSS")# Mn7_1
    add_mos(x0 + 2*pitch, yn + 1.05, "nmos", "CK", "n4",  "s",   "VSS")# Mn7_2
    add_mos(x0 + 3*pitch, yn + 1.05, "nmos", "mb", "n4",  "VSS", "VSS")# Mn7_3
    add_mos(x0 + 4*pitch, yn + 1.05, "nmos", "s",  "Q",   "VSS", "VSS")# Mn7_4

    # ---------- pmos ----------
    add_mos(x0 + 0*pitch, yp, "pmos", "CK", "CKB", "VDD", "VDD")      # Mp0_0
    add_mos(x0 + 1*pitch, yp, "pmos", "D",  "p1",  "VDD", "VDD")      # Mp0_1
    add_mos(x0 + 2*pitch, yp, "pmos", "CK", "m",   "p1",  "VDD")      # Mp0_2
    add_mos(x0 + 3*pitch, yp, "pmos", "CKB","p2",  "m",   "VDD")      # Mp0_3
    add_mos(x0 + 4*pitch, yp, "pmos", "mb", "p2",  "VDD", "VDD")      # Mp0_4
    add_mos(x0 + 5*pitch, yp, "pmos", "m",  "mb",  "VDD", "VDD")      # Mp0_5
    add_mos(x0 + 0*pitch, yp + 1.05, "pmos", "Q", "p3",  "VDD", "VDD")# Mp7_0
    add_mos(x0 + 1*pitch, yp + 1.05, "pmos", "CK", "s",  "p3",  "VDD")# Mp7_1
    add_mos(x0 + 2*pitch, yp + 1.05, "pmos", "CKB","p4",  "s",   "VDD")# Mp7_2
    add_mos(x0 + 3*pitch, yp + 1.05, "pmos", "mb", "p4",  "VDD", "VDD")# Mp7_3
    add_mos(x0 + 4*pitch, yp + 1.05, "pmos", "s",  "Q",   "VDD", "VDD")# Mp7_4

    # ---------- metal1 routing ----------
    net_terms = {}
    for net, x, y, kind in terms:
        if kind == "well":
            continue
        net_terms.setdefault(net, []).append((x, y))

    # power / clock rails
    box(cell, M1, 0.15, 0.15, W - 0.15, 0.35)
    label(cell, M1LAB, "VSS", 0.25, 0.25)
    box(cell, M1, 0.15, H - 0.35, W - 0.15, H - 0.15)
    label(cell, M1LAB, "VDD", 0.25, H - 0.25)
    box(cell, M1, 0.15, 1.25, W - 0.15, 1.45)
    label(cell, M1LAB, "CK", 0.25, 1.35)

    def route_net(net, yrail):
        pts = net_terms.get(net, [])
        if not pts:
            return
        xs_ = [p[0] for p in pts]
        ys_ = [p[1] for p in pts]
        x0_, x1_ = min(xs_), max(xs_)
        y0_, y1_ = min(ys_), max(ys_)
        xb = (x0_ + x1_) / 2
        # vertical trunk
        box(cell, M1, xb - 0.035, min(y0_, yrail) - 0.035,
                 xb + 0.035, max(y1_, yrail) + 0.035)
        # horizontal rail
        box(cell, M1, min(x0_, xb) - 0.035, yrail - 0.035,
                 max(x1_, xb) + 0.035, yrail + 0.035)
        # connect each terminal
        for x, y in pts:
            contact(cell, x, y)
            box(cell, M1, min(x, xb) - 0.035, y - 0.035,
                     max(x, xb) + 0.035, y + 0.035)

    route_net("VSS", 0.25)
    route_net("VDD", H - 0.25)
    route_net("CK", 1.35)
    route_net("D", 0.55)
    route_net("Q", H - 0.55)
    for net in ["CKB", "n1", "m", "n2", "mb", "s", "n3", "n4",
                "p1", "p2", "p3", "p4"]:
        route_net(net, 0.95)

    # ---------- external pins ----------
    box(cell, M1, 0.0, 0.50, 0.2, 0.70)
    label(cell, M1LAB, "D", 0.1, 0.60)
    contact(cell, 0.1, 0.60)

    box(cell, M1, W - 0.2, 1.90, W, 2.10)
    label(cell, M1LAB, "Q", W - 0.1, 2.00)
    contact(cell, W - 0.1, 2.00)

    cell.dbu_width = int(W / ly.dbu)
    cell.dbu_height = int(H / ly.dbu)

# ----------------------------------------------------------------------
# Top cell shreg16
# ----------------------------------------------------------------------
def build_top():
    top = ly.create_cell("shreg16")
    dff = ly.create_cell("dff")
    build_dff(dff)

    W = dff.dbu_width * ly.dbu
    H = dff.dbu_height * ly.dbu
    pitch = W + 0.25

    cols, rows = 4, 4
    for r in range(rows):
        for c in range(cols):
            idx = r * cols + c
            if idx >= 16:
                break
            top.insert(kdb.DCellInstArray(dff.cell_index(),
                                          kdb.DTrans(c * pitch, r * H)))

    tot_w = cols * pitch
    tot_h = rows * H

    # global rails on metal2
    box(top, M2, 0.0, 0.1, tot_w, 0.3)
    label(top, M2LAB, "VSS", 0.1, 0.2)
    box(top, M2, 0.0, tot_h - 0.3, tot_w, tot_h - 0.1)
    label(top, M2LAB, "VDD", 0.1, tot_h - 0.2)
    box(top, M2, 0.0, tot_h / 2 - 0.1, tot_w, tot_h / 2 + 0.1)
    label(top, M2LAB, "CK", 0.1, tot_h / 2)

    # connect each dff to rails
    for r in range(rows):
        for c in range(cols):
            idx = r * cols + c
            if idx >= 16:
                break
            cx = c * pitch + W / 2
            cy = r * H + H / 2
            via1(top, cx, 0.2)
            via1(top, cx, tot_h - 0.2)
            via1(top, cx, tot_h / 2)

    # D input to first stage
    box(top, M1, 0.0, 0.55, 0.2, 0.65)
    label(top, M1LAB, "D", 0.1, 0.60)
    via1(top, 0.1, 0.60)

    # Q outputs and inter-stage connections (row-major snake)
    q_names = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7",
               "Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15"]
    for i, qname in enumerate(q_names):
        r, c = divmod(i, cols)
        cx = c * pitch + W - 0.1
        cy = r * H + 2.00
        box(top, M1, cx - 0.1, cy - 0.1, cx + 0.1, cy + 0.1)
        label(top, M1LAB, qname, cx, cy)
        via1(top, cx, cy)

        if i < 15:
            nr, nc = divmod(i + 1, cols)
            nx = nc * pitch + 0.1
            ny = nr * H + 0.60
            box(top, M1, min(cx, nx) - 0.035, cy - 0.035,
                     max(cx, nx) + 0.035, cy + 0.035)
            box(top, M1, nx - 0.035, min(cy, ny) - 0.035,
                     nx + 0.035, max(cy, ny) + 0.035)
            via1(top, nx, cy)
            via1(top, nx, ny)

    # CK input pin
    box(top, M1, tot_w - 0.2, tot_h / 2 - 0.1, tot_w, tot_h / 2 + 0.1)
    label(top, M1LAB, "CK", tot_w - 0.1, tot_h / 2)
    via1(top, tot_w - 0.1, tot_h / 2)

    return top

# ----------------------------------------------------------------------
top = build_top()
ly.write("shreg16.gds")
print("wrote shreg16.gds")
bb = top.bbox()
print("bbox um:", bb.width(), bb.height(), "area um2:", bb.width() * bb.height())
