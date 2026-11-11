```python
from icdsl.canvas import *
tech = use()
c0 = tech.c0
stack = tech.stack
top_m = stack[-1]

# ---------- read the netlist (same file for every PDK) ----------
netlist = open("netlist.spice").read()

# unit MIM capacitor size from the PDK recipe
cap_recipe = tech.d["devices"]["cap_mim"]
size = max(float(cap_recipe.get("wmin", 5.0)), float(cap_recipe.get("lmin", 5.0)))
pitch = size + 1.0          # >= cap space rule on every PDK
cols, rows = 8, 8

# bit weights, MSB .. LSB, then the spare unit to VSS
weights = [("B5", 32), ("B4", 16), ("B3", 8), ("B2", 4), ("B1", 2), ("B0", 1), ("VSS", 1)]
bit_of = {}
idx = 0
for name, n in weights:
    for _ in range(n):
        bit_of[idx] = name
        idx += 1
assert idx == 64

c = Cell("cdac6")
caps = []
for r in range(rows):
    for col in range(cols):
        net = "TOP" if False else bit_of[r * cols + col]
        cc = c.capacitor("cap_mim", w=size, h=size,
                         at=(col * pitch, r * pitch), nets=("TOP", net))
        caps.append(cc)

array_left = 0.0
array_right = cols * pitch
array_bottom = 0.0
array_top = rows * pitch

# ---------- top plates: all tied to TOP ----------
# one bar per row on the top-plate layer, then a vertical bus
tplayer = caps[0].top_pad.layer
for r in range(rows):
    y = r * pitch + size / 2
    c.rect(tplayer, x0=array_left, x1=array_right,
           y0=y - size / 2, y1=y + size / 2, net="TOP")
vbus = c.rect(tplayer, x0=array_right, x1=array_right + 2.0,
              y0=array_bottom, y1=array_top, net="TOP")
c.port("TOP", on=vbus, dir="out")

# ---------- bottom plates: route every bit net ----------
# route layer = a conductor that is not a capacitor plate layer
bplayer = caps[0].bottom_pad.layer
route_layer = next(m for m in stack if m not in (tplayer, bplayer))

# row buses (rows 0..6 carry a single net each); row 7 is mixed -> per-cap verticals
row_bus = {}
for r in range(rows - 1):
    net = bit_of[r * cols]
    bus = c.rect(route_layer, x0=array_left, x1=array_right,
                 y0=r * pitch + size / 2 - 0.15,
                 y1=r * pitch + size / 2 + 0.15, net=net)
    row_bus[r] = bus
    for col in range(cols):
        cc = caps[r * cols + col]
        c.via(bplayer, route_layer, at=cc.bottom_pad.cx, cc.bottom_pad.cy if False else (cc.bottom_pad.cx, cc.bottom_pad.cy), net=net)

# row 7: one vertical track per column down to the bottom edge, then per-net trunks
trunk_y = array_bottom - 2.0
trunk_h = 0.9
trunk_gap = 0.6
trunk_y0 = trunk_y
col_trunks = {}
for col in range(cols):
    cc = caps[7 * cols + col]
    net = bit_of[56 + col]
    c.via(bplayer, route_layer, at=(cc.bottom_pad.cx, cc.bottom_pad.cy), net=net)
    seg = c.rect(route_layer, x0=cc.bottom_pad.cx - 0.15, x1=cc.bottom_pad.cx + 0.15,
                 y0=7 * pitch + size / 2 + 0.15, y1=trunk_y0 + trunk_h, net=net)
    col_trunks.setdefault(net, []).append(seg)

x_trunk = array_right + 2.0
for net, segs in col_trunks.items():
    x0 = min(s.left for s in segs) - 0.6
    x1 = max(s.right for s in segs) + 0.6
    trunk = c.rect(route_layer, x0=x0, x1=x1,
                   y0=trunk_y0, y1=trunk_y0 + trunk_h, net=net)
    port = c.rect(route_layer, x0=x_trunk, x1=x_trunk + 2.0,
                  y0=trunk_y0, y1=trunk_y0 + trunk_h, net=net)
    c.port(net, on=port, dir="out")
    x_trunk += 3.0

# tie row buses to their ports at the right edge
for r, bus in row_bus.items():
    net = bit_of[r * cols]
    port = c.rect(route_layer, x0=array_right, x1=array_right + 2.0,
                  y0=r * pitch + size / 2 - 0.15,
                  y1=r * pitch + size / 2 + 0.15, net=net)
    c.port(net, on=port, dir="out")

TOP = c
``````python
from icdsl.canvas import *
tech = use()
c0 = tech.c0
stack = tech.stack
top_m = stack[-1]

# ---------- read the task netlist (same file name for every PDK) ----------
netlist = open("netlist.spice").read()

# unit MIM capacitor size from the PDK recipe
cap_recipe = tech.d["devices"]["cap_mim"]
size = max(float(cap_recipe.get("wmin", 5.0)), float(cap_recipe.get("lmin", 5.0)))
pitch = size + 1.0          # >= cap space rule on every PDK
cols, rows = 8, 8

# bit weights, MSB .. LSB, then the spare unit to VSS (64 units total)
weights = [("B5", 32), ("B4", 16), ("B3", 8), ("B2", 4), ("B1", 2), ("B0", 1), ("VSS", 1)]
bit_of = {}
idx = 0
for name, n in weights:
    for _ in range(n):
        bit_of[idx] = name
        idx += 1
assert idx == 64

c = Cell("cdac6")
caps = []
for r in range(rows):
    for col in range(cols):
        net = bit_of[r * cols + col]
        cc = c.capacitor("cap_mim", w=size, h=size,
                         at=(col * pitch, r * pitch), nets=("TOP", net))
        caps.append(cc)

array_left = 0.0
array_right = cols * pitch
array_bottom = 0.0
array_top = rows * pitch

# ---------- top plates: all tied to TOP ----------
tplayer = caps[0].top_pad.layer
for r in range(rows):
    y = r * pitch + size / 2
    c.rect(tplayer, x0=array_left, x1=array_right,
           y0=y - size / 2, y1=y + size / 2, net="TOP")
vbus = c.rect(tplayer, x0=array_right, x1=array_right + 2.0,
              y0=array_bottom, y1=array_top, net="TOP")
c.port("TOP", on=vbus, dir="out")

# ---------- bottom plates: route every bit net ----------
bplayer = caps[0].bottom_pad.layer
route_layer = next(m for m in stack if m not in (tplayer, bplayer))

# rows 0..6 carry a single net each -> one row bus per row
for r in range(rows - 1):
    net = bit_of[r * cols]
    bus = c.rect(route_layer, x0=array_left, x1=array_right,
                 y0=r * pitch + size / 2 - 0.15,
                 y1=r * pitch + size / 2 + 0.15, net=net)
    c.port(net, on=c.rect(route_layer, x0=array_right, x1=array_right + 2.0,
                          y0=r * pitch + size / 2 - 0.15,
                          y1=r * pitch + size / 2 + 0.15, net=net), dir="out")
    for col in range(cols):
        cc = caps[r * cols + col]
        c.via(bplayer, route_layer, at=(cc.bottom_pad.cx, cc.bottom_pad.cy), net=net)

# row 7 is mixed -> one vertical track per column down to per-net trunks
trunk_y = array_bottom - 2.0
trunk_h = 0.9
x_trunk = array_right + 2.0
col_trunks = {}
for col in range(cols):
    cc = caps[7 * cols + col]
    net = bit_of[56 + col]
    c.via(bplayer, route_layer, at=(cc.bottom_pad.cx, cc.bottom_pad.cy), net=net)
    seg = c.rect(route_layer, x0=cc.bottom_pad.cx - 0.15, x1=cc.bottom_pad.cx + 0.15,
                 y0=7 * pitch + size / 2 + 0.15, y1=trunk_y + trunk_h, net=net)
    col_trunks.setdefault(net, []).append(seg)

for net, segs in col_trunks.items():
    x0 = min(s.left for s in segs) - 0.6
    x1 = max(s.right for s in segs) + 0.6
    c.rect(route_layer, x0=x0, x1=x1, y0=trunk_y, y1=trunk_y + trunk_h, net=net)
    port = c.rect(route_layer, x0=x_trunk, x1=x_trunk + 2.0,
                  y0=trunk_y, y1=trunk_y + trunk_h, net=net)
    c.port(net, on=port, dir="out")
    x_trunk += 3.0

TOP = c
```