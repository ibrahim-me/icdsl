"""NCSU FreePDK45 (45 nm predictive bulk CMOS, 10 metals; the process of the Nangate Open Cell Library)
as data for the canvas.

No local interconnect: contacts go from active / poly straight to metal1, so c0 = m1.
Both wells are drawn: n-diffusion and p-taps sit in pwell, p-diffusion and n-taps in nwell (the KLayout
deck requires every active shape to be inside a well). n and p implants must not overlap.
The KLayout deck codes WELL.4 as a separation of the well layer against itself in hierarchical mode: a
well polygon that KLayout splits internally (a thin ring or L, bounding box more than 3 x its area, or
more than 16 corners) is reported at the cut. Keep wells plain rectangles / stripes (guard_ring fills its
interior for that reason).
The PDK has only MOS devices: no poly resistor and no MIM capacitor exist in its decks, so there are
no res_poly / cap_mim recipes.
Values in micrometres, drawn dimensions. Sources: the PDK's magic tech file (freepdk45.tech, cifinput /
drc / extract sections) and its KLayout DRC deck (drc_freepdk45.lydrc); where they differ the stricter
value is used. tests/run_canvas.sh proves the numbers against both decks.
"""

_M = ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"]
_local = [(0.09, 0.09), (0.27, 0.27), (0.50, 0.50), (0.90, 0.90), (1.50, 1.50)]
_semi = [(0.27, 0.27), (0.50, 0.50), (0.90, 0.90), (1.50, 1.50)]
_glob = [(0.50, 0.50), (0.90, 0.90), (1.50, 1.50)]

