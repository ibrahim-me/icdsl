pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell nand2 width=10 height=H
  device MNA nmos w=WN l=L d=n1 g=A s=VGND
  device MNB nmos w=WN l=L d=Y g=B s=n1
  device MPA pmos w=WP l=L d=Y g=A s=VPWR
  device MPB pmos w=WP l=L d=Y g=B s=VPWR

  nd_w = 2*L + 0.72
  pd_w = L + 0.53

  nd  = rect diff w=nd_w h=WN x=cell.left+0.2 above=ptap
  pd1 = rect diff w=pd_w h=WP right_of=nd gap=0.27 below=ntap
  pd2 = rect diff w=pd_w h=WP right_of=pd1 gap=0.27 below=ntap

  nim = enclose nd nsdm
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  gA = cross [nd, pd1] poly w=L
  gB = cross [nd, pd2] poly w=L

  sn  = array licon in=nd left_of=gA
  nn  = array licon in=nd right_of=gA left_of=gB gap=min
  dn  = array licon in=nd right_of=gB

  sp1 = array licon in=pd1 left_of=gA
  dp1 = array licon in=pd1 right_of=gA
  sp2 = array licon in=pd2 left_of=gB
  dp2 = array licon in=pd2 right_of=gB

  snl = enclose sn li
  nnl = enclose nn li
  dnl = enclose dn li
  spl1 = enclose sp1 li
  dpl1 = enclose dp1 li
  spl2 = enclose sp2 li
  dpl2 = enclose dp2 li

  gnd = strap li from=snl to=vgnd_li
  yint = strap li from=dnl to=dpl1 net=Y
  yint2 = strap li from=dpl2 to=yint net=Y
  pwr1 = strap li from=spl1 to=vpwr_li
  pwr2 = strap li from=spl2 to=vpwr_li

  gcA = contact licon left_of=gB xspace=0.17 bottom=max(nd.top+0.19, snl.top+0.25, dnl.top+0.25)
  gpA = enclose gcA poly by=minx
  gnA = enclose gcA npc
  aM  = contact mcon in=gcA
  aP  = enclose aM m1 by=0.06 net=A

  gcB = contact licon right_of=gA xspace=0.17 bottom=max(nd.top+0.19, snl.top+0.25, dnl.top+0.25)
  gpB = enclose gcB poly by=minx
  gnB = enclose gcB npc
  bM  = contact mcon in=gcB
  bP  = enclose bM m1 by=0.06 net=B

  ym  = contact mcon in=yint cy=(yint.top - 0.3)
  yP  = enclose ym m1 by=0.06 net=Y

  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  port A in  on=aP
  port B in  on=bP
  port Y out on=yP
end
