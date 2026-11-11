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

def snap(v):
    return round(v / GRID) * GRID

def box(ly, cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(snap(x1), snap(y1), snap(x2), snap(y2)))

def label(ly, cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(snap(x), snap(y))))

def contact(ly, cell, lid_c, lid_m1, x, y, pad=0.40):
    s = TECH["cuts"]["contact"]["size"]
    box(ly, cell, lid_c, x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, lid_m1, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)

def via1(ly, cell, lid_v, lid_m1, lid_m2, x, y):
    s = TECH["cuts"]["via1"]["size"]
    box(ly, cell, lid_v, x - s / 2, y - s / 2, x + s / 2, y + s / 2)
    box(ly, cell, lid_m1, x - s / 2 - 0.06, y - s / 2 - 0.06, x + s / 2 + 0.06, y + s / 2 + 0.06)
    box(ly, cell, lid_m2, x - s / 2 - 0.07, y - s / 2 - 0.07, x + s / 2 + 0.07, y + s / 2 + 0.07)

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

def nwell_box(ly, cell, lid_nwell, x1, y1, x2, y2):
    box(ly, cell, lid_nwell, x1, y1, x2, y2)

def tap(ly, cell, kind, lid_diff, lid_nplus, lid_pplus, lid_nwell, x, y, w=0.60, h=1.60):
    if kind == "p":
        box(ly, cell, lid_diff, x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        box(ly, cell, lid_pplus, x - w / 2 - 0.16, y - h / 2 - 0.16,
            x + w / 2 + 0.16, y + h / 2 + 0.16)
    else:
        nwell_box(ly, cell, lid_nwell,
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
    W = 12.0
    H = 14.0
    L = 0.28
    WN = 0.36
    WP = 0.72
    SD = 0.45          # diffusion extension beyond gate (enough for contact spacing)
    PE = 0.22          # poly endcap beyond diff
    PAD = 0.40         # metal1 contact pad (>= 0.38 for M1.3 area)

    lid_diff = lid(ly, "diff")
    lid_poly = lid(ly, "poly")
    lid_nplus = lid(ly, "nplus")
    lid_pplus = lid(ly, "pplus")
    lid_nwell = lid(ly, "nwell")
    lid_contact = lid(ly, "contact")
    lid_m1 = lid(ly, "m1")
    lid_m2 = lid(ly, "m2")
    lbl_m1 = lidbl(ly, "m1")

    yvss = 1.5
    yvdd = H - 1.5
    yck = 5.0
    yckb = H - 5.0

    # nwell over pmos row (top half)
    nwell_box(ly, cell, lid_nwell, 0.0, 7.0, W, H)

    # ---------------------------------------------------------------- transistors
    # (name, kind, xg, yc, net_drain, net_gate, net_source)
    nmos_list = [
        ("Mn0_0", 1.5, yck,   "VSS", "CK",  "CKB"),
        ("Mn0_1", 3.5, yvss,  "n1",  "D",   "VSS"),
        ("Mn0_2", 5.5, yckb,  "m",   "CKB", "n1"),
        ("Mn0_3", 7.5, yck,  "n2",  "CK",  "m"),
        ("Mn0_4", 9.5, yvss,  "VSS", "mb",  "n2"),
        ("Mn0_5", 11.5, yvss, "mb",  "m",   "VSS"),
        ("Mn7_0", 1.5, yckb,  "n3",  "Q",   "VSS"),
        ("Mn7_1", 3.5, yckb,  "s",   "CKB", "n3"),
        ("Mn7_2", 5.5, yck,   "n4",  "CK",  "s"),
        ("Mn7_3", 7.5, yvss,  "VSS", "mb",  "n4"),
        ("Mn7_4", 9.5, yvss,  "Q",   "s",   "VSS"),
    ]
    pmos_list = [
        ("Mp0_0", 1.5, yck,   "VDD", "CK",  "CKB"),
        ("Mp0_1", 3.5, yvdd,  "p1",  "D",   "VDD"),
        ("Mp0_2", 5.5, yck,   "m",   "CK",  "p1"),
        ("Mp0_3", 7.5, yckb, "p2",  "CKB", "m"),
        ("Mp0_4", 9.5, yvdd,  "VDD", "mb",  "p2"),
        ("Mp0_5", 11.5, yvdd, "mb",  "m",   "VDD"),
        ("Mp7_0", 1.5, yck,   "p3",  "Q",   "VDD"),
        ("Mp7_1", 3.5, yck,   "s",   "CK",  "p3"),
        ("Mp7_2", 5.5, yckb,  "p4",  "CKB", "s"),
        ("Mp7_3", 7.5, yvdd,  "VDD", "mb",  "p4"),
        ("Mp7_4", 9.5, yvdd,  "Q",   "s",   "VDD"),
    ]

    def tmos(kind, xg, yc, wd, net_d, net_g, net_s):
        w = WN if kind == "n" else WP
        imp = lid_nplus if kind == "n" else lid_pplus
        # diffusion (active) region: horizontal strip
        box(ly, cell, lid_diff,
            xg - L / 2 - SD, yc - w / 2,
            xg + L / 2 + SD, yc + w / 2)
        # implant
        box(ly, cell, imp,
            xg - L / 2 - SD - 0.16, yc - w / 2 - 0.16,
            xg + L / 2 + SD + 0.16, yc + w / 2 + 0.16)
        # poly gate: vertical strip crossing diff
        box(ly, cell, lid_poly,
            xg - L / 2, yc - w / 2 - PE,
            xg + L / 2, yc + w / 2 + PE)
        # gate contact on poly (below diff for nmos row, above for pmos row)
        if kind == "n":
            gcy = yc - w / 2 - PE - 0.11   # contact sits on poly bottom edge
        else:
            gcy = yc + w / 2 + PE + 0.11   # contact sits on poly top edge
        contact(ly, cell, lid_contact, lid_m1, xg, gcy, PAD)
        # source contact: left end of diff, bottom edge (staggered)
        scx = xg - L / 2 - SD + 0.18
        scy = yc - w / 2 + 0.18
        contact(ly, cell, lid_contact, lid_m1, scx, scy, PAD)
        # drain contact: right end of diff, top edge (staggered)
        dcx = xg + L / 2 + SD - 0.18
        dcy = yc + w / 2 - 0.18
        contact(ly, cell, lid_contact, lid_m1, dcx, dcy, PAD)
        return dict(xg=xg, yc=yc, w=w, nets=(net_d, net_g, net_s),
                    scx=scx, scy=scy, dcx=dcx, dcy=dcy, gcy=gcy)

    tlist = []
    for nm, xg, yc, d, g, s in nmos_list:
        tlist.append(tmos("n", xg, yc, WN, d, g, s))
    for nm, xg, yc, d, g, s in pmos_list:
        tlist.append(tmos("p", xg, yc, WP, d, g, s))

    # ---------------------------------------------------------------- net routing
    net_x = {
        "VSS": 0.55, "VDD": 0.55, "D": 10.8, "CK": 11.5, "Q": 10.8,
        "CKB": 10.8, "n1": 4.5, "m": 6.5, "n2": 8.5, "mb": 10.5,
        "n3": 4.5, "s": 6.5, "n4": 8.5, "p1": 4.5, "p2": 6.5,
        "p3": 4.5, "p4": 6.5,
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

    # power rails
    m1wire(ly, cell, lid_m1, 0.55, yvss, W - 0.55, yvss, w=0.6)
    m1wire(ly, cell, lid_m1, 0.55, yvdd, W - 0.55, yvdd, w=0.6)

    # connect rail terminals to power rails
    for t in tlist:
        for (cx, cy, net) in ((t["scx"], t["scy"], t["nets"][0]),
                              (t["dcx"], t["dcy"], t["nets"][2])):
            if net in ("VSS", "VDD"):
                m1wire(ly, cell, lid_m1, cx, cy, net_x[net], cy)
                contact(ly, cell, lid_contact, lid_m1, net_x[net], cy, PAD)

    # D input
    route_net("D", [(10.8, yvss), (10.8, yck), (11.5, yck)])
    contact(ly, cell, lid_contact, lid_m1, 10.8, yvss, PAD)
    contact(ly, cell, lid_contact, lid_m1, 10.8, yck, PAD)
    # D gates of Mn0_1 (xg=3.5,yc=yvss) and Mp0_1 (xg=3.5,yc=yvdd)
    m1wire(ly, cell, lid_m1, 3.5, yvss - WN / 2 - 0.18, 3.5, yvss - WN / 2)
    m1wire(ly, cell, lid_m1, 3.5, yvdd + WP / 2, 3.5, yvdd + WP / 2 + 0.18)
    contact(ly, cell, lid_contact, lid_m1, 3.5, yvss - WN / 2 - 0.09, PAD)
    contact(ly, cell, lid_contact, lid_m1, 3.5, yvdd + WP / 2 + 0.09, PAD)

    # CK
    route_net("CK", [(11.5, yck), (11.5, yvss)])
    contact(ly, cell, lid_contact, lid_m1, 11.5, yck, PAD)
    contact(ly, cell, lid_contact, lid_m1, 11.5, yvss, PAD)
    for t in tlist:
        if t["nets"][1] == "CK":
            m1wire(ly, cell, lid_m1, t["xg"], yck - 0.18, t["xg"], yck)

    # CKB
    route_net("CKB", [(10.8, yckb), (10.8, yvdd)])
    contact(ly, cell, lid_contact, lid_m1, 10.8, yckb, PAD)
    contact(ly, cell, lid_contact, lid_m1, 10.8, yvdd, PAD)
    for t in tlist:
        if t["nets"][1] == "CKB":
            m1wire(ly, cell, lid_m1, t["xg"], yckb + 0.18, t["xg"], yckb)

    # Q output
    route_net("Q", [(10.8, yckb), (10.8, yvdd)])
    contact(ly, cell, lid_contact, lid_m1, 10.8, yckb, PAD)
    contact(ly, cell, lid_contact, lid_m1, 10.8, yvdd, PAD)

    def conn(net, segs, extra_contacts=()):
        xs = net_x[net]
        ys = net_y[net]
        pts = [(xs, ys)] + segs
        route_net(net, pts)
        for (cx, cy) in extra_contacts:
            contact(ly, cell, lid_contact, lid_m1, cx, cy, PAD)

    # n1: Mn0_1 drain (xg=3.5, right contact top), Mn0_2 source (xg=5.5, left contact bottom)
    conn("n1", [(3.5, yvss), (5.5, yvss)],
         [(3.5 + L / 2 + SD - 0.18, yvss + WN / 2 - 0.18),
          (5.5 - L / 2 - SD + 0.18, yvss - WN / 2 + 0.18)])
    # m: Mn0_2 drain (5.5 right top), Mp0_2 drain (5.5 right top), Mn0_3 source (7.5 left bottom),
    #    Mp0_3 source (7.5 left bottom), Mn0_5 gate (11.5), Mp0_5 gate (11.5)
    conn("m", [(5.5, yckb), (7.5, yckb), (11.5, yckb)],
         [(5.5 + L / 2 + SD - 0.18, yckb + WP / 2 - 0.18),
          (7.5 - L / 2 - SD + 0.18, yckb - WN / 2 + 0.18),
          (11.5, yckb - WN / 2 - 0.18 - 0.22), (11.5, yckb + WP / 2 + 0.18 + 0.22)])
    # n2: Mn0_3 drain (7.5 right top), Mn0_4 source (9.5 left bottom)
    conn("n2", [(7.5, yvss), (9.5, yvss)],
         [(7.5 + L / 2 + SD - 0.18, yvss + WN / 2 - 0.18),
          (9.5 - L / 2 - SD + 0.18, yvss - WN / 2 + 0.18)])
    # mb: Mn0_4 drain (9.5 left bottom), Mp0_4 drain (9.5 left top), Mn0_5 source (11.5 left bottom),
    #     Mp0_5 source (11.5 left top), Mn7_3 gate (7.5), Mp7_3 gate (7.5)
    conn("mb", [(9.5, yvss), (7.5, yvss)],
         [(9.5 - L / 2 - SD + 0.18, yvss - WN / 2 + 0.18),
          (7.5, yvss - WN / 2 - 0.18 - 0.22), (7.5, yvss - WN / 2 - 0.18)])
    # n3: Mn7_0 drain (1.5 left bottom), Mn7_1 source (3.5 right top)
    conn("n3", [(1.5, yckb), (3.5, yckb)],
         [(1.5 - L / 2 - SD + 0.18, yckb - WN / 2 + 0.18),
          (3.5 + L / 2 + SD - 0.18, yckb + WN / 2 - 0.18)])
    # s: Mn7_1 drain (3.5 left bottom), Mn7_2 source (5.5 right top), Mp7_1 drain (3.5 left top),
    #    Mp7_2 source (5.5 right bottom), Mn7_4 gate (9.5), Mp7_4 gate (9.5)
    conn("s", [(3.5, yckb), (5.5, yck), (9.5, yckb)],
         [(3.5 - L / 2 - SD + 0.18, yckb - WN / 2 + 0.18),
          (5.5 + L / 2 + SD - 0.18, yck + WP / 2 - 0.18),
          (9.5, yckb - WN / 2 - 0.18 - 0.22), (9.5, yckb + WP / 2 + 0.18 + 0.22)])
    # n4: Mn7_2 drain (5.5 left bottom), Mn7_3 source (7.5 right top)
    conn("n4", [(5.5, yck), (7.5, yvss)],
         [(5.5 - L / 2 - SD + 0.18, yck - WN / 2 + 0.18),
          (7.5 + L / 2 + SD - 0.18, yvss + WN / 2 - 0.18)])
    # p1: Mp0_1 drain (3.5 left top), Mp0_2 source (5.5 right bottom)
    conn("p1", [(3.5, yvdd), (5.5, yvdd)],
         [(3.5 - L / 2 - SD + 0.18, yvdd + WP / 2 - 0.18),
          (5.5 + L / 2 + SD - 0.18, yvdd - WP / 2 + 0.18)])
    # p2: Mp0_3 drain (7.5 left top), Mp0_4 source (9.5 right bottom)
    conn("p2", [(7.5, yckb), (9.5, yvdd)],
         [(7.5 - L / 2 - SD + 0.18, yckb + WP / 2 - 0.18),
          (9.5 + L / 2 + SD - 0.18, yvdd - WP / 2 + 0.18)])
    # p3: Mp7_0 drain (1.5 left top), Mp7_1 source (3.5 right bottom)
    conn("p3", [(1.5, yck), (3.5, yck)],
         [(1.5 - L / 2 - SD + 0.18, yck + WP / 2 - 0.18),
          (3.5 + L / 2 + SD - 0.18, yck - WP / 2 + 0.18)])
    # p4: Mp7_2 drain (5.5 left top), Mp7_3 source (7.5 right bottom)
    conn("p4", [(5.5, yckb), (7.5, yvdd)],
         [(5.5 - L / 2 - SD + 0.18, yckb + WP / 2 - 0.18),
          (7.5 + L / 2 + SD - 0.18, yvdd - WP / 2 + 0.18)])

    # Q drive: Mn7_4 drain (9.5 left bottom contact), Mp7_4 drain (9.5 left top contact) -> Q line
    contact(ly, cell, lid_contact, lid_m1, 9.5 - L / 2 - SD + 0.18, yvss - WN / 2 + 0.18, PAD)
    m1wire(ly, cell, lid_m1, 9.5 - L / 2 - SD + 0.18, yvss - WN / 2 + 0.18,
           9.5 - L / 2 - SD + 0.18, yckb)
    m1wire(ly, cell, lid_m1, 9.5 - L / 2 - SD + 0.18, yckb, 10.8, yckb)

    # ---------------------------------------------------------------- taps
    tap(ly, cell, "p", lid_diff, lid_nplus, lid_pplus, lid_nwell, 0.9, 0.9)
    tap(ly, cell, "n", lid_diff, lid_nplus, lid_pplus, lid_nwell, W - 0.9, H - 0.9)

    # ---------------------------------------------------------------- pins
    label(ly, cell, lbl_m1, "VSS", 0.55, yvss - 0.6)
    label(ly, cell, lbl_m1, "VDD", 0.55, yvdd + 0.6)
    label(ly, cell, lbl_m1, "D", 11.5, yvss - 0.6)
    label(ly, cell, lbl_m1, "CK", 11.5, yvss - 0.6)
    label(ly, cell, lbl_m1, "Q", 10.8, yvdd + 0.6)
    return cell

# ----------------------------------------------------------------------
# top cell
# ----------------------------------------------------------------------
def build_top(ly):
    top = ly.create_cell("shreg16")
    dff = build_dff(ly)
    W = 12.0
    H = 14.0
    N = 16
    pitch = W + 1.0

    lid_m1 = lid(ly, "m1")
    lid_m2 = lid(ly, "m2")
    lid_contact = lid(ly, "contact")
    lid_via1 = lid(ly, "via1")
    lbl_m1 = lidbl(ly, "m1")

    yvss = 1.5
    yvdd = H - 1.5
    yck = 5.0
    yckb = H - 5.0
    xd = 11.5
    xck = 11.5
    xq = 10.8

    for i in range(N):
        top.insert(kdb.DCellInstArray(dff.cell_index(),
                                      kdb.DTrans(kdb.DVector(i * pitch, 0.0))))

    m1wire(ly, top, lid_m1, 0.0, yvss, N * pitch, yvss, w=0.6)
    m1wire(ly, top, lid_m1, 0.0, yvdd, N * pitch, yvdd, w=0.6)
    m2wire(ly, top, lid_m2, xck, yvss, xck, yvdd, w=0.6)
    m2wire(ly, top, lid_m2, xd, yvss, xd, yvdd, w=0.6)

    # chain Q -> D
    for i in range(N - 1):
        xq_i = i * pitch + xq
        xd_n = (i + 1) * pitch + xd
        m2wire(ly, top, lid_m2, xq_i, yck, xd_n, yck, w=0.28)
        via1(ly, top, lid_via1, lid_m1, lid_m2, xq_i, yck)
        via1(ly, top, lid_via1, lid_m1, lid_m2, xd_n, yck)

    # input D
    contact(ly, top, lid_contact, lid_m1, xd, yvss, 0.40)
    m1wire(ly, top, lid_m1, xd, yvss, xd, yck)
    label(ly, top, lbl_m1, "D", xd, yvss - 0.6)

    # CK
    contact(ly, top, lid_contact, lid_m1, xck, yvss, 0.40)
    m1wire(ly, top, lid_m1, xck, yvss, xck, yck)
    label(ly, top, lbl_m1, "CK", xck, yvss - 0.6)

    # outputs Q0..Q15
    qorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    for i in qorder:
        xi = i * pitch + xq
        contact(ly, top, lid_contact, lid_m1, xi, yckb, 0.40)
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



