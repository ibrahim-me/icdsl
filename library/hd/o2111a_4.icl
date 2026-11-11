# o2111a_4: lifted from sky130_fd_sc_hd__o2111a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2111a_4 width=21 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n1 g=B1 s=n3 b=VNB
  device M3 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=n4 g=A2 s=n2 b=VPB
  device M6 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M7 nmos w=WN l=L d=n3 g=C1 s=n5 b=VNB
  device M8 nmos w=WN l=L d=n6 g=B1 s=n1 b=VNB
  device M9 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M10 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A1 s=n7 b=VPB
  device M13 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M14 nmos w=WN l=L d=n5 g=C1 s=n6 b=VNB
  device M15 pmos w=WP l=L d=n7 g=A2 s=n4 b=VPB
  device M16 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M17 nmos w=WN l=L d=n4 g=D1 s=n5 b=VNB
  device M18 pmos w=WP l=L d=n4 g=C1 s=VPWR b=VPB
  device M19 nmos w=WN l=L d=n5 g=D1 s=n4 b=VNB
  device M20 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M21 pmos w=WP l=L d=n4 g=B1 s=VPWR b=VPB
  device M22 pmos w=WP l=L d=n4 g=D1 s=VPWR b=VPB
  device M23 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M24 pmos w=WP l=L d=VPWR g=D1 s=n4 b=VPB
  device M25 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M26 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M27 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.22
  x7 = x6 + 0.06
  x8 = x7 + L + 0.62
  x9 = x8 + L + 0.015
  x10 = x9 + L + 0.13
  x11 = x10 + L + 0.055
  x12 = x11 + L + 0.095
  x13 = x12 + L + 0.045
  x14 = x13 + L + 0.18
  x15 = x14 + L + 0.06
  x16 = x15 + L + 0.455
  x17 = x16 + 0.145
  x18 = x17 + L + 0.22
  x19 = x18 + 0.06
  x20 = x19 + L + 0.235
  x21 = x20 + 0.045
  x22 = x21 + L + 0.26
  x23 = x22 + 0.02
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.205) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x8 - 0.11, x23 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x15 + L + 0.065) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x16 - 0.12, x23 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.28, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1 - 0.28, x2 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.13, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.18) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p13 = rect poly xspan=(x8 - 0.125, x9 + 0.055) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x8 - 0.115, x9 + L) yspan=(nb + WN + 0.075, pt - WP - 0.385)
  p15 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.075, H - 0.105)
  p16 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.385)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(pt - WP - 0.195, H - 0.105)
  p18 = rect poly xspan=(x10 + 0.055, x12 + L) yspan=(pt - WP - 0.23, pt - WP - 0.075)
  p19 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.075)
  p20 = rect poly xspan=(x11, x12 + L) yspan=(nb + WN + 0.1, pt - WP - 0.075)
  p21 = rect poly xspan=(x11, x13 + L) yspan=(nb + WN + 0.1, nb + WN + 0.25)
  p22 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.1, H - 0.105)
  p23 = rect poly xspan=(x13, x13 + L) yspan=(0.105, nb + WN + 0.25)
  p24 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.375, H - 0.105)
  p25 = rect poly xspan=(x14, x15 - 0.015) yspan=(nb + WN + 0.375, pt - WP - 0.08)
  p26 = rect poly xspan=(x14 + 0.04, x15 + L + 0.025) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p27 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.19)
  p28 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.19)
  p29 = rect poly xspan=(x16, x23 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p30 = rect poly xspan=(x17, x17 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p31 = rect poly xspan=(x18, x18 + L) yspan=(0.105, pt - WP - 0.19)
  p32 = rect poly xspan=(x19, x19 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p33 = rect poly xspan=(x20, x20 + L) yspan=(0.105, pt - WP - 0.19)
  p34 = rect poly xspan=(x21, x21 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p35 = rect poly xspan=(x22, x22 + L) yspan=(0.105, pt - WP - 0.19)
  p36 = rect poly xspan=(x23, x22 + L) yspan=(0.105, H - 0.105)
  p37 = rect poly xspan=(x23, x23 + L) yspan=(nb + WN + 0.14, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x8 - 0.15, x9 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x11 + L - 0.03, x13 + 0.07) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x15 + L + 0.075, x16 - 0.115) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x18 + L + 0.01, x21 - 0.02) yspan=(-0.085, nb + 0.29) net=VGND
  l5 = rect li xspan=(x22 + L - 0.03, x23 + L + 0.315) yspan=(-0.085, nb + 0.29) net=VGND
  l6 = rect li xspan=(x1 - 0.3, x7 + L + 0.3) yspan=(nb + 0.02, nb + 0.25) net=n5
  l7 = rect li xspan=(x1 - 0.3, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n5
  l8 = rect li xspan=(x4 + 0.065, x15 - 0.025) yspan=(nb + WN - 0.23, nb + WN) net=n1
  l9 = rect li xspan=(x9 + L + 0.055, x10 + L - 0.005) yspan=(nb + 0.02, nb + WN) net=n1
  l10 = rect li xspan=(x14 - 0.085, x15 - 0.025) yspan=(nb + 0.02, nb + WN) net=n1
  l11 = rect li xspan=(x4 + L - 0.03, x5 + L - 0.01) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=B1
  l12 = rect li xspan=(x11 + 0.015, x13 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A1
  l13 = rect li xspan=(x12 + 0.02, x13 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=A1
  l14 = rect li xspan=(x1 - 0.28, x1 - 0.06) yspan=(nb + WN + 0.11, pt - WP + 0.17) net=D1
  l15 = rect li xspan=(x3 - 0.09, x3 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP + 0.175) net=C1
  l16 = rect li xspan=(x3 - 0.09, x7 + L + 0.02) yspan=(pt - WP + 0.005, pt - WP + 0.175) net=C1
  l17 = rect li xspan=(x6 + 0.01, x7 + L + 0.18) yspan=(nb + WN + 0.195, pt - WP - 0.165) net=C1
  l18 = rect li xspan=(x6 + 0.01, x7 + L + 0.02) yspan=(nb + WN + 0.195, pt - WP + 0.175) net=C1
  l19 = rect li xspan=(x7 - 0.005, x7 + L + 0.18) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=C1
  l20 = rect li xspan=(x8 - 0.125, x9 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l21 = rect li xspan=(x8 - 0.115, x9 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=A2
  l22 = rect li xspan=(x8 + 0.05, x9 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP + 0.175) net=A2
  l23 = rect li xspan=(x8 + 0.05, x15 + 0.01) yspan=(pt - WP + 0.005, pt - WP + 0.175) net=A2
  l24 = rect li xspan=(x14 + 0.04, x15 + L + 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=A2
  l25 = rect li xspan=(x14 + 0.04, x15 + 0.01) yspan=(nb + WN + 0.19, pt - WP + 0.175) net=A2
  l26 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP + 0.35, pt - 0.02) net=n4
  l27 = rect li xspan=(x1 - 0.31, x15 + L + 0.105) yspan=(pt - WP + 0.35, pt - 0.48) net=n4
  l28 = rect li xspan=(x1 + L - 0.03, x2 + 0.045) yspan=(nb + WN - 0.23, pt - 0.48) net=n4
  l29 = rect li xspan=(x1 + L - 0.03, x17 - 0.005) yspan=(pt - WP + 0.345, pt - 0.485) net=n4
  l30 = rect li xspan=(x2 + L + 0.055, x3 - 0.01) yspan=(pt - WP + 0.345, pt - 0.02) net=n4
  l31 = rect li xspan=(x4 + L - 0.01, x5 - 0.055) yspan=(pt - WP + 0.345, pt - 0.02) net=n4
  l32 = rect li xspan=(x7 + L + 0.055, x8 + 0.03) yspan=(pt - WP + 0.345, pt - 0.02) net=n4
  l33 = rect li xspan=(x14 + L + 0.015, x15 + L + 0.105) yspan=(pt - WP + 0.345, pt - 0.02) net=n4
  l34 = rect li xspan=(x16 - 0.035, x22 - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.165) net=n4
  l35 = rect li xspan=(x16 - 0.035, x17 - 0.005) yspan=(nb + WN + 0.19, pt - 0.485) net=n4
  l36 = rect li xspan=(x17 + L - 0.055, x18 - 0.045) yspan=(nb + 0.02, nb + WN - 0.02) net=X
  l37 = rect li xspan=(x17 + L - 0.055, x23 + L + 0.315) yspan=(nb + WN - 0.19, nb + WN - 0.02) net=X
  l38 = rect li xspan=(x17 + L + 0.055, x23 + L + 0.315) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=X
  l39 = rect li xspan=(x17 + L + 0.055, x18 + 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l40 = rect li xspan=(x21 + L, x22 - 0.055) yspan=(nb + 0.02, nb + WN - 0.02) net=X
  l41 = rect li xspan=(x21 + L + 0.045, x22 - 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l42 = rect li xspan=(x23 + L + 0.045, x23 + L + 0.315) yspan=(nb + WN - 0.19, pt - WP + 0.18) net=X
  l43 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l44 = rect li xspan=(x3 + L + 0.02, x4 - 0.035) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l45 = rect li xspan=(x5 + L - 0.03, x7 + 0.03) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l46 = rect li xspan=(x10 + L - 0.025, x12 + 0.025) yspan=(pt - 0.305, H + 0.085) net=VPWR
  l47 = rect li xspan=(x16 - 0.17, x16 + L + 0.025) yspan=(pt - 0.315, H + 0.085) net=VPWR
  l48 = rect li xspan=(x18 + L + 0.03, x21 + 0.02) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l49 = rect li xspan=(x22 + L, x23 + L + 0.31) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x19 + L + 0.09) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n5
  c3 = array licon in=nd1 cx=(x7 + L + 0.08) span=(nb + 0.02, nb + 0.25) net=n5
  c4 = array licon in=nd2 cx=(x8 + 0.02) span=(-0.085, nb + 0.25) net=VGND
  c5 = array licon in=nd2 cx=(x12 + 0.05) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x15 + L + 0.19) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x23 + L + 0.12) span=(-0.085, nb + 0.29) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n5
  c9 = array licon in=nd2 cx=(x10 + 0.06) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x14 + 0.015) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c11 = array licon in=nd2 cx=(x17 + L + 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd2 cx=(x21 + L + 0.1) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=X
  c13 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.23, pt - 0.48) margin=0.04 net=n4
  c14 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + WN - 0.23, nb + WN) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) net=n4
  c16 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.345 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c17 = array licon in=pd1 cx=(x8 - 0.14) span=(pt - WP + 0.345, pt - 0.02) margin=0.04 net=n4
  c18 = array licon in=pd1 cx=(x15 + L - 0.065) span=(pt - WP + 0.345 + 0.08, pt - 0.02 - 0.08) net=n4
  c19 = array licon in=pd2 cx=(x18 - 0.08) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c20 = array licon in=pd2 cx=(x22 - 0.12) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c21 = array licon in=pd2 cx=(x20 - 0.095) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd2 cx=(x23 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c23 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.345 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c24 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.345 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c25 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd2 cx=(x16 + 0.01) span=(pt - 0.315, H + 0.085) net=VPWR
  c27 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd1 cx=(x6 - 0.08) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  c29 = array licon in=pd1 cx=(x11 + L - 0.055) span=(pt - 0.305, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + 0.045) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x11 + L + 0.035) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x15 + 0.005) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x16 + L + 0.015) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=x18 cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x20 - 0.1) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x21 + L + 0.055) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x23 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x7 + 0.035) cy=0
  mc7 = contact mcon cx=(x8 - 0.27) cy=0
  mc8 = contact mcon cx=(x9 + 0.04) cy=0
  mc9 = contact mcon cx=(x11 + 0.035) cy=0
  mc10 = contact mcon cx=(x13 + L/2) cy=0
  mc11 = contact mcon cx=(x15 + 0.015) cy=0
  mc12 = contact mcon cx=(x16 - 0.125) cy=0
  mc13 = contact mcon cx=(x17 + L + 0.05) cy=0
  mc14 = contact mcon cx=(x19 + L + 0.09) cy=0
  mc15 = contact mcon cx=(x21 + L + 0.13) cy=0
  mc16 = contact mcon cx=(x23 + L + 0.17) cy=0
  mc17 = contact mcon cx=(x1 - 0.17) cy=H
  mc18 = contact mcon cx=(x2 - 0.13) cy=H
  mc19 = contact mcon cx=(x3 - 0.09) cy=H
  mc20 = contact mcon cx=(x4 - 0.05) cy=H
  mc21 = contact mcon cx=(x5 - 0.01) cy=H
  mc22 = contact mcon cx=(x7 + 0.035) cy=H
  mc23 = contact mcon cx=(x8 - 0.27) cy=H
  mc24 = contact mcon cx=(x9 + 0.04) cy=H
  mc25 = contact mcon cx=(x11 + 0.035) cy=H
  mc26 = contact mcon cx=(x13 + L/2) cy=H
  mc27 = contact mcon cx=(x15 + 0.015) cy=H
  mc28 = contact mcon cx=(x16 - 0.125) cy=H
  mc29 = contact mcon cx=(x17 + L + 0.05) cy=H
  mc30 = contact mcon cx=(x19 + L + 0.09) cy=H
  mc31 = contact mcon cx=(x21 + L + 0.13) cy=H
  mc32 = contact mcon cx=(x23 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l12
  port A2 in on=l20
  port B1 in on=l11
  port C1 in on=l17
  port D1 in on=l14
  port X out on=l37
end
