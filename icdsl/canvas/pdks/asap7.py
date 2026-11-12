"""ASAP7: the 7 nm FinFET predictive PDK of Arizona State University and ARM.

Signoff differs from the other PDKs because no magic tech file exists for it:
  DRC      the KLayout deck asap7.lydrc (OpenROAD-flow-scripts, flow/platforms/asap7/drc; BSD 2-Clause,
           written after the design rule manual asap7_drm_201207a) is the only judge
  extract  KLayout's netlist extractor, driven by the `extract` table below (no LVS deck exists upstream)
  LVS      netgen with the setup file asap7_netgen_setup.tcl next to this file
The rule values below are those the deck implements; where the deck and its own rule text differ
(e.g. active past the gate: 25 nm coded, 20 nm in the text) the coded value is used.

Devices are FinFETs on two fixed grids (see `finfet`): fins every 27 nm in y, gates every 54 nm in x.
The width of a transistor is a number of fins; cell.mos takes w = nfin * 0.027 (the height of the
active area, which is also the width the extraction reports).
"""
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
_M = ["m1", "m2", "m3"]

TECH = dict(
    name="asap7",
    grid=0.001,
    gds_dbu=0.00025,               # the deck and the standard cells use 0.25 nm
    lyp="asap7.lyp",
    # image colours (colour, KLayout stipple index): the PDK's layer table draws every layer as a
    # near-white outline, which makes the images unreadable
    display={"nwell": ("#3a5f8f", 3), "fin": ("#5a5a5a", 1), "active": ("#2e8b57", 0), "gate": ("#d94a3d", 0),
             "gcut": ("#ffd166", 5), "nselect": ("#7fbf7f", 1), "pselect": ("#c98fd0", 1), "sdt": ("#8d6e63", 2),
             "lisd": ("#f4a261", 9), "lig": ("#e76f9a", 5), "v0": ("#ffffff", 0), "m1": ("#4aa3ff", 4),
             "v1": ("#e0e0e0", 12), "m2": ("#c77dff", 8), "v2": ("#e0e0e0", 12), "m3": ("#2ec4b6", 4),
             "boundary": ("#888888", 1)},
    layers={
        "nwell": (1, 0), "fin": (2, 0), "gate": (7, 0), "dummy": (8, 0), "gcut": (10, 0), "active": (11, 0),
        "nselect": (12, 0), "pselect": (13, 0), "lig": (16, 0), "lisd": (17, 0), "v0": (18, 0), "m1": (19, 0),
        "m2": (20, 0), "v1": (21, 0), "v2": (25, 0), "m3": (30, 0), "v3": (35, 0), "m4": (40, 0), "v4": (45, 0),
        "m5": (50, 0), "v5": (55, 0), "m6": (60, 0), "v6": (65, 0), "m7": (70, 0), "v7": (75, 0), "m8": (80, 0),
        "v8": (85, 0), "m9": (90, 0), "v9": (95, 0), "pad": (96, 0), "sdt": (88, 0), "slvt": (97, 0),
        "lvt": (98, 0), "sramdrc": (99, 0), "boundary": (100, 0), "sramvt": (110, 0),
    },
    # net-name texts: the pin purpose (datatype 251) of each conductor, as in the ASAP7 standard cells
    label={"lisd": (17, 251), "lig": (16, 251), "gate": (7, 251), "m1": (19, 251), "m2": (20, 251),
           "m3": (30, 251), "nwell": (1, 251)},
    pin={},
    # conductors, bottom-up. lisd (local interconnect on source/drain) is the layer the device terminals
    # are on, so it is c0; m1..m3 follow. m4..m9 are layers (drawable, checked by the deck) but cell.via
    # does not build stacks above m3 yet: V3 and up are not square (as wide as the metal above).
    stack=["lisd"] + _M,
    metal1="m1",
    cuts={
        "v0": dict(size=0.018, space=0.018, lower=["lisd", "lig"], upper="m1"),
        "v1": dict(size=0.018, space=0.018, lower="m1", upper="m2"),
        "v2": dict(size=0.018, space=0.018, lower="m2", upper="m3"),
    },
    width={"nwell": 0.108, "fin": 0.007, "gate": 0.020, "gcut": 0.017, "active": 0.016, "nselect": 0.108,
           "pselect": 0.108, "sdt": 0.024, "lisd": 0.024, "lig": 0.016, "m1": 0.018, "m2": 0.018, "m3": 0.018,
           "m4": 0.024, "m5": 0.024, "m6": 0.032, "m7": 0.032, "m8": 0.040, "m9": 0.040},
    space={("nwell", "nwell"): 0.108, ("gate", "gate"): 0.034, ("active", "active"): 0.038,
           ("active", "nwell"): 0.027, ("gcut", "gcut"): 0.035, ("sdt", "sdt"): 0.030,
           ("lisd", "lisd"): 0.018, ("lig", "lig"): 0.018, ("lig", "lisd"): 0.014, ("lig", "sdt"): 0.014,
           ("m1", "m1"): 0.018, ("m2", "m2"): 0.018, ("m3", "m3"): 0.018, ("m4", "m4"): 0.024,
           ("m5", "m5"): 0.024, ("m6", "m6"): 0.032, ("m7", "m7"): 0.032, ("m8", "m8"): 0.040,
           ("m9", "m9"): 0.040},
    space_wide={},
    # (all sides, the two opposite sides that need more). A metal is exactly as wide as its via and
    # extends 5 nm past it along the wire; lisd is 24 nm wide around an 18 nm V0. m2 over v1 is 6 nm:
    # the deck's V1.M2.EN.2 removes an end cap of exactly 5 nm before it looks for one (V2 / m3 does not).
    enc={("lisd", "v0"): (0.003, 0.005), ("lig", "v0"): (0.002, 0.002),
         ("m1", "v0"): (0.0, 0.005), ("m1", "v1"): (0.0, 0.005), ("m2", "v1"): (0.0, 0.006),
         ("m2", "v2"): (0.0, 0.005), ("m3", "v2"): (0.0, 0.005),
         ("nselect", "active"): (0.046, 0.046), ("pselect", "active"): (0.046, 0.046),
         ("nwell", "active"): (0.046, 0.046)},
    area={"active": 0.000864, "lisd": 0.000648, "lig": 0.000324, "m1": 0.000504, "m2": 0.000504,
          "m3": 0.000504, "nwell": 0.005832},
    rules=dict(
        gate_pitch=0.054,              # gates sit on this grid in x
        gate_length=0.020,             # the only gate length
        fin_pitch=0.027,               # fins sit on this grid in y
        fin_width=0.007,
        fin_enc=0.010,                 # active past its outer fins (so an active is nfin * 0.027 high)
        diff_ext_gate=0.025,           # active past the last gate
        dummy_gate_space=0.009,        # a gate that is not over an active keeps this distance from it
        poly_endcap=0.005,             # gate past the active (the deck asks for 4 nm)
        gate_contact_space=0.014,      # lig (gate contact) to lisd / sdt
        tip_space=0.025,               # m1..m3, lisd, lig: a wire end (edge up to 36 nm) to a long edge
        tip_tip_space=0.031,           # two wire ends (edges up to 24 nm) facing each other
        via_corner_space=0.030,        # two vias of one layer that are not aligned, corner to corner
        cell_height=0.270,             # 7.5-track standard cell: 10 fin pitches
    ),
    notes=[
        "FinFET PDK: a transistor is a gate (20 nm, pitch 54 nm) over an active whose height is nfin * 27 nm. "
        "cell.mos / cell.tap draw active, fins, gates, dummy gates, sdt and lisd on the two grids: the "
        "active's lower edge at y = k * 0.027 and its left edge at x = 0.046 + k * 0.054 (source/drain "
        "columns then sit at x = k * 0.054, gates at 0.027 + k * 0.054). w = nfin * 0.027, l = 0.020.",
        "devices in a row abut: the next active starts at handle.x_next (two dummy gates between two "
        "actives). An n device under a p device shares its gate stripes: extend both with gate_ext=(bottom, "
        "top) until they meet - gates that end facing each other are an error (GATE.S.1). A rect on gcut "
        "across a stripe separates two nets on it; put one under each supply rail.",
        "source/drain: active -> sdt -> lisd (no cut layer; sdt is drawn where lisd contacts the active). "
        "gate contact: lig over the gate; lig also joins lisd where they overlap. v0 goes from lisd or lig "
        "to m1: cell.via('lisd' | 'lig' | 'gate', 'm1').",
        "m1 / m2 / m3: a wire is exactly as wide as the via it carries (18 nm) and extends 5 nm past it "
        "(m2 past v1: 6 nm); "
        "spacing 18 nm side to side, 25 nm from a wire end to a side, 31 nm between two wire ends.",
        "every n-transistor needs a ptap and every p-transistor an ntap within 30 um (ACTIVE.LUP.1).",
        "stick / stick_auto / rows, Router, from_spice, mos_strip, guard_ring, resistor and capacitor are "
        "planar helpers and not available here; tests/asap7/ has cells built from mos / tap / via / rect.",
    ],
    roles=dict(poly="gate", contact="v0", boundary="boundary", nwell="nwell"),
    via_from={"gate": "lig"},          # cell.via('gate', ...) starts with a lig pad on the gate
    contact_extra={},
    finfet=dict(
        fin="fin", gate="gate", sdt="sdt", strap="lisd",
        dummy_gates=True,              # a gate stripe on the next grid position at each end of an active
        col_w=0.024,                   # width of the sdt / lisd columns
        select_enc=(0.046, 0.027),     # select and n-well past the active (x, y)
        fin_ext=0.046,                 # fins past the active in x (min. fin length 108 nm)
        tap_w=0.016,                   # active width of a tap column
    ),
    devices={
        "nmos": dict(type="mos", recipe="finfet", model="nmos_rvt", spice_prefix="M", diff="active",
                     implant="nselect", well=None, lmin=0.020, wmin=0.027, bulk="VSS"),
        "pmos": dict(type="mos", recipe="finfet", model="pmos_rvt", spice_prefix="M", diff="active",
                     implant="pselect", well="nwell", lmin=0.020, wmin=0.027, bulk="VDD"),
        "ptap": dict(type="tap", recipe="finfet", diff="active", implant="pselect", well=None),
        "ntap": dict(type="tap", recipe="finfet", diff="active", implant="nselect", well="nwell"),
    },
    libs=[dict(prefix="", gds="asap7sc7p5t_28_R_220121a.gds", spice=None)],
    signoff=dict(
        netgen=os.path.join(_HERE, "asap7_netgen_setup.tcl"),
        klayout=dict(deck="asap7.lydrc", input="in_gds", report="report_file", top="topcell", args={}, waive={}),
        # layout netlist by KLayout: derived layers (name, a, op, b), devices, connections
        extract=dict(
            tool="klayout",
            derive=[
                ("rgate", "gate", "-", "gcut"),            # a gate cut removes the gate
                ("nact", "active", "&", "nselect"),
                ("pact", "active", "&", "pselect"),
                ("ndev", "nact", "-", "nwell"),            # n-transistor active
                ("pdev", "pact", "&", "nwell"),            # p-transistor active
                ("ngate", "rgate", "&", "ndev"),
                ("pgate", "rgate", "&", "pdev"),
                ("nsd", "ndev", "-", "rgate"),
                ("psd", "pdev", "-", "rgate"),
                ("ntap", "nact", "&", "nwell"),            # n+ in the n-well: well tie
                ("ptap", "pact", "-", "nwell"),            # p+ outside the n-well: substrate tie
            ],
            mos=[dict(model="nmos_rvt", sd="nsd", gate="ngate", poly="rgate", well="bulk"),
                 dict(model="pmos_rvt", sd="psd", gate="pgate", poly="rgate", well="nwell")],
            conductors=["nsd", "psd", "ntap", "ptap", "nwell", "rgate", "sdt", "lisd", "lig", "v0", "m1", "v1",
                        "m2", "v2", "m3", "v3", "m4", "v4", "m5", "v5", "m6", "v6", "m7", "v7", "m8", "v8",
                        "m9", "v9"],
            connect=[("nsd", "sdt"), ("psd", "sdt"), ("ntap", "sdt"), ("ptap", "sdt"), ("sdt", "lisd"),
                     ("lisd", "lig"), ("lig", "rgate"), ("lisd", "v0"), ("lig", "v0"), ("v0", "m1"),
                     ("m1", "v1"), ("v1", "m2"), ("m2", "v2"), ("v2", "m3"), ("m3", "v3"), ("v3", "m4"),
                     ("m4", "v4"), ("v4", "m5"), ("m5", "v5"), ("v5", "m6"), ("m6", "v6"), ("v6", "m7"),
                     ("m7", "v7"), ("v7", "m8"), ("m8", "v8"), ("v8", "m9"), ("m9", "v9"),
                     ("ntap", "nwell")],
            labels={"gate": "rgate"},                      # a text on the gate layer names the cut gate
            substrate=dict(layer="bulk", ties=["ptap"], net="SUBSTRATE"),
        ),
    ),
    supplies=dict(power="VDD", ground="VSS"),
    spice_unit="u",
    # in-process connectivity pre-check: sdt acts as the cut between active and lisd; lig joins the
    # gate and lisd directly
    conn=dict(conductors=["gate", "active", "lig"], cut_by={"active": ["gate"], "gate": ["gcut"]}, plates={},
              cuts={"sdt": dict(lower=["active"], upper="lisd")},
              direct=[("lig", "gate"), ("lig", "lisd")]),
)
