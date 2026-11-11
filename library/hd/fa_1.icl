# fa_1: lifted from sky130_fd_sc_hd__fa_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell fa_1 width=20 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=A s=n1 b=VNB
  device M1 nmos w=WN2 l=L d=VGND g=B s=n2 b=VNB
  device M2 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB
  device M3 pmos w=WP2 l=L d=n4 g=B s=n5 b=VPB
  device M4 pmos w=WP2 l=L d=n6 g=A s=VPWR b=VPB
  device M5 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M6 pmos w=WP2 l=L d=n5 g=CIN s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n7 g=CIN s=VPWR b=VPB
  device M8 pmos w=WP2 l=L d=n8 g=CIN s=n9 b=VPB
  device M9 pmos w=WP2 l=L d=VPWR g=B s=n6 b=VPB
  device M10 pmos w=WP2 l=L d=n9 g=B s=n3 b=VPB
  device M11 nmos w=WN2 l=L d=VGND g=A s=n10 b=VNB
  device M12 nmos w=WN2 l=L d=n2 g=A s=VGND b=VNB
  device M13 nmos w=WN2 l=L d=VGND g=B s=n10 b=VNB
  device M14 pmos w=WP l=L d=VPWR g=n8 s=SUM b=VPB
  device M15 nmos w=WN2 l=L d=n10 g=CIN s=VGND b=VNB
  device M16 nmos w=WN2 l=L d=n10 g=n5 s=n8 b=VNB
  device M17 nmos w=WN2 l=L d=n5 g=CIN s=n2 b=VNB
  device M18 nmos w=WN2 l=L d=n11 g=B s=n12 b=VNB
  device M19 pmos w=WP2 l=L d=n7 g=n5 s=n8 b=VPB
  device M20 nmos w=WN l=L d=VGND g=n8 s=SUM b=VNB
  device M21 pmos w=WP2 l=L d=VPWR g=B s=n7 b=VPB
  device M22 nmos w=WN2 l=L d=n12 g=A s=VGND b=VNB
  device M23 pmos w=WP2 l=L d=VPWR g=A s=n4 b=VPB
  device M24 nmos w=WN l=L d=COUT g=n5 s=VGND b=VNB
  device M25 pmos w=WP l=L d=COUT g=n5 s=VPWR b=VPB
  device M26 nmos w=WN2 l=L d=n1 g=B s=n5 b=VNB
  device M27 nmos w=WN2 l=L d=n8 g=CIN s=n11 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.355
  x3 = x2 + L + 0.31
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.8
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.305
  x11 = x10 + L + 0.34
  x12 = x11 + L + 0.22
  x13 = x12 + L + 0.34
  x14 = x13 + L + 0.355
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x2 - 0.09) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x7 - 0.265, x14 + L + 0.265) yspan=(nb, nb + WN2)
  nd4 = rect diff xspan=(x13 + L + 0.09, x14 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 - 0.09) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x7 - 0.265, x14 + L + 0.265) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x13 + L + 0.09, x14 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.02, x1 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.035, x2 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.095, x3 + L + 0.035) yspan=(pt - WP + 0.065, pt - WP2 - 0.185)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.14, pt - WP - 0.13)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN + 0.145, pt - WP - 0.125)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, nb + WN - 0.005)
  p12 = rect poly xspan=(x6, x7 + L) yspan=(nb + WN2 + 0.075, nb + WN - 0.005)
  p13 = rect poly xspan=(x6, x7 + L) yspan=(pt - WP + 0.355, pt - WP2 - 0.075)
  p14 = rect poly xspan=(x6, x6 + L) yspan=(pt - WP + 0.355, H - 0.105)
  p15 = rect poly xspan=(x7 - 0.23, x7 + L - 0.055) yspan=(pt - WP - 0.05, pt - WP2 - 0.075)
  p16 = rect poly xspan=(x7 - 0.06, x7 + L - 0.055) yspan=(nb + WN2 + 0.075, pt - WP2 - 0.075)
  p17 = rect poly xspan=(x7, x7 + L - 0.055) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x7, x7 + L) yspan=(0.105, nb + WN + 0.07)
  p19 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP + 0.355, H - 0.105)
  p20 = rect poly xspan=(x8 - 0.065, x8 + L + 0.065) yspan=(pt - WP - 0.05, pt - WP2 - 0.3)
  p21 = rect poly xspan=(x8, x8 + L) yspan=(0.105, nb + WN - 0.005)
  p22 = rect poly xspan=(x8, x8 + L) yspan=(pt - WP - 0.05, H - 0.105)
  p23 = rect poly xspan=(x8 + 0.005, x8 + L + 0.01) yspan=(nb + WN2 + 0.075, pt - WP2 - 0.3)
  p24 = rect poly xspan=(x9 - 0.06, x9 + L + 0.07) yspan=(nb + WN - 0.01, pt - WP - 0.28)
  p25 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p26 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p27 = rect poly xspan=(x10, x10 + L + 0.125) yspan=(nb + WN - 0.01, pt - WP - 0.28)
  p28 = rect poly xspan=(x11 - 0.125, x11 + L) yspan=(pt - WP + 0.03, pt - WP2 - 0.22)
  p29 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p30 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p31 = rect poly xspan=(x12, x12 + L + 0.125) yspan=(pt - WP + 0.03, pt - WP2 - 0.22)
  p32 = rect poly xspan=(x13 - 0.125, x13 + L) yspan=(nb + WN + 0.07, pt - WP - 0.2)
  p33 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p34 = rect poly xspan=(x14 - 0.125, x14 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p35 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.05) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x7 - 0.305, x7 + 0.03) yspan=(-0.085, nb + WN2 - 0.165) net=VGND
  l4 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x13 + L - 0.03, x14 - 0.05) yspan=(-0.085, nb + 0.21) net=VGND
  l6 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.02, nb + WN - 0.1) net=n2
  l7 = rect li xspan=(x4 + L + 0.055, x6 + L + 0.225) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n2
  l8 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.1) net=n2
  l9 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(nb + 0.02, nb + WN - 0.1) net=n10
  l10 = rect li xspan=(x7 + L + 0.055, x10 - 0.08) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n10
  l11 = rect li xspan=(x9 + L + 0.055, x10 - 0.08) yspan=(nb + 0.02, nb + WN - 0.1) net=n10
  l12 = rect li xspan=(x10 - 0.035, x11 + L + 0.01) yspan=(nb + WN + 0.07, pt - WP - 0.36) net=n5
  l13 = rect li xspan=(x10 + L - 0.01, x11 + L + 0.01) yspan=(nb + WN2 + 0.11, pt - WP - 0.36) net=n5
  l14 = rect li xspan=(x9 - 0.135, x9 + L + 0.1) yspan=(nb + WN + 0.07, pt - WP - 0.21) net=A
  l15 = rect li xspan=(x12 + L + 0.075, x13 + L + 0.035) yspan=(nb + WN + 0.15, pt - WP - 0.21) net=A
  l16 = rect li xspan=(x2 + 0.02, x3 - 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.21) net=A
  l17 = rect li xspan=(x2 + 0.02, x2 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l18 = rect li xspan=(x5 + 0.05, x6 + 0.02) yspan=(nb + WN + 0.145, pt - WP - 0.125) net=A
  l19 = rect li xspan=(x7 - 0.345, x7 + 0.02) yspan=(pt - WP - 0.05, pt - WP + 0.28) net=B
  l20 = rect li xspan=(x12 - 0.035, x13 - 0.095) yspan=(pt - WP - 0.04, pt - WP2 - 0.3) net=B
  l21 = rect li xspan=(x3 - 0.045, x4 - 0.065) yspan=(pt - WP - 0.04, pt - WP2 - 0.185) net=B
  l22 = rect li xspan=(x4 - 0.095, x4 + L + 0.135) yspan=(nb + WN + 0.22, pt - WP - 0.21) net=CIN
  l23 = rect li xspan=(x4 + L - 0.04, x4 + L + 0.135) yspan=(nb + WN + 0.22, pt - WP + 0.28) net=CIN
  l24 = rect li xspan=(x4 + L - 0.04, x6 + L + 0.215) yspan=(pt - WP + 0.11, pt - WP + 0.28) net=CIN
  l25 = rect li xspan=(x6 + L + 0.045, x8 - 0.01) yspan=(nb + WN + 0.08, pt - WP - 0.235) net=CIN
  l26 = rect li xspan=(x6 + L + 0.045, x6 + L + 0.215) yspan=(nb + WN + 0.08, pt - WP + 0.28) net=CIN
  l27 = rect li xspan=(x7 + L + 0.1, x8 - 0.01) yspan=(nb + WN + 0.08, pt - WP2 - 0.38) net=CIN
  l28 = rect li xspan=(x7 + L + 0.1, x11 + L - 0.05) yspan=(pt - WP + 0.03, pt - WP2 - 0.38) net=CIN
  l29 = rect li xspan=(x11 - 0.155, x11 + L - 0.05) yspan=(pt - WP + 0.03, pt - WP2 - 0.11) net=CIN
  l30 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=COUT
  l31 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.055) net=COUT
  l32 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=COUT
  l33 = rect li xspan=(x1 + 0.035, x1 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n5
  l34 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.145) yspan=(nb + WN2 - 0.02, pt - WP + 0.46) net=n5
  l35 = rect li xspan=(x1 + L - 0.03, x4 - 0.055) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n5
  l36 = rect li xspan=(x1 + L - 0.03, x2 + L + 0.07) yspan=(pt - WP + 0.14, pt - WP + 0.46) net=n5
  l37 = rect li xspan=(x2 + 0.045, x2 + L + 0.07) yspan=(pt - WP + 0.14, pt - 0.02) net=n5
  l38 = rect li xspan=(x2 + 0.045, x4 - 0.055) yspan=(pt - WP2, pt - 0.02) net=n5
  l39 = rect li xspan=(x2 + L + 0.075, x4 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=n5
  l40 = rect li xspan=(x3 + L - 0.02, x4 - 0.055) yspan=(nb + 0.02, nb + WN + 0.05) net=n5
  l41 = rect li xspan=(x4 + L + 0.055, x6 + L + 0.29) yspan=(pt - WP2 - 0.13, pt - WP2 + 0.04) net=n6
  l42 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP2 - 0.13, pt - 0.02) net=n6
  l43 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.29) yspan=(pt - WP2 - 0.13, pt - 0.02) net=n6
  l44 = rect li xspan=(x7 + L + 0.055, x10 - 0.08) yspan=(pt - WP2 - 0.13, pt - WP2 + 0.04) net=n7
  l45 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - WP2 - 0.13, pt - 0.02) net=n7
  l46 = rect li xspan=(x9 + L + 0.055, x10 - 0.08) yspan=(pt - WP2 - 0.13, pt - 0.02) net=n7
  l47 = rect li xspan=(x10 + L + 0.115, x13 - 0.055) yspan=(nb + 0.02, nb + 0.27) net=n8
  l48 = rect li xspan=(x10 + L + 0.115, x11 - 0.055) yspan=(nb + 0.02, nb + WN2 - 0.06) net=n8
  l49 = rect li xspan=(x10 + L + 0.115, x13 + 0.025) yspan=(pt - 0.36, pt - 0.02) net=n8
  l50 = rect li xspan=(x12 + L + 0.115, x13 - 0.055) yspan=(nb + 0.02, nb + WN - 0.1) net=n8
  l51 = rect li xspan=(x12 + L + 0.115, x14 + 0.025) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n8
  l52 = rect li xspan=(x13 - 0.15, x14 + 0.025) yspan=(pt - WP2 - 0.13, pt - WP2 + 0.04) net=n8
  l53 = rect li xspan=(x13 - 0.15, x13 + 0.025) yspan=(pt - WP2 - 0.13, pt - 0.02) net=n8
  l54 = rect li xspan=(x14 - 0.15, x14 + 0.025) yspan=(nb + WN2 - 0.04, pt - WP2 + 0.04) net=n8
  l55 = rect li xspan=(x14 - 0.15, x14 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n8
  l56 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.455) yspan=(nb + 0.02, nb + WN - 0.075) net=SUM
  l57 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.455) yspan=(pt - WP, pt - 0.02) net=SUM
  l58 = rect li xspan=(x14 + L + 0.125, x14 + L + 0.455) yspan=(nb + 0.02, pt - 0.02) net=SUM
  l59 = rect li xspan=(x1 + L - 0.03, x2 - 0.13) yspan=(pt - WP2 + 0.085, H + 0.085) net=VPWR
  l60 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l61 = rect li xspan=(x7 - 0.305, x7 + 0.03) yspan=(pt - WP2 + 0.19, H + 0.085) net=VPWR
  l62 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l63 = rect li xspan=(x13 + L + 0.05, x14 + 0.03) yspan=(pt - WP2 + 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x8 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd3 cx=(x13 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c5 = array licon in=nd3 cx=(x7 - 0.14) span=(-0.085, nb + WN2 - 0.165) net=VGND
  c6 = array licon in=nd3 cx=(x11 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.06 - 0.08) margin=0.04 net=n8
  c7 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.05 - 0.08) margin=0.04 net=n5
  c8 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n2
  c9 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) net=n2
  c10 = array licon in=nd3 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n10
  c11 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n10
  c12 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.055 - 0.08) net=COUT
  c13 = array licon in=nd4 cx=(x14 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.075 - 0.08) net=SUM
  c14 = array licon in=pd4 cx=(x14 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=SUM
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=COUT
  c16 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP2 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n5
  c17 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP2 - 0.13 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n6
  c18 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP2 - 0.13 + 0.08, pt - 0.02 - 0.08) net=n6
  c19 = array licon in=pd3 cx=(x7 + L + 0.14) span=(pt - WP2 - 0.13 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n7
  c20 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP2 - 0.13 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n7
  c21 = array licon in=pd3 cx=(x11 - 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n8
  c22 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.085 + 0.08, H + 0.085 - 0.08) net=VPWR
  c23 = array licon in=pd3 cx=(x7 - 0.14) span=(pt - WP2 + 0.19, H + 0.085) net=VPWR
  c24 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd4 cx=(x14 - 0.14) span=(pt - WP2 + 0.21, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x9 + L - 0.07) cy=(pt - WP - 0.445)
  gc2 = contact licon cx=(x10 + L - 0.015) cy=(pt - WP - 0.445)
  gc3 = contact licon cx=(x13 + 0.015) cy=(pt - WP - 0.365)
  gc4 = contact licon cx=(x1 + L - 0.03) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x2 + L - 0.045) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x14 + 0.015) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.305)
  gc8 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.31)
  gc9 = contact licon cx=(x7 - 0.095) cy=(pt - WP + 0.115)
  gc10 = contact licon cx=(x8 + L/2) cy=(pt - WP + 0.115)
  gc11 = contact licon cx=(x11 + 0.015) cy=(pt - WP + 0.195)
  gc12 = contact licon cx=(x12 + L - 0.015) cy=(pt - WP + 0.195)
  gc13 = contact licon cx=(x3 + 0.045) cy=(pt - WP + 0.23)
  np1 = rect npc xspan=(x1 - 0.4, x14 + L + 0.575) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x2 - 0.085, x13 - 0.165) yspan=(nb + WN - 0.03, pt - WP2 - 0.28)
  np3 = rect npc xspan=(x2 - 0.085, x13 + L + 0.055) yspan=(nb + WN + 0.05, pt - WP - 0.14)
  np4 = rect npc xspan=(x3 - 0.145, x3 + L + 0.085) yspan=(nb + WN - 0.03, pt - WP2 - 0.165)
  np5 = rect npc xspan=(x9 + L + 0.14, x13 - 0.165) yspan=(nb + WN - 0.03, pt - WP2 - 0.2)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.115) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.125) cy=0
  mc5 = contact mcon cx=(x5 - 0.115) cy=0
  mc6 = contact mcon cx=(x6 - 0.075) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.245) cy=0
  mc8 = contact mcon cx=(x7 - 0.095) cy=0
  mc9 = contact mcon cx=(x8 - 0.055) cy=0
  mc10 = contact mcon cx=(x9 - 0.015) cy=0
  mc11 = contact mcon cx=(x10 + 0.005) cy=0
  mc12 = contact mcon cx=(x11 - 0.02) cy=0
  mc13 = contact mcon cx=(x12 + L - 0.065) cy=0
  mc14 = contact mcon cx=(x13 + 0.065) cy=0
  mc15 = contact mcon cx=(x14 + 0.03) cy=0
  mc16 = contact mcon cx=(x14 + L + 0.345) cy=0
  mc17 = contact mcon cx=(x3 + L + 0.13) cy=(nb + WN - 0.035)
  mc18 = contact mcon cx=(x11 + 0.01) cy=(nb + WN - 0.035)
  mc19 = contact mcon cx=(x2 + L + 0.12) cy=(nb + WN + 0.305)
  mc20 = contact mcon cx=(x6 - 0.07) cy=(nb + WN + 0.305)
  mc21 = contact mcon cx=(x9 + 0.015) cy=(nb + WN + 0.305)
  mc22 = contact mcon cx=(x13 + L - 0.06) cy=(nb + WN + 0.305)
  mc23 = contact mcon cx=(x3 + L + 0.13) cy=(pt - WP + 0.045)
  mc24 = contact mcon cx=(x7 - 0.07) cy=(pt - WP + 0.045)
  mc25 = contact mcon cx=(x12 + L - 0.04) cy=(pt - WP2 - 0.535)
  mc26 = contact mcon cx=(x1 - 0.17) cy=H
  mc27 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc28 = contact mcon cx=(x2 + L + 0.115) cy=H
  mc29 = contact mcon cx=(x3 + L + 0.125) cy=H
  mc30 = contact mcon cx=(x5 - 0.115) cy=H
  mc31 = contact mcon cx=(x6 - 0.075) cy=H
  mc32 = contact mcon cx=(x6 + L + 0.245) cy=H
  mc33 = contact mcon cx=(x7 - 0.095) cy=H
  mc34 = contact mcon cx=(x8 - 0.055) cy=H
  mc35 = contact mcon cx=(x9 - 0.015) cy=H
  mc36 = contact mcon cx=(x10 + 0.005) cy=H
  mc37 = contact mcon cx=(x11 - 0.02) cy=H
  mc38 = contact mcon cx=(x12 + L - 0.065) cy=H
  mc39 = contact mcon cx=(x13 + 0.065) cy=H
  mc40 = contact mcon cx=(x14 + 0.03) cy=H
  mc41 = contact mcon cx=(x14 + L + 0.345) cy=H
  w1 = rect m1 xspan=(x3 + L - 0.02, x4) yspan=(nb + WN2 + 0.08, nb + WN + 0.08) net=n5
  w2 = rect m1 xspan=(x3 + L - 0.02, x11 + L + 0.01) yspan=(nb + WN2 + 0.125, nb + WN + 0.035) net=n5
  w3 = rect m1 xspan=(x11 - 0.14, x11 + L + 0.01) yspan=(nb + WN2 + 0.08, nb + WN + 0.08) net=n5
  w4 = rect m1 xspan=(x2 + L - 0.03, x3 - 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=A
  w5 = rect m1 xspan=(x2 + L - 0.03, x13 + L + 0.09) yspan=(nb + WN + 0.235, nb + WN + 0.375) net=A
  w6 = rect m1 xspan=(x5 + L + 0.065, x6 + L - 0.07) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=A
  w7 = rect m1 xspan=(x9 - 0.135, x9 + L + 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=A
  w8 = rect m1 xspan=(x13 - 0.06, x13 + L + 0.09) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=A
  w9 = rect m1 xspan=(x3 + L - 0.02, x4) yspan=(pt - WP - 0.07, pt - WP2 - 0.42) net=B
  w10 = rect m1 xspan=(x3 + L - 0.02, x12 + L + 0.11) yspan=(pt - WP - 0.025, pt - WP2 - 0.465) net=B
  w11 = rect m1 xspan=(x7 - 0.215, x7 + L - 0.07) yspan=(pt - WP - 0.07, pt - WP2 - 0.42) net=B
  w12 = rect m1 xspan=(x12 - 0.04, x12 + L + 0.11) yspan=(pt - WP - 0.07, pt - WP2 - 0.42) net=B
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l16
  port B in on=l21
  port CIN in on=l29
  port COUT out on=l30
  port SUM out on=l56
end
