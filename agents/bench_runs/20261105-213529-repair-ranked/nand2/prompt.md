Design the standard cell `nand2`: Y = !(A & B).
Inputs: A, B; output: Y; internal nets: n1.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y
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

stdcell nand2 width=5 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # stick plan (gate order A B; (net) = series node, no contact; | = break)
  #   p: VPWR [A] Y [B] VPWR |
  #   n: Y [A] (n1) [B] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 2*L + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd1 right_of=g2
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=pd1 left_of=g1
  c3l = enclose c3 li net=VPWR
  c3s = strap li from=c3l to=vpwr_li
  c4 = array licon in=pd1 right_of=g1
  c4l = enclose c4 li net=Y
  c5 = array licon in=pd1 right_of=g2
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25)
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
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 36 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* g2 (line 18: `g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B`) - in 30 of 36 errors: poly.2 x13, licon.11 x10, met1.2 x4, diff/tap.2 x2
    g2 spans x 1.155..1.305, y 0.285..2.435 um
    licon.11: g2 [poly] vs c4 (line 31) [licon x 1.010..1.180, y 1.675..2.185]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
* pd1 (line 20: `pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)`) - in 17 of 36 errors: licon.11 x10, poly.2 x5, diff/tap.2 x2
    pd1 spans x 0.540..1.570, y 1.555..2.305 um
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* c4 (line 31: `c4 = array licon in=pd1 right_of=g1`) and shapes built from it (c4l) - in 15 of 36 errors: licon.11 x10, poly.2 x3, diff/tap.2 x2
    c4 spans x 1.010..1.180, y 1.675..2.185 um
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc2 (line 40: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (bm, bp, gl2, gp2) - in 12 of 36 errors: poly.2 x7, met1.2 x4, mcon.2 x1
    gc2 spans x 1.145..1.315, y 1.095..1.265 um
    its position uses cb (line 36: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule met1.2: two met1 shapes closer than 0.14 um
WARNING nand2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.