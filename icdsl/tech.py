"""SKY130 technology description used by the ICL compiler.

All dimensions are integer nanometres (1 dbu = 1 nm, GDS dbu = 0.001 um).
SKY130 manufacturing grid is 5 nm, so every coordinate we emit is a multiple of 5.

Rule values come from the SKY130 periphery rules (as encoded in the open_pdks
magic tech file and KLayout decks). Rule ids are kept so that error reports can
quote them.
"""

PDK = "sky130A"
DBU_UM = 0.001
MFG_GRID = 5

# GDS layer/datatype map
GDS = {
    "nwell": (64, 20),
    "diff": (65, 20),
    "tap": (65, 44),
    "poly": (66, 20),
    "licon": (66, 44),
    "npc": (95, 20),
    "nsdm": (93, 44),
    "psdm": (94, 20),
    "li": (67, 20),
    "mcon": (67, 44),
    "m1": (68, 20),
    "via": (68, 44),
    "m2": (69, 20),
    "via2": (69, 44),
    "m3": (70, 20),
    "boundary": (235, 4),
}
GDS_LABEL = {"li": (67, 5), "m1": (68, 5), "m2": (69, 5), "m3": (70, 5)}
GDS_PIN = {"li": (67, 16), "m1": (68, 16), "m2": (69, 16), "m3": (70, 16)}

# Drawing order / colours for rendering (fill colour, alpha)
RENDER = [
    ("nwell", "#b4b4b4", 0.25),
    ("nsdm", "#9be39b", 0.12),
    ("psdm", "#e8b0e8", 0.12),
    ("diff", "#2e9e2e", 0.55),
    ("tap", "#1f6f9e", 0.55),
    ("npc", "#e0e070", 0.15),
    ("poly", "#d2302b", 0.60),
    ("licon", "#222222", 0.90),
    ("li", "#a05ad0", 0.45),
    ("mcon", "#000000", 0.90),
    ("m1", "#3a6ed8", 0.40),
    ("via", "#ffffff", 0.95),
    ("m2", "#e08a1e", 0.40),
]

# ---------------------------------------------------------------- design rules
R = {
    # well / implant
    "nwell.width": 840, "nwell.space": 1270,
    "nwell.enc_pdiff": 180,       # difftap.8 / nwell enclosure of p+ diff
    "nwell.enc_ntap": 180,        # difftap.8
    "nwell.space_ndiff": 340,     # difftap.9
    "nwell.space_ptap": 130,      # difftap.10
    "sdm.width": 380, "sdm.space": 380,
    "sdm.enc_diff": 125,          # nsd.5a / psd.5a
    # diffusion / tap
    "diff.width": 150, "diff.space": 270,   # difftap.1 / difftap.3
    "fet.wmin": 420,
    # poly
    "poly.width": 150, "poly.space": 210,
    "poly.space_diff": 75,        # poly.4
    "poly.space_tap": 55,         # poly.5
    "poly.diff_ext": 250,         # poly.7 diff extension beyond gate
    "poly.endcap": 130,           # poly.8 poly extension beyond diff
    # local interconnect contact (licon)
    "licon.size": 170, "licon.space": 170,
    "licon.diff_enc": 40, "licon.diff_enc1": 60,  # licon.5a / 5c (one direction)
    "licon.tap_enc": 120,         # licon.7
    "licon.poly_enc": 50, "licon.poly_enc1": 80,  # licon.8 / 8a
    "licon.gate_space": 55,       # licon.11
    "licon.poly_diff_space": 190, # licon.14
    "licon.poly_psdm_space": 110, # licon.9
    "npc.enc_pcon": 100,          # licon.15
    "npc.width": 270, "npc.space": 270,
    "npc.space_dcon": 90,         # licon.13
    # li
    "li.width": 170, "li.space": 170, "li.enc_licon1": 80, "li.area": 56100,
    # mcon
    "mcon.size": 170, "mcon.space": 190,
    "m1.enc_mcon": 30, "m1.enc_mcon1": 60,
    # met1 / via / met2
    "m1.width": 140, "m1.space": 140, "m1.area": 83000,
    "via.size": 150, "via.space": 170,
    "via.m1_enc": 55, "via.m1_enc1": 85,
    "via.m2_enc": 55, "via.m2_enc1": 85,
    "m2.width": 140, "m2.space": 140, "m2.area": 67600,
}

# ---------------------------------------------------------------- routing grid
GRID = 460              # routing pitch in x and y (nm); also device contact pitch
WIRE_W = {"m1": 140, "m2": 140}
# landing pads (square) for cuts on routing layers
PAD_MCON_M1 = 170 + 2 * 60      # 290: m1 over mcon, 0.06 on all sides
PAD_VIA = 150 + 2 * 85          # 320: m1/m2 over via, 0.085 on all sides
RAIL_W = 300                    # default supply rail width (m1)

# compaction spacing tables: (layerA, layerB) -> min spacing (symmetric)
_SPACE = {
    ("diff", "diff"): 270, ("diff", "tap"): 270, ("tap", "tap"): 270,
    ("poly", "poly"): 210, ("poly", "diff"): 75, ("poly", "tap"): 55,
    ("licon", "licon"): 170, ("pcon", "pcon"): 170, ("licon", "pcon"): 170,
    ("pcon", "diff"): 190, ("pcon", "tap"): 190,
    ("npc", "dcon"): 90,
    ("li", "li"): 170,
    ("mcon", "mcon"): 190,
    ("nwell", "diff_n"): 340, ("nwell", "tap_p"): 130,
    ("nsdm", "psdm"): 0, ("psdm", "pcon"): 110,
    ("m1", "m1"): 140,
}
SPACE_V = dict(_SPACE)
SPACE_V[("npc", "npc")] = 270
SPACE_H = dict(_SPACE)          # npc is bridged inside a row


