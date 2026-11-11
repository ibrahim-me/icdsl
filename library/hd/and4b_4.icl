# and4b_4: lifted from sky130_fd_sc_hd__and4b_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4b_4 width=14 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=n2 s=VPWR b=VPB
  device M1 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M3 nmos w=WN l=L d=n3 g=n2 s=n1 b=VNB
  device M4 nmos w=WN l=L d=n4 g=C s=n5 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=D s=n1 b=VPB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M8 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M9 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=n1 g=C s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M12 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M13 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M14 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M15 nmos w=WN l=L d=n5 g=B s=n3 b=VNB
  device M16 nmos w=WN l=L d=VGND g=D s=n4 b=VNB
  device M17 pmos w=WP l=L d=VPWR g=B s=n1 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.665
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.43
  x9 = x8 + L + 0.45
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.01, x1 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x5 + L + 0.175) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6 - 0.125, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7 - 0.065, x7 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.235) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.235) net=VGND
  l3 = rect li xspan=(x5 + L + 0.01, x6 - 0.325) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x6 - 0.075, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=D
  l5 = rect li xspan=(x7 - 0.015, x7 + L + 0.055) yspan=(nb + WN2 + 0.1, pt - WP - 0.16) net=C
  l6 = rect li xspan=(x8 - 0.115, x8 + L + 0.075) yspan=(nb + WN2 + 0.08, pt - WP - 0.16) net=B
  l7 = rect li xspan=(x1 + 0.045, x2 - 0.085) yspan=(nb + WN2 + 0.11, pt - WP + 0.15) net=A_N
  l8 = rect li xspan=(x2 + L - 0.04, x3 - 0.035) yspan=(nb + WN2 - 0.005, pt - WP2 - 0.35) net=X
  l9 = rect li xspan=(x2 + L - 0.04, x5 - 0.055) yspan=(nb + WN2 - 0.005, nb + WN - 0.065) net=X
  l10 = rect li xspan=(x2 + L - 0.04, x5 + 0.03) yspan=(pt - WP + 0.06, pt - WP2 - 0.35) net=X
  l11 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, pt - WP2 - 0.35) net=X
  l12 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.02, nb + WN - 0.065) net=X
  l13 = rect li xspan=(x3 + L, x5 + L + 0.275) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l14 = rect li xspan=(x5 + L + 0.105, x5 + L + 0.275) yspan=(nb + WN2 - 0.04, pt - WP + 0.23) net=n1
  l15 = rect li xspan=(x5 + L + 0.105, x6 + 0.03) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n1
  l16 = rect li xspan=(x5 + L + 0.105, x9 + 0.03) yspan=(pt - WP + 0.06, pt - WP + 0.23) net=n1
  l17 = rect li xspan=(x6 - 0.145, x9 + L + 0.305) yspan=(nb + 0.065, nb + 0.235) net=n1
  l18 = rect li xspan=(x6 - 0.145, x6 + 0.03) yspan=(nb + 0.065, nb + WN - 0.1) net=n1
  l19 = rect li xspan=(x9 - 0.13, x9 + L + 0.305) yspan=(nb + 0.065, nb + WN - 0.075) net=n1
  l20 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=n2
  l21 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n2
  l22 = rect li xspan=(x1 - 0.315, x9 + L + 0.24) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n2
  l23 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n2
  l24 = rect li xspan=(x9 + L + 0.07, x9 + L + 0.24) yspan=(nb + WN + 0.11, pt - WP2 + 0.02) net=n2
  l25 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l26 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l27 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.305) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l28 = rect li xspan=(x7 + L - 0.03, x8 - 0.125) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l29 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.305) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x5 + L + 0.175) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x2 - 0.14) span=(-0.085, nb + 0.235) net=VGND
  c3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.235) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.065, nb + WN - 0.075) net=n1
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n2
  c6 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c7 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.065 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP2 - 0.35 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.06, pt - WP2 - 0.35) margin=0.04 net=X
  c10 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.06, pt - WP + 0.23) margin=0.04 net=n1
  c11 = array licon in=pd2 cx=(x9 - 0.14) span=(pt - WP + 0.06, pt - WP + 0.23) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n2
  c13 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c16 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.02) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 - 0.11) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.09) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.01) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L/2) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x9 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x4 - 0.105) cy=0
  mc5 = contact mcon cx=(x5 - 0.065) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.255) cy=0
  mc7 = contact mcon cx=(x6 + 0.055) cy=0
  mc8 = contact mcon cx=(x7 + L - 0.055) cy=0
  mc9 = contact mcon cx=(x8 - 0.02) cy=0
  mc10 = contact mcon cx=(x9 - 0.15) cy=0
  mc11 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc12 = contact mcon cx=(x1 - 0.17) cy=H
  mc13 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc14 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc15 = contact mcon cx=(x4 - 0.105) cy=H
  mc16 = contact mcon cx=(x5 - 0.065) cy=H
  mc17 = contact mcon cx=(x5 + L + 0.255) cy=H
  mc18 = contact mcon cx=(x6 + 0.055) cy=H
  mc19 = contact mcon cx=(x7 + L - 0.055) cy=H
  mc20 = contact mcon cx=(x8 - 0.02) cy=H
  mc21 = contact mcon cx=(x9 - 0.15) cy=H
  mc22 = contact mcon cx=(x9 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l7
  port B in on=l6
  port C in on=l5
  port D in on=l4
  port X out on=l8
end
