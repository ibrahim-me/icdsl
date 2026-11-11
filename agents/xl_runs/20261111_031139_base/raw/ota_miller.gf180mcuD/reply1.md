import klayout.db as kdb
import math

# ----------------------------------------------------------------------
# Technology data for gf180mcuD (um)
# ----------------------------------------------------------------------
TECH = dict(
    dbu=0.001,
    layers=dict(
        nwell=(21,0), pwell=(204,0), diff=(22,0), poly=(30,0),
        nplus=(32,0), pplus=(31,0), contact=(33,0), m1=(34,0),
        via1=(35,0), m2=(36,0), via2=(38,0), m3=(42,0),
        via3=(40,0), m4=(46,0), via4=(41,0), m5=(81,0),
        capm=(75,0), sab=(49,0), res_mk=(110,5), cap_mk=(117,5),
    ),
    label_layers=dict(
        poly=(30,10), m1=(34,10), m2=(36,10), m3=(42,10), m4=(46,10), m5=(81,10),
        nwell=(21,10), pwell=(204,10),
    ),
    rules=dict(
        poly_w=0.18, poly_space=0.24, poly_endcap=0.22,
        diff_w=0.22, diff_space=0.28, diff_ext_gate=0.23,
        nplus_w=0.40, nplus_space=0.40, nplus_enc_diff=0.16,
        pplus_w=0.40, pplus_space=0.40, pplus_enc_diff=0.16,
        nwell_w=0.86, nwell_space=0.60, nwell_enc_diff=0.43,
        contact_size=0.22, contact_space=0.25,
        contact_enc_diff=0.07, contact_enc_poly=0.07,
        m1_w=0.23, m1_space=0.23,
        m1_contact_enc_all=0.005, m1_contact_enc_opp=0.06,
        via1_size=0.26, via1_space=0.26,
        m1_via1_enc_all=0.0, m1_via1_enc_opp=0.06,
        m2_via1_enc_all=0.01, m2_via1_enc_opp=0.06,
        gate_contact_space=0.15,
        polycontact_diff_space=0.17,
        res_head_space=0.22,
        res_marker_enc=0.28,
        res_pplus_cover=0.30,
        cap_bottom_enc=0.60,
        cap_cut_enc=0.40,
        cap_marker_enc=0.40,
    ),
)

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------
def dbu(um):
    return int(round(um / TECH['dbu']))

def um(dbu_val):
    return dbu_val * TECH['dbu']

