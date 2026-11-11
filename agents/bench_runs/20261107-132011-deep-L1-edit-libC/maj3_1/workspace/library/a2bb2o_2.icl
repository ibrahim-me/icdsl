# a2bb2o_2: lifted from sky130_fd_sc_hd__a2bb2o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell a2bb2o_2 width=11 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=A1_N s=n1 b=VNB
  device M1 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M2 pmos w=WP2 l=L d=n2 g=n1 s=n3 b=VPB
  device M3 nmos w=WN2 l=L d=n2 g=B2 s=n4 b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=n1 s=n2 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M6 pmos w=WP2 l=L d=VPWR g=B1 s=n3 b=VPB
  device M7 pmos w=WP2 l=L d=n3 g=B2 s=VPWR b=VPB
  device M8 pmos w=WP2 l=L d=VPWR g=A1_N s=n5 b=VPB
  device M9 pmos w=WP2 l=L d=n5 g=A2_N s=n1 b=VPB
  device M10 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M11 nmos w=WN2 l=L d=n4 g=B1 s=VGND b=VNB
  device M12 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M13 nmos w=WN2 l=L d=n1 g=A2_N s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.445
  x4 = x3 + L + 0.22
  x5 = x4 + 0.06
  x6 = x5 + L + 0.685
  x7 = x6 + 0.06
  x8 = x7 + L + 0.22
  x9 = x8 + 0.095
  x10 = x9 + L + 0.185
  x11 = x10 + 0.095
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x11 + L + 0.17) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.27, x3 - 0.19) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.21) yspan=(pt - WP, pt - 0.36)
  pd2 = rect diff xspan=(x1 - 0.27, x3 - 0.18) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x6 - 0.205, x11 + L + 0.265) yspan=(pt - WP2, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x3 - 0.125, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - 0.36 + 0.13)
  p3 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.325, pt - 0.36 + 0.13)
  p4 = rect poly xspan=(x4 + 0.02, x5 + L + 0.085) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.11)
  p6 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x1, x2 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5 + L + 0.31, x6 + L) yspan=(nb + WN2 + 0.11, pt - WP - 0.05)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.05)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.17, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP + 0.15)
  p13 = rect poly xspan=(x8, x9 + L + 0.03) yspan=(pt - WP - 0.18, pt - WP + 0.15)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(pt - WP - 0.18, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, nb + WN + 0.26)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p17 = rect poly xspan=(x11, x11 + L + 0.21) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.23, x1 - 0.06) yspan=(-0.085, nb + WN + 0.045) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 - 0.04) yspan=(-0.085, nb + WN2 - 0.125) net=VGND
  l3 = rect li xspan=(x4 + L + 0.03, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l4 = rect li xspan=(x11 + 0.01, x11 + L + 0.265) yspan=(-0.085, nb + WN2 - 0.06) net=VGND
  l5 = rect li xspan=(x5 + 0.01, x5 + L + 0.155) yspan=(nb + WN + 0.11, pt - WP - 0.11) net=A2_N
  l6 = rect li xspan=(x3 - 0.075, x4 - 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A1_N
  l7 = rect li xspan=(x8 - 0.035, x10 + 0.03) yspan=(nb + WN + 0.47, pt - WP + 0.17) net=B2
  l8 = rect li xspan=(x8 + L + 0.04, x10 + 0.03) yspan=(nb + WN2 + 0.11, pt - WP + 0.17) net=B2
  l9 = rect li xspan=(x11 + L - 0.015, x11 + L + 0.25) yspan=(nb + WN2 + 0.11, pt - WP + 0.17) net=B1
  l10 = rect li xspan=(x3 + L + 0.055, x4 + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l11 = rect li xspan=(x3 + L + 0.055, x6 - 0.155) yspan=(nb + WN2, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x5 + L - 0.01, x6 - 0.155) yspan=(pt - WP + 0.06, pt - WP2 - 0.13) net=n1
  l13 = rect li xspan=(x5 + L - 0.01, x5 + L + 0.165) yspan=(pt - WP + 0.06, pt - WP2 + 0.06) net=n1
  l14 = rect li xspan=(x6 - 0.325, x6 - 0.155) yspan=(nb + WN2, pt - WP2 - 0.13) net=n1
  l15 = rect li xspan=(x1 + L - 0.035, x1 + L + 0.14) yspan=(nb + 0.02, pt - 0.02) net=X
  l16 = rect li xspan=(x1 + L - 0.035, x2 - 0.055) yspan=(nb + 0.02, nb + WN - 0.075) net=X
  l17 = rect li xspan=(x1 + L - 0.035, x2 - 0.055) yspan=(pt - WP + 0.04, pt - 0.02) net=X
  l18 = rect li xspan=(x2 + 0.035, x2 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l19 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP2 + 0.13) net=n2
  l20 = rect li xspan=(x2 + L - 0.03, x4 - 0.07) yspan=(pt - WP2 - 0.04, pt - WP2 + 0.13) net=n2
  l21 = rect li xspan=(x3 + L - 0.025, x4 - 0.07) yspan=(pt - WP2 - 0.04, pt - 0.115) net=n2
  l22 = rect li xspan=(x3 + L - 0.025, x6 + 0.01) yspan=(pt - 0.36 + 0.075, pt - 0.115) net=n2
  l23 = rect li xspan=(x6 - 0.225, x6 + 0.01) yspan=(pt - WP2 + 0.05, pt - 0.115) net=n2
  l24 = rect li xspan=(x6 - 0.225, x7 + L - 0.02) yspan=(pt - WP2 + 0.05, pt - WP2 + 0.22) net=n2
  l25 = rect li xspan=(x6 - 0.165, x6 + 0.01) yspan=(pt - WP2 + 0.05, pt - 0.02) net=n2
  l26 = rect li xspan=(x6 + 0.02, x7 + L - 0.02) yspan=(nb + WN2 + 0.045, pt - WP2 + 0.22) net=n2
  l27 = rect li xspan=(x6 + 0.02, x8 - 0.055) yspan=(nb + WN2 + 0.045, nb + WN - 0.015) net=n2
  l28 = rect li xspan=(x7 + L - 0.01, x8 - 0.055) yspan=(nb + 0.02, nb + WN - 0.015) net=n2
  l29 = rect li xspan=(x7 + L + 0.01, x8 + L - 0.025) yspan=(pt - 0.36 + 0.13, pt - 0.06) net=n3
  l30 = rect li xspan=(x8 - 0.05, x11 + L + 0.225) yspan=(pt - WP2 - 0.01, pt - 0.36 - 0.12) net=n3
  l31 = rect li xspan=(x8 - 0.05, x8 + L - 0.025) yspan=(pt - WP2 - 0.01, pt - 0.06) net=n3
  l32 = rect li xspan=(x11 + L + 0.055, x11 + L + 0.225) yspan=(pt - WP2 - 0.01, pt - 0.02) net=n3
  l33 = rect li xspan=(x1 - 0.23, x1 - 0.06) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  l34 = rect li xspan=(x2 + L - 0.03, x3 - 0.14) yspan=(pt - 0.36 + 0.11, H + 0.085) net=VPWR
  l35 = rect li xspan=(x9 + L + 0.055, x10 + L - 0.025) yspan=(pt - 0.36 + 0.05, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 - 0.145) span=(-0.085 + 0.08, nb + WN + 0.045 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x6 - 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x11 + L + 0.045) span=(-0.085, nb + WN2 - 0.06) net=VGND
  c5 = array licon in=nd2 cx=(x2 + L + 0.14) span=(-0.085, nb + WN2 - 0.125) net=VGND
  c6 = array licon in=nd1 cx=(x4 - 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c7 = array licon in=nd1 cx=(x7 + L + 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.015 - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd2 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.075 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd2 cx=(x1 - 0.145) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x5 + L + 0.08) span=(pt - WP + 0.06 + 0.08, pt - WP2 + 0.06 - 0.08) net=n1
  c11 = array licon in=pd2 cx=(x1 + L + 0.14) span=(pt - WP + 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd3 cx=(x6 - 0.08) span=(pt - WP2 + 0.05 + 0.08, pt - 0.02 - 0.08) net=n2
  c13 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - WP2 - 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c14 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - 0.36 + 0.11, H + 0.085) net=VPWR
  c15 = array licon in=pd3 cx=(x8 - 0.045) span=(pt - 0.36 + 0.13, pt - 0.06) margin=0.04 net=n3
  c16 = array licon in=pd3 cx=(x10 - 0.045) span=(pt - 0.36 + 0.05 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x6 - 0.24) cy=(pt - WP - 0.33)
  gc2 = contact licon cx=(x2 + L - 0.03) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + 0.015) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x4 + L + 0.005) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x11 + L + 0.075) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x8 + L - 0.015) cy=(pt - WP - 0.015)
  np1 = rect npc xspan=(x1 - 0.415, x11 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x5 + L + 0.245, x6 - 0.055) yspan=(nb + WN, pt - WP - 0.14)
  np3 = rect npc xspan=(x8 - 0.055, x9 + L + 0.08) yspan=(nb + WN + 0.09, pt - WP + 0.17)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.135) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.05) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.09) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x8 - 0.095) cy=0
  mc8 = contact mcon cx=(x10 - 0.055) cy=0
  mc9 = contact mcon cx=(x11 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.185) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.135) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.175) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.05) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.09) cy=H
  mc15 = contact mcon cx=(x6 - 0.135) cy=H
  mc16 = contact mcon cx=(x8 - 0.095) cy=H
  mc17 = contact mcon cx=(x10 - 0.055) cy=H
  mc18 = contact mcon cx=(x11 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l6
  port A2_N in on=l5
  port B1 in on=l9
  port B2 in on=l7
  port X out on=l15
end
