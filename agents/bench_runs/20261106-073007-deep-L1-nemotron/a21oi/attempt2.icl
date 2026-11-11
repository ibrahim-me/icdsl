pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  # Gate order A2, A1, B1 works for n-row without breaks:
  #   n-row: VGND - A2 - n1 - A1 - Y - B1 - VGND
  # p-row needs a diffusion break between A1 and B1:
  #   p-left:  VPWR - A2 - n2 - A1 - VPWR
  #   p-right: n2 - B1 - Y   (n2 islands joined by route)
  dnw = 0.265 + L + 0.39 + L + 0.80 + L + 0.265   # end contacts + gaps + gates + break
  nd  = rect diff w=dnw h=WN cx=cell.cx above=ptap
  pdl = rect diff w=(0.265 + L + 0.39 + L + 0.265) h=WP cx=(cell.cx - (0.80 + L) / 2) below=ntap
  pdr = rect diff w=(0.265 + L + 0.265) h=WP cx=(cell.cx + (0.265 + L + 0.80) / 2) below=ntap
  nim = enclose nd nsdm
  pim = enclose [pdl, pdr] psdm

  # ---- gates (same order both rows: A2, A1, B1) ----
  ga2 = cross [nd, pdl, pdr] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pdl] poly w=L left=(ga2.right + 0.39)
  gb1 = cross [nd, pdr] poly w=L left=(pdr.left + 0.265)

  # ---- diffusion contacts ----
  # n row: VGND(left), n1, Y, VGND(right)
  sn  = array licon in=nd left_of=ga2
  dn1 = array licon in=nd between=[ga2, ga1] net=n1
  dny = array licon in=nd between=[ga1, gb1] net=Y
  sn2 = array licon in=nd right_of=gb1
  # p-left row: VPWR(left), n2, VPWR(right)
  spl = array licon in=pdl left_of=ga2
  dn2l= array licon in=pdl between=[ga2, ga1] net=n2
  spr = array licon in=pdl right_of=ga1
  # p-right row: n2(left), Y(right)
  dn2r= array licon in=pdr left_of=gb1 net=n2
  dpy = array licon in=pdr right_of=gb1 net=Y
  snl = enclose sn li
  dn1l= enclose dn1 li
  dnyl= enclose dny li
  sn2l= enclose sn2 li
  spll= enclose spl li
  dn2ll= enclose dn2l li
  sprl= enclose spr li
  dn2rl= enclose dn2r li
  dpyl= enclose dpy li

  # supply straps
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=sn2l to=vgnd_li
  pwr = strap li from=spll to=vpwr_li
  pwr2= strap li from=sprl to=vpwr_li

  # internal nets
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y  layers=m1,m2

  # ---- gate contacts ----
  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dnyl.top + 0.25, sn2l.top + 0.25)
  gca = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gcb = contact licon cx=(ga1.cx + 0.1) bottom=cb
  gcc = contact licon cx=(gb1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A2
  ab  = enclose gcb li net=A1
  ac  = enclose gcc li net=B1

  well y=((nd.top + 0.34 + pdl.bottom - 0.18) / 2)

  # ---- ports ----
  a2m = contact mcon in=aa
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=ab
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=ac
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=dnyl
  yp  = enclose ym m1 by=0.06 net=Y
  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port Y  out on=yp
end
