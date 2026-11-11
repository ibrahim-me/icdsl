"""6-bit binary-weighted capacitor array (charge-redistribution DAC core): 64 unit MIM capacitors,
8 x 8, common top plate TOP; bottom plates B5 (32 units) ... B0 (1 unit) + one unit to VSS."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
rec = tech.device("cap_mim")
bot, topm = rec["bottom"], rec["top"]
i = tech.stack.index(bot)
v, h = tech.stack[i - 1], tech.stack[i - 2]          # route under the bottom plates
U, GAP = 5.0, 3.0
PITCH = U + 2 * rec["bottom_enc"] + GAP
top = Cell("cdac6")
r = Router(top, v=v, h=h, pin_layer=bot)


def net_of(k):                                         # interleaved: every other unit is B5, every 4th B4, ...
    if k == 0:
        return "VSS"
    tz = (k & -k).bit_length() - 1
    return f"B{5 - tz}"


rows_ = []
for k in range(64):
    row, col = divmod(k, 8)
    u = top.capacitor("cap_mim", w=U, h=U, at=(col * PITCH, row * PITCH), nets=("TOP", net_of(k)), name=f"C{k}")
    bp = u.bottom_plate
    tab = top.rect(bot, x0=bp.left, x1=bp.left + 1.6, y0=bp.bottom - 1.0, y1=bp.bottom, net=net_of(k))
    r.add(net_of(k), tab, group=row)
    if col == 0:
        rows_.append([])
    rows_[-1].append(u)
# top plates: one bar of top metal along every row, joined by a bar on the left
wb = min(2.0, rows_[0][0].top_pad.h)
xb = rows_[0][0].bottom_plate.left - GAP
for us in rows_:
    top.rect(topm, x0=xb, x1=us[-1].top_pad.right, y0=us[0].top_pad.cy - wb / 2, y1=us[0].top_pad.cy + wb / 2, net="TOP")
bar = top.rect(topm, x0=xb, x1=xb + wb, y0=rows_[0][0].top_pad.cy - wb / 2, y1=rows_[-1][0].top_pad.cy + wb / 2, net="TOP")
top.port("TOP", on=bar)
for net, shape in r.run().items():
    top.port(net, on=shape)
TOP = top
