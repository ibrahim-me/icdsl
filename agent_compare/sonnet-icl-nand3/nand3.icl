pdk sky130A
param L=0.15 H=2.72 WN=0.49 WP=0.75

stdcell nand3 width=5 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  nd  = rect diff w=1.88 h=WN cx=cell.cx above=ptap
  pd  = rect diff w=1.88 h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.50)
  gc  = cross [nd, pd] poly w=L left=(gb.right + 0.40)

  n0 = array licon in=nd left_of=ga
  n1 = array licon in=nd between=[ga, gb]
  n2 = array licon in=nd between=[gb, gc]
  n3 = array licon in=nd right_of=gc
  p0 = array licon in=pd left_of=ga
  p1 = array licon in=pd between=[ga, gb]
  p2 = array licon in=pd between=[gb, gc]
  p3 = array licon in=pd right_of=gc
  n0l = enclose n0 li
  n1l = enclose n1 li
  n2l = enclose n2 li
  n3l = enclose n3 li
  p0l = enclose p0 li
  p1l = enclose p1 li
  p2l = enclose p2 li
  p3l = enclose p3 li
  gnd = strap li from=n3l to=vgnd_li
  pw1 = strap li from=p1l to=vpwr_li
  pw3 = strap li from=p3l to=vpwr_li
  y0  = strap li from=n0l to=p0l net=Y
  ym2 = contact mcon in=p2l
  ym0 = contact mcon in=p0l
  ymp2 = enclose ym2 m1 by=0.06 net=Y
  ymp0 = enclose ym0 m1 by=0.06 net=Y
  ybar = strap m1 from=ymp0 to=ymp2 net=Y
  port Y out on=ymp0

  # gate contacts, staggered
  cA = contact licon cx=(ga.cx + 0.14) bottom=max(nd.top + 0.19, n1l.top + 0.25)
  cB = contact licon cx=gb.cx bottom=(max(nd.top + 0.19, n1l.top + 0.25))
  cC = contact licon cx=gc.cx bottom=max(nd.top + 0.19, n1l.top + 0.25)
  pA = enclose cA poly by=(0.05, 0.08)
  pB = enclose cB poly by=minx
  pC = enclose cC poly by=minx
  nA = enclose cA npc
  nB = enclose cB npc
  nC = enclose cC npc
  lA = enclose cA li net=A
  lB = enclose cB li net=B
  lC = enclose cC li net=C
  mA = contact mcon in=lA
  mB = contact mcon in=lB
  mC = contact mcon in=lC
  qA = enclose mA m1 by=0.06 net=A
  qB = enclose mB m1 by=0.06 net=B
  qC = enclose mC m1 by=0.06 net=C
  port A in on=qA
  port B in on=qB
  port C in on=qC
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
end
