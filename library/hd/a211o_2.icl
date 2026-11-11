# a211o_2: lifted from sky130_fd_sc_hd__a211o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a211o_2 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=C1 s=n3 b=VPB
  device M3 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M4 nmos w=WN l=L d=n4 g=A1 s=n3 b=VNB
  device M5 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M7 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M8 nmos w=WN l=L d=VGND g=C1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M10 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M11 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + 0.01
  x4 = x3 + L + 0.625
  x5 = x4 + L + 0.025
  x6 = x5 + L + 0.255
  x7 = x6 + 0.145
  x8 = x7 + L + 0.22
  x9 = x8 + 0.12
  x10 = x9 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.255) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.1, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x3 + L + 0.25) yspan=(nb + WN + 0.115, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.115, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L + 0.25) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4 - 0.085, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.015) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L - 0.02, x5 + 0.04) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x8 + L + 0.005, x10 - 0.055) yspan=(-0.085, nb + 0.29) net=VGND
  l4 = rect li xspan=(x4 - 0.115, x5 + 0.055) yspan=(nb + WN + 0.16, pt - WP - 0.21) net=A2
  l5 = rect li xspan=(x5 + L + 0.08, x7 + L + 0.01) yspan=(nb + WN + 0.16, pt - WP - 0.21) net=A1
  l6 = rect li xspan=(x8 - 0.04, x10 - 0.07) yspan=(nb + WN + 0.16, pt - WP - 0.21) net=B1
  l7 = rect li xspan=(x10 + L - 0.025, x10 + L + 0.315) yspan=(nb + WN + 0.16, pt - WP - 0.21) net=C1
  l8 = rect li xspan=(x3 + L + 0.03, x10 + L + 0.305) yspan=(nb + 0.46, nb + WN - 0.01) net=n3
  l9 = rect li xspan=(x3 + L + 0.03, x4 - 0.285) yspan=(nb + 0.46, pt - WP + 0.175) net=n3
  l10 = rect li xspan=(x3 + L + 0.03, x10 + L + 0.305) yspan=(pt - WP + 0.005, pt - WP + 0.175) net=n3
  l11 = rect li xspan=(x7 - 0.02, x8 - 0.055) yspan=(nb + 0.04, nb + WN - 0.01) net=n3
  l12 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(nb + 0.04, nb + WN - 0.01) net=n3
  l13 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(pt - WP + 0.005, pt - 0.16) net=n3
  l14 = rect li xspan=(x1 + L + 0.015, x2 - 0.045) yspan=(nb + 0.02, pt - 0.15) net=X
  l15 = rect li xspan=(x1 + L + 0.015, x2 - 0.035) yspan=(nb + WN - 0.25, pt - 0.15) net=X
  l16 = rect li xspan=(x4 - 0.14, x8 + L - 0.01) yspan=(pt - WP + 0.355, pt - 0.465) net=n1
  l17 = rect li xspan=(x4 - 0.14, x5 + 0.03) yspan=(pt - WP + 0.355, pt - 0.02) net=n1
  l18 = rect li xspan=(x7 + L + 0.025, x8 + L - 0.01) yspan=(pt - WP + 0.355, pt - 0.02) net=n1
  l19 = rect li xspan=(x1 - 0.31, x1 - 0.015) yspan=(pt - WP + 0.005, H + 0.085) net=VPWR
  l20 = rect li xspan=(x3 + L + 0.03, x3 + L + 0.285) yspan=(pt - 0.655, H + 0.085) net=VPWR
  l21 = rect li xspan=(x5 + L + 0.055, x7 - 0.065) yspan=(pt - 0.295, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 - 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x7 + L - 0.005) span=(nb + 0.04, nb + WN - 0.01) margin=0.04 net=n3
  c4 = array licon in=nd1 cx=(x9 + L + 0.05) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.04, nb + WN - 0.01) net=n3
  c7 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.15 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd1 cx=(x2 - 0.135) span=(nb + 0.02 + 0.08, pt - 0.15 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.15 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.005 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.005, pt - 0.16) net=n3
  c12 = array licon in=pd1 cx=(x3 + L + 0.13) span=(pt - 0.655 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x4 + 0.03) span=(pt - WP + 0.355, pt - 0.02) net=n1
  c14 = array licon in=pd2 cx=(x8 - 0.03) span=(pt - WP + 0.355, pt - 0.02) margin=0.04 net=n1
  c15 = array licon in=pd2 cx=(x6 - 0.05) span=(pt - 0.295 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x3 + L + 0.115) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x4 + 0.055) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 - 0.01) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + L/2 + 0.06) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 + L + 0.15) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.18) cy=0
  mc4 = contact mcon cx=(x4 + 0.02) cy=0
  mc5 = contact mcon cx=(x6 - 0.085) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.09) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.07) cy=0
  mc8 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.13) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.18) cy=H
  mc12 = contact mcon cx=(x4 + 0.02) cy=H
  mc13 = contact mcon cx=(x6 - 0.085) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.09) cy=H
  mc15 = contact mcon cx=(x9 + L + 0.07) cy=H
  mc16 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l4
  port B1 in on=l6
  port C1 in on=l7
  port X out on=l14
end
