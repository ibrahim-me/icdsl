# and4bb_2: lifted from sky130_fd_sc_hd__and4bb_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4bb_2 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=n1 g=D s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M3 nmos w=WN2 l=L d=n1 g=n2 s=n3 b=VNB
  device M4 pmos w=WP2 l=L d=VPWR g=B_N s=n4 b=VPB
  device M5 nmos w=WN2 l=L d=n5 g=C s=n6 b=VNB
  device M6 pmos w=WP2 l=L d=VPWR g=C s=n1 b=VPB
  device M7 pmos w=WP2 l=L d=n1 g=n4 s=VPWR b=VPB
  device M8 nmos w=WN2 l=L d=n6 g=D s=VGND b=VNB
  device M9 pmos w=WP2 l=L d=VPWR g=n2 s=n1 b=VPB
  device M10 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M11 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M12 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M13 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M14 nmos w=WN2 l=L d=n3 g=n4 s=n5 b=VNB
  device M15 nmos w=WN2 l=L d=VGND g=B_N s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.715
  x5 = x4 + 0.085
  x6 = x5 + L + 0.22
  x7 = x6 + 0.025
  x8 = x7 + L + 0.29
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.45
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x4 - 0.18, x10 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x4 - 0.08) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.2) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.305, x4 + L) yspan=(pt - WP - 0.49, pt - WP - 0.16)
  p7 = rect poly xspan=(x4 - 0.225, x4 + L) yspan=(nb + WN2 + 0.075, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN2 + 0.075, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, nb + WN + 0.065)
  p10 = rect poly xspan=(x6 - 0.07, x7 + L + 0.035) yspan=(pt - WP - 0.085, pt - WP2 - 0.335)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP2 - 0.335)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP - 0.085, H - 0.105)
  p13 = rect poly xspan=(x8 - 0.095, x8 + L + 0.035) yspan=(nb + WN - 0.11, pt - WP - 0.38)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9 - 0.035, x9 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.08)
  p16 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x10 - 0.105, x10 + L + 0.025) yspan=(nb + WN2 + 0.11, pt - WP - 0.39)
  p18 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x9 + L + 0.225, x10 + 0.03) yspan=(-0.085, nb + WN2 - 0.07) net=VGND
  l4 = rect li xspan=(x8 - 0.14, x8 + L - 0.02) yspan=(nb + 0.185, pt - WP - 0.21) net=C
  l5 = rect li xspan=(x9 + L + 0.215, x10 + L - 0.03) yspan=(nb + WN2 + 0.11, pt - WP - 0.18) net=B_N
  l6 = rect li xspan=(x9 - 0.12, x9 + L + 0.045) yspan=(nb + 0.19, pt - WP - 0.08) net=D
  l7 = rect li xspan=(x1 - 0.25, x1 - 0.07) yspan=(nb + WN + 0.11, pt - WP + 0.15) net=A_N
  l8 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP + 0.06, pt - WP2 - 0.35) net=X
  l9 = rect li xspan=(x2 + L - 0.005, x3 - 0.055) yspan=(nb + 0.02, pt - WP2 - 0.35) net=X
  l10 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=n2
  l11 = rect li xspan=(x1 - 0.225, x1 + L + 0.13) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n2
  l12 = rect li xspan=(x1 - 0.225, x4 - 0.225) yspan=(pt - WP2 - 0.18, pt - WP2 - 0.01) net=n2
  l13 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP2 - 0.18, pt - 0.02) net=n2
  l14 = rect li xspan=(x1 + L - 0.045, x1 + L + 0.13) yspan=(nb + WN2 - 0.02, pt - WP2 - 0.01) net=n2
  l15 = rect li xspan=(x3 + L + 0.32, x4 - 0.225) yspan=(nb + WN + 0.11, pt - WP2 - 0.01) net=n2
  l16 = rect li xspan=(x3 + L + 0.32, x4 - 0.085) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l17 = rect li xspan=(x3 + L - 0.025, x5 + L + 0.03) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n1
  l18 = rect li xspan=(x3 + L - 0.025, x3 + L + 0.15) yspan=(nb + WN2 - 0.02, pt - WP - 0.16) net=n1
  l19 = rect li xspan=(x4 - 0.14, x4 + 0.035) yspan=(nb + 0.02, nb + WN - 0.08) net=n1
  l20 = rect li xspan=(x5 + 0.005, x5 + L + 0.03) yspan=(nb + WN2 - 0.02, pt - WP2 + 0.02) net=n1
  l21 = rect li xspan=(x5 + 0.005, x9 - 0.055) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n1
  l22 = rect li xspan=(x5 + L + 0.02, x6 - 0.03) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n1
  l23 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n1
  l24 = rect li xspan=(x6 - 0.02, x6 + L + 0.005) yspan=(pt - WP - 0.085, pt - WP + 0.26) net=n4
  l25 = rect li xspan=(x6 - 0.02, x9 + L + 0.145) yspan=(pt - WP + 0.09, pt - WP + 0.26) net=n4
  l26 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.145) yspan=(pt - WP + 0.09, pt - WP2 + 0.02) net=n4
  l27 = rect li xspan=(x9 + L - 0.03, x10 + L + 0.315) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n4
  l28 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.315) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n4
  l29 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.315) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n4
  l30 = rect li xspan=(x10 + L + 0.145, x10 + L + 0.315) yspan=(nb + 0.02, pt - 0.02) net=n4
  l31 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(pt - WP2 + 0.19, H + 0.085) net=VPWR
  l32 = rect li xspan=(x3 + L + 0.055, x4 + 0.015) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l33 = rect li xspan=(x6 + L - 0.005, x8 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x9 + L + 0.145, x10 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n2
  c4 = array licon in=nd3 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x4 - 0.055) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n1
  c6 = array licon in=nd1 cx=(x10 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.07 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n4
  c8 = array licon in=pd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.18 + 0.08, pt - 0.02 - 0.08) net=n2
  c10 = array licon in=pd1 cx=(x5 + L + 0.105) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n4
  c13 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.19, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd2 cx=(x3 + L + 0.22) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x4 - 0.155) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c16 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x10 - 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x10 + 0.035) cy=(nb + WN + 0.045)
  gc2 = contact licon cx=(x8 + 0.045) cy=(nb + WN + 0.055)
  gc3 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + L + 0.065) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x4 - 0.17) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x9 + L - 0.045) cy=(nb + WN + 0.355)
  gc7 = contact licon cx=(x7 + 0.045) cy=(pt - WP + 0.08)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x5 + L + 0.1, x7 + L + 0.085) yspan=(nb + WN + 0.09, pt - WP2 - 0.315)
  np3 = rect npc xspan=(x5 + L + 0.1, x9 + L + 0.175) yspan=(pt - WP - 0.14, pt - WP2 - 0.56)
  np4 = rect npc xspan=(x7 + L + 0.12, x8 + L + 0.085) yspan=(nb + WN2 + 0.1, pt - WP2 - 0.56)
  np5 = rect npc xspan=(x10 - 0.16, x10 + L + 0.075) yspan=(nb + WN2 + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc5 = contact mcon cx=(x4 - 0.08) cy=0
  mc6 = contact mcon cx=(x6 - 0.065) cy=0
  mc7 = contact mcon cx=(x8 - 0.06) cy=0
  mc8 = contact mcon cx=(x9 - 0.02) cy=0
  mc9 = contact mcon cx=(x10 - 0.15) cy=0
  mc10 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc11 = contact mcon cx=(x1 - 0.17) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc13 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc14 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc15 = contact mcon cx=(x4 - 0.08) cy=H
  mc16 = contact mcon cx=(x6 - 0.065) cy=H
  mc17 = contact mcon cx=(x8 - 0.06) cy=H
  mc18 = contact mcon cx=(x9 - 0.02) cy=H
  mc19 = contact mcon cx=(x10 - 0.15) cy=H
  mc20 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l7
  port B_N in on=l5
  port C in on=l4
  port D in on=l6
  port X out on=l9
end