class LayoutBuilder:
    def __init__(self, top_name):
        self.ly = kdb.Layout()
        self.ly.dbu = TECH['dbu']
        self.top = self.ly.create_cell(top_name)
        self.layers = {}
        for name, (gds, dt) in TECH['layers'].items():
            self.layers[name] = self.ly.layer(gds, dt)
        self.label_layers = {}
        for name, (gds, dt) in TECH['label_layers'].items():
            self.label_layers[name] = self.ly.layer(gds, dt)
        self.x = 0.0
        self.y = 0.0

    # -- primitive shapes ------------------------------------------------
    def box(self, layer, x1, y1, x2, y2):
        self.top.shapes(self.layers[layer]).insert(
            kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2)))

    def poly(self, x1, y1, x2, y2):
        self.box('poly', x1, y1, x2, y2)

    def diff(self, x1, y1, x2, y2):
        self.box('diff', x1, y1, x2, y2)

    def nplus(self, x1, y1, x2, y2):
        self.box('nplus', x1, y1, x2, y2)

    def pplus(self, x1, y1, x2, y2):
        self.box('pplus', x1, y1, x2, y2)

    def nwell(self, x1, y1, x2, y2):
        self.box('nwell', x1, y1, x2, y2)

    def contact(self, x, y, size=None):
        s = size if size else TECH['rules']['contact_size']
        hs = TECH['rules']['contact_enc_diff']
        self.box('contact', x - s/2, y - s/2, x + s/2, y + s/2)
        # m1 pad around contact
        pad = TECH['rules']['m1_contact_enc_opp']
        all_enc = TECH['rules']['m1_contact_enc_all']
        self.box('m1', x - s/2 - pad, y - s/2 - all_enc,
                 x + s/2 + pad, y + s/2 + all_enc)
        # make pad square enough for DRC
        self.box('m1', x - s/2 - all_enc, y - s/2 - pad,
                 x + s/2 + all_enc, y + s/2 + pad)

    def via1(self, x, y, size=None):
        s = size if size else TECH['rules']['via1_size']
        self.box('via1', x - s/2, y - s/2, x + s/2, y + s/2)
        pad = TECH['rules']['m1_via1_enc_opp']
        all_enc = TECH['rules']['m1_via1_enc_all']
        self.box('m1', x - s/2 - pad, y - s/2 - all_enc,
                 x + s/2 + pad, y + s/2 + all_enc)
        self.box('m1', x - s/2 - all_enc, y - s/2 - pad,
                 x + s/2 + all_enc, y + s/2 + pad)
        pad2 = TECH['rules']['m2_via1_enc_opp']
        all_enc2 = TECH['rules']['m2_via1_enc_all']
        self.box('m2', x - s/2 - pad2, y - s/2 - all_enc2,
                 x + s/2 + pad2, y + s/2 + all_enc2)
        self.box('m2', x - s/2 - all_enc2, y - s/2 - pad2,
                 x + s/2 + all_enc2, y + s/2 + pad2)

    def m1(self, x1, y1, x2, y2):
        self.box('m1', x1, y1, x2, y2)

    def m2(self, x1, y1, x2, y2):
        self.box('m2', x1, y1, x2, y2)

    def m4(self, x1, y1, x2, y2):
        self.box('m4', x1, y1, x2, y2)

    def m5(self, x1, y1, x2, y2):
        self.box('m5', x1, y1, x2, y2)

    def capm(self, x1, y1, x2, y2):
        self.box('capm', x1, y1, x2, y2)

    def sab(self, x1, y1, x2, y2):
        self.box('sab', x1, y1, x2, y2)

    def res_mk(self, x1, y1, x2, y2):
        self.box('res_mk', x1, y1, x2, y2)

    def via4(self, x, y, size=None):
        s = size if size else TECH['rules']['via1_size']
        self.box('via4', x - s/2, y - s/2, x + s/2, y + s/2)
        pad = TECH['rules']['m4_via4_enc_opp'] if 'm4_via4_enc_opp' in TECH['rules'] else 0.06
        all_enc = TECH['rules'].get('m4_via4_enc_all', 0.01)
        self.box('m4', x - s/2 - pad, y - s/2 - all_enc,
                 x + s/2 + pad, y + s/2 + all_enc)
        self.box('m4', x - s/2 - all_enc, y - s/2 - pad,
                 x + s/2 + all_enc, y + s/2 + pad)
        pad5 = TECH['rules'].get('m5_via4_enc_opp', 0.06)
        all_enc5 = TECH['rules'].get('m5_via4_enc_all', 0.01)
        self.box('m5', x - s/2 - pad5, y - s/2 - all_enc5,
                 x + s/2 + pad5, y + s/2 + all_enc5)
        self.box('m5', x - s/2 - all_enc5, y - s/2 - pad5,
                 x + s/2 + all_enc5, y + s/2 + pad5)

    # -- labels / pins ---------------------------------------------------
    def label(self, layer_name, text, x, y):
        self.top.shapes(self.label_layers[layer_name]).insert(
            kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

    def pin_m1(self, name, x, y):
        self.label('m1', name, x, y)

    # -- devices ---------------------------------------------------------
    def mos(self, kind, x, y, w, l, fingers=1, gate_net=None,
            source_net=None, drain_net=None, bulk_net=None,
            diff_ext=None, implant='nplus'):
        """
        Draw a multi-finger MOS transistor.
        Orientation: diffusion runs along Y (width = w), gate runs along X (length = l).
        Fingers are placed side by side along X.
        Each finger gets its own source and drain diff (no sharing between source/drain nets).
        Contacts are placed on source and drain diffs.
        """
        r = TECH['rules']
        de = diff_ext if diff_ext is not None else r['diff_ext_gate']
        gate_y = y
        gate_y1 = gate_y - (w + 2 * r['poly_endcap']) / 2
        gate_y2 = gate_y + (w + 2 * r['poly_endcap']) / 2
        diff_y1 = gate_y - w / 2
        diff_y2 = gate_y + w / 2
        impl_y1 = diff_y1 - r[f'{implant}_enc_diff']
        impl_y2 = diff_y2 + r[f'{implant}_enc_diff']
        cur_x = x
        for f in range(fingers):
            # source diff (left)
            s_x1 = cur_x
            s_x2 = cur_x + l + 2 * de
            self.diff(s_x1, diff_y1, s_x2, diff_y2)
            self.box(implant, s_x1 - r[f'{implant}_enc_diff'], impl_y1,
                     s_x2 + r[f'{implant}_enc_diff'], impl_y2)
            # gate
            g_x1 = cur_x + de
            g_x2 = cur_x + de + l
            self.poly(g_x1, gate_y1, g_x2, gate_y2)
            # drain diff (right)
            d_x1 = cur_x + 2 * de + l
            d_x2 = cur_x + 2 * de + 2 * l
            self.diff(d_x1, diff_y1, d_x2, diff_y2)
            self.box(implant, d_x1 - r[f'{implant}_enc_diff'], impl_y1,
                     d_x2 + r[f'{implant}_enc_diff'], impl_y2)
            # contacts: source
            scx = cur_x + de / 2
            scy = gate_y
            self.contact(scx, scy)
            if source_net:
                self.pin_m1(source_net, scx, scy)
            # contacts: drain
            dcx = cur_x + 2 * de + l + de / 2
            dcy = gate_y
            self.contact(dcx, dcy)
            if drain_net:
                self.pin_m1(drain_net, dcx, dcy)
            # gate contact (if gate_net specified)
            if gate_net:
                gc_x = cur_x + de + l / 2
                gc_y = gate_y - (w + 2 * r['poly_endcap']) / 2 - r['gate_contact_space'] - r['contact_size'] / 2
                # ensure gate contact does not touch diff: polycontact_diff_space = 0.17
                # place contact on poly extension beyond diff
                self.contact(gc_x, gc_y)
                self.pin_m1(gate_net, gc_x, gc_y)
            cur_x = d_x2 + r['diff_space']

    def resistor_poly(self, x, y, w, l):
        """
        Uns salicided poly resistor.
        Body: poly strip w x l.
        Markers: res_mk on body, sab around body, pplus covers ends.
        Contacts at ends with head_space.
        """
        r = TECH['rules']
        # poly body
        self.poly(x, y - w/2, x + l, y + w/2)
        # res_mk same size
        self.res_mk(x, y - w/2, x + l, y + w/2)
        # sab larger by marker_enc
        enc = r['res_marker_enc']
        self.sab(x - enc, y - w/2 - enc, x + l + enc, y + w/2 + enc)
        # pplus covers ends by pplus_cover
        cover = r['res_pplus_cover']
        self.pplus(x - cover, y - w/2 - r['pplus_enc_diff'],
                   x, y + w/2 + r['pplus_enc_diff'])
        self.pplus(x + l, y - w/2 - r['pplus_enc_diff'],
                   x + l + cover, y + w/2 + r['pplus_enc_diff'])
        # contacts at ends, head_space from poly end
        hs = r['res_head_space']
        c_size = r['contact_size']
        # left contact
        lx = x + hs + c_size/2
        self.contact(lx, y)
        self.pin_m1('RES_LEFT', lx, y)
        # right contact
        rx = x + l - hs - c_size/2
        self.contact(rx, y)
        self.pin_m1('RES_RIGHT', rx, y)

    def cap_mim(self, x, y, w, l):
        """
        MIM capacitor between m4 (bottom) and m5 (top) with capm dielectric.
        """
        r = TECH['rules']
        enc = r['cap_bottom_enc']
        # bottom plate m4
        self.m4(x, y - w/2, x + l, y + w/2)
        # dielectric capm larger than m4 by enc
        self.capm(x - enc, y - w/2 - enc, x + l + enc, y + w/2 + enc)
        # top plate m5 same size as m4
        self.m5(x, y - w/2, x + l, y + w/2)
        # cap_mk marker on capm, smaller by marker_enc
        mk_enc = r['cap_marker_enc']
        self.box('cap_mk', x + mk_enc, y - w/2 + mk_enc,
                 x + l - mk_enc, y + w/2 - mk_enc)
        # via4 connections: one on bottom plate, one on top plate
        via_size = r['via1_size']
        # bottom via (m4 to capm? actually via4 between m4 and m5)
        # place via4 near left side on m4
        vx1 = x + via_size/2 + 0.2
        vy1 = y - w/2 + via_size/2 + 0.2
        self.via4(vx1, vy1, size=via_size)
        self.pin_m1('CAP_BOTTOM', vx1, vy1)
        # top via near right side on m5
        vx2 = x + l - via_size/2 - 0.2
        vy2 = y + w/2 - via_size/2 - 0.2
        self.via4(vx2, vy2, size=via_size)
        self.pin_m1('CAP_TOP', vx2, vy2)

    # -- routing helpers -------------------------------------------------
    def route_m1_h(self, y, x1, x2, net=None):
        self.m1(x1, y - TECH['rules']['m1_w']/2, x2, y + TECH['rules']['m1_w']/2)
        if net:
            self.pin_m1(net, (x1+x2)/2, y)

    def route_m1_v(self, x, y1, y2, net=None):
        self.m1(x - TECH['rules']['m1_w']/2, y1, x + TECH['rules']['m1_w']/2, y2)
        if net:
            self.pin_m1(net, x, (y1+y2)/2)

    def route_m2_h(self, y, x1, x2, net=None):
        self.m2(x1, y - TECH['rules']['m1_w']/2, x2, y + TECH['rules']['m1_w']/2)
        if net:
            self.pin_m1(net, (x1+x2)/2, y)

    def route_m2_v(self, x, y1, y2, net=None):
        self.m2(x - TECH['rules']['m1_w']/2, y1, x + TECH['rules']['m1_w']/2, y2)
        if net:
            self.pin_m1(net, x, (y1+y2)/2)

    def write(self, filename):
        self.ly.write(filename)

# ----------------------------------------------------------------------
# Build ota_miller for gf180mcuD
# ----------------------------------------------------------------------
def build_ota_miller():
    r = TECH['rules']
    b = LayoutBuilder('ota_miller')

    # Placement parameters (um)
    # We place devices in two rows: PMOS on top, NMOS on bottom.
    # Global rails: VDD at top, VSS at bottom, running in m2.
    VDD_Y = 20.0
    VSS_Y = 1.0
    IB_Y = 10.0

    # ---------- PMOS row (nwell) ----------
    # nwell encloses all PMOS diffs
    nwell_x1 = -2.0
    nwell_y1 = 12.0
    nwell_x2 = 70.0
    nwell_y2 = 19.0
    b.nwell(nwell_x1, nwell_y1, nwell_x2, nwell_y2)

    # M3: diode-connected PMOS load, 2 fingers, w=4, l=1
    # gate=drain=d1, source=VDD
    b.mos('pmos', x=0.0, y=15.5, w=4.0, l=1.0, fingers=2,
          gate_net='d1', source_net='VDD', drain_net='d1',
          implant='pplus')
    # M4: PMOS load, 2 fingers, w=4, l=1
    # gate=d1, source=VDD, drain=d2
    b.mos('pmos', x=12.0, y=15.5, w=4.0, l=1.0, fingers=2,
          gate_net='d1', source_net='VDD', drain_net='d2',
          implant='pplus')
    # M6: second stage PMOS, 8 fingers, w=4, l=0.5
    # gate=d2, source=VDD, drain=OUT
    b.mos('pmos', x=24.0, y=15.5, w=4.0, l=0.5, fingers=8,
          gate_net='d2', source_net='VDD', drain_net='OUT',
          implant='pplus')

    # ---------- NMOS row ----------
    # M1: NMOS diff pair, 2 fingers, w=4, l=0.5
    # gate=INN, source=tail, drain=d1
    b.mos('nmos', x=0.0, y=4.5, w=4.0, l=0.5, fingers=2,
          gate_net='INN', source_net='tail', drain_net='d1',
          implant='nplus')
    # M2: NMOS diff pair, 2 fingers, w=4, l=0.5
    # gate=INP, source=tail, drain=d2
    b.mos('nmos', x=12.0, y=4.5, w=4.0, l=0.5, fingers=2,
          gate_net='INP', source_net='tail', drain_net='d2',
          implant='nplus')
    # M5: tail current source, 4 fingers, w=2, l=1
    # gate=IB, source=VSS, drain=tail
    b.mos('nmos', x=24.0, y=4.5, w=2.0, l=1.0, fingers=4,
          gate_net='IB', source_net='VSS', drain_net='tail',
          implant='nplus')
    # M7: sink for second stage, 8 fingers, w=2, l=1
    # gate=IB, source=VSS, drain=OUT
    b.mos('nmos', x=36.0, y=4.5, w=2.0, l=1.0, fingers=8,
          gate_net='IB', source_net='VSS', drain_net='OUT',
          implant='nplus')
    # M8: bias diode, 2 fingers, w=2, l=1
    # gate=drain=IB, source=VSS
    b.mos('nmos', x=48.0, y=4.5, w=2.0, l=1.0, fingers=2,
          gate_net='IB', source_net='VSS', drain_net='IB',
          implant='nplus')

    # ---------- Resistor RZ ----------
    # poly resistor between d2 and x, w=1, l=8
    b.resistor_poly(x=56.0, y=10.0, w=1.0, l=8.0)
    # connect left side to d2, right side to x
    # we already placed pins RES_LEFT and RES_RIGHT on m1 contacts.
    # route them with m1 to d2 and x nets.
    # For simplicity, we label the contacts as d2 and x.
    # Overwrite labels: left contact -> d2, right contact -> x
    # (the pins were placed inside resistor_poly; we add new labels here)
    b.pin_m1('d2', 56.0 + 0.22/2 + 0.22, 10.0)   # approximate left contact
    b.pin_m1('x', 56.0 + 8.0 - 0.22/2 - 0.22, 10.0)  # approximate right contact

    # ---------- MIM Capacitor CC ----------
    # cap between x and OUT, 20 x 20
    b.cap_mim(x=66.0, y=10.0, w=20.0, l=20.0)
    # pins CAP_BOTTOM and CAP_TOP placed inside; connect to x and OUT
    b.pin_m1('x', 66.0 + 0.26/2 + 0.2, 10.0 - 10.0 + 0.26/2 + 0.2)
    b.pin_m1('OUT', 66.0 + 20.0 - 0.26/2 - 0.2, 10.0 + 10.0 - 0.26/2 - 0.2)

    # ---------- Global rails ----------
    # VDD rail: m2 horizontal at top
    b.route_m2_h(VDD_Y, -2.0, 100.0, net='VDD')
    # VSS rail: m2 horizontal at bottom
    b.route_m2_h(VSS_Y, -2.0, 100.0, net='VSS')
    # IB rail: m2 horizontal through middle
    b.route_m2_h(IB_Y, -2.0, 100.0, net='IB')

    # Connect VDD rail to PMOS sources (already labeled VDD on contacts)
    # Connect VSS rail to NMOS sources (already labeled VSS on contacts)
    # Connect IB rail to gates (already labeled IB on contacts)

    # ---------- Input pins ----------
    b.pin_m1('INP', 12.0 + 0.5/2 + 0.23/2, 4.5 - (4.0 + 2*0.22)/2 - 0.15 - 0.22/2)
    b.pin_m1('INN', 0.0 + 0.5/2 + 0.23/2, 4.5 - (4.0 + 2*0.22)/2 - 0.15 - 0.22/2)

    # ---------- Output pin ----------
    b.pin_m1('OUT', 24.0 + 0.5/2 + 0.23/2 + 8*(0.5+0.28), 15.5 + (4.0 + 2*0.22)/2 + 0.15 + 0.22/2)

    # ---------- Supply pins ----------
    b.pin_m1('VDD', 90.0, VDD_Y)
    b.pin_m1('VSS', 90.0, VSS_Y)

    # ------------------------------------------------------------------
    # Finalize: write GDS
    # ------------------------------------------------------------------
    b.write('ota_miller.gds')

if __name__ == '__main__':
    build_ota_miller()