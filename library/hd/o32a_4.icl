# o32a_4: lifted from sky130_fd_sc_hd__o32a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o32a_4 width=22 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M2 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n2 g=A3 s=n1 b=VPB
  device M4 pmos w=WP l=L d=n3 g=B2 s=n1 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n3 b=VPB
  device M7 pmos w=WP l=L d=n1 g=A3 s=n2 b=VPB
  device M8 pmos w=WP l=L d=n1 g=B2 s=n3 b=VPB
  device M9 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=n3 g=B1 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=n1 g=B2 s=n4 b=VNB
  device M12 nmos w=WN l=L d=VGND g=A3 s=n4 b=VNB
  device M13 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M14 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M15 nmos w=WN l=L d=n4 g=B1 s=n1 b=VNB
  device M16 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M17 nmos w=WN l=L d=VGND g=A1 s=n4 b=VNB
  device M18 pmos w=WP l=L d=n5 g=A2 s=n2 b=VPB
  device M19 nmos w=WN l=L d=n4 g=A1 s=VGND b=VNB
  device M20 nmos w=WN l=L d=n1 g=B1 s=n4 b=VNB
  device M21 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M22 pmos w=WP l=L d=VPWR g=A1 s=n5 b=VPB
  device M23 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M24 nmos w=WN l=L d=n4 g=A3 s=VGND b=VNB
  device M25 pmos w=WP l=L d=n2 g=A2 s=n5 b=VPB
  device M26 nmos w=WN l=L d=n4 g=B2 s=n1 b=VNB
  device M27 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.3
  x6 = x5 + L + 0.28
  x7 = x6 + 0.08
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.8
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.31
  x13 = x12 + L + 0.8
  x14 = x13 + L + 0.28
  x15 = x14 + L + 0.28
  x16 = x15 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 - 0.095) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x9 - 0.265, x12 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x13 - 0.265, x16 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 - 0.035) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 + L + 0.095, x8 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x9 - 0.265, x12 + L + 0.265) yspan=(pt - WP, pt)
  pd4 = rect diff xspan=(x13 - 0.265, x16 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p8 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p12 = rect poly xspan=(x9 - 0.06, x10 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x11, x12 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x13 - 0.3, x16 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p22 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=n4
  l2 = rect li xspan=(x1 - 0.315, x8 - 0.055) yspan=(nb + WN - 0.25, nb + WN) net=n4
  l3 = rect li xspan=(x7 + L - 0.03, x12 + L + 0.305) yspan=(nb + 0.02, nb + 0.23) net=n4
  l4 = rect li xspan=(x7 + L - 0.03, x8 - 0.055) yspan=(nb + 0.02, nb + WN) net=n4
  l5 = rect li xspan=(x1 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l6 = rect li xspan=(x13 - 0.225, x13 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l7 = rect li xspan=(x14 + L + 0.055, x15 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l8 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.31) yspan=(-0.085, nb + 0.31) net=VGND
  l9 = rect li xspan=(x1 - 0.25, x2 - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l10 = rect li xspan=(x2 + L + 0.11, x4 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l11 = rect li xspan=(x5 - 0.09, x7 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A3
  l12 = rect li xspan=(x9 - 0.09, x9 + L + 0.13) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B1
  l13 = rect li xspan=(x11 - 0.01, x12 + 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l14 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(nb + WN + 0.22, pt - WP + 0.56) net=n1
  l15 = rect li xspan=(x7 + L + 0.055, x9 - 0.315) yspan=(nb + WN + 0.22, nb + WN + 0.39) net=n1
  l16 = rect li xspan=(x8 + L + 0.295, x12 + L + 0.385) yspan=(nb + 0.4, nb + WN - 0.08) net=n1
  l17 = rect li xspan=(x8 + L + 0.295, x9 - 0.315) yspan=(nb + 0.4, nb + WN + 0.39) net=n1
  l18 = rect li xspan=(x10 + 0.025, x10 + L + 0.1) yspan=(nb + 0.4, pt - WP + 0.13) net=n1
  l19 = rect li xspan=(x10 + 0.025, x12 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n1
  l20 = rect li xspan=(x11 + L + 0.085, x12 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.63) net=n1
  l21 = rect li xspan=(x12 + L + 0.13, x12 + L + 0.385) yspan=(nb + 0.4, pt - WP - 0.22) net=n1
  l22 = rect li xspan=(x12 + L + 0.13, x16 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l23 = rect li xspan=(x12 + L + 0.13, x13 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.22) net=n1
  l24 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n5
  l25 = rect li xspan=(x1 - 0.315, x3 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=n5
  l26 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n5
  l27 = rect li xspan=(x2 + L - 0.03, x5 + 0.01) yspan=(pt - 0.19, pt - 0.02) net=n5
  l28 = rect li xspan=(x4 + L - 0.03, x5 + 0.01) yspan=(pt - 0.625, pt - 0.02) net=n5
  l29 = rect li xspan=(x3 + L + 0.055, x7 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.205) net=n2
  l30 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.56) net=n2
  l31 = rect li xspan=(x5 + L + 0.055, x7 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l32 = rect li xspan=(x5 + L + 0.055, x8 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=n2
  l33 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.305) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l34 = rect li xspan=(x9 - 0.305, x9 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n3
  l35 = rect li xspan=(x9 - 0.305, x11 + 0.03) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n3
  l36 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l37 = rect li xspan=(x10 + L - 0.03, x12 + L + 0.305) yspan=(pt - 0.2, pt - 0.02) net=n3
  l38 = rect li xspan=(x12 + L - 0.03, x12 + L + 0.305) yspan=(pt - WP - 0.04, pt - 0.02) net=n3
  l39 = rect li xspan=(x13 + L - 0.03, x14 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l40 = rect li xspan=(x13 + L - 0.03, x16 + L + 0.545) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=X
  l41 = rect li xspan=(x13 + L - 0.03, x14 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l42 = rect li xspan=(x13 + L - 0.03, x16 + L + 0.545) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=X
  l43 = rect li xspan=(x15 + L - 0.03, x16 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l44 = rect li xspan=(x15 + L - 0.03, x16 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l45 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.545) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=X
  l46 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l47 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l48 = rect li xspan=(x13 - 0.225, x13 - 0.055) yspan=(pt - WP + 0.35, H + 0.085) net=VPWR
  l49 = rect li xspan=(x14 + L + 0.055, x15 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l50 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.31) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n4
  c5 = array licon in=nd2 cx=(x12 - 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n4
  c6 = array licon in=nd3 cx=(x13 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c7 = array licon in=nd3 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c8 = array licon in=nd3 cx=(x14 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd3 cx=(x15 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c10 = array licon in=nd3 cx=(x16 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c11 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n4
  c12 = array licon in=nd1 cx=(x7 + L + 0.06) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n4
  c13 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + WN - 0.25, nb + WN) margin=0.04 net=n4
  c14 = array licon in=nd1 cx=(x5 - 0.14) span=(nb + WN - 0.25, nb + WN) margin=0.04 net=n4
  c15 = array licon in=nd2 cx=(x9 - 0.14) span=(nb + 0.4, nb + WN - 0.08) net=n1
  c16 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.4, nb + WN - 0.08) margin=0.04 net=n1
  c17 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.4, nb + WN - 0.08) net=n1
  c18 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n5
  c19 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=n5
  c20 = array licon in=pd2 cx=(x6 - 0.06) span=(pt - WP - 0.04, pt - 0.02) net=n2
  c21 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n2
  c22 = array licon in=pd3 cx=(x9 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n3
  c23 = array licon in=pd3 cx=(x12 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n3
  c24 = array licon in=pd4 cx=(x13 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=X
  c25 = array licon in=pd4 cx=(x15 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=X
  c26 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.56 - 0.08) margin=0.04 net=n2
  c27 = array licon in=pd2 cx=(x7 + L + 0.14) span=(nb + WN + 0.22 + 0.08, pt - WP + 0.56 - 0.08) margin=0.04 net=n1
  c28 = array licon in=pd3 cx=(x12 - 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.63 - 0.08) margin=0.04 net=n1
  c29 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c30 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.625, pt - 0.02) net=n5
  c31 = array licon in=pd3 cx=(x10 + L + 0.14) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=n3
  c32 = array licon in=pd4 cx=(x13 - 0.14) span=(pt - WP + 0.35 + 0.08, H + 0.085 - 0.08) net=VPWR
  c33 = array licon in=pd4 cx=(x14 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c34 = array licon in=pd4 cx=(x16 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c35 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.07) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 - 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x9 + L - 0.04) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x11 + L + 0.155) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x13 - 0.135) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x13 + L + 0.14) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x14 + L + 0.14) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x15 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x16 + L + 0.69) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.03) cy=0
  mc6 = contact mcon cx=(x6 + 0.015) cy=0
  mc7 = contact mcon cx=(x8 - 0.03) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.29) cy=0
  mc9 = contact mcon cx=(x9 - 0.05) cy=0
  mc10 = contact mcon cx=(x10 - 0.01) cy=0
  mc11 = contact mcon cx=(x11 + 0.035) cy=0
  mc12 = contact mcon cx=(x12 + 0.045) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.36) cy=0
  mc14 = contact mcon cx=(x13 + 0.025) cy=0
  mc15 = contact mcon cx=(x14 + 0.065) cy=0
  mc16 = contact mcon cx=(x15 + L - 0.045) cy=0
  mc17 = contact mcon cx=(x16 + L - 0.005) cy=0
  mc18 = contact mcon cx=(x16 + L + 0.46) cy=0
  mc19 = contact mcon cx=(x1 - 0.17) cy=H
  mc20 = contact mcon cx=(x2 - 0.13) cy=H
  mc21 = contact mcon cx=(x3 - 0.09) cy=H
  mc22 = contact mcon cx=(x4 - 0.05) cy=H
  mc23 = contact mcon cx=(x5 - 0.03) cy=H
  mc24 = contact mcon cx=(x6 + 0.015) cy=H
  mc25 = contact mcon cx=(x8 - 0.03) cy=H
  mc26 = contact mcon cx=(x8 + L + 0.29) cy=H
  mc27 = contact mcon cx=(x9 - 0.05) cy=H
  mc28 = contact mcon cx=(x10 - 0.01) cy=H
  mc29 = contact mcon cx=(x11 + 0.035) cy=H
  mc30 = contact mcon cx=(x12 + 0.045) cy=H
  mc31 = contact mcon cx=(x12 + L + 0.36) cy=H
  mc32 = contact mcon cx=(x13 + 0.025) cy=H
  mc33 = contact mcon cx=(x14 + 0.065) cy=H
  mc34 = contact mcon cx=(x15 + L - 0.045) cy=H
  mc35 = contact mcon cx=(x16 + L - 0.005) cy=H
  mc36 = contact mcon cx=(x16 + L + 0.46) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l9
  port A2 in on=l10
  port A3 in on=l11
  port B1 in on=l12
  port B2 in on=l13
  port X out on=l40
end
