# xnor2_1: Y = (!A&!B) | (A&B)  (tapless, PDK widths; x from gate columns, y from row edges)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

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

  # gate columns (left edges): order A, B, n2, B, A ; 0.80 gap = island break
  x1 = 0.44
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.80
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n row islands [x1-x2], [x3], [x4-x5]; p row same
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x4 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x4 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates (cross both rows) and full-height pads
  p1 = rect poly xspan=(x1 - 0.065, x1 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # gate A
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)                                  # gate A pad
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # gate B
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)                                  # gate B pad
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # gate n2
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)                                  # gate n2 pad
  p7 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # gate B
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)                                  # gate B pad
  p9 = rect poly xspan=(x5 - 0.065, x5 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # gate A
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)                                 # gate A pad
  # local interconnect: n row island 1 (x1-x2): VGND-[A]-n3-[B]-n2
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.24) net=VGND
  l2 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n3
  l3 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.355) yspan=(-0.085, nb + 0.24) net=n2
  # local interconnect: n row island 2 (x3): Y-[n2]-n4
  l4 = rect li xspan=(x3 - 0.305, x3 + 0.03) yspan=(-0.085, nb + 0.24) net=Y
  l5 = rect li xspan=(x3 + L + 0.065, x3 + L + 0.355) yspan=(-0.085, nb + 0.24) net=n4
  # local interconnect: n row island 3 (x4-x5): VGND-[B]-n4-[A]-VGND
  l6 = rect li xspan=(x4 - 0.305, x4 + 0.03) yspan=(-0.085, nb + 0.24) net=VGND
  l7 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n4
  l8 = rect li xspan=(x5 + L + 0.065, x5 + L + 0.355) yspan=(-0.085, nb + 0.24) net=VGND
  # local interconnect: p row island 1 (x1-x2): VPWR-[A]-n1-[B]-Y
  l9 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.04, pt + 0.04) net=VPWR
  l10 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP + 0.3, pt - 0.02) net=n1
  l11 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.355) yspan=(pt - WP - 0.04, pt + 0.04) net=Y
  # local interconnect: p row island 2 (x3): VPWR-[n2]-Y
  l12 = rect li xspan=(x3 - 0.305, x3 + 0.03) yspan=(pt - WP - 0.04, pt + 0.04) net=VPWR
  l13 = rect li xspan=(x3 + L + 0.065, x3 + L + 0.355) yspan=(pt - WP - 0.04, pt + 0.04) net=Y
  # local interconnect: p row island 3 (x4-x5): VPWR-[B]-n2-[A]-VPWR
  l14 = rect li xspan=(x4 - 0.305, x4 + 0.03) yspan=(pt - WP - 0.04, pt + 0.04) net=VPWR
  l15 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l16 = rect li xspan=(x5 + L + 0.065, x5 + L + 0.355) yspan=(pt - WP - 0.04, pt + 0.04) net=VPWR
  # input nets A, B, n2: vertical li over gates
  l17 = rect li xspan=(x1 - 0.015, x1 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l18 = rect li xspan=(x2 - 0.015, x2 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B
  l19 = rect li xspan=(x3 - 0.015, x3 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=n2
  l20 = rect li xspan=(x4 - 0.015, x4 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B
  l21 = rect li xspan=(x5 - 0.015, x5 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.24) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.24) net=n2
  c3 = array licon in=nd2 cx=(x3 - 0.14) span=(-0.085, nb + 0.24) net=Y
  c4 = array licon in=nd2 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.24) net=n4
  c5 = array licon in=nd3 cx=(x4 - 0.14) span=(-0.085, nb + 0.24) net=VGND
  c6 = array licon in=nd3 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.24) net=VGND
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt + 0.04) net=VPWR
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.04, pt + 0.04) net=Y
  c9 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP - 0.04, pt + 0.04) net=VPWR
  c10 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP - 0.04, pt + 0.04) net=Y
  c11 = array licon in=pd3 cx=(x4 - 0.14) span=(pt - WP - 0.04, pt + 0.04) net=VPWR
  c12 = array licon in=pd3 cx=(x5 + L + 0.14) span=(pt - WP - 0.04, pt + 0.04) net=VPWR
  # gate contacts
  gc1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275) net=A
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275) net=B
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275) net=n2
  gc4 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275) net=B
  gc5 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275) net=A
  np1 = rect npc xspan=(x1 - 0.44, x5 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply contacts
  mc1 = contact mcon cx=(x1 - 0.21) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.11) cy=0
  mc3 = contact mcon cx=(x5 + L + 0.21) cy=0
  mc4 = contact mcon cx=(x1 - 0.21) cy=H
  mc5 = contact mcon cx=(x1 + L + 0.11) cy=H
  mc6 = contact mcon cx=(x5 + L + 0.21) cy=H
  # straps: supplies to rails
  strap li from=c1 to=mc1
  strap li from=c6 to=mc3
  strap li from=c7 to=mc4
  strap li from=c12 to=mc6
  # internal nets: route n1, n2, n4, Y
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2
  route Y layers=m1,m2
  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A in on=l17
  port B in on=l18
  port Y out on=l11
end
