pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=7 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # stick plan (gate order B1 A1 A2; | = diffusion end)
  #   p: Y [B1] VPWR [A1] n1 [A2] Y |
  #   n: Y [B1] n2 [A1] VGND [A2] n2 |
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  gb = cross [nd, pd] poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  ga = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  gc = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  nd = rect diff xspan=(gb.left - 0.265, gc.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(gb.left - 0.265, gc.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # p row: Y | B1 | VPWR | A1 | n1 | A2 | Y
  cp0 = array licon in=pd left_of=gb
  cp0l = enclose cp0 li net=Y
  cp1 = array licon in=pd right_of=gb
  cp1l = enclose cp1 li net=VPWR
  cp1s = strap li from=cp1l to=vpwr_li
  cp2 = array licon in=pd right_of=ga
  cp2l = enclose cp2 li net=n1
  cp3 = array licon in=pd right_of=gc
  cp3l = enclose cp3 li net=Y

  # n row: Y | B1 | n2 | A1 | VGND | A2 | n2
  cn0 = array licon in=nd left_of=gb
  cn0l = enclose cn0 li net=Y
  cn1 = array licon in=nd right_of=gb
  cn1l = enclose cn1 li net=n2
  cn2 = array licon in=nd right_of=ga
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li
  cn3 = array licon in=nd right_of=gc
  cn3l = enclose cn3 li net=n2

  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn3l.top + 0.25)
  gcb = contact licon cx=gb.cx bottom=cb
  gpb = enclose gcb poly by=minx
  glb = enclose gcb li net=B1
  gca = contact licon cx=ga.cx bottom=cb
  gpa = enclose gca poly by=minx
  gla = enclose gca li net=A1
  gcc = contact licon cx=gc.cx bottom=cb
  gpc = enclose gcc poly by=minx
  glc = enclose gcc li net=A2
  gn = enclose [gcb, gca, gcc] npc

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input pins
  a1m = contact mcon in=gla
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=glc
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=glb
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p

  # output Y: n-row cn0l, p-row cp0l and cp3l; internal n2: cn1l and cn3l
  route Y layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  port Y out
end
