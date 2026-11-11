from icdsl.canvas import *

tech = use()
c0 = tech.c0
top_metal = tech.stack[-1]
under_metal = tech.stack[-2]

w = 4.0
g = 4.0
p = w + g
n_turns = 3.0
n_seg = int(8 * n_turns)   # 24 segments = 3 full turns

SQRT2 = 2.0 ** 0.5
C = 1.0 / SQRT2
dirs = [(1, 0), (C, C), (0, 1), (-C, C), (-1, 0), (-C, -C), (0, -1), (C, -C)]

# segment lengths: square-spiral-like growth, non-decreasing, constant pitch p
lengths = []
for k in range(n_seg):
    pair = k // 2
    lengths.append(p * (0.5 + 0.5 * pair))

pts = [(0.0, 0.0)]
for k in range(n_seg):
    dx, dy = dirs[k % 8]
    x, y = pts[-1]
    lengths_k = lengths[k]
    pts.append((x + lengths_k * dx, y + lengths_k * dy))

# center the spiral on the origin
xs = [q[0] for q in pts]; ys = [q[1] for q in pts]
cx = (min(xs) + max(xs)) / 2.0
cy = (min(ys) + max(ys)) / 2.0
pts = [(x - cx, y - cy) for x, y in pts]

inner = pts[0]
outer_end = pts[-1]

c = Cell("spiral")

# spiral on top metal, one net "L"
sp = c.path(top_metal, pts, w, net="L", first="round", last="round")

# inner end: via down to under_metal, underpass out to +x, via back up, stub
v_in = c.via(under_metal, top_metal, at=inner, net="L")

under_len = 30.0
under_y = inner[1]
under_x0 = inner[0]
under_x1 = inner[0] + under_len
up = c.rect(under_metal, x0=under_x0, x1=under_x1,
            y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

v_out = c.via(under_metal, top_metal, at=(under_x1, under_y), net="L")

stub = c.rect(top_metal, x0=under_x1, x1=under_x1 + w,
              y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

c.port("L", on=sp, dir="in")
c.port("L", on=stub, dir="out")

TOP = c
