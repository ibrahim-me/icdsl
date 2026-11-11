# a2111oi_2: lifted from sky130_fd_sc_hd__a2111oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2111oi_2 width=15 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=D1 s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M3 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M4 nmos w=WN l=L d=Y g=D1 s=VGND b=VNB
  device M5 pmos w=WP l=L d=n3 g=C1 s=n4 b=VPB
  device M6 pmos w=WP l=L d=n3 g=B1 s=n1 b=VPB
  device M7 nmos w=WN l=L d=VGND g=C1 s=Y b=VNB
  device M8 pmos w=WP l=L d=Y g=D1 s=n5 b=VPB
  device M9 pmos w=WP l=L d=n4 g=D1 s=Y b=VPB
  device M10 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M11 pmos w=WP l=L d=n1 g=B1 s=n3 b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M13 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M14 pmos w=WP l=L d=n5 g=C1 s=n3 b=VPB
  device M15 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M16 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M17 nmos w=WN l=L d=n6 g=A2 s=VGND b=VNB
  device M18 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M19 nmos w=WN l=L d=Y g=A1 s=n6 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.43
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + 0.11
  x6 = x5 + L + 0.22
  x7 = x6 + 0.115
  x8 = x7 + L + 0.175
  x9 = x8 + L + 0.085
  x10 = x9 + L + 0.29
  x11 = x10 + L + 0.155
  x12 = x11 + L + 0.265
  x13 = x12 + 0.025
  x14 = x13 + L + 0.29
  x15 = x14 + 0.04
  x16 = x15 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.29, x16 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.29, x9 + L + 0.04) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x10 + 0.035, x16 + L + 0.34) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.305, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.075, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.075, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x10, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.16)
  p18 = rect poly xspan=(x12, x15 + L + 0.075) yspan=(nb + WN + 0.105, pt - WP - 0.16)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.105, H - 0.105)
  p20 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.105, H - 0.105)
  p21 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.16)
  p22 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p23 = rect poly xspan=(x16, x16 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x3 + L + 0.035, x5 - 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x7 + L + 0.02, x8 + L + 0.035) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x12 + L + 0.005, x15 - 0.01) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x2 - 0.105, x3 + L - 0.01) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=D1
  l6 = rect li xspan=(x6, x9 + 0.015) yspan=(nb + WN + 0.145, pt - WP - 0.21) net=B1
  l7 = rect li xspan=(x12, x15 + L + 0.115) yspan=(nb + WN + 0.13, pt - WP - 0.21) net=A2
  l8 = rect li xspan=(x10 + L + 0.05, x11 + L) yspan=(nb + WN + 0.1, pt - WP + 0.19) net=A1
  l9 = rect li xspan=(x10 + L + 0.05, x16 + L + 0.25) yspan=(pt - WP - 0.04, pt - WP + 0.19) net=A1
  l10 = rect li xspan=(x16, x16 + L + 0.25) yspan=(nb + WN + 0.11, pt - WP + 0.19) net=A1
  l11 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(nb + WN + 0.16, pt - WP + 0.195) net=C1
  l12 = rect li xspan=(x1 - 0.305, x5 - 0.025) yspan=(pt - WP - 0.04, pt - WP + 0.195) net=C1
  l13 = rect li xspan=(x4 - 0.105, x5 + L) yspan=(nb + WN + 0.145, pt - WP - 0.21) net=C1
  l14 = rect li xspan=(x4 - 0.105, x5 - 0.025) yspan=(nb + WN + 0.145, pt - WP + 0.195) net=C1
  l15 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(nb + 0.02, nb + WN - 0.04) net=Y
  l16 = rect li xspan=(x1 - 0.31, x16 + L + 0.315) yspan=(nb + 0.38, nb + WN - 0.08) net=Y
  l17 = rect li xspan=(x1 - 0.31, x10 - 0.02) yspan=(nb + 0.38, nb + WN - 0.04) net=Y
  l18 = rect li xspan=(x2 + 0.045, x6 - 0.05) yspan=(pt - WP + 0.365, pt - WP + 0.62) net=Y
  l19 = rect li xspan=(x2 + L + 0.05, x3 + 0.01) yspan=(nb + 0.02, nb + WN - 0.04) net=Y
  l20 = rect li xspan=(x5 + L - 0.01, x7 - 0.005) yspan=(nb + 0.02, nb + WN - 0.04) net=Y
  l21 = rect li xspan=(x5 + L - 0.005, x10 - 0.02) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=Y
  l22 = rect li xspan=(x5 + L - 0.005, x6 - 0.05) yspan=(pt - WP - 0.04, pt - WP + 0.62) net=Y
  l23 = rect li xspan=(x9 + L - 0.025, x10 + 0.025) yspan=(nb + 0.04, nb + WN - 0.08) net=Y
  l24 = rect li xspan=(x9 + L + 0.04, x10 - 0.02) yspan=(nb + 0.04, pt - WP + 0.14) net=Y
  l25 = rect li xspan=(x16 + L - 0.025, x16 + L + 0.315) yspan=(nb + 0.06, nb + WN - 0.08) net=Y
  l26 = rect li xspan=(x1 - 0.33, x1 + 0.035) yspan=(pt - WP + 0.385, pt - 0.02) net=n3
  l27 = rect li xspan=(x1 - 0.33, x6) yspan=(pt - 0.21, pt - 0.02) net=n3
  l28 = rect li xspan=(x1 - 0.33, x9 + L - 0.005) yspan=(pt - 0.19, pt - 0.02) net=n3
  l29 = rect li xspan=(x9 - 0.03, x9 + L - 0.005) yspan=(pt - 0.35, pt - 0.02) net=n3
  l30 = rect li xspan=(x7 + 0.01, x10 + 0.065) yspan=(pt - WP + 0.31, pt - 0.52) net=n1
  l31 = rect li xspan=(x7 + 0.01, x8 + 0.025) yspan=(pt - WP + 0.31, pt - 0.425) net=n1
  l32 = rect li xspan=(x10 - 0.12, x16 + L + 0.36) yspan=(pt - WP + 0.36, pt - WP + 0.61) net=n1
  l33 = rect li xspan=(x10 - 0.12, x11 - 0.05) yspan=(pt - WP + 0.36, pt - 0.02) net=n1
  l34 = rect li xspan=(x13 + L + 0.05, x14 - 0.03) yspan=(pt - WP + 0.36, pt - 0.02) net=n1
  l35 = rect li xspan=(x13 + L + 0.05, x16 + L + 0.36) yspan=(pt - WP + 0.36, pt - WP + 0.62) net=n1
  l36 = rect li xspan=(x16 + L + 0.03, x16 + L + 0.36) yspan=(pt - WP + 0.36, pt - 0.02) net=n1
  l37 = rect li xspan=(x11 + L - 0.025, x13 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l38 = rect li xspan=(x14 + L - 0.005, x16 + 0.005) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 - 0.09) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x8 + 0.015) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x14 - 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x9 + L + 0.145) span=(nb + 0.04 + 0.08, pt - WP + 0.14 - 0.08) margin=0.04 net=Y
  c6 = array licon in=nd1 cx=(x16 + L + 0.145) span=(nb + 0.06, nb + WN - 0.08) net=Y
  c7 = array licon in=nd1 cx=(x6 - 0.06) span=(nb + 0.02, nb + WN - 0.04) margin=0.04 net=Y
  c8 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=Y
  c10 = array licon in=pd2 cx=(x10 + L + 0.015) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) net=n1
  c11 = array licon in=pd2 cx=(x13 + L + 0.145) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x7 + L + 0.03) span=(pt - WP + 0.31, pt - 0.425) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.365, pt - WP + 0.62) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.385, pt - 0.02) margin=0.04 net=n3
  c15 = array licon in=pd2 cx=(x16 + L + 0.195) span=(pt - WP + 0.36, pt - 0.02) margin=0.04 net=n1
  c16 = array licon in=pd1 cx=(x9 + 0.06) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) net=n3
  c17 = array licon in=pd1 cx=(x5 + L + 0.035) span=(pt - 0.21, pt - 0.02) margin=0.04 net=n3
  c18 = array licon in=pd2 cx=(x12 - 0.12) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c19 = array licon in=pd2 cx=(x15 + L + 0.125) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.03) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 - 0.045) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L/2) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x11 - 0.02) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x13 + L + 0.04) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x14 + L/2 + 0.02) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x16 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.43, x16 + L + 0.48) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.2) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.12) cy=0
  mc3 = contact mcon cx=(x3 - 0.14) cy=0
  mc4 = contact mcon cx=(x4 - 0.11) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.1) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.085) cy=0
  mc7 = contact mcon cx=(x9 + L) cy=0
  mc8 = contact mcon cx=(x10 + L + 0.035) cy=0
  mc9 = contact mcon cx=(x12 - 0.065) cy=0
  mc10 = contact mcon cx=(x14 - 0.06) cy=0
  mc11 = contact mcon cx=(x16 - 0.07) cy=0
  mc12 = contact mcon cx=(x16 + L + 0.25) cy=0
  mc13 = contact mcon cx=(x1 - 0.2) cy=H
  mc14 = contact mcon cx=(x1 + L + 0.12) cy=H
  mc15 = contact mcon cx=(x3 - 0.14) cy=H
  mc16 = contact mcon cx=(x4 - 0.11) cy=H
  mc17 = contact mcon cx=(x5 + L + 0.1) cy=H
  mc18 = contact mcon cx=(x7 + L + 0.085) cy=H
  mc19 = contact mcon cx=(x9 + L) cy=H
  mc20 = contact mcon cx=(x10 + L + 0.035) cy=H
  mc21 = contact mcon cx=(x12 - 0.065) cy=H
  mc22 = contact mcon cx=(x14 - 0.06) cy=H
  mc23 = contact mcon cx=(x16 - 0.07) cy=H
  mc24 = contact mcon cx=(x16 + L + 0.25) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l9
  port A2 in on=l7
  port B1 in on=l6
  port C1 in on=l12
  port D1 in on=l5
  port Y out on=l21
end
