from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal (m5 on gf180)
bot = tech.stack[-2]          # metal below top (m4 on gf180) -> underpass layer

W = 4.0                       # trace width (>= 4.0 um everywhere)
P = 8.0                       # centre-to-centre pitch between turns (edge gap = W)
SQRT2 = 2.0 ** 0.5
C4 = 4.0 / SQRT2              # 45-degree segment: dx=dy=2.828, length=4.0

# ---- octagonal spiral centreline: 3 full turns (24 segments) ----
# directions: E, NE, N, NW, W, SW, S, SE  (repeating)
# cardinal lengths grow by 2*P = 16 um per turn; 45-degree segments are 4 um chamfers
pts = [(-3.0, 0.0)]           # start a little before the via so the via is enclosed
x, y = -3.0, 0.0

def seg(dx, dy):
    global x, y
    x += dx; y += dy
    pts.append((x, y))

# turn 1
seg(9.0, 0.0); seg(C4, C4); seg(0.0, 14.0); seg(-C4, C4)
seg(-22.0, 0.0); seg(-C4, -C4); seg(0.0, -22.0); seg(C4, -C4)
# turn 2
seg(25.0, 0.0); seg(C4, C4); seg(0.0, 30.0); seg(-C4, C4)
seg(-38.0, 0.0); seg(-C4, -C4); seg(0.0, -38.0); seg(C4, -C4)
# turn 3
seg(41.0, 0.0); seg(C4, C4); seg(0.0, 46.0); seg(-C4, C4)
seg(-54.0, 0.0); seg(-C4, -C4); seg(0.0, -54.0); seg(C4, -C4)

c = Cell("spiral")

def add_seg(p0, p1, net="L"):
    """Draw one segment (Manhattan or 45 deg) with width W, overlapping neighbours."""
    x0, y0 = p0; x1, y1 = p1
    dx = x1 - x0; dy = y1 - y0
    if abs(dx) < 1e-9 or abs(dy) < 1e-9:          # Manhattan
        c.rect(top, x0=min(x0, x1) - W / 2, x1=max(x0, x1) + W / 2,
               y0=min(y0, y1) - W / 2, y1=max(y0, y1) + W / 2, net=net)
    else:                                          # 45-degree parallelogram
        sx = 1.0 if dx > 0 else -1.0
        sy = 1.0 if dy > 0 else -1.0
        px = -sy * SQRT2 / 2; py = sx * SQRT2 / 2   # unit perpendicular
        c.polygon(top, [
            (x0 + px * W / 2, y0 + py * W / 2),
            (x0 - px * W / 2, y0 - py * W / 2),
            (x1 - px * W / 2, y1 - py * W / 2),
            (x1 + px * W / 2, y1 + py * W / 2),
        ], net=net)

for i in range(len(pts) - 1):
    add_seg(pts[i], pts[i + 1])

# ---- inner end: via down at (0,0) on the first segment, then underpass out ----
v = c.via(bot, top, at=(0.0, 0.0), net="L")        # via pad sits inside the first segment

minx = min(p[0] for p in pts)
ux = minx - 2.0                                    # underpass end outside the coil
up = c.rect(bot, x0=ux, x1=v.lower.right,
            y0=v.lower.bottom - W / 2, y1=v.lower.top + W / 2, net="L")

# ---- ports: outer end of the coil, and the underpass end outside the coil ----
end = c.rect(top, x0=pts[-1][0] - W / 2, x1=pts[-1][0] + W / 2,
             y0=pts[-1][1] - W / 2, y1=pts[-1][1] + W / 2, net="L")
c.port("L", on=end, dir="out")
c.port("L", on=up, dir="out")

TOP = c


