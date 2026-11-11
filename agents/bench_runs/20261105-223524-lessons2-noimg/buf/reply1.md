```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # two diffusion islands per row: left inverter (gate A), right inverter (gate n1)
  nd1 = rect diff w=(L + 0.53) h=WN cx=(cell.cx - (L + 0.80)/2) above=ptap
  pd1 = rect diff w=(L + 0.53) h=WP cx=(cell.cx - (L + 0.80)/2) below=ntap
  nd2 = rect diff w=(L + 0.53) h=WN cx=(cell.cx + (L + 0.80)/2) above=ptap
  pd2 = rect diff w=(L + 0.53) h=WP cx=(cell.cx + (L + 0.80)/2) below=ntap
  nim1 = enclose nd1 nsdm
  pim1 = enclose pd1 psdm
  nim2 = enclose nd2 nsdm
  pim2 = enclose pd2 psdm

  ga = cross [nd1, pd1] poly w=L
  gn1 = cross [nd2, pd2] poly w=L left=(ga.right + 0.80)

  # n-row contacts
  sn1 = array licon in=nd1 left_of=ga
  dn1 = array licon in=nd1 right_of=ga net=n1
  sn2 = array licon in=nd2 left_of=gn1
  dn2 = array licon in=nd2 right_of=gn1 net=X
  sn1l = enclose sn1 li
  dn1l = enclose dn1 li net=n1
  sn2l = enclose sn2 li
  dn2l = enclose dn2 li net=X

  # p-row contacts
  sp1 = array licon in=pd1 left_of=ga
  dp1 = array licon in=pd1 right_of=ga net=n1
  xp2 = array licon in=pd2 left_of=gn1 net=X
  dp2 = array licon in=pd2 right_of=gn1
  sp1l = enclose sp1 li
  dp1l = enclose dp1 li net=n1
  xp2l = enclose xp2 li net=X
  dp2l = enclose dp2 li

  # supply straps
  gnd1 = strap li from=sn1l to=vgnd_li
  gnd2 = strap li from=sn2l to=vgnd_li
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=dp2l to=vpwr_li

  # gate contacts (cb from n-row items only)
  cb = max(nd1.top + 0.19, sn1l.top + 0.25, dn1l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpn1 = enclose gcn1 poly by=minx
  gna = enclose gca npc
  gnn1 = enclose gcn1 npc
  a_li = enclose gca li net=A
  n1_li = enclose gcn1 li net=n1

  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  # internal net n1: left drains + gate contact
  route n1 layers=m1,m2

  # output X: n-row right source and p-row left source
  route X layers=m1,m2

  # supply straps for output sources (already have gnd/pwr straps above)

  am = contact mcon in=a_li
  ap = enclose am m1 by=0.06 net=A
  xm = contact mcon in=dn2l
  xp = enclose xm m1 by=0.06 net=X
  port A in on=ap
  port X out on=xp
end
```