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
    width={"diff": 0.09, "poly": 0.05, "m1": 0.065, "m2": 0.07},
    space={
        ("diff", "diff"): 0.08, ("poly", "poly"): 0.075,
        ("nplus", "nplus"): 0.045, ("pplus", "pplus"): 0.045,
        ("nplus", "pplus"): 0.045, ("m1", "m1"): 0.065, ("m2", "m2"): 0.07,
        ("nwell", "diff"): 0.055, ("pwell", "diff"): 0.055,
    },
    enc={
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035),
        ("m2", "via1"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    devices={
        "nmos": dict(diff="diff", implant="nplus", well="pwell",
                     w=0.09, l=0.05, bulk="VSS", gate_ext=0.07),
        "pmos": dict(diff="diff", implant="pplus", well="nwell",
                     w=0.18, l=0.05, bulk="VDD", gate_ext=0.07),
    },
)

# ----------------------------------------------------------------------
# Layout database
# ----------------------------------------------------------------------
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

def box(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, x, y):
    """contact on diff/poly to m1"""
    c = TECH["cuts"]["contact"]["size"]
    e = 0.035
    s = c / 2.0
    box(cell, CONT, x - s, y - s, x + s, y + s)
    box(cell, M1, x - s - e, y - s - e, x + s + e, y + s + e)

def via1(cell, x, y):
    c = TECH["cuts"]["via1"]["size"]
    e = 0.035
    s = c / 2.0
    box(cell, VIA1, x - s, y - s, x + s, y + s)
    box(cell, M1, x - s - e, y - s - e, x + s + e, y + s + e)
    box(cell, M2, x - s - e, y - s - e, x + s + e, y + s + e)

