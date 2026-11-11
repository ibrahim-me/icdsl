# maj3_1: X = (A&B) | (A&C) | (B&C)  (14 transistors: 7 n / 7 p)
# tapless, PDK widths; x from gate columns; y from row edges nb/pt; clean over sweep
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=13 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.40                          # gate A
  x2 = x1 + L + max(0.28, 0.54 - L)  # gate B
  x3 = x2 + L + max(0.28, 0.54 - L)  # gate C
  x4 = x3 + L + 0.80                 # gate n3 (island break: 0.80 gap)
  nb = 0.235                         # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: NMOS row (4 islands separated by breaks)
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN2)
  nd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  # diffusion: PMOS row (4 islands separated by breaks)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pim = enclose [pd1, pd2, pd3, pd4] psdm

  # poly: gates crossing both rows
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)

  # local interconnect: NMOS side (horizontal strips in n row only)
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + WN2) net=VGND
  l2 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(nb + 0.02, nb + WN2) net=n2
  l3 = rect li xspan=(x2 + L - 0.03, x3 - 0.03) yspan=(nb + 0.02, nb + WN2) net=n3
  l4 = rect li xspan=(x3 + L - 0.03, x4 - 0.03) yspan=(nb + 0.02, nb + WN2) net=n4
  l5 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=X
  # NMOS input nets (vertical strips crossing n row only, stop before p row)
  l6 = rect li xspan=(x1 - 0.31, x1 + 0.05) yspan=(nb + WN2 + 0.19, pt - WP2 - 0.17) net=A
  l7 = rect li xspan=(x2 - 0.31, x2 + 0.05) yspan=(nb + WN2 + 0.19, pt - WP2 - 0.17) net=B
  l8 = rect li xspan=(x3 - 0.31, x3 + 0.05) yspan=(nb + WN2 + 0.19, pt - WP2 - 0.17) net=C
  l9 = rect li xspan=(x4 - 0.31, x4 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=n3
  # local interconnect: PMOS side (horizontal strips in p row only)
  l10 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP2 + 0.01, H + 0.085) net=VPWR
  l11 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(pt - WP2 + 0.02, pt - 0.02) net=n1
  l12 = rect li xspan=(x2 + L - 0.03, x3 - 0.03) yspan=(pt - WP2 + 0.02, pt - 0.02) net=n6
  l13 = rect li xspan=(x3 + L - 0.03, x4 - 0.03) yspan=(pt - WP2 + 0.02, pt - 0.02) net=n1
  l14 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP + 0.02, pt - 0.02) net=X
  # PMOS input nets (vertical strips crossing p row only, start above n row)
  l15 = rect li xspan=(x1 - 0.31, x1 + 0.05) yspan=(pt - WP2 + 0.19, H - 0.105) net=A
  l16 = rect li xspan=(x2 - 0.31, x2 + 0.05) yspan=(pt - WP2 + 0.19, H - 0.105) net=B
  l17 = rect li xspan=(x3 - 0.31, x3 + 0.05) yspan=(pt - WP2 + 0.19, H - 0.105) net=C
  l18 = rect li xspan=(x4 - 0.31, x4 + 0.05) yspan=(pt - WP + 0.19, H - 0.105) net=n3
  # local interconnect: vertical output strap X joining n and p drains
  l19 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, pt - 0.02) net=X

  # contacts: diffusion columns (NMOS side)
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n2
  c3 = array licon in=nd2 cx=(x2 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n2
  c4 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n3
  c5 = array licon in=nd3 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n3
  c6 = array licon in=nd3 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n4
  c7 = array licon in=nd4 cx=(x4 - 0.14) span=(nb + 0.08, nb + WN - 0.06) net=n4
  c8 = array licon in=nd4 cx=(x4 + L + 0.14) span=(nb + 0.08, nb + WN - 0.06) net=X
  # contacts: diffusion columns (PMOS side)
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c11 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c12 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n6
  c13 = array licon in=pd3 cx=(x3 - 0.14) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n6
  c14 = array licon in=pd3 cx=(x3 + L + 0.14) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c15 = array licon in=pd4 cx=(x4 - 0.14) span=(pt - WP + 0.08, pt - 0.07) net=n7
  c16 = array licon in=pd4 cx=(x4 + L + 0.14) span=(pt - WP + 0.08, pt - 0.07) net=X

  # gate contacts
  gc1 = contact licon cx=(x1 - 0.12) cy=(nb + WN2 + 0.275)
  gc2 = contact licon cx=(x2 - 0.12) cy=(nb + WN2 + 0.275)
  gc3 = contact licon cx=(x3 - 0.12) cy=(nb + WN2 + 0.275)
  gc4 = contact licon cx=(x4 - 0.12) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply rails
  mc1 = contact mcon cx=(x1 - 0.375) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.405) cy=0
  mc3 = contact mcon cx=(x1 - 0.375) cy=H
  mc4 = contact mcon cx=(x1 + L + 0.405) cy=H

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A in on=l6
  port B in on=l7
  port C in on=l8
  port X out on=l14
end
