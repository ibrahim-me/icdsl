# a21bo_4: lifted from sky130_fd_sc_hd__a21bo_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a21bo_4 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A1 s=n2 b=VNB
  device M1 nmos w=WN l=L d=n2 g=A1 s=n3 b=VNB
  device M2 pmos w=WP l=L d=n2 g=n4 s=n5 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A1 s=n5 b=VPB
  device M4 pmos w=WP l=L d=n4 g=B1_N s=VPWR b=VPB
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M6 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n5 g=n4 s=n2 b=VPB
  device M8 pmos w=WP l=L d=n5 g=A2 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M10 pmos w=WP l=L d=VPWR g=A2 s=n5 b=VPB
  device M11 nmos w=WN l=L d=n2 g=n4 s=VGND b=VNB
  device M12 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M13 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M14 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M15 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M16 nmos w=WN l=L d=VGND g=n4 s=n2 b=VNB
  device M17 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M18 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M19 nmos w=WN l=L d=n4 g=B1_N s=VGND b=VNB
  device M20 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M21 nmos w=WN l=L d=VGND g=n2 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.6
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.82
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + 0.04
  x10 = x9 + L + 0.24
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.39, x12 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.285) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x6 - 0.265, x12 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.07, x1 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x5 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6 - 0.195, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8 - 0.065, x9 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x12, x12 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.035, x2 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x5 + L + 0.055, x6 + 0.01) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x7 + L + 0.015, x9 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x12 + L + 0.025, x12 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND
  l6 = rect li xspan=(x10 + 0.055, x11) yspan=(nb + WN + 0.125, pt - WP - 0.125) net=A1
  l7 = rect li xspan=(x1 - 0.1, x1 + L + 0.09) yspan=(nb + WN + 0.125, pt - WP + 0.14) net=B1_N
  l8 = rect li xspan=(x2 - 0.03, x2 + L + 0.065) yspan=(nb + 0.38, pt - WP + 0.28) net=X
  l9 = rect li xspan=(x2 - 0.03, x5 + 0.025) yspan=(nb + 0.38, nb + WN - 0.1) net=X
  l10 = rect li xspan=(x2 - 0.03, x5 + L - 0.055) yspan=(pt - WP + 0.11, pt - WP + 0.28) net=X
  l11 = rect li xspan=(x8 - 0.095, x9 + L + 0.12) yspan=(nb + WN + 0.125, pt - WP - 0.21) net=A2
  l12 = rect li xspan=(x8 + L - 0.02, x9 + L + 0.12) yspan=(nb + WN + 0.125, pt - WP + 0.28) net=A2
  l13 = rect li xspan=(x8 + L - 0.02, x12 + 0.015) yspan=(pt - WP + 0.11, pt - WP + 0.28) net=A2
  l14 = rect li xspan=(x11 + L + 0.12, x12 + L + 0.18) yspan=(nb + WN + 0.17, pt - WP - 0.195) net=A2
  l15 = rect li xspan=(x11 + L + 0.12, x12 + 0.015) yspan=(nb + WN + 0.17, pt - WP + 0.28) net=A2
  l16 = rect li xspan=(x3 - 0.055, x5 + L + 0.07) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l17 = rect li xspan=(x3 - 0.055, x5 + L + 0.35) yspan=(nb + WN + 0.11, nb + WN + 0.3) net=n2
  l18 = rect li xspan=(x5 + L + 0.18, x7 - 0.055) yspan=(nb + 0.38, nb + WN - 0.1) net=n2
  l19 = rect li xspan=(x5 + L + 0.18, x5 + L + 0.35) yspan=(nb + 0.38, nb + WN + 0.3) net=n2
  l20 = rect li xspan=(x5 + L + 0.18, x6 - 0.27) yspan=(nb + 0.38, nb + WN - 0.085) net=n2
  l21 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.02, pt - WP + 0.32) net=n2
  l22 = rect li xspan=(x6 + L + 0.055, x11 + 0.01) yspan=(nb + 0.435, nb + WN - 0.045) net=n2
  l23 = rect li xspan=(x10 + L, x11 + 0.01) yspan=(nb + 0.17, nb + WN - 0.045) net=n2
  l24 = rect li xspan=(x6 - 0.225, x6 - 0.055) yspan=(pt - WP + 0.21, pt - 0.105) net=n5
  l25 = rect li xspan=(x6 - 0.225, x8 - 0.055) yspan=(pt - WP + 0.725, pt - 0.105) net=n5
  l26 = rect li xspan=(x7 + L + 0.045, x8 - 0.055) yspan=(pt - WP - 0.04, pt - 0.105) net=n5
  l27 = rect li xspan=(x7 + L + 0.045, x12 + L + 0.305) yspan=(pt - WP + 0.45, pt - 0.38) net=n5
  l28 = rect li xspan=(x12 + L + 0.05, x12 + L + 0.305) yspan=(pt - WP - 0.025, pt - 0.38) net=n5
  l29 = rect li xspan=(x1 - 0.495, x1 - 0.27) yspan=(nb + 0.02, pt - 0.02) net=n4
  l30 = rect li xspan=(x1 - 0.495, x1 - 0.06) yspan=(nb + 0.02, nb + WN - 0.045) net=n4
  l31 = rect li xspan=(x1 - 0.495, x1 - 0.05) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l32 = rect li xspan=(x1 - 0.495, x1 - 0.035) yspan=(pt - WP + 0.31, pt - 0.38) net=n4
  l33 = rect li xspan=(x1 - 0.495, x5 + L + 0.41) yspan=(pt - WP + 0.45, pt - 0.38) net=n4
  l34 = rect li xspan=(x5 + L + 0.24, x5 + L + 0.41) yspan=(pt - WP - 0.13, pt - 0.38) net=n4
  l35 = rect li xspan=(x5 + L + 0.24, x6 + 0.03) yspan=(pt - WP - 0.13, pt - WP + 0.04) net=n4
  l36 = rect li xspan=(x6 - 0.285, x6 + 0.03) yspan=(nb + WN + 0.11, pt - WP + 0.04) net=n4
  l37 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l38 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l39 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.31) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l40 = rect li xspan=(x8 + L - 0.03, x10 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l41 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.225) span=(nb + 0.02, nb + WN - 0.045) margin=0.04 net=n4
  c2 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x5 + L + 0.255) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x6 - 0.16) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x8 - 0.1) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x12 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c8 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.32 - 0.08) margin=0.04 net=n2
  c9 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.17 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=n2
  c10 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + 0.38, nb + WN - 0.1) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x4 + L + 0.145) span=(nb + 0.38, nb + WN - 0.1) margin=0.04 net=X
  c12 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.105 - 0.08) margin=0.04 net=n5
  c13 = array licon in=pd2 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.32 - 0.08) margin=0.04 net=n2
  c14 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - WP - 0.025 + 0.08, pt - 0.38 - 0.08) net=n5
  c15 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.11, pt - WP + 0.28) margin=0.04 net=X
  c16 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - WP + 0.11, pt - WP + 0.28) margin=0.04 net=X
  c17 = array licon in=pd2 cx=(x6 - 0.14) span=(pt - WP + 0.21 + 0.08, pt - 0.105 - 0.08) net=n5
  c18 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n4
  c19 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.45, pt - 0.38) margin=0.04 net=n5
  c20 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd2 cx=(x9 + L + 0.1) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd2 cx=(x11 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.07) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 - 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.075) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 - 0.06) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + 0.035) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + L + 0.11) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x12 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.6, x12 + L + 0.46) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.37) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.055) cy=0
  mc3 = contact mcon cx=(x2 + L - 0.025) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.01) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.04) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.29) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.03) cy=0
  mc9 = contact mcon cx=(x7 + L + 0.07) cy=0
  mc10 = contact mcon cx=(x9 + L + 0.07) cy=0
  mc11 = contact mcon cx=(x11 - 0.13) cy=0
  mc12 = contact mcon cx=(x12 - 0.09) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.23) cy=0
  mc14 = contact mcon cx=(x1 - 0.37) cy=H
  mc15 = contact mcon cx=(x1 + L - 0.055) cy=H
  mc16 = contact mcon cx=(x2 + L - 0.025) cy=H
  mc17 = contact mcon cx=(x3 + L + 0.01) cy=H
  mc18 = contact mcon cx=(x4 + L + 0.04) cy=H
  mc19 = contact mcon cx=(x5 + L + 0.07) cy=H
  mc20 = contact mcon cx=(x6 - 0.29) cy=H
  mc21 = contact mcon cx=(x6 + L + 0.03) cy=H
  mc22 = contact mcon cx=(x7 + L + 0.07) cy=H
  mc23 = contact mcon cx=(x9 + L + 0.07) cy=H
  mc24 = contact mcon cx=(x11 - 0.13) cy=H
  mc25 = contact mcon cx=(x12 - 0.09) cy=H
  mc26 = contact mcon cx=(x12 + L + 0.23) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l15
  port B1_N in on=l7
  port X out on=l8
end
