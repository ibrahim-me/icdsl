```python
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, c3 if False else (tech.c0, tech.c1, tech.c2, tech.conductor(3))
c0, c1, c2 = tech.c0, tech.c1, tech.c2
topm = tech.stack[-1]
has_res = "res_poly" in tech.d["devices"]
has_cap = "cap_mim" in tech.d["devices"]

# ---------- technology-dependent sizing (gf180mcuD values scale via the rule sheet) ----------
def W(val):   # drawn width  (um)
    return val
def L(val):   # drawn length (um)
    return val

# finger pitch = gate width + poly/diff space (keeps diffusion contacts legal)
pitch = tech.width("diff") + tech.space("poly", "diff")
nwell_en = tech.enc("nwell", "diff")[0] if isinstance(tech.enc("nwell", "diff"), tuple) else tech.enc("nwell", "diff")

# ---------- netlist (gf180mcuD) ----------
# M8  : 2x (nfet, w=2, l=1)   diode IB
# M5  : 4x (nfet, w=2, l=1)   tail, g=IB
# M1  : 2x (nfet, w=4, l=0.5) diff pair, g=INN, s=tail, d=d1
# M2  : 2x (nfet, w=4, l=0.5) diff pair, g=INP, s=tail, d=d2
# M3  : 2x (pfet, w=4, l=1)   load diode, g=d=d1, s=VDD
# M4  : 2x (pfet, w=4, l=1)   load, g=d1, d=d2, s=VDD
# M6  : 8x (pfet, w=4, l=0.5) second stage, g=d2, d=OUT, s=VDD
# M7  : 8x (nfet, w=2, l=1)   sink, g=IB, d=OUT, s=VSS
# RZ  : poly 1u x 8u  d2 -> x        (freepdk45: M9 nfet triode, g=VDD)
# CC  : MIM 20x20     x -> OUT       (freepdk45: MC nfet cap, g=OUT, s=d joined)

c = Cell("ota_miller")

# ================= NMOS row (bottom) =================
nstrip = ("VSS IB IB - VSS IB tail INN d1 - tail INP d2 - VSS IB OUT")
ncell = stick("nrow", n=nstrip, ports="INN INP IB tail d1 d2 OUT VSS", ntracks=4, wn=2.0, wp=0.0, l=1.0)
nref = c.place(ncell, at=(0, 0), name="NROW")

# ================= PMOS row (top) =================
pitch_p = tech.width("diff") + tech.space("poly", "diff")
pstrip = ("VDD d1 d1 - VDD d1 d2 - VDD d2 OUT OUT OUT OUT OUT OUT OUT OUT")
pcell = stick("prow", p=pstrip, ports="VDD d1 d2 OUT", ntracks=4, wn=0.0, wp=4.0, l=1.0)
pref = c.place(pcell, above=nref, name="PROW")

# well under the PMOS row
nw = c.rect("nwell", inside=pref.bbox, inflate=(nwell_en, nwell_en), net="VDD")

# ================= guard rings (good practice) =================
grn = c.guard_ring("ptap", around=nref, net="VSS", space=0.6)
grp = c.guard_ring("ntap", around=pref, net="VDD", space=0.6)

# ================= compensation network =================
if has_res and has_cap:
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(0, 0), nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(0, 0), nets=("x", "OUT"))
    # place CC to the right of RZ, bring its bottom plate out on c1 to avoid router/MIM issues
    c.place(cc, right_of=rz, space=1.0)
    cb = c.rect(c1, x0=cc.bottom_pad.left, x1=cc.bottom_pad.right,
                y0=cc.bottom_pad.bottom - 0.6, y1=cc.bottom_pad.top, net="OUT")
    c.via(c0, c1, at=cc.bottom_pad, net="OUT")
    rza = rz.a   # d2 side
    rzb = rz.b   # x side
else:
    # freepdk45 fallback: RZ -> M9 (nfet triode, gate=VDD), CC -> MC (nfet cap, gate=OUT)
    m9 = c.mos("nmos", w=2.0, l=1.0, nf=1, gates="VDD", sd=("d2", "x"), at=(0, 0))
    mc = c.mos("nmos", w=20.0, l=1.0, nf=1, gates="OUT", sd=("x", "x"), at=(0, 0))
    c.place(mc, right_of=m9, space=1.0)
    rza, rzb = m9.sd[0], mc.sd[0]

# ================= routing =================
r = Router(c, v=c2, h=c3, pin_layer=c1)

def pin(name):
    return getattr(nref, "pin")(name) if hasattr(nref, "pin") else nref.pin(name)

r.add("VSS", nref.pin("VSS"), grn.straps[0])
r.add("VDD", pref.pin("VDD"), grp.straps[0])
r.add("IB",  nref.pin("IB"), grn.straps[-1] if False else nref.pin("IB"))
r.add("INN", nref.pin("INN"))
r.add("INP", nref.pin("INP"))
r.add("tail", nref.pin("tail"))
r.add("d1", nref.pin("d1"), pref.pin("d1"))
r.add("d2", nref.pin("d2"), pref.pin("d2"), rza)
r.add("x", rzb)
r.add("OUT", nref.pin("OUT"), pref.pin("OUT"), cb)

try:
    r.run()
except Exception:
    # hand-pre-route the difficult nets, then retry
    r.add("d2", nref.pin("d2"), pref.pin("d2"), rza)
    r.add("OUT", nref.pin("OUT"), pref.pin("OUT"), cb)
    r.run()

# ================= ports =================
c.port("INP", on=nref.pin("INP"), dir="in")
c.port("INN", on=nref.pin("INN"), dir="in")
c.port("IB",  on=nref.pin("IB"),  dir="in")
c.port("OUT", on=cb,              dir="out")
c.port("VDD", on=pref.pin("VDD"))
c.port("VSS", on=nref.pin("VSS"))

TOP = c
``````python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
topm = tech.stack[-1]
c3 = tech.conductor(3) if len(tech.stack) > 3 else c2
has_res = "res_poly" in tech.d["devices"]
has_cap = "cap_mim" in tech.d["devices"]

# ---------- technology-dependent sizing ----------
pitch = tech.width("diff") + tech.space("poly", "diff")
enc = tech.enc("nwell", "diff")
nwell_en = enc[0] if isinstance(enc, tuple) else enc

# ================= cell =================
c = Cell("ota_miller")

# ================= NMOS row (bottom) =================
# strip: sd gate sd gate ...  (M8 diode, M5 tail, M1/M2 diff pair, M7 sink)
nstrip = ("VSS IB IB - VSS IB tail INN d1 - tail INP d2 - VSS IB OUT")
ncell = stick("nrow", n=nstrip, ports="INN INP IB tail d1 d2 OUT VSS",
              ntracks=4, wn=2.0, wp=0.0, l=1.0)
nref = c.place(ncell, at=(0, 0), name="NROW")

# ================= PMOS row (top) =================
# strip: M3 diode, M4 load, M6 x8 second stage (all sources VDD)
pstrip = ("VDD d1 d1 - VDD d1 d2 - VDD d2 OUT OUT OUT OUT OUT OUT OUT OUT")
pcell = stick("prow", p=pstrip, ports="VDD d1 d2 OUT",
              ntracks=4, wn=0.0, wp=4.0, l=1.0)
pref = c.place(pcell, above=nref, name="PROW")

# n-well under the PMOS row
nw = c.rect("nwell", inside=pref.bbox, inflate=(nwell_en, nwell_en), net="VDD")

# ================= guard rings (good practice) =================
grn = c.guard_ring("ptap", around=nref, net="VSS", space=0.6)
grp = c.guard_ring("ntap", around=pref, net="VDD", space=0.6)

# ================= compensation network =================
if has_res and has_cap:
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(0, 0), nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(0, 0), nets=("x", "OUT"))
    c.place(cc, right_of=rz, space=1.0)
    cb = c.rect(c1, x0=cc.bottom_pad.left, x1=cc.bottom_pad.right,
                y0=cc.bottom_pad.bottom - 0.6, y1=cc.bottom_pad.top, net="OUT")
    c.via(c0, c1, at=cc.bottom_pad, net="OUT")
    rza, rzb = rz.a, rz.b
else:
    # freepdk45 fallback: RZ -> M9 (nfet triode, gate=VDD), CC -> MC (nfet cap, gate=OUT)
    m9 = c.mos("nmos", w=2.0, l=1.0, nf=1, gates="VDD", sd=("d2", "x"), at=(0, 0))
    mc = c.mos("nmos", w=20.0, l=1.0, nf=1, gates="OUT", sd=("x", "x"), at=(0, 0))
    c.place(mc, right_of=m9, space=1.0)
    rza, rzb = m9.sd[0], mc.sd[0]

# ================= routing =================
r = Router(c, v=c2, h=c3, pin_layer=c1)

r.add("VSS", nref.pin("VSS"), grn.straps[0])
r.add("VDD", pref.pin("VDD"), grp.straps[0])
r.add("IB", nref.pin("IB"))
r.add("INN", nref.pin("INN"))
r.add("INP", nref.pin("INP"))
r.add("tail", nref.pin("tail"))
r.add("d1", nref.pin("d1"), pref.pin("d1"))
r.add("d2", nref.pin("d2"), pref.pin("d2"), rza)
r.add("x", rzb)
r.add("OUT", nref.pin("OUT"), pref.pin("OUT"), cb)

try:
    r.run()
except Exception:
    r.add("d2", nref.pin("d2"), pref.pin("d2"), rza)
    r.add("OUT", nref.pin("OUT"), pref.pin("OUT"), cb)
    r.run()

# ================= ports =================
c.port("INP", on=nref.pin("INP"), dir="in")
c.port("INN", on=nref.pin("INN"), dir="in")
c.port("IB", on=nref.pin("IB"), dir="in")
c.port("OUT", on=cb, dir="out")
c.port("VDD", on=pref.pin("VDD"))
c.port("VSS", on=nref.pin("VSS"))

TOP = c
```