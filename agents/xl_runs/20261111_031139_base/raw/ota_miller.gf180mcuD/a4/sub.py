import klayout.db as kdb

# -----------------------------------------------------------------------------
# PDK data for gf180mcuD
# -----------------------------------------------------------------------------
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0), "sab": (49, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0), "via2": (38, 0), "m3": (42, 0),
        "via3": (40, 0), "m4": (46, 0), "via4": (41, 0), "m5": (81, 0),
        "capm": (75, 0), "cap_mk": (117, 5), "res_mk": (110, 5),
    },
    label={
        "poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
        "nwell": (21, 10), "pwell": (204, 10),
    },
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"m1": 0.23, "m2": 0.28, "m4": 0.28, "m5": 0.44},
    space={
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06),
        ("m4", "via4"): (0.01, 0.06), ("m5", "via4"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
        ("nwell", "diff"): (0.43, 0.43),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        gate_space=0.24,
    ),
    devices={
        "nmos": dict(type="mos", model="nfet_03v3", diff="diff", implant="nplus", well=None,
                     lmin=0.28, wmin=0.22, bulk="VSS"),
        "pmos": dict(type="mos", model="pfet_03v3", diff="diff", implant="pplus", well="nwell",
                     lmin=0.28, wmin=0.22, bulk="VDD"),
        "res_poly": dict(type="res", model="ppolyf_u", body="poly",
                         markers=[("res_mk", 0.0), ("sab", 0.28)],
                         covers=[("pplus", 0.30, 0.30)], head_space=0.22, wmin=0.80, lmin=1.0,
                         terminals=3, bulk="VSS"),
        "cap_mim": dict(type="mim", model="cap_mim_2f0_m4m5_noshield", bottom="m4", plate="capm", top="m5",
                        cut="via4", wmin=5.0, bottom_enc=0.60, cut_enc=0.40,
                        markers=[("cap_mk", -0.40)]),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# -----------------------------------------------------------------------------
# Layout builder
# -----------------------------------------------------------------------------
class OTABuilder:
    def __init__(self, tech, top_name="ota_miller"):
        self.tech = tech
        self.ly = kdb.Layout()
        self.ly.dbu = 0.001
        self.top = self.ly.create_cell(top_name)
        self.layers = {}
        for name, (gds, dt) in tech["layers"].items():
            self.layers[name] = self.ly.layer(gds, dt)
        for name, (gds, dt) in tech["label"].items():
            self.layers[name + "_label"] = self.ly.layer(gds, dt)
        # derived DRC constants
        R = tech["rules"]
        C = tech["cuts"]["contact"]
        self.cs = C["size"]                      # 0.22
        self.m1pad = 0.40                        # >= sqrt(0.1444)=0.38 for M1.3 area
        self.via1pad = 0.40
        self.via4pad = 0.40
        self.ext = 0.45                          # diff extension beyond gate for contacts
        self.pe = R["poly_endcap"]               # 0.22
        self.de = R["diff_ext_gate"]             # 0.23 (min)
        self.gcs = R["gate_contact_space"]       # 0.15 contact-to-poly
        self.m1w = tech["width"]["m1"]           # 0.23
        self.m2w = tech["width"]["m2"]           # 0.28

    # -- primitive shapes ----------------------------------------------------
    def box(self, layer, x, y, w, h):
        self.top.shapes(self.layers[layer]).insert(kdb.DBox(x, y, x + w, y + h))

    def label(self, layer, text, x, y):
        key = layer + "_label"
        if key not in self.layers:
            key = layer
        self.top.shapes(self.layers[key]).insert(
            kdb.DText(text, kdb.DTrans(kdb.DVector(x, y))))

    def contact(self, x, y, net=None):
        """diff/poly contact with m1 pad (pad sized for M1.3 min area)."""
        c = self.tech["cuts"]["contact"]
        s = c["size"]
        self.box("contact", x - s / 2, y - s / 2, s, s)
        p = self.m1pad
        self.box("m1", x - p / 2, y - p / 2, p, p)
        if net:
            self.label("m1", net, x, y)

    def via1(self, x, y, net=None):
        v = self.tech["cuts"]["via1"]
        s = v["size"]
        self.box("via1", x - s / 2, y - s / 2, s, s)
        p = self.via1pad
        self.box("m1", x - p / 2, y - p / 2, p, p)
        self.box("m2", x - p / 2, y - p / 2, p, p)
        if net:
            self.label("m2", net, x, y)

    def via4(self, x, y, net=None):
        v = self.tech["cuts"]["via4"]
        s = v["size"]
        self.box("via4", x - s / 2, y - s / 2, s, s)
        p = self.via4pad
        self.box("m4", x - p / 2, y - p / 2, p, p)
        self.box("m5", x - p / 2, y - p / 2, p, p)
        if net:
            self.label("m5", net, x, y)

    def m1_h(self, y, x0, x1, net=None):
        self.box("m1", x0, y - self.m1w / 2, x1 - x0, self.m1w)
        if net:
            self.label("m1", net, (x0 + x1) / 2, y)

    def m1_v(self, x, y0, y1, net=None):
        self.box("m1", x - self.m1w / 2, y0, self.m1w, y1 - y0)
        if net:
            self.label("m1", net, x, (y0 + y1) / 2)

    def m2_h(self, y, x0, x1, net=None):
        self.box("m2", x0, y - self.m2w / 2, x1 - x0, self.m2w)
        if net:
            self.label("m2", net, (x0 + x1) / 2, y)

    def m2_v(self, x, y0, y1, net=None):
        self.box("m2", x - self.m2w / 2, y0, self.m2w, y1 - y0)
        if net:
            self.label("m2", net, x, (y0 + y1) / 2)

    def m4_h(self, y, x0, x1, net=None):
        w = self.tech["width"]["m4"]
        self.box("m4", x0, y - w / 2, x1 - x0, w)
        if net:
            self.label("m4", net, (x0 + x1) / 2, y)

    def m5_h(self, y, x0, x1, net=None):
        w = self.tech["width"]["m5"]
        self.box("m5", x0, y - w / 2, x1 - x0, w)
        if net:
            self.label("m5", net, (x0 + x1) / 2, y)

    def pin_m1(self, net, x, y):
        self.box("m1", x - self.m1w / 2, y - self.m1w / 2, self.m1w, self.m1w)
        self.label("m1", net, x, y)

    # -- MOS transistor (single instance, DRC-correct) -----------------------
    def mos(self, x, y, w, l, gate_net, source_net, drain_net,
            is_pmos=False, bulk_net=None):
        """One MOS instance. Diffusion extends `ext` beyond gate on each side
        so source/drain contacts fit with 0.07 diff enc and 0.15 poly space.
        Returns right edge of diffusion."""
        dev = self.tech["devices"]["pmos" if is_pmos else "nmos"]
        implant = dev["implant"]
        enc_nw = self.tech["enc"][("nwell", "diff")][0]
        enc_imp = self.tech["enc"][("nplus" if not is_pmos else "pplus", "diff")][0]

        # nwell for PMOS (shared, extends beyond diff)
        if is_pmos:
            self.box("nwell", x - enc_nw, y - enc_nw, l + 2 * self.ext + 2 * enc_nw,
                     w + 2 * enc_nw)
            self.label("nwell", bulk_net or "VDD", x + l / 2, y + w / 2)

        # diffusion + implant
        self.box("diff", x, y, l + 2 * self.ext, w)
        self.box(implant, x - enc_imp, y - enc_imp, l + 2 * self.ext + 2 * enc_imp,
                 w + 2 * enc_imp)

        # poly gate with endcap
        gx = x + self.ext
        self.box("poly", gx, y - self.pe, l, w + 2 * self.pe)

        # source contact (left side of gate)
        scx = x + self.ext - self.gcs - self.cs / 2
        scy = y + w / 2
        self.contact(scx, scy, source_net)

        # drain contact (right side of gate)
        dcx = x + self.ext + l + self.gcs + self.cs / 2
        self.contact(dcx, scy, drain_net)

        # gate contact on poly extension (above diffusion)
        gcx = x + self.ext + l / 2
        gcy = y - self.pe - self.cs / 2 - 0.01
        self.contact(gcx, gcy, gate_net)

        # m1 local interconnect: connect source contact, drain contact, gate contact
        # source rail above diffusion
        sr_y = y + w + self.pe + self.cs / 2 + 0.05 + self.m1w / 2
        self.m1_h(sr_y, x, x + l + 2 * self.ext, source_net)
        self.m1_v(scx, scy, sr_y, source_net)

        # drain rail above source rail
        dr_y = sr_y + self.m1w + 0.30
        self.m1_h(dr_y, x, x + l + 2 * self.ext, drain_net)
        self.m1_v(dcx, scy, dr_y, drain_net)

        # gate rail above drain rail
        gr_y = dr_y + self.m1w + 0.30
        self.m1_h(gr_y, x, x + l + 2 * self.ext, gate_net)
        self.m1_v(gcx, gcy, gr_y, gate_net)

        return x + l + 2 * self.ext

    # -- poly resistor -------------------------------------------------------
    def resistor_poly(self, x, y, w, l, net_a, net_b, bulk_net="VSS"):
        c = self.tech["cuts"]["contact"]
        cs = c["size"]
        enc_imp = self.tech["enc"][("pplus", "diff")][0]

        # poly body
        self.box("poly", x, y, l, w)
        # markers
        self.box("res_mk", x, y, l, w)
        self.box("sab", x - 0.28, y - 0.28, l + 2 * 0.28, w + 2 * 0.28)
        # pplus covers at ends (must be >= 0.35 area: 0.44x0.80 = 0.352)
        cw = 0.44
        ch = 0.80
        self.box("pplus", x - cw, y - (ch - w) / 2, cw, ch)
        self.box("pplus", x + l, y - (ch - w) / 2, cw, ch)

        # contacts on poly ends (overlap poly by 0.07)
        self.contact(x + cs / 2 + 0.07, y + w / 2, net_a)
        self.contact(x + l - cs / 2 - 0.07, y + w / 2, net_b)

        # m1 between contacts
        self.m1_h(y + w / 2, x + cs / 2 + 0.07, x + l - cs / 2 - 0.07, None)

        # bulk tap: p+ diffusion contact to bulk_net
        tap_x = x - 1.5
        tap_y = y + w / 2
        self.box("diff", tap_x, tap_y - 0.22, 0.44, 0.44)
        self.box("pplus", tap_x, tap_y - 0.22, 0.44, 0.44)
        self.contact(tap_x + 0.22, tap_y, bulk_net)
        self.m1_h(tap_y, tap_x, tap_x + 0.44, bulk_net)

        return x + l + 2.0

    # -- MIM capacitor -------------------------------------------------------
    def cap_mim(self, x, y, w, l, net_bottom, net_top):
        c = self.tech["cuts"]["via4"]
        cs = c["size"]
        be = self.tech["devices"]["cap_mim"]["bottom_enc"]  # 0.60

        # bottom plate m4
        self.box("m4", x, y, w, l)
        # capm extends beyond m4
        self.box("capm", x - be, y - be, w + 2 * be, l + 2 * be)
        # top plate m5 (same size as m4)
        self.box("m5", x, y, w, l)
        # marker
        mk = 0.40
        self.box("cap_mk", x + mk, y + mk, w - 2 * mk, l - 2 * mk)

        # via4 at corners: bottom-left -> m4/net_bottom, top-right -> m5/net_top
        self.via4(x + cs / 2 + 0.06, y + cs / 2 + 0.06, net_bottom)
        self.via4(x + w - cs / 2 - 0.06, y + l - cs / 2 - 0.06, net_top)

        # route m4 to bottom net
        self.m4_h(y + cs / 2 + 0.06, x + cs / 2 + 0.06, x + w - cs / 2 - 0.06, net_bottom)
        # route m5 to top net
        self.m5_h(y + l - cs / 2 - 0.06, x + cs / 2 + 0.06, x + w - cs / 2 - 0.06, net_top)

        return x + w + 2.0

    # -- write ---------------------------------------------------------------
    def write(self, fname):
        self.ly.write(fname)

    def bbox(self):
        bb = self.top.bbox()
        return (bb.left, bb.bottom, bb.right, bb.top)


# -----------------------------------------------------------------------------
# Build ota_miller for gf180mcuD
# -----------------------------------------------------------------------------
def build_ota_miller():
    b = OTABuilder(TECH, "ota_miller")

    # Floorplan coordinates
    y_nmos = 6.0          # NMOS row
    y_pmos = 20.0         # PMOS row
    x = 0.0

    # ---- NMOS differential pair M1 (INN) ----------------------------------
    x = b.mos(x, y_nmos, 4.0, 0.5, 'INN', 'tail', 'd1', is_pmos=False)
    x += 1.0

    # ---- NMOS differential pair M2 (INP) ----------------------------------
    x = b.mos(x, y_nmos, 4.0, 0.5, 'INP', 'tail', 'd2', is_pmos=False)
    x += 1.0

    # ---- Tail current source M5 (4 instances in netlist, place as 4) ------
    for _ in range(4):
        x = b.mos(x, y_nmos, 2.0, 1.0, 'IB', 'VSS', 'tail', is_pmos=False)
        x += 0.5

    # ---- PMOS load M3 (2 instances) ---------------------------------------
    for _ in range(2):
        x = b.mos(x, y_pmos, 4.0, 1.0, 'd1', 'VDD', 'd1', is_pmos=True, bulk_net='VDD')
        x += 1.0

    # ---- PMOS load M4 (2 instances) ---------------------------------------
    for _ in range(2):
        x = b.mos(x, y_pmos, 4.0, 1.0, 'd1', 'VDD', 'd2', is_pmos=True, bulk_net='VDD')
        x += 1.0

    # ---- PMOS second stage M6 (8 instances) -------------------------------
    for _ in range(8):
        x = b.mos(x, y_pmos, 4.0, 0.5, 'd2', 'VDD', 'OUT', is_pmos=True, bulk_net='VDD')
        x += 0.5

    # ---- NMOS sink M7 (8 instances) ---------------------------------------
    for _ in range(8):
        x = b.mos(x, y_nmos, 2.0, 1.0, 'IB', 'VSS', 'OUT', is_pmos=False)
        x += 0.5

    # ---- NMOS bias diode M8 (2 instances) ---------------------------------
    for _ in range(2):
        x = b.mos(x, y_nmos, 2.0, 1.0, 'IB', 'VSS', 'IB', is_pmos=False)
        x += 0.5

    # ---- Resistor RZ between d2 and x, bulk VSS ---------------------------
    x = b.resistor_poly(x, 10.0, 1.0, 8.0, 'd2', 'x', bulk_net='VSS')

    # ---- MIM capacitor CC between x and OUT -------------------------------
    x = b.cap_mim(x, 0.0, 20.0, 20.0, 'x', 'OUT')

    # ---- Global rails on m2 -----------------------------------------------
    rail_y_vdd = 34.0
    rail_y_vss = -4.0
    rail_y_ib = 15.0
    rail_x0 = -3.0
    rail_x1 = x + 3.0

    b.m2_h(rail_y_vdd, rail_x0, rail_x1, 'VDD')
    b.m2_h(rail_y_vss, rail_x0, rail_x1, 'VSS')
    b.m2_h(rail_y_ib, rail_x0, rail_x1, 'IB')

    # Connect rails to local m1 with via1 at several points
    # VDD: connect to PMOS source rails (gr_y of PMOS row ~ y_pmos + ... )
    # We'll drop via1 from m2 rail down to m1 at the right end
    b.via1(rail_x1 - 1.0, rail_y_vdd, 'VDD')
    b.via1(rail_x1 - 1.0, rail_y_vss, 'VSS')
    b.via1(rail_x1 - 1.0, rail_y_ib, 'IB')

    # Also connect IB rail to the IB gate contacts of NMOS devices
    # (gate contacts are on m1; drop via1 from IB m2 rail to those m1 gate rails)
    # Place via1 under each NMOS gate rail where it crosses IB rail
    # For simplicity, connect IB rail to the first M5 gate contact area
    # We already labeled IB on m2; the MOS gate contacts labeled IB on m1 are
    # separate nets unless connected. Add m1 vertical segments from gate rails
    # up to IB m2 rail with via1.
    # Connect IB m2 rail to M5/M7/M8 gate rails:
    ib_connect_x = 4.0  # somewhere in the NMOS row
    b.m1_v(ib_connect_x, y_nmos - 0.5 - 0.22 - 0.1 - 0.5 - 0.3 - 0.5, rail_y_ib - 0.14, 'IB')
    b.via1(ib_connect_x, rail_y_ib - 0.14, 'IB')

    # Connect VDD m2 rail to PMOS source rails
    vdd_connect_x = y_pmos and 8.0 or 8.0
    b.m1_v(vdd_connect_x, y_pmos + 4.0 + 0.22 + 0.1 + 0.5 + 0.3 + 0.5, rail_y_vdd + 0.14, 'VDD')
    b.via1(vdd_connect_x, rail_y_vdd + 0.14, 'VDD')

    # Connect VSS m2 rail to NMOS source rails
    vss_connect_x = 12.0
    b.m1_v(vss_connect_x, y_nmos + 4.0 + 0.22 + 0.1 + 0.5 + 0.3 + 0.5, rail_y_vss + 0.14, 'VSS')
    b.via1(vss_connect_x, rail_y_vss + 0.14, 'VSS')

    # ---- I/O pins on m1 ----------------------------------------------------
    b.pin_m1('INP', 0.5, y_nmos - 2.0)
    b.pin_m1('INN', 0.5, y_nmos + 6.0)
    b.pin_m1('OUT', x - 1.0, y_pmos + 6.0)
    b.pin_m1('IB', x - 1.0, y_nmos - 2.0)
    b.pin_m1('VDD', rail_x1 - 1.0, rail_y_vdd)
    b.pin_m1('VSS', rail_x1 - 1.0, rail_y_vss)

    b.write('ota_miller.gds')
    print("Wrote ota_miller.gds, bbox:", b.bbox())


if __name__ == '__main__':
    build_ota_miller()

