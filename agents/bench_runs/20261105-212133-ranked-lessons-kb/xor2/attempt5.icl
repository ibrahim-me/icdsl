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

  gapc = max(0.28, 0.54 - L)
  gaps = max(0.21, 0.54 - L)
  ndw  = 2*0.265 + 5*L + 3*gapc + gaps
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # n-row: VGND -A- n1 -B- VGND -n1- X -B- n4 -A- VGND
  ga  = cross nd poly w=L left=(nd.left + 0.265)
  gb1 = cross nd poly w=L left=(ga.right + gapc)
  gn1 = cross nd poly w=L left=(gb1.right + gapc)
  gb2 = cross nd poly w=L left=(gn1.right + gapc)
  ga2 = cross nd poly w=L left=(gb2.right + gaps)

  sn   = array licon in=nd left_of=ga
  dn1  = array licon in=nd right_of=ga
  dn2  = array licon in=nd right_of=gb1
  dn3  = array licon in=nd right_of=gn1
  dn4  = array licon in=nd right_of=gb2
  snl  = enclose sn li
  dn1l = enclose dn1 li net=n1
  dn2l = enclose dn2 li net=VGND
  dn3l = enclose dn3 li net=X
  dn4l = enclose dn4 li net=n4
  gnd  = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dn2l to=vgnd_li

  # p-row: X -n1- n2 -A- VPWR -A- n3 -B- n1 -B- VPWR
  gpn1 = cross pd poly w=L left=(pd.left + 0.265)
  gp4  = cross pd poly w=L left=(gpn1.right + gapc)
  gp6  = cross pd poly w=L left=(gp4.right + gapc)
  gp5  = cross pd poly w=L left=(gp6.right + gaps)
  gp3  = cross pd poly w=L left=(gp5.right + gapc)

  dx   = array licon in=pd left_of=gpn1
  dn2p = array licon in=pd right_of=gpn1
  dpwr = array licon in=pd right_of=gp4
  dn3p = array licon in=pd right_of=gp6
  dn1p = array licon in=pd right_of=gp5
  sp   = array licon in=pd right_of=gp3
  dxl  = enclose dx li net=X
  dn2pl= enclose dn2p li net=n2
  dpwrl= enclose dpwr li net=VPWR
  dn3pl= enclose dn3p li net=n3
  dn1pl= enclose dn1p li net=n1
  spl  = enclose sp li net=VPWR
  pwr  = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dpwrl to=vpwr_li

  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25, dn4l.top + 0.25)
  gca  = contact licon cx=ga.cx  bottom=cb
  gcb1 = contact licon cx=gb1.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gcb2 = contact licon cx=gb2.cx bottom=cb
  gca2 = contact licon cx=ga2.cx bottom=cb
  gpn1_c = contact licon cx=gpn1.cx bottom=cb
  gp4_c  = contact licon cx=gp4.cx  bottom=cb
  gp6_c  = contact licon cx=gp6.cx  bottom=cb
  gp5_c  = contact licon cx=gp5.cx  bottom=cb
  gp3_c  = contact licon cx=gp3.cx  bottom=cb

  gpc = enclose [gca, gcb1, gcn1, gcb2, gca2, gpn1_c, gp4_c, gp6_c, gp5_c, gp3_c] poly by=minx
  gnc = enclose [gca, gcb1, gcn1, gcb2, gca2, gpn1_c, gp4_c, gp6_c, gp5_c, gp3_c] npc

  aa  = enclose gca  li net=A
  bb1 = enclose gcb1 li net=B
  nn1 = enclose gcn1 li net=n1
  bb2 = enclose gcb2 li net=B
  aa2 = enclose gca2 li net=A
  pn1 = enclose gpn1_c li net=n1
  pa4 = enclose gp4_c  li net=A
  pa6 = enclose gp6_c  li net=A
  pb5 = enclose gp5_c  li net=B
  pb3 = enclose gp3_c  li net=B

  route n1 layers=m1,m2
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
