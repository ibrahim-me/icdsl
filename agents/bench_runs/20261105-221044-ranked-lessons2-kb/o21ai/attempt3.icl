pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  endc = 0.265
  midc = 0.40                      # gate edge gap; keeps poly pads >= 0.21 apart for all L
  ndw  = endc + L + midc + L + midc + L + endc

  nd  = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga = cross [nd, pd] poly w=L left=(nd.left + endc)
  gb = cross [nd, pd] poly w=L left=(ga.right + midc)
  gc = cross [nd, pd] poly w=L left=(gb.right + midc)

  sn2 = array licon in=nd left_of=ga
  svn = array licon in=nd between=[ga, gb]
  sn2b= array licon in=nd between=[gb, gc]
  sy  = array licon in=nd right_of=gc
  sn2l = enclose sn2 li net=n2
  sn2bl = enclose sn2b li net=n2
  svnl = enclose svn li
  gnd = strap li from=svnl to=vgnd_li
  syl = enclose sy li net=Y

  ppw = array licon in=pd left_of=ga
  pn1 = array licon in=pd between=[ga, gb]
  py  = array licon in=pd between=[gb, gc]
  ppw2= array licon in=pd right_of=gc
  ppwl = enclose ppw li
  ppw2l = enclose ppw2 li
  pwr1 = strap li from=ppwl to=vpwr_li
  pwr2 = strap li from=ppw2l to=vpwr_li
  pyl = enclose py li net=Y
  pn1l = enclose pn1 li net=n1

  route n2 layers=m1,m2
  route Y layers=m1,m2

  cb = max(nd.top + 0.19, sn2l.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A1
  bb  = enclose gcb li net=A2
  cc  = enclose gcc li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=aa
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=bb
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=cc
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=pyl
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
