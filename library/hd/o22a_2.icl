# o22a_2: lifted from sky130_fd_sc_hd__o22a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o22a_2 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M1 nmos w=WN l=L d=n1 g=B2 s=n2 b=VNB
  device M2 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n2 g=B1 s=n1 b=VNB
  device M4 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M5 pmos w=WP l=L d=n1 g=A2 s=n3 b=VPB
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M7 pmos w=WP l=L d=n4 g=B2 s=n1 b=VPB
  device M8 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M9 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M10 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=VGND g=n1 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.41
  x2 = x1 + 0.01
  x3 = x2 + L + 0.27
  x4 = x3 + 0.01
  x5 = x4 + L + 0.79
  x6 = x5 + L + 0.22
  x7 = x6 + 0.06
  x8 = x7 + L + 0.39
  x9 = x8 + 0.03
  x10 = x9 + L + 0.22
  x11 = x10 + 0.03
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.255) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x11 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.275, x11 + L + 0.255) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x4 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x5 - 0.28, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x7 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x8 - 0.115, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p15 = rect poly xspan=(x10, x11 + L + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x5 - 0.305, x8 + 0.015) yspan=(nb + 0.06, nb + 0.24) net=n2
  l2 = rect li xspan=(x7 + L + 0.06, x8 + 0.015) yspan=(nb + 0.06, nb + WN - 0.06) net=n2
  l3 = rect li xspan=(x8 - 0.16, x11 + L + 0.31) yspan=(nb + WN - 0.19, nb + WN - 0.02) net=n2
  l4 = rect li xspan=(x10 + L, x11 + L + 0.31) yspan=(nb + 0.045, nb + WN - 0.02) net=n2
  l5 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l6 = rect li xspan=(x4 + L + 0.045, x4 + L + 0.225) yspan=(-0.085, nb + 0.31) net=VGND
  l7 = rect li xspan=(x9 + L + 0.025, x10 - 0.025) yspan=(-0.085, nb + 0.29) net=VGND
  l8 = rect li xspan=(x5 - 0.335, x5 + 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B1
  l9 = rect li xspan=(x5 + L + 0.05, x7 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B2
  l10 = rect li xspan=(x10 - 0.015, x11 + L + 0.31) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=A1
  l11 = rect li xspan=(x10 + L + 0.015, x11 + L + 0.31) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l12 = rect li xspan=(x8 - 0.125, x9 + L + 0.035) yspan=(nb + WN + 0.19, nb + WN + 0.44) net=A2
  l13 = rect li xspan=(x9, x9 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A2
  l14 = rect li xspan=(x9 + L + 0.01, x10 - 0.01) yspan=(pt - WP - 0.04, pt - 0.08) net=A2
  l15 = rect li xspan=(x2 + L + 0.03, x3 - 0.025) yspan=(nb + 0.13, pt - 0.02) net=X
  l16 = rect li xspan=(x3 + L, x4 + L + 0.275) yspan=(nb + WN - 0.17, pt - WP + 0.22) net=n1
  l17 = rect li xspan=(x3 + L, x7 + 0.03) yspan=(nb + WN - 0.17, nb + WN + 0.01) net=n1
  l18 = rect li xspan=(x3 + L, x8 - 0.145) yspan=(pt - WP + 0.01, pt - WP + 0.22) net=n1
  l19 = rect li xspan=(x5 + L - 0.065, x7 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.01) net=n1
  l20 = rect li xspan=(x7 + 0.005, x8 - 0.145) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l21 = rect li xspan=(x1 - 0.295, x1 - 0.045) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.015, x5 + 0.03) yspan=(pt - 0.61, H + 0.085) net=VPWR
  l23 = rect li xspan=(x10 + L + 0.015, x11 + L + 0.31) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x9 + L + 0.11) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.13) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x5 - 0.14) span=(nb + 0.06, nb + 0.24) net=n2
  c5 = array licon in=nd2 cx=(x8 - 0.165) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=n2
  c6 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.045, nb + WN - 0.02) net=n2
  c7 = array licon in=nd1 cx=(x2 + L + 0.13) span=(nb + 0.13 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd2 cx=(x6 - 0.08) span=(nb + WN - 0.24, nb + WN + 0.01) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x1 - 0.13) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x3 - 0.13) span=(nb + 0.13 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x7 + L + 0.08) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x4 + L + 0.18) span=(pt - 0.61, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x5 - 0.14) span=(pt - 0.61, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x11 + L + 0.11) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x4 + L + 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 - 0.145) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x6 + L - 0.015) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x9 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x11 + L + 0.01) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.41, x11 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.18) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x5 - 0.16) cy=0
  mc5 = contact mcon cx=(x6 - 0.06) cy=0
  mc6 = contact mcon cx=(x8 - 0.19) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.1) cy=0
  mc8 = contact mcon cx=(x11 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.18) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.17) cy=H
  mc12 = contact mcon cx=(x5 - 0.16) cy=H
  mc13 = contact mcon cx=(x6 - 0.06) cy=H
  mc14 = contact mcon cx=(x8 - 0.19) cy=H
  mc15 = contact mcon cx=(x9 + L + 0.1) cy=H
  mc16 = contact mcon cx=(x11 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l14
  port B1 in on=l8
  port B2 in on=l9
  port X out on=l15
end
