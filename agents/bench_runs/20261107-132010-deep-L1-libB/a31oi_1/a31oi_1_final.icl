pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a31oi_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=Y b=VPB
  device M1 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=n2 b=VNB
  device M4 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M7 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4                          # gate B1
  x2 = x1 + L + 0.24                # gate A1 (same island as B1, share Y/n1)
  x3 = x2 + L + 0.8                 # gate A3 (new island)
  x4 = x3 + L + 0.24                # gate A2 (same island as A3, share n3/n1)
  nb = 0.235                        # bottom of the n row
  pt = H - 0.235                    # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly gates (left edge at x, full height)
  g1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)   # B1
  g2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)   # A1
  g3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)   # A3
  g4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)   # A2
  # local interconnect: n row
  l1 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=B1
  l4 = rect li xspan=(x2 - 0.015, x2 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l5 = rect li xspan=(x2 + L + 0.03, x2 + L + 0.28) yspan=(nb + WN - 0.21, pt - WP - 0.21) net=A1
  l6 = rect li xspan=(x3 - 0.27, x3 - 0.06) yspan=(nb + WN - 0.21, pt - WP - 0.21) net=A3
  l7 = rect li xspan=(x3 - 0.27, x3 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A3
  l8 = rect li xspan=(x3 + L + 0.11, x4 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l9 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.4) net=n1
  l10 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.25) yspan=(nb + 0.02, nb + 0.27) net=Y
  l11 = rect li xspan=(x3 + L + 0.055, x4 + L + 0.25) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n2
  l12 = rect li xspan=(x3 + L + 0.055, x4 + L + 0.25) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  # local interconnect: p row
  l13 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - 0.63, H + 0.085) net=VPWR
  l15 = rect li xspan=(x1 - 0.305, x2 + L - 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=Y
  l16 = rect li xspan=(x1 - 0.305, x2 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=Y
  l17 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.05) net=n1
  l18 = rect li xspan=(x3 + L + 0.055, x4 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.05) net=n1
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.36) net=VGND
  c2 = array licon in=nd2 cx=(x4 + L + 0.15) span=(-0.085, nb + 0.25) net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=Y
  c4 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.27) net=n2
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=Y
  c6 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  c9 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  # gate contacts (offset from gate edges, above n row)
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275) net=B1
  gc2 = contact licon cx=(x2 + L + 0.005) cy=(nb + WN + 0.275) net=A1
  gc3 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275) net=A3
  gc4 = contact licon cx=(x4 + L + 0.005) cy=(nb + WN + 0.275) net=A2
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal contacts on rails
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x4 + L + 0.21) cy=0
  mc3 = contact mcon cx=(x1 - 0.17) cy=H
  mc4 = contact mcon cx=(x4 + L + 0.21) cy=H
  # straps
  strap li from=c1 to=vgnd_li
  strap li from=c2 to=vgnd_li
  strap li from=c8 to=vpwr_li
  strap li from=c9 to=vpwr_li
  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=l4
  port A2 in on=l8
  port A3 in on=l7
  port B1 in on=l3
  port Y out on=l16
end