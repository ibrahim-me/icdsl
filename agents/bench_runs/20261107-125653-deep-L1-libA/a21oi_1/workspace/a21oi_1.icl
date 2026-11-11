pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a21oi_1 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.605                          # gate B1
  x2 = x1 + L + max(0.28, 0.54 - L)   # gate A1
  x3 = x2 + L + max(0.28, 0.54 - L)   # gate A2
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: n row = M3(B1) - M5(A1) - M0(A2)
  #   col0 (left of M3): M3.d = VGND
  #   col1 (M3-M5): shared Y (diffusion sharing)
  #   col2 (M5-M0): shared n1 (diffusion sharing)
  #   col3 (right of M0): M0.s = VGND
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)

  # diffusion: p row = M2(B1) - M1(A1) - M4(A2)
  #   col0 (left of M2): M2.d = Y
  #   col1 (M2-M1): shared n2 (diffusion sharing)
  #   col2 (M1-M4): shared VPWR (diffusion sharing)
  #   col3 (right of M4): M4.s = n2
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)

  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  # poly: gates crossing both rows, pads and jogs (nand2 pattern)
  p1 = rect poly xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.315, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.315, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)

  # local interconnect: n row outer columns (bottom of n row diffusion)
  ln1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  ln4 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND

  # local interconnect: p row outer columns (bottom of p row diffusion)
  lp1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP, pt + 0.085) net=Y
  lp4 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=n2

  # VPWR rail connection on p row col2 (shared VPWR column between M1 and M4)
  lp6 = rect li xspan=(x2 + L - 0.03, x3 + L - 0.20) yspan=(pt - WP, H + 0.085) net=VPWR

  # gate contact li strips (between the rows, at each gate contact)
  lg1 = rect li xspan=(x1 - 0.315, x1 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=B1
  lg2 = rect li xspan=(x2 - 0.315, x2 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A1
  lg3 = rect li xspan=(x3 - 0.315, x3 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A2

  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=Y
  c8 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP, pt - 0.02 - 0.08) net=n2
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR

  # gate contacts: one per gate, shifted left by 0.13 from gate left edge
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275) net=B1
  gc2 = contact licon cx=(x2 - 0.13) cy=(nb + WN + 0.275) net=A1
  gc3 = contact licon cx=(x3 - 0.13) cy=(nb + WN + 0.275) net=A2

  np1 = rect npc xspan=(x1 - 0.42, x3 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: rail contacts
  mc1 = contact mcon cx=(x1 - 0.19) cy=0 net=VGND
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0 net=VGND
  mc3 = contact mcon cx=(x2 + L + 0.17) cy=0 net=VGND
  mc4 = contact mcon cx=(x1 - 0.19) cy=H net=VPWR
  mc5 = contact mcon cx=(x1 + L + 0.13) cy=H net=VPWR
  mc6 = contact mcon cx=(x2 + L + 0.17) cy=H net=VPWR

  # supply straps
  s1 = strap li from=c1 to=vgnd_li
  s2 = strap li from=c9 to=vpwr_li

  # internal nets: route n1 (n row col2), n2 (p row col1-col3), Y (p col0 to n col1)
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  ym = contact mcon in=lp1
  yp = enclose ym m1 by=0.06 net=Y
  port B1 in on=lg1
  port A1 in on=lg2
  port A2 in on=lg3
  port Y out on=yp
end
