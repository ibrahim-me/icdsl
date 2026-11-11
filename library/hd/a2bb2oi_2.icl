# a2bb2oi_2: lifted from sky130_fd_sc_hd__a2bb2oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2bb2oi_2 width=15 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B2 s=Y b=VNB
  device M1 pmos w=WP l=L d=VPWR g=B2 s=n2 b=VPB
  device M2 nmos w=WN l=L d=n3 g=A2_N s=VGND b=VNB
  device M3 nmos w=WN l=L d=Y g=n3 s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=A2_N s=n3 b=VNB
  device M5 nmos w=WN l=L d=VGND g=A1_N s=n3 b=VNB
  device M6 pmos w=WP l=L d=n2 g=B1 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=n3 s=Y b=VNB
  device M8 pmos w=WP l=L d=n4 g=A1_N s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n3 g=A1_N s=VGND b=VNB
  device M10 nmos w=WN l=L d=n1 g=B1 s=VGND b=VNB
  device M11 pmos w=WP l=L d=VPWR g=B1 s=n2 b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A1_N s=n4 b=VPB
  device M13 pmos w=WP l=L d=Y g=n3 s=n2 b=VPB
  device M14 pmos w=WP l=L d=n3 g=A2_N s=n4 b=VPB
  device M15 nmos w=WN l=L d=Y g=B2 s=n1 b=VNB
  device M16 pmos w=WP l=L d=n2 g=B2 s=VPWR b=VPB
  device M17 nmos w=WN l=L d=VGND g=B1 s=n1 b=VNB
  device M18 pmos w=WP l=L d=n2 g=n3 s=Y b=VPB
  device M19 pmos w=WP l=L d=n4 g=A2_N s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.535
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.8
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x7 - 0.265, x10 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x6 + L + 0.305) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + 0.24) net=n1
  l2 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(nb + 0.02, nb + WN + 0.01) net=n1
  l3 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l4 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l7 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l8 = rect li xspan=(x2 - 0.015, x3 + L - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l9 = rect li xspan=(x7 - 0.265, x8 + L + 0.07) yspan=(pt - WP - 0.41, pt - WP - 0.21) net=A1_N
  l10 = rect li xspan=(x9 + 0.045, x10 + L + 0.46) yspan=(pt - WP - 0.41, pt - WP - 0.21) net=A2_N
  l11 = rect li xspan=(x1 - 0.45, x1 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l12 = rect li xspan=(x1 - 0.45, x4 + L + 0.095) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B1
  l13 = rect li xspan=(x4 - 0.095, x4 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l14 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x2 + L - 0.03, x6 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l16 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l17 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(nb + 0.02, pt - WP + 0.64) net=Y
  l18 = rect li xspan=(x5 + L + 0.015, x6 + 0.03) yspan=(nb + 0.02, pt - WP + 0.175) net=Y
  l19 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.345) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=n3
  l20 = rect li xspan=(x6 + L + 0.175, x10 + 0.03) yspan=(nb + WN - 0.16, pt - WP - 0.58) net=n3
  l21 = rect li xspan=(x6 + L + 0.175, x6 + L + 0.345) yspan=(nb + WN - 0.16, pt - WP + 0.13) net=n3
  l22 = rect li xspan=(x6 + L + 0.175, x10 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n3
  l23 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, pt - WP - 0.58) net=n3
  l24 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.02, pt - WP - 0.58) net=n3
  l25 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=n3
  l26 = rect li xspan=(x1 - 0.265, x5 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n2
  l27 = rect li xspan=(x1 - 0.265, x1 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l28 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l29 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l30 = rect li xspan=(x4 + L + 0.015, x6 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n2
  l31 = rect li xspan=(x6 + L + 0.015, x6 + L + 0.265) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l32 = rect li xspan=(x7 - 0.265, x9 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.48) net=n4
  l33 = rect li xspan=(x7 - 0.265, x7 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n4
  l34 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n4
  l35 = rect li xspan=(x8 + L + 0.015, x10 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n4
  l36 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.265) yspan=(pt - WP - 0.03, pt - 0.02) net=n4
  l37 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l38 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l39 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.01 - 0.08) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + 0.24) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c6 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x7 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, pt - WP - 0.58) margin=0.04 net=n3
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02, pt - WP - 0.58) margin=0.04 net=n3
  c11 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n3
  c15 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n2
  c17 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c19 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c20 = array licon in=pd2 cx=(x7 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n4
  c21 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c22 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L/2) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x6 + L + 0.14) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.13) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x10 - 0.13) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.535, x10 + L + 0.545) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.305) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.015) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.055) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.095) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.135) cy=0
  mc6 = contact mcon cx=(x6 - 0.105) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.215) cy=0
  mc8 = contact mcon cx=(x7 - 0.125) cy=0
  mc9 = contact mcon cx=(x8 - 0.085) cy=0
  mc10 = contact mcon cx=(x9 - 0.045) cy=0
  mc11 = contact mcon cx=x10 cy=0
  mc12 = contact mcon cx=(x10 + L + 0.315) cy=0
  mc13 = contact mcon cx=(x1 - 0.305) cy=H
  mc14 = contact mcon cx=(x1 + L + 0.015) cy=H
  mc15 = contact mcon cx=(x2 + L + 0.055) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.095) cy=H
  mc17 = contact mcon cx=(x4 + L + 0.135) cy=H
  mc18 = contact mcon cx=(x6 - 0.105) cy=H
  mc19 = contact mcon cx=(x6 + L + 0.215) cy=H
  mc20 = contact mcon cx=(x7 - 0.125) cy=H
  mc21 = contact mcon cx=(x8 - 0.085) cy=H
  mc22 = contact mcon cx=(x9 - 0.045) cy=H
  mc23 = contact mcon cx=x10 cy=H
  mc24 = contact mcon cx=(x10 + L + 0.315) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l9
  port A2_N in on=l10
  port B1 in on=l11
  port B2 in on=l8
  port Y out on=l17
end
