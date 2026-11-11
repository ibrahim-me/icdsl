# o32a_1: lifted from sky130_fd_sc_hd__o32a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o32a_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M2 nmos w=WN l=L d=n1 g=B1 s=n3 b=VNB
  device M3 pmos w=WP l=L d=n2 g=A2 s=n4 b=VPB
  device M4 pmos w=WP l=L d=n1 g=B2 s=n5 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M7 nmos w=WN l=L d=n3 g=B2 s=n1 b=VNB
  device M8 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M9 pmos w=WP l=L d=n4 g=A3 s=n1 b=VPB
  device M10 pmos w=WP l=L d=n5 g=B1 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.57
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.34
  x4 = x3 + L + 0.4
  x5 = x4 + L + 0.4
  x6 = x5 + L + 0.42
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.295) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.34, x6 + L + 0.295) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.185, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x6, x6 + L + 0.32) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + WN - 0.24) net=VGND
  l2 = rect li xspan=(x3 + L + 0.035, x4 - 0.035) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x2 + L + 0.01, x3 + 0.005) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l4 = rect li xspan=(x2 + L + 0.01, x5 - 0.01) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l5 = rect li xspan=(x4 + L + 0.06, x6 + L + 0.345) yspan=(nb + 0.02, nb + 0.23) net=n3
  l6 = rect li xspan=(x4 + L + 0.06, x5 - 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l7 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.345) yspan=(nb + 0.02, nb + WN - 0.15) net=n3
  l8 = rect li xspan=(x2 + 0.02, x2 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l9 = rect li xspan=(x2 + 0.02, x2 + L + 0.125) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A1
  l10 = rect li xspan=(x6 + L + 0.07, x6 + L + 0.345) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l11 = rect li xspan=(x4 - 0.03, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.175) net=A3
  l12 = rect li xspan=(x5 - 0.11, x5 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.175) net=B2
  l13 = rect li xspan=(x3, x3 + L + 0.2) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l14 = rect li xspan=(x3 + 0.02, x3 + L + 0.2) yspan=(nb + WN + 0.11, pt - WP + 0.64) net=A2
  l15 = rect li xspan=(x1 - 0.485, x1 - 0.31) yspan=(nb + 0.02, pt - 0.03) net=X
  l16 = rect li xspan=(x1 - 0.485, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l17 = rect li xspan=(x1 - 0.485, x1 - 0.1) yspan=(pt - WP + 0.01, pt - 0.03) net=X
  l18 = rect li xspan=(x1 - 0.125, x1 + 0.07) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l19 = rect li xspan=(x1 - 0.125, x1 + L + 0.1) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n1
  l20 = rect li xspan=(x1 + L/2, x1 + L + 0.1) yspan=(nb + WN + 0.19, pt - WP + 0.18) net=n1
  l21 = rect li xspan=(x1 + L/2, x3 - 0.155) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l22 = rect li xspan=(x2 + L + 0.015, x3 - 0.155) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l23 = rect li xspan=(x2 + L + 0.015, x5 - 0.04) yspan=(pt - 0.19, pt - 0.02) net=n1
  l24 = rect li xspan=(x4 + L + 0.03, x6 + 0.03) yspan=(pt - WP + 0.35, pt - 0.4) net=n1
  l25 = rect li xspan=(x4 + L + 0.03, x5 - 0.04) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l26 = rect li xspan=(x5 + L + 0.02, x6 + 0.03) yspan=(nb + 0.4, nb + WN - 0.06) net=n1
  l27 = rect li xspan=(x6 - 0.145, x6 + 0.03) yspan=(nb + 0.4, pt - 0.4) net=n1
  l28 = rect li xspan=(x1 + L - 0.03, x2 - 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l29 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.345) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.06) net=X
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.24 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 - 0.165) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n3
  c4 = array licon in=nd1 cx=(x3 + L + 0.2) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x5 - 0.175) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n3
  c6 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.15 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x5 + L + 0.185) span=(nb + 0.4, nb + WN - 0.06) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x1 - 0.185) span=(pt - WP + 0.01 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x4 + L + 0.195) span=(pt - WP + 0.35, pt - 0.02) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 - 0.02) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L - 0.045) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.57, x6 + L + 0.43) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.34) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.025) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.02) cy=0
  mc4 = contact mcon cx=(x3 + L - 0.005) cy=0
  mc5 = contact mcon cx=(x4 + 0.065) cy=0
  mc6 = contact mcon cx=(x5 - 0.02) cy=0
  mc7 = contact mcon cx=(x6 - 0.12) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.2) cy=0
  mc9 = contact mcon cx=(x1 - 0.34) cy=H
  mc10 = contact mcon cx=(x1 + L - 0.025) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.02) cy=H
  mc12 = contact mcon cx=(x3 + L - 0.005) cy=H
  mc13 = contact mcon cx=(x4 + 0.065) cy=H
  mc14 = contact mcon cx=(x5 - 0.02) cy=H
  mc15 = contact mcon cx=(x6 - 0.12) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.2) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l13
  port A3 in on=l11
  port B1 in on=l10
  port B2 in on=l12
  port X out on=l15
end
