from icdsl.canvas import *

tech = use()
assert tech.name == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4
top_m = tech.stack[-1]
assert "cap_mim" in tech.d["devices"], "gf180mcuD must have cap_mim"

# ------------------------------------------------------------------ array
CAP = 5.0          # unit cap: 5 x 5 um  (cap_mim wmin=5)
PX, PY = 8.6, 9.6  # x/y pitch (leaves routing channels)
COLS, ROWS = 8, 8
assert COLS * ROWS == 64

counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
net_list = []
while any(counts.values()):
    for n in order:
        if counts[n] > 0:
            net_list.append(n)
            counts[n] -= 1
assert len(net_list) == 64

c = Cell("cdac6")
caps = []
for r in range(ROWS):
    for col in range(COLS):
        k = c.capacitor("cap_mim", w=CAP, h=CAP,
                        at=(col * PX, r * PY),
                        nets=("TOP", net_list[r * COLS + col]))
        caps.append(k)

# ------------------------------------------------------------------ TOP rail (all top plates)
# one m1 rail per row at the top-pad y, plus a vertical m1 bus to the right of the array
array_right = COLS * PX
bus_x = array_right + 1.2
rail_y = {}
for r in range(ROWS):
    row = caps[r * COLS:(r + 1) * COLS]
    ys = [t.top_pad.cy for t in row]
    assert max(ys) - min(ys) < 0.01
    y = ys[0]
    x0 = min(t.top_pad.left for t in row) - 0.2
    x1 = bus_x + 0.3
    c.rect(c0, x0=x0, x1=x1, y0=y - 0.12, y1=y + 0.12, net="TOP")
    rail_y[r] = y
c.rect(c0, x0=bus_x - 0.3, x1=bus_x + 0.3,
       y0=min(rail_y.values()) - 1.0, y1=max(rail_y.values()) + 1.0, net="TOP")
c.port("TOP", on=c.rect(c0, x0=bus_x, x1=bus_x + 2.6,
                        y0=(min(rail_y.values()) + max(rail_y.values())) / 2 - 1.4,
                        y1=(min(rail_y.values()) + max(rail_y.values())) / 2 + 1.4,
                        net="TOP"))

# ------------------------------------------------------------------ bottom plates -> router on c2/c3
rtr = Router(c, v=c3, h=c2, pin_layer=c2, via_top_dir="v")
for net in ("B5", "B4", "B3", "B2", "B1", "B0", "VSS"):
    pads = [t.b for t, n in zip(caps, net_list) if n == net]
    pins = []
    for p in pads:
        pins.append(c.rect(c2, x0=p.left - 0.35, x1=p.right + 0.35,
                           y0=p.bottom - 0.35, y1=p.top + 0.35, net=net))
        c.via(c0, c2, at=p.bbox, net=net, dir="h")
    rtr.add(net, *pins)

# bit buses on c3 to the right of the array, ports on c3
bus_y = {}
for net in ("B5", "B4", "B3", "B2", "B1", "B0", "VSS"):
    bus_y[net] = -1.0  # placeholder, set below
# place buses stacked vertically below the array
by = -2.6
for net in ("B0", "B1", "B2", "B3", "B4", "B5", "VSS"):
    c.rect(c3, x0=0.0, x1=array_right + 3.0, y0=by, y1=by + 1.6, net=net)
    bus_y[net] = by + 0.8
    by += 2.2

# connect router results to the bit buses
done = rtr.run()
for net, shape in done.items():
    # route from the router shape up to the c3 bit bus (vertical c2 segment + via)
    sx, sy = shape.cx, shape.cy
    ty = bus_y[net]
    c.wire(c2, [(sx, sy), (sx, ty)], net=net, width=0.6, first="v")
    c.via(c2, c3, at=(sx, ty), net=net, dir="v")
    c.port(net, on=c.rect(c3, x0=sx - 1.0, x1=sx + 1.0,
                          y0=ty - 0.85, y1=ty + 0.85, net=net))

TOP = c
