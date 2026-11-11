# nor4_1: Y = !A & !B & !C & !D
# NMOS row (left to right): VGND|A|Y|B|VGND|C|Y|D|VGND  (four parallel devices Y-VGND)
# PMOS row: VPWR|A|n2|B|n1|C|n3|D|Y  (series chain; series nodes are plain diffusion, no contact)
# one full-height poly per gate crosses both rows; gate contacts sit on a pad in the channel between rows
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges), pitch L + 0.46
  x1 = 0.6
  x2 = x1 + L + 0.46
  x3 = x2 + L + 0.46
  x4 = x3 + L + 0.46
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                      # top of the p row
  chy = nb + WN + 0.275               # gate-contact height: 0.19 above the n diffusion (licon.14), 0.24 below the p row (licon.9)
  ny = nb + WN / 2                    # centre of the n row
  py = pt - WP / 2                    # centre of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.36, x4 + L + 0.37) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.36, x4 + L + 0.37) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: full-height gates, and pads in the channel for the gate contacts
  pga = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  pgb = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  pgc = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  pgd = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  padA = rect poly xspan=(x1, x1 + L + 0.235) yspan=(chy - 0.17, chy + 0.17)
  padB = rect poly xspan=(x2, x2 + L + 0.235) yspan=(chy - 0.17, chy + 0.17)
  padC = rect poly xspan=(x3, x3 + L + 0.235) yspan=(chy - 0.17, chy + 0.17)
  padD = rect poly xspan=(x4, x4 + L + 0.235) yspan=(chy - 0.17, chy + 0.17)
  # gate contacts and their local interconnect
  gca = contact licon cx=(x1 + L + 0.1) cy=chy
  gcb = contact licon cx=(x2 + L + 0.1) cy=chy
  gcc = contact licon cx=(x3 + L + 0.1) cy=chy
  gcd = contact licon cx=(x4 + L + 0.1) cy=chy
  npc1 = rect npc xspan=(x1 - 0.1, x4 + L + 0.3) yspan=(nb + WN + 0.1, pt - WP - 0.1)
  la = rect li xspan=(x1 + L - 0.065, x1 + L + 0.265) yspan=(chy - 0.165, chy + 0.165) net=A
  lb = rect li xspan=(x2 + L - 0.065, x2 + L + 0.265) yspan=(chy - 0.165, chy + 0.165) net=B
  lc = rect li xspan=(x3 + L - 0.065, x3 + L + 0.265) yspan=(chy - 0.165, chy + 0.165) net=C
  ld = rect li xspan=(x4 + L - 0.065, x4 + L + 0.265) yspan=(chy - 0.165, chy + 0.165) net=D
  # n row contacts: VGND at both ends and between B and C, Y between A and B and between C and D
  nc1 = contact licon cx=(x1 - 0.23) cy=ny
  nc2 = contact licon cx=(x1 + L + 0.23) cy=ny
  nc3 = contact licon cx=(x2 + L + 0.23) cy=ny
  nc4 = contact licon cx=(x3 + L + 0.23) cy=ny
  nc5 = contact licon cx=(x4 + L + 0.23) cy=ny
  nl1 = rect li xspan=(x1 - 0.335, x1 - 0.125) yspan=(-0.085, ny + 0.185) net=VGND
  nl2 = rect li xspan=(x1 + L + 0.125, x1 + L + 0.335) yspan=(ny - 0.185, ny + 0.185) net=Y
  nl3 = rect li xspan=(x2 + L + 0.125, x2 + L + 0.335) yspan=(-0.085, ny + 0.185) net=VGND
  nl4 = rect li xspan=(x3 + L + 0.125, x3 + L + 0.335) yspan=(ny - 0.185, ny + 0.185) net=Y
  nl5 = rect li xspan=(x4 + L + 0.125, x4 + L + 0.335) yspan=(-0.085, ny + 0.185) net=VGND
  nm1 = contact mcon cx=(x1 - 0.23) cy=0
  nm2 = contact mcon cx=(x2 + L + 0.23) cy=0
  nm3 = contact mcon cx=(x4 + L + 0.23) cy=0
  # p row contacts: VPWR at the left end, Y at the right end
  pc1 = contact licon cx=(x1 - 0.23) cy=py
  pc2 = contact licon cx=(x4 + L + 0.23) cy=py
  pl1 = rect li xspan=(x1 - 0.335, x1 - 0.125) yspan=(py - 0.185, H + 0.085) net=VPWR
  pl2 = rect li xspan=(x4 + L + 0.125, x4 + L + 0.335) yspan=(py - 0.185, py + 0.185) net=Y
  pm1 = contact mcon cx=(x1 - 0.23) cy=H
  # gate pins on met1 (stacked mcon on the gate li)
  ma = contact mcon cx=(x1 + L + 0.1) cy=chy
  mb = contact mcon cx=(x2 + L + 0.1) cy=chy
  mc = contact mcon cx=(x3 + L + 0.1) cy=chy
  md = contact mcon cx=(x4 + L + 0.1) cy=chy
  pA = enclose ma m1 by=0.06
  pB = enclose mb m1 by=0.06
  pC = enclose mc m1 by=0.06
  pD = enclose md m1 by=0.06
  # wells
  well y=((nb + WN + 0.34 + pt - WP - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # output: join the n-side and p-side Y drains on met1
  route Y layers=m1,m2
  # pins
  port A in on=pA
  port B in on=pB
  port C in on=pC
  port D in on=pD
  port Y out
end
