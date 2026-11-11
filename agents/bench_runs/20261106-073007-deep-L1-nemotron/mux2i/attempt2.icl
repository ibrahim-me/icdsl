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

  # ---- gate order (both rows): S, A1, A0, n1, S ----
  # n row: M3(S), M8(A1), M9(A0), M5(n1), M6(S)
  # p row: M0(S), M7(A1), M2(A0), M4(n1), M1(S)
  # gaps: g1-g2: VGND/n3 break(0.80), g2-g3: Y/Y share(0.28), g3-g4: n5/VPWR break(0.80), g4-g5: n4/n2 break(0.80)
  dw  = 2*0.265 + 5*L + 0.80 + 0.28 + 0.80 + 0.80
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  g1  = cross [nd, pd] poly w=L left=(nd.left + 0.265)        # S
  g2  = cross [nd, pd] poly w=L left=(g1.right + 0.80)        # A1
  g3  = cross [nd, pd] poly w=L left=(g2.right + 0.28)        # A0
  g4  = cross [nd, pd] poly w=L left=(g3.right + 0.80)        # n1
  g5  = cross [nd, pd] poly w=L left=(g4.right + 0.80)        # S

  # ---- n row diffusion contacts ----
  # M3: s=n3(left end), d=VGND(between g1-g2)
  # M8: s=n3(between g1-g2), d=Y(between g2-g3)
  # M9: s=Y(between g2-g3), d=n5(between g3-g4)
  # M5: s=VGND(between g3-g4), d=n5(between g4-g5)
  # M6: s=VGND(between g4-g5), d=n1(right end)
  sn3a = array licon in=nd left_of=g1          # n3 (M3.s)
  dvg1 = array licon in=nd right_of=g1         # VGND (M3.d)
  sn3b = array licon in=nd left_of=g2          # n3 (M8.s)
  dYn  = array licon in=nd right_of=g2         # Y (M8.d / M9.s)
  dn5a = array licon in=nd right_of=g3         # n5 (M9.d)
  svg1 = array licon in=nd left_of=g4          # VGND (M5.s)
  dn5b = array licon in=nd right_of=g4         # n5 (M5.d)
  svg2 = array licon in=nd left_of=g5          # VGND (M6.s)
  dn1n = array licon in=nd right_of=g5         # n1 (M6.d)

  sn3al = enclose sn3a li net=n3
  dvgl1 = enclose dvg1 li net=VGND
  sn3bl = enclose sn3b li net=n3
  dYnl  = enclose dYn li net=Y
  dn5al = enclose dn5a li net=n5
  svgl1 = enclose svg1 li net=VGND
  dn5bl = enclose dn5b li net=n5
  svgl2 = enclose svg2 li net=VGND
  dn1nl = enclose dn1n li net=n1

  # ---- p row diffusion contacts ----
  # M0: s=VPWR(left end), d=n1(between g1-g2)
  # M7: s=n4(between g1-g2), d=Y(between g2-g3)
  # M2: s=Y(between g2-g3), d=n2(between g3-g4)
  # M4: s=VPWR(between g3-g4), d=n4(between g4-g5)
  # M1: s=n2(between g4-g5), d=VPWR(right end)
  svp1  = array licon in=pd left_of=g1         # VPWR (M0.s)
  dn1p  = array licon in=pd right_of=g1        # n1 (M0.d)
  sn4   = array licon in=pd left_of=g2         # n4 (M7.s)
  dYp   = array licon in=pd right_of=g2        # Y (M7.d / M2.s)
  dn2   = array licon in=pd right_of=g3        # n2 (M2.d)
  svp2  = array licon in=pd left_of=g4         # VPWR (M4.s)
  dn4   = array licon in=pd right_of=g4        # n4 (M4.d)
  sn2   = array licon in=pd left_of=g5         # n2 (M1.s)
  dvp   = array licon in=pd right_of=g5        # VPWR (M1.d)

  svp1l = enclose svp1 li net=VPWR
  dn1pl = enclose dn1p li net=n1
  sn4l  = enclose sn4 li net=n4
  dYpl  = enclose dYp li net=Y
  dn2l  = enclose dn2 li net=n2
  svp2l = enclose svp2 li net=VPWR
  dn4l  = enclose dn4 li net=n4
  sn2l  = enclose sn2 li net=n2
  dvpl  = enclose dvp li net=VPWR

  # ---- supply straps ----
  gnd1 = strap li from=dvgl1 to=vgnd_li
  gnd2 = strap li from=svgl1 to=vgnd_li
  gnd3 = strap li from=svgl2 to=vgnd_li
  pwr1 = strap li from=svp1l to=vpwr_li
  pwr2 = strap li from=svp2l to=vpwr_li

  # ---- internal nets ----
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2
  route n3 layers=m1,m2
  route n5 layers=m1,m2
  route Y layers=m1,m2

  # ---- gate contacts ----
  cb = max(nd.top + 0.19, sn3al.top + 0.25, dvgl1.top + 0.25, sn3bl.top + 0.25, dYnl.top + 0.25, dn5al.top + 0.25, svgl1.top + 0.25, dn5bl.top + 0.25, svgl2.top + 0.25, dn1nl.top + 0.25)
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

  sS1 = enclose gc1 li net=S
  sA1 = enclose gc2 li net=A1
  sA0 = enclose gc3 li net=A0
  sn1g= enclose gc4 li net=n1
  sS2 = enclose gc5 li net=S

  # ---- well ----
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---- ports ----
  am  = contact mcon in=sS1
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