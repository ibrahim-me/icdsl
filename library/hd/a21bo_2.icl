# a21bo_2: lifted from sky130_fd_sc_hd__a21bo_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell a21bo_2 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=n1 g=A1 s=n2 b=VNB
  device M2 pmos w=WP2 l=L d=VPWR g=B1_N s=n3 b=VPB
  device M3 nmos w=WN l=L d=VGND g=n3 s=n1 b=VNB
  device M4 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M5 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M7 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M8 pmos w=WP l=L d=n1 g=n3 s=n4 b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A2 s=n4 b=VPB
  device M10 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M11 nmos w=WN2 l=L d=VGND g=B1_N s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.37
  x4 = x3 + L + 0.8
  x5 = x4 + L + 0.28
  x6 = x5 + 0.06
  x7 = x6 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x4 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd3 = rect diff xspan=(x1 - 0.265, x3 + L/2) yspan=(pt - 0.58 + 0.27, pt)
  pd4 = rect diff xspan=(x4 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x3 - 0.035, x3 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x3, x3 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.325, x4 + L) yspan=(nb + WN + 0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.065, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.23) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + 0.23 + 0.08) net=VGND
  l2 = rect li xspan=(x2 + L + 0.05, x3 - 0.12) yspan=(-0.085, nb + WN - 0.02) net=VGND
  l3 = rect li xspan=(x4 - 0.305, x4 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.305) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l5 = rect li xspan=(x2 + L + 0.1, x3 + L + 0.045) yspan=(nb + WN + 0.15, pt - WP - 0.16) net=B1_N
  l6 = rect li xspan=(x3 - 0.01, x3 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1_N
  l7 = rect li xspan=(x5 - 0.015, x7 - 0.02) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A1
  l8 = rect li xspan=(x7 + L + 0.01, x7 + L + 0.3) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A2
  l9 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.385) yspan=(nb + 0.23 + 0.19, nb + WN - 0.06) net=n3
  l10 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.385) yspan=(pt - WP + 0.07, pt - WP + 0.24) net=n3
  l11 = rect li xspan=(x3 + L + 0.215, x3 + L + 0.385) yspan=(nb + 0.23 + 0.19, pt - WP + 0.24) net=n3
  l12 = rect li xspan=(x3 + L + 0.215, x4 - 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l13 = rect li xspan=(x1 - 0.25, x1 - 0.02) yspan=(nb + WN - 0.17, pt - 0.58 + 0.1) net=X
  l14 = rect li xspan=(x1 - 0.25, x2 + 0.025) yspan=(nb + WN - 0.17, nb + WN) net=X
  l15 = rect li xspan=(x1 - 0.25, x2 + 0.025) yspan=(pt - 0.58 - 0.07, pt - 0.58 + 0.1) net=X
  l16 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(nb + 0.08, nb + WN) net=X
  l17 = rect li xspan=(x1 + L + 0.055, x2 + 0.025) yspan=(pt - 0.58 - 0.07, pt - 0.06) net=X
  l18 = rect li xspan=(x1 + L + 0.03, x2 + L/2) yspan=(nb + WN + 0.19, pt - 0.58 - 0.24) net=n1
  l19 = rect li xspan=(x1 + L + 0.03, x3 - 0.055) yspan=(pt - WP + 0.01, pt - 0.58 - 0.24) net=n1
  l20 = rect li xspan=(x2 + L + 0.145, x3 - 0.055) yspan=(pt - WP + 0.01, pt - 0.58 + 0.2) net=n1
  l21 = rect li xspan=(x2 + L + 0.145, x4 - 0.055) yspan=(pt - 0.58 - 0.01, pt - 0.58 + 0.2) net=n1
  l22 = rect li xspan=(x4 - 0.305, x4 - 0.055) yspan=(pt - 0.58 - 0.01, pt - 0.02) net=n1
  l23 = rect li xspan=(x4 - 0.225, x4 - 0.055) yspan=(pt - WP + 0.02, pt - 0.02) net=n1
  l24 = rect li xspan=(x4 - 0.225, x4 + L + 0.095) yspan=(pt - WP + 0.02, pt - WP + 0.19) net=n1
  l25 = rect li xspan=(x4 + 0.07, x4 + L + 0.095) yspan=(nb + 0.23 + 0.17, pt - WP + 0.19) net=n1
  l26 = rect li xspan=(x4 + 0.07, x6 - 0.015) yspan=(nb + 0.23 + 0.17, nb + WN - 0.06) net=n1
  l27 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - 0.58 - 0.06, pt - 0.02) net=n4
  l28 = rect li xspan=(x4 + L - 0.03, x7 + L + 0.305) yspan=(pt - 0.58 - 0.06, pt - 0.58 + 0.11) net=n4
  l29 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.305) yspan=(pt - 0.58 - 0.06, pt - 0.02) net=n4
  l30 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l31 = rect li xspan=(x2 + L + 0.07, x3 + 0.035) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l32 = rect li xspan=(x6 + L - 0.01, x7 - 0.055) yspan=(pt - 0.58 + 0.28, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.08 - 0.08) net=VGND
  c3 = array licon in=nd3 cx=(x4 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c4 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.08, nb + WN) margin=0.04 net=X
  c5 = array licon in=nd3 cx=(x5 - 0.125) span=(nb + 0.23 + 0.17, nb + WN - 0.06) margin=0.04 net=n1
  c6 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.23 + 0.19, nb + WN - 0.06) net=n3
  c7 = array licon in=nd3 cx=(x7 + L + 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c8 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.07, pt - WP + 0.24) net=n3
  c9 = array licon in=pd4 cx=(x4 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c10 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.58 - 0.07 + 0.08, pt - 0.06 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd4 cx=(x4 + L + 0.14) span=(pt - 0.58 - 0.06, pt - 0.02) margin=0.04 net=n4
  c12 = array licon in=pd4 cx=(x7 + L + 0.14) span=(pt - 0.58 - 0.06, pt - 0.02) net=n4
  c13 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  c14 = array licon in=pd3 cx=(x3 - 0.135) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd4 cx=(x6 + L + 0.08) span=(pt - 0.58 + 0.28 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.095) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.045) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 - 0.19) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.095) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.14) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.18) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x4 - 0.21) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.11) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.09) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.19) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.14) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.18) cy=H
  mc12 = contact mcon cx=(x3 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x4 - 0.21) cy=H
  mc14 = contact mcon cx=(x4 + L + 0.11) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.09) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.19) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l8
  port B1_N in on=l5
  port X out on=l13
end
