pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a22oi_1 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1 b=VNB
  device M5 pmos w=WP l=L d=Y g=B2 s=n2 b=VPB
  device M6 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB

  # gate columns (left edges): same order in both rows: B1, B2, A2, A1
  x1 = 0.4
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n-row continuous (Y|n1|VGND|n3|Y); p-row broken between g2(B2) and g3(A2)
  #   pd1: col0=Y, col1=n2, col2=Y   |   pd2: col3=VPWR, col4=n2, col5=VPWR
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.275) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, full height
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect: n-row columns
  l1 = rect li xspan=(x1 - 0.31, x1 + 0.035) yspan=(nb + 0.06, nb + WN - 0.06) net=Y
  l2 = rect li xspan=(x1 + L + 0.05, x2 - 0.055) yspan=(nb + 0.06, nb + WN - 0.06) net=n1
  l3 = rect li xspan=(x2 + L + 0.05, x3 - 0.055) yspan=(nb + 0.06, nb + WN - 0.06) net=VGND
  l4 = rect li xspan=(x3 + L + 0.05, x4 - 0.055) yspan=(nb + 0.06, nb + WN - 0.06) net=n3
  l5 = rect li xspan=(x4 + L - 0.04, x4 + 0.04) yspan=(nb + 0.06, nb + WN - 0.06) net=Y
  # local interconnect: p-row columns (pd1)
  l6 = rect li xspan=(x1 - 0.31, x1 + 0.035) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=Y
  l7 = rect li xspan=(x1 + L + 0.05, x2 - 0.055) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=n2
  l8 = rect li xspan=(x2 + L - 0.04, x2 + 0.04) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=Y
  # local interconnect: p-row columns (pd2)
  l9 = rect li xspan=(x3 + L - 0.04, x3 + 0.04) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=VPWR
  l10 = rect li xspan=(x3 + L + 0.05, x4 - 0.055) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=n2
  l11 = rect li xspan=(x4 + L - 0.04, x4 + 0.04) yspan=(pt - WP + 0.06, pt - WP - 0.06) net=VPWR
  # local interconnect: input rails (vertical, full row height)
  l12 = rect li xspan=(x1 - 0.315, x1 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l13 = rect li xspan=(x2 - 0.315, x2 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B2
  l14 = rect li xspan=(x3 - 0.315, x3 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l15 = rect li xspan=(x4 - 0.315, x4 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  # local interconnect: supply rails
  l16 = rect li xspan=(x3 + L + 0.05, x4 + L + 0.32) yspan=(pt - WP + 0.01, pt - 0.04) net=VPWR
  l17 = rect li xspan=(x1 - 0.31, x1 + 0.035) yspan=(-0.085, nb + WN - 0.07) net=VGND
  # output Y vertical strap connecting n-row col0/col4 and p-row col0/col2
  l18 = rect li xspan=(x4 + L - 0.04, x4 + 0.04) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=Y
  # contacts: n-row diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=Y
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=n3
  c5 = array licon in=nd1 cx=(x4 + L + 0.15) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=Y
  # contacts: p-row diffusion columns (pd1)
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.06, pt - WP - 0.06) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.06, pt - WP - 0.06) margin=0.04 net=n2
  c8 = array licon in=pd1 cx=(x2 + L + 0.15) span=(pt - WP + 0.06, pt - WP - 0.06) margin=0.04 net=Y
  # contacts: p-row diffusion columns (pd2)
  c9 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.06, pt - WP - 0.06) margin=0.04 net=VPWR
  c10 = array licon in=pd2 cx=(x4 + L + 0.15) span=(pt - WP + 0.06, pt - WP - 0.06) margin=0.04 net=VPWR
  # supply contacts to met1 rails
  c11 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + WN - 0.07) net=VGND
  c12 = array licon in=pd2 cx=(x4 + L + 0.15) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.16) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.16) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.16) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply rail contacts
  mc1 = contact mcon cx=(x2 + L + 0.14) cy=0
  mc2 = contact mcon cx=(x4 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port B1 in on=l12
  port B2 in on=l13
  port A2 in on=l14
  port A1 in on=l15
  port Y out on=l18

end
