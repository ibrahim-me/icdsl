pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=10 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # ---------- diffusion rows ----------
  ggap = max(0.28, 0.54 - L)          # gate centre pitch >= 0.54 so gate-contact li pads clear
  dw   = 4*L + 3*ggap + 2*0.265
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # ---------- one poly line per input, crossing both rows ----------
  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)        # A1
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + ggap)       # A2
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + ggap)       # B2
  gb1 = cross [nd, pd] poly w=L left=(gb2.right + ggap)       # B1

  # ---------- p-row contacts ----------
  pp1 = array licon in=pd left_of=ga1
  pn1 = array licon in=pd between=[ga1, ga2] net=n1
  pp2 = array licon in=pd between=[ga2, gb2] net=Y
  pn2 = array licon in=pd between=[gb2, gb1] net=n2
  pp4 = array licon in=pd right_of=gb1

  ppl  = enclose pp1 li
  pn1l = enclose pn1 li net=n1
  ppl2 = enclose pp2 li net=Y
  pn2l = enclose pn2 li net=n2
  ppl4 = enclose pp4 li

  vpwr1 = strap li from=ppl to=vpwr_li
  vpwr2 = strap li from=ppl4 to=vpwr_li

  # ---------- n-row contacts ----------
  np0 = array licon in=nd left_of=ga1
  nn1 = array licon in=nd between=[ga1, ga2] net=n3
  np2 = array licon in=nd between=[ga2, gb2] net=Y
  nn3 = array licon in=nd between=[gb2, gb1] net=n3
  np4 = array licon in=nd right_of=gb1

  npl0 = enclose np0 li
  nn1l = enclose nn1 li net=n3
  npl2 = enclose np2 li net=Y
  nn3l = enclose nn3 li net=n3
  npl4 = enclose np4 li

  gnd1 = strap li from=npl0 to=vgnd_li
  gnd2 = strap li from=npl4 to=vgnd_li

  # n3 is split into two columns; join on m1/m2 so no li crosses the Y column
  n3ma = contact mcon in=nn1l
  n3pa = enclose n3ma m1 by=0.06 net=n3
  n3mb = contact mcon in=nn3l
  n3pb = enclose n3mb m1 by=0.06 net=n3
  route n3 layers=m1,m2

  # Y: n-row and p-row Y columns line up -> single vertical li strap
  ys = strap li from=npl2 to=ppl2 net=Y

  # ---------- gate contacts (one per input line, bottom from n-row items only) ----------
  cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)

  gc1 = contact licon cx=ga1.cx bottom=cb
  gc2 = contact licon cx=ga2.cx bottom=cb
  gc3 = contact licon cx=gb2.cx bottom=cb
  gc4 = contact licon cx=gb1.cx bottom=cb

  gpp = enclose [gc1, gc2, gc3, gc4] poly by=minx
  gnp = enclose [gc1, gc2, gc3, gc4] npc

  a1  = enclose gc1 li net=A1
  a2  = enclose gc2 li net=A2
  b2  = enclose gc3 li net=B2
  b1  = enclose gc4 li net=B1

  route A1 layers=m1,m2
  route A2 layers=m1,m2
  route B1 layers=m1,m2
  route B2 layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------- ports on met1 ----------
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=npl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end
