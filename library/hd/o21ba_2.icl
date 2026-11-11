# o21ba_2: lifted from sky130_fd_sc_hd__o21ba_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell o21ba_2 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M2 pmos w=WP l=L d=VPWR g=n2 s=n1 b=VPB
  device M3 pmos w=WP l=L d=n1 g=A2 s=n3 b=VPB
  device M4 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M5 nmos w=WN2 l=L d=n2 g=B1_N s=VGND b=VNB
  device M6 nmos w=WN l=L d=n1 g=n2 s=n4 b=VNB
  device M7 nmos w=WN l=L d=VGND g=A1 s=n4 b=VNB
  device M8 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M10 pmos w=WP2 l=L d=n2 g=B1_N s=VPWR b=VPB
  device M11 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + 0.01
  x4 = x3 + L + 0.27
  x5 = x4 + 0.01
  x6 = x5 + L + 0.8
  x7 = x6 + L + 0.335
  x8 = x7 + 0.005
  x9 = x8 + L + 0.22
  x10 = x9 + 0.055
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.255) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x1 + L + 0.08, x5 + L + 0.255) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x6 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.23) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 + L + 0.08, x10 + L + 0.23) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.025, x1 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x5 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x5 + L + 0.27, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7 - 0.12, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x9, x10 + L + 0.15) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.1) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x5 + L + 0.325) yspan=(-0.085, nb + 0.23 + 0.02) net=VGND
  l3 = rect li xspan=(x8 + L + 0.05, x9 + 0.005) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l4 = rect li xspan=(x6 + L + 0.06, x8 + 0.025) yspan=(nb + 0.23 - 0.1, nb + WN + 0.02) net=n4
  l5 = rect li xspan=(x6 + L + 0.06, x10 + L + 0.31) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n4
  l6 = rect li xspan=(x9 + L + 0.025, x10 + L + 0.31) yspan=(nb + 0.035, nb + WN + 0.02) net=n4
  l7 = rect li xspan=(x6 + L + 0.06, x8 + L + 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l8 = rect li xspan=(x9 + 0.02, x10 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=A1
  l9 = rect li xspan=(x1 + 0.03, x2 - 0.1) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1_N
  l10 = rect li xspan=(x1 + L + 0.055, x2 - 0.1) yspan=(nb + WN + 0.11, pt - WP + 0.21) net=B1_N
  l11 = rect li xspan=(x3 + 0.065, x3 + L + 0.09) yspan=(nb + 0.02, pt - WP + 0.21) net=X
  l12 = rect li xspan=(x3 + 0.065, x4 - 0.055) yspan=(nb + 0.02, nb + 0.23 + 0.13) net=X
  l13 = rect li xspan=(x3 + 0.065, x5 + 0.05) yspan=(pt - WP + 0.01, pt - WP + 0.21) net=X
  l14 = rect li xspan=(x1 - 0.315, x1 - 0.145) yspan=(nb + 0.23 - 0.035, pt - 0.58 + 0.13) net=n2
  l15 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.23 - 0.035, nb + WN - 0.06) net=n2
  l16 = rect li xspan=(x1 - 0.315, x1) yspan=(pt - WP + 0.01, pt - 0.58 + 0.13) net=n2
  l17 = rect li xspan=(x1 - 0.315, x6 - 0.31) yspan=(pt - 0.58 - 0.04, pt - 0.58 + 0.13) net=n2
  l18 = rect li xspan=(x5 + L + 0.32, x6 - 0.31) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13) net=n2
  l19 = rect li xspan=(x4 - 0.01, x5 + L + 0.01) yspan=(nb + WN + 0.005, pt - WP - 0.16) net=n1
  l20 = rect li xspan=(x4 + L - 0.015, x6 + 0.035) yspan=(nb + 0.23 + 0.19, nb + 0.23 + 0.36) net=n1
  l21 = rect li xspan=(x4 + L - 0.015, x5 + L + 0.15) yspan=(nb + 0.23 + 0.19, pt - WP - 0.425) net=n1
  l22 = rect li xspan=(x6 - 0.305, x6 + 0.035) yspan=(nb + 0.02, nb + 0.23 + 0.36) net=n1
  l23 = rect li xspan=(x6 - 0.14, x6 + 0.035) yspan=(nb + 0.02, pt - 0.58 + 0.13) net=n1
  l24 = rect li xspan=(x6 - 0.14, x8 + 0.005) yspan=(pt - WP - 0.03, pt - 0.58 + 0.13) net=n1
  l25 = rect li xspan=(x6 + L + 0.015, x8 + 0.005) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l26 = rect li xspan=(x1 + L - 0.025, x3 + 0.03) yspan=(pt - 0.28, H + 0.085) net=VPWR
  l27 = rect li xspan=(x4 + L - 0.025, x6 - 0.015) yspan=(pt - 0.28, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L - 0.03, x10 + L + 0.25) yspan=(pt - 0.58 - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x5 + L + 0.13) span=(-0.085, nb + 0.23 + 0.02) net=VGND
  c2 = array licon in=nd3 cx=(x6 - 0.14) span=(nb + 0.02, nb + 0.23 + 0.36) net=n1
  c3 = array licon in=nd3 cx=(x9 - 0.085) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.035, nb + WN + 0.02) net=n4
  c5 = array licon in=nd2 cx=(x3 + L + 0.13) span=(nb + 0.02 + 0.08, nb + 0.23 + 0.13 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd3 cx=(x7 - 0.14) span=(nb + 0.23 - 0.1 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.23 - 0.035 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c8 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=pd2 cx=(x4 - 0.13) span=(pt - WP + 0.01, pt - WP + 0.21) margin=0.04 net=X
  c10 = array licon in=pd2 cx=(x7 - 0.135) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 + 0.13 - 0.08) net=n2
  c12 = array licon in=pd2 cx=(x10 + L + 0.085) span=(pt - 0.58 - 0.03, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd2 cx=(x2 - 0.13) span=(pt - 0.28, H + 0.085) net=VPWR
  c14 = array licon in=pd2 cx=(x5 + L + 0.16) span=(pt - 0.28, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x6 - 0.18) span=(pt - 0.28, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.035) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + L/2 + 0.005) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x6 - 0.395) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 + L - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x5 + L + 0.165) cy=0
  mc5 = contact mcon cx=(x6 - 0.175) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.145) cy=0
  mc7 = contact mcon cx=(x9 - 0.095) cy=0
  mc8 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.125) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.165) cy=H
  mc13 = contact mcon cx=(x6 - 0.175) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.145) cy=H
  mc15 = contact mcon cx=(x9 - 0.095) cy=H
  mc16 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l7
  port B1_N in on=l9
  port X out on=l12
end
