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

LYR = TECH["layers"]
LBL = TECH["label"]
GRID = TECH["grid"]

def lid(ly, name):
    g, d = LYR[name]
    return ly.layer(g, d)

def lidbl(ly, name):
    g, d = LBL[name]
    return ly.layer(g, d)

def R(x, y):
    return kdb.DBox(round(x / GRID) * GRID, round(y / GRID) * GRID,
                    round(x / GRID) * GRID, round(y / GRID) * GRID)

def box(ly, cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(R(x1, y1).p1, R(x2, y2).p2))

def label(ly, cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(round(x / GRID) * GRID,
                                                         round(y / GRID) * GRID)))

def contact(ly, cell, lid_contact, lid_m1, x, y, sz=None):
    s = TECH["cuts"]["contact"]["size"] if sz is None else sz
    box(ly, cell, lid_contact, x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, lid_m1, x - s / 2 - 0.07, y - s / 2 - 0.07,
        x + s / 2 + 0.07, y + s / 2 + 0.07)

def via1(ly, cell, lid_via1, lid_m1, lid_m2, x, y):
    s = TECH["cuts"]["via1"]["size"]
    box(ly, cell, lid_via1, x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, lid_m1, x - s / 2 - 0.06, y - s / 2 - 0.06,
        x + s / 2 + 0.06, y + s / 2 + 0.06)
    box(ly, cell, lid_m2, x - s / 2 - 0.07, y - s / 2 - 0.07,
        x + s / 2 + 0.07, y + s / 2 + 0.07)

def m1wire(ly, cell, lid_m1, x1, y1, x2, y2, w=0.23):
    if x1 == x2:
        box(ly, cell, lid_m1, x1 - w / 2, y1, x1 + w / 2, y2)
    else:
        box(ly, cell, lid_m1, x1, y1 - w / 2, x2, y1 + w / 2)

def m2wire(ly, cell, lid_m2, x1, y1, x2, y2, w=0.28):
    if x1 == x2:
        box(ly, cell, lid_m2, x1 - w / 2, y1, x1 + w / 2, y2)
    else:
        box(ly, cell, lid_m2, x1, y1 - w / 2, x2, y1 + w / 2)

def nwell_box(ly, cell, lid_nwell, lid_pwell, x1, y1, x2, y2):
    box(ly, cell, lid_nwell, x1, y1, x2, y2)
    box(ly, cell, lid_pwell, x1 - 0.10, y1 - 0.10, x2 + 0.10, y2 + 0.10)

