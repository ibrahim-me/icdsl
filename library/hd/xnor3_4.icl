# xnor3_4: lifted from sky130_fd_sc_hd__xnor3_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.64 WN3=0.6 WN4=0.42 WP=1 WP2=0.84 WP3=0.64 L=0.15 H=2.72

stdcell xnor3_4 width=25 height=H taps=no
  device M0 pmos w=WP3 l=L d=n1 g=B s=n2 b=VPB
  device M1 nmos w=WN2 l=L d=n3 g=C s=n4 b=VNB
  device M2 nmos w=WN2 l=L d=VGND g=n5 s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M4 pmos w=WP l=L d=VPWR g=B s=n6 b=VPB
  device M5 nmos w=WN2 l=L d=n1 g=B s=n3 b=VNB
  device M6 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M7 pmos w=WP2 l=L d=n5 g=B s=n3 b=VPB
  device M8 nmos w=WN2 l=L d=n5 g=B s=n2 b=VNB
  device M9 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M10 pmos w=WP3 l=L d=n3 g=n6 s=n1 b=VPB
  device M11 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB
  device M12 pmos w=WP3 l=L d=VPWR g=C s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n4 g=n7 s=n3 b=VPB
  device M14 nmos w=WN2 l=L d=n4 g=n7 s=n2 b=VNB
  device M15 nmos w=WN3 l=L d=n3 g=n6 s=n5 b=VNB
  device M16 pmos w=WP2 l=L d=n2 g=C s=n4 b=VPB
  device M17 pmos w=WP2 l=L d=n2 g=n6 s=n5 b=VPB
  device M18 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M19 nmos w=WN l=L d=VGND g=B s=n6 b=VNB
  device M20 pmos w=WP l=L d=VPWR g=n5 s=n1 b=VPB
  device M21 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M22 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M23 nmos w=WN4 l=L d=VGND g=C s=n7 b=VNB
  device M24 pmos w=WP l=L d=n5 g=A s=VPWR b=VPB
  device M25 nmos w=WN4 l=L d=n2 g=n6 s=n1 b=VNB
  device M26 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB
  device M27 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.51
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.29
  x4 = x3 + 0.02
  x5 = x4 + L + 0.26
  x6 = x5 + 0.02
  x7 = x6 + L + 0.375
  x8 = x7 + L + 0.91
  x9 = x8 + 0.065
  x10 = x9 + L + 0.28
  x11 = x10 + 0.02
  x12 = x11 + L + 0.9
  x13 = x12 + L + 0.03
  x14 = x13 + L + 0.79
  x15 = x14 + L + 0.615
  x16 = x15 + L + 0.655
  x17 = x16 + 0.08
  x18 = x17 + L + 0.375
  x19 = x18 + 0.005
  x20 = x19 + L + 0.36
  x21 = x20 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x7 + L + 0.43) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x8 - 0.21, x11 + L + 0.355) yspan=(nb + 0.01, nb + WN)
  nd4 = rect diff xspan=(x12 - 0.125, x13 + L + 0.255) yspan=(nb, nb + WN)
  nd5 = rect diff xspan=(x12 - 0.125, x13 + L + 0.265) yspan=(nb + 0.01 + WN4 - 0.045, nb + WN)
  nd6 = rect diff xspan=(x14 - 0.265, x21 + L + 0.29) yspan=(nb + 0.01, nb + 0.23 + 0.055)
  nd7 = rect diff xspan=(x14 - 0.255, x21 + L + 0.29) yspan=(nb + 0.01, nb + 0.01 + WN4)
  nd8 = rect diff xspan=(x14 - 0.255, x15 - 0.11) yspan=(nb + 0.01, nb + WN)
  nd9 = rect diff xspan=(x15 + L + 0.13, x17 + L + 0.175) yspan=(nb + 0.01, nb + WN)
  nd10 = rect diff xspan=(x15 + L + 0.13, x21 + L + 0.29) yspan=(nb + 0.01 + WN4, nb + WN3)
  nd11 = rect diff xspan=(x17 + L + 0.01, x21 + L + 0.29) yspan=(nb, nb + WN3)
  nd12 = rect diff xspan=(x19 + L + 0.105, x21 + L + 0.29) yspan=(nb, nb + WN2)
  pd1 = rect diff xspan=(x8 - 0.33, x10 - 0.08) yspan=(pt - 0.02 - WP2, pt - 0.02)
  pd2 = rect diff xspan=(x9 + L + 0.025, x11 + L + 0.37) yspan=(pt - WP, pt - 0.36 - 0.01)
  pd3 = rect diff xspan=(x10 - 0.08, x11 + L + 0.365) yspan=(pt - WP, pt - 0.16)
  pd4 = rect diff xspan=(x1 - 0.265, x7 - 0.08) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x1 - 0.265, x7 + L + 0.285) yspan=(pt - WP, pt - 0.36)
  pd6 = rect diff xspan=(x12 - 0.265, x13 + L + 0.095) yspan=(pt - 0.36 + 0.05, pt)
  pd7 = rect diff xspan=(x12 - 0.26, x13 + L + 0.095) yspan=(pt - WP, pt)
  pd8 = rect diff xspan=(x13 + L + 0.365, x15 - 0.115) yspan=(pt - WP, pt - 0.16)
  pd9 = rect diff xspan=(x13 + L + 0.365, x16 - 0.175) yspan=(pt - WP, pt - 0.36)
  pd10 = rect diff xspan=(x13 + L + 0.365, x21 + L + 0.29) yspan=(pt - WP2, pt - 0.36)
  pd11 = rect diff xspan=(x15 + L + 0.305, x21 + L + 0.29) yspan=(pt - 0.36, pt - 0.2)
  pd12 = rect diff xspan=(x17 + L + 0.08, x19 + L + 0.075) yspan=(pt - WP2, pt)
  pd13 = rect diff xspan=(x19 + L + 0.075, x21 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7, nd8, nd9, nd10, nd11, nd12] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7, pd8, pd9, pd10, pd11, pd12, pd13] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x14 + L + 0.215, x15 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x15, x15 + L) yspan=(0.115, pt - 0.2 - 0.03)
  p3 = rect poly xspan=(x10 - 0.065, x11 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, pt + 0.035)
  p5 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x7, x7 + L) yspan=(nb + 0.01 + 0.09, pt - 0.02 - 0.05)
  p7 = rect poly xspan=(x7, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, pt + 0.11)
  p9 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.13)
  p10 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x1, x6 + L + 0.16) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p15 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p16 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.2, H - 0.105)
  p18 = rect poly xspan=(x12, x14 + L) yspan=(nb + WN + 0.2, pt - WP - 0.25)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.25)
  p20 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x14, x17 + L) yspan=(pt - 0.02, H - 0.105)
  p22 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.16)
  p23 = rect poly xspan=(x16, x17 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p24 = rect poly xspan=(x17, x17 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p25 = rect poly xspan=(x18 - 0.12, x19 + L) yspan=(nb + WN + 0.06, pt - WP - 0.21)
  p26 = rect poly xspan=(x18, x18 + L) yspan=(nb + WN + 0.06, H - 0.105)
  p27 = rect poly xspan=(x19, x19 + L) yspan=(0.105, pt - WP - 0.205)
  p28 = rect poly xspan=(x20 - 0.145, x20 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p29 = rect poly xspan=(x20, x20 + L) yspan=(0.105, H - 0.105)
  p30 = rect poly xspan=(x21 - 0.065, x21 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p31 = rect poly xspan=(x21, x21 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + 0.01 + WN4 + 0.07) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.065) yspan=(-0.085, nb + 0.01 + WN4 + 0.07) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x7 - 0.17) yspan=(-0.085, nb + 0.23 + 0.06) net=VGND
  l4 = rect li xspan=(x12 - 0.055, x12 + L - 0.03) yspan=(-0.085, nb + WN2 - 0.01) net=VGND
  l5 = rect li xspan=(x20 + L + 0.055, x21 - 0.055) yspan=(-0.085, nb + 0.23 + 0.1) net=VGND
  l6 = rect li xspan=(x14 + L + 0.18, x15 - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.215) net=n6
  l7 = rect li xspan=(x15 - 0.22, x15 - 0.01) yspan=(nb + 0.01 + WN4 - 0.035, pt - WP - 0.215) net=n6
  l8 = rect li xspan=(x17 + L + 0.165, x18) yspan=(nb + 0.01 + WN4 + 0.065, pt - WP - 0.21) net=n6
  l9 = rect li xspan=(x17 + L + 0.165, x18 + L - 0.045) yspan=(nb + WN + 0.06, pt - WP - 0.21) net=n6
  l10 = rect li xspan=(x8 - 0.37, x9 + L - 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=C
  l11 = rect li xspan=(x19 + L + 0.125, x20 + L + 0.035) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A
  l12 = rect li xspan=(x17 - 0.03, x17 + L - 0.01) yspan=(nb + WN + 0.11, pt - 0.02 - WP2 - 0.01) net=B
  l13 = rect li xspan=(x17 - 0.03, x19 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=B
  l14 = rect li xspan=(x8 - 0.24, x11 + L + 0.335) yspan=(nb + 0.01 + WN4 - 0.04, nb + WN3 - 0.04) net=n3
  l15 = rect li xspan=(x8 - 0.24, x8 + L - 0.005) yspan=(nb + 0.01 + WN4 - 0.04, nb + WN + 0.02) net=n3
  l16 = rect li xspan=(x11 + L + 0.06, x11 + L + 0.445) yspan=(pt - WP + 0.04, pt - WP2 + 0.05) net=n3
  l17 = rect li xspan=(x11 + L + 0.165, x11 + L + 0.335) yspan=(nb + 0.01 + WN4 - 0.04, pt - WP2 + 0.05) net=n3
  l18 = rect li xspan=(x11 + L + 0.165, x11 + L + 0.445) yspan=(pt - WP - 0.11, pt - WP2 + 0.05) net=n3
  l19 = rect li xspan=(x7 + 0.005, x11 + 0.035) yspan=(pt - WP + 0.05, pt - WP2 + 0.06) net=n7
  l20 = rect li xspan=(x7 + L + 0.2, x7 + L + 0.37) yspan=(nb + 0.01 + WN4 - 0.07, pt - WP2 + 0.06) net=n7
  l21 = rect li xspan=(x10 - 0.12, x11 + 0.035) yspan=(nb + WN + 0.11, pt - WP2 + 0.06) net=n7
  l22 = rect li xspan=(x10 - 0.12, x10 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n7
  l23 = rect li xspan=(x19 + L + 0.055, x21 + L - 0.05) yspan=(pt - WP + 0.01, pt - WP2 + 0.06) net=n5
  l24 = rect li xspan=(x19 + L + 0.095, x20 + 0.03) yspan=(nb + 0.01 + 0.05, nb + WN3 - 0.085) net=n5
  l25 = rect li xspan=(x19 + L + 0.135, x20 + 0.03) yspan=(nb + 0.01 + 0.05, nb + WN + 0.02) net=n5
  l26 = rect li xspan=(x19 + L + 0.135, x21 + L - 0.05) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.02) net=n5
  l27 = rect li xspan=(x21 - 0.075, x21 + L - 0.05) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP2 + 0.06) net=n5
  l28 = rect li xspan=(x21 - 0.075, x21 + L + 0.015) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n5
  l29 = rect li xspan=(x12 + L - 0.03, x13 + L + 0.225) yspan=(pt - WP - 0.04, pt - WP2 + 0.07) net=n6
  l30 = rect li xspan=(x13 + L - 0.02, x13 + L + 0.225) yspan=(nb + 0.23 - 0.05, pt - WP2 + 0.07) net=n6
  l31 = rect li xspan=(x14 + L + 0.165, x15 - 0.035) yspan=(pt - WP - 0.04, pt - 0.36 - 0.08) net=n3
  l32 = rect li xspan=(x14 + L + 0.165, x15 + L + 0.19) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=n3
  l33 = rect li xspan=(x15 + L + 0.02, x15 + L + 0.19) yspan=(nb + 0.01 + 0.01, pt - 0.02 - WP2 - 0.01) net=n3
  l34 = rect li xspan=(x15 + L + 0.02, x18 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n3
  l35 = rect li xspan=(x17 - 0.03, x18 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23) net=n3
  l36 = rect li xspan=(x14 - 0.385, x14 - 0.215) yspan=(nb + 0.01 + 0.02, pt - 0.36 - 0.02) net=n5
  l37 = rect li xspan=(x14 - 0.385, x14 + 0.03) yspan=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n5
  l38 = rect li xspan=(x14 - 0.385, x14 - 0.175) yspan=(nb + 0.01 + 0.02, nb + 0.01 + WN4 - 0.07) net=n5
  l39 = rect li xspan=(x5 + L - 0.045, x6 + L + 0.145) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n4
  l40 = rect li xspan=(x5 + L - 0.015, x7 + L + 0.03) yspan=(nb + 0.01 + WN4 + 0.03, nb + WN2 - 0.01) net=n4
  l41 = rect li xspan=(x5 + L - 0.015, x6 + L + 0.145) yspan=(nb + 0.01 + WN4 + 0.03, pt - WP - 0.16) net=n4
  l42 = rect li xspan=(x5 + L - 0.01, x6 + L + 0.145) yspan=(nb + 0.01 + WN4 + 0.03, pt - 0.36 - 0.08) net=n4
  l43 = rect li xspan=(x5 + L - 0.01, x7 + L + 0.145) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.08) net=n4
  l44 = rect li xspan=(x7 + 0.005, x11 + 0.02) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n4
  l45 = rect li xspan=(x7 + 0.005, x7 + L + 0.03) yspan=(nb + 0.01 + 0.01, nb + WN2 - 0.01) net=n4
  l46 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.145) yspan=(pt - WP2 + 0.23, pt - 0.02 - 0.06) net=n4
  l47 = rect li xspan=(x7 + L - 0.03, x11 + 0.035) yspan=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n4
  l48 = rect li xspan=(x9 + 0.025, x11 + 0.02) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) net=n4
  l49 = rect li xspan=(x8 - 0.425, x13 + L + 0.22) yspan=(pt - 0.36 - 0.23, pt - 0.36 - 0.06) net=n2
  l50 = rect li xspan=(x11 + L + 0.045, x12 - 0.225) yspan=(nb + 0.01 + 0.04, nb + 0.23 - 0.01) net=n2
  l51 = rect li xspan=(x12 - 0.395, x12 - 0.225) yspan=(nb + 0.01 + 0.04, pt - WP - 0.28) net=n2
  l52 = rect li xspan=(x12 - 0.285, x12 - 0.115) yspan=(nb + WN + 0.15, pt - 0.36 - 0.06) net=n2
  l53 = rect li xspan=(x13 + L + 0.05, x13 + L + 0.22) yspan=(pt - 0.36 - 0.23, pt - 0.02 - 0.02) net=n2
  l54 = rect li xspan=(x13 + L + 0.05, x19 + L + 0.065) yspan=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) net=n2
  l55 = rect li xspan=(x14 - 0.045, x14 + L - 0.02) yspan=(nb + 0.01 + WN4 + 0.055, pt - 0.02 - 0.02) net=n2
  l56 = rect li xspan=(x14, x14 + L + 0.225) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n2
  l57 = rect li xspan=(x14, x14 + L + 0.025) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN + 0.005) net=n2
  l58 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.225) yspan=(nb + 0.01 + 0.075, nb + WN3 - 0.01) net=n2
  l59 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(nb + 0.23 - 0.09, pt - 0.02 - 0.04) net=X
  l60 = rect li xspan=(x1 + L - 0.03, x5 - 0.07) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=X
  l61 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + WN + 0.11, pt - 0.02 - 0.04) net=X
  l62 = rect li xspan=(x3 + L - 0.04, x5 - 0.07) yspan=(nb + 0.01 + 0.105, pt - 0.02) net=X
  l63 = rect li xspan=(x3 + L - 0.04, x5 - 0.055) yspan=(nb + 0.01 + 0.105, pt - WP - 0.56) net=X
  l64 = rect li xspan=(x3 + L - 0.04, x5 - 0.035) yspan=(pt - WP - 0.045, pt - 0.02) net=X
  l65 = rect li xspan=(x16 - 0.295, x16 - 0.125) yspan=(nb + 0.01 + WN4 - 0.07, pt - 0.36 - 0.02) net=n1
  l66 = rect li xspan=(x16 - 0.295, x21 + L + 0.355) yspan=(pt - WP2 + 0.29, pt - 0.36 - 0.02) net=n1
  l67 = rect li xspan=(x21 + 0.015, x21 + L + 0.355) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.02) net=n1
  l68 = rect li xspan=(x21 + L + 0.055, x21 + L + 0.355) yspan=(nb + 0.01 + 0.01, nb + 0.01 + WN4 - 0.08) net=n1
  l69 = rect li xspan=(x21 + L + 0.06, x21 + L + 0.185) yspan=(pt - WP2 + 0.23, pt - 0.02) net=n1
  l70 = rect li xspan=(x21 + L + 0.185, x21 + L + 0.355) yspan=(nb + 0.01 + 0.01, pt - 0.02) net=n1
  l71 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP + 0.005, H + 0.085) net=VPWR
  l72 = rect li xspan=(x2 + L + 0.055, x3 - 0.065) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l73 = rect li xspan=(x5 + L - 0.01, x7 - 0.065) yspan=(pt - 0.2 - 0.07, H + 0.085) net=VPWR
  l74 = rect li xspan=(x12 - 0.305, x12 + 0.03) yspan=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  l75 = rect li xspan=(x20 + L - 0.03, x21 + 0.035) yspan=(pt - 0.2 - 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x6 + L + 0.12) span=(-0.085 + 0.08, nb + 0.23 + 0.06 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd4 cx=(x12 + 0.035) span=(-0.085 + 0.08, nb + WN2 - 0.01 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd3 cx=(x10 - 0.13) span=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) margin=0.04 net=n4
  c4 = array licon in=nd3 cx=(x11 + L + 0.21) span=(nb + 0.01 + 0.04, nb + 0.23 - 0.01) margin=0.04 net=n2
  c5 = array licon in=nd9 cx=(x17 + L + 0.07) span=(nb + 0.01 + 0.01, nb + 0.23) net=n3
  c6 = array licon in=nd8 cx=(x14 - 0.14) span=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n5
  c7 = array licon in=nd12 cx=(x20 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.1 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd12 cx=(x21 + L + 0.14) span=(nb + 0.01 + 0.01 + 0.08, nb + 0.01 + WN4 - 0.08 - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd8 cx=(x14 + L + 0.14) span=(nb + 0.01 + 0.075 + 0.08, nb + WN3 - 0.01 - 0.08) margin=0.04 net=n2
  c10 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.01 + WN4 + 0.07 - 0.08) net=VGND
  c11 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.23 - 0.09 + 0.08, pt - 0.02 - 0.04 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.01 + WN4 + 0.07 - 0.08) margin=0.04 net=VGND
  c13 = array licon in=nd1 cx=(x4 + L + 0.12) span=(nb + 0.01 + 0.105 + 0.08, pt - WP - 0.56 - 0.08) margin=0.04 net=X
  c14 = array licon in=nd12 cx=(x20 - 0.14) span=(nb + 0.01 + 0.05 + 0.08, nb + WN + 0.02 - 0.08) net=n5
  c15 = array licon in=nd3 cx=(x8 - 0.075) span=(nb + 0.01 + WN4 - 0.04, nb + WN + 0.02) net=n3
  c16 = array licon in=nd4 cx=(x13 + L + 0.14) span=(nb + 0.23 - 0.05 + 0.08, pt - WP2 + 0.07 - 0.08) net=n6
  c17 = array licon in=nd2 cx=(x7 + L + 0.285) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - WP2 + 0.06 - 0.08) margin=0.04 net=n7
  c18 = array licon in=nd9 cx=(x16 - 0.21) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - 0.36 - 0.02 - 0.08) margin=0.04 net=n1
  c19 = array licon in=pd3 cx=(x11 + L + 0.225) span=(pt - WP + 0.04, pt - WP2 + 0.05) net=n3
  c20 = array licon in=pd4 cx=(x5 - 0.12) span=(pt - WP - 0.045 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c21 = array licon in=pd5 cx=(x7 + L + 0.14) span=(pt - WP + 0.05, pt - WP2 + 0.06) margin=0.04 net=n7
  c22 = array licon in=pd8 cx=(x15 - 0.275) span=(pt - WP - 0.04, pt - 0.36 - 0.08) margin=0.04 net=n3
  c23 = array licon in=pd13 cx=(x20 - 0.14) span=(pt - WP + 0.01, pt - WP2 + 0.06) margin=0.04 net=n5
  c24 = array licon in=pd7 cx=(x13 + L - 0.035) span=(pt - WP - 0.04, pt - WP2 + 0.07) net=n6
  c25 = array licon in=pd4 cx=(x1 - 0.14) span=(pt - WP + 0.005 + 0.08, H + 0.085 - 0.08) net=VPWR
  c26 = array licon in=pd4 cx=(x1 + L + 0.14) span=(nb + 0.23 - 0.09 + 0.08, pt - 0.02 - 0.04 - 0.08) margin=0.04 net=X
  c27 = array licon in=pd4 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd8 cx=(x14 - 0.3) span=(nb + 0.01 + 0.02 + 0.08, pt - 0.36 - 0.02 - 0.08) net=n5
  c29 = array licon in=pd13 cx=(x21 + L + 0.145) span=(pt - WP2 + 0.23, pt - 0.36 - 0.02) margin=0.04 net=n1
  c30 = array licon in=pd1 cx=(x8 - 0.14) span=(pt - 0.36 - 0.23, pt - 0.36 - 0.06) margin=0.04 net=n2
  c31 = array licon in=pd10 cx=(x16 - 0.06) span=(pt - WP2 + 0.29, pt - 0.36 - 0.02) margin=0.04 net=n1
  c32 = array licon in=pd4 cx=(x6 + L + 0.145) span=(pt - 0.2 - 0.07, H + 0.085) margin=0.04 net=VPWR
  c33 = array licon in=pd1 cx=(x9 + L + 0.075) span=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n4
  c34 = array licon in=pd7 cx=(x12 - 0.14) span=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  c35 = array licon in=pd12 cx=(x18 - 0.15) span=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) margin=0.04 net=n2
  c36 = array licon in=pd13 cx=(x20 + L + 0.14) span=(pt - 0.2 - 0.01, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x19 + 0.015) cy=(pt - WP - 0.375)
  gc2 = contact licon cx=(x6 + L + 0.025) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x8 - 0.07) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x11 + 0.055) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x15 - 0.265) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x16 + L - 0.015) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x20 - 0.01) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x21 + L/2) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.51, x21 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x18 - 0.17, x19 + L + 0.055) yspan=(nb + WN + 0.04, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.28) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.04) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.08) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.09) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.13) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.075) cy=0
  mc7 = contact mcon cx=(x8 - 0.375) cy=0
  mc8 = contact mcon cx=(x9 + 0.025) cy=0
  mc9 = contact mcon cx=(x11 + 0.045) cy=0
  mc10 = contact mcon cx=(x11 + L + 0.36) cy=0
  mc11 = contact mcon cx=(x12 - 0.08) cy=0
  mc12 = contact mcon cx=(x13 + L + 0.07) cy=0
  mc13 = contact mcon cx=(x14 - 0.26) cy=0
  mc14 = contact mcon cx=(x14 + L + 0.06) cy=0
  mc15 = contact mcon cx=(x15 - 0.095) cy=0
  mc16 = contact mcon cx=(x15 + L + 0.225) cy=0
  mc17 = contact mcon cx=(x16 + 0.035) cy=0
  mc18 = contact mcon cx=(x18 - 0.105) cy=0
  mc19 = contact mcon cx=(x20 - 0.15) cy=0
  mc20 = contact mcon cx=(x21 - 0.11) cy=0
  mc21 = contact mcon cx=(x21 + L + 0.21) cy=0
  mc22 = contact mcon cx=(x14 - 0.26) cy=(nb + 0.23 + 0.045)
  mc23 = contact mcon cx=(x20 - 0.15) cy=(nb + 0.23 + 0.045)
  mc24 = contact mcon cx=(x13 + L + 0.07) cy=(nb + WN3 + 0.015)
  mc25 = contact mcon cx=(x15 - 0.095) cy=(nb + WN3 + 0.015)
  mc26 = contact mcon cx=(x18 - 0.105) cy=(nb + WN3 + 0.015)
  mc27 = contact mcon cx=(x11 + L + 0.36) cy=(pt - WP + 0.045)
  mc28 = contact mcon cx=(x15 - 0.095) cy=(pt - WP + 0.045)
  mc29 = contact mcon cx=(x1 - 0.28) cy=H
  mc30 = contact mcon cx=(x1 + L + 0.04) cy=H
  mc31 = contact mcon cx=(x2 + L + 0.08) cy=H
  mc32 = contact mcon cx=(x4 + L + 0.09) cy=H
  mc33 = contact mcon cx=(x6 + L + 0.13) cy=H
  mc34 = contact mcon cx=(x7 + L + 0.075) cy=H
  mc35 = contact mcon cx=(x8 - 0.375) cy=H
  mc36 = contact mcon cx=(x9 + 0.025) cy=H
  mc37 = contact mcon cx=(x11 + 0.045) cy=H
  mc38 = contact mcon cx=(x11 + L + 0.36) cy=H
  mc39 = contact mcon cx=(x12 - 0.08) cy=H
  mc40 = contact mcon cx=(x13 + L + 0.07) cy=H
  mc41 = contact mcon cx=(x14 - 0.26) cy=H
  mc42 = contact mcon cx=(x14 + L + 0.06) cy=H
  mc43 = contact mcon cx=(x15 - 0.095) cy=H
  mc44 = contact mcon cx=(x15 + L + 0.225) cy=H
  mc45 = contact mcon cx=(x16 + 0.035) cy=H
  mc46 = contact mcon cx=(x18 - 0.105) cy=H
  mc47 = contact mcon cx=(x20 - 0.15) cy=H
  mc48 = contact mcon cx=(x21 - 0.11) cy=H
  mc49 = contact mcon cx=(x21 + L + 0.21) cy=H
  w1 = rect m1 xspan=(x13 + L + 0.385, x14 - 0.115) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n5
  w2 = rect m1 xspan=(x13 + L + 0.385, x20) yspan=(nb + 0.23 - 0.025, nb + 0.01 + WN4 - 0.085) net=n5
  w3 = rect m1 xspan=(x19 + L + 0.065, x20) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n5
  w4 = rect m1 xspan=(x13 + 0.07, x13 + L + 0.215) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n6
  w5 = rect m1 xspan=(x13 + 0.07, x19 + 0.04) yspan=(nb + WN3 - 0.055, nb + WN + 0.035) net=n6
  w6 = rect m1 xspan=(x15 - 0.24, x15 + 0.055) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n6
  w7 = rect m1 xspan=(x17 + L + 0.125, x19 + 0.04) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP - 0.52) net=n6
  w8 = rect m1 xspan=(x11 + L + 0.215, x12 - 0.395) yspan=(pt - WP - 0.07, pt - WP2) net=n3
  w9 = rect m1 xspan=(x11 + L + 0.215, x15 + 0.055) yspan=(pt - WP - 0.025, pt - 0.02 - WP2 - 0.025) net=n3
  w10 = rect m1 xspan=(x15 - 0.24, x15 + 0.055) yspan=(pt - WP - 0.07, pt - WP2) net=n3
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l11
  port B in on=l13
  port C in on=l10
  port X out on=l62
end
