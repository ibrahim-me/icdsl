# o311ai_2: lifted from sky130_fd_sc_hd__o311ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o311ai_2 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A3 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A3 s=Y b=VPB
  device M2 nmos w=WN l=L d=Y g=C1 s=n3 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M4 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M5 pmos w=WP l=L d=Y g=A3 s=n2 b=VPB
  device M6 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M8 nmos w=WN l=L d=n3 g=B1 s=n1 b=VNB
  device M9 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M10 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M11 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M12 pmos w=WP l=L d=Y g=C1 s=VPWR b=VPB
  device M13 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M14 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M15 pmos w=WP l=L d=n2 g=A2 s=n4 b=VPB
  device M16 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M17 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M18 nmos w=WN l=L d=n1 g=B1 s=n3 b=VNB
  device M19 pmos w=WP l=L d=n4 g=A2 s=n2 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.52
  x2 = x1 + 0.02
  x3 = x2 + L + 0.26
  x4 = x3 + 0.02
  x5 = x4 + L + 0.26
  x6 = x5 + 0.02
  x7 = x6 + L + 0.26
  x8 = x7 + 0.02
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.36
  x11 = x10 + L + 0.22
  x12 = x11 + 0.06
  x13 = x12 + L + 0.22
  x14 = x13 + 0.06
  x15 = x14 + L + 0.22
  x16 = x15 + L + 0.26
  x17 = x16 + L + 0.42
  x18 = x17 + 0.02
  x19 = x18 + L + 0.26
  x20 = x19 + 0.02
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.245, x16 + 0.03) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x16 + L + 0.155, x20 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 - 0.035) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 + L + 0.095, x20 + L + 0.245) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.085, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.19)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.19)
  p6 = rect poly xspan=(x5 - 0.045, x8 + L + 0.045) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.19)
  p12 = rect poly xspan=(x9, x12 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.19)
  p15 = rect poly xspan=(x12, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.19)
  p18 = rect poly xspan=(x13, x16 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p19 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p20 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.19)
  p21 = rect poly xspan=(x16, x16 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p22 = rect poly xspan=(x17, x17 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p23 = rect poly xspan=(x17, x20 + L + 0.295) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p24 = rect poly xspan=(x18, x18 + L) yspan=(0.105, pt - WP - 0.19)
  p25 = rect poly xspan=(x19, x19 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p26 = rect poly xspan=(x20, x20 + L) yspan=(0.105, pt - WP - 0.19)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.01, x4 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x5 + L - 0.01, x8 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x9 + L - 0.03, x11 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l4 = rect li xspan=(x13 + L - 0.03, x20 + 0.03) yspan=(nb + 0.02, nb + 0.25) net=n3
  l5 = rect li xspan=(x1 - 0.435, x1 - 0.035) yspan=(nb + 0.02, nb + WN) net=n1
  l6 = rect li xspan=(x1 - 0.435, x16 + 0.07) yspan=(nb + WN - 0.23, nb + WN) net=n1
  l7 = rect li xspan=(x4 + L + 0.055, x5 - 0.035) yspan=(nb + 0.02, nb + WN) net=n1
  l8 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(nb + 0.02, nb + WN) net=n1
  l9 = rect li xspan=(x12 + L - 0.01, x13 - 0.055) yspan=(nb + 0.02, nb + WN) net=n1
  l10 = rect li xspan=(x1 - 0.435, x4 + L) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A1
  l11 = rect li xspan=(x5 - 0.085, x9 - 0.065) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A2
  l12 = rect li xspan=(x9 + L - 0.04, x11) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=A3
  l13 = rect li xspan=(x12 + L + 0.085, x16 + 0.07) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=B1
  l14 = rect li xspan=(x18 + L + 0.045, x20 + L + 0.435) yspan=(nb + WN + 0.17, pt - WP - 0.17) net=C1
  l15 = rect li xspan=(x1 - 0.435, x9 + 0.01) yspan=(pt - WP, pt - WP + 0.24) net=n4
  l16 = rect li xspan=(x1 - 0.435, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=n4
  l17 = rect li xspan=(x4 + L + 0.035, x5 - 0.055) yspan=(pt - WP, pt - 0.02) net=n4
  l18 = rect li xspan=(x8 + L + 0.035, x9 + 0.01) yspan=(pt - WP, pt - WP + 0.64) net=n4
  l19 = rect li xspan=(x5 + L - 0.03, x8 + 0.01) yspan=(pt - WP + 0.41, pt - 0.02) net=n2
  l20 = rect li xspan=(x5 + L - 0.03, x12 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n2
  l21 = rect li xspan=(x10 + L - 0.03, x12 + 0.03) yspan=(pt - 0.59, pt - 0.02) net=n2
  l22 = rect li xspan=(x9 + L + 0.055, x20 + L + 0.435) yspan=(pt - WP, pt - WP + 0.24) net=Y
  l23 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(pt - WP, pt - WP + 0.64) net=Y
  l24 = rect li xspan=(x12 + L + 0.055, x13 + 0.01) yspan=(pt - WP, pt - 0.02) net=Y
  l25 = rect li xspan=(x16 + L + 0.055, x17 - 0.055) yspan=(pt - WP, pt - 0.02) net=Y
  l26 = rect li xspan=(x16 + L + 0.095, x20 + L + 0.435) yspan=(nb + 0.42, nb + WN) net=Y
  l27 = rect li xspan=(x16 + L + 0.095, x18 + 0.02) yspan=(nb + 0.42, pt - WP + 0.24) net=Y
  l28 = rect li xspan=(x20 + L + 0.035, x20 + L + 0.435) yspan=(pt - WP, pt - 0.02) net=Y
  l29 = rect li xspan=(x20 + L + 0.055, x20 + L + 0.435) yspan=(nb + 0.02, nb + WN) net=Y
  l30 = rect li xspan=(x1 + L - 0.03, x4 + 0.01) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l31 = rect li xspan=(x13 + L + 0.03, x16 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l32 = rect li xspan=(x17 + L - 0.03, x20 + 0.01) yspan=(pt - 0.59, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 - 0.12) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x7 - 0.12) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x10 - 0.17) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x10 + L + 0.03) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x14 + L + 0.08) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n3
  c6 = array licon in=nd2 cx=(x19 - 0.12) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x1 - 0.12) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n1
  c8 = array licon in=nd1 cx=(x5 - 0.12) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd1 cx=(x12 + L + 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c11 = array licon in=nd2 cx=(x20 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  c12 = array licon in=nd1 cx=(x16 - 0.12) span=(nb + WN - 0.23, nb + WN) margin=0.04 net=n1
  c13 = array licon in=nd2 cx=(x17 - 0.12) span=(nb + 0.42 + 0.08, pt - WP + 0.24 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n4
  c15 = array licon in=pd1 cx=(x4 + L + 0.12) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c16 = array licon in=pd1 cx=(x8 + L + 0.12) span=(pt - WP + 0.08, pt - WP + 0.64 - 0.08) net=n4
  c17 = array licon in=pd2 cx=(x10 - 0.14) span=(pt - WP + 0.08, pt - WP + 0.64 - 0.08) net=Y
  c18 = array licon in=pd2 cx=(x13 - 0.08) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c19 = array licon in=pd2 cx=(x16 + L + 0.21) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c20 = array licon in=pd2 cx=(x20 + L + 0.12) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  c21 = array licon in=pd1 cx=(x2 + L + 0.12) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x6 + L + 0.12) span=(pt - WP + 0.41, pt - 0.02) margin=0.04 net=n2
  c23 = array licon in=pd2 cx=(x11 - 0.08) span=(pt - 0.59, pt - 0.02) margin=0.04 net=n2
  c24 = array licon in=pd2 cx=(x15 - 0.08) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd2 cx=(x15 + L + 0.12) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd2 cx=(x18 + L + 0.12) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L/2 + 0.01) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + 0.025) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x9 + L + 0.13) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x10 + L - 0.035) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x13 + L + 0.015) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x15 + L - 0.065) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x19 - 0.05) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x20 + L + 0.13) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.52, x20 + L + 0.52) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.29) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.01) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.05) cy=0
  mc4 = contact mcon cx=(x6 + L + 0.09) cy=0
  mc5 = contact mcon cx=(x8 + L + 0.13) cy=0
  mc6 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc7 = contact mcon cx=(x11 - 0.09) cy=0
  mc8 = contact mcon cx=(x13 - 0.05) cy=0
  mc9 = contact mcon cx=(x15 - 0.01) cy=0
  mc10 = contact mcon cx=(x16 + 0.055) cy=0
  mc11 = contact mcon cx=(x17 - 0.05) cy=0
  mc12 = contact mcon cx=(x19 - 0.01) cy=0
  mc13 = contact mcon cx=(x20 + L + 0.29) cy=0
  mc14 = contact mcon cx=(x1 - 0.29) cy=H
  mc15 = contact mcon cx=(x2 + L + 0.01) cy=H
  mc16 = contact mcon cx=(x4 + L + 0.05) cy=H
  mc17 = contact mcon cx=(x6 + L + 0.09) cy=H
  mc18 = contact mcon cx=(x8 + L + 0.13) cy=H
  mc19 = contact mcon cx=(x9 + L + 0.17) cy=H
  mc20 = contact mcon cx=(x11 - 0.09) cy=H
  mc21 = contact mcon cx=(x13 - 0.05) cy=H
  mc22 = contact mcon cx=(x15 - 0.01) cy=H
  mc23 = contact mcon cx=(x16 + 0.055) cy=H
  mc24 = contact mcon cx=(x17 - 0.05) cy=H
  mc25 = contact mcon cx=(x19 - 0.01) cy=H
  mc26 = contact mcon cx=(x20 + L + 0.29) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l11
  port A3 in on=l12
  port B1 in on=l13
  port C1 in on=l14
  port Y out on=l27
end
