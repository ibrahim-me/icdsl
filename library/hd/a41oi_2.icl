# a41oi_2: lifted from sky130_fd_sc_hd__a41oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a41oi_2 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A1 s=Y b=VNB
  device M1 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB
  device M2 nmos w=WN l=L d=n3 g=A2 s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A4 s=n2 b=VPB
  device M4 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M5 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=n2 g=A4 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n4 g=A4 s=VGND b=VNB
  device M8 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A3 s=n2 b=VPB
  device M11 nmos w=WN l=L d=n1 g=A2 s=n3 b=VNB
  device M12 nmos w=WN l=L d=n4 g=A3 s=n3 b=VNB
  device M13 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M14 nmos w=WN l=L d=n3 g=A3 s=n4 b=VNB
  device M15 pmos w=WP l=L d=n2 g=A3 s=VPWR b=VPB
  device M16 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M17 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  device M18 nmos w=WN l=L d=VGND g=A4 s=n4 b=VNB
  device M19 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.49
  x2 = x1 + L + 0.28
  x3 = x2 + 0.1
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.3
  x10 = x9 + L + 0.36
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 - 0.115) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 + L + 0.015, x9 - 0.035) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x9 + L + 0.095, x13 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 + L + 0.115, x13 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x5 - 0.065, x6 + L + 0.045) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7 - 0.025, x8 + L + 0.085) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x11 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.19)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x12 - 0.065, x13 + L + 0.425) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p18 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x13, x13 + L + 0.425) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x7 + L - 0.03, x11 + 0.03) yspan=(nb + 0.06, nb + 0.23) net=n3
  l2 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x3 + 0.02, x4 - 0.055) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l5 = rect li xspan=(x4 + L - 0.03, x7 - 0.055) yspan=(nb + 0.06, nb + 0.23) net=n1
  l6 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.06, nb + WN - 0.07) net=n1
  l7 = rect li xspan=(x6 + L + 0.055, x9 + 0.01) yspan=(nb + WN - 0.24, nb + WN - 0.07) net=n1
  l8 = rect li xspan=(x9 + L + 0.055, x13 + L + 0.225) yspan=(nb + 0.41, nb + WN - 0.07) net=n4
  l9 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.225) yspan=(nb + 0.02, nb + WN - 0.07) net=n4
  l10 = rect li xspan=(x1 + 0.06, x4 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.205) net=B1
  l11 = rect li xspan=(x7 - 0.025, x8 + L + 0.115) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l12 = rect li xspan=(x5 - 0.065, x6 + L + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=A1
  l13 = rect li xspan=(x9, x11 + L - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=A3
  l14 = rect li xspan=(x12 - 0.135, x13 + L + 0.445) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=A4
  l15 = rect li xspan=(x1 - 0.345, x6 + 0.03) yspan=(nb + 0.41, nb + WN - 0.07) net=Y
  l16 = rect li xspan=(x1 - 0.345, x1 - 0.175) yspan=(nb + 0.41, pt - WP + 0.14) net=Y
  l17 = rect li xspan=(x1 - 0.345, x4 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=Y
  l18 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.02, nb + WN - 0.07) net=Y
  l19 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=Y
  l20 = rect li xspan=(x2 - 0.125, x2 + 0.05) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l21 = rect li xspan=(x2 - 0.125, x5 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n2
  l22 = rect li xspan=(x4 + L + 0.055, x13 + L + 0.31) yspan=(pt - WP + 0.05, pt - WP + 0.22) net=n2
  l23 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP + 0.05, pt - 0.02) net=n2
  l24 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP + 0.05, pt - 0.02) net=n2
  l25 = rect li xspan=(x8 + L + 0.075, x9 - 0.055) yspan=(pt - WP + 0.05, pt - 0.02) net=n2
  l26 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - WP + 0.05, pt - 0.02) net=n2
  l27 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.225) yspan=(pt - WP + 0.05, pt - 0.02) net=n2
  l28 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l29 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l30 = rect li xspan=(x9 + L + 0.065, x11 - 0.045) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l31 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.04) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.06, nb + 0.23) net=n1
  c4 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n3
  c5 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n3
  c6 = array licon in=nd3 cx=(x12 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) margin=0.04 net=Y
  c8 = array licon in=nd3 cx=(x13 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) net=n4
  c9 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.06 + 0.08, nb + WN - 0.07 - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.41, nb + WN - 0.07) margin=0.04 net=Y
  c11 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + WN - 0.24, nb + WN - 0.07) net=n1
  c12 = array licon in=nd3 cx=(x10 - 0.14) span=(nb + 0.41, nb + WN - 0.07) net=n4
  c13 = array licon in=nd3 cx=(x11 + L + 0.14) span=(nb + 0.41, nb + WN - 0.07) margin=0.04 net=n4
  c14 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.03, pt - WP + 0.64) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x2 - 0.04) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c17 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x9 - 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c19 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c20 = array licon in=pd1 cx=(x13 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=n2
  c21 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x10 - 0.13) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x10 + L + 0.07) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x12 + L + 0.14) span=(pt - 0.57, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.08) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.04) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.045) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + 0.025) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L - 0.005) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 + 0.065) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x9 + L + 0.02) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + 0.025) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x11 - 0.06) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x12 + L - 0.005) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x13 + 0.065) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x13 + L + 0.26) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.49, x13 + L + 0.53) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.26) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.06) cy=0
  mc3 = contact mcon cx=(x3 + L - 0.005) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.04) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.08) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.12) cy=0
  mc7 = contact mcon cx=(x8 - 0.12) cy=0
  mc8 = contact mcon cx=(x9 - 0.1) cy=0
  mc9 = contact mcon cx=(x10 - 0.14) cy=0
  mc10 = contact mcon cx=(x11 - 0.1) cy=0
  mc11 = contact mcon cx=(x12 - 0.06) cy=0
  mc12 = contact mcon cx=(x13 - 0.02) cy=0
  mc13 = contact mcon cx=(x13 + L + 0.3) cy=0
  mc14 = contact mcon cx=(x1 - 0.26) cy=H
  mc15 = contact mcon cx=(x1 + L + 0.06) cy=H
  mc16 = contact mcon cx=(x3 + L - 0.005) cy=H
  mc17 = contact mcon cx=(x4 + L + 0.04) cy=H
  mc18 = contact mcon cx=(x5 + L + 0.08) cy=H
  mc19 = contact mcon cx=(x6 + L + 0.12) cy=H
  mc20 = contact mcon cx=(x8 - 0.12) cy=H
  mc21 = contact mcon cx=(x9 - 0.1) cy=H
  mc22 = contact mcon cx=(x10 - 0.14) cy=H
  mc23 = contact mcon cx=(x11 - 0.1) cy=H
  mc24 = contact mcon cx=(x12 - 0.06) cy=H
  mc25 = contact mcon cx=(x13 - 0.02) cy=H
  mc26 = contact mcon cx=(x13 + L + 0.3) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l12
  port A2 in on=l11
  port A3 in on=l13
  port A4 in on=l14
  port B1 in on=l10
  port Y out on=l16
end