def spacing(table, a, b):
    if (a, b) in table:
        return table[(a, b)]
    return table.get((b, a))


def snap(v, grid=MFG_GRID):
    """Snap to the manufacturing grid (round half away from zero)."""
    return int(round(v / grid)) * grid


def snap_up(v, grid):
    return -((-v) // grid) * grid


def um(nm):
    return nm * DBU_UM


# ================================================================== extended model
# Rule API used by every library: width / spacing / enclosure lookups by layer name.
GDS.update({"via3": (70, 44), "m4": (71, 20), "pwell": (64, 44)})
GDS_LABEL.update({"m4": (71, 5), "tap": (65, 5), "poly": (66, 5)})
GDS_PIN.update({"m4": (71, 16)})
RENDER += [("via2", "#ffffff", 0.95), ("m3", "#2aa198", 0.35), ("via3", "#ffffff", 0.95), ("m4", "#b0306b", 0.30)]

WIDTH = {"nwell": 840, "diff": 150, "tap": 150, "poly": 150, "npc": 270, "nsdm": 380, "psdm": 380,
         "li": 170, "m1": 140, "m2": 140, "m3": 300, "m4": 300,
         "licon": 170, "mcon": 170, "via": 150, "via2": 200, "via3": 200}
CUT_SIZE = {"licon": 170, "mcon": 170, "via": 150, "via2": 200, "via3": 200}
AREA = {"li": 56100, "m1": 83000, "m2": 67600, "m3": 240000, "m4": 240000}
SPACE = {
    ("nwell", "nwell"): 1270, ("diff", "diff"): 270, ("tap", "tap"): 270, ("diff", "tap"): 270,
    ("poly", "poly"): 210, ("poly", "diff"): 75, ("poly", "tap"): 55,
    ("npc", "npc"): 270, ("nsdm", "nsdm"): 380, ("psdm", "psdm"): 380,
    ("licon", "licon"): 170, ("li", "li"): 170, ("mcon", "mcon"): 190,
    ("m1", "m1"): 140, ("via", "via"): 170, ("m2", "m2"): 140, ("via2", "via2"): 200,
    ("m3", "m3"): 300, ("via3", "via3"): 200, ("m4", "m4"): 300,
    ("nwell", "diff"): 340,      # n-diff to n-well (p-diff must be inside, see ENC)
    ("licon", "poly"): 55,       # diff-licon to gate (licon.11)
    ("licon", "diff"): 190,      # poly-licon to diffusion (licon.14)
    ("licon", "psdm"): 110,      # poly-licon to psdm (licon.9)
    ("npc", "licon"): 90,        # npc to diff-licon (licon.13)
}
# (outer, inner) -> (all-around enclosure, enclosure required on one axis (both sides))
ENC = {
    ("diff", "licon"): (40, 60), ("tap", "licon"): (0, 120), ("poly", "licon"): (50, 80),
    ("li", "licon"): (0, 80), ("li", "mcon"): (0, 0), ("m1", "mcon"): (30, 60),
    ("m1", "via"): (55, 85), ("m2", "via"): (55, 85), ("m2", "via2"): (40, 85), ("m3", "via2"): (65, 65),
    ("m3", "via3"): (60, 90), ("m4", "via3"): (65, 65),
    ("nsdm", "diff"): (125, 125), ("psdm", "diff"): (125, 125), ("nsdm", "tap"): (125, 125),
    ("psdm", "tap"): (125, 125), ("nwell", "diff"): (180, 180), ("nwell", "tap"): (180, 180),
    ("npc", "licon"): (100, 100),
}
# poly over diff: gate extension rules
EXT = {("poly", "diff"): 130, ("diff", "poly"): 250}


def rule_width(layer):
    return WIDTH.get(layer, 0)


def rule_space(a, b=None):
    b = b or a
    return SPACE.get((a, b), SPACE.get((b, a), 0))


def rule_enc(outer, inner):
    return ENC.get((outer, inner), (0, 0))


# ------------------------------------------------------------------ routing stack
ROUTE_LAYERS = ["m1", "m2", "m3", "m4"]
# cut between consecutive conductors: (lower, upper) -> cut layer
CUTS = {("li", "m1"): "mcon", ("m1", "m2"): "via", ("m2", "m3"): "via2", ("m3", "m4"): "via3"}
STACK = ["li", "m1", "m2", "m3", "m4"]
PREFERRED = {"m1": "h", "m2": "v", "m3": "h", "m4": "v"}
# sheet resistance (ohm/sq) and via resistance (ohm/cut), typical sky130 values
RSHEET = {"li": 12.8, "m1": 0.125, "m2": 0.125, "m3": 0.047, "m4": 0.047}
RCUT = {"mcon": 9.3, "via": 4.5, "via2": 3.41, "via3": 3.41}
THICK = {"li": 0.1, "m1": 0.36, "m2": 0.36, "m3": 0.845, "m4": 0.845}   # um
EPS_OX = 3.9 * 8.854e-3    # fF/um


def cut_between(lo, hi):
    return CUTS.get((lo, hi))


def pad_size(metal, cut):
    """Square landing pad on `metal` for `cut` that satisfies both enclosure rules."""
    e0, e1 = rule_enc(metal, cut)
    return CUT_SIZE[cut] + 2 * max(e0, e1)
