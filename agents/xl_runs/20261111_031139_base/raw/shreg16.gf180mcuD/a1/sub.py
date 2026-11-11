import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data for gf180mcuD (um)
# ----------------------------------------------------------------------
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "pwell": (204, 0), "dnwell": (12, 0),
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0), "sab": (49, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0), "via2": (38, 0), "m3": (42, 0),
        "via3": (40, 0), "m4": (46, 0), "via4": (41, 0), "m5": (81, 0),
        "capm": (75, 0), "cap_mk": (117, 5), "res_mk": (110, 5), "hres": (62, 0), "dualgate": (55, 0),
        "v5_xtor": (112, 1), "nat": (5, 0), "diode_mk": (115, 5), "mos_cap_mk": (166, 5),
        "m1res": (110, 11), "m2res": (110, 12), "m3res": (110, 13), "m4res": (110, 14), "m5res": (110, 15),
        "boundary": (0, 0), "ind_mk": (151, 5),
    },
    label={"poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
           "nwell": (21, 10), "pwell": (204, 10)},
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
    },
    width={"diff": 0.22, "poly": 0.18, "nplus": 0.40, "pplus": 0.40, "m1": 0.23, "m2": 0.28},
    space={
        ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("nplus", "nplus"): 0.40, ("pplus", "pplus"): 0.40,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28,
        ("nwell", "diff"): 0.43,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
        ("nwell", "diff"): (0.43, 0.43),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        gate_space=0.24,
        tap_diff_space=0.32,
    ),
    devices={
        "nmos": dict(diff="diff", implant="nplus", well=None, lmin=0.28, wmin=0.22, bulk="VSS"),
        "pmos": dict(diff="diff", implant="pplus", well="nwell", lmin=0.28, wmin=0.22, bulk="VDD"),
        "ptap": dict(diff="diff", implant="pplus", well=None),
        "ntap": dict(diff="diff", implant="nplus", well="nwell", well_enc=0.12),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

LY = TECH["layers"]
LBL = TECH["label"]
GRID = TECH["grid"]

# ----------------------------------------------------------------------
# helpers
# ----------------------------------------------------------------------
def R(x, y):
    """Snap to grid and return kdb.DBox."""
    return kdb.DBox(round(x / GRID) * GRID, round(y / GRID) * GRID,
                    round(x / GRID) * GRID, round(y / GRID) * GRID)

def box(ly, cell, layer, x1, y1, x2, y2):
    cell.shapes(ly[layer]).insert(R(x1, y1))
    cell.shapes(ly[layer]).insert(kdb.DBox(R(x1, y1).p1, R(x2, y2).p2))

def label(ly, cell, layer, text, x, y):
    cell.shapes(ly[layer]).insert(kdb.DText(text, kdb.DTrans(round(x / GRID) * GRID,
                                                             round(y / GRID) * GRID)))

def contact(ly, cell, x, y, sz=None):
    """M1 contact over diff/poly."""
    s = TECH["cuts"]["contact"]["size"] if sz is None else sz
    box(ly, cell, "contact", x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, "m1", x - s / 2 - 0.07, y - s / 2 - 0.07, x + s / 2 + 0.07, y + s / 2 + 0.07)

def via1(ly, cell, x, y):
    s = TECH["cuts"]["via1"]["size"]
    box(ly, cell, "via1", x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, "m1", x - s / 2 - 0.06, y - s / 2 - 0.06, x + s / 2 + 0.06, y + s / 2 + 0.06)
    box(ly, cell, "m2", x - s / 2 - 0.07, y - s / 2 - 0.07, x + s / 2 + 0.07, y + s / 2 + 0.07)

def m1wire(ly, cell, x1, y1, x2, y2, w=0.23):
    if x1 == x2:
        box(ly, cell, "m1", x1 - w / 2, y1, x1 + w / 2, y2)
    else:
        box(ly, cell, "m1", x1, y1 - w / 2, x2, y1 + w / 2)

def m2wire(ly, cell, x1, y1, x2, y2, w=0.28):
    if x1 == x2:
        box(ly, cell, "m2", x1 - w / 2, y1, x1 + w / 2, y2)
    else:
        box(ly, cell, "m2", x1, y1 - w / 2, x2, y1 + w / 2)

def nwell_box(ly, cell, x1, y1, x2, y2):
    box(ly, cell, "nwell", x1, y1, x2, y2)
    box(ly, cell, "pwell", x1 - 0.10, y1 - 0.10, x2 + 0.10, y2 + 0.10)

def tap(ly, cell, kind, x, y, w=0.60, h=1.60):
    """Well tap: diff + implant, nwell for ntap."""
    if kind == "p":
        box(ly, cell, "diff", x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        box(ly, cell, "pplus", x - w / 2 - 0.16, y - h / 2 - 0.16,
            x + w / 2 + 0.16, y + h / 2 + 0.16)
    else:
        nwell_box(ly, cell, x - w / 2 - 0.12, y - h / 2 - 0.12,
                  x + w / 2 + 0.12, y + h / 2 + 0.12)
        box(ly, cell, "diff", x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        box(ly, cell, "nplus", x - w / 2 - 0.16, y - h / 2 - 0.16,
            x + w / 2 + 0.16, y + h / 2 + 0.16)

# ----------------------------------------------------------------------
# DFF cell (master-slave, 22 transistors)
# ----------------------------------------------------------------------
def build_dff(ly, name):
    cell = ly.create_cell(name)
    W = 22.0          # cell width
    H = 26.0          # cell height
    L = 0.28          # gate length
    WN = 0.36         # nmos width
    WP = 0.72         # pmos width
    EXT = 0.22        # poly endcap beyond diff
    CS = 0.22         # contact size
    CE = 0.07         # contact enclosure on diff/poly

    # rails
    yvss = 2.0
    yvdd = H - 2.0
    yck = 6.0
    yckb = H - 6.0

    # ---------------------------------------------------------------- nwell
    nwell_box(ly, cell, 0.0, 0.0, W, H)

    # ---------------------------------------------------------------- rails
    box(ly, cell, "diff", 0.0, yvss - 0.18, W, yvss + 0.18)          # VSS rail
    box(ly, cell, "nplus", -0.16, yvss - 0.18 - 0.16, W + 0.16, yvss + 0.18 + 0.16)
    box(ly, cell, "diff", 0.0, yvdd - 0.18, W, yvdd + 0.18)          # VDD rail
    box(ly, cell, "pplus", -0.16, yvdd - 0.18 - 0.16, W + 0.16, yvdd + 0.18 + 0.16)

    # ---------------------------------------------------------------- transistors
    # (name, kind, x, yc, drain_net, gate_net, source_net)
    nmos_list = [
        ("Mn0_0", 1.20, yck,   "VSS", "CK",  "CKB"),
        ("Mn0_1", 4.20, yvss,  "n1",  "D",   "VSS"),
        ("Mn0_2", 7.20, yckb,  "m",   "CKB", "n1"),
        ("Mn0_3", 10.20, yck,  "n2",  "CK",  "m"),
        ("Mn0_4", 13.20, yvss,  "VSS", "mb",  "n2"),
        ("Mn0_5", 16.20, yvss,  "mb",  "m",   "VSS"),
        ("Mn7_0", 1.20, yckb,  "n3",  "Q",   "VSS"),
        ("Mn7_1", 4.20, yckb,  "s",   "CKB", "n3"),
        ("Mn7_2", 7.20, yck,   "n4",  "CK",  "s"),
        ("Mn7_3", 10.20, yvss,  "VSS", "mb",  "n4"),
        ("Mn7_4", 13.20, yvss,  "Q",   "s",   "VSS"),
    ]
    pmos_list = [
        ("Mp0_0", 1.20, yck,   "VDD", "CK",  "CKB"),
        ("Mp0_1", 4.20, yvdd,  "p1",  "D",   "VDD"),
        ("Mp0_2", 7.20, yck,   "m",   "CK",  "p1"),
        ("Mp0_3", 10.20, yckb, "p2",  "CKB", "m"),
        ("Mp0_4", 13.20, yvdd,  "VDD", "mb",  "p2"),
        ("Mp0_5", 16.20, yvdd,  "mb",  "m",   "VDD"),
        ("Mp7_0", 1.20, yck,   "p3",  "Q",   "VDD"),
        ("Mp7_1", 4.20, yck,   "s",   "CK",  "p3"),
        ("Mp7_2", 7.20, yckb,  "p4",  "CKB", "s"),
        ("Mp7_3", 10.20, yvdd,  "VDD", "mb",  "p4"),
        ("Mp7_4", 13.20, yvdd,  "Q",   "s",   "VDD"),
    ]

    def tmos(kind, x, yc, wd, net_a, net_g, net_b):
        """Draw one transistor: diff vertical, poly horizontal."""
        w = WN if kind == "n" else WP
        box(ly, cell, "diff", x - L / 2, yc - w / 2, x + L / 2, yc + w / 2)
        imp = "nplus" if kind == "n" else "pplus"
        box(ly, cell, imp, x - L / 2 - 0.16, yc - w / 2 - 0.16,
            x + L / 2 + 0.16, yc + w / 2 + 0.16)
        box(ly, cell, "poly", x - L / 2 - EXT, yc - w / 2 - EXT,
            x + L / 2 + EXT, yc + w / 2 + EXT)
        # gate contact
        contact(ly, cell, x, yc - w / 2 - 0.55)
        # source/drain contacts
        contact(ly, cell, x - L / 2 - 0.55, yc)
        contact(ly, cell, x + L / 2 + 0.55, yc)
        return dict(x=x, yc=yc, w=w, nets=(net_a, net_g, net_b))

    tlist = []
    for nm, x, yc, a, g, b in nmos_list:
        tlist.append(tmos("n", x, yc, WN, a, g, b))
    for nm, x, yc, a, g, b in pmos_list:
        tlist.append(tmos("p", x, yc, WP, a, g, b))

    # ---------------------------------------------------------------- net routing (m1)
    net_x = {
        "VSS": 0.55, "VDD": 0.55, "D": 18.5, "CK": 20.5, "Q": 21.5,
        "CKB": 19.5, "n1": 3.65, "m": 6.65, "n2": 9.65, "mb": 12.65,
        "n3": 3.65, "s": 6.65, "n4": 9.65, "p1": 3.65, "p2": 6.65,
        "p3": 3.65, "p4": 6.65,
    }
    net_y = {
        "VSS": yvss, "VDD": yvdd, "D": yvss, "CK": yck, "Q": yckb,
        "CKB": yckb, "n1": yvss, "m": yckb, "n2": yvss, "mb": yvss,
        "n3": yckb, "s": yckb, "n4": yck, "p1": yvdd, "p2": yckb,
        "p3": yck, "p4": yckb,
    }

    def route_net(net, pts):
        for i in range(len(pts) - 1):
            x1, y1 = pts[i]
            x2, y2 = pts[i + 1]
            m1wire(ly, cell, x1, y1, x2, y2)

    # VSS / VDD rails
    m1wire(ly, cell, 0.55, yvss, W - 0.55, yvss)
    m1wire(ly, cell, 0.55, yvdd, W - 0.55, yvdd)
    for t in tlist:
        if t["nets"][0] in ("VSS", "VDD"):
            contact(ly, cell, t["x"] - L / 2 - 0.55, t["yc"])
        if t["nets"][2] in ("VSS", "VDD"):
            contact(ly, cell, t["x"] + L / 2 + 0.55, t["yc"])

    # D input
    route_net("D", [(18.5, yvss), (18.5, yck), (20.5, yck)])
    contact(ly, cell, 18.5, yvss)
    contact(ly, cell, 18.5, yck)
    # Mn0_1 gate (D) and Mp0_1 gate (D)
    contact(ly, cell, 4.20, yvss - 0.55)
    contact(ly, cell, 4.20, yvdd + 0.55)
    m1wire(ly, cell, 4.20, yvss - 0.55, 4.20, yvss - 0.18)
    m1wire(ly, cell, 4.20, yvdd + 0.55, 4.20, yvdd + 0.18)

    # CK
    route_net("CK", [(20.5, yck), (20.5, yvss)])
    contact(ly, cell, 20.5, yck)
    contact(ly, cell, 20.5, yvss)
    for t, g in [("Mn0_0", "CK"), ("Mn0_3", "CK"), ("Mn7_2", "CK"),
                 ("Mp0_0", "CK"), ("Mp0_2", "CK"), ("Mp7_1", "CK")]:
        tt = next(t for t in tlist if True)
    # gate contacts already placed; connect them to CK line at yck
    for t in tlist:
        if t["nets"][1] == "CK":
            m1wire(ly, cell, t["x"], yck - 0.55, t["x"], yck)
    # CKB
    route_net("CKB", [(19.5, yckb), (19.5, yvdd)])
    contact(ly, cell, 19.5, yckb)
    contact(ly, cell, 19.5, yvdd)
    for t in tlist:
        if t["nets"][1] == "CKB":
            m1wire(ly, cell, t["x"], yckb + 0.55, t["x"], yckb)

    # Q output
    route_net("Q", [(21.5, yckb), (21.5, yvdd)])
    contact(ly, cell, 21.5, yckb)
    contact(ly, cell, 21.5, yvdd)
    for t in tlist:
        if t["nets"][0] == "Q" or t["nets"][2] == "Q":
            pass  # Q is driven by Mn7_4/Mp7_4 drains at x=13.20; route below

    # internal nets: n1, m, n2, mb, n3, s, n4, p1, p2, p3, p4
    def conn(net, xts, yts, extra_contacts=()):
        xs = net_x[net]
        ys = net_y[net]
        pts = [(xs, ys)]
        for xt, yt in xts:
            pts.append((xt, yt))
        route_net(net, pts)
        for (cx, cy) in extra_contacts:
            contact(ly, cell, cx, cy)

    # n1: Mn0_1 drain (x=4.20, left contact), Mn0_2 source (x=7.20, right contact)
    conn("n1", [(4.20, yvss), (7.20, yvss)], [],
         [(4.20 - L / 2 - 0.55, yvss), (7.20 + L / 2 + 0.55, yvss)])
    # m: Mn0_2 drain (7.20 left), Mp0_2 drain (7.20 left), Mn0_3 source (10.20 right),
    #    Mp0_3 source (10.20 right), Mn0_5 gate (16.20), Mp0_5 gate (16.20)
    conn("m", [(7.20, yckb), (10.20, yckb), (16.20, yckb)], [],
         [(7.20 - L / 2 - 0.55, yckb), (10.20 + L / 2 + 0.55, yckb),
          (16.20, yckb - 0.55), (16.20, yckb + 0.55)])
    # n2: Mn0_3 drain (10.20 left), Mn0_4 source (13.20 right)
    conn("n2", [(10.20, yvss), (13.20, yvss)], [],
         [(10.20 - L / 2 - 0.55, yvss), (13.20 + L / 2 + 0.55, yvss)])
    # mb: Mn0_4 drain (13.20 left), Mp0_4 drain (13.20 left), Mn0_5 source (16.20 left),
    #     Mp0_5 source (16.20 left), Mn7_3 gate (10.20), Mp7_3 gate (10.20)
    conn("mb", [(13.20, yvss), (10.20, yvss)], [],
         [(13.20 - L / 2 - 0.55, yvss), (10.20, yvss - 0.55), (10.20, yvss + 0.55)])
    # n3: Mn7_0 drain (1.20 left), Mn7_1 source (4.20 right)
    conn("n3", [(1.20, yckb), (4.20, yckb)], [],
         [(1.20 - L / 2 - 0.55, yckb), (4.20 + L / 2 + 0.55, yckb)])
    # s: Mn7_1 drain (4.20 left), Mn7_2 source (7.20 right), Mp7_1 drain (4.20 left),
    #    Mp7_2 source (7.20 right), Mn7_4 gate (13.20), Mp7_4 gate (13.20)
    conn("s", [(4.20, yckb), (7.20, yck), (13.20, yckb)], [],
         [(4.20 - L / 2 - 0.55, yckb), (7.20 + L / 2 + 0.55, yck),
          (13.20, yckb - 0.55), (13.20, yckb + 0.55)])
    # n4: Mn7_2 drain (7.20 left), Mn7_3 source (10.20 right)
    conn("n4", [(7.20, yck), (10.20, yvss)], [],
         [(7.20 - L / 2 - 0.55, yck), (10.20 + L / 2 + 0.55, yvss)])
    # p1: Mp0_1 drain (4.20 left), Mp0_2 source (7.20 right)
    conn("p1", [(4.20, yvdd), (7.20, yvdd)], [],
         [(4.20 - L / 2 - 0.55, yvdd), (7.20 + L / 2 + 0.55, yvdd)])
    # p2: Mp0_3 drain (10.20 left), Mp0_4 source (13.20 right)
    conn("p2", [(10.20, yckb), (13.20, yvdd)], [],
         [(10.20 - L / 2 - 0.55, yckb), (13.20 + L / 2 + 0.55, yvdd)])
    # p3: Mp7_0 drain (1.20 left), Mp7_1 source (4.20 right)
    conn("p3", [(1.20, yck), (4.20, yck)], [],
         [(1.20 - L / 2 - 0.55, yck), (4.20 + L / 2 + 0.55, yck)])
    # p4: Mp7_2 drain (7.20 left), Mp7_3 source (10.20 right)
    conn("p4", [(7.20, yckb), (10.20, yvdd)], [],
         [(7.20 - L / 2 - 0.55, yckb), (10.20 + L / 2 + 0.55, yvdd)])

    # Q drive: Mn7_4 drain (13.20 left contact), Mp7_4 drain (13.20 left contact) -> Q line
    contact(ly, cell, 13.20 - L / 2 - 0.55, yvss)
    m1wire(ly, cell, 13.20 - L / 2 - 0.55, yvss, 13.20 - L / 2 - 0.55, yckb)
    m1wire(ly, cell, 13.20 - L / 2 - 0.55, yckb, 21.5, yckb)

    # ---------------------------------------------------------------- taps
    tap(ly, cell, "p", 1.0, 1.0)
    tap(ly, cell, "n", W - 1.0, H - 1.0)

    # ---------------------------------------------------------------- pins
    label(ly, cell, "VSS", 0.55, yvss - 0.6)
    label(ly, cell, "VDD", 0.55, yvdd + 0.6)
    label(ly, cell, "D", 18.5, yvss - 0.6)
    label(ly, cell, "CK", 20.5, yvss - 0.6)
    label(ly, cell, "Q", 21.5, yvdd + 0.6)
    return cell

# ----------------------------------------------------------------------
# top cell
# ----------------------------------------------------------------------
def build_top(ly):
    top = ly.create_cell("shreg16")
    dff = build_dff(ly, "dff")
    W = 22.0
    H = 26.0
    N = 16
    pitch = W + 2.0

    # place DFFs
    for i in range(N):
        top.insert(kdb.DCellInstArray(dff.cell_index(),
                                      kdb.DTrans(kdb.DVector(i * pitch, 0.0))))

    # global rails
    yvss = 2.0
    yvdd = H - 2.0
    yck = 6.0
    xd = 18.5
    xck = 20.5
    xq = 21.5

    m1wire(ly, top, 0.0, yvss, N * pitch, yvss, w=0.6)
    m1wire(ly, top, 0.0, yvdd, N * pitch, yvdd, w=0.6)
    m2wire(ly, top, xck, yvss, xck, yvdd, w=0.6)
    m2wire(ly, top, xd, yvss, xd, yvdd, w=0.6)

    # chain Q -> D
    for i in range(N - 1):
        xq_i = i * pitch + xq
        xd_n = (i + 1) * pitch + xd
        m2wire(ly, top, xq_i, yck, xd_n, yck, w=0.28)
        via1(ly, top, xq_i, yck)
        via1(ly, top, xd_n, yck)

    # input D
    contact(ly, top, xd, yvss)
    m1wire(ly, top, xd, yvss, xd, yck)
    label(ly, top, "D", xd, yvss - 0.6)

    # CK
    contact(ly, top, xck, yvss)
    m1wire(ly, top, xck, yvss, xck, yck)
    label(ly, top, "CK", xck, yvss - 0.6)

    # outputs Q0..Q15
    qorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    for i in qorder:
        xi = i * pitch + xq
        contact(ly, top, xi, yckb := H - 6.0)
        m1wire(ly, top, xi, yckb, xi, yvdd)
        label(ly, top, "Q%d" % i, xi, yvdd + 0.6)

    # supply pins
    label(ly, top, "VSS", 0.0, yvss - 0.6)
    label(ly, top, "VDD", 0.0, yvdd + 0.6)

    return top

# ----------------------------------------------------------------------
# main
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = build_top(ly)
ly.write("shreg16.gds")
print("wrote shreg16.gds, bbox:", top.bbox().to_um())
