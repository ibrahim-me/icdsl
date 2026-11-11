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

  # gate columns (left edges): gate order A, B, n2, B, A (same for both rows)
  x1 = 0.415
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.80
  x5 = x4 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: NMOS row - 5 islands (one per gate column, breaks where nets differ)
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  nd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd5 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: PMOS row - 5 islands
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4, nd5] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5] psdm
  # poly: gates
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
  # local interconnect: NMOS row
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l3 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l4 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l5 = rect li xspan=(x1 + L + 0.04, x2 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n3
  l6 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l7 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l8 = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l9 = rect li xspan=(x3 - 0.325, x3 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n2
  l10 = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l11 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l12 = rect li xspan=(x3 + L + 0.04, x4 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=n2
  l13 = rect li xspan=(x3 - 0.335, x3 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l15 = rect li xspan=(x5 - 0.335, x5 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l16 = rect li xspan=(x5 - 0.325, x5 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l17 = rect li xspan=(x5 + L - 0.045, x5 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n2
  l18 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n4
  l19 = rect li xspan=(x5 + L + 0.04, x5 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=Y
  l20 = rect li xspan=(x5 - 0.335, x5 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # local interconnect: PMOS row
  l21 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l22 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  l23 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR
  l24 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x2 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=n4
  c3 = array licon in=nd3 cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=n2
  c4 = array licon in=nd4 cx=(x4 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=n4
  c5 = array licon in=nd5 cx=(x5 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd5 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN) net=n4
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n1
  c9 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n1
  c11 = array licon in=pd3 cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c12 = array licon in=pd3 cx=(x3 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=Y
  c13 = array licon in=pd4 cx=(x4 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c14 = array licon in=pd4 cx=(x4 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n2
  c15 = array licon in=pd5 cx=(x5 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd5 cx=(x5 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n2
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.155) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.155) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.155) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 - 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x5 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x3 - 0.19) cy=0
  mc6 = contact mcon cx=(x3 + L + 0.13) cy=0
  mc7 = contact mcon cx=(x4 - 0.19) cy=0
  mc8 = contact mcon cx=(x4 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x5 - 0.19) cy=0
  mc10 = contact mcon cx=(x5 + L + 0.13) cy=0
  mc11 = contact mcon cx=(x1 - 0.19) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x2 - 0.19) cy=H
  mc14 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc15 = contact mcon cx=(x3 - 0.19) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.13) cy=H
  mc17 = contact mcon cx=(x4 - 0.19) cy=H
  mc18 = contact mcon cx=(x4 + L + 0.13) cy=H
  mc19 = contact mcon cx=(x5 - 0.19) cy=H
  mc20 = contact mcon cx=(x5 + L + 0.13) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A in on=l2
  port B in on=l3
  port Y out on=l19
end
