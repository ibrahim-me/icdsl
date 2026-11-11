Design the standard cell `or2`: X = A | B (NOR2 + inverter).
Inputs: A, B; output: X; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=<columns, your choice> height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port X out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

This layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. Find the problem and fix it (keep everything else):
```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=7 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # stick plan (gate order A B n2; (net) = series node, no contact; | = break)
  #   p: VPWR [A] (n1) [B] n2 | n2 X [n2] VPWR |
  #   n: VGND [A] n2 [B] VGND | VGND X [n2] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n2
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=X
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=pd1 left_of=g1
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd1 right_of=g2
  c7l = enclose c7 li net=n2
  c8 = array licon in=pd2 left_of=g3
  c8l = enclose c8 li net=X
  c9 = array licon in=pd2 right_of=g3
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li
  cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n2
  gn = enclose [gc1, gc2, gc3] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port X out                       # pin goes on the routed met1 of X
  route n2 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 30 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* g2 (line 20: `g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B`) - in 24 of 30 errors: poly.2 x12, licon.11 x5, met1.2 x4, diff/tap.2 x2
    g2 spans x 1.140..1.290, y 0.285..2.435 um
    licon.11: g2 [poly] vs c2 (line 31) [licon x 0.995..1.165, y 0.540..0.710]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
* gc2 (line 55: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (bm, bp, gl2, gp2) - in 12 of 30 errors: poly.2 x7, met1.2 x4, mcon.2 x1
    gc2 spans x 1.130..1.300, y 1.095..1.265 um
    its position uses cb (line 51: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule met1.2: two met1 shapes closer than 0.14 um
* nd1 (line 22: `nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)`) - in 11 of 30 errors: licon.11 x5, poly.2 x4, diff/tap.2 x2
    nd1 spans x 0.525..1.555, y 0.415..0.835 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc1 (line 52: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (am, ap, gl1, gp1) - in 9 of 30 errors: met1.2 x4, poly.2 x4, mcon.2 x1
    gc1 spans x 0.780..0.950, y 1.095..1.265 um
    mcon.2: am [mcon] vs bm (line 66) [mcon x 1.130..1.300, y 1.095..1.265]: gap 0.180 um, rule needs >= 0.19 um (short by 0.010 um)
    met1.2: ap [m1] vs bp (line 67) [m1 x 1.070..1.360, y 1.035..1.325]: gap 0.060 um, rule needs >= 0.14 um (short by 0.080 um)
    poly.2: gp1 [poly] vs gp2 (line 56) [poly x 1.050..1.380, y 1.045..1.315]: gap 0.020 um, rule needs >= 0.21 um (short by 0.190 um)
    its position uses cb (line 51: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule met1.2: two met1 shapes closer than 0.14 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING or2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING or2: port B: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.