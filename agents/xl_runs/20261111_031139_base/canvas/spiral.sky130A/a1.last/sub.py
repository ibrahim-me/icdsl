from icdsl.canvas import *

tech = use()
stack = tech.stack
top_metal = stack[-1]
bot_metal = stack[-2]

w = 4.0                     # trace width everywhere (>= 4.0 um)
pitch = 6.0                 # centre-line pitch between turns (edge spacing >= 2 um)

c = Cell("spiral")

# ---- octagonal spiral centreline on top metal (3 full turns) ----
pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
L, g = 6.0, 3.0             # straight length and 45-deg projection, turn 1
for turn in range(3):
    for dx, dy in [(L, 0), (g, g), (0, L), (-g, g), (-L, 0), (-g, -g), (0, -L), (g, -g)]:
        x += dx; y += dy
        pts.append((x, y))
    L += 12.0               # each turn grows by 2*pitch in x and y

spiral = c.path(top_metal, pts, width=w, net="L")
c.label("L", top_metal, at=spiral)          # outer end is the top-metal port

# ---- inner end: via down to metal below, underpass to outside the coil ----
ix, iy = pts[0]
v = c.via(top_metal, bot_metal, at=(ix, iy), net="L", dir="h")
ux = spiral.right + 2.0                       # outside the coil on the right
under = c.rect(bot_metal, x0=ix, x1=ux, y0=iy - w/2, y1=iy + w/2, net="L")
c.port("L", on=under, dir="out")

TOP = c
