```
from icdsl.canvas import *

tech = use()
assert tech.name == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4
assert "cap_mim" in tech.d["devices"], "gf180mcuD must have cap_mim"

# ------------------------------------------------------------------ array
CAP = 5.0          # unit cap: 5 x 5 um  (cap_mim wmin=5 on gf180mcuD)
PX, PY = 10.0, 10.0
COLS, ROWS = 8, 8
assert COLS * ROWS == 64

counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
# dedicate whole rows to one bit (fewest routing crossings); last row is mixed
net_list = []
for n, cnt in counts.items():
    full = cnt // COLS
    net_list += [n] * (full * COLS)
    rem = cnt % COLS
    if rem:
        net_list += [n] * rem
# pad the final mixed row to 8 with the remaining nets in order
while len(net_list) < 64:
    for n in ("B2", "B1", "B0", "VSS"):
        if net_list.count(n) < counts[n]:
            net_list.append(n)
            break
assert len(net_list) == 64
for n in counts:
    assert net_list.count(n) == counts[n], (n, net_list.count(n), counts[n])

c = Cell("cdac6")
caps = []
for r in range(ROWS):
    for col in range(COLS):
        k = c.capacitor("cap_mim", w=CAP, h=CAP,
                        at=(col * PX, r * PY),
                        nets=("TOP", net_list[r * COLS + col]))
        caps.append(k)

array_right = COLS * PX          # 80
array_top = ROWS * PY            # 80

# ------------------------------------------------------------------ TOP rail on c4 (m5): top plates sit on m5
for r in range(ROWS):
    row = caps[r * COLS:(r + 1) * COLS]
    y = row[0].top_pad.cy
    x0 = min(t.top_pad.left for t in row) - 0.2
    x1 = array_right + 3.0
    c.rect(c4, x0=x0, x1=x1, y0=y - 0.25, y1=y + 0.25, net="TOP")
# vertical c4 bus collecting all rows
c.rect(c4, x0=array_right + 2.4, x1=array_right + 3.0,
       y0=0.0, y1=array_top, net="TOP")
c.port("TOP", on=c.rect(c4, x0=array_right + 2.4, x1=array_right + 5.6,
                        y0=array_top / 2 - 1.6, y1=array_top / 2 + 1.6,
                        net="TOP"))

# ------------------------------------------------------------------ bottom plates on c2 (m3): route under the MIM, no plate conflict
# vertical bit buses on c1 (m2) at the right of the array; row buses on c2 tap them via via2
BUS_X0 = array_right + 1.6
BUS_X1 = BUS_X0 + 1.0
bus_y = {}
by = -2.6
for net in ("B0", "B1", "B2", "B3", "B4", "B5", "VSS"):
    c.rect(c1, x0=BUS_X0, x1=BUS_X1, y0=by, y1=by + 1.6, net=net)
    bus_y[net] = by + 0.8
    by += 2.2

# row bottom buses on c2 (one per row), each going to its bit's c1 bus via via2
for r in range(ROWS):
    row = caps[r * COLS:(r + 1) * COLS]
    nets_in_row = [net_list[r * COLS + col] for col in range(COLS)]
    y = row[0].b.cy
    # group contiguous caps of the same net into one c2 segment
    x0 = None
    cur = None
    for col in range(COLS + 1):
        net = nets_in_row[col] if col < COLS else None
        if net != cur:
            if cur is not None:
                seg = c.rect(c2, x0=x0, x1=caps[r * COLS + col - 1].b.right + 0.2,
                             y0=y - 0.25, y1=y + 0.25, net=cur)
                # tap to the c1 bit bus
                c.via(c1, c2, at=(BUS_X0 + 0.5, y), net=cur, dir="h")
                c.wire(c2, [seg, (BUS_X0 + 0.5, y)], net=cur, width=0.6)
            cur = net
            x0 = caps[r * COLS + col].b.left - 0.2 if col < COLS else None

# ports on the c1 bit buses
for net in ("B5", "B4", "B3", "B2", "B1", "B0", "VSS"):
    c.port(net, on=c.rect(c1, x0=BUS_X0 - 0.4, x1=BUS_X1 + 0.4,
                          y0=bus_y[net] - 0.85, y1=bus_y[net] + 0.85,
                          net=net))

TOP = c

```