TECH = dict(
    name="freepdk45",
    grid=0.005,             # magic works on 5 nm; the manufacturing grid is 2.5 nm
    gds_dbu=0.0005,         # the KLayout deck checks the 2.5 nm grid: it needs a database unit below 1 nm
    lyp="libs.tech/klayout/tech/freepdk45/freepdk45.lyp",
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0), "pplus": (5, 0),
        "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0), "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0), "m3": (15, 0), "via3": (16, 0),
        "m4": (17, 0), "via4": (18, 0), "m5": (19, 0), "via5": (20, 0), "m6": (21, 0), "via6": (22, 0),
        "m7": (23, 0), "via7": (24, 0), "m8": (25, 0), "via8": (26, 0), "m9": (27, 0), "via9": (28, 0),
        "m10": (29, 0), "boundary": (235, 0),
    },
    # magic reads text on <metal>/1 as a port of that metal (text on <metal>/0 is a plain label)
    label={m: (11 + 2 * i, 1) for i, m in enumerate(_M)},
    pin={},
    stack=list(_M),
    metal1="m1",
    cuts={
        "contact": dict(size=0.065, space=0.075, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.07, space=0.075, lower="m1", upper="m2"),
        "via2": dict(size=0.07, space=0.085, lower="m2", upper="m3"),
        "via3": dict(size=0.07, space=0.085, lower="m3", upper="m4"),
        "via4": dict(size=0.14, space=0.16, lower="m4", upper="m5"),
        "via5": dict(size=0.14, space=0.16, lower="m5", upper="m6"),
        "via6": dict(size=0.14, space=0.16, lower="m6", upper="m7"),
        "via7": dict(size=0.40, space=0.44, lower="m7", upper="m8"),
        "via8": dict(size=0.40, space=0.44, lower="m8", upper="m9"),
        "via9": dict(size=0.80, space=0.88, lower="m9", upper="m10"),
    },
    width={"nwell": 0.20, "pwell": 0.20, "diff": 0.09, "poly": 0.05, "nplus": 0.045, "pplus": 0.045,
           "m1": 0.065, "m2": 0.07, "m3": 0.07, "m4": 0.14, "m5": 0.14, "m6": 0.14, "m7": 0.40, "m8": 0.40,
           "m9": 0.80, "m10": 0.80},
    space={
        # wells at different potential need 0.225 (WELL.2, not coded in either deck); nwell to pwell: abut
        # or 0.2 apart
        ("nwell", "nwell"): 0.225, ("pwell", "pwell"): 0.225, ("nwell", "pwell"): 0.20,
        ("diff", "diff"): 0.08, ("poly", "poly"): 0.075, ("poly", "diff"): 0.05,
        ("nplus", "nplus"): 0.045, ("pplus", "pplus"): 0.045, ("nplus", "pplus"): 0.045,
        ("m1", "m1"): 0.065, ("m2", "m2"): 0.07, ("m3", "m3"): 0.07, ("m4", "m4"): 0.14, ("m5", "m5"): 0.14,
        ("m6", "m6"): 0.14, ("m7", "m7"): 0.40, ("m8", "m8"): 0.40, ("m9", "m9"): 0.80, ("m10", "m10"): 0.80,
        ("nwell", "diff"): 0.055,
    },
    # a shape wider than w needs spacing s to everything else on its layer: [(w, s), ...]
    # (METALx.5 - .9; the decks also ask for a minimum parallel run length, ignored here = conservative)
    space_wide={"m1": _local, "m2": _local, "m3": _local, "m4": _semi, "m5": _semi, "m6": _semi,
                "m7": _glob, "m8": _glob, "m9": _glob, "m10": _glob},
    enc={   # (outer, inner): (every side, the two opposite sides that need more)
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035), ("m2", "via1"): (0.0, 0.035),
        ("m2", "via2"): (0.0, 0.035), ("m3", "via2"): (0.0, 0.035), ("m3", "via3"): (0.0, 0.035),
        # no implant enclosure rule exists; 0.035 + 0.07 (implant past a gate) makes tap and transistor
        # implants abut exactly in a stick cell
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    area={},
    rules=dict(
        gate_contact_space=0.035,       # contact on active to the gate (CONTACT.6)
        poly_endcap=0.055,              # poly past the active (POLY.3; the decks check 0.05)
        diff_ext_gate=0.07,             # active past a gate (POLY.4)
        polycontact_diff_space=0.055,   # contact on poly to active: poly 0.05 from active + 0.005 enclosure
        polycontact_implant_space=0.025,    # IMPLANT.2
        gate_space=0.14,                # POLY.2
        tap_diff_space=0.105,           # tap active to transistor active: the two implants abut
    ),
    roles=dict(poly="poly", contact="contact", boundary="boundary", nwell="nwell"),
    contact_extra={},
    devices={
        "nmos": dict(type="mos", model="nmos", spice_prefix="M", diff="diff", implant="nplus", well="pwell",
                     lmin=0.05, wmin=0.09, bulk="VSS", implant_gate_ext=0.07),
        "pmos": dict(type="mos", model="pmos", spice_prefix="M", diff="diff", implant="pplus", well="nwell",
                     lmin=0.05, wmin=0.09, bulk="VDD", implant_gate_ext=0.07),
        "ptap": dict(type="tap", diff="diff", implant="pplus", well="pwell", well_enc=0.055),
        "ntap": dict(type="tap", diff="diff", implant="nplus", well="nwell", well_enc=0.055),
    },
    libs=[
        dict(prefix="", gds="libs.ref/nangate45/gds/NangateOpenCellLibrary.gds",
             spice="libs.ref/nangate45/cdl/NangateOpenCellLibrary.cdl"),
    ],
    signoff=dict(magicrc="libs.tech/magic/freepdk45.magicrc", netgen="libs.tech/netgen/freepdk45_setup.tcl",
                 drc_style="drc(full)",
                 # the tech file's default extraction style makes subcircuit devices; (lvs) makes M devices.
                 # Its extract section gives lambda as 0.025 (um) where magic expects centimicrons (2.5),
                 # so every extracted length comes out 100 times too small: corrected in the .ext files.
                 ext_style="spice3(lvs)", ext_scale=100,
                 klayout=dict(deck="libs.tech/klayout/tech/freepdk45/drc/drc_freepdk45.lydrc", top="topcell",
                              args={}, waive={})),
    supplies=dict(power="VDD", ground="VSS"),
    spice_unit="u",
    conn=dict(conductors=["poly", "diff"], cut_by={"diff": ["poly"]}, plates={}),
)
