# a2111o_4: lifted from sky130_fd_sc_hd__a2111o_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2111o_4 width=21 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M1 nmos w=WN l=L d=n3 g=A1 s=n4 b=VNB
  device M2 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 pmos w=WP l=L d=n3 g=D1 s=n5 b=VPB
  device M5 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M7 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M8 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M9 nmos w=WN l=L d=VGND g=B1 s=n3 b=VNB
  device M10 nmos w=WN l=L d=n4 g=A1 s=n3 b=VNB
  device M11 pmos w=WP l=L d=n5 g=D1 s=n3 b=VPB
  device M12 nmos w=WN l=L d=VGND g=D1 s=n3 b=VNB
  device M13 nmos w=WN l=L d=VGND g=C1 s=n3 b=VNB
  device M14 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M15 pmos w=WP l=L d=n5 g=C1 s=n2 b=VPB
  device M16 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M17 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M18 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M19 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M20 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M21 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M22 nmos w=WN l=L d=n3 g=C1 s=VGND b=VNB
  device M23 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M24 pmos w=WP l=L d=n2 g=C1 s=n5 b=VPB
  device M25 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M26 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M27 nmos w=WN l=L d=n3 g=D1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + 0.07
  x3 = x2 + L + 0.22
  x4 = x3 + 0.07
  x5 = x4 + L + 0.22
  x6 = x5 + 0.07
  x7 = x6 + L + 0.22
  x8 = x7 + 0.105
  x9 = x8 + L + 0.345
  x10 = x9 + L + 0.21
  x11 = x10 + L + 0.29
  x12 = x11 + L + 0.05
  x13 = x12 + L + 0.295
  x14 = x13 + 0.04
  x15 = x14 + L + 0.25
  x16 = x15 + 0.04
  x17 = x16 + L + 0.8
  x18 = x17 + L + 0.29
  x19 = x18 + L + 0.29
  x20 = x19 + L + 0.29
  x21 = x20 + L + 0.29
  x22 = x21 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.2, x16 + L + 0.245) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x17 - 0.285, x22 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x8 + L + 0.16) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 + L - 0.06, x16 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x17 - 0.265, x22 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.315, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.34)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x5, x8 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.165)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.165)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.165)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.165)
  p12 = rect poly xspan=(x9, x12 + L) yspan=(nb + WN + 0.11, pt - WP - 0.165)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p15 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.165)
  p16 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.15)
  p17 = rect poly xspan=(x13, x16 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.15)
  p18 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p19 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.15)
  p20 = rect poly xspan=(x16, x16 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p21 = rect poly xspan=(x17 - 0.16, x18 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p22 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  p23 = rect poly xspan=(x17, x18 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p24 = rect poly xspan=(x18, x18 + L) yspan=(0.105, H - 0.105)
  p25 = rect poly xspan=(x19, x19 + L) yspan=(0.105, H - 0.105)
  p26 = rect poly xspan=(x19, x22 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p27 = rect poly xspan=(x20, x20 + L) yspan=(0.105, H - 0.105)
  p28 = rect poly xspan=(x21, x21 + L) yspan=(0.105, H - 0.105)
  p29 = rect poly xspan=(x22, x22 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.025, x4 + 0.025) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x6 + L + 0.02, x7 + L - 0.015) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x9 + L - 0.025, x12 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x17 - 0.31, x17 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(-0.085, nb + 0.28) net=VGND
  l6 = rect li xspan=(x20 + L - 0.025, x21 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l7 = rect li xspan=(x22 + L - 0.025, x22 + L + 0.31) yspan=(-0.085, nb + 0.23) net=VGND
  l8 = rect li xspan=(x13 + L - 0.025, x18 - 0.05) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=n4
  l9 = rect li xspan=(x17 + L + 0.055, x18 - 0.05) yspan=(nb + 0.02, nb + WN - 0.1) net=n4
  l10 = rect li xspan=(x13 + L - 0.025, x16 + L + 0.18) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l11 = rect li xspan=(x16 + L + 0.36, x18 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l12 = rect li xspan=(x4 + L - 0.025, x9 - 0.02) yspan=(nb + WN + 0.09, pt - WP - 0.2) net=C1
  l13 = rect li xspan=(x9 + L + 0.01, x12 - 0.015) yspan=(nb + WN + 0.09, pt - WP - 0.2) net=B1
  l14 = rect li xspan=(x1 - 0.335, x1 - 0.05) yspan=(nb + WN + 0.09, pt - WP + 0.14) net=D1
  l15 = rect li xspan=(x1 - 0.24, x1 + 0.025) yspan=(nb + 0.02, nb + WN - 0.08) net=n3
  l16 = rect li xspan=(x1 - 0.24, x13 - 0.05) yspan=(nb + WN - 0.25, nb + WN - 0.08) net=n3
  l17 = rect li xspan=(x1 + L - 0.025, x3 + 0.025) yspan=(nb + WN - 0.25, pt - WP + 0.64) net=n3
  l18 = rect li xspan=(x4 + L + 0.05, x6 - 0.005) yspan=(nb + 0.02, nb + WN - 0.08) net=n3
  l19 = rect li xspan=(x4 + L + 0.05, x13 - 0.05) yspan=(nb + WN - 0.27, nb + WN - 0.08) net=n3
  l20 = rect li xspan=(x8 + L + 0.06, x9 - 0.06) yspan=(nb + 0.02, nb + WN - 0.08) net=n3
  l21 = rect li xspan=(x12 + L + 0.055, x16 + L + 0.27) yspan=(nb + 0.02, nb + 0.21) net=n3
  l22 = rect li xspan=(x12 + L + 0.055, x13 - 0.05) yspan=(nb + 0.02, pt - WP + 0.14) net=n3
  l23 = rect li xspan=(x12 + L + 0.055, x19 + 0.005) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=n3
  l24 = rect li xspan=(x18 + L + 0.11, x22 + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l25 = rect li xspan=(x18 + L + 0.11, x19 + 0.005) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=n3
  l26 = rect li xspan=(x5 + L - 0.025, x11 + 0.025) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n2
  l27 = rect li xspan=(x5 + L - 0.025, x7 + 0.025) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=n2
  l28 = rect li xspan=(x10 + L + 0.055, x11 + 0.025) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=n2
  l29 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(pt - WP + 0.31, pt - 0.02) net=n5
  l30 = rect li xspan=(x1 - 0.31, x9 - 0.14) yspan=(pt - 0.19, pt - 0.02) net=n5
  l31 = rect li xspan=(x4 + L - 0.025, x5 - 0.05) yspan=(pt - WP - 0.03, pt - 0.02) net=n5
  l32 = rect li xspan=(x7 + L + 0.045, x9 - 0.14) yspan=(pt - WP + 0.31, pt - 0.02) net=n5
  l33 = rect li xspan=(x9 + 0.045, x10 + 0.03) yspan=(pt - 0.69, pt - 0.02) net=n1
  l34 = rect li xspan=(x9 + 0.045, x13 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n1
  l35 = rect li xspan=(x12 + 0.055, x18 - 0.05) yspan=(pt - WP + 0.31, pt - WP + 0.51) net=n1
  l36 = rect li xspan=(x12 + 0.055, x13 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l37 = rect li xspan=(x16 + L + 0.05, x16 + L + 0.31) yspan=(pt - WP + 0.31, pt - 0.07) net=n1
  l38 = rect li xspan=(x17 + L + 0.055, x18 - 0.05) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l39 = rect li xspan=(x19 + L + 0.05, x20 - 0.05) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l40 = rect li xspan=(x19 + L + 0.05, x22 + L + 0.33) yspan=(nb + WN - 0.25, nb + WN - 0.08) net=X
  l41 = rect li xspan=(x19 + L + 0.05, x22 + L + 0.33) yspan=(pt - WP - 0.02, pt - WP + 0.15) net=X
  l42 = rect li xspan=(x19 + L + 0.05, x20 - 0.05) yspan=(pt - WP - 0.02, pt - 0.02) net=X
  l43 = rect li xspan=(x19 + L + 0.05, x22 - 0.05) yspan=(pt - WP - 0.02, pt - WP + 0.23) net=X
  l44 = rect li xspan=(x21 + L + 0.05, x22 - 0.05) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l45 = rect li xspan=(x21 + L + 0.05, x22 - 0.05) yspan=(pt - WP - 0.02, pt - 0.02) net=X
  l46 = rect li xspan=(x22 + L + 0.085, x22 + L + 0.33) yspan=(nb + WN - 0.25, pt - WP + 0.15) net=X
  l47 = rect li xspan=(x13 + L + 0.015, x16 + 0.025) yspan=(pt - 0.32, H + 0.085) net=VPWR
  l48 = rect li xspan=(x17 - 0.31, x17 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l49 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l50 = rect li xspan=(x20 + L - 0.025, x21 + 0.025) yspan=(pt - 0.6, H + 0.085) net=VPWR
  l51 = rect li xspan=(x22 + L - 0.025, x22 + L + 0.31) yspan=(pt - 0.68, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x7 - 0.035) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x10 - 0.065) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x11 + 0.03) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x16 + L + 0.1) span=(nb + 0.02, nb + 0.21) margin=0.04 net=n3
  c5 = array licon in=nd2 cx=(x17 - 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x18 + L + 0.145) span=(-0.085, nb + 0.28) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x20 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x3 - 0.075) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c9 = array licon in=nd2 cx=(x22 + L + 0.145) span=(-0.085, nb + 0.23) net=VGND
  c10 = array licon in=nd1 cx=(x1 - 0.075) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n3
  c11 = array licon in=nd1 cx=(x5 - 0.075) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=n3
  c12 = array licon in=nd1 cx=(x8 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=n3
  c13 = array licon in=nd1 cx=(x13 - 0.145) span=(nb + 0.02 + 0.08, pt - WP + 0.14 - 0.08) margin=0.04 net=n3
  c14 = array licon in=nd2 cx=(x17 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n4
  c15 = array licon in=nd2 cx=(x19 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c16 = array licon in=nd2 cx=(x21 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c17 = array licon in=nd1 cx=(x14 + L + 0.105) span=(nb + WN - 0.27, nb + WN - 0.1) margin=0.04 net=n4
  c18 = array licon in=pd1 cx=(x4 + L + 0.075) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n5
  c19 = array licon in=pd2 cx=(x10 + L + 0.145) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c20 = array licon in=pd1 cx=(x2 + L + 0.075) span=(nb + WN - 0.25, pt - WP + 0.64) margin=0.04 net=n3
  c21 = array licon in=pd1 cx=(x6 + L + 0.075) span=(pt - WP - 0.03, pt - WP + 0.64) margin=0.04 net=n2
  c22 = array licon in=pd3 cx=(x19 + L + 0.145) span=(pt - WP - 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c23 = array licon in=pd3 cx=(x21 + L + 0.145) span=(pt - WP - 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c24 = array licon in=pd2 cx=(x9 + L + 0.07) span=(pt - 0.69, pt - 0.02) net=n1
  c25 = array licon in=pd3 cx=(x18 + L + 0.145) span=(pt - 0.685, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd2 cx=(x12 + L + 0.075) span=(pt - WP + 0.31, pt - 0.02) margin=0.04 net=n1
  c27 = array licon in=pd2 cx=(x16 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.07 - 0.08) net=n1
  c28 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n5
  c29 = array licon in=pd1 cx=(x8 + L + 0.035) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n5
  c30 = array licon in=pd3 cx=(x17 + L + 0.145) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c31 = array licon in=pd3 cx=(x20 + L + 0.145) span=(pt - 0.6, H + 0.085) margin=0.04 net=VPWR
  c32 = array licon in=pd3 cx=(x22 + L + 0.145) span=(pt - 0.68, H + 0.085) net=VPWR
  c33 = array licon in=pd2 cx=(x15 - 0.105) span=(pt - 0.32, H + 0.085) margin=0.04 net=VPWR
  c34 = array licon in=pd3 cx=(x17 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.15) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x6 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 + L - 0.005) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x10 - 0.035) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x11 + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x14 + L + 0.105) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x16 + L + 0.015) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x17 + 0.01) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x18 - 0.085) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x19 + L + 0.02) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x20 + L/2) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x21 - 0.02) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x22 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x22 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.06) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.09) cy=0
  mc4 = contact mcon cx=(x7 - 0.1) cy=0
  mc5 = contact mcon cx=(x8 + L + 0.115) cy=0
  mc6 = contact mcon cx=(x9 + L + 0.09) cy=0
  mc7 = contact mcon cx=(x11 - 0.09) cy=0
  mc8 = contact mcon cx=(x12 + L + 0.04) cy=0
  mc9 = contact mcon cx=(x14 + L + 0.025) cy=0
  mc10 = contact mcon cx=(x16 + L + 0.055) cy=0
  mc11 = contact mcon cx=(x17 - 0.285) cy=0
  mc12 = contact mcon cx=(x17 + L + 0.035) cy=0
  mc13 = contact mcon cx=(x18 + L + 0.065) cy=0
  mc14 = contact mcon cx=(x19 + L + 0.095) cy=0
  mc15 = contact mcon cx=(x20 + L + 0.125) cy=0
  mc16 = contact mcon cx=(x22 - 0.135) cy=0
  mc17 = contact mcon cx=(x22 + L + 0.185) cy=0
  mc18 = contact mcon cx=(x1 - 0.19) cy=H
  mc19 = contact mcon cx=(x2 + L + 0.06) cy=H
  mc20 = contact mcon cx=(x4 + L + 0.09) cy=H
  mc21 = contact mcon cx=(x7 - 0.1) cy=H
  mc22 = contact mcon cx=(x8 + L + 0.115) cy=H
  mc23 = contact mcon cx=(x9 + L + 0.09) cy=H
  mc24 = contact mcon cx=(x11 - 0.09) cy=H
  mc25 = contact mcon cx=(x12 + L + 0.04) cy=H
  mc26 = contact mcon cx=(x14 + L + 0.025) cy=H
  mc27 = contact mcon cx=(x16 + L + 0.055) cy=H
  mc28 = contact mcon cx=(x17 - 0.285) cy=H
  mc29 = contact mcon cx=(x17 + L + 0.035) cy=H
  mc30 = contact mcon cx=(x18 + L + 0.065) cy=H
  mc31 = contact mcon cx=(x19 + L + 0.095) cy=H
  mc32 = contact mcon cx=(x20 + L + 0.125) cy=H
  mc33 = contact mcon cx=(x22 - 0.135) cy=H
  mc34 = contact mcon cx=(x22 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l11
  port B1 in on=l13
  port C1 in on=l12
  port D1 in on=l14
  port X out on=l46
end
