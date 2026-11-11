"""spiral: 3.5-turn octagonal spiral inductor on the top metal with an underpass on the metal below.
Non-Manhattan geometry; nothing here is PDK specific."""
from icdsl.canvas import *

tech = use()
top_m, under = tech.stack[-1], tech.stack[-2]
W, S, TURNS, A0 = 4.0, 2.4, 3, 12.0            # trace width, turn spacing, full turns, inner apothem (um)
P = W + S
T = 0.41421356                                  # tan(22.5 deg): half side of an octagon / apothem
h = lambda a: tech.snap(a * T)

c = Cell("spiral")
X0 = -1.0                                       # inner end (kept clear of the first turn's exit diagonal)
pts = [(X0, -A0)]
for k in range(TURNS):
    a, a2 = A0 + k * P, A0 + (k + 1) * P
    pts += [(h(a), -a), (a, -h(a)), (a, h(a)), (h(a), a), (-h(a), a), (-a, h(a)),
            (-a, -(P + h(a2))), (-h(a2), -a2)]
aN = A0 + TURNS * P
x_in = X0 + W / 2                                # centre of the inner end pad
x_out = x_in + 2 * W + S                        # outer lead, next to the underpass
y_end = -(aN + 2 * W)
pts += [(h(aN), -aN), (aN, -h(aN)), (aN, h(aN)), (h(aN), aN), (-h(aN), aN), (-aN, h(aN))]    # the extra half turn
aE = aN + P
pts += [(-aN, -(P + h(aE))), (-h(aE), -aE), (x_out, -aE), (x_out, y_end - P)]
coil = c.path(top_m, pts, W, net="L")

v = c.via(under, top_m, at=(x_in, -A0), nx=2, ny=2, net="L")       # inner end -> underpass
c.rect(under, x0=x_in - W / 2, x1=x_in + W / 2, y0=y_end - P, y1=-A0 + W / 2, net="L")
c.port("L", on=c.rect(top_m, x0=x_out - W / 2, x1=x_out + W / 2, y0=y_end - P, y1=y_end - P + W, net="L"))
TOP = c
