# nand4bb_2: lifted from sky130_fd_sc_hd__nand4bb_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand4bb_2 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=n3 b=VNB
  device M1 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n4 g=D s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M4 pmos w=WP l=L d=Y g=D s=VPWR b=VPB
  device M5 nmos w=WN l=L d=Y g=n5 s=n1 b=VNB
  device M6 nmos w=WN l=L d=VGND g=D s=n4 b=VNB
  device M7 nmos w=WN l=L d=n1 g=n5 s=Y b=VNB
  device M8 pmos w=WP l=L d=Y g=n5 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M10 pmos w=WP2 l=L d=n2 g=B_N s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n5 s=Y b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A_N s=n5 b=VPB
  device M13 pmos w=WP l=L d=VPWR g=n2 s=Y b=VPB
  device M14 nmos w=WN2 l=L d=VGND g=A_N s=n5 b=VNB
  device M15 nmos w=WN2 l=L d=n2 g=B_N s=VGND b=VNB
  device M16 nmos w=WN l=L d=n3 g=n2 s=n1 b=VNB
  device M17 nmos w=WN l=L d=n3 g=C s=n4 b=VNB
  device M18 pmos w=WP l=L d=VPWR g=D s=Y b=VPB
  device M19 nmos w=WN l=L d=n4 g=C s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 1.01
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
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.475) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x3 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x7 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.475) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 - 0.02) yspan=(nb + WN + 0.185, pt - WP - 0.085)
  p2 = rect poly xspan=(x1 - 0.17, x1 - 0.02) yspan=(nb + WN2 + 0.075, pt - WP2 - 0.13)
  p3 = rect poly xspan=(x1 - 0.17, x1 + L) yspan=(nb + WN2 + 0.075, nb + WN2 + 0.225)
  p4 = rect poly xspan=(x1 - 0.17, x1 + L) yspan=(pt - WP + 0.3, pt - WP2 - 0.13)
  p5 = rect poly xspan=(x1, x1 + L) yspan=(0.105, nb + WN2 + 0.225)
  p6 = rect poly xspan=(x1, x1 + L) yspan=(pt - WP + 0.3, H - 0.105)
  p7 = rect poly xspan=(x1 + L + 0.05, x2 + L) yspan=(nb + WN + 0.205, pt - WP - 0.065)
  p8 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x2 + L + 0.4, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x2 + L + 0.4, x4 + L) yspan=(nb + WN + 0.14, nb + WN + 0.41)
  p11 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x5 - 0.065, x6 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x7 - 0.335, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p17 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x9 - 0.065, x10 + L + 0.305) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p20 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p22 = rect poly xspan=(x10, x10 + L + 0.305) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l2 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(-0.085, nb + WN2 - 0.09) net=VGND
  l3 = rect li xspan=(x3 - 0.225, x6 + L + 0.305) yspan=(nb + 0.02, nb + WN2 - 0.17) net=n1
  l4 = rect li xspan=(x3 - 0.225, x3 - 0.055) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n1
  l5 = rect li xspan=(x5 + L - 0.03, x8 + 0.03) yspan=(nb + WN2, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x7 - 0.305, x9 + 0.03) yspan=(nb + 0.02, nb + WN2 - 0.17) net=n4
  l7 = rect li xspan=(x8 + L + 0.055, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l8 = rect li xspan=(x8 + L + 0.055, x10 + L + 0.325) yspan=(nb + WN2 + 0.08, nb + WN + 0.02) net=n4
  l9 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.325) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l10 = rect li xspan=(x5 - 0.065, x5 + L + 0.125) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=n2
  l11 = rect li xspan=(x6 + L + 0.35, x8 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l12 = rect li xspan=(x9 - 0.065, x10 + L + 0.305) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=D
  l13 = rect li xspan=(x1 - 0.315, x1 - 0.07) yspan=(nb + WN + 0.185, pt - WP + 0.13) net=B_N
  l14 = rect li xspan=(x1 + L + 0.02, x2 + L/2) yspan=(nb + WN + 0.285, pt - WP - 0.145) net=A_N
  l15 = rect li xspan=(x1 + L + 0.07, x2 + L/2) yspan=(nb + WN + 0.185, pt - WP + 0.13) net=A_N
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.015) net=n2
  l17 = rect li xspan=(x1 - 0.315, x2 + L + 0.27) yspan=(nb + WN2 + 0.075, nb + WN + 0.015) net=n2
  l18 = rect li xspan=(x1 - 0.315, x2 + L + 0.27) yspan=(pt - WP + 0.3, pt - WP2 - 0.085) net=n2
  l19 = rect li xspan=(x1 - 0.315, x1 - 0.03) yspan=(pt - WP + 0.3, pt - 0.045) net=n2
  l20 = rect li xspan=(x2 + L + 0.1, x2 + L + 0.27) yspan=(nb + WN2 + 0.075, pt - WP2 - 0.085) net=n2
  l21 = rect li xspan=(x2 + L - 0.03, x3 - 0.395) yspan=(nb + 0.02, nb + WN2 - 0.095) net=n5
  l22 = rect li xspan=(x2 + L - 0.03, x3 - 0.395) yspan=(pt - WP2 + 0.085, pt - 0.02) net=n5
  l23 = rect li xspan=(x2 + L + 0.44, x3 - 0.395) yspan=(nb + 0.02, pt - 0.02) net=n5
  l24 = rect li xspan=(x2 + L + 0.44, x3 - 0.39) yspan=(nb + WN - 0.17, pt - WP - 0.075) net=n5
  l25 = rect li xspan=(x3 + L - 0.03, x4 - 0.055) yspan=(nb + WN2, pt - 0.02) net=Y
  l26 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + WN2, pt - WP + 0.18) net=Y
  l27 = rect li xspan=(x3 + L - 0.03, x10 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l28 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l29 = rect li xspan=(x6 + 0.02, x6 + L + 0.18) yspan=(pt - WP - 0.41, pt - WP + 0.18) net=Y
  l30 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l31 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l32 = rect li xspan=(x1 + L - 0.005, x2 - 0.055) yspan=(pt - WP2 + 0.13, H + 0.085) net=VPWR
  l33 = rect li xspan=(x3 - 0.225, x3 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l34 = rect li xspan=(x4 + L - 0.03, x5 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l35 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l36 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l37 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.325) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.11 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN2 - 0.17) margin=0.04 net=n1
  c3 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02, nb + WN2 - 0.17) net=n1
  c4 = array licon in=nd3 cx=(x7 - 0.14) span=(nb + 0.02, nb + WN2 - 0.17) net=n4
  c5 = array licon in=nd3 cx=(x8 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c6 = array licon in=nd3 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.09 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n4
  c8 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n1
  c9 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.015 - 0.08) net=n2
  c10 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN2 - 0.095) margin=0.04 net=n5
  c11 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + WN2 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c12 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + WN2, nb + WN + 0.02) margin=0.04 net=n3
  c13 = array licon in=nd3 cx=(x7 + L + 0.14) span=(nb + WN2, nb + WN + 0.02) margin=0.04 net=n3
  c14 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c15 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c16 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c17 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c18 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c19 = array licon in=pd2 cx=(x3 + L + 0.14) span=(nb + WN2 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c20 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd2 cx=(x6 + L + 0.22) span=(pt - WP2 - 0.23, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd2 cx=(x7 - 0.22) span=(pt - WP2 - 0.23, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.045 - 0.08) net=n2
  c25 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP2 + 0.085, pt - 0.02) margin=0.04 net=n5
  c26 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.13 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x3 - 0.475) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x5 + L - 0.045) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 - 0.17) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x9 + L - 0.045) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x10 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.35)
  gc8 = contact licon cx=(x2 - 0.095) cy=(nb + WN + 0.37)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 - 0.4, x2 + L - 0.055) yspan=(nb + WN + 0.09, pt - WP - 0.045)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x3 - 0.36) cy=0
  mc5 = contact mcon cx=(x3 + L - 0.045) cy=0
  mc6 = contact mcon cx=(x4 + L - 0.005) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.04) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.08) cy=0
  mc9 = contact mcon cx=(x7 - 0.26) cy=0
  mc10 = contact mcon cx=(x7 + L + 0.06) cy=0
  mc11 = contact mcon cx=(x8 + L + 0.1) cy=0
  mc12 = contact mcon cx=(x9 + L + 0.14) cy=0
  mc13 = contact mcon cx=(x10 + L + 0.18) cy=0
  mc14 = contact mcon cx=(x2 + L + 0.185) cy=(pt - WP - 0.295)
  mc15 = contact mcon cx=(x5 + L + 0.04) cy=(nb + WN + 0.305)
  mc16 = contact mcon cx=(x1 - 0.17) cy=H
  mc17 = contact mcon cx=(x2 - 0.13) cy=H
  mc18 = contact mcon cx=(x2 + L + 0.19) cy=H
  mc19 = contact mcon cx=(x3 - 0.36) cy=H
  mc20 = contact mcon cx=(x3 + L - 0.045) cy=H
  mc21 = contact mcon cx=(x4 + L - 0.005) cy=H
  mc22 = contact mcon cx=(x5 + L + 0.04) cy=H
  mc23 = contact mcon cx=(x6 + L + 0.08) cy=H
  mc24 = contact mcon cx=(x7 - 0.26) cy=H
  mc25 = contact mcon cx=(x7 + L + 0.06) cy=H
  mc26 = contact mcon cx=(x8 + L + 0.1) cy=H
  mc27 = contact mcon cx=(x9 + L + 0.14) cy=H
  mc28 = contact mcon cx=(x10 + L + 0.18) cy=H
  w1 = rect m1 xspan=(x2 + L + 0.04, x6 - 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n2
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l15
  port B_N in on=l13
  port C in on=l11
  port D in on=l12
  port Y out on=l27
end
