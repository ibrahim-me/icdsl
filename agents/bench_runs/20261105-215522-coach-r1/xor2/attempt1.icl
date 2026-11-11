pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  gapc = max(0.28, 0.54 - L)      # gap with contact column between gates
  gaps = max(0.21, 0.54 - L)      # series gap, no contact column
  ndw  = 2*0.265 + 5*L + 4*gapc + gaps
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # gate order left to right: A, B, A, B, n1  (crosses both rows)
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb1 = cross [nd, pd] poly w=L left=(ga.right + gapc)
  ga2 = cross [nd, pd] poly w=L left=(gb1.right + gapc)
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + gapc)
  gn1 = cross [nd, pd] poly w=L left=(gb2.right + gapc)

  # n row: VGND | A | n1 | B | VGND | A | n4(series) | B | X | n1 | VGND
  sn   = array licon in=nd left_of=ga
  dn1  = array licon in=nd right_of=ga
  dn2  = array licon in=nd right_of=gb1
  dn4  = array licon in=nd right_of=ga2
  dnx  = array licon in=nd right_of=gb2
  snl  = enclose sn li
  dn1l = enclose dn1 li net=n1
  dn2l = enclose dn2 li net=VGND
  dn4l = enclose dn4 li net=n4
  dnxl = enclose dnx li net=X
  gnd  = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dn2l to=vgnd_li
  gnd3 = strap li from=dnxl to=vgnd_li

  # p row island 1: VPWR | A | n2 | B | VPWR | A | n3(series) | B | n1
  pd1  = rect diff w=ndw h=WP left=pd.left right=(gn1.left - gaps) below=ntap
  pim1 = enclose pd1 psdm
  gpb  = cross [nd, pd1] poly w=L left=(pd1.left + 0.265)
  gpa  = cross [nd, pd1] poly w=L left=(gpb.right + gapc)
  gpw  = cross [nd, pd1] poly w=L left=(gpa.right + gapc)
  gpa2 = cross [nd, pd1] poly w=L left=(gpw.right + gaps)
  gpn1 = cross [nd, pd1] poly w=L left=(gpa2.right + gapc)

  sp   = array licon in=pd1 left_of=gpb
  dn2p = array licon in=pd1 right_of=gpb
  dpwr = array licon in=pd1 right_of=gpa
  dn3p = array licon in=pd1 right_of=gpw
  dn1p = array licon in=pd1 right_of=gpa2
  spl  = enclose sp li
  dn2pl= enclose dn2p li net=n2
  dpwrl= enclose dpwr li net=VPWR
  dn3pl= enclose dn3p li net=n3
  dn1pl= enclose dn1p li net=n1
  pwr  = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dpwrl to=vpwr_li

  # p row island 2 (under n1 gate only): X | n1 | n2
  pd2  = rect diff w=(L + 0.53) h=WP cx=gn1.cx below=ntap
  pim2 = enclose pd2 psdm
  gn2  = cross [nd, pd2] poly w=L left=(gn1.left + 0.265)
  dxp  = array licon in=pd2 left_of=gn2
  dn2q = array licon in=pd2 right_of=gn2
  dxpl = enclose dxp li net=X
  dn2ql= enclose dn2q li net=n2

  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn4l.top + 0.25, dnxl.top + 0.25)
  gca  = contact licon cx=ga.cx  bottom=cb
  gcb1 = contact licon cx=gb1.cx bottom=cb
  gca2 = contact licon cx=ga2.cx bottom=cb
  gcb2 = contact licon cx=gb2.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb

  gpc = enclose [gca, gcb1, gca2, gcb2, gcn1] poly by=minx
  gnc = enclose [gca, gcb1, gca2, gcb2, gcn1] npc

  aa  = enclose gca  li net=A
  bb1 = enclose gcb1 li net=B
  aa2 = enclose gca2 li net=A
  bb2 = enclose gcb2 li net=B
  nn1 = enclose gcn1 li net=n1

  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route X layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb1
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=dxl
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
