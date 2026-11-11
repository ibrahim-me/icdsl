# o311a_4: lifted from sky130_fd_sc_hd__o311a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o311a_4 width=22 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=C1 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=n1 g=B1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=VPWR g=C1 s=n1 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M4 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M5 nmos w=WN l=L d=n1 g=C1 s=n3 b=VNB
  device M6 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M7 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M8 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M9 nmos w=WN l=L d=VGND g=A3 s=n2 b=VNB
  device M10 pmos w=WP l=L d=n4 g=A2 s=n5 b=VPB
  device M11 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M12 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M13 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M14 nmos w=WN l=L d=n3 g=C1 s=n1 b=VNB
  device M15 pmos w=WP l=L d=n5 g=A2 s=n4 b=VPB
  device M16 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M17 pmos w=WP l=L d=n1 g=A3 s=n5 b=VPB
  device M18 nmos w=WN l=L d=n2 g=A3 s=VGND b=VNB
  device M19 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M20 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M21 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M22 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M23 pmos w=WP l=L d=n5 g=A3 s=n1 b=VPB
  device M24 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M25 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M26 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M27 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.62
  x6 = x5 + L + 0.04
  x7 = x6 + L + 0.1
  x8 = x7 + L + 0.04
  x9 = x8 + L + 0.1
  x10 = x9 + L + 0.04
  x11 = x10 + L + 0.1
  x12 = x11 + L + 0.04
  x13 = x12 + L + 0.64
  x14 = x13 + L + 0.03
  x15 = x14 + L + 0.11
  x16 = x15 + L + 0.38
  x17 = x16 + L + 0.28
  x18 = x17 + L + 0.28
  x19 = x18 + L + 0.28
  x20 = x19 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.085, x12 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x13 - 0.095, x20 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x12 + L + 0.085) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x13 - 0.265, x16 - 0.115) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x16 + L + 0.015, x20 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5 - 0.1, x7 + L) yspan=(nb + WN + 0.075, pt - WP - 0.19)
  p7 = rect poly xspan=(x5 - 0.1, x8 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.075, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.075, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, nb + WN + 0.225)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.415, H - 0.105)
  p13 = rect poly xspan=(x9, x12 + 0.03) yspan=(nb + WN + 0.415, pt - WP - 0.075)
  p14 = rect poly xspan=(x9 + 0.01, x12 + L) yspan=(nb + WN + 0.41, pt - WP - 0.16)
  p15 = rect poly xspan=(x9 + 0.02, x12 + L) yspan=(nb + WN + 0.405, pt - WP - 0.16)
  p16 = rect poly xspan=(x9 + 0.03, x12 + L) yspan=(nb + WN + 0.4, pt - WP - 0.16)
  p17 = rect poly xspan=(x9 + 0.035, x12 + L) yspan=(nb + WN + 0.395, pt - WP - 0.16)
  p18 = rect poly xspan=(x9 + 0.04, x12 + L) yspan=(nb + WN + 0.39, pt - WP - 0.16)
  p19 = rect poly xspan=(x9 + 0.05, x12 + L) yspan=(nb + WN + 0.385, pt - WP - 0.16)
  p20 = rect poly xspan=(x9 + 0.055, x12 + L) yspan=(nb + WN + 0.38, pt - WP - 0.16)
  p21 = rect poly xspan=(x9 + 0.06, x12 + L) yspan=(nb + WN + 0.375, pt - WP - 0.16)
  p22 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.075)
  p23 = rect poly xspan=(x10, x12 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p24 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p25 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.16)
  p26 = rect poly xspan=(x13, x16 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p27 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p28 = rect poly xspan=(x14, x14 + L) yspan=(0.105, pt - WP - 0.19)
  p29 = rect poly xspan=(x15, x15 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p30 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.19)
  p31 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  p32 = rect poly xspan=(x17, x18 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p33 = rect poly xspan=(x18, x18 + L) yspan=(0.105, H - 0.105)
  p34 = rect poly xspan=(x19, x19 + L) yspan=(0.105, H - 0.105)
  p35 = rect poly xspan=(x19, x20 + L + 0.22) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p36 = rect poly xspan=(x20, x20 + L) yspan=(0.105, H - 0.105)
  p37 = rect poly xspan=(x20, x20 + L + 0.22) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.225) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x14 + L - 0.03, x16 + 0.03) yspan=(-0.085, nb + 0.27) net=VGND
  l5 = rect li xspan=(x17 + L - 0.03, x18 + 0.03) yspan=(-0.085, nb + 0.27) net=VGND
  l6 = rect li xspan=(x19 + L - 0.03, x20 + 0.03) yspan=(-0.085, nb + 0.27) net=VGND
  l7 = rect li xspan=(x5 - 0.225, x12 + L + 0.305) yspan=(nb + 0.02, nb + 0.27) net=n3
  l8 = rect li xspan=(x9 - 0.045, x9 + L - 0.02) yspan=(nb + 0.02, nb + WN) net=n3
  l9 = rect li xspan=(x10 + L - 0.03, x20 + L + 0.335) yspan=(nb + WN - 0.21, nb + WN) net=n2
  l10 = rect li xspan=(x13 - 0.155, x13 + L - 0.03) yspan=(nb + 0.02, nb + WN) net=n2
  l11 = rect li xspan=(x16 + L + 0.055, x17 - 0.055) yspan=(nb + 0.02, nb + WN) net=n2
  l12 = rect li xspan=(x18 + L + 0.055, x19 - 0.055) yspan=(nb + 0.02, nb + WN) net=n2
  l13 = rect li xspan=(x20 + L + 0.055, x20 + L + 0.335) yspan=(nb + 0.02, nb + WN) net=n2
  l14 = rect li xspan=(x5 - 0.305, x8 + 0.065) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=C1
  l15 = rect li xspan=(x9 - 0.01, x13 - 0.165) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=B1
  l16 = rect li xspan=(x13 + 0.02, x16 + L + 0.13) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A3
  l17 = rect li xspan=(x17 + 0.025, x19 - 0.07) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A2
  l18 = rect li xspan=(x19 + L - 0.035, x20 + L + 0.335) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A1
  l19 = rect li xspan=(x1 - 0.315, x2 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=X
  l20 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.02, pt - 0.02) net=X
  l21 = rect li xspan=(x1 + L + 0.055, x4 - 0.055) yspan=(nb + WN - 0.17, nb + WN) net=X
  l22 = rect li xspan=(x1 + L + 0.055, x4 - 0.055) yspan=(pt - WP, pt - WP + 0.24) net=X
  l23 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.02, nb + WN) net=X
  l24 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP, pt - 0.02) net=X
  l25 = rect li xspan=(x2 + L - 0.03, x4 + L + 0.145) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=n1
  l26 = rect li xspan=(x4 + L - 0.03, x8 + 0.03) yspan=(nb + WN - 0.17, nb + WN) net=n1
  l27 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.145) yspan=(nb + WN - 0.17, pt - WP + 0.24) net=n1
  l28 = rect li xspan=(x4 + L - 0.03, x14 + L + 0.055) yspan=(pt - WP, pt - WP + 0.24) net=n1
  l29 = rect li xspan=(x5 - 0.225, x8 + 0.03) yspan=(nb + WN - 0.21, nb + WN) net=n1
  l30 = rect li xspan=(x6 + 0.02, x6 + L + 0.045) yspan=(pt - WP, pt - 0.02) net=n1
  l31 = rect li xspan=(x10 + 0.02, x10 + L + 0.045) yspan=(pt - WP, pt - 0.02) net=n1
  l32 = rect li xspan=(x14 + 0.03, x14 + L + 0.055) yspan=(pt - WP, pt - WP + 0.64) net=n1
  l33 = rect li xspan=(x13 - 0.305, x13 + 0.03) yspan=(pt - WP + 0.41, pt - 0.02) net=n5
  l34 = rect li xspan=(x13 - 0.305, x18 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n5
  l35 = rect li xspan=(x15 + L + 0.055, x16 - 0.055) yspan=(pt - WP, pt - 0.02) net=n5
  l36 = rect li xspan=(x17 + L - 0.03, x18 + 0.03) yspan=(pt - 0.59, pt - 0.02) net=n5
  l37 = rect li xspan=(x16 + L - 0.03, x20 + L + 0.335) yspan=(pt - WP, pt - WP + 0.24) net=n4
  l38 = rect li xspan=(x16 + L - 0.03, x17 - 0.055) yspan=(pt - WP, pt - WP + 0.64) net=n4
  l39 = rect li xspan=(x18 + L + 0.055, x19 - 0.055) yspan=(pt - WP, pt - 0.36) net=n4
  l40 = rect li xspan=(x20 + L + 0.055, x20 + L + 0.335) yspan=(pt - WP, pt - 0.02) net=n4
  l41 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP, H + 0.085) net=VPWR
  l42 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l43 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l44 = rect li xspan=(x7 + L - 0.03, x9 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l45 = rect li xspan=(x12, x12 + L + 0.045) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l46 = rect li xspan=(x19 + L - 0.03, x20 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.31) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x9 + 0.045) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n3
  c3 = array licon in=nd3 cx=(x15 + 0.04) span=(-0.085, nb + 0.27) margin=0.04 net=VGND
  c4 = array licon in=nd3 cx=(x16 - 0.145) span=(-0.085, nb + 0.27) margin=0.04 net=VGND
  c5 = array licon in=nd3 cx=(x17 + L + 0.14) span=(-0.085, nb + 0.27) margin=0.04 net=VGND
  c6 = array licon in=nd3 cx=(x19 + L + 0.14) span=(-0.085, nb + 0.27) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN) net=VGND
  c8 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c9 = array licon in=nd2 cx=(x5 + 0.045) span=(nb + 0.02, nb + 0.27) net=n3
  c10 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.02, nb + 0.27) net=n3
  c11 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=X
  c13 = array licon in=nd3 cx=(x13 + 0.035) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n2
  c14 = array licon in=nd3 cx=(x16 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n2
  c15 = array licon in=nd3 cx=(x18 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n2
  c16 = array licon in=nd3 cx=(x20 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n2
  c17 = array licon in=nd2 cx=(x7 + 0.045) span=(nb + WN - 0.21, nb + WN) margin=0.04 net=n1
  c18 = array licon in=nd2 cx=(x11 + 0.045) span=(nb + WN - 0.21, nb + WN) margin=0.04 net=n2
  c19 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP, H + 0.085) net=VPWR
  c20 = array licon in=pd2 cx=(x15 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n5
  c21 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c22 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c23 = array licon in=pd1 cx=(x6 + L - 0.045) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c24 = array licon in=pd1 cx=(x10 + L - 0.045) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c25 = array licon in=pd2 cx=(x14 + L - 0.035) span=(pt - WP + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n1
  c26 = array licon in=pd3 cx=(x16 + L + 0.14) span=(pt - WP + 0.08, pt - WP + 0.64 - 0.08) net=n4
  c27 = array licon in=pd3 cx=(x18 + L + 0.14) span=(pt - WP + 0.08, pt - 0.36 - 0.08) margin=0.04 net=n4
  c28 = array licon in=pd3 cx=(x20 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n4
  c29 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c30 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c31 = array licon in=pd1 cx=(x5 - 0.14) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c32 = array licon in=pd1 cx=(x8 + L - 0.045) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c33 = array licon in=pd3 cx=(x17 + L + 0.14) span=(pt - 0.59, pt - 0.02) margin=0.04 net=n5
  c34 = array licon in=pd3 cx=(x19 + L + 0.14) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c35 = array licon in=pd1 cx=(x12 + L - 0.045) span=(pt - 0.59 + 0.08, H + 0.085 - 0.08) net=VPWR
  c36 = array licon in=pd2 cx=(x13 - 0.14) span=(pt - WP + 0.41, pt - 0.02) net=n5
  gc1 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.06) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x11 + 0.025) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x14 + 0.015) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x15 + L - 0.045) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x16 - 0.08) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x17 + L + 0.06) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x19 + L + 0.135) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x20 + L + 0.055) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x20 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.27) cy=0
  mc6 = contact mcon cx=(x5 + L - 0.035) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.01) cy=0
  mc8 = contact mcon cx=(x10 + 0.015) cy=0
  mc9 = contact mcon cx=(x12 + 0.055) cy=0
  mc10 = contact mcon cx=(x13 - 0.27) cy=0
  mc11 = contact mcon cx=(x14 + 0.025) cy=0
  mc12 = contact mcon cx=(x15 + L + 0.09) cy=0
  mc13 = contact mcon cx=(x16 + L + 0.03) cy=0
  mc14 = contact mcon cx=(x17 + L + 0.07) cy=0
  mc15 = contact mcon cx=(x18 + L + 0.11) cy=0
  mc16 = contact mcon cx=(x20 - 0.13) cy=0
  mc17 = contact mcon cx=(x20 + L + 0.19) cy=0
  mc18 = contact mcon cx=(x1 - 0.17) cy=H
  mc19 = contact mcon cx=(x2 - 0.13) cy=H
  mc20 = contact mcon cx=(x3 - 0.09) cy=H
  mc21 = contact mcon cx=(x4 - 0.05) cy=H
  mc22 = contact mcon cx=(x4 + L + 0.27) cy=H
  mc23 = contact mcon cx=(x5 + L - 0.035) cy=H
  mc24 = contact mcon cx=(x7 + L + 0.01) cy=H
  mc25 = contact mcon cx=(x10 + 0.015) cy=H
  mc26 = contact mcon cx=(x12 + 0.055) cy=H
  mc27 = contact mcon cx=(x13 - 0.27) cy=H
  mc28 = contact mcon cx=(x14 + 0.025) cy=H
  mc29 = contact mcon cx=(x15 + L + 0.09) cy=H
  mc30 = contact mcon cx=(x16 + L + 0.03) cy=H
  mc31 = contact mcon cx=(x17 + L + 0.07) cy=H
  mc32 = contact mcon cx=(x18 + L + 0.11) cy=H
  mc33 = contact mcon cx=(x20 - 0.13) cy=H
  mc34 = contact mcon cx=(x20 + L + 0.19) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l18
  port A2 in on=l17
  port A3 in on=l16
  port B1 in on=l15
  port C1 in on=l14
  port X out on=l19
end
