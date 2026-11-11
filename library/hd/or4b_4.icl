# or4b_4: lifted from sky130_fd_sc_hd__or4b_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or4b_4 width=14 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M1 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M3 pmos w=WP l=L d=n4 g=C s=n1 b=VPB
  device M4 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M5 nmos w=WN l=L d=VGND g=n5 s=n3 b=VNB
  device M6 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M7 pmos w=WP l=L d=n3 g=n5 s=n4 b=VPB
  device M8 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M9 nmos w=WN2 l=L d=VGND g=D_N s=n5 b=VNB
  device M10 pmos w=WP2 l=L d=VPWR g=D_N s=n5 b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M12 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M13 nmos w=WN l=L d=VGND g=B s=n3 b=VNB
  device M14 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M15 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M16 nmos w=WN l=L d=n3 g=C s=VGND b=VNB
  device M17 nmos w=WN l=L d=X g=n3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.39
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.39
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.255) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb + 0.23 + 0.135, nb + WN)
  nd3 = rect diff xspan=(x2 - 0.265, x9 + L + 0.28) yspan=(nb, nb + 0.23 + 0.055)
  nd4 = rect diff xspan=(x2 - 0.255, x9 + L + 0.28) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.175, x1 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.345, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.125, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x6, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x2 - 0.305, x2 - 0.055) yspan=(-0.085, nb + 0.23 + 0.12) net=VGND
  l3 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.23 + 0.02) net=VGND
  l4 = rect li xspan=(x5 + L + 0.025, x6 + 0.02) yspan=(-0.085, nb + 0.23 + 0.02) net=VGND
  l5 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l6 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.225) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l7 = rect li xspan=(x5 + 0.05, x5 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l8 = rect li xspan=(x5 + 0.05, x6 - 0.05) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A
  l9 = rect li xspan=(x1 - 0.295, x1 + 0.05) yspan=(pt - WP - 0.49, pt - WP2 - 0.11) net=D_N
  l10 = rect li xspan=(x3 - 0.075, x3 + L - 0.05) yspan=(nb + WN + 0.11, pt - 0.11) net=C
  l11 = rect li xspan=(x3 - 0.075, x4 - 0.135) yspan=(pt - WP + 0.135, pt - 0.11) net=C
  l12 = rect li xspan=(x4 - 0.095, x4 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.035) net=B
  l13 = rect li xspan=(x4 + 0.05, x4 + L + 0.095) yspan=(nb + WN + 0.11, pt - 0.11) net=B
  l14 = rect li xspan=(x4 + 0.05, x5 - 0.075) yspan=(pt - WP2 - 0.28, pt - 0.11) net=B
  l15 = rect li xspan=(x2 - 0.305, x2 + 0.03) yspan=(pt - WP + 0.09, pt - 0.035) net=n3
  l16 = rect li xspan=(x2 - 0.305, x2 + L + 0.145) yspan=(pt - WP + 0.09, pt - WP2 - 0.32) net=n3
  l17 = rect li xspan=(x2 + L - 0.03, x6 + 0.03) yspan=(nb + 0.23 + 0.19, nb + WN - 0.06) net=n3
  l18 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.145) yspan=(nb + 0.23 + 0.19, pt - WP2 - 0.32) net=n3
  l19 = rect li xspan=(x2 + L + 0.135, x3 - 0.085) yspan=(nb + 0.07, nb + WN - 0.06) net=n3
  l20 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.07, nb + WN - 0.06) net=n3
  l21 = rect li xspan=(x6 - 0.145, x6 + 0.03) yspan=(nb + 0.23 + 0.19, pt - WP - 0.24) net=n3
  l22 = rect li xspan=(x6 - 0.145, x9 + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l23 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.245) yspan=(nb + 0.23 - 0.03, pt - WP - 0.58) net=n5
  l24 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.245) yspan=(pt - WP2, pt - 0.03) net=n5
  l25 = rect li xspan=(x1 + L + 0.075, x1 + L + 0.245) yspan=(nb + 0.23 - 0.03, pt - 0.03) net=n5
  l26 = rect li xspan=(x1 + L + 0.075, x2 - 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n5
  l27 = rect li xspan=(x6 + L + 0.015, x9 + L + 0.325) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=X
  l28 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l29 = rect li xspan=(x6 + L + 0.055, x7 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l30 = rect li xspan=(x6 + L + 0.055, x9 + L + 0.325) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l31 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l32 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l33 = rect li xspan=(x9 + L + 0.085, x9 + L + 0.325) yspan=(nb + WN - 0.16, pt - WP + 0.14) net=X
  l34 = rect li xspan=(x1 - 0.315, x1 - 0.035) yspan=(pt - WP2 + 0.07, H + 0.085) net=VPWR
  l35 = rect li xspan=(x5 + L + 0.07, x6 - 0.07) yspan=(pt - WP2 - 0.27, H + 0.085) net=VPWR
  l36 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP2 - 0.27, H + 0.085) net=VPWR
  l37 = rect li xspan=(x9 + L + 0.015, x9 + L + 0.265) yspan=(pt - WP2 - 0.27, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd4 cx=(x2 - 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.12 - 0.08) net=VGND
  c2 = array licon in=nd4 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd4 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c4 = array licon in=nd4 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) net=VGND
  c5 = array licon in=nd4 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.23 + 0.02) margin=0.04 net=VGND
  c6 = array licon in=nd4 cx=(x6 - 0.15) span=(-0.085, nb + 0.23 + 0.02) margin=0.04 net=VGND
  c7 = array licon in=nd4 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd4 cx=(x3 - 0.17) span=(nb + 0.07 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c9 = array licon in=nd4 cx=(x4 + L + 0.14) span=(nb + 0.07 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c10 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c11 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.23 - 0.03 + 0.08, pt - WP - 0.58 - 0.08) net=n5
  c12 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c13 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP + 0.09, pt - 0.035) net=n3
  c15 = array licon in=pd2 cx=(x5 + L + 0.195) span=(pt - WP2 - 0.27 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c16 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP2 - 0.27 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c17 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP2 - 0.27 + 0.08, H + 0.085 - 0.08) net=VPWR
  c18 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.08, pt - 0.03 - 0.08) net=n5
  c19 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.04) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 - 0.21) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 + 0.055) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x8 - 0.03) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x9 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.06) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.1) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.14) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.07) cy=0
  mc9 = contact mcon cx=(x7 + L + 0.11) cy=0
  mc10 = contact mcon cx=(x9 - 0.13) cy=0
  mc11 = contact mcon cx=(x9 + L + 0.19) cy=0
  mc12 = contact mcon cx=(x1 - 0.17) cy=H
  mc13 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc14 = contact mcon cx=(x2 - 0.19) cy=H
  mc15 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.06) cy=H
  mc17 = contact mcon cx=(x4 + L + 0.1) cy=H
  mc18 = contact mcon cx=(x5 + L + 0.14) cy=H
  mc19 = contact mcon cx=(x6 + L + 0.07) cy=H
  mc20 = contact mcon cx=(x7 + L + 0.11) cy=H
  mc21 = contact mcon cx=(x9 - 0.13) cy=H
  mc22 = contact mcon cx=(x9 + L + 0.19) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port B in on=l14
  port C in on=l11
  port D_N in on=l9
  port X out on=l30
end
