from icdsl.canvas import *

tech = use()
c0 = tech.c0          # first conductor (device/contact layer)
top = tech.stack[-1]  # top metal
below = tech.stack[-2]  # metal below top
# via between below and top
via_stack = (below, top)

W = 4.0          # trace width (>= 4.0 um)
GAP = 8.0        # gap between turns (well above min space on all PDKs)
PITCH = W + GAP  # center-to-center pitch = 12 um
SQRT2 = 2.0 ** 0.5

# ---------- build octagonal spiral centerline ----------
# Directions cycle E, NE, N, NW, W, SW, S, SE (CCW outward spiral).
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

def spiral_points(n_turns=3, lead=20.0):
    """Centerline points of an octagonal spiral with constant pitch PITCH.
    Starts at the inner end (lead going East), spirals outward CCW."""
    pts = [(0.0, 0.0)]
    x, y = 0.0, 0.0
    # inner lead
    x += lead
    pts.append((x, y))
    # segment lengths grow so each full loop is offset by one PITCH outward.
    # straight length for loop r: A_r = A0 + r*2*PITCH ; diagonal extent g_r = g0 + r*2*PITCH/sqrt(2)
    A0 = lead + 2 * PITCH
    g0 = PITCH  # diagonal x/y extent
    n_seg = 8 * n_turns
    for i in range(n_seg):
        r = i // 8
        d = i % 8
        dx, dy = DIRS[d]
        if dx and dy:          # diagonal
            length = (g0 + r * 2 * PITCH) * SQRT2
        else:                  # straight
            length = A0 + r * 2 * PITCH
        x += dx * length
        y += dy * length
        pts.append((x, y))
    return pts

pts = spiral_points(3)
