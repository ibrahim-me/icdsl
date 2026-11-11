# xor3_1: lifted from sky130_fd_sc_hd__xor3_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.64 WN3=0.6 WN4=0.42 WP=1 WP2=0.84 WP3=0.64 L=0.15 H=2.72

stdcell xor3_1 width=22 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=n2 s=n3 b=VPB
  device M1 pmos w=WP3 l=L d=n4 g=n5 s=n6 b=VPB
  device M2 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M3 nmos w=WN3 l=L d=n4 g=n5 s=n7 b=VNB
  device M4 pmos w=WP2 l=L d=n3 g=n5 s=n7 b=VPB
  device M5 nmos w=WN2 l=L d=n7 g=B s=n3 b=VNB
  device M6 nmos w=WN2 l=L d=n3 g=C s=n1 b=VNB
  device M7 pmos w=WP l=L d=n7 g=A s=VPWR b=VPB
  device M8 nmos w=WN4 l=L d=n3 g=n5 s=n6 b=VNB
  device M9 pmos w=WP2 l=L d=n4 g=C s=n1 b=VPB
  device M10 nmos w=WN2 l=L d=VGND g=n7 s=n6 b=VNB
  device M11 pmos w=WP l=L d=VPWR g=n7 s=n6 b=VPB
  device M12 pmos w=WP l=L d=VPWR g=B s=n5 b=VPB
  device M13 nmos w=WN4 l=L d=VGND g=C s=n2 b=VNB
  device M14 nmos w=WN2 l=L d=n1 g=n2 s=n4 b=VNB
  device M15 nmos w=WN l=L d=VGND g=B s=n5 b=VNB
  device M16 pmos w=WP2 l=L d=n7 g=B s=n4 b=VPB
  device M17 pmos w=WP3 l=L d=n6 g=B s=n3 b=VPB
  device M18 nmos w=WN2 l=L d=n6 g=B s=n4 b=VNB
  device M19 nmos w=WN2 l=L d=n7 g=A s=VGND b=VNB
  device M20 pmos w=WP3 l=L d=VPWR g=C s=n2 b=VPB
  device M21 nmos w=WN l=L d=X g=n1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.565
  x2 = x1 + 0.02
  x3 = x2 + L + 0.46
  x4 = x3 + L + 0.93
  x5 = x4 + 0.04
  x6 = x5 + L + 0.35
  x7 = x6 + 0.06
  x8 = x7 + L + 1.005
  x9 = x8 + L + 0.025
  x10 = x9 + L + 0.79
  x11 = x10 + L + 0.62
  x12 = x11 + L + 0.655
  x13 = x12 + 0.08
  x14 = x13 + L + 0.375
  x15 = x14 + 0.005
  x16 = x15 + L + 0.36
  x17 = x16 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.425) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x4 - 0.235, x7 + L + 0.5) yspan=(nb + 0.01, nb + WN)
  nd4 = rect diff xspan=(x8 - 0.14, x9 + L + 0.255) yspan=(nb, nb + WN)
  nd5 = rect diff xspan=(x8 - 0.14, x9 + L + 0.265) yspan=(nb + 0.01 + WN4 - 0.06, nb + WN)
  nd6 = rect diff xspan=(x10 - 0.265, x17 + L + 0.29) yspan=(nb + 0.01, nb + 0.23 + 0.06)
  nd7 = rect diff xspan=(x10 - 0.255, x17 + L + 0.29) yspan=(nb + 0.01, nb + 0.01 + WN4)
  nd8 = rect diff xspan=(x10 - 0.255, x11 - 0.11) yspan=(nb + 0.01, nb + WN)
  nd9 = rect diff xspan=(x11 + L + 0.13, x13 + L + 0.175) yspan=(nb + 0.01, nb + WN)
  nd10 = rect diff xspan=(x11 + L + 0.13, x17 + L + 0.29) yspan=(nb + 0.01 + WN4, nb + WN3)
  nd11 = rect diff xspan=(x13 + L + 0.01, x17 + L + 0.29) yspan=(nb, nb + WN3)
  nd12 = rect diff xspan=(x15 + L + 0.105, x17 + L + 0.29) yspan=(nb, nb + WN2)
  pd1 = rect diff xspan=(x4 - 0.325, x7 + L + 0.47) yspan=(pt - 0.02 - WP2, pt - 0.02)
  pd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.285) yspan=(pt - WP, pt - 0.36)
  pd3 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(pt - WP, pt)
  pd4 = rect diff xspan=(x8 - 0.265, x9 + L + 0.09) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x8 - 0.265, x9 + L + 0.1) yspan=(pt - WP, pt - WP2 + 0.1)
  pd6 = rect diff xspan=(x9 + L + 0.36, x11 - 0.115) yspan=(pt - 0.36 - 0.3, pt - 0.16)
  pd7 = rect diff xspan=(x9 + L + 0.37, x12 - 0.175) yspan=(pt - WP, pt - 0.36)
  pd8 = rect diff xspan=(x9 + L + 0.37, x17 + L + 0.29) yspan=(pt - WP2, pt - 0.36)
  pd9 = rect diff xspan=(x11 + L + 0.305, x17 + L + 0.29) yspan=(pt - 0.36, pt - 0.2)
  pd10 = rect diff xspan=(x13 + L + 0.08, x15 + L + 0.075) yspan=(pt - WP2, pt)
  pd11 = rect diff xspan=(x15 + L + 0.075, x17 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7, nd8, nd9, nd10, nd11, nd12] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7, pd8, pd9, pd10, pd11] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x10 + L + 0.215, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x11, x11 + L) yspan=(0.115, pt - 0.2 - 0.03)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(nb + 0.01 + 0.09, pt - 0.02 - 0.05)
  p4 = rect poly xspan=(x3, x5 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, pt + 0.11)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.13)
  p7 = rect poly xspan=(x5, x5 + L + 0.01) yspan=(nb + WN + 0.1, pt - WP - 0.13)
  p8 = rect poly xspan=(x6 - 0.065, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, pt + 0.11)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x1, x3 - 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.2, H - 0.105)
  p15 = rect poly xspan=(x8, x10 + L) yspan=(nb + WN + 0.2, pt - WP - 0.25)
  p16 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.25)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x10, x13 + L) yspan=(pt - 0.02, H - 0.105)
  p19 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.16)
  p20 = rect poly xspan=(x12, x13 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p21 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p22 = rect poly xspan=(x14 - 0.12, x15 + L) yspan=(nb + WN + 0.06, pt - WP - 0.21)
  p23 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.06, H - 0.105)
  p24 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.205)
  p25 = rect poly xspan=(x16 - 0.145, x16 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p26 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p27 = rect poly xspan=(x17 - 0.065, x17 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p28 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.035, x3 - 0.175) yspan=(-0.085, nb + 0.23 + 0.06) net=VGND
  l2 = rect li xspan=(x8 - 0.06, x8 + L - 0.035) yspan=(-0.085, nb + WN2 - 0.01) net=VGND
  l3 = rect li xspan=(x16 + L + 0.055, x17 - 0.055) yspan=(-0.085, nb + 0.23 + 0.1) net=VGND
  l4 = rect li xspan=(x10 + L + 0.185, x11 - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.215) net=n5
  l5 = rect li xspan=(x11 - 0.225, x11 - 0.01) yspan=(nb + 0.01 + WN4 - 0.035, pt - WP - 0.215) net=n5
  l6 = rect li xspan=(x13 + L + 0.165, x14) yspan=(nb + 0.01 + WN4 + 0.065, pt - WP - 0.21) net=n5
  l7 = rect li xspan=(x13 + L + 0.165, x14 + L - 0.045) yspan=(nb + WN + 0.06, pt - WP - 0.21) net=n5
  l8 = rect li xspan=(x4 - 0.395, x5 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  l9 = rect li xspan=(x15 + L + 0.125, x16 + L + 0.035) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A
  l10 = rect li xspan=(x13 - 0.03, x13 + L - 0.01) yspan=(nb + WN + 0.11, pt - 0.02 - WP2 - 0.01) net=B
  l11 = rect li xspan=(x13 - 0.03, x15 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=B
  l12 = rect li xspan=(x3 + 0.005, x7 - 0.005) yspan=(pt - WP + 0.05, pt - WP2 + 0.06) net=n2
  l13 = rect li xspan=(x3 + L + 0.195, x3 + L + 0.365) yspan=(nb + 0.01 + WN4 - 0.07, pt - WP2 + 0.06) net=n2
  l14 = rect li xspan=(x6 - 0.12, x7 - 0.005) yspan=(nb + WN + 0.11, pt - WP2 + 0.06) net=n2
  l15 = rect li xspan=(x6 - 0.12, x6 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l16 = rect li xspan=(x15 + L + 0.055, x17 + L - 0.05) yspan=(pt - WP + 0.01, pt - WP2 + 0.06) net=n7
  l17 = rect li xspan=(x15 + L + 0.095, x16 + 0.03) yspan=(nb + 0.01 + 0.05, nb + WN3 - 0.085) net=n7
  l18 = rect li xspan=(x15 + L + 0.135, x16 + 0.03) yspan=(nb + 0.01 + 0.05, pt - WP - 0.58) net=n7
  l19 = rect li xspan=(x15 + L + 0.135, x17 + L - 0.05) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP - 0.58) net=n7
  l20 = rect li xspan=(x17 - 0.075, x17 + L - 0.05) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP2 + 0.06) net=n7
  l21 = rect li xspan=(x17 - 0.075, x17 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n7
  l22 = rect li xspan=(x8 + L - 0.03, x9 + L + 0.225) yspan=(pt - WP - 0.04, pt - WP2 + 0.07) net=n5
  l23 = rect li xspan=(x9 + L - 0.02, x9 + L + 0.225) yspan=(nb + 0.23 - 0.05, pt - WP2 + 0.07) net=n5
  l24 = rect li xspan=(x10 + L + 0.17, x11 - 0.035) yspan=(pt - WP - 0.04, pt - 0.36 - 0.08) net=n4
  l25 = rect li xspan=(x10 + L + 0.17, x11 + L + 0.19) yspan=(pt - WP - 0.04, pt - 0.02 - WP2 - 0.01) net=n4
  l26 = rect li xspan=(x11 + L + 0.02, x11 + L + 0.19) yspan=(nb + 0.01 + 0.01, pt - 0.02 - WP2 - 0.01) net=n4
  l27 = rect li xspan=(x11 + L + 0.02, x14 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n4
  l28 = rect li xspan=(x13 - 0.03, x14 - 0.085) yspan=(nb + 0.01 + 0.01, nb + 0.23) net=n4
  l29 = rect li xspan=(x4 - 0.385, x7 + L + 0.19) yspan=(pt - WP2 + 0.25, pt - 0.36 - 0.06) net=n4
  l30 = rect li xspan=(x7 + L + 0.02, x7 + L + 0.19) yspan=(pt - WP + 0.04, pt - 0.36 - 0.06) net=n4
  l31 = rect li xspan=(x7 + L + 0.02, x8 - 0.455) yspan=(pt - WP + 0.04, pt - WP2 + 0.05) net=n4
  l32 = rect li xspan=(x7 + L + 0.265, x7 + L + 0.435) yspan=(nb + 0.01 + WN4 - 0.07, pt - WP2 + 0.05) net=n4
  l33 = rect li xspan=(x7 + L + 0.265, x8 - 0.455) yspan=(pt - WP - 0.11, pt - WP2 + 0.05) net=n4
  l34 = rect li xspan=(x10 - 0.39, x10 - 0.22) yspan=(nb + 0.01 + 0.02, pt - 0.36 - 0.02) net=n7
  l35 = rect li xspan=(x10 - 0.39, x10 + 0.03) yspan=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n7
  l36 = rect li xspan=(x10 - 0.39, x10 - 0.17) yspan=(nb + 0.01 + 0.02, nb + 0.01 + WN4 - 0.07) net=n7
  l37 = rect li xspan=(x2 + L + 0.025, x2 + L + 0.225) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n1
  l38 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.225) yspan=(nb + 0.01 + WN4 + 0.03, pt - 0.36 - 0.08) net=n1
  l39 = rect li xspan=(x2 + L + 0.055, x3 + L + 0.025) yspan=(nb + 0.01 + WN4 + 0.03, nb + WN2 - 0.01) net=n1
  l40 = rect li xspan=(x2 + L + 0.055, x3 + L + 0.145) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.08) net=n1
  l41 = rect li xspan=(x3, x6 - 0.045) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n1
  l42 = rect li xspan=(x3, x3 + L + 0.025) yspan=(nb + 0.01 + 0.01, nb + WN2 - 0.01) net=n1
  l43 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.145) yspan=(pt - WP2 + 0.23, pt - 0.02 - 0.06) net=n1
  l44 = rect li xspan=(x3 + L - 0.03, x6 + L - 0.035) yspan=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n1
  l45 = rect li xspan=(x4 + L - 0.01, x6 - 0.045) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) net=n1
  l46 = rect li xspan=(x4 - 0.285, x7 + L + 0.095) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n3
  l47 = rect li xspan=(x6 + L - 0.02, x8 - 0.23) yspan=(nb + 0.01 + 0.01, nb + 0.23 - 0.04) net=n3
  l48 = rect li xspan=(x6 + L - 0.02, x7 + L + 0.095) yspan=(nb + 0.01 + 0.01, nb + WN3 - 0.01) net=n3
  l49 = rect li xspan=(x7 + L + 0.125, x8 - 0.475) yspan=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n3
  l50 = rect li xspan=(x7 + L + 0.36, x9 + L + 0.225) yspan=(pt - WP2 + 0.25, pt - 0.36 - 0.06) net=n3
  l51 = rect li xspan=(x7 + L + 0.36, x8 - 0.475) yspan=(pt - WP2 + 0.25, pt - 0.02 - 0.06) net=n3
  l52 = rect li xspan=(x8 - 0.4, x8 - 0.23) yspan=(nb + 0.01 + 0.01, pt - WP - 0.28) net=n3
  l53 = rect li xspan=(x8 - 0.285, x8 - 0.115) yspan=(nb + WN + 0.15, pt - 0.36 - 0.06) net=n3
  l54 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.225) yspan=(pt - WP2 + 0.25, pt - 0.02 - 0.02) net=n3
  l55 = rect li xspan=(x9 + L + 0.055, x15 + L + 0.065) yspan=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) net=n3
  l56 = rect li xspan=(x10 - 0.05, x10 + L - 0.025) yspan=(nb + 0.01 + WN4 + 0.055, pt - 0.02 - 0.02) net=n3
  l57 = rect li xspan=(x10 + 0.005, x10 + L + 0.225) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n3
  l58 = rect li xspan=(x10 + 0.005, x10 + L + 0.03) yspan=(nb + 0.01 + WN4 - 0.01, nb + WN + 0.005) net=n3
  l59 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(nb + 0.01 + 0.075, nb + WN3 - 0.01) net=n3
  l60 = rect li xspan=(x1 - 0.48, x1 - 0.165) yspan=(nb + 0.01 + 0.105, pt - 0.02) net=X
  l61 = rect li xspan=(x1 - 0.48, x2 + 0.01) yspan=(nb + 0.01 + 0.105, nb + WN + 0.04) net=X
  l62 = rect li xspan=(x1 - 0.48, x2 + 0.03) yspan=(pt - WP - 0.045, pt - 0.02) net=X
  l63 = rect li xspan=(x12 - 0.295, x12 - 0.125) yspan=(nb + 0.01 + WN4 - 0.07, pt - 0.36 - 0.02) net=n6
  l64 = rect li xspan=(x12 - 0.295, x17 + L + 0.355) yspan=(pt - WP2 + 0.29, pt - 0.36 - 0.02) net=n6
  l65 = rect li xspan=(x17 + 0.015, x17 + L + 0.355) yspan=(pt - WP2 + 0.23, pt - 0.36 - 0.02) net=n6
  l66 = rect li xspan=(x17 + L + 0.055, x17 + L + 0.355) yspan=(nb + 0.01 + 0.01, nb + 0.01 + WN4 - 0.08) net=n6
  l67 = rect li xspan=(x17 + L + 0.06, x17 + L + 0.185) yspan=(pt - WP2 + 0.23, pt - 0.02) net=n6
  l68 = rect li xspan=(x17 + L + 0.185, x17 + L + 0.355) yspan=(nb + 0.01 + 0.01, pt - 0.02) net=n6
  l69 = rect li xspan=(x2 + L + 0.055, x3 - 0.07) yspan=(pt - 0.2 - 0.07, H + 0.085) net=VPWR
  l70 = rect li xspan=(x8 - 0.305, x8 + 0.03) yspan=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  l71 = rect li xspan=(x16 + L - 0.03, x17 + 0.035) yspan=(pt - 0.2 - 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.2) span=(-0.085 + 0.08, nb + 0.23 + 0.06 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd4 cx=(x8 + 0.03) span=(-0.085 + 0.08, nb + WN2 - 0.01 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd3 cx=(x5 + L + 0.14) span=(nb + 0.01 + 0.01, nb + 0.23 - 0.01) margin=0.04 net=n1
  c4 = array licon in=nd9 cx=(x13 + L + 0.07) span=(nb + 0.01 + 0.01, nb + 0.23) net=n4
  c5 = array licon in=nd8 cx=(x10 - 0.14) span=(nb + 0.01 + 0.02, nb + 0.23 + 0.02) net=n7
  c6 = array licon in=nd12 cx=(x16 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.1 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd12 cx=(x17 + L + 0.14) span=(nb + 0.01 + 0.01 + 0.08, nb + 0.01 + WN4 - 0.08 - 0.08) margin=0.04 net=n6
  c8 = array licon in=nd8 cx=(x10 + L + 0.14) span=(nb + 0.01 + 0.075 + 0.08, nb + WN3 - 0.01 - 0.08) margin=0.04 net=n3
  c9 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.01 + 0.105, nb + WN + 0.04) net=X
  c10 = array licon in=nd12 cx=(x16 - 0.14) span=(nb + 0.01 + 0.05 + 0.08, pt - WP - 0.58 - 0.08) net=n7
  c11 = array licon in=nd4 cx=(x9 + L + 0.14) span=(nb + 0.23 - 0.05 + 0.08, pt - WP2 + 0.07 - 0.08) net=n5
  c12 = array licon in=nd3 cx=(x4 - 0.1) span=(nb + 0.01 + WN4 - 0.01, nb + WN3 - 0.01) net=n3
  c13 = array licon in=nd2 cx=(x3 + L + 0.28) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - WP2 + 0.06 - 0.08) margin=0.04 net=n2
  c14 = array licon in=nd3 cx=(x7 + L + 0.35) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - WP2 + 0.05 - 0.08) margin=0.04 net=n4
  c15 = array licon in=nd9 cx=(x12 - 0.21) span=(nb + 0.01 + WN4 - 0.07 + 0.08, pt - 0.36 - 0.02 - 0.08) margin=0.04 net=n6
  c16 = array licon in=pd3 cx=(x1 - 0.12) span=(pt - WP - 0.045, pt - 0.02) margin=0.04 net=X
  c17 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.05, pt - WP2 + 0.06) margin=0.04 net=n2
  c18 = array licon in=pd7 cx=(x11 - 0.275) span=(pt - WP - 0.04, pt - 0.36 - 0.08) margin=0.04 net=n4
  c19 = array licon in=pd11 cx=(x16 - 0.14) span=(pt - WP + 0.01, pt - WP2 + 0.06) margin=0.04 net=n7
  c20 = array licon in=pd4 cx=(x9 + L - 0.03) span=(pt - WP - 0.04, pt - WP2 + 0.07) net=n5
  c21 = array licon in=pd7 cx=(x10 - 0.305) span=(nb + 0.01 + 0.02 + 0.08, pt - 0.36 - 0.02 - 0.08) net=n7
  c22 = array licon in=pd11 cx=(x17 + L + 0.145) span=(pt - WP2 + 0.23, pt - 0.36 - 0.02) margin=0.04 net=n6
  c23 = array licon in=pd1 cx=(x4 - 0.14) span=(pt - WP2 + 0.25, pt - 0.36 - 0.06) margin=0.04 net=n4
  c24 = array licon in=pd8 cx=(x12 - 0.06) span=(pt - WP2 + 0.29, pt - 0.36 - 0.02) margin=0.04 net=n6
  c25 = array licon in=pd3 cx=(x2 + L + 0.225) span=(pt - 0.2 - 0.07, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) margin=0.04 net=n1
  c27 = array licon in=pd1 cx=(x7 + L + 0.33) span=(pt - 0.2 - 0.05, pt - 0.02 - 0.06) net=n3
  c28 = array licon in=pd4 cx=(x8 - 0.14) span=(pt - 0.2 - 0.05, H + 0.085) net=VPWR
  c29 = array licon in=pd10 cx=(x14 - 0.15) span=(pt - 0.2 - 0.01, pt - 0.02 - 0.02) margin=0.04 net=n3
  c30 = array licon in=pd11 cx=(x16 + L + 0.14) span=(pt - 0.2 - 0.01, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x15 + 0.015) cy=(pt - WP - 0.375)
  gc2 = contact licon cx=(x2 + L + 0.11) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 - 0.285) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 + 0.02) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x7 + 0.015) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x11 - 0.27) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x12 + L - 0.015) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x16 - 0.01) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=(x17 + L/2) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.565, x17 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x14 - 0.17, x15 + L + 0.055) yspan=(nb + WN + 0.04, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.335) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.02) cy=0
  mc3 = contact mcon cx=(x3 - 0.035) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.285) cy=0
  mc5 = contact mcon cx=(x4 - 0.185) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.095) cy=0
  mc7 = contact mcon cx=(x7 + L) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.465) cy=0
  mc9 = contact mcon cx=(x8 - 0.08) cy=0
  mc10 = contact mcon cx=(x9 + L + 0.075) cy=0
  mc11 = contact mcon cx=(x10 - 0.255) cy=0
  mc12 = contact mcon cx=(x10 + L + 0.065) cy=0
  mc13 = contact mcon cx=(x11 - 0.095) cy=0
  mc14 = contact mcon cx=(x11 + L + 0.225) cy=0
  mc15 = contact mcon cx=(x12 + 0.035) cy=0
  mc16 = contact mcon cx=(x14 - 0.105) cy=0
  mc17 = contact mcon cx=(x16 - 0.15) cy=0
  mc18 = contact mcon cx=(x17 - 0.11) cy=0
  mc19 = contact mcon cx=(x17 + L + 0.21) cy=0
  mc20 = contact mcon cx=(x10 - 0.255) cy=(nb + 0.23 + 0.045)
  mc21 = contact mcon cx=(x16 - 0.15) cy=(nb + 0.23 + 0.045)
  mc22 = contact mcon cx=(x9 + L + 0.075) cy=(nb + WN3 + 0.015)
  mc23 = contact mcon cx=(x11 - 0.095) cy=(nb + WN3 + 0.015)
  mc24 = contact mcon cx=(x14 - 0.105) cy=(nb + WN3 + 0.015)
  mc25 = contact mcon cx=(x7 + L + 0.465) cy=(pt - WP + 0.045)
  mc26 = contact mcon cx=(x11 - 0.095) cy=(pt - WP + 0.045)
  mc27 = contact mcon cx=(x1 - 0.335) cy=H
  mc28 = contact mcon cx=(x1 + L - 0.02) cy=H
  mc29 = contact mcon cx=(x3 - 0.035) cy=H
  mc30 = contact mcon cx=(x3 + L + 0.285) cy=H
  mc31 = contact mcon cx=(x4 - 0.185) cy=H
  mc32 = contact mcon cx=(x5 + L + 0.095) cy=H
  mc33 = contact mcon cx=(x7 + L) cy=H
  mc34 = contact mcon cx=(x7 + L + 0.465) cy=H
  mc35 = contact mcon cx=(x8 - 0.08) cy=H
  mc36 = contact mcon cx=(x9 + L + 0.075) cy=H
  mc37 = contact mcon cx=(x10 - 0.255) cy=H
  mc38 = contact mcon cx=(x10 + L + 0.065) cy=H
  mc39 = contact mcon cx=(x11 - 0.095) cy=H
  mc40 = contact mcon cx=(x11 + L + 0.225) cy=H
  mc41 = contact mcon cx=(x12 + 0.035) cy=H
  mc42 = contact mcon cx=(x14 - 0.105) cy=H
  mc43 = contact mcon cx=(x16 - 0.15) cy=H
  mc44 = contact mcon cx=(x17 - 0.11) cy=H
  mc45 = contact mcon cx=(x17 + L + 0.21) cy=H
  w1 = rect m1 xspan=(x9 + L + 0.39, x10 - 0.11) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n7
  w2 = rect m1 xspan=(x9 + L + 0.39, x16) yspan=(nb + 0.23 - 0.025, nb + 0.01 + WN4 - 0.085) net=n7
  w3 = rect m1 xspan=(x15 + L + 0.065, x16) yspan=(nb + 0.23 - 0.07, nb + 0.01 + WN4 - 0.04) net=n7
  w4 = rect m1 xspan=(x9 + L/2, x9 + L + 0.22) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n5
  w5 = rect m1 xspan=(x9 + L/2, x15 + 0.04) yspan=(nb + WN3 - 0.055, nb + WN + 0.035) net=n5
  w6 = rect m1 xspan=(x11 - 0.24, x11 + 0.055) yspan=(nb + 0.01 + WN4 + 0.07, nb + WN + 0.08) net=n5
  w7 = rect m1 xspan=(x13 + L + 0.125, x15 + 0.04) yspan=(nb + 0.01 + WN4 + 0.07, pt - WP - 0.52) net=n5
  w8 = rect m1 xspan=(x7 + L + 0.32, x8 - 0.395) yspan=(pt - WP - 0.07, pt - WP2) net=n4
  w9 = rect m1 xspan=(x7 + L + 0.32, x11 + 0.055) yspan=(pt - WP - 0.025, pt - 0.02 - WP2 - 0.025) net=n4
  w10 = rect m1 xspan=(x11 - 0.24, x11 + 0.055) yspan=(pt - WP - 0.07, pt - WP2) net=n4
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l9
  port B in on=l11
  port C in on=l8
  port X out on=l60
end
