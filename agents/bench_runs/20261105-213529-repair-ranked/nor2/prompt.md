Design the standard cell `nor2`: Y = !(A | B).
Inputs: A, B; output: Y; internal nets: n1.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

This layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. Find the problem and fix it (keep everything else):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=5 height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1

  # stick plan (gate order A B; (net) = series node, no contact; | = break)
  #   p: VPWR [A] (n1) [B] Y |
  #   n: VGND [A] Y [B] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 2*L + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  nd1 = rect diff xspan=(g1.left - 0.18, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=Y
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=pd1 left_of=g1
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  c5 = array licon in=pd1 right_of=g2
  c5l = enclose c5 li net=Y
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gn = enclose [gc1, gc2] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port Y out                       # pin goes on the routed met1 of Y
  route Y layers=m1,m2 prefer=m2
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 5 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* c1 (line 23: `c1 = array licon in=nd1 left_of=g1`) and shapes built from it (c1l) - in 5 of 5 errors: poly.7 x3, licon.1 x1, licon.5a x1
    c1 spans x 0.580..0.750, y 0.575..0.745 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* c1s (line 25: `c1s = strap li from=c1l to=vgnd_li`) - in 5 of 5 errors: poly.7 x3, licon.1 x1, licon.5a x1
    c1s spans x 0.580..0.750, y -0.085..0.825 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* nd1 (line 19: `nd1 = rect diff xspan=(g1.left - 0.18, g2.right + 0.265) yspan=(ny0, ny0 + WN)`) - in 5 of 5 errors: poly.7 x3, licon.1 x1, licon.5a x1
    nd1 spans x 0.625..1.760, y 0.415..0.905 um
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* g1 (line 17: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A`) - in 1 of 5 errors: licon.1 x1
    g1 spans x 0.805..0.955, y 0.285..2.435 um
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses x0 (line 16: `x0 = cell.cx - span/2`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.