def tap(ly, cell, kind, lid_diff, lid_nplus, lid_pplus, lid_nwell, lid_pwell,
        x, y, w=0.60, h=1.60):
    if kind == "p":
        box(ly, cell, lid_diff, x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        box(ly, cell, lid_pplus, x - w / 2 - 0.16, y - h / 2 - 0.16,
            x + w / 2 + 0.16, y + h / 2 + 0.16)
    else:
        nwell_box(ly, cell, lid_nwell, lid_pwell,
                  x - w / 2 - 0.12, y - h / 2 - 0.12,
                  x + w / 2 + 0.12, y + h / 2 + 0.12)
        box(ly, cell, lid_diff, x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        box(ly, cell, lid_nplus, x - w / 2 - 0.16, y - h / 2 - 0.16,
            x + w / 2 + 0.16, y + h / 2 + 0.16)

# ----------------------------------------------------------------------
# DFF cell (master-slave, 22 transistors)
# ----------------------------------------------------------------------
def build_dff(ly):
    cell = ly.create_cell("dff")
    W = 22.0
    H = 26.0
    L = 0.28
    WN = 0.36
    WP = 0.72
    EXT = 0.22
    CS = 0.22
    CE = 0.07

    lid_diff = lid(ly, "diff")
    lid_poly = lid(ly, "poly")
    lid_nplus = lid(ly, "nplus")
    lid_pplus = lid(ly, "pplus")
    lid_nwell = lid(ly, "nwell")
    lid_pwell = lid(ly, "pwell")
    lid_contact = lid(ly, "contact")
    lid_m1 = lid(ly, "m1")
    lid_m2 = lid(ly, "m2")
    lbl_m1 = lidbl(ly, "m1")

    yvss = 2.0
    yvdd = H - 2.0
    yck = 6.0
    yckb = H - 6.0

    # nwell everywhere (pmos + ntap)
    nwell_box(ly, cell, lid_nwell, lid_pwell, 0.0, 0.0, W, H)

    # rails
    box(ly, cell, lid_diff, 0.0, yvss - 0.18, W, yvss + 0.18)
    box(ly, cell, lid_nplus, -0.16, yvss - 0.18 - 0.16, W + 0.16, yvss + 0.18 + 0.16)
    box(ly, cell, lid_diff, 0.0, yvdd - 0.18, W, yvdd + 0.18)
    box(ly, cell, lid_pplus, -0.16, yvdd - 0.18 - 0.16, W + 0.16, yvdd + 0.18 + 0.16)

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
        w = WN if kind == "n" else WP
        imp = lid_nplus if kind == "n" else lid_pplus
        box(ly, cell, lid_diff, x - L / 2, yc - w / 2, x + L / 2, yc + w / 2)
        box(ly, cell, imp, x - L / 2 - 0.16, yc - w / 2 - 0.16,
            x + L / 2 + 0.16, yc + w / 2 + 0.16)
        box(ly, cell, lid_poly, x - L / 2 - EXT, yc - w / 2 - EXT,
            x + L / 2 + EXT, yc + w / 2 + EXT)
        contact(ly, cell, lid_contact, lid_m1, x, yc - w / 2 - 0.55)
        contact(ly, cell, lid_contact, lid_m1, x - L / 2 - 0.55, yc)
        contact(ly, cell, lid_contact, lid_m1, x + L / 2 + 0.55, yc)
        return dict(x=x, yc=yc, w=w, nets=(net_a, net_g, net_b))

    tlist = []
    for nm, x, yc, a, g, b in nmos_list:
        tlist.append(tmos("n", x, yc, WN, a, g, b))
    for nm, x, yc, a, g, b in pmos_list:
        tlist.append(tmos("p", x, yc, WP, a, g, b))

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
            m1wire(ly, cell, lid_m1, x1, y1, x2, y2)

    # rails
    m1wire(ly, cell, lid_m1, 0.55, yvss, W - 0.55, yvss)
    m1wire(ly, cell, lid_m1, 0.55, yvdd, W - 0.55, yvdd)
    for t in tlist:
        if t["nets"][0] in ("VSS", "VDD"):
            contact(ly, cell, lid_contact, lid_m1, t["x"] - L / 2 - 0.55, t["yc"])
        if t["nets"][2] in ("VSS", "VDD"):
            contact(ly, cell, lid_contact, lid_m1, t["x"] + L / 2 + 0.55, t["yc"])

    # D input
    route_net("D", [(18.5, yvss), (18.5, yck), (20.5, yck)])
    contact(ly, cell, lid_contact, lid_m1, 18.5, yvss)
    contact(ly, cell, lid_contact, lid_m1, 18.5, yck)
    contact(ly, cell, lid_contact, lid_m1, 4.20, yvss - 0.55)
    contact(ly, cell, lid_contact, lid_m1, 4.20, yvdd + 0.55)
    m1wire(ly, cell, lid_m1, 4.20, yvss - 0.55, 4.20, yvss - 0.18)
    m1wire(ly, cell, lid_m1, 4.20, yvdd + 0.55, 4.20, yvdd + 0.18)

    # CK
    route_net("CK", [(20.5, yck), (20.5, yvss)])
    contact(ly, cell, lid_contact, lid_m1, 20.5, yck)
    contact(ly, cell, lid_contact, lid_m1, 20.5, yvss)
    for t in tlist:
        if t["nets"][1] == "CK":
            m1wire(ly, cell, lid_m1, t["x"], yck - 0.55, t["x"], yck)

    # CKB
    route_net("CKB", [(19.5, yckb), (19.5, yvdd)])
    contact(ly, cell, lid_contact, lid_m1, 19.5, yckb)
    contact(ly, cell, lid_contact, lid_m1, 19.5, yvdd)
    for t in tlist:
        if t["nets"][1] == "CKB":
            m1wire(ly, cell, lid_m1, t["x"], yckb + 0.55, t["x"], yckb)

    # Q output
    route_net("Q", [(21.5, yckb), (21.5, yvdd)])
    contact(ly, cell, lid_contact, lid_m1, 21.5, yckb)
    contact(ly, cell, lid_contact, lid_m1, 21.5, yvdd)

    def conn(net, segs, extra_contacts=()):
        xs = net_x[net]
        ys = net_y[net]
        pts = [(xs, ys)] + segs
        route_net(net, pts)
        for (cx, cy) in extra_contacts:
            contact(ly, cell, lid_contact, lid_m1, cx, cy)

    conn("n1", [(4.20, yvss), (7.20, yvss)],
         [(4.20 - L / 2 - 0.55, yvss), (7.20 + L / 2 + 0.55, yvss)])
    conn("m", [(7.20, yckb), (10.20, yckb), (16.20, yckb)],
         [(7.20 - L / 2 - 0.55, yckb), (10.20 + L / 2 + 0.55, yckb),
          (16.20, yckb - 0.55), (16.20, yckb + 0.55)])
    conn("n2", [(10.20, yvss), (13.20, yvss)],
         [(10.20 - L / 2 - 0.55, yvss), (13.20 + L / 2 + 0.55, yvss)])
    conn("mb", [(13.20, yvss), (10.20, yvss)],
         [(13.20 - L / 2 - 0.55, yvss), (10.20, yvss - 0.55), (10.20, yvss + 0.55)])
    conn("n3", [(1.20, yckb), (4.20, yckb)],
         [(1.20 - L / 2 - 0.55, yckb), (4.20 + L / 2 + 0.55, yckb)])
    conn("s", [(4.20, yckb), (7.20, yck), (13.20, yckb)],
         [(4.20 - L / 2 - 0.55, yckb), (7.20 + L / 2 + 0.55, yck),
          (13.20, yckb - 0.55), (13.20, yckb + 0.55)])
    conn("n4", [(7.20, yck), (10.20, yvss)],
         [(7.20 - L / 2 - 0.55, yck), (10.20 + L / 2 + 0.55, yvss)])
    conn("p1", [(4.20, yvdd), (7.20, yvdd)],
         [(4.20 - L / 2 - 0.55, yvdd), (7.20 + L / 2 + 0.55, yvdd)])
    conn("p2", [(10.20, yckb), (13.20, yvdd)],
         [(10.20 - L / 2 - 0.55, yckb), (13.20 + L / 2 + 0.55, yvdd)])
    conn("p3", [(1.20, yck), (4.20, yck)],
         [(1.20 - L / 2 - 0.55, yck), (4.20 + L / 2 + 0.55, yck)])
    conn("p4", [(7.20, yckb), (10.20, yvdd)],
         [(7.20 - L / 2 - 0.55, yckb), (10.20 + L / 2 + 0.55, yvdd)])

    # Q drive from Mn7_4 / Mp7_4 drains
    contact(ly, cell, lid_contact, lid_m1, 13.20 - L / 2 - 0.55, yvss)
    m1wire(ly, cell, lid_m1, 13.20 - L / 2 - 0.55, yvss, 13.20 - L / 2 - 0.55, yckb)
    m1wire(ly, cell, lid_m1, 13.20 - L / 2 - 0.55, yckb, 21.5, yckb)

    # taps
    tap(ly, cell, "p", lid_diff, lid_nplus, lid_pplus, lid_nwell, lid_pwell, 1.0, 1.0)
    tap(ly, cell, "n", lid_diff, lid_nplus, lid_pplus, lid_nwell, lid_pwell, W - 1.0, H - 1.0)

    # pins
    label(ly, cell, lbl_m1, "VSS", 0.55, yvss - 0.6)
    label(ly, cell, lbl_m1, "VDD", 0.55, yvdd + 0.6)
    label(ly, cell, lbl_m1, "D", 18.5, yvss - 0.6)
    label(ly, cell, lbl_m1, "CK", 20.5, yvss - 0.6)
    label(ly, cell, lbl_m1, "Q", 21.5, yvdd + 0.6)
    return cell

# ----------------------------------------------------------------------
# top cell
# ----------------------------------------------------------------------
def build_top(ly):
    top = ly.create_cell("shreg16")
    dff = build_dff(ly)
    W = 22.0
    H = 26.0
    N = 16
    pitch = W + 2.0

    lid_m1 = lid(ly, "m1")
    lid_m2 = lid(ly, "m2")
    lid_contact = lid(ly, "contact")
    lid_via1 = lid(ly, "via1")
    lbl_m1 = lidbl(ly, "m1")

    yvss = 2.0
    yvdd = H - 2.0
    yck = 6.0
    yckb = H - 6.0
    xd = 18.5
    xck = 20.5
    xq = 21.5

    for i in range(N):
        top.insert(kdb.DCellInstArray(dff.cell_index(),
                                      kdb.DTrans(kdb.DVector(i * pitch, 0.0))))

    m1wire(ly, top, lid_m1, 0.0, yvss, N * pitch, yvss, w=0.6)
    m1wire(ly, top, lid_m1, 0.0, yvdd, N * pitch, yvdd, w=0.6)
    m2wire(ly, top, lid_m2, xck, yvss, xck, yvdd, w=0.6)
    m2wire(ly, top, lid_m2, xd, yvss, xd, yvdd, w=0.6)

    for i in range(N - 1):
        xq_i = i * pitch + xq
        xd_n = (i + 1) * pitch + xd
        m2wire(ly, top, lid_m2, xq_i, yck, xd_n, yck, w=0.28)
        via1(ly, top, lid_via1, lid_m1, lid_m2, xq_i, yck)
        via1(ly, top, lid_via1, lid_m1, lid_m2, xd_n, yck)

    contact(ly, top, lid_contact, lid_m1, xd, yvss)
    m1wire(ly, top, lid_m1, xd, yvss, xd, yck)
    label(ly, top, lbl_m1, "D", xd, yvss - 0.6)

    contact(ly, top, lid_contact, lid_m1, xck, yvss)
    m1wire(ly, top, lid_m1, xck, yvss, xck, yck)
    label(ly, top, lbl_m1, "CK", xck, yvss - 0.6)

    qorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    for i in qorder:
        xi = i * pitch + xq
        contact(ly, top, lid_contact, lid_m1, xi, yckb)
        m1wire(ly, top, lid_m1, xi, yckb, xi, yvdd)
        label(ly, top, lbl_m1, "Q%d" % i, xi, yvdd + 0.6)

    label(ly, top, lbl_m1, "VSS", 0.0, yvss - 0.6)
    label(ly, top, lbl_m1, "VDD", 0.0, yvdd + 0.6)

    return top

# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = build_top(ly)
ly.write("shreg16.gds")
print("wrote shreg16.gds, bbox:", top.bbox().to_um())

