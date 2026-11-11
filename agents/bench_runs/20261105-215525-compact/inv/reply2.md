```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=3 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  span = 0.53 + L
  x0 = cell.cx - span/2
  g = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  nd = rect diff xspan=(g.left - 0.265, g.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g.left - 0.265, g.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm
  c1 = array licon in=nd left_of=g
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd right_of=g
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=pd left_of=g
  c3l = enclose c3 li net=Y
  c4 = array licon in=pd right_of=g
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  cb = max(nd.top + 0.19, c1l.top + 0.25, c2l.top + 0.25)
  gc = contact licon cx=(g.cx + 0.13) bottom=cb
  gp = enclose gc poly by=minx
  gl = enclose gc li net=A
  gn = enclose [gc] npc
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  am = contact mcon in=gl
  ap = enclose am m1 by=0.06 net=A
  ym = contact mcon in=c1l
  yp = enclose ym m1 by=0.06 net=Y
  port A in on=ap
  port Y out on=yp
end
```