pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a31oi_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=Y b=VPB
  device M1 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=n2 b=VNB
  device M4 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M7 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB

  # gate columns (left edges): order B1, A1, A3, A2
  x1 = 0.4                          # gate B1
  x2 = x1 + L + max(0.21, 0.54 - L) # gate A1 (series with B1, share Y/n1)
  x3 = x2 + L + max(0.28, 0.54 - L) # gate A3 (island break, contact column)
  x4 = x3 + L + max(0.21, 0.54 - L) # gate A2 (series with A3, share n1/n3)
  nb = 0.235                        # bottom of the n row
  pt = H - 0.235                    # top of the p row

  # diffusion islands
  # n row: N1 = VGND-M4(B1)-Y-M1(A1)-n2 ; N2 = VGND-M5(A3)-n3-M3(A2)-n2
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # p row: P1 = Y-M0(B1)-n1-M2(A1)-VPWR ; P2 = VPWR-M6(A3)-n1-M7(A2)-VPWR
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # poly gates (cross both rows)
  g1 = cross [nd1, pd1] poly w=L cx=x1
  g2 = cross [nd1, pd1] poly w=L cx=x2
  g3 = cross [nd2, pd2] poly w=L cx=x3
  g4 = cross [nd2, pd2] poly w=L cx=x4

  # local interconnect: n row
  l1 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x2 + L - 0.02, x2 + L + 0.315) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=B1
  l4 = rect li xspan=(x2 - 0.015, x2 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l5 = rect li xspan=(x3 - 0.27, x3 + L - 0.06) yspan=(nb + WN - 0.21, pt - WP - 0.21) net=A3
  l6 = rect li xspan=(x3 - 0.27, x4 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A3
  l7 = rect li xspan=(x4 + L + 0.11, x4 + L + 0.315) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  # n row internal nets: Y (n1 island), n2 (n2 island)
  l8 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.4) net=Y
  l9 = rect li xspan=(x1 + L + 0.055, x2 + 0.01) yspan=(pt - WP + 0.31, pt - 0.36) net=Y
  l10 = rect li xspan=(x3 + L + 0.055, x4 + 0.01) yspan=(pt - WP + 0.35, pt - 0.45) net=n2
  l11 = rect li xspan=(x3 + L + 0.055, x4 + 0.01) yspan=(pt - WP + 0.35, pt - 0.36) net=n2

  # local interconnect: p row
  l12 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l13 = rect li xspan=(x2 + L - 0.03, x3 - 0.055) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l14 = rect li xspan=(x1 - 0.305, x2 + L - 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=Y
  l15 = rect li xspan=(x1 - 0.305, x2 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=Y
  # n1 on p row: overlapping li strips across both p islands
  l16 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.05) net=n1
  l17 = rect li xspan=(x1 + L + 0.055, x3 + 0.01) yspan=(pt - WP + 0.31, pt - 0.15) net=n1
  l18 = rect li xspan=(x3 + L + 0.055, x4 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.05) net=n1
  l19 = rect li xspan=(x3 + L + 0.055, x4 + 0.01) yspan=(pt - WP + 0.35, pt - 0.15) net=n1

  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.36) net=VGND
  c2 = array licon in=nd2 cx=(x2 + L + 0.15) span=(-0.085, nb + 0.25) net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=Y
  c4 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + 0.27) net=n2
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=Y
  c6 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - WP + 0.31 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=n1

  # gate contacts
  cb = max(nd1.top + 0.19, l3.top + 0.25, l4.top + 0.25, l5.top + 0.25, l6.top + 0.25, l7.top + 0.25)
  gc1 = contact licon cx=(x1 + 0.015) cy=cb net=B1
  gc2 = contact licon cx=(x2 + L + 0.005) cy=cb net=A1
  gc3 = contact licon cx=(x3 - 0.085) cy=cb net=A3
  gc4 = contact licon cx=(x4 + L - 0.015) cy=cb net=A2

  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal contacts on rails
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.21) cy=0
  mc3 = contact mcon cx=(x3 - 0.17) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.21) cy=0
  mc5 = contact mcon cx=(x1 - 0.17) cy=H
  mc6 = contact mcon cx=(x2 + L + 0.21) cy=H
  mc7 = contact mcon cx=(x3 - 0.17) cy=H
  mc8 = contact mcon cx=(x4 + L + 0.21) cy=H

  # straps from diffusion contacts to rails
  strap li from=c1 to=vgnd_li
  strap li from=c2 to=vgnd_li
  strap li from=c5 to=vpwr_li
  strap li from=c8 to=vpwr_li

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port B1 in on=l3
  port A1 in on=l4
  port A3 in on=l5
  port A2 in on=l7
  port Y out on=l15
end
