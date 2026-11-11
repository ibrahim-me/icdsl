import klayout.db as kdb

# -----------------------------------------------------------------------------
# PDK data for gf180mcuD (layers as (gds layer, datatype), rules in um)
# -----------------------------------------------------------------------------
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "pwell": (204, 0), "dnwell": (12, 0),
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0), "sab": (49, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0), "via2": (38, 0), "m3": (42, 0),
        "via3": (40, 0), "m4": (46, 0), "via4": (41, 0), "m5": (81, 0),
        "capm": (75, 0), "cap_mk": (117, 5), "res_mk": (110, 5), "sab": (49, 0),
    },
    label={
        "poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
        "nwell": (21, 10), "pwell": (204, 10),
    },
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"diff": 0.22, "poly": 0.18, "nplus": 0.40, "pplus": 0.40, "m1": 0.23, "m2": 0.28,
           "m3": 0.28, "m4": 0.28, "m5": 0.44, "capm": 5.0},
    space={
        ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("nplus", "nplus"): 0.40, ("pplus", "pplus"): 0.40,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28, ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
        ("nwell", "diff"): 0.43, ("capm", "capm"): 0.60,
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
        tap_diff_space=0.32,
    ),
    devices={
        "nmos": dict(type="mos", model="nfet_03v3", diff="diff", implant="nplus", well=None,
                     lmin=0.28, wmin=0.22, bulk="VSS", implant_gate_ext=0.23),
        "pmos": dict(type="mos", model="pfet_03v3", diff="diff", implant="pplus", well="nwell",
                     lmin=0.28, wmin=0.22, bulk="VDD", implant_gate_ext=0.23),
        "ptap": dict(type="tap", diff="diff", implant="pplus", well=None),
        "ntap": dict(type="tap", diff="diff", implant="nplus", well="nwell", well_enc=0.12),
        "res_poly": dict(type="res", model="ppolyf_u", body="poly",
                         markers=[("res_mk", 0.0), ("sab", 0.28)],
                         covers=[("pplus", 0.30, 0.30)], head_space=0.22, wmin=0.80, lmin=1.0,
                         terminals=3, bulk="VSS", params={"w": "r_width", "l": "r_length"}),
        "cap_mim": dict(type="mim", model="cap_mim_2f0_m4m5_noshield", bottom="m4", plate="capm", top="m5",
                        cut="via4", wmin=5.0, bottom_enc=0.60, cut_enc=0.40,
                        markers=[("cap_mk", -0.40)],
                        params={"w": "c_width", "l": "c_length"}),
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

    # -- primitive shapes ----------------------------------------------------
    def box(self, layer, x, y, w, h):
        self.top.shapes(self.layers[layer]).insert(
            kdb.DBox(x, y, x + w, y + h))

    def label(self, layer, text, x, y):
        self.top.shapes(self.layers[layer + "_label"]).insert(
            kdb.DText(text, kdb.DTrans(x, y)))

    def contact(self, x, y, net=None):
        """diff/poly -> m1 contact with m1 pad"""
        c = self.tech["cuts"]["contact"]
        s = c["size"]
        self.box("contact", x - s / 2, y - s / 2, s, s)
        pad = s + 2 * 0.06
        self.box("m1", x - pad / 2, y - pad / 2, pad, pad)
        if net:
            self.label("m1", net, x, y)

    def via1(self, x, y, net=None):
        v = self.tech["cuts"]["via1"]
        s = v["size"]
        self.box("via1", x - s / 2, y - s / 2, s, s)
        pad = s + 2 * 0.06
        self.box("m1", x - pad / 2, y - pad / 2, pad, pad)
        self.box("m2", x - pad / 2, y - pad / 2, pad, pad)
        if net:
            self.label("m2", net, x, y)

    def via4(self, x, y, net=None):
        v = self.tech["cuts"]["via4"]
        s = v["size"]
        self.box("via4", x - s / 2, y - s / 2, s, s)
        pad = s + 2 * 0.06
        self.box("m4", x - pad / 2, y - pad / 2, pad, pad)
        self.box("m5", x - pad / 2, y - pad / 2, pad, pad)
        if net:
            self.label("m5", net, x, y)

    def m1_h(self, y, x0, x1, net=None):
        w = self.tech["width"]["m1"]
        self.box("m1", x0, y - w / 2, x1 - x0, w)
        if net:
            self.label("m1", net, (x0 + x1) / 2, y)

    def m1_v(self, x, y0, y1, net=None):
        w = self.tech["width"]["m1"]
        self.box("m1", x - w / 2, y0, w, y1 - y0)
        if net:
            self.label("m1", net, x, (y0 + y1) / 2)

    def m2_h(self, y, x0, x1, net=None):
        w = self.tech["width"]["m2"]
        self.box("m2", x0, y - w / 2, x1 - x0, w)
        if net:
            self.label("m2", net, (x0 + x1) / 2, y)

    def m2_v(self, x, y0, y1, net=None):
        w = self.tech["width"]["m2"]
        self.box("m2", x - w / 2, y0, w, y1 - y0)
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

    # -- MOS transistor ------------------------------------------------------
    def mos(self, x, y, w, l, fingers, gate_net, source_net, drain_net,
            is_pmos=False, bulk_net=None):
        """Place a multi-finger MOS transistor.
        Fingers run along x. Gate length = l (x), gate width = w (y).
        Source/drain contacts on m1, gate contacts on poly->m1.
        """
        dev = self.tech["devices"]["pmos" if is_pmos else "nmos"]
        implant = dev["implant"]
        de = self.tech["rules"]["diff_ext_gate"]
        pe = self.tech["rules"]["poly_endcap"]
        gs = self.tech["rules"]["gate_space"]
        ds = self.tech["space"][("diff", "diff")]
        c = self.tech["cuts"]["contact"]
        cs = c["size"]

        diff_len = l + 2 * de
        pitch = diff_len + ds
        total_w = fingers * pitch

        # nwell for PMOS
        if is_pmos:
            nw_x = x - self.tech["enc"][("nwell", "diff")][0]
            nw_y = y - self.tech["enc"][("nwell", "diff")][0]
            nw_w = total_w + 2 * self.tech["enc"][("nwell", "diff")][0]
            nw_h = w + 2 * self.tech["enc"][("nwell", "diff")][0]
            self.box("nwell", nw_x, nw_y, nw_w, nw_h)
            self.label("nwell", bulk_net or "VDD", x + total_w / 2, y + w / 2)

        for i in range(fingers):
            fx = x + i * pitch
            # diffusion
            self.box("diff", fx, y, diff_len, w)
            self.box(implant, fx, y, diff_len, w)
            # poly gate
            gx = fx + de
            self.box("poly", gx, y - pe, l, w + 2 * pe)
            # source contact (left side of gate)
            sx = fx + de - cs / 2 - 0.01
            sy = y + w / 2
            self.contact(sx, sy, source_net)
            # drain contact (right side of gate)
            dx = gx + l + cs / 2 + 0.01
            self.contact(dx, sy, drain_net)
            # gate contact on poly extension (top side)
            gcx = gx + l / 2
            gcy = y - pe - cs / 2 - 0.01
            self.contact(gcx, gcy, gate_net)

        # connect all source contacts together with m1 rail above the fingers
        src_rail_y = y + w + pe + cs + 0.1
        self.m1_h(src_rail_y, x, x + total_w, source_net)
        for i in range(fingers):
            fx = x + i * pitch
            sx = fx + de - cs / 2 - 0.01
            sy = y + w / 2
            self.m1_v(sx, sy, src_rail_y, source_net)

        # connect all drain contacts together with m1 rail
        drn_rail_y = y + w + pe + cs + 0.1 + 0.5
        self.m1_h(drn_rail_y, x, x + total_w, drain_net)
        for i in range(fingers):
            fx = x + i * pitch
            gx = fx + de
            dx = gx + l + cs / 2 + 0.01
            sy = y + w / 2
            self.m1_v(dx, sy, drn_rail_y, drain_net)

        # connect all gate contacts together with m1 rail
        gate_rail_y = y - pe - cs - 0.1 - 0.5
        self.m1_h(gate_rail_y, x, x + total_w, gate_net)
        for i in range(fingers):
            fx = x + i * pitch
            gx = fx + de
            gcx = gx + l / 2
            gcy = y - pe - cs / 2 - 0.01
            self.m1_v(gcx, gcy, gate_rail_y, gate_net)

        return x + total_w

    # -- poly resistor -------------------------------------------------------
    def resistor_poly(self, x, y, w, l, net_a, net_b, bulk_net="VSS"):
        """Unsalicided poly resistor between net_a and net_b, bulk to bulk_net."""
        dev = self.tech["devices"]["res_poly"]
        c = self.tech["cuts"]["contact"]
        cs = c["size"]
        pe = self.tech["rules"]["poly_endcap"]

        # poly body
        self.box("poly", x, y, l, w)
        # markers
        self.box("res_mk", x, y, l, w)
        self.box("sab", x - 0.28, y - 0.28, l + 2 * 0.28, w + 2 * 0.28)
        # pplus covers at ends
        cover_w = 0.30
        self.box("pplus", x - cover_w, y - cover_w / 2, cover_w, w + cover_w)
        self.box("pplus", x + l, y - cover_w / 2, cover_w, w + cover_w)
        self.label("res_mk", "RES", x + l / 2, y + w / 2)

        # contacts on poly ends
        self.contact(x + cs / 2 + 0.07, y + w / 2, net_a)
        self.contact(x + l - cs / 2 - 0.07, y + w / 2, net_b)

        # route contacts with m1
        self.m1_h(y + w / 2, x + cs / 2 + 0.07, x + l - cs / 2 - 0.07, None)

        # bulk tap: p+ diffusion contact to VSS near resistor
        tap_x = x - 1.0
        tap_y = y + w / 2
        self.box("diff", tap_x, tap_y - 0.22, 0.44, 0.44)
        self.box("pplus", tap_x, tap_y - 0.22, 0.44, 0.44)
        self.contact(tap_x + 0.22, tap_y, bulk_net)
        self.m1_h(tap_y, tap_x, tap_x + 0.44, bulk_net)

        return x + l + 2.0

    # -- MIM capacitor -------------------------------------------------------
    def cap_mim(self, x, y, w, l, net_bottom, net_top):
        """MIM cap: bottom plate m4, capm dielectric/plate, top plate m5."""
        dev = self.tech["devices"]["cap_mim"]
        c = self.tech["cuts"]["via4"]
        cs = c["size"]

        # bottom plate m4
        self.box("m4", x, y, w, l)
        # capm plate
        self.box("capm", x, y, w, l)
        # top plate m5
        self.box("m5", x, y, w, l)
        # marker
        mk_off = dev["markers"][0][1]
        self.box("cap_mk", x + mk_off, y + mk_off, w - 2 * mk_off, l - 2 * mk_off)
        self.label("cap_mk", "CAP", x + w / 2, y + l / 2)

        # via4 at corners to connect plates
        pad = cs + 2 * 0.06
        # bottom-left via: connect m4 to net_bottom
        self.via4(x + cs / 2 + 0.06, y + cs / 2 + 0.06, net_bottom)
        # top-right via: connect m5 to net_top
        self.via4(x + w - cs / 2 - 0.06, y + l - cs / 2 - 0.06, net_top)

        # route m4 to bottom net
        self.m4_h(y + cs / 2 + 0.06, x + cs / 2 + 0.06, x + w - cs / 2 - 0.06, net_bottom)
        # route m5 to top net
        self.m5_h(y + l - cs / 2 - 0.06, x + cs / 2 + 0.06, x + w - cs / 2 - 0.06, net_top)

        return x + w + 2.0

    # -- pin on m1 -----------------------------------------------------------
    def pin_m1(self, net, x, y):
        w = self.tech["width"]["m1"]
        self.box("m1", x - w / 2, y - w / 2, w, w)
        self.label("m1", net, x, y)

    # -- write ---------------------------------------------------------------
    def write(self, fname):
        self.top.shapes()  # ensure cell exists
        self.ly.write(fname)


# -----------------------------------------------------------------------------
# Build ota_miller for gf180mcuD
# -----------------------------------------------------------------------------
def build_ota_miller():
    b = OTABuilder(TECH, "ota_miller")

    # placement cursor
    x = 0.0
    y_nmos = 4.0
    y_pmos = 14.0

    # M1: NMOS diff pair left, w=4, l=0.5, fingers=2
    # gate=INN, source=tail, drain=d1
    x = b.mos(x, y_nmos, 4.0, 0.5, 2, 'INN', 'tail', 'd1', is_pmos=False)
    x += 1.0

    # M2: NMOS diff pair right, w=4, l=0.5, fingers=2
    # gate=INP, source=tail, drain=d2
    x = b.mos(x, y_nmos, 4.0, 0.5, 2, 'INP', 'tail', 'd2', is_pmos=False)
    x += 1.0

    # M5: tail current source, w=2, l=1, fingers=4
    # gate=IB, source=VSS, drain=tail
    x = b.mos(x, y_nmos, 2.0, 1.0, 4, 'IB', 'VSS', 'tail', is_pmos=False)
    x += 1.0

    # M3: PMOS load left, w=4, l=1, fingers=2
    # gate=d1, source=VDD, drain=d1
    x = b.mos(x, y_pmos, 4.0, 1.0, 2, 'd1', 'VDD', 'd1', is_pmos=True, bulk_net='VDD')
    x += 1.0

    # M4: PMOS load right, w=4, l=1, fingers=2
    # gate=d1, source=VDD, drain=d2
    x = b.mos(x, y_pmos, 4.0, 1.0, 2, 'd1', 'VDD', 'd2', is_pmos=True, bulk_net='VDD')
    x += 1.0

    # M6: second stage PMOS, w=4, l=0.5, fingers=8
    # gate=d2, source=VDD, drain=OUT
    x = b.mos(x, y_pmos, 4.0, 0.5, 8, 'd2', 'VDD', 'OUT', is_pmos=True, bulk_net='VDD')
    x += 1.0

    # M7: sink NMOS, w=2, l=1, fingers=8
    # gate=IB, source=VSS, drain=OUT
    x = b.mos(x, y_nmos, 2.0, 1.0, 8, 'IB', 'VSS', 'OUT', is_pmos=False)
    x += 1.0

    # M8: bias diode NMOS, w=2, l=1, fingers=2
    # gate=IB, source=VSS, drain=IB
    x = b.mos(x, y_nmos, 2.0, 1.0, 2, 'IB', 'VSS', 'IB', is_pmos=False)
    x += 1.0

    # RZ: poly resistor w=1, l=8 between d2 and x, bulk VSS
    x = b.resistor_poly(x, 10.0, 1.0, 8.0, 'd2', 'x', bulk_net='VSS')

    # CC: MIM cap 20x20 between x and OUT
    x = b.cap_mim(x, 0.0, 20.0, 20.0, 'x', 'OUT')

    # ------------------------------------------------------------------
    # Global rails: VDD, VSS, IB on m2
    # ------------------------------------------------------------------
    rail_y_vdd = 21.0
    rail_y_vss = 1.0
    rail_y_ib = 11.0
    rail_x0 = -2.0
    rail_x1 = x + 2.0

    b.m2_h(rail_y_vdd, rail_x0, rail_x1, 'VDD')
    b.m2_h(rail_y_vss, rail_x0, rail_x1, 'VSS')
    b.m2_h(rail_y_ib, rail_x0, rail_x1, 'IB')

    # connect VDD rail to PMOS sources (already labeled VDD on contacts, but add vias)
    # connect VSS rail to NMOS sources
    # connect IB rail to gates
    # We'll drop via1 from m2 rails to m1 contacts at strategic points.
    # For simplicity, place via1 at the right end of each rail.
    b.via1(rail_x1 - 0.5, rail_y_vdd, 'VDD')
    b.via1(rail_x1 - 0.5, rail_y_vss, 'VSS')
    b.via1(rail_x1 - 0.5, rail_y_ib, 'IB')

    # ------------------------------------------------------------------
    # I/O pins on m1
    # ------------------------------------------------------------------
    b.pin_m1('INP', 0.5, y_nmos - 1.0)
    b.pin_m1('INN', 0.5, y_nmos + 5.0)
    b.pin_m1('OUT', x - 1.0, y_pmos + 5.0)
    b.pin_m1('IB', x - 1.0, y_nmos - 1.0)
    b.pin_m1('VDD', rail_x1 - 1.0, rail_y_vdd)
    b.pin_m1('VSS', rail_x1 - 1.0, rail_y_vss)

    b.write('ota_miller.gds')
    print("Wrote ota_miller.gds, bbox:", self_bbox(b))


def self_bbox(b):
    bb = b.top.bbox()
    return (bb.left, bb.bottom, bb.right, bb.top)


if __name__ == '__main__':
    build_ota_miller()
