pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell o211ai_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.605                          # A1
  x2 = x1 + L + 0.28                  # A2 (contact column between)
  x3 = x2 + L + 0.80                  # B1 (island break)
  x4 = x3 + L + 0.28                  # C1 (contact column between)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion islands (two per row, break between A2 and B1)
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)   # n row: A1,A2
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)   # n row: B1,C1
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)   # p row: A1,A2
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)   # p row: B1,C1
  nim1 = enclose [nd1] nsdm
  nim2 = enclose [nd2] nsdm
  pim1 = enclose [pd1] psdm
  pim2 = enclose [pd2] psdm

  # poly: gates crossing both rows, plus vertical jogs
  p1 = rect poly xspan=(x1 - 0.285, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # A1 pad
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)                          # A1 jog
  p3 = rect poly xspan=(x2 - 0.285, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # A2 pad
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)                          # A2 jog
  p5 = rect poly xspan=(x3 - 0.285, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # B1 pad
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)                          # B1 jog
  p7 = rect poly xspan=(x4 - 0.285, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # C1 pad
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)                          # C1 jog

  # local interconnect: p row (top) - supplies and internal nets
  # VPWR: col0 (left of A1), col2b (left of B1), col4 (right of C1)
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l2 = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l3 = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # n1: col1 (between A1-A2), p row
  l4 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  # Y: col2a (right of A2), col3 (between B1-C1), col4 (right of C1), p row
  l5 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y
  l6 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  l7 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y

  # local interconnect: n row (bottom) - supplies and internal nets
  # VGND: col0 (left of A1), col2a (right of A2)
  l8 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l9 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(-0.085, nb + WN) net=VGND
  # n2: col1 (between A1-A2), col2b (left of B1), n row
  l10 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=n2
  l11 = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(nb + 0.02, nb + WN) net=n2
  # n3: col3 (between B1-C1), n row
  l12 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  # Y: col4 (right of C1), n row
  l13 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=Y

  # gate input strips (vertical li crossing both rows at each gate)
  # Alternate left/right to avoid overlap at 0.43 pitch
  l14 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A1
  l15 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A2
  l16 = rect li xspan=(x3 - 0.325, x3 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B1
  l17 = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=C1

  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN) net=n2
  c4 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02, nb + WN) net=n2
  c5 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=n3
  c6 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) net=n1
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y
  c10 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y
  c12 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y

  # gate contacts (on the input li strips)
  cb = max(nd1.top + 0.19, l14.top + 0.25)
  gc1 = contact licon cx=(x1 - 0.155) bottom=cb net=A1
  gc2 = contact licon cx=(x2 + L + 0.125) bottom=cb net=A2
  gc3 = contact licon cx=(x3 - 0.155) bottom=cb net=B1
  gc4 = contact licon cx=(x4 + L + 0.125) bottom=cb net=C1
  np1 = rect npc xspan=(x1 - 0.605, x4 + L + 0.635) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply and output contacts on rails
  mc1 = contact mcon cx=(x1 - 0.19) cy=0 net=VGND
  mc2 = contact mcon cx=(x2 + L + 0.13) cy=0 net=VGND
  mc3 = contact mcon cx=(x1 - 0.19) cy=H net=VPWR
  mc4 = contact mcon cx=(x3 - 0.19) cy=H net=VPWR
  mc5 = contact mcon cx=(x4 + L + 0.17) cy=H net=VPWR
  mc6 = contact mcon cx=(x4 + L + 0.405) cy=0 net=Y

  # internal net routes
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route Y layers=m1,m2

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A1 in on=l14
  port A2 in on=l15
  port B1 in on=l16
  port C1 in on=l17
  port Y out on=l7
end
