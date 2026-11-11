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
  dw = 4*L + 3*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # ---------- p-row: VPWR-M1(A1)-n1-M0(A2)-Y-M2(B2)-n2-M6(B1)-VPWR ----------
  gp1 = cross [nd, pd] poly w=L left=(pd.left + 0.265)          # A1
  gp2 = cross [nd, pd] poly w=L left=(gp1.right + 0.28)         # A2
  gp3 = cross [nd, pd] poly w=L left=(gp2.right + 0.28)         # B2
  gp4 = cross [nd, pd] poly w=L left=(gp3.right + 0.28)         # B1

  pp1 = array licon in=pd left_of=gp1
  pn1 = array licon in=pd between=[gp1, gp2] net=n1
  pp2 = array licon in=pd between=[gp2, gp3] net=Y
  pn2 = array licon in=pd between=[gp3, gp4] net=n2
  pp4 = array licon in=pd right_of=gp4

  ppl  = enclose pp1 li
  pn1l = enclose pn1 li net=n1
  ppl2 = enclose pp2 li net=Y
  pn2l = enclose pn2 li net=n2
  ppl4 = enclose pp4 li

  vpwr1 = strap li from=ppl to=vpwr_li
  vpwr2 = strap li from=ppl4 to=vpwr_li

  # ---------- n-row: VGND-M7(A1)-n3-M4(B1)-Y-M5(B2)-n3-M3(A2)-VGND ----------
  gn1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # A1
  gn2 = cross [nd, pd] poly w=L left=(gn1.right + 0.28)         # B1
  gn3 = cross [nd, pd] poly w=L left=(gn2.right + 0.28)         # B2
  gn4 = cross [nd, pd] poly w=L left=(gn3.right + 0.28)         # A2

  np0 = array licon in=nd left_of=gn1
  nn1 = array licon in=nd between=[gn1, gn2] net=n3
  np2 = array licon in=nd between=[gn2, gn3] net=Y
  nn3 = array licon in=nd between=[gn3, gn4] net=n3
  np4 = array licon in=nd right_of=gn4

  npl0 = enclose np0 li
  nn1l = enclose nn1 li net=n3
  npl2 = enclose np2 li net=Y
  nn3l = enclose nn3 li net=n3
  npl4 = enclose np4 li

  gnd1 = strap li from=npl0 to=vgnd_li
  gnd2 = strap li from=npl4 to=vgnd_li

  # n3 is split into two columns (nn1l, nn3l) separated by the Y column;
  # join them on m1/m2 so no li crosses the Y column
  n3ma = contact mcon in=nn1l
  n3pa = enclose n3ma m1 by=0.06 net=n3
  n3mb = contact mcon in=nn3l
  n3pb = enclose n3mb m1 by=0.06 net=n3
  route n3 layers=m1,m2

  # Y: n-row column npl2 and p-row column ppl2 are vertically aligned -> single li strap
  ys = strap li from=npl2 to=ppl2 net=Y

  # ---------- gate contacts (bottom from n-row items only) ----------
  cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)

  gca = contact licon cx=gp1.cx bottom=cb
  gcb = contact licon cx=gp2.cx bottom=cb
  gcc = contact licon cx=gp3.cx bottom=cb
  gcd = contact licon cx=gp4.cx bottom=cb
  gce = contact licon cx=gn1.cx bottom=cb
  gcf = contact licon cx=gn2.cx bottom=cb
  gcg = contact licon cx=gn3.cx bottom=cb
  gch = contact licon cx=gn4.cx bottom=cb

  gpa = enclose [gca, gcb, gcc, gcd] poly by=minx
  gpb = enclose [gce, gcf, gcg, gch] poly by=minx
  gnpc = enclose [gca, gcb, gcc, gcd, gce, gcf, gcg, gch] npc

  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1
  a1n = enclose gce li net=A1
  b1n = enclose gcf li net=B1
  b2n = enclose gcg li net=B2
  a2n = enclose gch li net=A2

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
