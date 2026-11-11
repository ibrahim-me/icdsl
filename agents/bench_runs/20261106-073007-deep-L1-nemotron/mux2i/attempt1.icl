pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # ---- diffusion rows (5 gates: S, A0, A1, n1, S) ----
  dw  = 5*L + 4*0.80 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # ---- gates: same order in both rows ----
  g1  = cross [nd, pd] poly w=L left=(nd.left + 0.265)        # S
  g2  = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))   # A0
  g3  = cross [nd, pd] poly w=L left=(g2.right + max(0.28, 0.54 - L))   # A1
  g4  = cross [nd, pd] poly w=L left=(g3.right + max(0.21, 0.54 - L))   # n1 (series node, no contact between)
  g5  = cross [nd, pd] poly w=L left=(g4.right + max(0.28, 0.54 - L))   # S

  # ---- diffusion contacts ----
  # n row: M3(s=n3,d=VGND) | M6(s=VGND,d=n1) | M5(s=VGND,d=n5) | M8(s=n3,d=Y) | M9(s=Y,d=n5)
  sn3 = array licon in=nd left_of=g1
  dvg = array licon in=nd right_of=g1
  sn1 = array licon in=nd left_of=g4
  dn5 = array licon in=nd right_of=g4
  sY  = array licon in=nd left_of=g5
  dn5b= array licon in=nd right_of=g5

  # p row: M0(s=VPWR,d=n1) | M2(s=Y,d=n2) | M7(s=n4,d=Y) | M4(s=VPWR,d=n4) | M1(s=n2,d=VPWR)
  svp = array licon in=pd left_of=g1
  dn1 = array licon in=pd right_of=g1
  sYp = array licon in=pd left_of=g2
  dn2 = array licon in=pd right_of=g2
  sn4 = array licon in=pd left_of=g3
  dYp = array licon in=pd right_of=g3
  svp2= array licon in=pd left_of=g4
  dn4 = array licon in=pd right_of=g4
  sn2 = array licon in=pd left_of=g5
  dvp = array licon in=pd right_of=g5

  sn3l = enclose sn3 li
  dvgl = enclose dvg li net=VGND
  sn1l = enclose sn1 li
  dn5l = enclose dn5 li net=n5
  sYl  = enclose sY li net=Y
  dn5bl= enclose dn5b li net=n5

  svpl = enclose svp li net=VPWR
  dn1l = enclose dn1 li net=n1
  sYpl = enclose sYp li net=Y
  dn2l = enclose dn2 li net=n2
  sn4l = enclose sn4 li net=n4
  dYpl = enclose dYp li net=Y
  svp2l= enclose svp2 li net=VPWR
  dn4l = enclose dn4 li net=n4
  sn2l = enclose sn2 li net=n2
  dvpl = enclose dvp li net=VPWR

  # ---- supply straps ----
  gnd = strap li from=dvgl to=vgnd_li
  pwr1 = strap li from=svpl to=vpwr_li
  pwr2 = strap li from=svp2l to=vpwr_li

  # ---- internal nets: n1, n2, n4 ----
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2

  # ---- output Y: n and p drains don't line up ----
  route Y layers=m1,m2

  # ---- gate contacts ----
  cb = max(nd.top + 0.19, sn3l.top + 0.25, dvgl.top + 0.25, sn1l.top + 0.25, dn5l.top + 0.25, sYl.top + 0.25, dn5bl.top + 0.25)
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb
  gc2 = contact licon cx=(g2.cx - 0.13) bottom=cb
  gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb
  gc4 = contact licon cx=(g4.cx - 0.13) bottom=cb
  gc5 = contact licon cx=(g5.cx - 0.13) bottom=cb

  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gp3 = enclose gc3 poly by=minx
  gp4 = enclose gc4 poly by=minx
  gp5 = enclose gc5 poly by=minx
  gn  = enclose [gc1, gc2, gc3, gc4, gc5] npc

  sA  = enclose gc1 li net=S
  sA0 = enclose gc2 li net=A0
  sA1 = enclose gc3 li net=A1
  sn1g= enclose gc4 li net=n1
  sS2 = enclose gc5 li net=S

  # ---- well ----
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---- ports ----
  am  = contact mcon in=sA
  ap  = enclose am m1 by=0.06 net=S
  a0m = contact mcon in=sA0
  a0p = enclose a0m m1 by=0.06 net=A0
  a1m = contact mcon in=sA1
  a1p = enclose a1m m1 by=0.06 net=A1
  ym  = contact mcon in=dYpl
  yp  = enclose ym m1 by=0.06 net=Y

  port S in  on=ap
  port A0 in on=a0p
  port A1 in on=a1p
  port Y out on=yp
end