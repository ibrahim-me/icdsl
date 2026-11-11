```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

# ---------------- devices ----------------
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL", "D1"), at=(0, 0))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL", "D2"), at=(0, 0))
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "TAIL"), at=(0, 0))
M8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS", "IB"), at=(0, 0))
M3 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D1"), at=(0, 0))
M4 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D2"), at=(0, 0))
M6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="D2", sd=("VDD", "OUT"), at=(0, 0))
M7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS", "OUT"), at=(0, 0))

if have_res:
    RZ = c.resistor("res_poly", w=1, l=8, at=(0, 0), nets=("D2", "X"), orient="v")
if have_mim:
    CC = c.capacitor("cap_mim", w=20, h=20, at=(0, 0), nets=("X", "OUT"))

# ---------------- floorplan ----------------
# column A: input pair M1/M2 ; column B: tail M5 ; column C: bias diode M8
# M1 left, M2 right (same row), sources -> TAIL rail between them and M5
M2.place_right_of(M1, space=0.6)
M5.place_below(M1, space=0.5, align="left")   # tail under M1
M8.place_right_of(M5, space=0.5)              # bias diode next to tail

# PMOS load row above the NMOS pair (n-well), sources to VDD rail
M3.place_above(M1, space=0.6, align="left")
M4.place_above(M2, space=0.6, align="left")

# second stage to the right: M6 (top), M7 (bottom)
M6.place_right_of(M4, space=1.0, align="top")
M7.place_below(M6, space=0.8, align="right")

# compensation network between D2 and OUT
if have_res:
    RZ.place_right_of(M6, space=0.8, align="top")
if have_mim:
    CC.place_below(RZ, space=0.4, align="right") if have_res else CC.place_right_of(M6, space=1.0, align="top")

# ---------------- power rails ----------------
vdd = c.rect(m2, x0=min(M3.well.left, M4.well.left, M6.well.left) - 0.2,
             x1=max(M3.well.right, M4.well.right, M6.well.right) + 0.2,
             y0=max(M3.top, M4.top, M6.top), y1=max(M3.top, M4.top, M6.top) + 0.8, net="VDD")
vss = c.rect(m2, x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.2,
             x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.2,
             y0=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom) - 0.8,
             y1=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom), net="VSS")

# ---------------- taps / guard rings ----------------
# n-taps in PMOS wells -> VDD ; p-taps in NMOS substrate -> VSS
for mos in (M3, M4, M6):
    if mos.well:
        c.tap("ntap", x0=mos.well.left - 0.1, y0=mos.well.bottom - 0.1,
              x1=mos.well.right + 0.1, y1=mos.well.top + 0.1, net="VDD")
c.tap("ptap", x0=M1.diff.left - 0.1, y0=M1.diff.bottom - 0.1,
      x1=max(M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y1=min(M1.diff.bottom, M2.diff.bottom, M5.diff.bottom, M7.diff.bottom, M8.diff.bottom) - 0.1, net="VSS")
c.tap("ptap", x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.1,
      y1=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top) + 0.1,
      x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y0=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top), net="VSS")

# ---------------- first stage routing ----------------
# TAIL rail: M1.sd[0], M2.sd[0] -> M5.drain
tail = c.rect(c0, x0=min(M1.sd[0].left, M2.sd[0].left, M5.sd[1].left),
              x1=max(M1.sd[0].right, M2.sd[0].right, M5.sd[1].right),
              y0=min(M1.sd[0].bottom, M2.sd[0].bottom, M5.sd[1].bottom),
              y1=max(M1.sd[0].top, M2.sd[0].top, M5.sd[1].top), net="TAIL")
# D1 = M1 drain = M3 drain = M3/M4 gate
d1 = c.rect(c0, x0=min(M1.sd[1].left, M3.sd[1].left, M3.gates[0].left, M4.gates[0].left),
            x1=max(M1.sd[1].right, M3.sd[1].right, M3.gates[0].right, M4.gates[0].right),
            y0=min(M1.sd[1].bottom, M3.sd[1].bottom, M3.gates[0].bottom, M4.gates[0].bottom),
            y1=max(M1.sd[1].top, M3.sd[1].top, M3.gates[0].top, M4.gates[0].top), net="D1")
# D2 = M2 drain = M4 drain = M6 gate
d2 = c.rect(c0, x0=min(M2.sd[1].left, M4.sd[1].left, M6.gates[0].left),
            x1=max(M2.sd[1].right, M4.sd[1].right, M6.gates[0].right),
            y0=min(M2.sd[1].bottom, M4.sd[1].bottom, M6.gates[0].bottom),
            y1=max(M2.sd[1].top, M4.sd[1].top, M6.gates[0].top), net="D2")

# gate inputs INN/INP (poly already at gates); bring to metal1 pins
for mos, pin in ((M1, "INN"), (M2, "INP")):
    g = mos.gates[0]
    c.rect(m1, x0=g.left - 0.2, x1=g.right + 0.2, y0=g.bottom - 0.1, y1=g.top + 0.1, net=pin)

# ---------------- second stage & compensation ----------------
# OUT = M6 drain = M7 drain
out = c.rect(c0, x0=min(M6.sd[1].left, M7.sd[1].left),
             x1=max(M6.sd[1].right, M7.sd[1].right),
             y0=min(M6.sd[1].bottom, M7.sd[1].bottom),
             y1=max(M6.sd[1].top, M7.sd[1].top), net="OUT")
if have_res:
    rz = c.rect(c0, x0=min(RZ.a.left, d2.left), x1=max(RZ.a.right, d2.right),
                y0=min(RZ.a.bottom, d2.bottom), y1=max(RZ.a.top, d2.top), net="D2")
    xnode = c.rect(c0, x0=min(RZ.b.left, CC.bottom_pad.left if have_mim else RZ.b.left),
                   x1=max(RZ.b.right, CC.bottom_pad.right if have_mim else RZ.b.right),
                   y0=min(RZ.b.bottom, CC.bottom_pad.bottom if have_mim else RZ.b.bottom),
                   y1=max(RZ.b.top, CC.bottom_pad.top if have_mim else RZ.b.top), net="X")
if have_mim and not have_res:
    xnode = c.rect(c0, x0=CC.bottom_pad.left, x1=CC.bottom_pad.right,
                   y0=CC.bottom_pad.bottom, y1=CC.bottom_pad.top, net="X")
    c.rect(c0, x0=d2.left, x1=CC.top_pad.left, y0=CC.top_pad.bottom, y1=CC.top_pad.top, net="D2")

# ---------------- router for long signals ----------------
r = Router(c)
r.auto()
try:
    h = r.run()
except Exception as e:
    # route critical nets by hand if router struggles
    pass

# ---------------- ports ----------------
c.port("INP", on=M2.gates[0], dir="in")
c.port("INN", on=M1.gates[0], dir="in")
c.port("OUT", on=out, dir="out")
c.port("IB", on=M8.sd[1], dir="in")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c
```

