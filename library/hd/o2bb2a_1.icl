# o2bb2a_1: lifted from sky130_fd_sc_hd__o2bb2a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell o2bb2a_1 width=10 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=n2 s=n3 b=VNB
  device M1 pmos w=WP2 l=L d=VPWR g=n2 s=n1 b=VPB
  device M2 pmos w=WP2 l=L d=VPWR g=A1_N s=n2 b=VPB
  device M3 pmos w=WP2 l=L d=n2 g=A2_N s=VPWR b=VPB
  device M4 nmos w=WN2 l=L d=VGND g=B1 s=n3 b=VNB
  device M5 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M6 nmos w=WN2 l=L d=n3 g=B2 s=VGND b=VNB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 nmos w=WN2 l=L d=n4 g=A2_N s=n2 b=VNB
  device M9 pmos w=WP2 l=L d=n1 g=B2 s=n5 b=VPB
  device M10 pmos w=WP2 l=L d=n5 g=B1 s=VPWR b=VPB
  device M11 nmos w=WN2 l=L d=VGND g=A1_N s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.34
  x3 = x2 + 0.005
  x4 = x3 + L + 0.32
  x5 = x4 + 0.09
  x6 = x5 + L + 0.725
  x7 = x6 + 0.01
  x8 = x7 + L + 0.27
  x9 = x8 + 0.06
  x10 = x9 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x6 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x5 + L + 0.175) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x1 - 0.265, x2 - 0.08) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 - 0.075) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(pt - 0.22 - WP2, pt - 0.22)
  pd3 = rect diff xspan=(x3 + L + 0.08, x4 + 0.015) yspan=(pt - WP, pt - 0.22)
  pd4 = rect diff xspan=(x5 + L + 0.085, x6 - 0.07) yspan=(pt - 0.22 - WP2, pt - 0.02)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x2 - 0.02, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, pt - 0.09)
  p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.215)
  p5 = rect poly xspan=(x4, x5 + L + 0.055) yspan=(nb + WN2 + 0.115, nb + WN + 0.215)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.215, pt - 0.09)
  p7 = rect poly xspan=(x5 + L + 0.215, x6 + L) yspan=(pt - WP - 0.13, pt - 0.22 - WP2 - 0.16)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - 0.22 - WP2 - 0.16)
  p9 = rect poly xspan=(x7, x6 + L) yspan=(0.105, pt - 0.09)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP + 0.075, pt - 0.09)
  p11 = rect poly xspan=(x8 - 0.065, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, pt - 0.09)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - 0.09)
  p15 = rect poly xspan=(x10, x10 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x1 - 0.02, x1 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.08, x2 - 0.09) yspan=(-0.085, nb + WN2 + 0.095) net=VGND
  l2 = rect li xspan=(x9 + L - 0.01, x10 - 0.055) yspan=(-0.085, nb + WN2 - 0.1) net=VGND
  l3 = rect li xspan=(x7 + L + 0.045, x8 + 0.03) yspan=(nb + 0.085, nb + WN + 0.02) net=n3
  l4 = rect li xspan=(x7 + L + 0.045, x10 + L + 0.315) yspan=(nb + WN2 + 0.07, nb + WN + 0.02) net=n3
  l5 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.315) yspan=(nb + 0.085, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x3 + L + 0.045, x4 - 0.055) yspan=(nb + 0.145, nb + WN + 0.02) net=A2_N
  l7 = rect li xspan=(x3 + L + 0.045, x5 + L - 0.015) yspan=(nb + WN2 + 0.08, nb + WN + 0.02) net=A2_N
  l8 = rect li xspan=(x5 - 0.04, x5 + L - 0.015) yspan=(nb + WN2 + 0.08, pt - WP - 0.385) net=A2_N
  l9 = rect li xspan=(x2 - 0.11, x4 - 0.125) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1_N
  l10 = rect li xspan=(x10 + L - 0.035, x10 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP + 0.16) net=B1
  l11 = rect li xspan=(x2 + L - 0.03, x6 - 0.29) yspan=(pt - WP + 0.01, pt - 0.22 - WP2 - 0.13) net=n2
  l12 = rect li xspan=(x4 + L/2 + 0.045, x5 + L + 0.33) yspan=(nb + 0.16, nb + WN2 - 0.09) net=n2
  l13 = rect li xspan=(x5 + L + 0.16, x5 + L + 0.33) yspan=(nb + 0.16, pt - 0.22 - WP2 - 0.13) net=n2
  l14 = rect li xspan=(x5 + L + 0.16, x6 - 0.29) yspan=(pt - WP - 0.13, pt - 0.22 - WP2 - 0.13) net=n2
  l15 = rect li xspan=(x1 + 0.035, x1 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=n1
  l16 = rect li xspan=(x1 + 0.035, x2 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n1
  l17 = rect li xspan=(x1 + L + 0.115, x2 - 0.055) yspan=(pt - WP - 0.04, pt - 0.22 - WP2 + 0.21) net=n1
  l18 = rect li xspan=(x1 + L + 0.115, x8 + 0.02) yspan=(pt - 0.22 - WP2 + 0.04, pt - 0.22 - WP2 + 0.21) net=n1
  l19 = rect li xspan=(x6 - 0.225, x7 + 0.02) yspan=(nb + 0.085, nb + WN2 + 0.035) net=n1
  l20 = rect li xspan=(x6 - 0.145, x7 + 0.02) yspan=(nb + 0.085, pt - WP - 0.24) net=n1
  l21 = rect li xspan=(x6 - 0.12, x7 + 0.045) yspan=(nb + WN + 0.19, pt - 0.22 - WP2 + 0.21) net=n1
  l22 = rect li xspan=(x6 - 0.12, x8 + 0.02) yspan=(pt - WP + 0.01, pt - 0.22 - WP2 + 0.21) net=n1
  l23 = rect li xspan=(x6 + L - 0.04, x8 + 0.02) yspan=(pt - WP + 0.01, pt - 0.22 + 0.025) net=n1
  l24 = rect li xspan=(x7 + L + 0.07, x10 - 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B2
  l25 = rect li xspan=(x9 + L - 0.02, x10 - 0.06) yspan=(nb + WN + 0.19, pt - 0.06) net=B2
  l26 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=X
  l27 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l28 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - 0.22 - WP2 - 0.05, pt - 0.02) net=X
  l29 = rect li xspan=(x1 + L - 0.03, x2 - 0.035) yspan=(pt - 0.22 - 0.03, H + 0.085) net=VPWR
  l30 = rect li xspan=(x5 + L + 0.14, x6 - 0.185) yspan=(pt - 0.22 - 0.03, H + 0.085) net=VPWR
  l31 = rect li xspan=(x10 + L - 0.035, x10 + L + 0.315) yspan=(pt - 0.22 - WP2 - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.06) net=X
  c2 = array licon in=nd1 cx=(x9 + L + 0.08) span=(-0.085 + 0.08, nb + WN2 - 0.1 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.085, nb + WN + 0.02) net=n3
  c4 = array licon in=nd2 cx=(x5 + L + 0.05) span=(nb + 0.16, nb + WN2 - 0.09) net=n2
  c5 = array licon in=nd1 cx=(x6 - 0.14) span=(nb + 0.085 + 0.08, nb + WN2 + 0.035 - 0.08) net=n1
  c6 = array licon in=nd1 cx=(x7 + L + 0.13) span=(nb + 0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd3 cx=(x1 + L + 0.165) span=(-0.085 + 0.08, nb + WN2 + 0.095 - 0.08) net=VGND
  c8 = array licon in=pd3 cx=(x4 - 0.115) span=(pt - WP + 0.01, pt - 0.22 - WP2 - 0.13) net=n2
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.22 - WP2 - 0.05 + 0.08, pt - 0.02 - 0.08) net=X
  c10 = array licon in=pd2 cx=(x8 - 0.13) span=(pt - WP + 0.01 + 0.08, pt - 0.22 + 0.025 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - 0.22 - WP2 - 0.03, H + 0.085) net=VPWR
  c12 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.22 - 0.03, H + 0.085) net=VPWR
  c13 = array licon in=pd4 cx=(x5 + L + 0.34) span=(pt - 0.22 - 0.03, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.05)
  gc2 = contact licon cx=(x1 + L - 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x2 + L - 0.03) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x9 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 + L + 0.135) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x5 + L + 0.35) cy=(pt - WP + 0.035)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x4 - 0.055, x5 + L + 0.105) yspan=(nb + WN2 + 0.095, pt - WP - 0.14)
  np3 = rect npc xspan=(x5 + L + 0.165, x6 - 0.19) yspan=(nb + WN + 0.09, pt - 0.22 - WP2 - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x5 + L + 0.035) cy=0
  mc5 = contact mcon cx=(x6 - 0.23) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.08) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.07) cy=0
  mc8 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.125) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.035) cy=H
  mc13 = contact mcon cx=(x6 - 0.23) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.08) cy=H
  mc15 = contact mcon cx=(x9 + L + 0.07) cy=H
  mc16 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l9
  port A2_N in on=l6
  port B1 in on=l10
  port B2 in on=l25
  port X out on=l26
end
