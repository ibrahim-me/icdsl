# o311a_1: lifted from sky130_fd_sc_hd__o311a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o311a_1 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=n2 b=VNB
  device M1 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M2 pmos w=WP l=L d=VPWR g=C1 s=n3 b=VPB
  device M3 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M4 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M6 pmos w=WP l=L d=n4 g=A2 s=n5 b=VPB
  device M7 pmos w=WP l=L d=n3 g=B1 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=n2 g=C1 s=n3 b=VNB
  device M9 pmos w=WP l=L d=n5 g=A3 s=n3 b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M11 nmos w=WN l=L d=X g=n3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.41
  x2 = x1 + L + 0.635
  x3 = x2 + L + 0.37
  x4 = x3 + L + 0.43
  x5 = x4 + L + 0.285
  x6 = x5 + 0.09
  x7 = x6 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.125, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.125, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x3 + L + 0.215, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5 - 0.07, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7, x7 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.015) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x3 + L, x4 - 0.05) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x2 + L + 0.04, x3 - 0.035) yspan=(nb + 0.075, nb + WN - 0.06) net=n1
  l4 = rect li xspan=(x2 + L + 0.04, x6 - 0.015) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l5 = rect li xspan=(x4 + L + 0.025, x6 - 0.015) yspan=(nb + 0.075, nb + WN - 0.06) net=n1
  l6 = rect li xspan=(x2 - 0.24, x2 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x4 + L + 0.035, x5 + L + 0.005) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l8 = rect li xspan=(x7 + L + 0.07, x7 + L + 0.315) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C1
  l9 = rect li xspan=(x2 + L + 0.125, x3 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l10 = rect li xspan=(x3 - 0.175, x3 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.585) net=A2
  l11 = rect li xspan=(x3 + L + 0.145, x4 - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.585) net=A3
  l12 = rect li xspan=(x3 + L + 0.145, x4 + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l13 = rect li xspan=(x1 - 0.325, x1 - 0.055) yspan=(nb + 0.02, pt - 0.02) net=X
  l14 = rect li xspan=(x1 - 0.325, x1 + 0.03) yspan=(nb + WN + 0.185, pt - 0.02) net=X
  l15 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.225) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n3
  l16 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.025) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l17 = rect li xspan=(x2, x2 + L + 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l18 = rect li xspan=(x2, x5 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n3
  l19 = rect li xspan=(x4 + L - 0.025, x5 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l20 = rect li xspan=(x4 + L - 0.025, x7 + L + 0.315) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l21 = rect li xspan=(x6 + L + 0.09, x7 + L + 0.315) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l22 = rect li xspan=(x6 + L + 0.09, x7 + 0.045) yspan=(nb + 0.02, pt - WP + 0.18) net=n3
  l23 = rect li xspan=(x7 + L + 0.025, x7 + L + 0.315) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l24 = rect li xspan=(x1 + L + 0.055, x2 - 0.175) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l25 = rect li xspan=(x6 + L - 0.025, x7) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN - 0.06) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 - 0.155) span=(-0.085, nb + WN - 0.06) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.215) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x5 - 0.095) span=(nb + 0.075, nb + WN - 0.06) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) net=n3
  c6 = array licon in=nd1 cx=(x2 + L + 0.185) span=(nb + 0.075 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c9 = array licon in=pd1 cx=(x5 - 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n3
  c10 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c11 = array licon in=pd1 cx=(x6 + L + 0.065) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x1 + L + 0.275) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.08) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 - 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.41, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.18) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.14) cy=0
  mc3 = contact mcon cx=(x2 - 0.035) cy=0
  mc4 = contact mcon cx=(x3 - 0.085) cy=0
  mc5 = contact mcon cx=(x4 - 0.195) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.125) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.07) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.18) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.14) cy=H
  mc11 = contact mcon cx=(x2 - 0.035) cy=H
  mc12 = contact mcon cx=(x3 - 0.085) cy=H
  mc13 = contact mcon cx=(x4 - 0.195) cy=H
  mc14 = contact mcon cx=(x4 + L + 0.125) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.07) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l9
  port A3 in on=l11
  port B1 in on=l7
  port C1 in on=l8
  port X out on=l13
end