The script failed because I passed shell text. Let me rewrite cleanly as a proper Python script. I need to be careful about the API: `place_right_of` etc. may not exist on mos objects. Let me check the canvas API - mos objects have `.diff`, `.gates`, `.sd` etc. but placement helpers like `place_right_of` are on `Cell.rect` results (shapes), not necessarily on mos. Let me use absolute positioning via `at=` and relative via computing from shape attributes.

Let me rewrite using explicit coordinates computed from device shapes, using `c.rect` with `right_of=`, `above=` etc. which work on shapes. For mos, I'll position with `at=` and then use the shape attributes.

Actually, the `mos` returns an object with shape attributes. I can use `c.rect(..., right_of=M1.diff, ...)` since rect accepts shapes for relative placement. Let me restructure to place devices at absolute positions first (they're placed at `at=`), then I compute relative positions.

But `at=(0,0)` for all would overlap. I need to place them at different locations. The mos `at=` sets the origin. Let me place them sequentially using computed positions.

Let me rewrite more carefully, computing positions as I go. I'll place M1 at origin, then place others relative to it using the shape attributes and `c.rect` relative keywords won't help for mos placement. Instead I'll compute `at=` manually.

Let me write a cleaner version.```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

# ---------------- devices ----------------
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL", "D1"), at=(0, 0))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL", "D2"), at=(0, 0))
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "TAIL"), at=(0, 0))
M8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS", "IB"), at=(0, 0))
M3 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D1"), at=(0, 0))
M4 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D2"), at=(0, 0))
M6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="D2", sd=("VDD", "OUT"), at=(0, 0))
M7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS", "OUT"), at=(0, 0))

if have_res:
    RZ = c.resistor("res_poly", w=1, l=8, at=(0, 0), nets=("D2", "X"), orient="v")
if have_mim:
    CC = c.capacitor("cap_mim", w=20, h=20, at=(0, 0), nets=("X", "OUT"))

# ---------------- floorplan (absolute, using shape edges) ----------------
sp = 0.6
M2.at = (M1.diff.right + sp, M1.diff.bottom)          # M2 right of M1
M5.at = (M1.diff.left, M1.diff.bottom - 1.2 - M5.diff.h)   # tail below M1
M8.at = (M5.diff.right + sp, M5.diff.bottom)          # bias diode right of tail

M3.at = (M1.diff.left, M1.diff.top + sp)              # load above M1
M4.at = (M2.diff.left, M2.diff.top + sp)              # load above M2

M6.at = (M4.diff.right + 1.0, M4.diff.top - M6.diff.h)   # 2nd stage PMOS right of M4
M7.at = (M6.diff.right - M7.diff.w, M6.diff.bottom - 0.8 - M7.diff.h)  # sink below M6

if have_res:
    RZ.at = (M6.diff.right + 0.8, M6.diff.top - RZ.diff.h if hasattr(RZ, 'diff') else M6.diff.top)
if have_mim:
    CC.at = (M6.diff.right + 0.8, M6.diff.bottom - CC.h)

# ---------------- power rails ----------------
vdd = c.rect(m2,
    x0=min(M3.well.left, M4.well.left, M6.well.left) - 0.2,
    x1=max(M3.well.right, M4.well.right, M6.well.right) + 0.2,
    y0=max(M3.top, M4.top, M6.top),
    y1=max(M3.top, M4.top, M6.top) + 0.8, net="VDD")
vss = c.rect(m2,
    x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.2,
    x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.2,
    y0=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom) - 0.8,
    y1=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom), net="VSS")

# ---------------- taps ----------------
for mos in (M3, M4, M6):
    if mos.well:
        c.tap("ntap", x0=mos.well.left - 0.1, y0=mos.well.bottom - 0.1,
              x1=mos.well.right + 0.1, y1=mos.well.top + 0.1, net="VDD")
c.tap("ptap", x0=M1.diff.left - 0.1, y0=M1.diff.bottom - 0.1,
      x1=max(M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y1=min(M1.diff.bottom, M2.diff.bottom, M5.diff.bottom, M7.diff.bottom, M8.diff.bottom) - 0.1, net="VSS")
c.tap("ptap", x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.1,
      y1=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top) + 0.1,
      x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y0=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top), net="VSS")

# ---------------- internal nodes (c0 straps) ----------------
def strap(*objs, net):
    return c.rect(c0, x0=min(o.left for o in objs), x1=max(o.right for o in objs),
                  y0=min(o.bottom for o in objs), y1=max(o.top for o in objs), net=net)

strap(M1.sd[0], M2.sd[0], M5.sd[1], net="TAIL")
strap(M1.sd[1], M3.sd[1], M3.gates[0], M4.gates[0], net="D1")
strap(M2.sd[1], M4.sd[1], M6.gates[0], net="D2")
strap(M6.sd[1], M7.sd[1], net="OUT")

# gate input metal1 tabs
for mos, pin in ((M1, "INN"), (M2, "INP")):
    g = mos.gates[0]
    c.rect(m1, x0=g.left - 0.2, x1=g.right + 0.2, y0=g.bottom - 0.1, y1=g.top + 0.1, net=pin)

# ---------------- compensation network ----------------
if have_res:
    strap(RZ.a, D2_shape := None, net="D2") if False else None
    c.rect(c0, x0=min(RZ.a.left, M2.sd[1].left, M4.sd[1].left, M6.gates[0].left),
           x1=max(RZ.a.right, M2.sd[1].right, M4.sd[1].right, M6.gates[0].right),
           y0=min(RZ.a.bottom, M2.sd[1].bottom, M4.sd[1].bottom, M6.gates[0].bottom),
           y1=max(RZ.a.top, M2.sd[1].top, M4.sd[1].top, M6.gates[0].top), net="D2")
    xnode = c.rect(c0,
        x0=min(RZ.b.left, CC.bottom_pad.left if have_mim else RZ.b.left),
        x1=max(RZ.b.right, CC.bottom_pad.right if have_mim else RZ.b.right),
        y0=min(RZ.b.bottom, CC.bottom_pad.bottom if have_mim else RZ.b.bottom),
        y1=max(RZ.b.top, CC.bottom_pad.top if have_mim else RZ.b.top), net="X")
elif have_mim:
    xnode = c.rect(c0, x0=CC.bottom_pad.left, x1=CC.bottom_pad.right,
                   y0=CC.bottom_pad.bottom, y1=CC.bottom_pad.top, net="X")
    c.rect(c0, x0=M2.sd[1].left, x1=CC.top_pad.left,
           y0=CC.top_pad.bottom, y1=CC.top_pad.top, net="D2")

# ---------------- router for long signals ----------------
r = Router(c)
r.auto()
try:
    h = r.run()
except Exception:
    pass

# ---------------- ports ----------------
c.port("INP", on=M2.gates[0], dir="in")
c.port("INN", on=M1.gates[0], dir="in")
c.port("OUT", on=strap(M6.sd[1], M7.sd[1], net="OUT"), dir="out")
c.port("IB", on=M8.sd[1], dir="in")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c
```

I made errors: `M2.at = ...` — mos objects may not support `.at` assignment, and `D2_shape := None` is bogus. Also `RZ.at`/`CC.at` assignment and `RZ.diff` may not exist. Let me check the API: PCells are placed with `at=` at creation; can I reposition? The doc shows `at=` in constructor. There's `place()` for hierarchy instances. For mos, I think `at=` is set at creation. Let me not reassign `.at`. Instead, I'll create devices at computed positions by passing `at=` directly, computing positions incrementally using previously placed shapes' attributes.

But I need device sizes before placing. I can create all at (0,0) first to get sizes, then... no, they'd overlap but I can read `.diff.w` etc. then recreate? Can't recreate easily.

Better approach: create devices one at a time, computing `at=` from the previous device's shape attributes (which are known after creation). Since creation at (0,0) gives real sizes, I can place M1 at (0,0), read M1.diff, then place M2 at (M1.diff.right+sp, M1.diff.bottom) by creating M2 with that at. But I already created M2 at (0,0). 

Solution: create devices sequentially, each with `at=` computed from already-created devices. Don't create all at (0,0). Let me restructure: create M1 at (0,0), then M2 with at based on M1, etc. But I need M3/M4 sizes which depend on creation... I can create them in order and use their attributes immediately.

Let me rewrite cleanly, creating each device with computed `at=`, in dependency order. For the compensation, place RZ/CC after M6/M7.

Also `strap` helper uses `o.left` etc. — shapes have those. Good. But I referenced `M2.sd[1]` before M2 placed — fine if placed in order.

Let me also reconsider: `c.mos(... at=(x,y))` — does `at` set the diff origin or gate origin? The doc: `at=(0,0)`. Likely the cell origin. I'll just use it as a placement anchor and read `.diff` edges.

Let me also handle the `RZ`/`CC` placement: `c.resistor` returns r with `.a`, `.b` pads. `c.capacitor` returns cc with `.top_pad`, `.bottom_pad`, `.w`, `.h`. Good.

Let me rewrite the whole thing properly.```python
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
```

I keep hitting the issue that I need a device's size to place the next, but `at=` is set at creation. Let me check: can I create a device, read its size, and the canvas allows me to set position? The cleanest is to create all devices first at (0,0) — they overlap but I can read their `.diff.w/.h` — then I cannot move them. 

Alternative: The canvas `mos` might support being placed and the `at` is the anchor. Since I can't move after creation, I'll create devices in an order where each new device's `at=` only depends on previously created devices' sizes (which are known). I just need to not create M5 before knowing its height. But M5's height is known right after I create it. So: create M5 at a temporary position, read M5.diff.h, but I can't move it.

Hmm. Let me reconsider — maybe I should just place everything at (0,0) to get sizes, then build a SECOND pass? No.

Actually, simplest robust approach: place devices on a grid using estimated pitches, then route. But I want exact sizes.

Let me check if mos objects allow setting position. Let me look at whether there's a way. Actually, I can create devices at (0,0), read sizes, and then place them using `c.place`? No, that's for hierarchy.

Let me just create each device with `at=` computed from previously created ones, and for the first device of a pair where I need the second's size to position the first, I'll order carefully:

Order: M1 (at 0,0) -> know M1 size. M2 (at M1.diff.right+sp, M1.diff.bottom) -> know M2 size. M5: I need M5 height to place below M1. But I can place M5 at (M1.diff.left, some_y) and choose y after creating M5... can't.

Solution: create M5 at (0,0) first (temp), read M5.diff.h, then... it's already placed at (0,0) overlapping M1. That's a problem for DRC but I can't move.

Wait — maybe I can just place M5 below M1 using a y that accounts for an estimated height, then verify. But better: let me check if the canvas supports repositioning. Let me look at the API by checking if mos has a method. Actually, let me just test: create M5 at (0,0), and place M1/M2 relative to known sizes, and place M5 using its own size by creating it LAST in the vertical chain but at a computed y that I estimate.

Cleanest: I'll create all devices at (0,0) to obtain sizes, store sizes, then I realize I can't reposition. 

Let me reconsider the whole strategy: Use `stick` cells / `rows`? Too complex for this irregular topology.

Alternative: Maybe `at=` can be changed, or maybe I should just place devices with explicit absolute coordinates that I compute from known standard sizes. But I don't know exact sizes.

Let me check: does the canvas mos return an object whose position I can set? Let me just try creating devices sequentially where each `at=` depends only on earlier-created devices. For M5 below M1: I need M5's height. I can create M5 at (M1.diff.left, M1.diff.bottom - 1.2 - ESTIMATED_H). If estimate is off, DRC/LVS still fine as long as no overlap and routing connects. Overlap would be bad. Let me estimate NMOS w=2 l=1 nf=4 height: diffusion width w=2 (vertical), plus gates. Height maybe ~3-4 um. Let me just create M5 at (0,0) to read size, but place it properly...

OK, I think the cleanest is: create devices one by one; for any device whose position depends on its own size, create it at (0,0) first to measure, but that overlaps. 

Let me just check whether I can set `.at` or reposition by testing quickly. Actually, I'll restructure to avoid needing a device's own size for its placement:

- Place M1 at (0,0).
- Place M2 right of M1 (needs M1 size only). ✓
- Place M5 below M1: needs M5 height. Instead, place M5 to the RIGHT of M2 or in a column where vertical position doesn't need its own height. 

Let me redesign floorplan so placement only depends on previously-created devices:

Column 1 (bottom): M1 (NMOS pair left). Above M1: M3 (PMOS load). 
Column 2: M2 right of M1. Above M2: M4.
Column 3 (right): M6, M7.
Tail M5: place below the M1/M2 row, spanning. I need M5 height to set its top = M1.bottom - gap. 

I can create M5 at (0,0) to get its height h5, then I still can't move it. 

Hmm, let me just check if the canvas allows repositioning by trying `M5.at = ...` — if mos objects are like shapes with settable attributes maybe. But safer: let me create M5, M8, M7 etc. at (0,0) to measure all sizes FIRST (they overlap at origin but that's fine for measuring), THEN I know all sizes. But I can't place them in a second pass.

Wait — actually I CAN create them in the final positions if I compute positions from sizes, and I can get sizes by creating at (0,0) in a FIRST script run... no.

Let me reconsider: maybe the canvas `mos` and other PCells support being placed via `at=` and I can just compute everything if I create in an order where each device's position depends only on devices created before it. The only problem is a device whose position depends on its own height (to place below something with top alignment). 

For M5 below M1: I want M5.top = M1.bottom - gap. M5.at.y = M1.bottom - gap - M5.h. Needs M5.h. 

Workaround: Place M5 BELOW M1 but align BOTTOM: M5.at.y = M1.bottom - gap - M5.h. Still needs M5.h.

Alternative: place M5 to the side (right of M8) rather than below. Let me redesign:

Floorplan:
- Row A (bottom): VSS rail.
- Row B: NMOS devices M1, M2 (diff pair) and M5 (tail) and M7 (sink) and M8 (diode) — all in a horizontal line? They have different heights.

This is getting complicated. Let me just check if I can reposition. Let me write a tiny test to see if mos objects support setting position or if there's a `place`/`move`. Actually, I'll just create devices at (0,0), read sizes, and then place them using absolute coordinates computed from sizes — but I need to place in the SAME script. 

Idea: Create all devices at (0,0) to measure. Record sizes. Then... they're all at (0,0) overlapping. Bad.

Better idea: The canvas likely lets me create a device and the `at` is just the origin; maybe I can create a "placeholder" — no.

Let me just look: maybe I can create devices and then use `c.rect` straps to connect, and place devices far apart initially using estimated coordinates, then route. Overlaps only matter if they actually overlap. If I space them generously using conservative size estimates, no overlap, and routing connects everything. Estimates just need to be upper bounds to avoid overlap, but too much space blows area budget (2x allowed = 5296 um2, reference 2648). I have room.

But I'd rather get exact. Let me check if the canvas supports repositioning by testing `at` reassignment or a move method. Let me just write the script creating devices sequentially with `at=` depending on previous devices, and for the self-height problem, I'll place M5, M8, M7 in a separate column to the right where I stack them vertically using cumulative heights (each depends on previous, not self).

New floorplan (columns):
- Col 1: M1 (bottom), M3 (top above M1).  [first stage left half]
- Col 2: M2 (bottom, right of M1), M4 (top above M2, right of M3). [first stage right half]
- Col 3 (to the right of col 2): stack M5 (tail), M8 (diode) vertically at bottom; M7 (sink) above them; M6 (2nd stage PMOS) at top right.

Hmm M6 needs to be above M7 (PMOS top row, NMOS bottom row). Let me do:

- Top row (VDD): M3, M4 (load), then M6 (2nd stage) to the right.
- Bottom row (VSS): M1, M2 (diff pair), M5 (tail), M8 (diode), M7 (sink).
- M6 gate = D2 (from M2/M4 drain). M6 drain = OUT. M7 drain = OUT. M7 gate = IB.

Placement order (each depends only on previous):
1. M1 at (0,0). 
2. M3 above M1: at (M1.diff.left, M1.diff.top + sp). needs M1 only. ✓
3. M2 right of M1: at (M1.diff.right + sp, M1.diff.bottom). ✓
4. M4 above M2: at (M2.diff.left, M2.diff.top + sp). ✓
5. M5 below M1: needs M5.h. Problem.

To avoid self-height: place M5 to the right of M2 (same bottom row), at (M2.diff.right + sp, M1.diff.bottom). Then M5 doesn't need its own height for y (aligned with M1 bottom). ✓ But M5 is wide (nf=4). Fine.

6. M8 right of M5: at (M5.diff.right + sp, M1.diff.bottom). ✓ (bias diode)
7. M7 (sink) right of M8 or below M6: Let me put M7 in bottom row right of M8: at (M8.diff.right + sp, M1.diff.bottom). ✓
8. M6 above M7 / right of M4: at (M4.diff.right + sp, M4.diff.top - M6.h). needs M6.h. Problem again.

For M6, place it in the top row right of M4: at (M4.diff.right + sp, M3.diff.bottom) i.e. same y as M3/M4 (top row). ✓ needs only M4. M6.diff.bottom = M3.diff.bottom (aligned). Good, top row aligned.

So:
- Top row y = M3.diff.bottom (= M4.diff.bottom = M6.diff.bottom). M3 above M1, M4 above M2, M6 right of M4.
- Bottom row y = M1.diff.bottom (= M2 = M5 = M8 = M7). 

Wait M3 is "above M1" so M3.diff.bottom = M1.diff.top + sp. M4.diff.bottom = M2.diff.top + sp = same (M1 and M2 aligned). Good, top row aligned. M6 at same bottom = top row. ✓

- M7 bottom row right of M8. ✓

Now M6 gate = D2 connects from M2/M4 (col 2) across to M6 (col 3). Routing handles it.

M7 drain = OUT connects to M6 drain (top row) — vertical routing. M7 gate = IB (from M8). 

This works! All placements depend only on previously created devices. Let me also place RZ and CC:
- RZ between D2 and X. Place RZ right of M6 (top row area) or near D2. Let me place RZ at (M6.diff.right + sp, M6.diff.bottom) (top row, right of M6), oriented vertical. RZ.a connects to D2, RZ.b to X.
- CC (MIM) between X and OUT. Place CC below RZ or right. Let me place CC at (RZ position x, M7.diff.top) area. Actually CC is 20x20, big. Let me place CC to the right of M6/M7 area.

Hmm, area budget. Let me just place RZ and CC to the right of the second stage and route.

Actually, let me reconsider positions to keep it compact. Let me place:
- RZ at (M6.diff.right + sp, M6.diff.bottom) — top row extension.
- CC at (M6.diff.right + sp, M7.diff.bottom) — bottom row extension, below RZ. CC is 20x20 so it spans vertically; place at bottom row y.

Then X node = between RZ.b and CC.bottom_pad. Route D2->RZ.a, RZ.b->CC.bottom (X), CC.top->OUT.

This is fine. Let me also make sure D2 strap reaches M6 gate and RZ.a.

Let me now also handle the case freepdk45 (no res, no mim): RZ becomes M9 (NMOS triode, gate=VDD), CC becomes MC (NMOS capacitor, gate=OUT, s/d joined). But target PDK is sky130A which has both. I'll write the sky130A version with res+mim, and add freepdk45 fallback. Since grading is sky130A, I'll focus but include fallback for completeness.

Actually, to keep it manageable and correct for sky130A, let me implement sky130A fully (res + mim), and add a simple freepdk45 fallback using transistors. But the fallback needs care. Let me implement both but ensure sky130A is correct.

Let me now also reconsider: the `strap` function and `c.rect(c0, ...)`. The c0 is "li". Contacts: mos.sd[i] are c0 straps already. Good.

Now, the gates: M1.gates[0] is poly. INN/INP ports on poly gates — but ports should be on metal typically. The doc example puts port on poly via a contact. Let me add m1 tabs over the gates with contacts, or just put port on the poly gate (LVS pin on poly is fine? Pin should be on a conductor layer that connects). Actually input pins INN/INP connect to poly gates. I can place port on the poly gate shape directly, or bring to m1. Let me bring INN/INP to m1 with a contact for cleanliness. But simpler: port on poly gate is acceptable since net="INN" on the poly. Let me put net on the gate and port on gate. Actually `c.port("INN", on=M1.gates[0])` — port on poly. Should be fine for LVS (pin on poly). But the doc says pins become labels; label on poly layer. OK.

Hmm, but for the gate, the poly gate of M1 — is it accessible? Yes. Let me put net="INN" on M1 gate and port there. Actually the mos already has the gate; I just need to name the net. Let me add a small m1 rectangle over each gate with a contact (via licon? poly->li is licon). Actually poly to c0(li) uses licon cut. Let me add contacts.

This is getting detailed. Let me simplify: route INN/INP/IB/OUT/etc. using the router where possible, and manual straps for local connections.

Let me reconsider using the Router. The Router routes between pins on c1/c2 with trunks. It might be easier to route power and signals. But the Router works with "pins" as shapes. Let me use manual c0 straps for local device connections (they're all on c0/li which is the device layer) and m1/m2 for longer runs.

Given time, let me write a complete script with manual routing using c0 (li) straps and m1/m2 for rails, then run DRC/LVS and iterate. Let me write it now, carefully.

Let me define placement precisely:

```
M1 at (0,0)
M3 at (M1.diff.left, M1.diff.top + sp)
M2 at (M1.diff.right + sp, M1.diff.bottom)
M4 at (M2.diff.left, M2.diff.top + sp)
M5 at (M2.diff.right + sp, M1.diff.bottom)     # tail, bottom row
M8 at (M5.diff.right + sp, M1.diff.bottom)     # bias diode, bottom row
M7 at (M8.diff.right + sp, M1.diff.bottom)     # sink, bottom row
M6 at (M4.diff.right + sp, M3.diff.bottom)     # 2nd stage PMOS, top row
RZ at (M6.diff.right + sp, M6.diff.bottom)     # top row
CC at (M6.diff.right + sp, M7.diff.bottom)     # bottom row (20x20)
```

Wait M6 at (M4.diff.right+sp, M3.diff.bottom): M6.diff.bottom = M3.diff.bottom, so top row aligned. Good. But M6 is wide (nf=8, w=4). It'll extend far right. RZ right of M6 extends further. Area might be large but within 2x budget hopefully.

Actually M6 w=4 nf=8 is very wide. Total width = 8 fingers * 4um = 32um of diffusion plus gates. That's wide. M6.diff.w could be ~ 8*(gate+space) ... let me just see. The area budget is 60x22=1320 reference, budget 2648. Hmm reference is 60.715 x 21.805 = 1324 um2, budget 2648. My layout might exceed if M6 is 32um wide plus everything. Let me estimate total width: col1 M1 (~w=4 nf=2 -> maybe 3um wide) + sp + M2 (~3um) + sp + M5 (w=2 nf=4 -> maybe 5um) + sp + M8 (w=2 nf=2 -> ~3um) + sp + M7 (w=2 nf=8 -> ~9um) = ~26um for bottom row. Top row: M3 (~3um) + sp + M4 (~3um) + sp + M6 (w=4 nf=8 -> ~17um) = ~26um. Plus RZ/CC to the right. Could be ~40-50um wide. Height: bottom row to top row + rails. M1 height (w=4) ~ 5um, M3 height (w=4) ~5um, gap sp, rails ~2um each. Total height ~ 5+0.6+5+2(rails) ~ 13-15um. Area ~ 50*15 = 750. Well within budget. Good. Actually CC is 20x20 which adds height if placed below. Let me place CC to the right of RZ instead of below, to avoid blowing height. Or place CC in the bottom row area. Let me place CC at (RZ.diff.right + sp, M7.diff.bottom) — extends width by 20. Width ~ 26 + 20 = 46. Height ~ 15. Area ~ 690. Fine.

Hmm wait, but M6 is w=4 nf=8 — is w per finger? If w=4 per finger and nf=8, total width 32um diffusion. That's huge. Let me reconsider: maybe w is total width and nf divides it. The netlist: XM6_0 ... w=4 l=0.5, 8 fingers XM6_0..XM6_7. If canvas writes each finger with w=4, then w=4 is per finger, total 32. But that seems too wide for a reference 60um wide chip. Actually 8 fingers * 4um = 32um just for M6 diffusion, plus gates. That alone is wide. But reference total width is 60um. So maybe w=4 is TOTAL width and each finger is w/nf = 0.5um? But netlist says w=4 for each finger instance...

Hmm, this is the key question. Let me reconsider: In the netlist, each finger instance XM6_0 has w=4. If the canvas mos with w=4, nf=8 writes 8 instances each w=4, total W=32. But maybe the canvas writes ONE instance with w=4, nf=8 and the netlist writer... no, the netlist clearly has 8 separate instances each w=4.

Wait, maybe the canvas mos `w` is the TOTAL width, and with nf fingers it creates nf devices each of width w/nf? But then netlist would say w=0.5 for each. It says w=4. So either:
(a) w=4 is per finger, canvas writes nf instances each w=4 (total 32), OR
(b) w=4 is total, canvas writes nf instances each w=4 (total 32) — same thing.

Either way each finger is w=4. So M6 total width = 8 * 4 = 32um of diffusion. That's the device size. The reference layout is 60um wide, so 32um for M6 plus other devices fits in 60um. OK so my estimate of M6 being wide is correct, and total width ~ 26 (bottom) but top row has M6 32um wide. Let me recompute top row width: M3 (w=4 nf=2 -> 8um diffusion) + sp + M4 (8um) + sp + M6 (32um) = ~49um. Bottom row: M1 (8um) + sp + M2 (8um) + sp + M5 (w=2 nf=4 -> 8um) + sp + M8 (w=2 nf=2 -> 4um) + sp + M7 (w=2 nf=8 -> 16um) = ~46um. Plus RZ/CC to the right of M6: + ~10 + 20 = ~79um wide. That exceeds 60um reference but budget is 2x area (5296 um2). 79 * height. Height ~ 15um -> 1185 um2. Within 5296 budget. But width 79 > 60 reference; area is what matters (budget is area 2648, 2x = 5296). 1185 < 5296. Fine. But let me try to keep it compact anyway.

Actually wait, is w per finger = 4, or is the diffusion width w? The MOS diffusion width (the dimension perpendicular to gate) = w. With nf fingers side by side, total width = nf * w + (nf-1)*gate_pitch? No — fingers share diffusion regions. For nf fingers, there are nf gates and nf+1 diffusion regions (or nf-1 shared + 2 ends). The total x-width = nf * L_gate + (nf+1) * diffusion_width_between_gates... no.

Let me think physically: A multi-finger MOS: diffusion runs vertically (height = w), gates run horizontally across it (width = L). Fingers are side by side along x. Each finger: gate of length L (x-dimension) crossing diffusion. Between adjacent fingers is a shared source/drain diffusion region. So along x: [diff ext][gate L][shared diff][gate L][shared diff]...[gate L][diff ext]. The shared diffusion regions have some width (minimum diffusion). Total x ≈ nf*L + (nf-1)*shared_diff_width + 2*ext. The shared diff width is at least min diffusion width (~0.3um) but for shared S/D it's just the diffusion between two gates, which needs to be wide enough for contact. Typically ~0.5-1um.

So M6 (nf=8, L=0.5): x ≈ 8*0.5 + 7*~0.6 + 2*ext ≈ 4 + 4.2 + ext ≈ ~9-10um. NOT 32um! Because the fingers are stacked along x with gate length 0.5 each, not width 4 each. The w=4 is the vertical diffusion height. So total width is modest. 

So my width estimates were wrong. Let me recompute: MOS width (x-dimension) ≈ nf * L + (nf-1)*pitch_shared + extensions. For M6: 8*0.5 + 7*0.6 + 2*0.3 ≈ 4+4.2+0.6 ≈ 8.8um. Height (y-dimension) = w = 4um plus source/drain extensions. So M6 is ~9um wide, ~5um tall. 

So total layout width: bottom row M1(2 fingers L=0.5 -> ~2um) + M2(~2um) + M5(4 fingers L=1 -> ~4*1+3*0.6=5.8um) + M8(2 fingers L=1 -> ~2*1+0.6=2.6um) + M7(8 fingers L=1 -> 8+7*0.6=12.2um) + gaps ≈ 2+0.6+2+0.6+5.8+0.6+2.6+0.6+12.2 ≈ 27um. Top row: M3(2 fingers L=1 -> ~2+0.6=2.6um) + M4(~2.6um) + M6(~8.8um) + gaps ≈ 15um. Plus RZ/CC. CC is 20x20 (big!). CC 20um wide. If placed to the right, width += 20. Total ~ 27+20 = 47um. Height: bottom row devices height: M1 w=4 -> ~5um tall, M5 w=2 -> ~3um, M7 w=2 -> ~3um. They're aligned at bottom but different tops. Top row M3/M4 w=4 -> ~5um, M6 w=4 -> ~5um. Gap between rows sp=0.6. Rails. Total height ~ 5 (bottom) + 0.6 + 5 (top) + 2 (rails top/bottom) ≈ 13um. CC 20 tall if placed below — don't place below. Place CC to the right in the middle vertically. 

OK this is all estimation. Let me just write the script with the sequential placement and run it. I'll iterate based on DRC/LVS results.

Let me write the final script now. I'll be careful about the API.

Key API points:
- `c.mos(kind, w, l, nf, gates, sd, at=(x,y), net=?)`. gates can be a string (one net for all gates) or list. sd is (source, drain) pair or nf+1 nets. For M1: gates="INN", sd=("TAIL","D1"). 
- `m.diff`, `m.gates[i]`, `m.sd[i]`, `m.well` (for pmos).
- `c.tap(kind, x0,y0,x1,y1, net)`.
- `c.resistor("res_poly", w, l, at, nets, orient)` -> r.a, r.b.
- `c.capacitor("cap_mim", w, h, at, nets)` -> cc.top_pad, cc.bottom_pad.
- `c.rect(layer, ..., net=)`.
- `c.port(name, on=shape, dir=)`.
- `Router(c)`, `r.auto()`, `r.run()`.

For `at=` on mos: I'll set at creation. Let me place sequentially.

One concern: `M5.at` — I won't reassign; I create M5 with computed at. But M5's position y = M1.diff.bottom (aligned bottom), x = M2.diff.right + sp. That doesn't need M5's own size. Good. Similarly all placements avoid self-size. 

For M6: at = (M4.diff.right + sp, M3.diff.bottom). Needs M4 and M3 only. Good. M6.diff.bottom = M3.diff.bottom (top row aligned). Good.

For RZ: at = (M6.diff.right + sp, M6.diff.bottom). Needs M6. Good. RZ orient="v".
For CC: at = (RZ.b.right + sp, M7.diff.bottom) — needs RZ placed. Or place CC at (M6.diff.right + sp, M7.diff.bottom) (below RZ, bottom row). But CC is 20 tall, would extend above M7 into the gap. That's fine, no overlap if M7 top < CC bottom... CC at M7.diff.bottom means CC bottom = M7 bottom, CC extends up 20um which would overlap M6/top row. Bad. 

Let me place CC to the right of RZ: CC.at = (RZ.b.right + sp, M6.diff.bottom) (top row, right of RZ). CC is 20x20, extends up 20 from top row — might go above VDD rail. That's OK if within cell, but VDD rail is at top. Let me place CC at (RZ.b.right + sp, M7.diff.bottom) but that overlaps vertically with top row. 

Better: place CC in the bottom row to the right of M7: CC.at = (M7.diff.right + sp, M1.diff.bottom). CC 20x20 extends up 20 from bottom row — overlaps top row (which is at M1.bottom + 5 + 0.6 = ~11.6). CC top = bottom + 20 = ~20, top row top ~ 11.6 + rail. Overlap between CC (y 0 to 20) and top row devices (y ~11.6 to 16.6) in x-range if CC x overlaps top row x. CC is at x = M7.diff.right+sp (far right, ~27um), top row M6 is at x = M4.diff.right+sp (~15um) to ~24um. CC at x~27-47um, M6 at 15-24um. No x overlap! So CC at bottom-right, extending up to y=20, while top row is at y 11.6-16.6 but at x 15-24. CC at x 27-47. No overlap. But CC extends above VDD rail? VDD rail at top ~ y=16.6 to 17.4. CC top at y=20 > VDD rail top. CC would extend above the VDD rail but at x 27-47 where there's no VDD rail (VDD rail only spans the wells x-range). Actually VDD rail x0..x1 spans wells (M3,M4,M6 wells) = x 0 to ~24. CC at x 27-47 is outside VDD rail x-range. So CC extending to y=20 is fine (no overlap). But then cell height = 20 (from CC) which is fine. Area = width ~47 * height ~20 = 940. OK.

Hmm, but actually it's cleaner to keep CC within the main block. Let me place CC at (M7.diff.right + sp, M1.diff.bottom) — bottom right. It extends up to y=20. The cell bbox will be y 0 to ~20 (or VDD rail top ~17.4, CC top 20). Height ~20. Width ~47. Area ~940. Fine, within budget.

Actually, let me reduce height by placing CC not extending too high. CC is 20x20 fixed (w=20 l=20 for the MIM). It's a big cap. Fine.

Wait, the MIM cap w=20 l=20 — that's 20um x 20um, quite large. Area 400 um2 just for CC. Plus everything. Total maybe ~1000-1500 um2. Within 5296 budget. Good.

Let me also reconsider: do I even need CC to be 20x20? The netlist says cap_mim w=20 l=20. Yes, must match. OK.

Now let me also handle the freepdk45 fallback (no res/mim). For sky130A (target), both exist. I'll write the main path for sky130A and a fallback. But to keep the script correct and not overcomplicate, let me implement the res/mim path (sky130A/gf180) and a transistor fallback for freepdk45. Since grading is sky130A, I'll make sure that path is solid.

Let me now also think about LVS device matching. The netlist has M1 as two fingers XM1_0, XM1_1 each w=4 l=0.5. My canvas mos M1 with w=4, l=0.5, nf=2 should produce two fingers each w=4 l=0.5. Good. M5 w=2 l=1 nf=4 -> 4 fingers w=2 l=1. Matches XM5_0..3. M8 w=2 l=1 nf=2 -> matches XM8_0,1. M3 w=4 l=1 nf=2 -> matches XM3_0,1. M4 similar. M6 w=4 l=0.5 nf=8 -> matches XM6_0..7. M7 w=2 l=1 nf=8 -> matches XM7_0..7. RZ w=1 l=8. CC w=20 l=20. 

Now connectivity: I need to make sure the net names match. The netlist uses nets: INP, INN, OUT, IB, VDD, VSS, TAIL, D1, D2, x (internal). Internal net names are free per the task ("internal net names are free"). So TAIL, D1, D2, X can be anything. Good. But the DEVICE connections must match: e.g., M1 gate=INN, source/drain = {TAIL, D1}. Since source/drain are swapped in netlist between fingers but electrically it's {TAIL, D1}, fine.

Let me make sure M5 (tail): gate=IB, source=VSS, drain=TAIL. My M5: sd=("VSS","TAIL"), gates="IB". So source=VSS, drain=TAIL, gate=IB. Matches (XM5_0: drain=TAIL, gate=IB, source=VSS). Good.

M8: gate=IB, sd=("VSS","IB") -> source=VSS, drain=IB, gate=IB. Diode connected (gate=drain=IB). Matches XM8_0 (drain=IB, gate=IB, source=VSS). Good.

M7: gate=IB, sd=("VSS","OUT") -> source=VSS, drain=OUT, gate=IB. Matches XM7_0 (drain=OUT, gate=IB, source=VSS). Good.

M6: gate=D2, sd=("VDD","OUT") -> source=VDD, drain=OUT, gate=D2. Matches XM6_0 (drain=OUT, gate=D2, source=VDD). Good.

M3: gate=D1, sd=("VDD","D1") -> source=VDD, drain=D1, gate=D1. Diode connected (gate=drain=D1). Matches XM3_0 (drain=D1, gate=D1, source=VDD). Good.

M4: gate=D1, sd=("VDD","D2") -> source=VDD, drain=D2, gate=D1. Matches XM4_0 (drain=D2, gate=D1, source=VDD). Good.

M1: gate=INN, sd=("TAIL","D1") -> source=TAIL, drain=D1, gate=INN. Matches XM1_0 (drain=D1, gate=INN, source=TAIL). Good.
M2: gate=INP, sd=("TAIL","D2") -> source=TAIL, drain=D2, gate=INP. Matches XM2_0. Good.

RZ: between D2 and X. My resistor nets=("D2","X"). Good.
CC: between X and OUT. nets=("X","OUT"). Good.

Bulk: NMOS bulk=VSS (mos default? The mos has bulk tied to VSS via... I need to make sure NMOS bulk connects to VSS). The canvas mos for nmos — does it connect bulk? The netlist NMOS bulk=VSS. The canvas mos probably ties bulk to a well or substrate. For nmos without well, bulk is substrate (VSS). I should ensure NMOS bulk is VSS. The mos PCell likely handles bulk via the substrate or a specified net. Let me check: `c.mos("nmos", ...)` — bulk connection. The doc doesn't mention bulk param for mos. It might tie nmos bulk to VSS automatically or leave it. For LVS, the extracted NMOS bulk must be VSS. In sky130, NMOS is in p-substrate, bulk = substrate. If I don't draw a bulk contact, extraction might float bulk. I should add p-taps (substrate contacts to VSS) which I do. The MOS bulk terminal — netgen LVS for MOS: the 4th terminal is bulk. If the layout MOS has bulk connected to substrate (via the p-substrate, no contact needed for the MOS itself—the MOS bulk is the substrate), netgen might treat it as connected to VSS if there's a p-tap. Actually, the MOS device in extraction includes the bulk terminal which connects to the surrounding substrate. If substrate is tied to VSS via p-tap, bulk=VSS. Should be fine.

For PMOS, bulk = n-well = VDD. The mos PCell creates m.well (n-well) and I add ntap to VDD. The PMOS bulk connects to the n-well. Good.

Now, the mos `sd` straps: m.sd[i] are c0 straps per source/drain column. For nf fingers, there are nf+1 sd straps. M1 nf=2 -> m.sd[0], m.sd[1], m.sd[2]. sd=("TAIL","D1") means source=TAIL, drain=D1. With 2 fingers, the shared middle diffusion... sd straps: sd[0]=source(TAIL), sd[1]=shared?, sd[2]=drain(D1)? Or sd[0] and sd[1] are the two ends. The doc: "m.sd[i] (c0 strap per source/drain column)". For nf fingers there are nf+1 columns. With sd=("TAIL","D1") (a pair), it alternates: sd[0]=TAIL, sd[1]=D1, sd[2]=TAIL? Or sd[0]=TAIL, sd[1]=D1 for nf=1... For nf=2, sd pair (S,D) alternates: columns = S, D, S? That would be TAIL, D1, TAIL. But we want the two fingers: finger0 source=TAIL drain=D1, finger1 source=TAIL drain=D1. With shared diffusion, the middle column is shared drain of finger0 and source of finger1 — but they're different nets (D1 vs TAIL)! That can't be shared.

Hmm. For a differential pair transistor M1 with two fingers, we want both fingers: source=TAIL, drain=D1. If fingers share diffusion, the middle diffusion would be both drain (finger0) and source (finger1) — conflict unless TAIL==D1. So for M1, the two fingers should NOT share diffusion; they should be separate, each with source=TAIL and drain=D1. That means sd = ("TAIL","D1","TAIL","D1")? nf+1 = 3 columns for nf=2 if sharing, but if not sharing we need separate source and drain for each finger.

Actually, the netlist has XM1_0 (drain=D1, source=TAIL) and XM1_1 (drain=TAIL, source=D1) — SWAPPED! This is exactly the shared-diffusion / cross-coupled technique: finger0 drain=D1 source=TAIL, finger1 drain=TAIL source=D1. The middle shared diffusion is D1 for finger0 (drain) and TAIL for finger1 (source)? No—if they share a diffusion, that diffusion is one net. 

Wait, XM1_0: drain=D1, source=TAIL. XM1_1: drain=TAIL, source=D1. So finger0: drain=D1, source=TAIL. Finger1: drain=TAIL, source=D1. If they share the middle diffusion, finger0's drain (D1) and finger1's source (D1) — both D1! And finger0's source (TAIL) and finger1's drain (TAIL) — both TAIL! So the shared middle diffusion = D1? No: finger0 drain=D1 (right side), finger1 source=D1 (left side). If they share the middle diffusion, that diffusion is D1 (finger0 drain = finger1 source = D1). And the outer diffusions: finger0 source=TAIL (left outer), finger1 drain=TAIL (right outer). So columns left-to-right: TAIL, D1(shared), TAIL. That's sd = ("TAIL","D1","TAIL") for nf=2! 

So the canvas with sd=("TAIL","D1") and nf=2 — does it produce TAIL, D1, TAIL (alternating starting with source)? The doc: "sd = (S, D)