# a311o_1: lifted from sky130_fd_sc_hd__a311o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a311o_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M1 nmos w=WN l=L d=VGND g=A3 s=n2 b=VNB
  device M2 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M3 pmos w=WP l=L d=n4 g=C1 s=n3 b=VPB
  device M4 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M5 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=A2 s=n5 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M8 nmos w=WN l=L d=VGND g=C1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M10 nmos w=WN l=L d=n5 g=A1 s=n3 b=VNB
  device M11 pmos w=WP l=L d=n1 g=B1 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + 0.025
  x3 = x2 + L + 0.295
  x4 = x3 + 0.035
  x5 = x4 + L + 0.305
  x6 = x5 + 0.09
  x7 = x6 + L + 0.53
  x8 = x7 + L + 0.335
  x9 = x8 + L + 0.425
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.025, x2 + L + 0.08) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x5, x6 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p10 = rect poly xspan=(x7 - 0.01, x7 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.025, x4 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x8 + L + 0.05, x9 - 0.045) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x4 + 0.015, x5 - 0.1) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l4 = rect li xspan=(x5 + L + 0.025, x6 + L + 0.135) yspan=(nb + WN - 0.135, pt - WP - 0.16) net=A2
  l5 = rect li xspan=(x7 - 0.135, x7 + 0.06) yspan=(nb + WN - 0.12, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x7 - 0.135, x7 + L + 0.07) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x8 + 0.05, x9 - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l8 = rect li xspan=(x9 + L + 0.07, x9 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C1
  l9 = rect li xspan=(x1 - 0.315, x1 - 0.145) yspan=(nb + 0.02, pt - 0.06) net=X
  l10 = rect li xspan=(x1 - 0.315, x1) yspan=(nb + 0.02, nb + WN - 0.215) net=X
  l11 = rect li xspan=(x1 - 0.315, x2 + 0.005) yspan=(pt - 0.7, pt - 0.06) net=X
  l12 = rect li xspan=(x3 + L + 0.01, x8 + 0.005) yspan=(pt - WP + 0.35, pt - 0.48) net=n1
  l13 = rect li xspan=(x3 + L + 0.01, x5 - 0.075) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l14 = rect li xspan=(x7 + L + 0.085, x8 + 0.005) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l15 = rect li xspan=(x2 + 0.005, x3 - 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l16 = rect li xspan=(x2 + L - 0.005, x3 - 0.125) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=n3
  l17 = rect li xspan=(x2 + L - 0.005, x5 - 0.08) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l18 = rect li xspan=(x2 + L - 0.005, x9 + L + 0.225) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l19 = rect li xspan=(x4 + L + 0.055, x8 - 0.08) yspan=(nb + 0.02, nb + 0.19) net=n3
  l20 = rect li xspan=(x4 + L + 0.055, x5 - 0.08) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l21 = rect li xspan=(x7 + L + 0.085, x8 - 0.08) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l22 = rect li xspan=(x7 + L + 0.085, x9 + L + 0.225) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l23 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l24 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.225) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l25 = rect li xspan=(x2 + L + 0.03, x3 - 0.02) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l26 = rect li xspan=(x5 + L/2 + 0.045, x7 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 - 0.105) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x9 - 0.21) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.215 - 0.08) net=X
  c4 = array licon in=nd1 cx=(x8 - 0.165) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c5 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c6 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd1 cx=(x8 - 0.165) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.7, pt - 0.06) net=X
  c10 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x6 + L + 0.05) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x7 - 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.035) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.05) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.115) cy=0
  mc4 = contact mcon cx=(x6 + L + 0.04) cy=0
  mc5 = contact mcon cx=(x7 - 0.03) cy=0
  mc6 = contact mcon cx=(x8 - 0.045) cy=0
  mc7 = contact mcon cx=(x9 - 0.15) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.115) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.04) cy=H
  mc13 = contact mcon cx=(x7 - 0.03) cy=H
  mc14 = contact mcon cx=(x8 - 0.045) cy=H
  mc15 = contact mcon cx=(x9 - 0.15) cy=H
  mc16 = contact mcon cx=(x9 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l4
  port A3 in on=l3
  port B1 in on=l7
  port C1 in on=l8
  port X out on=l9
end
