pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell xnor2_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M2 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B s=n4 b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M7 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M9 nmos w=WN l=L d=n4 g=n2 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  x5 = x4 + L + max(0.28, 0.54 - L)
  x6 = x5 + L + max(0.28, 0.54 - L)
  x7 = x6 + L + max(0.28, 0.54 - L)
  x8 = x7 + L + max(0.28, 0.54 - L)
  x9 = x8 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x7 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x7 - 0.265, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.31, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.31, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.31, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.31, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5 - 0.31, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6 - 0.31, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7 - 0.31, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x8 - 0.31, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x9 - 0.31, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p18 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l3 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l4 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l5 = rect li xspan=(x1 + L + 0.04, x2 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n3
  l6 = rect li xspan=(x1 + L + 0.04, x2 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n3
  l7 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l8 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l9 = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l10 = rect li xspan=(x3 - 0.325, x3 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B
  l11 = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l12 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l13 = rect li xspan=(x3 + L + 0.04, x4 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n2
  l14 = rect li xspan=(x3 + L + 0.04, x4 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n2
  l15 = rect li xspan=(x3 - 0.335, x3 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l16 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l17 = rect li xspan=(x5 - 0.335, x5 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l18 = rect li xspan=(x5 - 0.325, x5 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l19 = rect li xspan=(x6 + L - 0.045, x6 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n2
  l20 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR
  l21 = rect li xspan=(x5 + L + 0.04, x6 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n4
  l22 = rect li xspan=(x5 + L + 0.04, x6 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n4
  l23 = rect li xspan=(x5 - 0.335, x5 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l24 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l25 = rect li xspan=(x7 - 0.335, x7 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l26 = rect li xspan=(x7 - 0.325, x7 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n2
  l27 = rect li xspan=(x8 + L - 0.045, x8 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l28 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP, pt - 0.02) net=n4
  l29 = rect li xspan=(x7 + L + 0.04, x8 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n4
  l30 = rect li xspan=(x7 + L + 0.04, x8 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n4
  l31 = rect li xspan=(x7 - 0.335, x7 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l32 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l33 = rect li xspan=(x9 - 0.335, x9 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l34 = rect li xspan=(x9 - 0.325, x9 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n2
  l35 = rect li xspan=(x9 + L - 0.045, x9 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=Y
  l36 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=Y
  l37 = rect li xspan=(x9 + L + 0.04, x9 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=Y
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=n3
  c3 = array licon in=nd2 cx=(x4 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN) net=n2
  c5 = array licon in=nd3 cx=(x7 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd3 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + WN) net=n4
  c7 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n1
  c10 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n2
  c12 = array licon in=pd3 cx=(x7 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n4
  c14 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=Y
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.155) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.125) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 - 0.155) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L + 0.125) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 - 0.155) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x8 + L + 0.125) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x9 - 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x9 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x3 - 0.19) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.13) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc7 = contact mcon cx=(x5 - 0.19) cy=0
  mc8 = contact mcon cx=(x5 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x6 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x7 - 0.19) cy=0
  mc11 = contact mcon cx=(x7 + L + 0.13) cy=0
  mc12 = contact mcon cx=(x8 + L + 0.17) cy=0
  mc13 = contact mcon cx=(x9 - 0.19) cy=0
  mc14 = contact mcon cx=(x9 + L + 0.13) cy=0
  mc15 = contact mcon cx=(x1 - 0.19) cy=H
  mc16 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc17 = contact mcon cx=(x2 + L + 0.17) cy=H
  mc18 = contact mcon cx=(x3 - 0.19) cy=H
  mc19 = contact mcon cx=(x3 + L + 0.13) cy=H
  mc20 = contact mcon cx=(x4 + L + 0.17) cy=H
  mc21 = contact mcon cx=(x5 - 0.19) cy=H
  mc22 = contact mcon cx=(x5 + L + 0.13) cy=H
  mc23 = contact mcon cx=(x6 + L + 0.17) cy=H
  mc24 = contact mcon cx=(x7 - 0.19) cy=H
  mc25 = contact mcon cx=(x7 + L + 0.13) cy=H
  mc26 = contact mcon cx=(x8 + L + 0.17) cy=H
  mc27 = contact mcon cx=(x9 - 0.19) cy=H
  mc28 = contact mcon cx=(x9 + L + 0.13) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A in on=l2
  port B in on=l10
  port Y out on=l36
end
