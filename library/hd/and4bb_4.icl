# and4bb_4: lifted from sky130_fd_sc_hd__and4bb_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4bb_4 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=n2 b=VPB
  device M1 pmos w=WP l=L d=n2 g=n3 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n4 g=C s=n5 b=VNB
  device M4 pmos w=WP2 l=L d=VPWR g=A_N s=n3 b=VPB
  device M5 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M6 nmos w=WN l=L d=VGND g=D s=n4 b=VNB
  device M7 nmos w=WN l=L d=n6 g=n3 s=n2 b=VNB
  device M8 nmos w=WN l=L d=n5 g=n1 s=n6 b=VNB
  device M9 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M11 pmos w=WP2 l=L d=n1 g=B_N s=VPWR b=VPB
  device M12 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M13 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M14 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M15 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M16 nmos w=WN2 l=L d=n1 g=B_N s=VGND b=VNB
  device M17 nmos w=WN2 l=L d=VGND g=A_N s=n3 b=VNB
  device M18 pmos w=WP l=L d=VPWR g=D s=n2 b=VPB
  device M19 pmos w=WP l=L d=n2 g=C s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.36
  x7 = x6 + L + 0.34
  x8 = x7 + L + 0.43
  x9 = x8 + L + 0.34
  x10 = x9 + L + 1.135
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x10 - 0.425, x10 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x1 + L + 0.08, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.02, x1 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.11)
  p5 = rect poly xspan=(x2, x5 + L + 0.145) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x9, x10 - 0.22) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x10, x10 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.235) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.235) net=VGND
  l3 = rect li xspan=(x5 + L - 0.01, x6 - 0.035) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x10 - 0.465, x10 - 0.135) yspan=(-0.085, nb + WN2 - 0.19) net=VGND
  l5 = rect li xspan=(x6 + 0.05, x7 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=D
  l6 = rect li xspan=(x7 + L - 0.01, x8 - 0.14) yspan=(nb + WN2 + 0.1, pt - WP - 0.16) net=C
  l7 = rect li xspan=(x10 + 0.05, x10 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP + 0.135) net=A_N
  l8 = rect li xspan=(x1 + 0.035, x2 - 0.095) yspan=(nb + WN2 + 0.11, pt - WP + 0.15) net=B_N
  l9 = rect li xspan=(x2 + L - 0.06, x3 - 0.055) yspan=(nb + WN2 - 0.005, pt - WP2 - 0.35) net=X
  l10 = rect li xspan=(x2 + L - 0.06, x5 - 0.055) yspan=(nb + WN2 - 0.005, nb + WN - 0.065) net=X
  l11 = rect li xspan=(x2 + L - 0.06, x5 + 0.03) yspan=(pt - WP + 0.06, pt - WP2 - 0.35) net=X
  l12 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, pt - WP2 - 0.35) net=X
  l13 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.02, nb + WN - 0.065) net=X
  l14 = rect li xspan=(x3 + L - 0.03, x6 - 0.135) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n2
  l15 = rect li xspan=(x5 + L + 0.055, x6 - 0.135) yspan=(nb + WN2 - 0.04, pt - WP + 0.23) net=n2
  l16 = rect li xspan=(x5 + L + 0.055, x6 + L + 0.165) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n2
  l17 = rect li xspan=(x5 + L + 0.055, x9 - 0.015) yspan=(pt - WP + 0.06, pt - WP + 0.23) net=n2
  l18 = rect li xspan=(x6 + L - 0.01, x9 + L + 0.305) yspan=(nb + 0.065, nb + 0.235) net=n2
  l19 = rect li xspan=(x6 + L - 0.01, x6 + L + 0.165) yspan=(nb + 0.065, nb + WN - 0.1) net=n2
  l20 = rect li xspan=(x9 + L - 0.055, x9 + L + 0.305) yspan=(nb + 0.065, nb + WN - 0.075) net=n2
  l21 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=n1
  l22 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n1
  l23 = rect li xspan=(x1 - 0.315, x9 + L + 0.185) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n1
  l24 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n1
  l25 = rect li xspan=(x8 + 0.05, x8 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l26 = rect li xspan=(x8 + 0.05, x9 + L + 0.185) yspan=(nb + WN + 0.27, pt - WP - 0.16) net=n1
  l27 = rect li xspan=(x9 + L + 0.015, x9 + L + 0.185) yspan=(nb + WN + 0.27, pt - WP2 + 0.02) net=n1
  l28 = rect li xspan=(x10 - 0.49, x10 - 0.32) yspan=(nb + WN2, pt - WP2 + 0.02) net=n3
  l29 = rect li xspan=(x10 - 0.49, x10 + L + 0.225) yspan=(nb + WN2, nb + WN - 0.06) net=n3
  l30 = rect li xspan=(x10 - 0.49, x10 + L + 0.225) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n3
  l31 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l32 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n3
  l33 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l35 = rect li xspan=(x5 + L - 0.03, x6 - 0.055) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l36 = rect li xspan=(x7 + L + 0.075, x8 - 0.025) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l37 = rect li xspan=(x9 + L + 0.055, x10 - 0.07) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x5 + L + 0.16) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x2 - 0.14) span=(-0.085, nb + 0.235) net=VGND
  c3 = array licon in=nd1 cx=(x10 - 0.3) span=(-0.085, nb + WN2 - 0.19) net=VGND
  c4 = array licon in=nd3 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.235) margin=0.04 net=VGND
  c5 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.065, nb + WN - 0.075) net=n2
  c6 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n1
  c7 = array licon in=nd3 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd3 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.065 - 0.08) margin=0.04 net=X
  c9 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.06, pt - WP2 - 0.35) margin=0.04 net=X
  c12 = array licon in=pd2 cx=(x7 - 0.14) span=(pt - WP + 0.06, pt - WP + 0.23) margin=0.04 net=n2
  c13 = array licon in=pd2 cx=(x8 + L + 0.16) span=(pt - WP + 0.06, pt - WP + 0.23) margin=0.04 net=n2
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n1
  c15 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n3
  c16 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c19 = array licon in=pd2 cx=(x8 - 0.19) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x9 + L + 0.22) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x9 + L + 0.56) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x10 - 0.235) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.03) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.06) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.025) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L + 0.08) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x10 - 0.405) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x4 - 0.105) cy=0
  mc5 = contact mcon cx=(x5 - 0.065) cy=0
  mc6 = contact mcon cx=(x6 - 0.105) cy=0
  mc7 = contact mcon cx=(x7 - 0.125) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.195) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.085) cy=0
  mc10 = contact mcon cx=(x9 + L + 0.065) cy=0
  mc11 = contact mcon cx=(x9 + L + 0.525) cy=0
  mc12 = contact mcon cx=(x10 - 0.15) cy=0
  mc13 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc16 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc17 = contact mcon cx=(x4 - 0.105) cy=H
  mc18 = contact mcon cx=(x5 - 0.065) cy=H
  mc19 = contact mcon cx=(x6 - 0.105) cy=H
  mc20 = contact mcon cx=(x7 - 0.125) cy=H
  mc21 = contact mcon cx=(x7 + L + 0.195) cy=H
  mc22 = contact mcon cx=(x8 + L + 0.085) cy=H
  mc23 = contact mcon cx=(x9 + L + 0.065) cy=H
  mc24 = contact mcon cx=(x9 + L + 0.525) cy=H
  mc25 = contact mcon cx=(x10 - 0.15) cy=H
  mc26 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l7
  port B_N in on=l8
  port C in on=l6
  port D in on=l5
  port X out on=l9
end
