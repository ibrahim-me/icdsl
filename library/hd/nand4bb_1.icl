# nand4bb_1: lifted from sky130_fd_sc_hd__nand4bb_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand4bb_1 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=n1 s=VPWR b=VPB
  device M1 nmos w=WN l=L d=n2 g=n1 s=Y b=VNB
  device M2 pmos w=WP2 l=L d=VPWR g=A_N s=n1 b=VPB
  device M3 nmos w=WN2 l=L d=VGND g=A_N s=n1 b=VNB
  device M4 nmos w=WN2 l=L d=n3 g=B_N s=VGND b=VNB
  device M5 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n4 g=n3 s=n2 b=VNB
  device M7 pmos w=WP2 l=L d=n3 g=B_N s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=D s=Y b=VPB
  device M9 pmos w=WP l=L d=VPWR g=n3 s=Y b=VPB
  device M10 nmos w=WN l=L d=VGND g=D s=n5 b=VNB
  device M11 nmos w=WN l=L d=n5 g=C s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.405
  x3 = x2 + L + 0.4
  x4 = x3 + L + 0.36
  x5 = x4 + L + 0.36
  x6 = x5 + L + 0.8
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x6 - 0.265, x6 + L + 0.44) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x1 + L + 0.08, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x5 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x6 - 0.265, x6 + L + 0.44) yspan=(pt - WP2, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.19) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x6 - 0.335) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x6, x6 + L + 0.125) yspan=(nb + WN + 0.105, pt - WP - 0.165)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.045) yspan=(-0.085, nb + 0.23 + 0.08) net=VGND
  l2 = rect li xspan=(x6 - 0.325, x6 + 0.03) yspan=(-0.085, nb + 0.23 + 0.08) net=VGND
  l3 = rect li xspan=(x2 + 0.03, x3 - 0.165) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=D
  l4 = rect li xspan=(x3 + 0.02, x3 + L + 0.095) yspan=(nb + WN2 + 0.08, pt - WP - 0.16) net=C
  l5 = rect li xspan=(x6 - 0.035, x6 + L + 0.075) yspan=(nb + WN2 + 0.07, pt - WP + 0.13) net=A_N
  l6 = rect li xspan=(x1 + 0.035, x2 - 0.165) yspan=(nb + WN + 0.19, pt - WP + 0.17) net=B_N
  l7 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.23 + 0.02, pt - 0.02) net=n3
  l8 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.23 + 0.02, nb + WN + 0.02) net=n3
  l9 = rect li xspan=(x1 - 0.315, x2 + L + 0.185) yspan=(nb + WN2 + 0.06, nb + WN + 0.02) net=n3
  l10 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP2, pt - 0.02) net=n3
  l11 = rect li xspan=(x2 + L - 0.01, x4 + L + 0.125) yspan=(nb + 0.23 - 0.1, nb + 0.23 + 0.09) net=n3
  l12 = rect li xspan=(x2 + L - 0.01, x2 + L + 0.185) yspan=(nb + 0.23 - 0.1, nb + WN + 0.02) net=n3
  l13 = rect li xspan=(x4 - 0.015, x4 + L + 0.125) yspan=(nb + 0.23 - 0.1, pt - WP - 0.16) net=n3
  l14 = rect li xspan=(x2 + L + 0.035, x3 - 0.035) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l15 = rect li xspan=(x2 + L + 0.035, x5 + L + 0.045) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l16 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l17 = rect li xspan=(x5 - 0.065, x5 + L + 0.045) yspan=(nb + 0.02, pt - WP + 0.18) net=Y
  l18 = rect li xspan=(x5 - 0.065, x5 + L + 0.305) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l19 = rect li xspan=(x5 + L + 0.215, x6 - 0.335) yspan=(nb + WN + 0.11, pt - WP2 - 0.06) net=n1
  l20 = rect li xspan=(x5 + L + 0.215, x6 + L + 0.49) yspan=(pt - WP2 - 0.23, pt - WP2 - 0.06) net=n1
  l21 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.49) yspan=(nb + 0.02, nb + 0.23 + 0.08) net=n1
  l22 = rect li xspan=(x6 + L + 0.07, x6 + L + 0.49) yspan=(pt - WP2 - 0.23, pt - 0.02) net=n1
  l23 = rect li xspan=(x6 + L + 0.245, x6 + L + 0.49) yspan=(nb + 0.02, pt - 0.02) net=n1
  l24 = rect li xspan=(x1 + L + 0.055, x2 - 0.02) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l25 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l26 = rect li xspan=(x5 + L + 0.055, x6 + 0.03) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x2 - 0.2) span=(-0.085 + 0.08, nb + 0.23 + 0.08 - 0.08) net=VGND
  c2 = array licon in=nd3 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) net=Y
  c3 = array licon in=nd1 cx=(x6 - 0.14) span=(-0.085, nb + 0.23 + 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x6 + L + 0.235) span=(nb + 0.02, nb + 0.23 + 0.08) margin=0.04 net=n1
  c5 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.23 + 0.02, nb + WN + 0.02) net=n3
  c6 = array licon in=pd2 cx=(x2 + L + 0.2) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=pd2 cx=(x4 + L + 0.18) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c8 = array licon in=pd2 cx=(x2 - 0.185) span=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  c9 = array licon in=pd2 cx=(x3 + L + 0.18) span=(pt - WP2 - 0.23, H + 0.085) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2, pt - 0.02) net=n3
  c11 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  c12 = array licon in=pd3 cx=(x6 - 0.14) span=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  c13 = array licon in=pd3 cx=(x6 + L + 0.235) span=(pt - WP2 - 0.23, pt - 0.02) margin=0.04 net=n1
  gc1 = contact licon cx=(x6 + L - 0.015) cy=(pt - WP - 0.33)
  gc2 = contact licon cx=(x1 + L + 0.055) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x2 + L + 0.05) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x3 + L + 0.01) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x4 + L - 0.015) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x5 + L + 0.3) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.575) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x6 - 0.055, x6 + L + 0.175) yspan=(nb + WN + 0.085, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.065) cy=0
  mc4 = contact mcon cx=(x3 + L - 0.02) cy=0
  mc5 = contact mcon cx=(x4 + L - 0.06) cy=0
  mc6 = contact mcon cx=(x5 + 0.05) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.365) cy=0
  mc8 = contact mcon cx=(x6 + 0.03) cy=0
  mc9 = contact mcon cx=(x6 + L + 0.345) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.065) cy=H
  mc13 = contact mcon cx=(x3 + L - 0.02) cy=H
  mc14 = contact mcon cx=(x4 + L - 0.06) cy=H
  mc15 = contact mcon cx=(x5 + 0.05) cy=H
  mc16 = contact mcon cx=(x5 + L + 0.365) cy=H
  mc17 = contact mcon cx=(x6 + 0.03) cy=H
  mc18 = contact mcon cx=(x6 + L + 0.345) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l5
  port B_N in on=l6
  port C in on=l4
  port D in on=l3
  port Y out on=l15
end
