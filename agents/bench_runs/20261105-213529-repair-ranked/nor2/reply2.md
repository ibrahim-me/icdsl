The gates reference `nd1`/`pd1` before those diffusions exist. I define the diffusion rows first (using `x0`/`span` directly, so there is no circular dependency), then place the gates as `cross` strips over both rows. The n-diffusion left extension is also fixed from `0.18` to `0.25` (`x0 + 0.015`) to satisfy `poly.7` next to the `left_of=g1` contact column.

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
  nd1 = rect diff xspan=(x0 + 0.015, x0 + span) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(x0, x0 + span) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  g1 = cross [nd1, pd1] poly w=L left=(x0 + 0.265)   # gate A
  g2 = cross [nd1, pd1] poly w=L left=(g1.right + max(0.28, 0.54 - L))   # gate B
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