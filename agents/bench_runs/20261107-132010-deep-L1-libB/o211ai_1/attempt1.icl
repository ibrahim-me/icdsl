pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell o211ai_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: n row - two islands (nd1: A1,A2 share VGND/n2; nd2: B1,C1 share n2,n3,Y)
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: p row - one island covering all gates
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm

  # poly: gates crossing both rows
  g1 = cross [nd1, pd1] poly w=L left=x1
  g2 = cross [nd1, pd1] poly w=L left=x2
  g3 = cross [nd2, pd1] poly w=L left=x3
  g4 = cross [nd2, pd1] poly w=L left=x4

  # local interconnect: n row
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x2 + L + 0.04, x2 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n2
  l3 = rect li xspan=(x3 + L + 0.04, x3 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=n3
  l4 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=Y
  # n row horizontal straps at diffusion height
  l5 = rect li xspan=(x1 - 0.335, x2 + L + 0.315) yspan=(nb + WN - 0.15, nb + WN - 0.02) net=VGND
  l6 = rect li xspan=(x1 - 0.335, x2 + L + 0.315) yspan=(nb + WN - 0.15, nb + WN - 0.02) net=n2
  # local interconnect: p row
  l7 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP, pt - 0.02) net=VPWR
  l8 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y
  # p row horizontal straps at diffusion height
  l9 = rect li xspan=(x1 - 0.335, x4 + L + 0.305) yspan=(pt - WP + 0.01, pt - WP + 0.14) net=VPWR
  l10 = rect li xspan=(x1 - 0.335, x4 + L + 0.305) yspan=(pt - WP + 0.01, pt - WP + 0.14) net=Y
  # input nets running vertically across both rows
  l11 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A1
  l12 = rect li xspan=(x2 - 0.325, x2 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A2
  l13 = rect li xspan=(x3 - 0.325, x3 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B1
  l14 = rect li xspan=(x4 - 0.325, x4 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=C1

  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=n2
  c3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=n3
  c4 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c6 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.155) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.125) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply contacts
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc5 = contact mcon cx=(x1 - 0.19) cy=H
  mc6 = contact mcon cx=(x4 + L + 0.13) cy=H
  mc7 = contact mcon cx=(x4 + L + 0.17) cy=H

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # straps from supply contacts to rails
  strap li from=c1 to=vgnd_li
  strap li from=c5 to=vpwr_li
  strap li from=c7 to=vpwr_li

  # pins
  port A1 in on=l11
  port A2 in on=l12
  port B1 in on=l13
  port C1 in on=l14
  port Y out on=l8
end
