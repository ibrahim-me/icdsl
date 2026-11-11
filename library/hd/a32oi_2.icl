# a32oi_2: lifted from sky130_fd_sc_hd__a32oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a32oi_2 width=17 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=n2 b=VNB
  device M1 nmos w=WN l=L d=Y g=B1 s=n3 b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A3 s=n4 b=VPB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n4 b=VPB
  device M5 nmos w=WN l=L d=n3 g=B1 s=Y b=VNB
  device M6 pmos w=WP l=L d=n4 g=A3 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n4 g=A2 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=B2 s=n3 b=VNB
  device M9 nmos w=WN l=L d=Y g=A1 s=n2 b=VNB
  device M10 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M11 pmos w=WP l=L d=n4 g=B1 s=Y b=VPB
  device M12 nmos w=WN l=L d=n3 g=B2 s=VGND b=VNB
  device M13 nmos w=WN l=L d=n2 g=A2 s=n1 b=VNB
  device M14 nmos w=WN l=L d=n1 g=A3 s=VGND b=VNB
  device M15 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M16 pmos w=WP l=L d=n4 g=B2 s=Y b=VPB
  device M17 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M18 pmos w=WP l=L d=Y g=B2 s=n4 b=VPB
  device M19 pmos w=WP l=L d=Y g=B1 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.435
  x7 = x6 + L + 0.19
  x8 = x7 + 0.09
  x9 = x8 + L + 0.22
  x10 = x9 + 0.07
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.13
  x13 = x12 + L + 0.285
  x14 = x13 + L + 0.16
  x15 = x14 + L + 0.38
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 - 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 + L + 0.17, x12 + L - 0.01) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x13 - 0.02, x15 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x15 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.245, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.065, x4 + L) yspan=(nb + WN + 0.09, pt - WP - 0.19)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.19)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.15, H - 0.105)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.19)
  p14 = rect poly xspan=(x10, x12 + L + 0.06) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.19)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p17 = rect poly xspan=(x13, x15 + L + 0.28) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p18 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p19 = rect poly xspan=(x14, x14 + L) yspan=(0.105, pt - WP - 0.19)
  p20 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x15, x15 + L + 0.28) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x5 + L + 0.13, x12 + L + 0.035) yspan=(nb + 0.06, nb + 0.23) net=n2
  l2 = rect li xspan=(x10 + L - 0.03, x15 - 0.05) yspan=(nb + WN - 0.25, nb + WN - 0.08) net=n1
  l3 = rect li xspan=(x14 + L - 0.005, x15 - 0.05) yspan=(nb + 0.04, nb + WN - 0.08) net=n1
  l4 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(nb + 0.06, nb + 0.23) net=n3
  l5 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.06, nb + WN) net=n3
  l6 = rect li xspan=(x1 - 0.225, x3 - 0.055) yspan=(nb + WN - 0.17, nb + WN) net=n3
  l7 = rect li xspan=(x2 + L - 0.03, x5 + 0.04) yspan=(nb + 0.06, nb + 0.23) net=n3
  l8 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.06, nb + WN) net=n3
  l9 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l10 = rect li xspan=(x13 - 0.065, x14 - 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l11 = rect li xspan=(x15 + L - 0.025, x15 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND
  l12 = rect li xspan=(x2 + L + 0.085, x4 + 0.07) yspan=(nb + WN + 0.195, pt - WP - 0.2) net=B1
  l13 = rect li xspan=(x3 - 0.065, x3 + L + 0.125) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l14 = rect li xspan=(x1 - 0.255, x2 + 0.01) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B2
  l15 = rect li xspan=(x1 - 0.255, x1 - 0.075) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=B2
  l16 = rect li xspan=(x5 + L + 0.195, x8 + L) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=A1
  l17 = rect li xspan=(x10 + L + 0.08, x13 - 0.14) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=A2
  l18 = rect li xspan=(x13 + L - 0.05, x15 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=A3
  l19 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.47, pt - 0.36) net=Y
  l20 = rect li xspan=(x1 + L + 0.055, x5 + L - 0.045) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=Y
  l21 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP - 0.03, pt - 0.36) net=Y
  l22 = rect li xspan=(x3 + L - 0.03, x7 + L/2 + 0.045) yspan=(nb + 0.42, nb + WN - 0.06) net=Y
  l23 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=Y
  l24 = rect li xspan=(x5 - 0.115, x5 + L - 0.045) yspan=(nb + 0.42, pt - WP + 0.14) net=Y
  l25 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l26 = rect li xspan=(x1 - 0.225, x5 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n4
  l27 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l28 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l29 = rect li xspan=(x4 + L + 0.055, x15 + L + 0.225) yspan=(pt - WP + 0.43, pt - WP + 0.6) net=n4
  l30 = rect li xspan=(x8 + L - 0.04, x9 - 0.085) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l31 = rect li xspan=(x12 + L + 0.055, x13 - 0.06) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l32 = rect li xspan=(x15 + L + 0.055, x15 + L + 0.225) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l33 = rect li xspan=(x5 + L + 0.05, x7 - 0.045) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x9 + L - 0.03, x12 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l35 = rect li xspan=(x13 + L, x15) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x14 + L + 0.165) span=(nb + 0.04, nb + WN - 0.08) margin=0.04 net=n1
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06 + 0.08, nb + WN - 0.08) net=n3
  c3 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.06 + 0.08, nb + WN - 0.08) margin=0.04 net=n3
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.06, nb + 0.23) net=n3
  c6 = array licon in=nd2 cx=(x6 - 0.14) span=(nb + 0.06, nb + 0.23) net=n2
  c7 = array licon in=nd2 cx=(x9 - 0.07) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n2
  c8 = array licon in=nd2 cx=(x12 + 0.015) span=(nb + 0.06, nb + 0.23) net=n2
  c9 = array licon in=nd3 cx=(x13 + L - 0.04) span=(-0.085, nb + 0.23) net=VGND
  c10 = array licon in=nd3 cx=(x15 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c11 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + WN - 0.25, nb + WN - 0.08) margin=0.04 net=n1
  c12 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.42, nb + WN - 0.06) margin=0.04 net=Y
  c13 = array licon in=nd2 cx=(x7 - 0.05) span=(nb + 0.42, nb + WN - 0.06) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n4
  c16 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c17 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c19 = array licon in=pd1 cx=(x8 + L + 0.05) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c20 = array licon in=pd1 cx=(x12 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c21 = array licon in=pd1 cx=(x15 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n4
  c22 = array licon in=pd1 cx=(x5 + L + 0.215) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x6 + L - 0.025) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x10 + L + 0.07) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x11 + L - 0.015) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x14 + 0.015) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c27 = array licon in=pd1 cx=(x15 - 0.17) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.08) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x1 + L + 0.12) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.045) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + 0.065) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x11 - 0.035) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x12 + 0.04) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x14 + L - 0.05) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x15 - 0.085) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x15 + L + 0.115) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x15 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 - 0.125) cy=0
  mc7 = contact mcon cx=(x7 + 0.01) cy=0
  mc8 = contact mcon cx=(x9 + 0.02) cy=0
  mc9 = contact mcon cx=(x11 - 0.015) cy=0
  mc10 = contact mcon cx=(x12 + L + 0.035) cy=0
  mc11 = contact mcon cx=(x13 + L + 0.07) cy=0
  mc12 = contact mcon cx=(x15 - 0.15) cy=0
  mc13 = contact mcon cx=(x15 + L + 0.17) cy=0
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x2 - 0.13) cy=H
  mc16 = contact mcon cx=(x3 - 0.09) cy=H
  mc17 = contact mcon cx=(x4 - 0.05) cy=H
  mc18 = contact mcon cx=(x5 - 0.01) cy=H
  mc19 = contact mcon cx=(x6 - 0.125) cy=H
  mc20 = contact mcon cx=(x7 + 0.01) cy=H
  mc21 = contact mcon cx=(x9 + 0.02) cy=H
  mc22 = contact mcon cx=(x11 - 0.015) cy=H
  mc23 = contact mcon cx=(x12 + L + 0.035) cy=H
  mc24 = contact mcon cx=(x13 + L + 0.07) cy=H
  mc25 = contact mcon cx=(x15 - 0.15) cy=H
  mc26 = contact mcon cx=(x15 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l16
  port A2 in on=l17
  port A3 in on=l18
  port B1 in on=l12
  port B2 in on=l14
  port Y out on=l20
end
