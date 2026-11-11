# a311oi_2: lifted from sky130_fd_sc_hd__a311oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a311oi_2 width=15 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=Y g=C1 s=n2 b=VPB
  device M2 nmos w=WN l=L d=n3 g=A1 s=Y b=VNB
  device M3 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M4 nmos w=WN l=L d=n3 g=A2 s=n4 b=VNB
  device M5 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M7 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M8 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M9 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M10 nmos w=WN l=L d=n4 g=A2 s=n3 b=VNB
  device M11 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M12 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M13 nmos w=WN l=L d=VGND g=A3 s=n4 b=VNB
  device M14 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M15 pmos w=WP l=L d=n2 g=C1 s=Y b=VPB
  device M16 nmos w=WN l=L d=n4 g=A3 s=VGND b=VNB
  device M17 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M18 pmos w=WP l=L d=n1 g=A3 s=VPWR b=VPB
  device M19 nmos w=WN l=L d=VGND g=C1 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + 0.01
  x6 = x5 + L + 0.3
  x7 = x6 + L + 0.28
  x8 = x7 + 0.07
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.31
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.53
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 - 0.045) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x6 + L + 0.085, x13 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 - 0.085) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 + L + 0.045, x13 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x5 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x6, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x10 - 0.055, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x12, x13 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p18 = rect poly xspan=(x12, x13 + L + 0.29) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x3 + L - 0.03, x9 + 0.03) yspan=(nb + 0.07, nb + 0.24) net=n3
  l5 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l6 = rect li xspan=(x1 - 0.225, x6) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n4
  l7 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l8 = rect li xspan=(x1 - 0.265, x2 - 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l9 = rect li xspan=(x2 + L + 0.095, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l10 = rect li xspan=(x6 - 0.11, x9 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l11 = rect li xspan=(x10 - 0.075, x11 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l12 = rect li xspan=(x12 + L + 0.03, x13 + L + 0.29) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=C1
  l13 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.29) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=C1
  l14 = rect li xspan=(x6 + L + 0.045, x13 + L + 0.225) yspan=(nb + 0.42, nb + WN - 0.06) net=Y
  l15 = rect li xspan=(x9 + L + 0.075, x10 - 0.065) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l16 = rect li xspan=(x11 + L + 0.055, x11 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l17 = rect li xspan=(x11 + L + 0.23, x12 - 0.085) yspan=(nb + 0.42, pt - WP + 0.195) net=Y
  l18 = rect li xspan=(x11 + L + 0.23, x13 + 0.015) yspan=(pt - WP + 0.025, pt - WP + 0.195) net=Y
  l19 = rect li xspan=(x12 + L - 0.045, x13 + 0.015) yspan=(pt - WP + 0.025, pt - WP + 0.6) net=Y
  l20 = rect li xspan=(x12 + L - 0.045, x13 + 0.03) yspan=(pt - WP + 0.09, pt - WP + 0.26) net=Y
  l21 = rect li xspan=(x12 + L - 0.045, x13 + 0.03) yspan=(pt - WP + 0.43, pt - WP + 0.6) net=Y
  l22 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l23 = rect li xspan=(x1 + L + 0.055, x11 + 0.03) yspan=(pt - WP + 0.09, pt - WP + 0.26) net=n1
  l24 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP + 0.09, pt - 0.02) net=n1
  l25 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.09, pt - 0.02) net=n1
  l26 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP + 0.09, pt - 0.02) net=n1
  l27 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(pt - WP + 0.09, pt - WP + 0.6) net=n1
  l28 = rect li xspan=(x9 + L - 0.02, x13 + L + 0.225) yspan=(pt - 0.23, pt - 0.06) net=n2
  l29 = rect li xspan=(x11 + L + 0.08, x12 - 0.12) yspan=(pt - 0.57, pt - 0.02) net=n2
  l30 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.225) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l31 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l32 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l33 = rect li xspan=(x4 + L - 0.02, x6 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l34 = rect li xspan=(x7 + L - 0.03, x9 - 0.045) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x10 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x12 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.07, nb + 0.24) margin=0.04 net=n3
  c5 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.07, nb + 0.24) margin=0.04 net=n3
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n4
  c7 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n4
  c8 = array licon in=nd2 cx=(x10 - 0.15) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c9 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c10 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  c11 = array licon in=nd1 cx=(x5 + L + 0.13) span=(nb + WN - 0.23, nb + WN - 0.06) net=n4
  c12 = array licon in=nd2 cx=(x7 - 0.07) span=(nb + 0.42, nb + WN - 0.06) net=Y
  c13 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c14 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.09, pt - WP + 0.6) margin=0.04 net=n1
  c15 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - WP + 0.025 + 0.08, pt - WP + 0.6 - 0.08) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.09 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c17 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.09 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c18 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.09 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c19 = array licon in=pd2 cx=(x13 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c20 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x8 + L + 0.07) span=(pt - 0.57, H + 0.085) net=VPWR
  c23 = array licon in=pd2 cx=(x11 + L + 0.245) span=(pt - 0.57, pt - 0.02) margin=0.04 net=n2
  c24 = array licon in=pd2 cx=(x10 - 0.14) span=(pt - 0.23, pt - 0.06) net=n2
  gc1 = contact licon cx=(x1 - 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x1 + L + 0.055) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.045) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 - 0.015) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x9 - 0.1) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x10 + L - 0.065) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x11 + 0.005) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x13 - 0.075) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x13 + L + 0.125) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x13 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x6 - 0.04) cy=0
  mc6 = contact mcon cx=(x7 + 0.005) cy=0
  mc7 = contact mcon cx=(x9 - 0.03) cy=0
  mc8 = contact mcon cx=(x10 - 0.02) cy=0
  mc9 = contact mcon cx=(x11 + 0.025) cy=0
  mc10 = contact mcon cx=(x12 - 0.19) cy=0
  mc11 = contact mcon cx=(x12 + L + 0.13) cy=0
  mc12 = contact mcon cx=(x13 + L + 0.17) cy=0
  mc13 = contact mcon cx=(x1 - 0.17) cy=H
  mc14 = contact mcon cx=(x2 - 0.13) cy=H
  mc15 = contact mcon cx=(x3 - 0.09) cy=H
  mc16 = contact mcon cx=(x4 - 0.05) cy=H
  mc17 = contact mcon cx=(x6 - 0.04) cy=H
  mc18 = contact mcon cx=(x7 + 0.005) cy=H
  mc19 = contact mcon cx=(x9 - 0.03) cy=H
  mc20 = contact mcon cx=(x10 - 0.02) cy=H
  mc21 = contact mcon cx=(x11 + 0.025) cy=H
  mc22 = contact mcon cx=(x12 - 0.19) cy=H
  mc23 = contact mcon cx=(x12 + L + 0.13) cy=H
  mc24 = contact mcon cx=(x13 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l9
  port A3 in on=l8
  port B1 in on=l11
  port C1 in on=l12
  port Y out on=l17
end
