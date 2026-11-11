# a31oi_1: Y = (!A1&!B1) | (!A2&!B1) | (!A3&!B1) = !B1 & !(A1&A2&A3)
# 8 transistors (4 n / 4 p), inputs A1, A2, A3, B1; output Y; internal nets n1, n2, n3
# Tapless: bodies tied by row tap cells. PDK widths. Clean over the sweep.
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
  x1 = 0.4
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n row is one continuous island (Y-n2-n3-VGND all connected)
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # p row: two islands - [Y|n1] separated from [n1|VPWR] by 0.80 gap (different nets)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates (full height) and row jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2 - 0.125, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3 - 0.125, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4 - 0.125, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  # n-row supply: VGND at right end (x4+L)
  l1 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(-0.085, nb + 0.25) net=VGND
  # n-row internal: n2 between A1 and A2 gates
  l2 = rect li xspan=(x1 + L + 0.05, x2 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  # n-row internal: n3 between A2 and A3 gates
  l3 = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  # n-row output: Y at left end (x1) - M1 drain and M4 drain
  l4 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  # p-row supply: VPWR at right end (x4+L)
  l5 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(pt - WP, pt - 0.02) net=VPWR
  l6 = rect li xspan=(x4 + L + 0.04, x4 + L + 0.305) yspan=(pt - 0.63, H + 0.085) net=VPWR
  # p-row internal: n1 between B1 gate (x1) and A1/A2/A3 gates (x2-x4)
  l7 = rect li xspan=(x1 + L + 0.05, x2 - 0.05) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l8 = rect li xspan=(x2 + L + 0.05, x4 + L - 0.05) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  # p-row output: Y at left end (x1) - M0 source
  l9 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  # gate input nets on li (cross both rows)
  l10 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=B1
  l11 = rect li xspan=(x2 - 0.015, x2 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A2
  l12 = rect li xspan=(x3 - 0.015, x3 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A3
  l13 = rect li xspan=(x4 - 0.015, x4 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A1
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x4 + L + 0.15) span=(nb + 0.02, nb + 0.27) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n2
  c3 = array licon in=nd1 cx=(x2 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n3
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=Y
  c6 = array licon in=pd1 cx=(x1 + L + 0.1) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd2 cx=(x2 + L + 0.1) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd2 cx=(x3 + L + 0.1) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  # gate contacts
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply contacts
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.15) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.21) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x2 - 0.09) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc9 = contact mcon cx=(x4 - 0.15) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.21) cy=H
  # output route: n-side Y (l4/c4) and p-side Y (l9/c5) don't line up -> route
  route Y layers=m1,m2
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=l13
  port A2 in on=l11
  port A3 in on=l12
  port B1 in on=l10
  port Y out
end
