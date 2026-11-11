pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a21oi_1 width=7 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.55
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + 0.80
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n row single island (VGND-A2-n1-A1-Y-B1-VGND)
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  # p row: pd1 for A2,A1 (VPWR-A2-n2-A1-VPWR), pd2 for B1 (n2-B1-Y)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  pim2 = enclose [pd2] psdm
  # poly: gates crossing both rows
  g1 = cross [nd1, pd1] poly w=L cx=x1
  g2 = cross [nd1, pd1] poly w=L cx=x2
  g3 = cross [nd1, pd2] poly w=L cx=x3
  # local interconnect: n row
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.02) yspan=(nb + 0.03, nb + WN - 0.1) net=VGND
  l2 = rect li xspan=(x1 + L + 0.035, x2 + L) yspan=(nb + 0.03, nb + WN - 0.1) net=n1
  l3 = rect li xspan=(x2 + L + 0.035, x3 + L) yspan=(nb + 0.03, nb + WN - 0.1) net=Y
  l4 = rect li xspan=(x3 + L + 0.035, x3 + L + 0.31) yspan=(nb + 0.03, nb + WN - 0.1) net=VGND
  # local interconnect: p row pd1 (A2, A1)
  l5 = rect li xspan=(x1 - 0.31, x1 - 0.02) yspan=(pt - WP + 0.01, pt - 0.02) net=VPWR
  l6 = rect li xspan=(x1 + L + 0.035, x2 + L) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l7 = rect li xspan=(x2 + L + 0.035, x2 + L + 0.31) yspan=(pt - WP + 0.01, pt - 0.02) net=VPWR
  # local interconnect: p row pd2 (B1)
  l8 = rect li xspan=(x3 - 0.31, x3 - 0.02) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l9 = rect li xspan=(x3 + L + 0.035, x3 + L + 0.31) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  # local interconnect: gate inputs
  l10 = rect li xspan=(x1 - 0.31, x1 + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l11 = rect li xspan=(x2 - 0.31, x2 + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l12 = rect li xspan=(x3 - 0.31, x3 + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.1 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 - 0.02) span=(nb + 0.03 + 0.08, nb + WN - 0.1 - 0.08) net=n1
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.1 - 0.08) net=VGND
  c9 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.1 - 0.08) net=Y
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  c5 = array licon in=pd1 cx=(x2 - 0.02) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c6 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  c7 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c8 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.035) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.55, x3 + L + 0.75) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply rails
  mc1 = contact mcon cx=(x1 - 0.32) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.005) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.06) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.52) cy=0
  mc5 = contact mcon cx=(x1 - 0.32) cy=H
  mc6 = contact mcon cx=(x1 + L - 0.005) cy=H
  mc7 = contact mcon cx=(x3 + L + 0.06) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.52) cy=H
  # straps: supply rails to li
  s1 = strap li from=c1 to=vgnd_li
  s3 = strap li from=c3 to=vgnd_li
  s4 = strap li from=c4 to=vpwr_li
  s6 = strap li from=c6 to=vpwr_li
  # route internal nets
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2
  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=l11
  port A2 in on=l10
  port B1 in on=l12
  port Y out on=l9
end
