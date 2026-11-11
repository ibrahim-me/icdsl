# a32o_4: lifted from sky130_fd_sc_hd__a32o_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a32o_4 width=21 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B2 s=n2 b=VPB
  device M1 nmos w=WN l=L d=n3 g=A1 s=n2 b=VNB
  device M2 nmos w=WN l=L d=n2 g=B1 s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=A3 s=n5 b=VNB
  device M4 pmos w=WP l=L d=n1 g=A3 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n5 g=A2 s=n3 b=VNB
  device M6 nmos w=WN l=L d=n4 g=B1 s=n2 b=VNB
  device M7 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M8 nmos w=WN l=L d=n5 g=A3 s=VGND b=VNB
  device M9 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M10 nmos w=WN l=L d=n3 g=A2 s=n5 b=VNB
  device M11 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M12 nmos w=WN l=L d=VGND g=B2 s=n4 b=VNB
  device M13 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M14 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M15 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M16 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M17 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M18 nmos w=WN l=L d=n4 g=B2 s=VGND b=VNB
  device M19 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M20 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M21 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M22 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M23 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M24 pmos w=WP l=L d=n2 g=B2 s=n1 b=VPB
  device M25 nmos w=WN l=L d=n2 g=A1 s=n3 b=VNB
  device M26 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M27 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.8
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  x11 = x10 + L + 1.135
  x12 = x11 + 0.045
  x13 = x12 + L + 0.235
  x14 = x13 + 0.045
  x15 = x14 + L + 0.28
  x16 = x15 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x7 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x11 - 0.265, x16 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x7 - 0.265, x16 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x6 + L + 0.07) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x6 + L + 0.24) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7 - 0.105, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.14)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.14, pt - WP - 0.14)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x10, x10 + L + 0.235) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p18 = rect poly xspan=(x11 - 0.06, x14 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p19 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.19)
  p20 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p21 = rect poly xspan=(x12, x14 + L) yspan=(nb + WN + 0.14, pt - WP - 0.16)
  p22 = rect poly xspan=(x13, x14) yspan=(0.105, pt - WP - 0.16)
  p23 = rect poly xspan=(x14, x13 + L) yspan=(0.105, H - 0.105)
  p24 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p25 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p26 = rect poly xspan=(x15, x16 + L) yspan=(nb + WN + 0.14, pt - WP - 0.16)
  p27 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p28 = rect poly xspan=(x16, x16 + L + 0.29) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x7 - 0.305, x10 + L + 0.305) yspan=(nb + 0.06, nb + 0.23) net=n3
  l2 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l5 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(-0.085, nb + 0.23) net=VGND
  l6 = rect li xspan=(x15 + L - 0.03, x16 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l7 = rect li xspan=(x11 - 0.305, x15 - 0.055) yspan=(nb + 0.06, nb + 0.23) net=n4
  l8 = rect li xspan=(x14 + L + 0.055, x15 - 0.055) yspan=(nb + 0.02, nb + WN - 0.07) net=n4
  l9 = rect li xspan=(x14 + L + 0.055, x16 + L + 0.225) yspan=(nb + WN - 0.24, nb + WN - 0.07) net=n4
  l10 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.07) net=n4
  l11 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n5
  l12 = rect li xspan=(x5 + L + 0.055, x8 + 0.03) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n5
  l13 = rect li xspan=(x5 + L - 0.015, x7 - 0.335) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=A3
  l14 = rect li xspan=(x7 - 0.105, x8 + L + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A2
  l15 = rect li xspan=(x9 + 0.005, x10 + L + 0.235) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A1
  l16 = rect li xspan=(x11 - 0.345, x15 - 0.08) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=B1
  l17 = rect li xspan=(x15 + L + 0.03, x16 + L + 0.29) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=B2
  l18 = rect li xspan=(x15 + L + 0.03, x16 - 0.055) yspan=(nb + WN + 0.19, pt - WP + 0.15) net=B2
  l19 = rect li xspan=(x1 + L + 0.03, x5 - 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l20 = rect li xspan=(x4 + L - 0.005, x5 - 0.11) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n2
  l21 = rect li xspan=(x4 + L - 0.005, x11 - 0.525) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l22 = rect li xspan=(x9 + L - 0.03, x14 - 0.01) yspan=(nb + 0.4, nb + WN - 0.08) net=n2
  l23 = rect li xspan=(x10 + L + 0.44, x11 - 0.525) yspan=(nb + 0.4, pt - 0.41) net=n2
  l24 = rect li xspan=(x10 + L + 0.44, x12 + L + 0.04) yspan=(pt - WP + 0.42, pt - WP + 0.43) net=n2
  l25 = rect li xspan=(x10 + L + 0.44, x16 + 0.03) yspan=(pt - WP + 0.43, pt - 0.41) net=n2
  l26 = rect li xspan=(x11 + L + 0.015, x16 + 0.03) yspan=(pt - WP + 0.43, pt - 0.4) net=n2
  l27 = rect li xspan=(x1 - 0.28, x4 - 0.055) yspan=(nb + 0.4, nb + WN - 0.08) net=X
  l28 = rect li xspan=(x1 - 0.28, x1 - 0.06) yspan=(nb + 0.4, pt - WP + 0.18) net=X
  l29 = rect li xspan=(x1 - 0.28, x4 - 0.055) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=X
  l30 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l31 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l32 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l33 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l34 = rect li xspan=(x5 + L + 0.055, x10 + L + 0.225) yspan=(pt - WP + 0.43, pt - 0.4) net=n1
  l35 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l36 = rect li xspan=(x7 - 0.225, x7 - 0.055) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l37 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l38 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(pt - WP + 0.43, pt - 0.06) net=n1
  l39 = rect li xspan=(x10 + L + 0.055, x16 + L + 0.305) yspan=(pt - 0.23, pt - 0.06) net=n1
  l40 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.305) yspan=(pt - WP + 0.27, pt - 0.06) net=n1
  l41 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l42 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l43 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l44 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l45 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l46 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c5 = array licon in=nd2 cx=(x7 - 0.14) span=(nb + 0.06, nb + 0.23) net=n3
  c6 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n3
  c7 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.06, nb + 0.23) net=n3
  c8 = array licon in=nd3 cx=(x11 - 0.14) span=(nb + 0.06, nb + 0.23) net=n4
  c9 = array licon in=nd3 cx=(x15 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n5
  c13 = array licon in=nd3 cx=(x14 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) margin=0.04 net=n4
  c14 = array licon in=nd3 cx=(x16 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) net=n4
  c15 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.4, nb + WN - 0.08) margin=0.04 net=n2
  c16 = array licon in=nd3 cx=(x12 + L + 0.095) span=(nb + 0.4, nb + WN - 0.08) margin=0.04 net=n2
  c17 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + WN - 0.23, nb + WN - 0.06) margin=0.04 net=n5
  c18 = array licon in=pd2 cx=(x16 + L + 0.14) span=(pt - WP + 0.27 + 0.08, pt - 0.06 - 0.08) net=n1
  c19 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c20 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c21 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.57, H + 0.085) net=VPWR
  c22 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd2 cx=(x13 - 0.095) span=(pt - WP + 0.43, pt - 0.4) margin=0.04 net=n2
  c25 = array licon in=pd2 cx=(x15 + L + 0.14) span=(pt - WP + 0.43, pt - 0.4) margin=0.04 net=n2
  c26 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.43 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c27 = array licon in=pd2 cx=(x7 - 0.14) span=(pt - WP + 0.43 + 0.08, pt - 0.02 - 0.08) net=n1
  c28 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.43 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c29 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  c30 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c31 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c32 = array licon in=pd2 cx=(x11 - 0.095) span=(pt - 0.23, pt - 0.06) margin=0.04 net=n1
  c33 = array licon in=pd2 cx=(x14 + L + 0.14) span=(pt - 0.23, pt - 0.06) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 + L + 0.115) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 - 0.125) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.075) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + 0.065) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 - 0.02) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x10 - 0.13) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L + 0.07) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x11 + L - 0.04) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x14 - 0.015) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x16 - 0.075) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x16 + L + 0.125) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x16 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 + 0.035) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.35) cy=0
  mc8 = contact mcon cx=(x7 + 0.015) cy=0
  mc9 = contact mcon cx=(x8 + 0.055) cy=0
  mc10 = contact mcon cx=(x9 + L - 0.055) cy=0
  mc11 = contact mcon cx=(x10 + L - 0.015) cy=0
  mc12 = contact mcon cx=(x10 + L + 0.45) cy=0
  mc13 = contact mcon cx=(x11 - 0.225) cy=0
  mc14 = contact mcon cx=(x12 + L + 0.05) cy=0
  mc15 = contact mcon cx=(x14 + L + 0.09) cy=0
  mc16 = contact mcon cx=(x15 + L + 0.13) cy=0
  mc17 = contact mcon cx=(x16 + L + 0.17) cy=0
  mc18 = contact mcon cx=(x1 - 0.17) cy=H
  mc19 = contact mcon cx=(x2 - 0.13) cy=H
  mc20 = contact mcon cx=(x3 - 0.09) cy=H
  mc21 = contact mcon cx=(x4 - 0.05) cy=H
  mc22 = contact mcon cx=(x5 - 0.01) cy=H
  mc23 = contact mcon cx=(x6 + 0.035) cy=H
  mc24 = contact mcon cx=(x6 + L + 0.35) cy=H
  mc25 = contact mcon cx=(x7 + 0.015) cy=H
  mc26 = contact mcon cx=(x8 + 0.055) cy=H
  mc27 = contact mcon cx=(x9 + L - 0.055) cy=H
  mc28 = contact mcon cx=(x10 + L - 0.015) cy=H
  mc29 = contact mcon cx=(x10 + L + 0.45) cy=H
  mc30 = contact mcon cx=(x11 - 0.225) cy=H
  mc31 = contact mcon cx=(x12 + L + 0.05) cy=H
  mc32 = contact mcon cx=(x14 + L + 0.09) cy=H
  mc33 = contact mcon cx=(x15 + L + 0.13) cy=H
  mc34 = contact mcon cx=(x16 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l15
  port A2 in on=l14
  port A3 in on=l13
  port B1 in on=l16
  port B2 in on=l17
  port X out on=l28
end
