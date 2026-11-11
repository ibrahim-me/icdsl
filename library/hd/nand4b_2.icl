# nand4b_2: lifted from sky130_fd_sc_hd__nand4b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand4b_2 width=15 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=D s=Y b=VPB
  device M1 nmos w=WN l=L d=n1 g=n2 s=Y b=VNB
  device M2 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n2 s=Y b=VPB
  device M4 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M5 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M7 nmos w=WN l=L d=n3 g=B s=n1 b=VNB
  device M8 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M9 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M10 nmos w=WN l=L d=n1 g=B s=n3 b=VNB
  device M11 nmos w=WN l=L d=n4 g=C s=n3 b=VNB
  device M12 nmos w=WN l=L d=VGND g=D s=n4 b=VNB
  device M13 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M14 nmos w=WN l=L d=n3 g=C s=n4 b=VNB
  device M15 nmos w=WN l=L d=Y g=n2 s=n1 b=VNB
  device M16 nmos w=WN l=L d=n4 g=D s=VGND b=VNB
  device M17 pmos w=WP l=L d=Y g=D s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.75
  x7 = x6 + 0.05
  x8 = x7 + L + 0.23
  x9 = x8 + 0.05
  x10 = x9 + L + 0.32
  x11 = x10 + 0.05
  x12 = x11 + L + 0.23
  x13 = x12 + 0.05
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x6 - 0.215, x13 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x13 + L + 0.355) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.29, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x9 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p15 = rect poly xspan=(x10, x13 + L + 0.24) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x10, x13 + L + 0.38) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p17 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.16)
  p18 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x4 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + 0.23) net=n3
  l2 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.305) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x11 + L + 0.055, x12) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l4 = rect li xspan=(x2 - 0.305, x4 - 0.055) yspan=(nb + 0.02, nb + 0.23) net=n1
  l5 = rect li xspan=(x2 - 0.305, x2 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l7 = rect li xspan=(x3 + L + 0.055, x5 + L + 0.305) yspan=(nb + WN2 - 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x6 - 0.255, x11 - 0.01) yspan=(nb + WN2 - 0.02, nb + WN + 0.02) net=n4
  l9 = rect li xspan=(x6 - 0.255, x13 + L + 0.31) yspan=(nb + WN2 + 0.06, nb + WN + 0.02) net=n4
  l10 = rect li xspan=(x9 + L + 0.055, x10) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l11 = rect li xspan=(x9 + L + 0.055, x11 - 0.01) yspan=(nb + WN2 - 0.04, nb + WN + 0.02) net=n4
  l12 = rect li xspan=(x12 + L + 0.02, x13 + L + 0.31) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l13 = rect li xspan=(x3 + L + 0.11, x5 + L + 0.36) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l14 = rect li xspan=(x6 - 0.13, x11 - 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l15 = rect li xspan=(x11 + L + 0.01, x13 + L + 0.4) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=D
  l16 = rect li xspan=(x1 - 0.31, x1 - 0.07) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A_N
  l17 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=n2
  l18 = rect li xspan=(x1 - 0.31, x1 + L + 0.13) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n2
  l19 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n2
  l20 = rect li xspan=(x1 - 0.31, x1 + L + 0.13) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n2
  l21 = rect li xspan=(x1 + L - 0.045, x1 + L + 0.13) yspan=(nb + WN2 - 0.02, pt - WP2 + 0.02) net=n2
  l22 = rect li xspan=(x1 + L - 0.045, x2 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n2
  l23 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + WN2 - 0.02, nb + WN - 0.06) net=Y
  l24 = rect li xspan=(x2 + L - 0.03, x13 - 0.02) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l25 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l26 = rect li xspan=(x2 + L + 0.07, x3 + 0.03) yspan=(nb + WN2 - 0.02, pt - 0.02) net=Y
  l27 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l28 = rect li xspan=(x6 + L - 0.03, x9 - 0.02) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l29 = rect li xspan=(x10 + L - 0.03, x13 - 0.02) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l30 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l31 = rect li xspan=(x2 - 0.305, x2 - 0.055) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  l32 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l33 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x9 + L, x10 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l35 = rect li xspan=(x13 + L, x13 + L + 0.4) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c2 = array licon in=nd2 cx=(x2 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c3 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n3
  c4 = array licon in=nd3 cx=(x8 - 0.09) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n3
  c5 = array licon in=nd3 cx=(x12 - 0.09) span=(-0.085 + 0.08, nb + WN2 - 0.11 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd3 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n4
  c7 = array licon in=nd3 cx=(x10 - 0.135) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c8 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n2
  c9 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + WN2 - 0.02, nb + WN - 0.06) margin=0.04 net=Y
  c11 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + WN2 - 0.02, nb + WN + 0.02) net=n1
  c12 = array licon in=nd3 cx=(x6 - 0.09) span=(nb + WN2 - 0.02, nb + WN + 0.02) net=n4
  c13 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c14 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c15 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c16 = array licon in=pd2 cx=(x7 + L + 0.09) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c17 = array licon in=pd2 cx=(x13 + L + 0.17) span=(pt - WP + 0.01, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c19 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd2 cx=(x6 - 0.22) span=(pt - WP2 - 0.23, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd2 cx=(x9 + L + 0.125) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd2 cx=(x11 + L + 0.09) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c23 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n2
  c24 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.04) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.125) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L - 0.035) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x12 - 0.055) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x13 + L + 0.215) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x13 + L + 0.49) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x4 - 0.11) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.25) cy=0
  mc8 = contact mcon cx=(x6 - 0.04) cy=0
  mc9 = contact mcon cx=(x8 + 0.005) cy=0
  mc10 = contact mcon cx=(x10 - 0.05) cy=0
  mc11 = contact mcon cx=(x12 - 0.01) cy=0
  mc12 = contact mcon cx=(x13 + L + 0.26) cy=0
  mc13 = contact mcon cx=(x1 - 0.17) cy=H
  mc14 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc15 = contact mcon cx=(x2 - 0.19) cy=H
  mc16 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc17 = contact mcon cx=(x4 - 0.11) cy=H
  mc18 = contact mcon cx=(x5 - 0.07) cy=H
  mc19 = contact mcon cx=(x5 + L + 0.25) cy=H
  mc20 = contact mcon cx=(x6 - 0.04) cy=H
  mc21 = contact mcon cx=(x8 + 0.005) cy=H
  mc22 = contact mcon cx=(x10 - 0.05) cy=H
  mc23 = contact mcon cx=(x12 - 0.01) cy=H
  mc24 = contact mcon cx=(x13 + L + 0.26) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l16
  port B in on=l13
  port C in on=l14
  port D in on=l15
  port Y out on=l26
end
