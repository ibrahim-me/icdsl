pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  endc = 0.265          # diffusion end column with a contact
  midc = 0.28           # diffusion column between two gates with a contact
  ndw  = endc + L + midc + L + midc + L + endc   # 3*L + 2*endc + 2*midc

  nd  = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # common gate order (left to right): A1, A2, B1
  # n-row: n2 | A1 | VGND | A2 | n2 | B1 | Y
  # p-row: VPWR | A1 | n1 | A2 | Y | B1 | VPWR
  ga = cross [nd, pd] poly w=L left=(nd.left + endc)            # gate A1
  gb = cross [nd, pd] poly w=L left=(ga.right + midc)           # gate A2
  gc = cross [nd, pd] poly w=L left=(gb.right + midc)           # gate B1

  sn2 = array licon in=nd left_of=ga            # n2 column (left end)
  svn = array licon in=nd between=[ga, gb]      # VGND column
  sn2b= array licon in=nd between=[gb, gc]      # n2 column (right of A2)
  sy  = array licon in=nd right_of=gc           # Y column (right end)
  sn2l = enclose [sn2, sn2b] li net=n2
  svnl = enclose svn li
  gnd = strap li from=svnl to=vgnd_li
  syl = enclose sy li net=Y

  ppw = array licon in=pd left_of=ga            # VPWR column (left end)
  pn1 = array licon in=pd between=[ga, gb]      # n1 column
  py  = array licon in=pd between=[gb, gc]      # Y column
  ppw2= array licon in=pd right_of=gc           # VPWR column (right end)
  ppwl = enclose [ppw, ppw2] li
  pwr1 = strap li from=ppw to=vpwr_li
  pwr2 = strap li from=ppw2 to=vpwr_li
  pyl = enclose py li net=Y
  pn1l = enclose pn1 li net=n1

  route n2 layers=m1,m2                         # joins the two n2 diffusion columns
  route Y layers=m1,m2                          # joins n-row Y to p-row Y

  cb = max(nd.top + 0.19, snl is sn2l ? sn2l.top + 0.25 : 0, sn2l.top + 0.25)
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
