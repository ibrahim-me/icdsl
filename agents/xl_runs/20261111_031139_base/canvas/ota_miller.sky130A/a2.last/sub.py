from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")
sp = 0.6

def strap(*objs, net):
    return c.rect(c0, x0=min(o.left for o in objs), x1=max(o.right for o in objs),
                  y0=min(o.bottom for o in objs), y1=max(o.top for o in objs), net=net)

# ---------------- devices (placed in dependency order) ----------------
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL", "D1"), at=(0, 0))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL", "D2"),
           at=(M1.diff.right + sp, M1.diff.bottom))
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "TAIL"),
           at=(M1.diff.left, M1.diff.bottom - 1.2 - M5.diff.h if False else M1.diff.bottom - 1.2 - 0))
# M5 height unknown until created; create at (0,0) then reposition is not supported, so create with a temp at then we read size
