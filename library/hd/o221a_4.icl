# o221a_4: lifted from sky130_fd_sc_hd__o221a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o221a_4 width=20 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M2 nmos w=WN l=L d=n3 g=B2 s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M4 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M5 pmos w=WP l=L d=n4 g=B1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M7 nmos w=WN l=L d=n1 g=B2 s=n3 b=VNB
  device M8 nmos w=WN l=L d=n1 g=B1 s=n3 b=VNB
  device M9 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M11 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M12 nmos w=WN l=L d=n3 g=B1 s=n1 b=VNB
  device M13 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M14 nmos w=WN l=L d=n2 g=C1 s=n3 b=VNB
  device M15 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M16 pmos w=WP l=L d=VPWR g=A1 s=n5 b=VPB
  device M17 nmos w=WN l=L d=n3 g=C1 s=n2 b=VNB
  device M18 pmos w=WP l=L d=n2 g=A2 s=n5 b=VPB
  device M19 pmos w=WP l=L d=n2 g=B2 s=n4 b=VPB
  device M20 pmos w=WP l=L d=VPWR g=C1 s=n2 b=VPB
  device M21 pmos w=WP l=L d=n2 g=C1 s=VPWR b=VPB
  device M22 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M23 pmos w=WP l=L d=n5 g=A2 s=n2 b=VPB
  device M24 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M25 pmos w=WP l=L d=n4 g=B2 s=n2 b=VPB
  device M26 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M27 nmos w=WN l=L d=X g=n2 s=VGND b=VNB

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
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  x14 = x13 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x7 - 0.265, x14 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x14 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6 - 0.055, x6 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7 - 0.135, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x10 - 0.065, x10 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x11, x14 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p20 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p22 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x6 + L + 0.315) yspan=(nb + 0.02, nb + 0.24) net=n3
  l2 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.01) net=n3
  l3 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l4 = rect li xspan=(x3 + L - 0.03, x6 + 0.04) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x3 + L - 0.03, x8 + 0.03) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x3 + L - 0.03, x10 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n1
  l7 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x7 - 0.295, x7 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l10 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l11 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l12 = rect li xspan=(x12 + L + 0.055, x13 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l13 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.31) yspan=(-0.085, nb + 0.33) net=VGND
  l14 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C1
  l15 = rect li xspan=(x4 + 0.035, x5 + L + 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l16 = rect li xspan=(x8 - 0.085, x9 + L - 0.07) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l17 = rect li xspan=(x2 + L + 0.065, x3 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l18 = rect li xspan=(x2 + L + 0.065, x6 + L + 0.105) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B1
  l19 = rect li xspan=(x6 - 0.085, x6 + L + 0.105) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l20 = rect li xspan=(x6 + L + 0.365, x7 + L + 0.025) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l21 = rect li xspan=(x6 + L + 0.365, x10 + L - 0.07) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A1
  l22 = rect li xspan=(x9 + L + 0.105, x11 - 0.085) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l23 = rect li xspan=(x9 + L + 0.105, x10 + L - 0.07) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l24 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.41, nb + WN - 0.02) net=n2
  l25 = rect li xspan=(x1 + L + 0.025, x2) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l26 = rect li xspan=(x1 + L + 0.025, x11 + 0.03) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n2
  l27 = rect li xspan=(x1 + L + 0.07, x2 + 0.03) yspan=(nb + 0.41, pt - WP + 0.47) net=n2
  l28 = rect li xspan=(x4 + L + 0.025, x5) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=n2
  l29 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=n2
  l30 = rect li xspan=(x10 + L + 0.135, x11 + L + 0.115) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n2
  l31 = rect li xspan=(x10 + L + 0.135, x11 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.47) net=n2
  l32 = rect li xspan=(x11 + L - 0.06, x14 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=n2
  l33 = rect li xspan=(x11 + L - 0.06, x11 + L + 0.115) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=n2
  l34 = rect li xspan=(x3 + L + 0.025, x4) yspan=(pt - WP + 0.64, pt - 0.02) net=n4
  l35 = rect li xspan=(x3 + L + 0.025, x6) yspan=(pt - 0.19, pt - 0.02) net=n4
  l36 = rect li xspan=(x5 + L + 0.025, x6) yspan=(pt - 0.36, pt - 0.02) net=n4
  l37 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP + 0.64, pt - 0.02) net=n5
  l38 = rect li xspan=(x7 + L + 0.015, x10 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n5
  l39 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n5
  l40 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l41 = rect li xspan=(x11 + L - 0.03, x14 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l42 = rect li xspan=(x11 + L - 0.03, x14 + L + 0.4) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=X
  l43 = rect li xspan=(x11 + L + 0.055, x12 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=X
  l44 = rect li xspan=(x11 + L + 0.055, x13 - 0.06) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=X
  l45 = rect li xspan=(x12 + L + 0.05, x14 + L + 0.4) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=X
  l46 = rect li xspan=(x12 + L + 0.05, x13 - 0.06) yspan=(pt - WP - 0.04, pt - WP + 0.47) net=X
  l47 = rect li xspan=(x13 + L - 0.03, x14 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l48 = rect li xspan=(x13 + L + 0.015, x14 - 0.015) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l49 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.4) yspan=(nb + WN - 0.15, pt - WP + 0.13) net=X
  l50 = rect li xspan=(x1 - 0.255, x1) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  l51 = rect li xspan=(x2 + L + 0.025, x3) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l52 = rect li xspan=(x6 + L + 0.025, x7 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l53 = rect li xspan=(x10 + L + 0.015, x11 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l54 = rect li xspan=(x12 + L + 0.015, x13 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l55 = rect li xspan=(x14 + L + 0.015, x14 + L + 0.265) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.02, nb + 0.24) net=n3
  c2 = array licon in=nd2 cx=(x7 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.01 - 0.08) net=n3
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n3
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.24) margin=0.04 net=n3
  c6 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c8 = array licon in=nd2 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c10 = array licon in=nd2 cx=(x12 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c11 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c12 = array licon in=nd2 cx=(x14 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) net=VGND
  c13 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c14 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.41, nb + WN - 0.02) margin=0.04 net=n2
  c15 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n1
  c16 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n1
  c17 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x13 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c19 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c21 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c22 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c23 = array licon in=pd1 cx=(x14 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) net=VPWR
  c24 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.64 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c26 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c27 = array licon in=pd1 cx=(x6 + L + 0.15) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd1 cx=(x7 - 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c29 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.64 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n5
  c30 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n5
  c31 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c32 = array licon in=pd1 cx=(x12 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L - 0.065) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + 0.005) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + L/2) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x11 + L + 0.14) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x12 + L + 0.11) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x13 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x14 + L + 0.84) yspan=(nb + WN + 0.09, pt - WP - 0.14)
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
  mc12 = contact mcon cx=(x11 + L + 0.03) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.07) cy=0
  mc14 = contact mcon cx=(x13 + L + 0.11) cy=0
  mc15 = contact mcon cx=(x14 + L + 0.15) cy=0
  mc16 = contact mcon cx=(x14 + L + 0.61) cy=0
  mc17 = contact mcon cx=(x1 - 0.17) cy=H
  mc18 = contact mcon cx=(x2 - 0.13) cy=H
  mc19 = contact mcon cx=(x3 - 0.09) cy=H
  mc20 = contact mcon cx=(x4 - 0.05) cy=H
  mc21 = contact mcon cx=(x5 - 0.01) cy=H
  mc22 = contact mcon cx=(x6 + 0.035) cy=H
  mc23 = contact mcon cx=(x6 + L + 0.35) cy=H
  mc24 = contact mcon cx=(x7 + 0.015) cy=H
  mc25 = contact mcon cx=(x8 + 0.055) cy=H
  mc26 = contact mcon cx=(x9 + L - 0.055) cy=H
  mc27 = contact mcon cx=(x10 + L - 0.015) cy=H
  mc28 = contact mcon cx=(x11 + L + 0.03) cy=H
  mc29 = contact mcon cx=(x12 + L + 0.07) cy=H
  mc30 = contact mcon cx=(x13 + L + 0.11) cy=H
  mc31 = contact mcon cx=(x14 + L + 0.15) cy=H
  mc32 = contact mcon cx=(x14 + L + 0.61) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l22
  port A2 in on=l16
  port B1 in on=l17
  port B2 in on=l15
  port C1 in on=l14
  port X out on=l45
end
