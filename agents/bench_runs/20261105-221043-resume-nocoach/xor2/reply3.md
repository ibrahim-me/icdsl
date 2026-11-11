```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=14 height=H
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

  pitch = max(0.54, L + 0.28)      # gate-centre pitch: 0.33 pad + 0.21 space
  endc  = 0.265                    # end contact to diff edge
  ndw   = 2*endc + 5*L + 4*pitch
  nd    = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd    = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim   = enclose nd nsdm
  pim   = enclose pd psdm

  # n-row gates: A B n1 B A  (M0 M1 M2 M7 M9), contact column in every gap
  ga  = cross nd poly w=L left=(nd.left + endc)
  gb1 = cross nd poly w=L left=(ga.right + pitch)
  gn1 = cross nd poly w=L left=(gb1.right + pitch)
  gb2 = cross nd poly w=L left=(gn1.right + pitch)
  ga2 = cross nd poly w=L left=(gb2.right + pitch)

  sn   = array licon in=nd left_of=ga
  dn1  = array licon in=nd right_of=ga
  dn2  = array licon in=nd right_of=gb1
  dn3  = array licon in=nd right_of=gn1
  dn4  = array licon in=nd right_of=gb2
  se   = array licon in=nd right_of=ga2
  snl  = enclose sn li
  dn1l = enclose dn1 li net=n1
  dn2l = enclose dn2 li net=VGND
  dn3l = enclose dn3 li net=X
  dn4l = enclose dn4 li net=n4
  sel  = enclose se li
  gnd  = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dn2l to=vgnd_li
  gnd3 = strap li from=sel to=vgnd_li

  # p-row gates: B A A B n1  (M3 M4 M6 M5 M8), contact column in every gap
  gpb = cross pd poly w=L left=(pd.left + endc)
  gpa = cross pd poly w=L left=(gpb.right + pitch)
  gpw = cross pd poly w=L left=(gpa.right + pitch)
  gpa2= cross pd poly w=L left=(gpw.right + pitch)
  gpn1= cross pd poly w=L left=(gpa2.right + pitch)

  sp   = array licon in=pd left_of=gpb
  dn2p = array licon in=pd right_of=gpb
  dpwr = array licon in=pd right_of=gpa
  dn3p = array licon in=pd right_of=gpw
  dn1p = array licon in=pd right_of=gpa2
  dx   = array licon in=pd right_of=gpn1
  spl  = enclose sp li
  dn2pl= enclose dn2p li net=n2
  dpwrl= enclose dpwr li net=VPWR
  dn3pl= enclose dn3p li net=n3
  dn1pl= enclose dn1p li net=n1
  dxl  = enclose dx li net=X
  pwr  = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dpwrl to=vpwr_li

  # gate contacts: n-row low (cbn), p-row high (cbp) so pads never overlap
  cbn = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25, dn4l.top + 0.25, sel.top + 0.25)
  cbp = pd.bottom - 0.19 - 0.17
  gca  = contact licon cx=ga.cx  bottom=cbn
  gcb1 = contact licon cx=gb1.cx bottom=cbn
  gcn1 = contact licon cx=gn1.cx bottom=cbn
  gcb2 = contact licon cx=gb2.cx bottom=cbn
  gca2 = contact licon cx=ga2.cx bottom=cbn
  gpb_c = contact licon cx=gpb.cx bottom=cbp
  gpa_c = contact licon cx=gpa.cx bottom=cbp
  gpw_c = contact licon cx=gpw.cx bottom=cbp
  gpa2_c= contact licon cx=gpa2.cx bottom=cbp
  gpn1_c= contact licon cx=gpn1.cx bottom=cbp

  gpc = enclose [gca, gcb1, gcn1, gcb2, gca2] poly by=minx
  gnc = enclose [gca, gcb1, gcn1, gcb2, gca2] npc
  gpp = enclose [gpb_c, gpa_c, gpw_c, gpa2_c, gpn1_c] poly by=minx
  gnpc= enclose [gpb_c, gpa_c, gpw_c, gpa2_c, gpn1_c] npc

  aa  = enclose gca  li net=A
  bb1 = enclose gcb1 li net=B
  nn1 = enclose gcn1 li net=n1
  bb2 = enclose gcb2 li net=B
  aa2 = enclose gca2 li net=A
  pbb = enclose gpb_c li net=B
  paa = enclose gpa_c li net=A
  paa2= enclose gpa2_c li net=A
  pnn1= enclose gpn1_c li net=n1

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
```