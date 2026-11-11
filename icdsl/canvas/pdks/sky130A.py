"""SkyWater SKY130 (sky130A) as data for the canvas.

Short layer names below are conveniences; every official layer of the PDK's KLayout table
('met5.drawing', 'poly.res', 'areaid.sc', ...) and raw (layer, datatype) tuples work everywhere too.
Values in micrometres. Sources: the open_pdks magic tech file + SkyWater periphery rules; the canvas
regression (tests/run_canvas.sh) proves them against magic drc(full).
"""

_M = lambda n: {"m%d" % (i + 1): (68 + i, n) for i in range(5)}

TECH = dict(
    name="sky130A",
    grid=0.005,
    lyp="libs.tech/klayout/tech/sky130A.lyp",
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "lvtn": (125, 44), "hvtp": (78, 44), "hvi": (75, 20), "hvntm": (125, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20), "via2": (69, 44), "m3": (70, 20),
        "via3": (70, 44), "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
        "capm": (89, 44), "cap2m": (97, 44), "rpm": (86, 20), "urpm": (79, 20),
        "polyres": (66, 13), "diffres": (65, 13), "lires": (67, 13),
        "m1res": (68, 13), "m2res": (69, 13), "m3res": (70, 13), "m4res": (71, 13), "m5res": (72, 13),
        "boundary": (235, 4), "areaid_sc": (81, 4), "inductor": (82, 24),
    },
    label={"poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5), "m3": (70, 5), "m4": (71, 5),
           "m5": (72, 5), "nwell": (64, 5), "pwell": (64, 59)},
    pin={"poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16), "m3": (70, 16), "m4": (71, 16),
         "m5": (72, 16), "nwell": (64, 16), "pwell": (122, 16)},
    stack=["li", "m1", "m2", "m3", "m4", "m5"],
    metal1="m1",
    cuts={
        "licon": dict(size=0.17, space=0.17, lower=["diff", "tap", "poly"], upper="li"),
        "mcon": dict(size=0.17, space=0.19, lower="li", upper="m1"),
        "via": dict(size=0.15, space=0.17, lower="m1", upper="m2"),
        "via2": dict(size=0.20, space=0.20, lower="m2", upper="m3"),
        "via3": dict(size=0.20, space=0.20, lower="m3", upper="m4"),
        "via4": dict(size=0.80, space=0.80, lower="m4", upper="m5"),
    },
    width={"nwell": 0.84, "diff": 0.15, "tap": 0.15, "poly": 0.15, "npc": 0.27, "nsdm": 0.38, "psdm": 0.38,
           "lvtn": 0.38, "hvtp": 0.38, "li": 0.17, "m1": 0.14, "m2": 0.14, "m3": 0.30, "m4": 0.30, "m5": 1.60,
           "capm": 1.0},
    space={
        ("nwell", "nwell"): 1.27, ("diff", "diff"): 0.27, ("tap", "tap"): 0.27, ("diff", "tap"): 0.27,
        ("poly", "poly"): 0.21, ("poly", "diff"): 0.075, ("poly", "tap"): 0.055,
        ("nsdm", "nsdm"): 0.38, ("psdm", "psdm"): 0.38, ("npc", "npc"): 0.27,
        ("li", "li"): 0.17, ("m1", "m1"): 0.14, ("m2", "m2"): 0.14, ("m3", "m3"): 0.30, ("m4", "m4"): 0.30,
        ("m5", "m5"): 1.60, ("nwell", "diff"): 0.34, ("capm", "capm"): 0.84,
    },
    enc={   # (outer, inner): (every side, the two opposite sides that need more)
        ("diff", "licon"): (0.04, 0.06), ("tap", "licon"): (0.0, 0.12), ("poly", "licon"): (0.05, 0.08),
        ("li", "licon"): (0.0, 0.08), ("li", "mcon"): (0.0, 0.0), ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085), ("m2", "via"): (0.055, 0.085), ("m2", "via2"): (0.04, 0.085),
        ("m3", "via2"): (0.065, 0.065), ("m3", "via3"): (0.06, 0.09), ("m4", "via3"): (0.065, 0.065),
        ("m4", "via4"): (0.19, 0.19), ("m5", "via4"): (0.31, 0.31),
        ("nsdm", "diff"): (0.125, 0.125), ("psdm", "diff"): (0.125, 0.125),
        ("nsdm", "tap"): (0.125, 0.125), ("psdm", "tap"): (0.125, 0.125),
        ("nwell", "diff"): (0.18, 0.18), ("nwell", "tap"): (0.18, 0.18), ("npc", "licon"): (0.10, 0.10),
        ("m3", "capm"): (0.14, 0.14), ("capm", "via3"): (0.14, 0.14),
    },
    area={"li": 0.0561, "m1": 0.083, "m2": 0.0676, "m3": 0.24, "m4": 0.24, "m5": 4.0,
          "nsdm": 0.255, "psdm": 0.255, "nwell": 0.0},
    rules=dict(
        gate_contact_space=0.055,       # licon on diff to the gate
        poly_endcap=0.13,               # poly past the diffusion
        diff_ext_gate=0.25,             # diffusion past a gate
        polycontact_diff_space=0.19,    # licon on poly to diffusion
        polycontact_implant_space=0.11,  # licon on poly to the other... (psdm) - keep pads off P implants
        gate_space=0.21,
        tap_diff_space=0.27,
        latchup_dist=15.0,              # every diffusion within this distance of a tap of its well
        wide_metal=3.0,                 # wider metal needs more space (m1/m2 0.28, m3/m4 0.40)
    ),
    roles=dict(poly="poly", contact="licon", boundary="boundary", nwell="nwell"),
    contact_extra={"poly": [("npc", 0.10)]},     # a licon on poly needs npc around it
    devices={
        "nmos": dict(type="mos", model="sky130_fd_pr__nfet_01v8", diff="diff", implant="nsdm", well=None,
                     lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(type="mos", model="sky130_fd_pr__pfet_01v8", diff="diff", implant="psdm", well="nwell",
                     lmin=0.15, wmin=0.42, bulk="VDD"),
        "nmos_lvt": dict(type="mos", model="sky130_fd_pr__nfet_01v8_lvt", diff="diff", implant="nsdm",
                         well=None, lmin=0.15, wmin=0.42, bulk="VSS", gate_extra=[("lvtn", 0.18)]),
        "pmos_hvt": dict(type="mos", model="sky130_fd_pr__pfet_01v8_hvt", diff="diff", implant="psdm",
                         well="nwell", lmin=0.15, wmin=0.42, bulk="VDD", gate_extra=[("hvtp", 0.18)]),
        "pmos_lvt": dict(type="mos", model="sky130_fd_pr__pfet_01v8_lvt", diff="diff", implant="psdm",
                         well="nwell", lmin=0.35, wmin=0.42, bulk="VDD", gate_extra=[("lvtn", 0.18)]),
        "ptap": dict(type="tap", diff="tap", implant="psdm", well=None),
        "ntap": dict(type="tap", diff="tap", implant="nsdm", well="nwell"),
        "res_poly": dict(type="res", model="sky130_fd_pr__res_generic_po", body="poly", markers=[("polyres", 0.0)],
                         wmin=0.33, lmin=0.5, terminals=2, contact="poly"),
        "cap_mim": dict(type="mim", model="sky130_fd_pr__cap_mim_m3_1", bottom="m3", plate="capm",
                        top="m4", cut="via3", wmin=2.0, bottom_enc=0.14, cut_enc=0.2, bottom_space=1.2),
    },
    libs=[
        dict(prefix="sky130_fd_sc_hd__", gds="libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds",
             spice="libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice"),
        dict(prefix="sky130_fd_pr__", gds="libs.ref/sky130_fd_pr/gds/sky130_fd_pr.gds"),
    ],
    signoff=dict(magicrc="libs.tech/magic/sky130A.magicrc", netgen="libs.tech/netgen/sky130A_setup.tcl",
                 drc_style="drc(full)",
                 klayout=dict(deck="libs.tech/klayout/drc/sky130A_mr.drc", top="top_cell",
                              args=dict(feol="true", beol="true", offgrid="true"), waive={})),
    supplies=dict(power="VDD", ground="VSS"),
    conn=dict(conductors=["poly", "diff", "tap"],
              cut_by={"diff": ["poly"], "poly": ["polyres"], "li": ["lires"], "m1": ["m1res"], "m2": ["m2res"],
                      "m3": ["m3res"], "m4": ["m4res"], "m5": ["m5res"]},
              plates={"capm": "via3"}),
)
