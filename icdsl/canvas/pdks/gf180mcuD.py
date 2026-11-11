"""GlobalFoundries GF180MCU (gf180mcuD: 5 metals, MIM between Metal4 and Metal5) as data for the canvas.

No local interconnect: contacts go from COMP / Poly2 straight to Metal1, so c0 = m1 here (sky130: li).
Taps are COMP with the opposite implant (same GDS layer as transistor diffusion).
Values in micrometres, drawn dimensions. Source: the open_pdks magic tech file for gf180mcuD (cifinput,
cifoutput and drc sections) cross-checked with the GF180MCU design-rule names; tests/run_canvas.sh proves
them against magic drc(full).
"""

TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    lyp="libs.tech/klayout/tech/gf180mcu.lyp",
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
    # magic reads text on <layer>/10 as a port of that layer; there are no separate pin shapes
    label={"poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
           "nwell": (21, 10), "pwell": (204, 10)},
    pin={},
    stack=["m1", "m2", "m3", "m4", "m5"],
    metal1="m1",
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"nwell": 0.86, "diff": 0.22, "poly": 0.18, "nplus": 0.40, "pplus": 0.40, "m1": 0.23, "m2": 0.28,
           "m3": 0.28, "m4": 0.28, "m5": 0.44, "capm": 5.0},
    space={
        ("nwell", "nwell"): 0.60, ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("nplus", "nplus"): 0.40, ("pplus", "pplus"): 0.40,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28, ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
        ("nwell", "diff"): 0.43, ("capm", "capm"): 0.60,
    },
    enc={   # (outer, inner): (every side, the two opposite sides that need more)
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06), ("m2", "via2"): (0.01, 0.06),
        ("m3", "via2"): (0.01, 0.06), ("m3", "via3"): (0.01, 0.06), ("m4", "via3"): (0.01, 0.06),
        ("m4", "via4"): (0.01, 0.06), ("m5", "via4"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
        ("nwell", "diff"): (0.43, 0.43),
    },
    area={"m1": 0.1444, "m2": 0.1444, "m3": 0.1444, "m4": 0.1444, "m5": 0.5625, "nplus": 0.35, "pplus": 0.35,
          "diff": 0.2025},
    rules=dict(
        gate_contact_space=0.15,        # contact on COMP to the gate (CO.7)
        poly_endcap=0.22,               # poly past the diffusion (PL.4)
        diff_ext_gate=0.23,             # diffusion past a gate (DF.6)
        polycontact_diff_space=0.17,    # contact on poly to COMP (CO.8)
        polycontact_implant_space=0.0,
        gate_space=0.24,
        tap_diff_space=0.32,            # tap COMP to transistor COMP: both implants enclose by 0.16
        latchup_dist=15.0,
        wide_metal=10.0,                # wider metal needs 0.30 space
    ),
    roles=dict(poly="poly", contact="contact", boundary="boundary", nwell="nwell"),
    contact_extra={},
    devices={
        "nmos": dict(type="mos", model="nfet_03v3", diff="diff", implant="nplus", well=None,
                     lmin=0.28, wmin=0.22, bulk="VSS", implant_gate_ext=0.23),
        "pmos": dict(type="mos", model="pfet_03v3", diff="diff", implant="pplus", well="nwell",
                     lmin=0.28, wmin=0.22, bulk="VDD", implant_gate_ext=0.23),
        "ptap": dict(type="tap", diff="diff", implant="pplus", well=None),
        "ntap": dict(type="tap", diff="diff", implant="nplus", well="nwell", well_enc=0.12),
        # unsalicided P+ poly resistor: body = Poly2 under SAB inside RES_MK; contacts exactly 0.22 from it
        "res_poly": dict(type="res", model="ppolyf_u", body="poly", markers=[("res_mk", 0.0), ("sab", 0.28)],
                         covers=[("pplus", 0.30, 0.30)], head_space=0.22, wmin=0.80, lmin=1.0, terminals=3,
                         bulk="VSS", params={"w": "r_width", "l": "r_length"}),
        "cap_mim": dict(type="mim", model="cap_mim_2f0_m4m5_noshield", bottom="m4", plate="capm", top="m5",
                        cut="via4", wmin=5.0, bottom_enc=0.60, cut_enc=0.40, bottom_space=1.2, markers=[("cap_mk", -0.40)],
                        params={"w": "c_width", "l": "c_length"}),
    },
    libs=[
        dict(prefix="gf180mcu_fd_sc_mcu7t5v0__",
             gds="libs.ref/gf180mcu_fd_sc_mcu7t5v0/gds/gf180mcu_fd_sc_mcu7t5v0.gds",
             spice="libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice"),
    ],
    signoff=dict(magicrc="libs.tech/magic/gf180mcuD.magicrc", netgen="libs.tech/netgen/gf180mcuD_setup.tcl",
                 drc_style="drc(full)",
                 klayout=dict(deck="libs.tech/klayout/tech/drc/gf180mcu.drc", top="topcell",
                              args=dict(variant="D", run_mode="flat"),
                              waive={r: "die-level density / fill rule, not applicable to a block"
                                     for r in ("M1.4", "M2.4", "M3.4", "M4.4", "M5.4", "MT.3", "PL.8",
                                               "DCF.1a", "DCF.1b")})),
    supplies=dict(power="VDD", ground="VSS"),
    spice_unit="u",                 # magic writes w=1u l=0.28u for this PDK (sky130 uses a 1u scale)
    conn=dict(conductors=["poly", "diff"],
              cut_by={"diff": ["poly"], "poly": ["res_mk"], "m1": ["m1res"], "m2": ["m2res"], "m3": ["m3res"],
                      "m4": ["m4res"], "m5": ["m5res"]},
              plates={"capm": "via4"}),
)
