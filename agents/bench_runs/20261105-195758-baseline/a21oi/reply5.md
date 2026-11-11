```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=(4*L + 1.62) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.62) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # shared gates cross both diffusion rows only
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(nd.left + L + 0.545)
  gb1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # NMOS row: VGND | n1 | Y | VGND  (gates A2, A1, B1)
  cn0 = array licon in=nd left_of=ga2
  cn1 = array licon in=nd right_of=ga2 left_of=ga1
  cn2 = array licon in=nd right_of=ga1 left_of=gb1
  cn3 = array licon in=nd right_of=gb1
  cn0l = enclose cn0 li net=VGND
  cn1l = enclose cn1 li net=n1
  cn2l = enclose cn2 li net=Y
  cn3l = enclose cn3 li net=VGND

  gndn = strap li from=cn0l to=vgnd_li
  gndn2 = strap li from=cn3l to=vgnd_li

  # PMOS row: VPWR | n2 | VPWR | Y  (gates A1, A2, B1)
  cp0 = array licon in=pd left_of=ga1
  cp1 = array licon in=pd right_of=ga1 left_of=ga2
  cp2 = array licon in=pd right_of=ga2 left_of=gb1
  cp3 = array licon in=pd right_of=gb1
  cp0l = enclose cp0 li net=VPWR
  cp1l = enclose cp1 li net=n2
  cp2l = enclose cp2 li net=VPWR
  cp3l = enclose cp3 li net=Y

  pwr1 = strap li from=cp0l to=vpwr_li
  pwr2 = strap li from=cp2l to=vpwr_li

  route Y layers=m1
  route n2 layers=m1

  # gate contacts in the gap between the rows, pushed outwards so pads clear
  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25,
              cp0l.top + 0.25, cp1l.top + 0.25, cp2l.top + 0.25, cp3l.top + 0.25)

  gca2 = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gpa1 = contact licon cx=(ga1.cx - 0.1) bottom=cb
  gpa4 = contact licon cx=(ga2.cx + 0.1) bottom=cb
  gpa5 = contact licon cx=(ga1.cx + 0.1) bottom=cb
  gcb2 = contact licon cx=(gb1.cx - 0.1) bottom=cb
  gcb3 = contact licon cx=(gb1.cx + 0.1) bottom=cb

  pca2 = enclose gca2 poly by=minx
  ppa1 = enclose gpa1 poly by=minx
  ppa4 = enclose gpa4 poly by=minx
  ppa5 = enclose gpa5 poly by=minx
  ppb2 = enclose gcb2 poly by=minx
  ppb3 = enclose gcb3 poly by=minx

  na2 = enclose [gca2, gpa4] npc
  nb3 = enclose [gcb2, gcb3] npc

  a1  = enclose [gpa1, gpa5] li net=A1
  a2  = enclose [gca2, gpa4] li net=A2
  b1  = enclose [gcb2, gcb3] li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input pins on met1, kept clear of the top vpwr rail
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=cn2l cy=(cn2l.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
```