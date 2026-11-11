# mux2i_2: lifted from sky130_fd_sc_hd__mux2i_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell mux2i_2 width=14 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M1 nmos w=WN l=L d=n3 g=A1 s=Y b=VNB
  device M2 nmos w=WN l=L d=Y g=A0 s=n1 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n2 s=n1 b=VNB
  device M4 pmos w=WP l=L d=Y g=A1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=Y g=A0 s=n5 b=VPB
  device M6 nmos w=WN l=L d=n1 g=A0 s=Y b=VNB
  device M7 pmos w=WP l=L d=n4 g=A1 s=Y b=VPB
  device M8 nmos w=WN l=L d=n3 g=S s=VGND b=VNB
  device M9 nmos w=WN l=L d=VGND g=S s=n3 b=VNB
  device M10 pmos w=WP l=L d=n5 g=S s=VPWR b=VPB
  device M11 pmos w=WP l=L d=n5 g=A0 s=Y b=VPB
  device M12 nmos w=WN l=L d=n2 g=S s=VGND b=VNB
  device M13 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M14 pmos w=WP l=L d=n4 g=n2 s=VPWR b=VPB
  device M15 pmos w=WP l=L d=n2 g=S s=VPWR b=VPB
  device M16 pmos w=WP l=L d=VPWR g=S s=n5 b=VPB
  device M17 pmos w=WP l=L d=VPWR g=n2 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.8
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.32
  x9 = x8 + L + 0.285
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x6 - 0.265, x9 + L + 0.46) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x6 - 0.265, x9 + L + 0.46) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.02, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4 - 0.02, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 + L + 0.25, x7 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x7 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x9 + L + 0.245) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.02) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x4 + 0.03) yspan=(-0.085, nb + WN) net=VGND
  l3 = rect li xspan=(x5 + L + 0.055, x5 + L + 0.225) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.06, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x4 + L + 0.055, x7 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=n1
  l7 = rect li xspan=(x2 + L + 0.055, x3 + 0.02) yspan=(nb + WN - 0.31, nb + WN + 0.05) net=n3
  l8 = rect li xspan=(x8 - 0.05, x9 + 0.025) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l9 = rect li xspan=(x8 - 0.05, x8 + L + 0.065) yspan=(nb + WN - 0.23, nb + WN + 0.05) net=n3
  l10 = rect li xspan=(x5 + L + 0.25, x7 + L - 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A0
  l11 = rect li xspan=(x1 + 0.035, x2 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=S
  l12 = rect li xspan=(x1 + L + 0.04, x2 - 0.04) yspan=(nb + WN - 0.16, pt - WP - 0.16) net=S
  l13 = rect li xspan=(x9 - 0.015, x9 + L + 0.17) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A1
  l14 = rect li xspan=(x2 + L - 0.03, x4 + L - 0.07) yspan=(pt - WP + 0.35, pt - WP + 0.52) net=n5
  l15 = rect li xspan=(x4 - 0.095, x7 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n5
  l16 = rect li xspan=(x4 - 0.095, x4 + L - 0.07) yspan=(pt - WP + 0.01, pt - WP + 0.52) net=n5
  l17 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.23) net=n5
  l18 = rect li xspan=(x6 - 0.305, x9 + L + 0.51) yspan=(nb + 0.06, nb + 0.23) net=Y
  l19 = rect li xspan=(x6 - 0.305, x9 + L + 0.51) yspan=(pt - 0.23, pt - 0.06) net=Y
  l20 = rect li xspan=(x9 + L + 0.285, x9 + L + 0.51) yspan=(pt - WP + 0.3, pt - 0.06) net=Y
  l21 = rect li xspan=(x9 + L + 0.34, x9 + L + 0.51) yspan=(nb + 0.06, pt - 0.06) net=Y
  l22 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.11, pt - 0.02) net=n2
  l23 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.11, nb + WN - 0.21) net=n2
  l24 = rect li xspan=(x1 - 0.315, x3 + L + 0.015) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l25 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.65, pt - 0.02) net=n2
  l26 = rect li xspan=(x3 - 0.015, x5 - 0.095) yspan=(nb + WN + 0.27, pt - WP - 0.16) net=n2
  l27 = rect li xspan=(x3 - 0.015, x3 + L + 0.015) yspan=(nb + WN + 0.27, pt - WP + 0.18) net=n2
  l28 = rect li xspan=(x4, x5 - 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n2
  l29 = rect li xspan=(x4 + L + 0.055, x5 + 0.005) yspan=(pt - 0.35, pt - 0.02) net=n4
  l30 = rect li xspan=(x4 + L + 0.11, x6 - 0.135) yspan=(pt - WP + 0.35, pt - WP + 0.52) net=n4
  l31 = rect li xspan=(x4 + L + 0.11, x5 + 0.005) yspan=(pt - WP + 0.35, pt - 0.02) net=n4
  l32 = rect li xspan=(x6 - 0.305, x9 + 0.03) yspan=(pt - WP + 0.52, pt - 0.4) net=n4
  l33 = rect li xspan=(x6 - 0.135, x9 + 0.03) yspan=(pt - WP + 0.43, pt - 0.4) net=n4
  l34 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l35 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l36 = rect li xspan=(x5 + L + 0.055, x5 + L + 0.305) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x6 - 0.14) span=(nb + 0.06, nb + 0.23) net=Y
  c5 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=Y
  c6 = array licon in=nd2 cx=(x9 + L + 0.335) span=(nb + 0.06, nb + 0.23) net=Y
  c7 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.06 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c8 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.11 + 0.08, nb + WN - 0.21 - 0.08) net=n2
  c9 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + WN - 0.31 + 0.08, nb + WN + 0.05 - 0.08) margin=0.04 net=n3
  c10 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=n1
  c11 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + WN - 0.23, nb + WN - 0.06) margin=0.04 net=n3
  c12 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.01, pt - WP + 0.23) margin=0.04 net=n5
  c13 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.35, pt - WP + 0.52) margin=0.04 net=n5
  c14 = array licon in=pd2 cx=(x9 - 0.14) span=(pt - WP + 0.43, pt - 0.4) margin=0.04 net=n4
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.65 + 0.08, pt - 0.02 - 0.08) net=n2
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c17 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c19 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd2 cx=(x6 - 0.14) span=(pt - 0.23, pt - 0.06) net=Y
  c21 = array licon in=pd2 cx=(x7 + L + 0.16) span=(pt - 0.23, pt - 0.06) margin=0.04 net=Y
  c22 = array licon in=pd2 cx=(x9 + L + 0.145) span=(pt - 0.23, pt - 0.06) margin=0.04 net=Y
  gc1 = contact licon cx=(x1 + L - 0.03) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 - 0.385) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 - 0.045) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.125) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.085) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.595) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.31) cy=0
  mc7 = contact mcon cx=(x6 - 0.03) cy=0
  mc8 = contact mcon cx=(x7 + 0.015) cy=0
  mc9 = contact mcon cx=(x8 + 0.015) cy=0
  mc10 = contact mcon cx=(x9 + 0.05) cy=0
  mc11 = contact mcon cx=(x9 + L + 0.365) cy=0
  mc12 = contact mcon cx=(x3 - 0.085) cy=(nb + WN - 0.035)
  mc13 = contact mcon cx=(x8 + 0.04) cy=(nb + WN - 0.035)
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x2 - 0.13) cy=H
  mc16 = contact mcon cx=(x3 - 0.09) cy=H
  mc17 = contact mcon cx=(x4 - 0.05) cy=H
  mc18 = contact mcon cx=(x5 - 0.01) cy=H
  mc19 = contact mcon cx=(x5 + L + 0.31) cy=H
  mc20 = contact mcon cx=(x6 - 0.03) cy=H
  mc21 = contact mcon cx=(x7 + 0.015) cy=H
  mc22 = contact mcon cx=(x8 + 0.015) cy=H
  mc23 = contact mcon cx=(x9 + 0.05) cy=H
  mc24 = contact mcon cx=(x9 + L + 0.365) cy=H
  w1 = rect m1 xspan=(x2 + L + 0.05, x3 + 0.065) yspan=(nb + 0.5, nb + WN + 0.08) net=n3
  w2 = rect m1 xspan=(x2 + L + 0.05, x8 + L + 0.04) yspan=(nb + 0.545, nb + WN + 0.035) net=n3
  w3 = rect m1 xspan=(x8 - 0.11, x8 + L + 0.04) yspan=(nb + 0.5, nb + WN + 0.08) net=n3
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A0 in on=l10
  port A1 in on=l13
  port S in on=l11
  port Y out on=l20
end
