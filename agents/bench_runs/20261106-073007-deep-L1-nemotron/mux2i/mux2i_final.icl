pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=11 height=H
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

  # ---- gate order (both rows): S, n1, A1, A0, S ----
  # n row: M3(S), M5(n1), M8(A1), M9(A0), M6(S)
  # p row: M0(S), M4(n1), M7(A1), M2(A0), M1(S)
  # gaps: g1-g2: n-side VGND/VGND share(0.28) but p-side n1/VPWR break(0.80) -> 0.80
  #       g2-g3: n-side n5/n3 break(0.80) but p-side n4/n4 share(0.28) -> 0.80
  #       g3-g4: Y/Y share(0.28) both -> 0.28
  #       g4-g5: n-side n5/VGND break(0.80) but p-side n2/n2 share(0.28) -> 0.80
  dw  = 2*0.265 + 5*L + 0.80 + 0.80 + 0.28 + 0.80

  # ---- n row: separate diffusion rectangles per island ----
  # Island A (M3): n3 | g1(S) | VGND
  ndA = rect diff w=(0.265 + L + 0.265) h=WN cx=(nd.left + 0.265 + L/2 + 0.265/2) above=ptap
  # Island B (M5): VGND | g2(n1) | n5
  ndB = rect diff w=(0.265 + L + 0.265) h=WN cx=(ndA.cx + 0.80 + L + 0.80) above=ptap
  # Island C (M8): n3 | g3(A1) | Y
  ndC = rect diff w=(0.265 + L + 0.265) h=WN cx=(ndB.cx + 0.80 + L + 0.80) above=ptap
  # Island D (M9): Y | g4(A0) | n5
  ndD = rect diff w=(0.265 + L + 0.265) h=WN cx=(ndC.cx + 0.28 + L + 0.28) above=ptap
  # Island E (M6): VGND | g5(S) | n1
  ndE = rect diff w=(0.265 + L + 0.265) h=WN cx=(ndD.cx + 0.80 + L + 0.80) above=ptap

  nd = enclose [ndA, ndB, ndC, ndD, ndE] diff
  nim = enclose nd nsdm

  g1  = cross [ndA, pd] poly w=L left=(ndA.left + 0.265)        # S
  g2  = cross [ndB, pd] poly w=L left=(ndB.left + 0.265)        # n1
  g3  = cross [ndC, pd] poly w=L left=(ndC.left + 0.265)        # A1
  g4  = cross [ndD, pd] poly w=L left=(ndD.left + 0.265)        # A0
  g5  = cross [ndE, pd] poly w=L left=(ndE.left + 0.265)        # S

  # ---- p row: separate diffusion rectangles per island ----
  # Island A (M0): VPWR | g1(S) | n1
  pdA = rect diff w=(0.265 + L + 0.265) h=WP cx=(ndA.cx) below=ntap
  # Island B (M4): VPWR | g2(n1) | n4
  pdB = rect diff w=(0.265 + L + 0.265) h=WP cx=(ndB.cx) below=ntap
  # Island C (M7): n4 | g3(A1) | Y
  pdC = rect diff w=(0.265 + L + 0.265) h=WP cx=(ndC.cx) below=ntap
  # Island D (M2): Y | g4(A0) | n2
  pdD = rect diff w=(0.265 + L + 0.265) h=WP cx=(ndD.cx) below=ntap
  # Island E (M1): n2 | g5(S) | VPWR
  pdE = rect diff w=(0.265 + L + 0.265) h=WP cx=(ndE.cx) below=ntap

  pd = enclose [pdA, pdB, pdC, pdD, pdE] diff
  pim = enclose pd psdm

  # ---- n row diffusion contacts ----
  sn3a = array licon in=ndA left_of=g1          # n3 (M3.s)
  dvg  = array licon in=ndA right_of=g1         # VGND (M3.d)
  svg1 = array licon in=ndB left_of=g2          # VGND (M5.s)
  dn5a = array licon in=ndB right_of=g2         # n5 (M5.d)
  sn3b = array licon in=ndC left_of=g3          # n3 (M8.s)
  dYn  = array licon in=ndC right_of=g3         # Y (M8.d)
  sYn  = array licon in=ndD left_of=g4          # Y (M9.s)
  dn5b = array licon in=ndD right_of=g4         # n5 (M9.d)
  svg2 = array licon in=ndE left_of=g5          # VGND (M6.s)
  dn1n = array licon in=ndE right_of=g5         # n1 (M6.d)

  sn3al = enclose sn3a li net=n3
  dvgl  = enclose dvg li net=VGND
  svgl1 = enclose svg1 li net=VGND
  dn5al = enclose dn5a li net=n5
  sn3bl = enclose sn3b li net=n3
  dYnl  = enclose dYn li net=Y
  sYnl  = enclose sYn li net=Y
  dn5bl = enclose dn5b li net=n5
  svgl2 = enclose svg2 li net=VGND
  dn1nl = enclose dn1n li net=n1

  # ---- p row diffusion contacts ----
  svp1  = array licon in=pdA left_of=g1         # VPWR (M0.s)
  dn1p  = array licon in=pdA right_of=g1        # n1 (M0.d)
  svp2  = array licon in=pdB left_of=g2         # VPWR (M4.s)
  dn4   = array licon in=pdB right_of=g2        # n4 (M4.d)
  sn4   = array licon in=pdC left_of=g3         # n4 (M7.s)
  dYp   = array licon in=pdC right_of=g3        # Y (M7.d)
  sYp   = array licon in=pdD left_of=g4         # Y (M2.s)
  dn2   = array licon in=pdD right_of=g4        # n2 (M2.d)
  sn2   = array licon in=pdE left_of=g5         # n2 (M1.s)
  dvp   = array licon in=pdE right_of=g5        # VPWR (M1.d)

  svp1l = enclose svp1 li net=VPWR
  dn1pl = enclose dn1p li net=n1
  svp2l = enclose svp2 li net=VPWR
  dn4l  = enclose dn4 li net=n4
  sn4l  = enclose sn4 li net=n4
  dYpl  = enclose dYp li net=Y
  sYpl  = enclose sYp li net=Y
  dn2l  = enclose dn2 li net=n2
  sn2l  = enclose sn2 li net=n2
  dvpl  = enclose dvp li net=VPWR

  # ---- supply straps ----
  gnd1 = strap li from=dvgl to=vgnd_li
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

  # ---- gate contacts (centered on gates) ----
  cb = max(ndA.top + 0.19, sn3al.top + 0.25, dvgl.top + 0.25, svgl1.top + 0.25, dn5al.top + 0.25, sn3bl.top + 0.25, dYnl.top + 0.25, sYnl.top + 0.25, dn5bl.top + 0.25, svgl2.top + 0.25, dn1nl.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gc2 = contact licon cx=g2.cx bottom=cb
  gc3 = contact licon cx=g3.cx bottom=cb
  gc4 = contact licon cx=g4.cx bottom=cb
  gc5 = contact licon cx=g5.cx bottom=cb

  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gp3 = enclose gc3 poly by=minx
  gp4 = enclose gc4 poly by=minx
  gp5 = enclose gc5 poly by=minx
  gn  = enclose [gc1, gc2, gc3, gc4, gc5] npc

  sS1 = enclose gc1 li net=S
  sn1g= enclose gc2 li net=n1
  sA1 = enclose gc3 li net=A1
  sA0 = enclose gc4 li net=A0
  sS2 = enclose gc5 li net=S

  # ---- well ----
  well y=((ndA.top + 0.34 + pdA.bottom - 0.18) / 2)

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