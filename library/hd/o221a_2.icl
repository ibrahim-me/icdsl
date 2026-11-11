# o221a_2: lifted from sky130_fd_sc_hd__o221a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o221a_2 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M1 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=n1 g=C1 s=n3 b=VNB
  device M3 nmos w=WN l=L d=n2 g=B2 s=n3 b=VNB
  device M4 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M5 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M6 pmos w=WP l=L d=n4 g=B2 s=n1 b=VPB
  device M7 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M8 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=n1 g=A2 s=n5 b=VPB
  device M10 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M12 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M13 pmos w=WP l=L d=n1 g=C1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.56
  x2 = x1 + L + 0.28
  x3 = x2 + 0.06
  x4 = x3 + L + 0.22
  x5 = x4 + 0.015
  x6 = x5 + L + 0.785
  x7 = x6 + L + 0.22
  x8 = x7 + 0.06
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.37, x5 + L + 0.25) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x6 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.33, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.435, x1 + L) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.065, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x5 + L + 0.205) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6 - 0.225, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x7, x8 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.035, x5 + L + 0.3) yspan=(nb + 0.06, nb + 0.23) net=n3
  l2 = rect li xspan=(x2 + L - 0.04, x5 + 0.06) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n2
  l3 = rect li xspan=(x2 + L - 0.04, x8 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l4 = rect li xspan=(x6 + L - 0.03, x8 + 0.03) yspan=(nb + 0.035, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x6 - 0.225, x6 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l7 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(-0.085, nb + 0.33) net=VGND
  l8 = rect li xspan=(x2 - 0.095, x3 + L + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B1
  l9 = rect li xspan=(x7 - 0.065, x9 - 0.105) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l10 = rect li xspan=(x1 - 0.475, x1 - 0.215) yspan=(nb + WN + 0.09, pt - WP - 0.16) net=C1
  l11 = rect li xspan=(x4 + 0.005, x5 + L + 0.235) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l12 = rect li xspan=(x4 + L - 0.045, x5 + L + 0.235) yspan=(nb + WN + 0.19, pt - WP + 0.22) net=B2
  l13 = rect li xspan=(x6 - 0.36, x6 - 0.055) yspan=(nb + WN + 0.19, pt - WP + 0.22) net=A2
  l14 = rect li xspan=(x6 - 0.36, x6 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l15 = rect li xspan=(x1 - 0.39, x1 - 0.06) yspan=(nb + 0.02, nb + WN - 0.08) net=n1
  l16 = rect li xspan=(x1 - 0.39, x1 + L + 0.015) yspan=(nb + WN - 0.25, nb + WN - 0.08) net=n1
  l17 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l18 = rect li xspan=(x1 - 0.015, x1 + L + 0.015) yspan=(nb + WN - 0.25, pt - WP + 0.185) net=n1
  l19 = rect li xspan=(x1 - 0.015, x4 - 0.07) yspan=(pt - WP - 0.04, pt - WP + 0.185) net=n1
  l20 = rect li xspan=(x3 + L - 0.025, x4 - 0.07) yspan=(pt - WP - 0.04, pt - 0.44) net=n1
  l21 = rect li xspan=(x3 + L - 0.025, x7 - 0.075) yspan=(pt - WP + 0.39, pt - 0.44) net=n1
  l22 = rect li xspan=(x4 + L + 0.005, x6 - 0.035) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l23 = rect li xspan=(x6 + L - 0.03, x9 + L + 0.095) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l24 = rect li xspan=(x6 + L - 0.03, x7 - 0.075) yspan=(pt - WP - 0.03, pt - 0.44) net=n1
  l25 = rect li xspan=(x9 + 0.07, x10 - 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=n1
  l26 = rect li xspan=(x9 + 0.07, x9 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=n1
  l27 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.03, nb + WN + 0.02) net=X
  l28 = rect li xspan=(x9 + L - 0.03, x10 + L + 0.315) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=X
  l29 = rect li xspan=(x9 + L - 0.03, x10 - 0.055) yspan=(pt - WP + 0.39, pt - 0.02) net=X
  l30 = rect li xspan=(x9 + L - 0.03, x10 + L + 0.315) yspan=(pt - WP + 0.39, pt - WP + 0.56) net=X
  l31 = rect li xspan=(x10 + L, x10 + L + 0.315) yspan=(nb + WN - 0.15, pt - WP + 0.56) net=X
  l32 = rect li xspan=(x1 + L + 0.05, x2 + 0.015) yspan=(pt - 0.635, H + 0.085) net=VPWR
  l33 = rect li xspan=(x8 + 0.04, x9 - 0.055) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l34 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.315) yspan=(pt - 0.27, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.225) span=(nb + 0.02, nb + WN - 0.08) margin=0.04 net=n1
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n3
  c3 = array licon in=nd1 cx=(x5 + L + 0.125) span=(nb + 0.06, nb + 0.23) net=n3
  c4 = array licon in=nd2 cx=(x6 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c5 = array licon in=nd2 cx=(x7 - 0.08) span=(nb + 0.035, nb + WN + 0.02) margin=0.04 net=n2
  c6 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.03, nb + WN + 0.02) margin=0.04 net=X
  c8 = array licon in=nd2 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) net=VGND
  c9 = array licon in=nd1 cx=(x3 + L + 0.08) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x6 - 0.14) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x8 + L + 0.08) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c15 = array licon in=pd1 cx=(x2 - 0.105) span=(pt - 0.635 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c16 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - 0.27, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.3) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.07) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x6 - 0.09) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.09) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.56, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.33) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.015) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.025) cy=0
  mc4 = contact mcon cx=(x5 + L + 0.055) cy=0
  mc5 = contact mcon cx=(x6 - 0.27) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.05) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.09) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.33) cy=H
  mc11 = contact mcon cx=(x1 + L - 0.015) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.025) cy=H
  mc13 = contact mcon cx=(x5 + L + 0.055) cy=H
  mc14 = contact mcon cx=(x6 - 0.27) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.05) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.09) cy=H
  mc17 = contact mcon cx=(x9 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l9
  port A2 in on=l13
  port B1 in on=l8
  port B2 in on=l12
  port C1 in on=l10
  port X out on=l31
end
