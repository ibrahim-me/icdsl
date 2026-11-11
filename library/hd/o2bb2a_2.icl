# o2bb2a_2: lifted from sky130_fd_sc_hd__o2bb2a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell o2bb2a_2 width=11 height=H taps=no
  device M0 pmos w=WP2 l=L d=VPWR g=A1_N s=n1 b=VPB
  device M1 pmos w=WP2 l=L d=n1 g=A2_N s=VPWR b=VPB
  device M2 nmos w=WN2 l=L d=n2 g=B2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=n4 g=A2_N s=n1 b=VNB
  device M5 nmos w=WN2 l=L d=VGND g=A1_N s=n4 b=VNB
  device M6 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=n3 g=n1 s=n2 b=VNB
  device M8 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M9 pmos w=WP2 l=L d=VPWR g=n1 s=n3 b=VPB
  device M10 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M11 pmos w=WP2 l=L d=n5 g=B1 s=VPWR b=VPB
  device M12 pmos w=WP2 l=L d=n3 g=B2 s=n5 b=VPB
  device M13 nmos w=WN2 l=L d=VGND g=B1 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.425
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.34
  x4 = x3 + 0.005
  x5 = x4 + L + 0.32
  x6 = x5 + 0.09
  x7 = x6 + L + 0.72
  x8 = x7 + 0.02
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x7 - 0.245, x10 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.29, x6 + L + 0.175) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x1 - 0.29, x3 - 0.08) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.29, x3 - 0.075) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.29, x10 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x4 + L + 0.08, x5 + 0.015) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.02, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, nb + WN + 0.215)
  p8 = rect poly xspan=(x5, x6 + L + 0.055) yspan=(nb + WN2 + 0.115, nb + WN + 0.215)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.215, H - 0.105)
  p10 = rect poly xspan=(x6 + L + 0.22, x8 + L) yspan=(pt - WP - 0.13, pt - WP2 - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP - 0.13, H - 0.105)
  p12 = rect poly xspan=(x8, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP2 - 0.16)
  p14 = rect poly xspan=(x9 - 0.065, x9 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x10, x10 + L + 0.285) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x8 + L + 0.055, x9 + 0.01) yspan=(nb + 0.085, nb + WN + 0.02) net=n2
  l2 = rect li xspan=(x8 + L + 0.055, x10 + L + 0.305) yspan=(nb + WN2 + 0.07, nb + WN + 0.02) net=n2
  l3 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(nb + 0.085, nb + WN + 0.02) net=n2
  l4 = rect li xspan=(x1 - 0.315, x1 - 0.06) yspan=(-0.085, nb + WN + 0.025) net=VGND
  l5 = rect li xspan=(x2 + L + 0.08, x3 - 0.09) yspan=(-0.085, nb + WN2 + 0.095) net=VGND
  l6 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(-0.085, nb + WN2 - 0.1) net=VGND
  l7 = rect li xspan=(x4 + L + 0.045, x5 - 0.055) yspan=(nb + 0.145, nb + WN + 0.02) net=A2_N
  l8 = rect li xspan=(x5 - 0.055, x6 + L - 0.005) yspan=(nb + WN2 + 0.08, nb + WN + 0.02) net=A2_N
  l9 = rect li xspan=(x6 - 0.02, x6 + L) yspan=(nb + WN2 + 0.115, pt - WP - 0.385) net=A2_N
  l10 = rect li xspan=(x3 - 0.11, x5 - 0.105) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1_N
  l11 = rect li xspan=(x10 + L - 0.045, x10 + L + 0.305) yspan=(nb + WN + 0.19, pt - WP + 0.16) net=B1
  l12 = rect li xspan=(x3 + L - 0.03, x7 - 0.28) yspan=(pt - WP + 0.01, pt - WP2 - 0.13) net=n1
  l13 = rect li xspan=(x5 + L/2 + 0.045, x6 + L + 0.345) yspan=(nb + 0.16, nb + WN2 - 0.09) net=n1
  l14 = rect li xspan=(x6 + L + 0.175, x6 + L + 0.345) yspan=(nb + 0.16, pt - WP2 - 0.13) net=n1
  l15 = rect li xspan=(x6 + L + 0.175, x7 - 0.28) yspan=(pt - WP - 0.13, pt - WP2 - 0.13) net=n1
  l16 = rect li xspan=(x2 + 0.035, x2 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=n3
  l17 = rect li xspan=(x2 + 0.035, x3 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n3
  l18 = rect li xspan=(x2 + L + 0.115, x3 - 0.055) yspan=(pt - WP - 0.04, pt - WP2 + 0.21) net=n3
  l19 = rect li xspan=(x2 + L + 0.115, x9 + 0.01) yspan=(pt - WP2 + 0.04, pt - WP2 + 0.21) net=n3
  l20 = rect li xspan=(x7 - 0.205, x8 + 0.025) yspan=(nb + 0.085, nb + WN2 + 0.035) net=n3
  l21 = rect li xspan=(x7 - 0.13, x8 + 0.025) yspan=(nb + 0.085, pt - WP - 0.24) net=n3
  l22 = rect li xspan=(x7 - 0.11, x8 + 0.045) yspan=(nb + WN + 0.19, pt - WP2 + 0.21) net=n3
  l23 = rect li xspan=(x7 - 0.11, x9 + 0.01) yspan=(pt - WP + 0.01, pt - WP2 + 0.21) net=n3
  l24 = rect li xspan=(x7 + L - 0.05, x9 + 0.01) yspan=(pt - WP + 0.01, pt - 0.06) net=n3
  l25 = rect li xspan=(x8 + L + 0.07, x10 - 0.075) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B2
  l26 = rect li xspan=(x9 + L + 0.035, x10 - 0.075) yspan=(nb + WN + 0.19, pt - 0.06) net=B2
  l27 = rect li xspan=(x1 + L - 0.035, x1 + L + 0.14) yspan=(nb + 0.02, pt - 0.02) net=X
  l28 = rect li xspan=(x1 + L - 0.035, x2 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l29 = rect li xspan=(x1 + L - 0.035, x2 - 0.055) yspan=(pt - WP2 - 0.05, pt - 0.02) net=X
  l30 = rect li xspan=(x1 - 0.315, x1 - 0.06) yspan=(pt - WP - 0.075, H + 0.085) net=VPWR
  l31 = rect li xspan=(x2 + L - 0.03, x3 - 0.035) yspan=(pt - 0.25, H + 0.085) net=VPWR
  l32 = rect li xspan=(x6 + L + 0.14, x7 - 0.175) yspan=(pt - 0.25, H + 0.085) net=VPWR
  l33 = rect li xspan=(x10 + L - 0.015, x10 + L + 0.305) yspan=(pt - WP2 - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x1 - 0.145) span=(-0.085 + 0.08, nb + WN + 0.025 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=X
  c3 = array licon in=nd1 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.1 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.085, nb + WN + 0.02) net=n2
  c5 = array licon in=nd2 cx=(x6 + L + 0.05) span=(nb + 0.16, nb + WN2 - 0.09) net=n1
  c6 = array licon in=nd1 cx=(x7 - 0.12) span=(nb + 0.085 + 0.08, nb + WN2 + 0.035 - 0.08) net=n3
  c7 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + 0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd3 cx=(x2 + L + 0.165) span=(-0.085 + 0.08, nb + WN2 + 0.095 - 0.08) net=VGND
  c9 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP - 0.075 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd3 cx=(x5 - 0.115) span=(pt - WP + 0.01, pt - WP2 - 0.13) net=n1
  c11 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 - 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd2 cx=(x8 + L + 0.12) span=(pt - WP + 0.01, pt - 0.06) margin=0.04 net=n3
  c13 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP2 - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c14 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.25, H + 0.085) net=VPWR
  c15 = array licon in=pd2 cx=(x6 + L + 0.345) span=(pt - 0.25, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x5 + L + 0.005) cy=(nb + WN + 0.05)
  gc2 = contact licon cx=(x2 + L - 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.03) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x9 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 + L + 0.125) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L + 0.355) cy=(pt - WP + 0.035)
  np1 = rect npc xspan=(x1 - 0.425, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x5 - 0.035, x6 + L + 0.105) yspan=(nb + WN2 + 0.095, pt - WP - 0.14)
  np3 = rect npc xspan=(x6 + L + 0.17, x7 - 0.17) yspan=(nb + WN + 0.09, pt - WP2 - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.195) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.125) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.165) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.14) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.05) cy=0
  mc6 = contact mcon cx=(x7 - 0.21) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.09) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.195) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.125) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.165) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.05) cy=H
  mc15 = contact mcon cx=(x7 - 0.21) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.09) cy=H
  mc17 = contact mcon cx=(x9 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l10
  port A2_N in on=l7
  port B1 in on=l11
  port B2 in on=l26
  port X out on=l27
end
