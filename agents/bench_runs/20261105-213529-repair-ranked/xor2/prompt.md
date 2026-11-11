Design the standard cell `xor2`: X = A ^ B.
Inputs: A, B; output: X; internal nets: n1, n2, n3, n4.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=<columns, your choice> height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4
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
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  # stick plan (gate order A B A B n1; (net) = series node, no contact; | = break)
  #   p: VPWR [A] n2 [B] VPWR [A] (n3) [B] n1 | n1 X [n1] n2 |
  #   n: VGND [A] n1 [B] VGND [A] (n4) [B] X [n1] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 5*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L) + max(0.21, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g4 = rect poly w=L left=(g3.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g5 = rect poly w=L left=(g4.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  nd1 = rect diff xspan=(g1.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n1
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd1 right_of=g4
  c4l = enclose c4 li net=X
  c5 = array licon in=nd1 right_of=g5
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=pd1 left_of=g1
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd1 right_of=g1
  c7l = enclose c7 li net=n2
  c8 = array licon in=pd1 right_of=g2
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li
  c9 = array licon in=pd1 right_of=g4
  c9l = enclose c9 li net=n1
  c10 = array licon in=pd2 left_of=g5
  c10l = enclose c10 li net=X
  c11 = array licon in=pd2 right_of=g5
  c11l = enclose c11 li net=n2
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=A
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=n1
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port X out                       # pin goes on the routed met1 of X
  route n1 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
end
```
Its check report:
The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}):
line 88: `route A layers=m1,m2 prefer=m2`
error: stdcell xor2: routing failed: net 'A': pin gl1+ap has no legal access point
hint: relax or drop a constraint, give the router room (place ... gap=, row ... space=1), allow more layers (layers=m1,m2,m3), or route it by hand with 'wire'
Fix it (only use statements and keys from the reference) and return the complete file.