# ----------------------------------------------------------------------
# DFF cell  (22 transistors, master-slave pair of clocked inverters)
# ----------------------------------------------------------------------
def build_dff(cell):
    # cell outline
    W, H = 4.6, 5.2

    # placement grid
    # nmos row: y = 1.0   pmos row: y = 4.2
    # transistor x positions: 0.6, 1.2, 1.8, 2.4, 3.0, 3.6, 4.0
    yn, yp = 1.0, 4.2
    xs = [0.6, 1.2, 1.8, 2.4, 3.0, 3.6, 4.0]

    # keep track of terminals for routing
    # each terminal: (net, x, y, kind)  kind = 'diff' or 'gate'
    terms = []

    def add_mos(x, y, dev, gate, src, drn, bulk):
        d = TECH["devices"][dev]
        w, l = d["w"], d["l"]
        ge = d["gate_ext"]
        well_layer = NWELL if dev == "pmos" else PWELL
        impl_layer = PPLUS if dev == "pmos" else NPLUS

        # well
        we = 0.055
        box(cell, well_layer, x - w / 2 - we, y - l / 2 - we,
                   x + w / 2 + we, y + l / 2 + we)

        # diffusion (runs horizontally, x direction)
        dw = 0.20   # diffusion width in y
        box(cell, DIFF, x - w / 2, y - dw / 2, x + w / 2, y + dw / 2)

        # implant
        box(cell, impl_layer, x - w / 2 - ge, y - dw / 2 - ge,
                   x + w / 2 + ge, y + dw / 2 + ge)

        # poly gate (runs vertically)
        pl = 1.6   # poly length in y
        box(cell, POLY, x - l / 2, y - pl / 2, x + l / 2, y + pl / 2)

        # terminals
        terms.append((src, x - w / 2, y, "diff"))
        terms.append((drn, x + w / 2, y, "diff"))
        terms.append((gate, x, y, "gate"))
        terms.append((bulk, x, y, "well"))

        # contacts
        contact(cell, x - w / 2, y)   # source
        contact(cell, x + w / 2, y)   # drain
        contact(cell, x, y)           # gate

    # ---------- nmos transistors ----------
    # Mn0_0 VSS CK CKB VSS
    add_mos(xs[0], yn, "nmos", "CK", "VSS", "CKB", "VSS")
    # Mn0_1 n1 D VSS VSS
    add_mos(xs[1], yn, "nmos", "D", "VSS", "n1", "VSS")
    # Mn0_2 m CKB n1 VSS
    add_mos(xs[2], yn, "nmos", "CKB", "n1", "m", "VSS")
    # Mn0_3 n2 CK m VSS
    add_mos(xs[3], yn, "nmos", "CK", "m", "n2", "VSS")
    # Mn0_4 VSS mb n2 VSS
    add_mos(xs[4], yn, "nmos", "mb", "VSS", "n2", "VSS")
    # Mn0_5 mb m VSS VSS
    add_mos(xs[5], yn, "nmos", "m", "VSS", "mb", "VSS")
    # Mn7_0 n3 Q VSS VSS
    add_mos(xs[0], yn + 1.1, "nmos", "Q", "VSS", "n3", "VSS")
    # Mn7_1 s CKB n3 VSS
    add_mos(xs[1], yn + 1.1, "nmos", "CKB", "n3", "s", "VSS")
    # Mn7_2 n4 CK s VSS
    add_mos(xs[2], yn + 1.1, "nmos", "CK", "s", "n4", "VSS")
    # Mn7_3 VSS mb n4 VSS
    add_mos(xs[3], yn + 1.1, "nmos", "mb", "VSS", "n4", "VSS")
    # Mn7_4 Q s VSS VSS
    add_mos(xs[4], yn + 1.1, "nmos", "s", "VSS", "Q", "VSS")

    # ---------- pmos transistors ----------
    # Mp0_0 VDD CK CKB VDD
    add_mos(xs[0], yp, "pmos", "CK", "VDD", "CKB", "VDD")
    # Mp0_1 p1 D VDD VDD
    add_mos(xs[1], yp, "pmos", "D", "VDD", "p1", "VDD")
    # Mp0_2 m CK p1 VDD
    add_mos(xs[2], yp, "pmos", "CK", "p1", "m", "VDD")
    # Mp0_3 p2 CKB m VDD
    add_mos(xs[3], yp, "pmos", "CKB", "m", "p2", "VDD")
    # Mp0_4 VDD mb p2 VDD
    add_mos(xs[4], yp, "pmos", "mb", "VDD", "p2", "VDD")
    # Mp0_5 mb m VDD VDD
    add_mos(xs[5], yp, "pmos", "m", "VDD", "mb", "VDD")
    # Mp7_0 p3 Q VDD VDD
    add_mos(xs[0], yp + 1.1, "pmos", "Q", "VDD", "p3", "VDD")
    # Mp7_1 s CK p3 VDD
    add_mos(xs[1], yp + 1.1, "pmos", "CK", "p3", "s", "VDD")
    # Mp7_2 p4 CKB s VDD
    add_mos(xs[2], yp + 1.1, "pmos", "CKB", "s", "p4", "VDD")
    # Mp7_3 VDD mb p4 VDD
    add_mos(xs[3], yp + 1.1, "pmos", "mb", "VDD", "p4", "VDD")
    # Mp7_4 Q s VDD VDD
    add_mos(xs[4], yp + 1.1, "pmos", "s", "VDD", "Q", "VDD")

    # ---------- metal1 routing ----------
    # collect terminals per net
    net_terms = {}
    for net, x, y, kind in terms:
        net_terms.setdefault(net, []).append((x, y, kind))

    # power rails
    box(cell, M1, 0.15, 0.15, W - 0.15, 0.35)
    label(cell, M1LAB, "VSS", 0.25, 0.25)
    box(cell, M1, 0.15, H - 0.35, W - 0.15, H - 0.15)
    label(cell, M1LAB, "VDD", 0.25, H - 0.25)
    box(cell, M1, 0.15, 2.45, W - 0.15, 2.65)
    label(cell, M1LAB, "CK", 0.25, 2.55)

    def route_net(net, yrail):
        pts = net_terms.get(net, [])
        if not pts:
            return
        xs_ = [p[0] for p in pts]
        ys_ = [p[1] for p in pts]
        x0, x1 = min(xs_), max(xs_)
        y0, y1 = min(ys_), max(ys_)
        # vertical bus at average x
        xb = (x0 + x1) / 2
        box(cell, M1, xb - 0.03, min(y0, yrail) - 0.03, xb + 0.03, max(y1, yrail) + 0.03)
        # horizontal rail
        box(cell, M1, min(x0, xb) - 0.03, yrail - 0.03, max(x1, xb) + 0.03, yrail + 0.03)
        # contacts at each terminal
        for x, y, kind in pts:
            if kind == "well":
                continue
            contact(cell, x, y)
            # connect contact to vertical bus
            box(cell, M1, min(x, xb) - 0.03, y - 0.03, max(x, xb) + 0.03, y + 0.03)

    # route each net to a rail
    route_net("VSS", 0.25)
    route_net("VDD", H - 0.25)
    route_net("CK", 2.55)
    route_net("D", 0.85)
    route_net("Q", H - 0.85)
    for net in ["CKB", "n1", "m", "n2", "mb", "s", "n3", "n4", "p1", "p2", "p3", "p4"]:
        route_net(net, 1.65)

    # ---------- external pins ----------
    # D input (left)
    box(cell, M1, 0.0, 0.8, 0.2, 1.0)
    label(cell, M1LAB, "D", 0.1, 0.9)
    contact(cell, 0.1, 0.9)

    # Q output (right)
    box(cell, M1, W - 0.2, 4.2, W, 4.4)
    label(cell, M1LAB, "Q", W - 0.1, 4.3)
    contact(cell, W - 0.1, 4.3)

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
    pitch = W + 0.3

    cols, rows = 4, 4
    for r in range(rows):
        for c in range(cols):
            idx = r * cols + c
            if idx >= 16:
                break
            top.insert(kdb.DCellInstArray(dff.cell_index(),
                                          kdb.DTrans(c * pitch, r * H + 0.2)))

    # global rails on metal2
    tot_w = cols * pitch
    tot_h = rows * H + 0.4
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
            cy = r * H + 0.2 + H / 2
            via1(top, cx, 0.2)      # VSS
            via1(top, cx, tot_h - 0.2)  # VDD
            via1(top, cx, tot_h / 2)    # CK

    # D input to first stage
    box(top, M1, 0.0, 0.2 + 0.9, 0.2, 0.2 + 1.1)
    label(top, M1LAB, "D", 0.1, 0.2 + 1.0)
    via1(top, 0.1, 0.2 + 1.0)

    # Q outputs and inter-stage connections (snake: row-major)
    q_names = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7",
               "Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15"]
    for i, qname in enumerate(q_names):
        r, c = divmod(i, cols)
        cx = c * pitch + W - 0.1
        cy = r * H + 0.2 + 4.3
        box(top, M1, cx - 0.1, cy - 0.1, cx + 0.1, cy + 0.1)
        label(top, M1LAB, qname, cx, cy)
        via1(top, cx, cy)

        # connect Q[i] to D[i+1]
        if i < 15:
            nr, nc = divmod(i + 1, cols)
            nx = nc * pitch + 0.1
            ny = nr * H + 0.2 + 1.0
            # route on metal1
            box(top, M1, min(cx, nx) - 0.03, cy - 0.03, max(cx, nx) + 0.03, cy + 0.03)
            box(top, M1, nx - 0.03, min(cy, ny) - 0.03, nx + 0.03, max(cy, ny) + 0.03)
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
print("bbox um:", top.bbox().width(), top.bbox().height(),
      "area um2:", top.bbox().width() * top.bbox().height())
