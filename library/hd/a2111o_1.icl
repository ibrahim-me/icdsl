# a2111o_1: lifted from sky130_fd_sc_hd__a2111o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2111o_1 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=D1 s=n1 b=VNB
  device M1 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n3 g=B1 s=n2 b=VPB
  device M4 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M5 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M6 nmos w=WN l=L d=n1 g=C1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=B1 s=n1 b=VNB
  device M9 nmos w=WN l=L d=n1 g=A1 s=n4 b=VNB
  device M10 pmos w=WP l=L d=n1 g=D1 s=n5 b=VPB
  device M11 pmos w=WP l=L d=n5 g=C1 s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.43
  x2 = x1 + 0.04
  x3 = x2 + L + 0.855
  x4 = x3 + 0.06
  x5 = x4 + L + 0.26
  x6 = x5 + L + 0.37
  x7 = x6 + L + 0.57
  x8 = x7 + 0.01
  x9 = x8 + L + 0.265
  x10 = x9 + 0.005
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.295, x10 + L + 0.29) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.295, x2 + L + 0.23) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.33, x10 + L + 0.295) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.08, H - 0.105)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.145)
  p3 = rect poly xspan=(x2, x2 + L + 0.35) yspan=(nb + WN + 0.075, pt - WP - 0.145)
  p4 = rect poly xspan=(x3 - 0.145, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L + 0.155) yspan=(nb + WN + 0.11, pt - WP - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.185) yspan=(nb + WN + 0.075, pt - WP - 0.155)
  p11 = rect poly xspan=(x7 - 0.17, x8 + L + 0.02) yspan=(nb + WN + 0.08, pt - WP - 0.16)
  p12 = rect poly xspan=(x7 - 0.17, x7 + L) yspan=(nb + WN + 0.08, pt - WP - 0.155)
  p13 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.08, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p16 = rect poly xspan=(x9, x10 + L + 0.19) yspan=(nb + WN + 0.08, pt - WP - 0.16)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.08, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.025, x3 - 0.155) yspan=(-0.085, nb + 0.235) net=VGND
  l2 = rect li xspan=(x5 + L + 0.02, x6) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x10 + L + 0.01, x10 + L + 0.25) yspan=(-0.085, nb + WN - 0.125) net=VGND
  l4 = rect li xspan=(x9 - 0.05, x10 + L + 0.305) yspan=(nb + WN + 0.14, pt - WP - 0.195) net=A2
  l5 = rect li xspan=(x7 - 0.24, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x7 - 0.16, x7 + L) yspan=(nb + 0.05, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x7 - 0.16, x9 - 0.02) yspan=(nb + 0.05, nb + 0.61) net=A1
  l8 = rect li xspan=(x1 - 0.295, x1 - 0.04) yspan=(nb + 0.02, pt - 0.025) net=X
  l9 = rect li xspan=(x1 - 0.295, x2) yspan=(nb + 0.02, pt - WP + 0.135) net=X
  l10 = rect li xspan=(x2 + L + 0.085, x2 + L + 0.305) yspan=(nb + 0.415, pt - WP + 0.16) net=n1
  l11 = rect li xspan=(x2 + L + 0.085, x5 - 0.01) yspan=(nb + 0.415, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x2 + L + 0.085, x6 + L + 0.23) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l13 = rect li xspan=(x2 + L + 0.085, x3 - 0.12) yspan=(pt - WP - 0.02, pt - WP + 0.16) net=n1
  l14 = rect li xspan=(x3 - 0.33, x3 - 0.12) yspan=(pt - WP - 0.02, pt - 0.025) net=n1
  l15 = rect li xspan=(x3 + L - 0.025, x5 - 0.01) yspan=(nb + 0.025, nb + WN - 0.06) net=n1
  l16 = rect li xspan=(x6 + L + 0.025, x6 + L + 0.23) yspan=(nb + 0.025, nb + WN - 0.06) net=n1
  l17 = rect li xspan=(x6 + L + 0.285, x7 + 0.005) yspan=(pt - WP + 0.01, pt - 0.025) net=n2
  l18 = rect li xspan=(x6 + L + 0.285, x10 + L + 0.285) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l19 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.285) yspan=(pt - WP + 0.01, pt - 0.025) net=n2
  l20 = rect li xspan=(x3 - 0.175, x4 + L + 0.055) yspan=(nb + WN + 0.165, pt - WP - 0.195) net=D1
  l21 = rect li xspan=(x4 - 0.005, x4 + L + 0.055) yspan=(nb + WN + 0.165, pt - 0.02) net=D1
  l22 = rect li xspan=(x5 - 0.035, x5 + L + 0.155) yspan=(nb + WN + 0.165, pt - 0.02) net=C1
  l23 = rect li xspan=(x6 - 0.035, x6 + L + 0.105) yspan=(nb + WN + 0.11, pt - 0.02) net=B1
  l24 = rect li xspan=(x1 + L - 0.01, x2 + L + 0.285) yspan=(pt - 0.67, H + 0.085) net=VPWR
  l25 = rect li xspan=(x8 + L + 0.03, x9 - 0.02) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.19) span=(-0.085, nb + 0.235) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 - 0.32) span=(-0.085, nb + 0.235) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.085) span=(nb + 0.025, nb + WN - 0.06) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x1 - 0.13) span=(nb + 0.02 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x5 + L + 0.185) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.125 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.025 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x1 - 0.15) span=(nb + 0.02 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd2 cx=(x3 - 0.205) span=(pt - WP - 0.02 + 0.08, pt - 0.025 - 0.08) net=n1
  c10 = array licon in=pd2 cx=(x7 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n2
  c11 = array licon in=pd2 cx=(x10 + L + 0.15) span=(pt - WP + 0.01 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n2
  c12 = array licon in=pd1 cx=(x2 + L + 0.105) span=(pt - 0.67 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x8 + L + 0.13) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.195) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + 0.01) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + 0.005) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x10 + L) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.43, x10 + L + 0.435) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.2) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.08) cy=0
  mc3 = contact mcon cx=(x3 - 0.315) cy=0
  mc4 = contact mcon cx=(x3 + L) cy=0
  mc5 = contact mcon cx=(x5 + L) cy=0
  mc6 = contact mcon cx=(x6 + L - 0.05) cy=0
  mc7 = contact mcon cx=(x7 - 0.155) cy=0
  mc8 = contact mcon cx=(x9 - 0.11) cy=0
  mc9 = contact mcon cx=(x10 + L + 0.205) cy=0
  mc10 = contact mcon cx=(x1 - 0.2) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.08) cy=H
  mc12 = contact mcon cx=(x3 - 0.315) cy=H
  mc13 = contact mcon cx=(x3 + L) cy=H
  mc14 = contact mcon cx=(x5 + L) cy=H
  mc15 = contact mcon cx=(x6 + L - 0.05) cy=H
  mc16 = contact mcon cx=(x7 - 0.155) cy=H
  mc17 = contact mcon cx=(x9 - 0.11) cy=H
  mc18 = contact mcon cx=(x10 + L + 0.205) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l4
  port B1 in on=l23
  port C1 in on=l22
  port D1 in on=l20
  port X out on=l8
end
