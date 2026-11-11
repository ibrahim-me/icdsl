# a31oi_1: Y = (!A1&!B1) | (!A2&!B1) | (!A3&!B1) = !B1 & !(A1&A2&A3)
# 8 transistors (4 n / 4 p), inputs A1, A2, A3, B1; output Y; internal nets n1, n2, n3
# Gate order (both rows): B1, A1, A2, A3
# nMOS: nd1 = series chain Y-n2-n3-VGND (gates A1,A2,A3), nd2 = parallel Y-VGND (gate B1)
# pMOS: pd1 = parallel VPWR-n1 (gates A1,A2,A3), pd2 = series n1-Y (gate B1)
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

  # gate columns (left edges): B1, A1, A2, A3
  x1 = 0.4
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: two islands per row
  nd1 = rect diff xspan=(x2 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)   # series chain A1,A2,A3
  nd2 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)   # parallel B1
  pd1 = rect diff xspan=(x2 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)   # parallel A1,A2,A3
  pd2 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)   # series B1
  nim = enclose [nd1, nd2] nsdm
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
  # local interconnect: n row series chain (nd1): Y-n2-n3-VGND
  l1 = rect li xspan=(x2 - 0.305, x2 + L) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l2 = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l3 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l4 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(nb + 0.02, nb + WN - 0.06) net=VGND
  l5 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(-0.085, nb + 0.25) net=VGND
  # n row parallel B1 (nd2): Y-VGND
  l6 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l7 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + 0.25) net=VGND
  # local interconnect: p row parallel A1,A2,A3 (pd1): VPWR-n1
  l8 = rect li xspan=(x2 - 0.305, x2 + L) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=VPWR
  l9 = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l10 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l11 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=VPWR
  l12 = rect li xspan=(x4 + L - 0.02, x4 + L + 0.315) yspan=(pt - WP, pt - 0.02) net=VPWR
  l13 = rect li xspan=(x4 + L + 0.04, x4 + L + 0.305) yspan=(pt - 0.63, H + 0.085) net=VPWR
  # p row series B1 (pd2): n1-Y
  l14 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l15 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  # gate input nets on li (cross both rows)
  l16 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=B1
  l17 = rect li xspan=(x2 - 0.015, x2 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A1
  l18 = rect li xspan=(x3 - 0.015, x3 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A2
  l19 = rect li xspan=(x4 - 0.015, x4 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=A3
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x2 - 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c2 = array licon in=nd1 cx=(x2 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n2
  c3 = array licon in=nd1 cx=(x3 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n3
  c4 = array licon in=nd1 cx=(x4 + L + 0.15) span=(nb + 0.02, nb + 0.27) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c8 = array licon in=pd1 cx=(x2 - 0.14) span=(pt - WP + 0.09, pt - WP + 0.18 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x2 + L + 0.1) span=(pt - WP + 0.09, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x3 + L + 0.1) span=(pt - WP + 0.09, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.09, pt - 0.02 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c13 = array licon in=pd2 cx=(x1 - 0.14) span=(pt - WP + 0.09, pt - WP + 0.18 - 0.08) margin=0.04 net=n1
  c14 = array licon in=pd2 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=Y
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
  # output route: n-side Y (c1/c6) and p-side Y (c14) don't line up -> route
  route Y layers=m1,m2
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=l17
  port A2 in on=l18
  port A3 in on=l19
  port B1 in on=l16
  port Y out
end
