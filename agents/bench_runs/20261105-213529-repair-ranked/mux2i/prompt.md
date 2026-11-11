Design the standard cell `mux2i`: Y = !(S ? A1 : A0).
Inputs: A0, A1, S; output: Y; internal nets: n1, n2, n3, n4, n5.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y
  <your geometry>
  port A0 in on=<a met1 shape>
  port A1 in on=<a met1 shape>
  port S in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

This layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. Find the problem and fix it (keep everything else):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=11 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # stick plan (gate order S S A0 A1 n1; (net) = series node, no contact; | = break)
  #   p: n1 [S] VPWR [S] (n2) [A0] Y [A1] (n4) [n1] VPWR |
  #   n: n3 [S] VGND [S] n1 | n1 n5 [A0] Y [A1] n3 | n3 VGND [n1] n5 |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 5*L + max(0.28, 0.54 - L) + max(0.80, 0.54 - L) + max(0.28, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A0
  g4 = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g5 = rect poly w=L left=(g4.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  nd3 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=n3
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n1
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=n5
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=Y
  c6 = array licon in=nd2 right_of=g4
  c6l = enclose c6 li net=n3
  c7 = array licon in=nd3 left_of=g5
  c7l = enclose c7 li net=VGND
  c7s = strap li from=c7l to=vgnd_li
  c8 = array licon in=nd3 right_of=g5
  c8l = enclose c8 li net=n5
  c9 = array licon in=pd1 left_of=g1
  c9l = enclose c9 li net=n1
  c10 = array licon in=pd1 right_of=g1
  c10l = enclose c10 li net=VPWR
  c10s = strap li from=c10l to=vpwr_li
  c11 = array licon in=pd1 right_of=g3
  c11l = enclose c11 li net=Y
  c12 = array licon in=pd1 right_of=g5
  c12l = enclose c12 li net=VPWR
  c12s = strap li from=c12l to=vpwr_li
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=S
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=S
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=A0
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=A1
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=n1
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc
  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  a0m = contact mcon in=gl3
  a0p = enclose a0m m1 by=0.06 net=A0
  port A0 in on=a0p
  a1m = contact mcon in=gl4
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  sm = contact mcon in=gl1
  sp = enclose sm m1 by=0.06 net=S
  port S in on=sp
  port Y out                       # pin goes on the routed met1 of Y
  route n3 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
  route S layers=m1,m2 prefer=m2
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [c3l (line 40), nd1 (line 28)] | [c9l (line 53), pd1 (line 31)] | [g5 (line 27), gl5 (line 77), gp5 (line 76)] - join them (strap / shared metal / `route n1`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.