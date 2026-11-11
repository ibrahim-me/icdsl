The break is the n-diffusion left edge: `nd1` starts only `g1.left - 0.18`, but poly.7 requires diffusion to extend 0.25 beyond the gate (room for the source/drain contact). That shorts the `c1` contact column into the tap/gate area, causing the poly.7 / licon.1 / licon.5a errors. Fix: use the 0.265 end-contact room on both ends of `nd1` (and keep the p-side symmetric), then derive `span` from `L` and the gate gap so it stays clean across the sweep.

```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=6 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # stick plan (gate order A B C; (net) = series node, no contact; | = break)
  #   p: Y [A] VPWR [B] Y [C] VPWR |
  #   n: Y [A] (n2) [B] (n1) [C] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # gate-to-gate gap (>= contact column room, >= 0.54 pitch)
  span = 2*0.265 + 3*L + 2*gap          # end contacts + 3 gates + 2 gaps
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd1 right_of=g3
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=pd1 left_of=g1
  c3l = enclose c3 li net=Y
  c4 = array licon in=pd1 right_of=g1
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  c5 = array licon in=pd1 right_of=g2
  c5l = enclose c5 li net=Y
  c6 = array licon in=pd1 right_of=g3
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  cb = max(nd1.top + 0.19, c1l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=C
  gn = enclose [gc1, gc2, gc3] npc
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  port Y out                       # pin goes on the routed met1 of Y
  route Y layers=m1,m2 prefer=m2
end
```