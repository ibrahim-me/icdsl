import klayout.db as kdb
DBU = 0.001
def R(v): return int(round(v / DBU))
LAY = {
 'nwell': (64,20), 'diff': (65,20), 'tap': (65,44), 'poly': (66,20), 'licon': (66,44),
 'npc': (95,20), 'nsdm': (93,44), 'psdm': (94,20), 'li': (67,20), 'mcon': (67,44),
 'met1': (68,20), 'via': (68,44), 'met2': (69,20),
 'li_t': (67,5), 'met1_t': (68,5), 'met1_p': (68,16), 'li_p': (67,16),
}
class Cell:
    def __init__(self, name, lib):
        self.c = lib.create_cell(name)
        self.lib = lib
    def box(self, layer, x0, y0, x1, y1):
        l = self.lib.layer(*LAY[layer])
        self.c.shapes(l).insert(kdb.Box(R(x0), R(y0), R(x1), R(y1)))
    def text(self, layer, s, x, y):
        l = self.lib.layer(*LAY[layer])
        self.c.shapes(l).insert(kdb.Text(s, kdb.Trans(R(x), R(y))))

W = 8.28  # 18 x 0.46 um
H = 2.72

def build_frame(cell):
    # rails: met1 VGND centred y=0, VPWR centred y=H (width 0.34)
    cell.box('met1', 0, -0.17, W, 0.17); cell.text('met1_t', 'VGND', 0.2, 0)
    cell.box('met1', 0, H - 0.17, W, H + 0.17); cell.text('met1_t', 'VPWR', 0.2, H)
    # n-well over upper half, from y=1.36 to top of cell, extended on top to rail edge
    cell.box('nwell', 0, 1.36, W, H + 0.17)
    # p-tap strip under VGND (bottom edge), n-tap strip under VPWR (top area)
    cell.box('tap', 0.1, 0.0, W - 0.1, 0.15); cell.box('psdm', 0.0, -0.125, W, 0.275)
    cell.box('tap', 0.1, H - 0.15, W - 0.1, H); cell.box('nsdm', 0.0, H - 0.275, W, H + 0.125)
