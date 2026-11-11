# xor3_4: lifted from sky130_fd_sc_hd__xor3_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.64 WN3=0.6 WN4=0.42 WP=1 WP2=0.84 WP3=0.64 L=0.15 H=2.72

stdcell xor3_4 width=26 height=H taps=no
  device M0 pmos w=WP3 l=L d=n1 g=n2 s=n3 b=VPB
  device M1 nmos w=WN4 l=L d=VGND g=C s=n4 b=VNB
  device M2 nmos w=WN2 l=L d=VGND g=n5 s=n3 b=VNB
  device M3 pmos w=WP2 l=L d=n1 g=C s=n6 b=VPB
  device M4 nmos w=WN3 l=L d=n1 g=n2 s=n5 b=VNB
  device M5 pmos w=WP2 l=L d=n7 g=n2 s=n5 b=VPB
  device M6 nmos w=WN l=L d=X g=n6 s=VGND b=VNB
  device M7 nmos w=WN2 l=L d=n5 g=B s=n7 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=n6 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n7 g=C s=n6 b=VNB
  device M10 pmos w=WP l=L d=n5 g=A s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n6 s=X b=VPB
  device M12 pmos w=WP l=L d=X g=n6 s=VPWR b=VPB
  device M13 nmos w=WN4 l=L d=n7 g=n2 s=n3 b=VNB
  device M14 pmos w=WP l=L d=X g=n6 s=VPWR b=VPB
  device M15 pmos w=WP3 l=L d=n3 g=B s=n7 b=VPB
  device M16 nmos w=WN l=L d=VGND g=n6 s=X b=VNB
  device M17 nmos w=WN l=L d=VGND g=B s=n2 b=VNB
  device M18 pmos w=WP3 l=L d=VPWR g=C s=n4 b=VPB
  device M19 nmos w=WN l=L d=X g=n6 s=VGND b=VNB
  device M20 nmos w=WN l=L d=VGND g=n6 s=X b=VNB
  device M21 nmos w=WN2 l=L d=n6 g=n4 s=n1 b=VNB
  device M22 nmos w=WN2 l=L d=n3 g=B s=n1 b=VNB
  device M23 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M24 pmos w=WP2 l=L d=n5 g=B s=n1 b=VPB
  device M25 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M26 pmos w=WP l=L d=VPWR g=n5 s=n3 b=VPB
  device M27 pmos w=WP2 l=L d=n6 g=n4 s=n7 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + 0.1
  x3 = x2 + L + 0.18
  x4 = x3 + 0.1
  x5 = x4 + L + 0.18
  x6 = x5 + 0.1
  x7 = x6 + L + 0.18
  x8 = x7 + 0.1
  x9 = x8 + L + 0.355
  x10 = x9 + 0.09
  x11 = x10 + L + 0.79
  x12 = x11 + 0.04
  x13 = x12 + L + 0.35
  x14 = x13 + 0.06
  x15 = x14 + L + 1.005
  x16 = x15 + L + 0.025
  x17 = x16 + L + 0.79
  x18 = x17 + L + 0.62
  x19 = x18 + L + 0.655
  x20 = x19 + 0.08
  x21 = x20 + L + 0.375
  x22 = x21 + 0.005
  x23 = x22 + L + 0.36
  x24 = x23 + L + 0.32
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x9 + 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x10 + L + 0.285) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x11 - 0.235, x14 + L + 0.5) yspan=(nb + 0.01, nb + WN)
  nd4 = rect diff xspan=(x15 - 0.1, x16 + L + 0.255) yspan=(nb, nb + WN)
  nd5 = rect diff xspan=(x15 - 0.1, x16 + L + 0.265) yspan=(nb + 0.01 + WN4 - 0.06, nb + WN)
  nd6 = rect diff xspan=(x17 - 0.265, x24 + L + 0.265) yspan=(nb + 0.01, nb + 0.23 + 0.06)
  nd7 = rect diff xspan=(x17 - 0.255, x24 + L + 0.265) yspan=(nb + 0.01, nb + 0.01 + WN4)
  nd8 = rect diff xspan=(x17 - 0.255, x18 - 0.11) yspan=(nb + 0.01, nb + WN)
  nd9 = rect diff xspan=(x18 + L + 0.13, x20 + L + 0.175) yspan=(nb + 0.01, nb + WN)
  nd10 = rect diff xspan=(x18 + L + 0.13, x24 + L + 0.265) yspan=(nb + 0.01 + WN4, nb + WN3)
  nd11 = rect diff xspan=(x20 + L + 0.01, x24 + L + 0.265) yspan=(nb, nb + WN3)
  nd12 = rect diff xspan=(x22 + L + 0.105, x24 + L + 0.265) yspan=(nb, nb + WN2)
  pd1 = rect diff xspan=(x11 - 0.265, x14 + L + 0.47) yspan=(pt - 0.02 - WP2, pt - 0.02)
  pd2 = rect diff xspan=(x1 - 0.165, x9 - 0.09) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x1 - 0.165, x10 + L + 0.235) yspan=(pt - WP, pt - 0.36)
  pd4 = rect diff xspan=(x15 - 0.265, x16 + L + 0.09) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x15 - 0.265, x16 + L + 0.1) yspan=(pt - WP, pt - WP2 + 0.1)
  pd6 = rect diff xspan=(x16 + L + 0.36, x18 - 0.115) yspan=(pt - 0.36 - 0.3, pt - 0.16)
  pd7 = rect diff xspan=(x16 + L + 0.37, x19 - 0.175) yspan=(pt - WP, pt - 0.36)
  pd8 = rect diff xspan=(x16 + L + 0.37, x24 + L + 0.265) yspan=(pt - WP2, pt - 0.36)
  pd9 = rect diff xspan=(x18 + L + 0.305, x24 + L + 0.265) yspan=(pt - 0.36, pt - 0.2)
  pd10 = rect diff xspan=(x20 + L + 0.08, x22 + L + 0.075) yspan=(pt - WP2, pt)
  pd11 = rect diff xspan=(x22 + L + 0.075, x24 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7, nd8, nd9, nd10, nd11, nd12] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7, pd8, pd9, pd10, pd11] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x17 + L + 0.215, x18 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x18, x18 + L) yspan=(0.115, pt - 0.2 - 0.03)
  p3 = rect poly xspan=(x9, x12 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, pt - 0.02 - 0.05)
  p5 = rect poly xspan=(x10, x10 + L) yspan=(nb + 0.01 + 0.09, pt - WP - 0.16)
  p6 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, pt + 0.11)
  p7 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.13)
  p8 = rect poly xspan=(x12, x12 + L + 0.01) yspan=(nb + WN + 0.1, pt - WP - 0.13)
  p9 = rect poly xspan=(x13 - 0.065, x14 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.11, pt + 0.11)
  p11 = rect poly xspan=(x14, x14 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.45)
  p13 = rect poly xspan=(x1 + 0.005, x8 + L + 0.14) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p15 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p16 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p17 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p18 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p19 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p20 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p21 = rect poly xspan=(x15, x15 + L) yspan=(nb + WN + 0.2, H - 0.105)
  p22 = rect poly xspan=(x15, x17 + L) yspan=(nb + WN + 0.2, pt - WP - 0.25)
  p23 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.25)
  p24 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  p25 = rect poly xspan=(x17, x20 + L) yspan=(pt - 0.02, H - 0.105)
  p26 = rect poly xspan=(x19, x19 + L) yspan=(0.105, pt - WP - 0.16)
  p27 = rect poly xspan=(x19, x20 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p28 = rect poly xspan=(x20, x20 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p29 = rect poly xspan=(x21 - 0.12, x22 + L) yspan=(nb + WN + 0.06, pt - WP - 0.21)
  p30 = rect poly xspan=(x21, x21 + L) yspan=(nb + WN + 0.06, H - 0.105)
  p31 = rect poly xspan=(x22, x22 + L) yspan=(0.105, pt - WP - 0.205)
  p32 = rect poly xspan=(x23 - 0.145, x23 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p33 = rect poly xspan=(x23, x23 + L) yspan=(0.105, H - 0.105)
  p34 = rect poly xspan=(x24 - 0.105, x24 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p35 = rect poly xspan=(x24, x24 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + 0.23 + 0.08) net=VGND
  l2 = rect li xspan=(x4 + 0.02, x5 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x7 + L + 0.05, x8 + L + 0.125) yspan=(-0.085, nb + 0.23 + 0.06) net=VGND
  l4 = rect li xspan=(x15 - 0.06, x15 + L - 0.035) yspan=(-0.085, nb + WN) net=VGND
  l5 = rect li xspan=(x23 + L + 0.095, x24 - 0.055) yspan=(-0.085, nb + 0.23 + 0.1) net=VGND
  l6 = rect li xspan=(x17 + L + 0.185, x18 - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.215) net=n2
  l7 = rect li xspan=(x18 - 0.225, x18 - 0.01) yspan=(nb + 0.01 + WN4 - 0.035, pt - WP - 0.215) net=n2
  l8 = rect li xspan=(x20 + L + 0.165, x21) yspan=(nb + 0.01 + WN4 + 0.065, pt - WP - 0.21) net=n2
  l9 = rect li xspan=(x20 + L + 0.165, x21 + L - 0.045) yspan=(nb + WN + 0.06, pt - WP - 0.21) net=n2
  l10 = rect li xspan=(x10 + L + 0.395, x12 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  l11 = rect li xspan=(x22 + L + 0.125, x23 + L + 0.035) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A
  l12 = rect li xspan=(x20 - 0.03, x20 + L - 0.01) yspan=(nb + WN + 0.11, pt - 0.02 - WP2 - 0.01) net=B
  l13 = rect li xspan=(x20 - 0.03, x22 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=B
  l14 = rect li xspan=(x9 + L/2 + 0.045, x14 - 0.005) yspan=(pt - WP + 0.05, pt - WP2 + 0.06) net=n4
  l15 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(nb + 0.01 + WN4 - 0.07, pt - WP2 + 0.06) net=n4
  l16 = rect li xspan=(x13 - 0.12, x14 + L + 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n4
  l17 = rect li xspan=(x13 - 0.12, x14 - 0.005) yspan=(nb + WN + 0.11, pt - WP2 + 0.06) net=n4
  l18 = rect li xspan=(x22 + L + 0.055, x24 + 0.06) yspan=(pt - WP + 0.01, pt - WP2 + 0.06) net=n5
  l19 = rect li xspan=(x22 + L + 0.095, x23 + 0.03) yspan=(nb + 0.01 + 0.05, nb + WN3 - 0.085) net=n5
  l20 = rect li xspan=(x22 + L + 0.135, x23 + 0.03) yspan=(nb + 0.01 + 0.05, pt - WP - 0.58) net=n5
  l21 = rect li xspan=(x22 + L + 0.135, x24 + 0.06) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP - 0.58) net=n5
  l22 = rect li xspan=(x24 - 0.115, x24 + 0.06) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP2 + 0.06) net=n5
  l23 = rect li xspan=(x24 - 0.115, x24 + L - 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n5
  l24 = rect li xspan=(x15 + L - 0.03, x16 + L + 0.225) yspan=(pt - WP - 0.04, pt - WP2 + 0.07) net=n2
  l25 = rect li xspan=(x16 + L - 0.02, x16 + L + 0.225) yspan=(nb + 0.23 - 0.05, pt - WP2 + 0.07) net=n2
  l26 = rect li xspan=(x17 + L + 0.17, x18 - 0.035) yspan=(pt - WP - 0.04, pt - 0.36 - 0.08) net=n1
  l27 = rect li xspan=(x17 + L + 0.17, x18 + L + 0.19) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=n1
  l28 = rect li xspan=(x18 + L + 0.02, x18 + L + 0.19) yspan=(nb + 0.01 + 0.01, pt - 0.02 - WP2 - 0.01) net=n1
  l29 = rect li xspan=(x18 + L + 0.02, x21 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n1
  l30 = rect li xspan=(x20 - 0.03, x21 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23) net=n1
  l31 = rect li xspan=(x11 - 0.385, x14 + L + 0.19) yspan=(pt - WP2 + 0.25, pt - 0.36 - 0.06) net=n1
  l32 = rect li xspan=(x14 + L + 0.02, x14 + L + 0.19) yspan=(pt - WP + 0.04, pt - 0.36 - 0.06) net=n1
  l33 = rect li xspan=(x14 + L + 0.02, x15 - 0.455) yspan=(pt - WP + 0.04, pt - WP2 + 0.05) net=n1
  l34 = rect li xspan=(x14 + L + 0.265, x14 + L + 0.435) yspan=(nb + 0.01 + WN4 - 0.07, pt - WP2 + 0.05) net=n1
  l35 = rect li xspan=(x14 + L + 0.265, x15 - 0.455) yspan=(pt - WP - 0.11, pt - WP2 + 0.05) net=n1
  l36 = rect li xspan=(x17 - 0.39, x17 - 0.22) yspan=(nb + 0.01 + 0.02, pt - 0.36 - 0.02) net=n5
  l37 = rect li xspan=(x17 - 0.39, x17 + 0.03) yspan=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n5
  l38 = rect li xspan=(x17 - 0.39, x17 - 0.17) yspan=(nb + 0.01 + 0.02, nb + 0.01 + WN4 - 0.07) net=n5
  l39 = rect li xspan=(x7 + L + 0.015, x8 + L + 0.145) yspan=(pt - WP - 0.52, pt - WP - 0.16) net=n6
  l40 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.145) yspan=(nb + 0.01 + WN4 + 0.03, pt - 0.36 - 0.08) net=n6
  l41 = rect li xspan=(x8 + L - 0.03, x10 + 0.025) yspan=(nb + 0.01 + WN4 + 0.03, nb + WN2 - 0.01) net=n6
  l42 = rect li xspan=(x8 + L - 0.03, x10 + L + 0.06) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.08) net=n6
  l43 = rect li xspan=(x9 - 0.06, x13 - 0.045) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n6
  l44 = rect li xspan=(x9 - 0.06, x10 + 0.025) yspan=(nb + 0.01 + 0.01, nb + WN2 - 0.01) net=n6
  l45 = rect li xspan=(x9 + L - 0.025, x10 + L + 0.06) yspan=(pt - WP2 + 0.23, pt - 0.02 - 0.06) net=n6
  l46 = rect li xspan=(x9 + L - 0.025, x13 + L - 0.035) yspan=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n6
  l47 = rect li xspan=(x11 + L - 0.01, x13 - 0.045) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) net=n6
  l48 = rect li xspan=(x11 - 0.285, x14 + L + 0.095) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n7
  l49 = rect li xspan=(x13 + L - 0.02, x15 - 0.23) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n7
  l50 = rect li xspan=(x13 + L - 0.02, x14 + L + 0.095) yspan=(nb + 0.01 + 0.01, nb + WN3 - 0.01) net=n7
  l51 = rect li xspan=(x14 + L + 0.125, x15 - 0.475) yspan=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n7
  l52 = rect li xspan=(x14 + L + 0.36, x16 + L + 0.225) yspan=(pt - WP2 + 0.25, pt - 0.36 - 0.06) net=n7
  l53 = rect li xspan=(x14 + L + 0.36, x15 - 0.475) yspan=(pt - WP2 + 0.25, pt - 0.02 - 0.06) net=n7
  l54 = rect li xspan=(x15 - 0.4, x15 - 0.23) yspan=(nb + 0.01 + 0.01, pt - WP - 0.28) net=n7
  l55 = rect li xspan=(x15 - 0.285, x15 - 0.145) yspan=(nb + WN + 0.15, pt - WP2 + 0.25) net=n7
  l56 = rect li xspan=(x15 - 0.285, x15 - 0.13) yspan=(nb + WN + 0.155, pt - WP2 + 0.25) net=n7
  l57 = rect li xspan=(x15 - 0.285, x15 - 0.12) yspan=(nb + WN + 0.16, pt - WP2 + 0.25) net=n7
  l58 = rect li xspan=(x15 - 0.285, x15 - 0.115) yspan=(nb + WN + 0.165, pt - 0.36 - 0.06) net=n7
  l59 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.225) yspan=(pt - WP2 + 0.25, pt - 0.02 - 0.02) net=n7
  l60 = rect li xspan=(x16 + L + 0.055, x22 + L + 0.065) yspan=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) net=n7
  l61 = rect li xspan=(x17 - 0.03, x17 + L - 0.005) yspan=(nb + 0.01 + WN4 + 0.055, pt - 0.02 - 0.02) net=n7
  l62 = rect li xspan=(x17 + 0.005, x17 + L + 0.225) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n7
  l63 = rect li xspan=(x17 + 0.005, x17 + L + 0.03) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN + 0.005) net=n7
  l64 = rect li xspan=(x17 + L + 0.055, x17 + L + 0.225) yspan=(nb + 0.01 + 0.075, nb + WN3 - 0.01) net=n7
  l65 = rect li xspan=(x1 + L + 0.05, x3 - 0.055) yspan=(nb + 0.01 + 0.105, nb + WN + 0.04) net=X
  l66 = rect li xspan=(x1 + L + 0.05, x6 + L + 0.055) yspan=(nb + 0.01 + WN4 - 0.005, nb + WN + 0.04) net=X
  l67 = rect li xspan=(x1 + L + 0.05, x7 - 0.055) yspan=(nb + 0.01 + WN4 - 0.005, nb + WN3 - 0.005) net=X
  l68 = rect li xspan=(x2 + L + 0.055, x3 + 0.05) yspan=(pt - WP - 0.045, pt - 0.02) net=X
  l69 = rect li xspan=(x2 + L + 0.055, x5 + L + 0.035) yspan=(pt - WP - 0.045, pt - 0.36 - 0.08) net=X
  l70 = rect li xspan=(x2 + L + 0.055, x7 + 0.05) yspan=(pt - WP - 0.03, pt - 0.36 - 0.08) net=X
  l71 = rect li xspan=(x4 + L + 0.045, x5 + L + 0.035) yspan=(nb + 0.01 + WN4 - 0.005, pt - 0.36 - 0.08) net=X
  l72 = rect li xspan=(x5 + L + 0.05, x7 - 0.055) yspan=(nb + 0.23 - 0.115, nb + 0.01 + WN4 - 0.005) net=X
  l73 = rect li xspan=(x6 + L + 0.055, x7 + 0.05) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l74 = rect li xspan=(x19 - 0.295, x19 - 0.125) yspan=(nb + 0.01 + WN4 - 0.07, pt - 0.36 - 0.02) net=n3
  l75 = rect li xspan=(x19 - 0.295, x24 + L + 0.315) yspan=(pt - WP2 + 0.29, pt - 0.36 - 0.02) net=n3
  l76 = rect li xspan=(x24 - 0.03, x24 + L + 0.315) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.02) net=n3
  l77 = rect li xspan=(x24 + L + 0.055, x24 + L + 0.315) yspan=(nb + 0.01 + 0.01, nb + 0.01 + WN4 - 0.08) net=n3
  l78 = rect li xspan=(x24 + L + 0.055, x24 + L + 0.315) yspan=(pt - WP2 + 0.23, pt - 0.02) net=n3
  l79 = rect li xspan=(x24 + L + 0.145, x24 + L + 0.315) yspan=(nb + 0.01 + 0.01, pt - 0.02) net=n3
  l80 = rect li xspan=(x1 - 0.125, x1 + 0.05) yspan=(pt - 0.36 + 0.01, H + 0.085) net=VPWR
  l81 = rect li xspan=(x4 + L - 0.03, x5 + L - 0.02) yspan=(pt - 0.2 - 0.07, H + 0.085) net=VPWR
  l82 = rect li xspan=(x8 + L - 0.03, x9 - 0.05) yspan=(pt - 0.2 - 0.07, H + 0.085) net=VPWR
  l83 = rect li xspan=(x15 - 0.305, x15 + 0.03) yspan=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  l84 = rect li xspan=(x23 + L + 0.015, x24 + 0.03) yspan=(pt - 0.2 - 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x8 + L + 0.04) span=(-0.085 + 0.08, nb + 0.23 + 0.06 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x12 + L + 0.14) span=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) margin=0.04 net=n6
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.08 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x4 + L + 0.04) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c5 = array licon in=nd4 cx=(x15 + 0.03) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd9 cx=(x20 + L + 0.07) span=(nb + 0.01 + 0.01, nb + 0.23) net=n1
  c7 = array licon in=nd8 cx=(x17 - 0.14) span=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n5
  c8 = array licon in=nd12 cx=(x24 - 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.1 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd12 cx=(x24 + L + 0.14) span=(nb + 0.01 + 0.01 + 0.08, nb + 0.01 + WN4 - 0.08 - 0.08) net=n3
  c10 = array licon in=nd8 cx=(x17 + L + 0.14) span=(nb + 0.01 + 0.075 + 0.08, nb + WN3 - 0.01 - 0.08) margin=0.04 net=n7
  c11 = array licon in=nd1 cx=(x2 + L + 0.04) span=(nb + 0.01 + 0.105 + 0.08, nb + WN + 0.04 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd1 cx=(x6 + L + 0.04) span=(nb + 0.23 - 0.115 + 0.08, nb + 0.01 + WN4 - 0.005 - 0.08) margin=0.04 net=X
  c13 = array licon in=nd12 cx=(x23 - 0.14) span=(nb + 0.01 + 0.05 + 0.08, pt - WP - 0.58 - 0.08) net=n5
  c14 = array licon in=nd4 cx=(x16 + L + 0.14) span=(nb + 0.23 - 0.05 + 0.08, pt - WP2 + 0.07 - 0.08) net=n2
  c15 = array licon in=nd3 cx=(x11 - 0.1) span=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n7
  c16 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - WP2 + 0.06 - 0.08) margin=0.04 net=n4
  c17 = array licon in=nd3 cx=(x14 + L + 0.35) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - WP2 + 0.05 - 0.08) margin=0.04 net=n1
  c18 = array licon in=nd9 cx=(x19 - 0.21) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - 0.36 - 0.02 - 0.08) margin=0.04 net=n3
  c19 = array licon in=pd2 cx=(x3 - 0.04) span=(pt - WP - 0.045 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c20 = array licon in=pd2 cx=(x7 - 0.04) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c21 = array licon in=pd3 cx=(x10 + L + 0.09) span=(pt - WP + 0.05, pt - WP2 + 0.06) margin=0.04 net=n4
  c22 = array licon in=pd7 cx=(x18 - 0.275) span=(pt - WP - 0.04, pt - 0.36 - 0.08) margin=0.04 net=n1
  c23 = array licon in=pd11 cx=(x23 - 0.14) span=(pt - WP + 0.01, pt - WP2 + 0.06) margin=0.04 net=n5
  c24 = array licon in=pd4 cx=(x16 + L - 0.03) span=(pt - WP - 0.04, pt - WP2 + 0.07) net=n2
  c25 = array licon in=pd7 cx=(x17 - 0.305) span=(nb + 0.01 + 0.02 + 0.08, pt - 0.36 - 0.02 - 0.08) net=n5
  c26 = array licon in=pd11 cx=(x24 + L + 0.14) span=(pt - WP2 + 0.23 + 0.08, pt - 0.02 - 0.08) net=n3
  c27 = array licon in=pd1 cx=(x11 - 0.14) span=(pt - WP2 + 0.25, pt - 0.36 - 0.06) net=n1
  c28 = array licon in=pd8 cx=(x19 - 0.06) span=(pt - WP2 + 0.29, pt - 0.36 - 0.02) margin=0.04 net=n3
  c29 = array licon in=pd2 cx=(x1 - 0.04) span=(pt - 0.36 + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c30 = array licon in=pd2 cx=(x5 - 0.04) span=(pt - 0.2 - 0.07, H + 0.085) margin=0.04 net=VPWR
  c31 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - 0.2 - 0.07, H + 0.085) net=VPWR
  c32 = array licon in=pd1 cx=(x12 + L + 0.145) span=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) margin=0.04 net=n6
  c33 = array licon in=pd1 cx=(x14 + L + 0.33) span=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n7
  c34 = array licon in=pd4 cx=(x15 - 0.14) span=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  c35 = array licon in=pd10 cx=(x21 - 0.15) span=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) margin=0.04 net=n7
  c36 = array licon in=pd11 cx=(x24 - 0.14) span=(pt - 0.2 - 0.01, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x22 + 0.015) cy=(pt - WP - 0.375)
  gc2 = contact licon cx=(x8 + L) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x11 - 0.285) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x12 + 0.02) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x14 + 0.015) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x18 - 0.27) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x19 + L - 0.015) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x23 - 0.01) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=(x24 + 0.035) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x24 + L + 0.76) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x21 - 0.17, x22 + L + 0.055) yspan=(nb + WN + 0.04, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.05) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.09) cy=0
  mc4 = contact mcon cx=(x7 - 0.05) cy=0
  mc5 = contact mcon cx=(x8 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x10 + L + 0.045) cy=0
  mc7 = contact mcon cx=(x11 - 0.285) cy=0
  mc8 = contact mcon cx=(x12 + L - 0.01) cy=0
  mc9 = contact mcon cx=(x13 + L - 0.04) cy=0
  mc10 = contact mcon cx=(x14 + L + 0.365) cy=0
  mc11 = contact mcon cx=(x15 - 0.18) cy=0
  mc12 = contact mcon cx=(x16 + L - 0.03) cy=0
  mc13 = contact mcon cx=(x17 - 0.355) cy=0
  mc14 = contact mcon cx=(x17 + L - 0.04) cy=0
  mc15 = contact mcon cx=(x18 - 0.195) cy=0
  mc16 = contact mcon cx=(x18 + L + 0.125) cy=0
  mc17 = contact mcon cx=(x19 - 0.07) cy=0
  mc18 = contact mcon cx=(x20 + L + 0.17) cy=0
  mc19 = contact mcon cx=(x22 + L + 0.11) cy=0
  mc20 = contact mcon cx=(x23 + L + 0.07) cy=0
  mc21 = contact mcon cx=(x24 + L + 0.07) cy=0
  mc22 = contact mcon cx=(x24 + L + 0.53) cy=0
  mc23 = contact mcon cx=(x17 - 0.255) cy=(nb + 0.23 + 0.045)
  mc24 = contact mcon cx=(x23 - 0.15) cy=(nb + 0.23 + 0.045)
  mc25 = contact mcon cx=(x16 + L + 0.075) cy=(nb + WN3 + 0.015)
  mc26 = contact mcon cx=(x18 - 0.095) cy=(nb + WN3 + 0.015)
  mc27 = contact mcon cx=(x21 - 0.105) cy=(nb + WN3 + 0.015)
  mc28 = contact mcon cx=(x14 + L + 0.465) cy=(pt - WP + 0.045)
  mc29 = contact mcon cx=(x18 - 0.095) cy=(pt - WP + 0.045)
  mc30 = contact mcon cx=(x1 - 0.17) cy=H
  mc31 = contact mcon cx=(x2 + L + 0.05) cy=H
  mc32 = contact mcon cx=(x4 + L + 0.09) cy=H
  mc33 = contact mcon cx=(x7 - 0.05) cy=H
  mc34 = contact mcon cx=(x8 + L + 0.17) cy=H
  mc35 = contact mcon cx=(x10 + L + 0.045) cy=H
  mc36 = contact mcon cx=(x11 - 0.285) cy=H
  mc37 = contact mcon cx=(x12 + L - 0.01) cy=H
  mc38 = contact mcon cx=(x13 + L - 0.04) cy=H
  mc39 = contact mcon cx=(x14 + L + 0.365) cy=H
  mc40 = contact mcon cx=(x15 - 0.18) cy=H
  mc41 = contact mcon cx=(x16 + L - 0.03) cy=H
  mc42 = contact mcon cx=(x17 - 0.355) cy=H
  mc43 = contact mcon cx=(x17 + L - 0.04) cy=H
  mc44 = contact mcon cx=(x18 - 0.195) cy=H
  mc45 = contact mcon cx=(x18 + L + 0.125) cy=H
  mc46 = contact mcon cx=(x19 - 0.07) cy=H
  mc47 = contact mcon cx=(x20 + L + 0.17) cy=H
  mc48 = contact mcon cx=(x22 + L + 0.11) cy=H
  mc49 = contact mcon cx=(x23 + L + 0.07) cy=H
  mc50 = contact mcon cx=(x24 + L + 0.07) cy=H
  mc51 = contact mcon cx=(x24 + L + 0.53) cy=H
  w1 = rect m1 xspan=(x16 + L + 0.39, x17 - 0.11) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n5
  w2 = rect m1 xspan=(x16 + L + 0.39, x23) yspan=(nb + 0.23 - 0.025, nb + 0.01 + WN4 - 0.085) net=n5
  w3 = rect m1 xspan=(x22 + L + 0.065, x23) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n5
  w4 = rect m1 xspan=(x16 + L/2, x16 + L + 0.22) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n2
  w5 = rect m1 xspan=(x16 + L/2, x22 + 0.04) yspan=(nb + WN3 - 0.055, nb + WN + 0.035) net=n2
  w6 = rect m1 xspan=(x18 - 0.24, x18 + 0.055) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n2
  w7 = rect m1 xspan=(x20 + L + 0.125, x22 + 0.04) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP - 0.52) net=n2
  w8 = rect m1 xspan=(x14 + L + 0.32, x15 - 0.395) yspan=(pt - WP - 0.07, pt - WP2) net=n1
  w9 = rect m1 xspan=(x14 + L + 0.32, x18 + 0.055) yspan=(pt - WP - 0.025, pt - 0.02 - WP2 - 0.025) net=n1
  w10 = rect m1 xspan=(x18 - 0.24, x18 + 0.055) yspan=(pt - WP - 0.07, pt - WP2) net=n1
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l11
  port B in on=l13
  port C in on=l10
  port X out on=l69
end
