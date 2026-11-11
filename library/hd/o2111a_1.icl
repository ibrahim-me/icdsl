# o2111a_1: lifted from sky130_fd_sc_hd__o2111a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2111a_1 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=D1 s=n1 b=VPB
  device M1 nmos w=WN l=L d=n2 g=C1 s=n3 b=VNB
  device M2 nmos w=WN l=L d=VGND g=A1 s=n4 b=VNB
  device M3 nmos w=WN l=L d=n1 g=D1 s=n2 b=VNB
  device M4 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M5 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M6 pmos w=WP l=L d=n1 g=C1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n1 g=A2 s=n5 b=VPB
  device M8 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n3 g=B1 s=n4 b=VNB
  device M10 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M11 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.775
  x3 = x2 + 0.07
  x4 = x3 + L + 0.375
  x5 = x4 + L + 0.375
  x6 = x5 + L + 0.105
  x7 = x6 + L + 0.375
  x8 = x7 + 0.06
  x9 = x8 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 - 0.24, x9 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.205) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.05, x3 + L + 0.07) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.19)
  p6 = rect poly xspan=(x4 - 0.035, x4 + L + 0.155) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p9 = rect poly xspan=(x5, x6 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p11 = rect poly xspan=(x7 - 0.125, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L + 0.3) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.01, x1 + L + 0.305) yspan=(-0.085, nb + 0.33) net=VGND
  l2 = rect li xspan=(x7 + L + 0.01, x9 + 0.03) yspan=(-0.085, nb + 0.3) net=VGND
  l3 = rect li xspan=(x6 + L + 0.07, x7 - 0.015) yspan=(nb + 0.02, nb + WN - 0.01) net=n4
  l4 = rect li xspan=(x6 + L + 0.07, x9 + L + 0.32) yspan=(nb + WN - 0.18, nb + WN - 0.01) net=n4
  l5 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.32) yspan=(nb + 0.02, nb + WN - 0.01) net=n4
  l6 = rect li xspan=(x2 - 0.05, x4 - 0.155) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=D1
  l7 = rect li xspan=(x3 + L + 0.01, x4 - 0.155) yspan=(nb + 0.155, pt - WP - 0.16) net=D1
  l8 = rect li xspan=(x4 + 0.03, x4 + L + 0.155) yspan=(nb + 0.155, pt - WP - 0.16) net=C1
  l9 = rect li xspan=(x5 + 0.035, x6 + 0.035) yspan=(nb + 0.155, pt - WP - 0.16) net=B1
  l10 = rect li xspan=(x5 + 0.035, x6 + 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l11 = rect li xspan=(x9 + L - 0.035, x9 + L + 0.3) yspan=(nb + WN + 0.19, pt - WP + 0.175) net=A1
  l12 = rect li xspan=(x7 - 0.125, x9 - 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A2
  l13 = rect li xspan=(x7 + L + 0.03, x9 - 0.06) yspan=(nb + WN + 0.19, pt - 0.07) net=A2
  l14 = rect li xspan=(x1 - 0.305, x1 - 0.045) yspan=(nb + 0.02, pt - 0.02) net=X
  l15 = rect li xspan=(x1 + L - 0.02, x1 + L + 0.325) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n1
  l16 = rect li xspan=(x1 + L + 0.155, x1 + L + 0.325) yspan=(nb + WN - 0.15, pt - WP + 0.18) net=n1
  l17 = rect li xspan=(x1 + L + 0.155, x3 - 0.015) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l18 = rect li xspan=(x1 + L + 0.155, x7 + 0.01) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l19 = rect li xspan=(x2 - 0.29, x3 - 0.015) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l20 = rect li xspan=(x3 + L - 0.025, x4 - 0.065) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l21 = rect li xspan=(x6 + L + 0.13, x7 + 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l22 = rect li xspan=(x1 + L - 0.02, x2 + 0.025) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l23 = rect li xspan=(x4 + L - 0.025, x6 + L - 0.045) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l24 = rect li xspan=(x9 + L - 0.01, x9 + L + 0.32) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x8 + L + 0.08) span=(-0.085 + 0.08, nb + 0.3 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) net=VGND
  c3 = array licon in=nd2 cx=(x2 - 0.115) span=(nb + 0.02, nb + WN + 0.02) net=n1
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c5 = array licon in=nd2 cx=(x7 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.01 - 0.08) margin=0.04 net=n4
  c6 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.01 - 0.08) net=n4
  c7 = array licon in=pd1 cx=(x7 - 0.08) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c9 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x1 + L + 0.15) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x2 - 0.145) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x5 + L - 0.04) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.07) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L - 0.03) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 - 0.04) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.135) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.165) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.085) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.03) cy=0
  mc6 = contact mcon cx=(x5 + L - 0.03) cy=0
  mc7 = contact mcon cx=(x7 - 0.185) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.075) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.175) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc12 = contact mcon cx=(x2 - 0.165) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.085) cy=H
  mc14 = contact mcon cx=(x4 + L + 0.03) cy=H
  mc15 = contact mcon cx=(x5 + L - 0.03) cy=H
  mc16 = contact mcon cx=(x7 - 0.185) cy=H
  mc17 = contact mcon cx=(x8 + L + 0.075) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l11
  port A2 in on=l12
  port B1 in on=l9
  port C1 in on=l8
  port D1 in on=l6
  port X out on=l14
end
