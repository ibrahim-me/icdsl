Design the standard cell `buf`: X = A (two inverters).
Inputs: A; output: X; internal nets: n1.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=<columns, your choice> height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X
  <your geometry>
  port A in on=<a met1 shape>
  port X out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

This layout of the cell was DRC and LVS clean over the whole sweep until ONE edit broke it. Find the problem and fix it (keep everything else):
```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # stick plan (gate order n1 A; (net) = series node, no contact; | = break)
  #   p: X [n1] VPWR [A] n1 |
  #   n: X [n1] VGND [A] n1 |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 2*L + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=X
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n1
  c4 = array licon in=pd1 left_of=g1
  c4l = enclose c4 li net=X
  c5 = array licon in=pd1 right_of=g1
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd1 right_of=g2
  c6l = enclose c6 li net=n1
  cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=n1
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A
  gn = enclose [gc1, gc2] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  am = contact mcon in=gl2
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  port X out                       # pin goes on the routed met1 of X
  route X layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
end
```
Its check report:
The file did not compile (params {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}):
line 51: `route n1 layers=m1,m2 prefer=m2`
error: stdcell buf: routing failed: net 'n1': pin c6l has no legal access point (blocked by ap on m1: 0.000 < 0.140 um)
hint: relax or drop a constraint, give the router room (place ... gap=, row ... space=1), allow more layers (layers=m1,m2,m3), or route it by hand with 'wire'
Fix it (only use statements and keys from the reference) and return the complete file.