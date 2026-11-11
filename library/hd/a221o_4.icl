# a221o_4: lifted from sky130_fd_sc_hd__a221o_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a221o_4 width=21 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=C1 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n1 g=C1 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=B2 s=n3 b=VPB
  device M3 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M4 nmos w=WN l=L d=n1 g=B1 s=n5 b=VNB
  device M5 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n4 g=A1 s=n1 b=VNB
  device M7 pmos w=WP l=L d=n3 g=B2 s=n2 b=VPB
  device M8 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M9 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M11 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M12 nmos w=WN l=L d=VGND g=B2 s=n5 b=VNB
  device M13 nmos w=WN l=L d=n1 g=A1 s=n4 b=VNB
  device M14 pmos w=WP l=L d=n3 g=B1 s=n2 b=VPB
  device M15 nmos w=WN l=L d=n5 g=B2 s=VGND b=VNB
  device M16 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M17 pmos w=WP l=L d=n2 g=B1 s=n3 b=VPB
  device M18 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M19 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M20 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M21 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M22 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M23 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M24 nmos w=WN l=L d=VGND g=C1 s=n1 b=VNB
  device M25 pmos w=WP l=L d=n2 g=C1 s=n1 b=VPB
  device M26 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M27 nmos w=WN l=L d=n5 g=B1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.285
  x9 = x8 + 0.095
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + 0.01
  x13 = x12 + L + 0.27
  x14 = x13 + 0.01
  x15 = x14 + L + 0.27
  x16 = x15 + 0.01
  x17 = x16 + L + 0.27
  x18 = x17 + 0.01
  x19 = x18 + L + 0.7
  x20 = x19 + 0.09
  x21 = x20 + L + 0.19
  x22 = x21 + 0.09
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 - 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x7 + L + 0.115, x18 + L + 0.255) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x19 - 0.175, x22 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 - 0.11) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x10 + L + 0.02, x22 + L + 0.185) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7 - 0.065, x10 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.235)
  p15 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p16 = rect poly xspan=(x12, x13) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.16)
  p18 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.27, H - 0.105)
  p19 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.23)
  p20 = rect poly xspan=(x16, x18 + L + 0.345) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p21 = rect poly xspan=(x16, x16 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p22 = rect poly xspan=(x17, x17 + L) yspan=(0.105, pt - WP - 0.16)
  p23 = rect poly xspan=(x18, x18 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p24 = rect poly xspan=(x19 - 0.05, x22 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p25 = rect poly xspan=(x19, x19 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p26 = rect poly xspan=(x20, x20 + L) yspan=(0.105, pt - WP - 0.16)
  p27 = rect poly xspan=(x21, x21 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p28 = rect poly xspan=(x22, x22 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l5 = rect li xspan=(x12 + L + 0.045, x13 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x20 + L + 0.055, x21 + 0.04) yspan=(-0.085, nb + 0.32) net=VGND
  l7 = rect li xspan=(x15 + L - 0.03, x19 + L/2 + 0.045) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n5
  l8 = rect li xspan=(x15 + L - 0.03, x22 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n5
  l9 = rect li xspan=(x22 + L - 0.03, x22 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n5
  l10 = rect li xspan=(x4 + L + 0.055, x6 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n4
  l11 = rect li xspan=(x5 - 0.135, x5 + L - 0.06) yspan=(nb + WN - 0.15, nb + WN + 0.05) net=n4
  l12 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l13 = rect li xspan=(x7 + L + 0.13, x10 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n4
  l14 = rect li xspan=(x8 - 0.03, x9 + L + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.05) net=n4
  l15 = rect li xspan=(x9 + L - 0.035, x10 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n4
  l16 = rect li xspan=(x5 + L + 0.045, x6 + L + 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l17 = rect li xspan=(x7 - 0.065, x7 + L + 0.13) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l18 = rect li xspan=(x7 - 0.065, x10 + L + 0.06) yspan=(nb + WN + 0.22, pt - WP - 0.2) net=A1
  l19 = rect li xspan=(x9 + L + 0.13, x10 + L + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l20 = rect li xspan=(x11 - 0.05, x14 + 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=C1
  l21 = rect li xspan=(x15 + L - 0.03, x18 + L + 0.345) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l22 = rect li xspan=(x19 - 0.12, x22 + L + 0.24) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B2
  l23 = rect li xspan=(x1 + L - 0.05, x4 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=n1
  l24 = rect li xspan=(x4 + L + 0.015, x5 - 0.095) yspan=(nb + WN + 0.23, pt - WP + 0.14) net=n1
  l25 = rect li xspan=(x4 + L + 0.015, x15 - 0.055) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l26 = rect li xspan=(x7 + L + 0.02, x12 + 0.02) yspan=(nb + 0.07, nb + 0.24) net=n1
  l27 = rect li xspan=(x10 + L + 0.055, x12 + 0.02) yspan=(nb + 0.07, nb + WN + 0.02) net=n1
  l28 = rect li xspan=(x10 + L + 0.055, x15 - 0.055) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n1
  l29 = rect li xspan=(x11 + L - 0.02, x14 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.22) net=n1
  l30 = rect li xspan=(x13 + L - 0.03, x18 + L + 0.295) yspan=(nb + 0.02, nb + 0.24) net=n1
  l31 = rect li xspan=(x13 + L - 0.03, x15 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l32 = rect li xspan=(x14 + L + 0.045, x15 - 0.055) yspan=(nb + 0.02, pt - WP + 0.14) net=n1
  l33 = rect li xspan=(x1 - 0.305, x4 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=X
  l34 = rect li xspan=(x1 - 0.305, x1 - 0.075) yspan=(nb + WN - 0.15, pt - WP + 0.14) net=X
  l35 = rect li xspan=(x1 - 0.305, x4 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=X
  l36 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l37 = rect li xspan=(x1 + L - 0.03, x4 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l38 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l39 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l40 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l41 = rect li xspan=(x5 + L + 0.015, x11 - 0.05) yspan=(pt - WP + 0.31, pt - WP + 0.48) net=n3
  l42 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l43 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l44 = rect li xspan=(x10 + L + 0.06, x18 + 0.03) yspan=(pt - WP + 0.39, pt - WP + 0.56) net=n3
  l45 = rect li xspan=(x15 + L - 0.02, x21) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n3
  l46 = rect li xspan=(x15 + L - 0.02, x18 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.56) net=n3
  l47 = rect li xspan=(x19 + L + 0.02, x21) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=n3
  l48 = rect li xspan=(x10 + L - 0.065, x19) yspan=(pt - 0.27, pt - 0.02) net=n2
  l49 = rect li xspan=(x10 + L - 0.065, x22 + L + 0.185) yspan=(pt - 0.19, pt - 0.02) net=n2
  l50 = rect li xspan=(x18 + L + 0.055, x19) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l51 = rect li xspan=(x21 + L + 0.02, x22 + L + 0.185) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l52 = rect li xspan=(x1 - 0.245, x1 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l53 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l54 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l55 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l56 = rect li xspan=(x8 + L + 0.01, x10 - 0.11) yspan=(pt - 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x18 + L + 0.13) span=(nb + 0.02, nb + 0.24) net=n1
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n4
  c8 = array licon in=nd2 cx=(x8 - 0.045) span=(nb + 0.07, nb + 0.24) net=n1
  c9 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.07 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x12 + L + 0.13) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c11 = array licon in=nd2 cx=(x14 + L + 0.13) span=(nb + 0.02 + 0.08, pt - WP + 0.14 - 0.08) margin=0.04 net=n1
  c12 = array licon in=nd3 cx=(x21 - 0.05) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c13 = array licon in=nd3 cx=(x22 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n5
  c14 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) net=VGND
  c15 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n4
  c16 = array licon in=nd2 cx=(x16 + L + 0.13) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n5
  c17 = array licon in=nd3 cx=(x19 - 0.05) span=(nb + WN - 0.24, nb + WN + 0.02) net=n5
  c18 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c19 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c20 = array licon in=pd2 cx=(x13 - 0.13) span=(pt - WP - 0.03, pt - WP + 0.22) margin=0.04 net=n1
  c21 = array licon in=pd2 cx=(x17 - 0.13) span=(pt - WP - 0.03, pt - WP + 0.56) margin=0.04 net=n3
  c22 = array licon in=pd2 cx=(x20 + L + 0.05) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n3
  c23 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) net=VPWR
  c24 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c27 = array licon in=pd1 cx=(x8 - 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c28 = array licon in=pd2 cx=(x18 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c29 = array licon in=pd2 cx=(x19 - 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c30 = array licon in=pd2 cx=(x22 + L + 0.05) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n2
  c31 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c32 = array licon in=pd1 cx=(x9 + L + 0.045) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) net=VPWR
  c33 = array licon in=pd2 cx=(x11 - 0.135) span=(pt - 0.27, pt - 0.02) net=n2
  c34 = array licon in=pd2 cx=(x15 - 0.13) span=(pt - 0.27, pt - 0.02) margin=0.04 net=n2
  gc1 = contact licon cx=(x1 + L + 0.12) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.04) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.045) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + 0.025) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 - 0.07) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L - 0.045) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + 0.02) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x12 + L + 0.1) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x17 - 0.01) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x18 + L + 0.18) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x19 + L/2 + 0.045) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x21 + 0.04) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x22 + L + 0.78) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 + 0.035) cy=0
  mc7 = contact mcon cx=(x7 + L/2) cy=0
  mc8 = contact mcon cx=(x9 + 0.015) cy=0
  mc9 = contact mcon cx=(x10 + 0.055) cy=0
  mc10 = contact mcon cx=(x11 + L - 0.055) cy=0
  mc11 = contact mcon cx=(x13 + L - 0.015) cy=0
  mc12 = contact mcon cx=(x16 + L + 0.02) cy=0
  mc13 = contact mcon cx=(x18 + L + 0.06) cy=0
  mc14 = contact mcon cx=(x19 - 0.18) cy=0
  mc15 = contact mcon cx=(x20 + L + 0.05) cy=0
  mc16 = contact mcon cx=(x22 + L + 0.09) cy=0
  mc17 = contact mcon cx=(x22 + L + 0.55) cy=0
  mc18 = contact mcon cx=(x5 + 0.005) cy=(nb + WN - 0.035)
  mc19 = contact mcon cx=(x8 + L - 0.005) cy=(nb + WN - 0.035)
  mc20 = contact mcon cx=(x1 - 0.17) cy=H
  mc21 = contact mcon cx=(x2 - 0.13) cy=H
  mc22 = contact mcon cx=(x3 - 0.09) cy=H
  mc23 = contact mcon cx=(x4 - 0.05) cy=H
  mc24 = contact mcon cx=(x5 - 0.01) cy=H
  mc25 = contact mcon cx=(x6 + 0.035) cy=H
  mc26 = contact mcon cx=(x7 + L/2) cy=H
  mc27 = contact mcon cx=(x9 + 0.015) cy=H
  mc28 = contact mcon cx=(x10 + 0.055) cy=H
  mc29 = contact mcon cx=(x11 + L - 0.055) cy=H
  mc30 = contact mcon cx=(x13 + L - 0.015) cy=H
  mc31 = contact mcon cx=(x16 + L + 0.02) cy=H
  mc32 = contact mcon cx=(x18 + L + 0.06) cy=H
  mc33 = contact mcon cx=(x19 - 0.18) cy=H
  mc34 = contact mcon cx=(x20 + L + 0.05) cy=H
  mc35 = contact mcon cx=(x22 + L + 0.09) cy=H
  mc36 = contact mcon cx=(x22 + L + 0.55) cy=H
  w1 = rect m1 xspan=(x4 + L + 0.135, x5 + L) yspan=(nb + 0.5, nb + WN + 0.08) net=n4
  w2 = rect m1 xspan=(x4 + L + 0.135, x9 + L + 0.05) yspan=(nb + WN - 0.105, nb + WN + 0.035) net=n4
  w3 = rect m1 xspan=(x8, x9 + L + 0.05) yspan=(nb + 0.5, nb + WN + 0.08) net=n4
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l17
  port A2 in on=l16
  port B1 in on=l21
  port B2 in on=l22
  port C1 in on=l20
  port X out on=l34
end
