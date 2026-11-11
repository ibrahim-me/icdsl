Design the standard cell `o22ai`: Y = !((A1 | A2) & (B1 | B2)).
Inputs: A1, A2, B1, B2; output: Y; internal nets: n1, n2, n3.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3
  <your geometry>
  port A1 in on=<a met1 shape>
  port A2 in on=<a met1 shape>
  port B1 in on=<a met1 shape>
  port B2 in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

This layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. Find the problem and fix it (keep everything else):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=7 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # stick plan (gate order A2 B2 B1 A1; (net) = series node, no contact; | = break)
  #   p: n1 [A2] Y [B2] (n2) [B1] VPWR [A1] n1 |
  #   n: VGND [A2] n3 [B2] Y [B1] n3 [A1] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 4*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B2
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  g4 = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  nd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n3
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=Y
  c4 = array licon in=nd1 right_of=g3
  c4l = enclose c4 li net=n3
  c5 = array licon in=nd1 right_of=g4
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=pd1 left_of=g1
  c6l = enclose c6 li net=n1
  c7 = array licon in=pd1 right_of=g1
  c7l = enclose c7 li net=Y
  c8 = array licon in=pd1 right_of=g3
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li
  c9 = array licon in=pd1 right_of=g4
  c9l = enclose c9 li net=n1
  cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B2
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=A1
  gn = enclose [gc1, gc2, gc3, gc4] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  a1m = contact mcon in=gl4
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon in=gl2
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  port Y out                       # pin goes on the routed met1 of Y
  route n3 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 299 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 26: `pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)`) - in 134 of 150 errors: li.3 x56, poly.7 x28, licon.14 x19, poly.1a x16
    pd1 spans x 0.460..2.760, y 1.555..2.305 um
    licon.14: pd1 [diff] vs c7 (line 43) [licon x 0.930..1.100, y 1.675..2.185]: they overlap by 0.630 um, rule needs >= 0.19 um (short by 0.820 um)
    licon.14: pd1 [diff] vs gc2 (line 54) [licon x 1.255..1.425, y 1.505..1.675]: they overlap by 0.120 um, rule needs >= 0.19 um (short by 0.310 um)
    licon.14: pd1 [diff] vs c8 (line 45) [licon x 2.010..2.180, y 1.675..2.185]: they overlap by 0.630 um, rule needs >= 0.19 um (short by 0.820 um)
    its position uses py1 (line 18: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* gc1 (line 51: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (a2m, a2p, gl1, gp1) - in 41 of 150 errors: li.3 x20, poly.7 x8, licon.14 x5, poly.1a x4
    gc1 spans x 0.715..0.885, y 1.505..1.675 um
    its position uses cb (line 50: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* gc4 (line 60: `gc4 = contact licon cx=g4.cx bottom=cb`) and shapes built from it (a1m, a1p, gl4, gp4) - in 35 of 150 errors: li.3 x15, poly.7 x8, licon.14 x5, poly.1a x4
    gc4 spans x 2.335..2.505, y 1.505..1.675 um
    its position uses cb (line 50: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* g1 (line 21: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2`) - in 30 of 150 errors: li.3 x14, poly.7 x6, poly.1a x4, licon.14 x3
    g1 spans x 0.725..0.875, y 0.285..2.435 um
    its position uses ny0 (line 17: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses x0 (line 20: `x0 = cell.cx - span/2`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.