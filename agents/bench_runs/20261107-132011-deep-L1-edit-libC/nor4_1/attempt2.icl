# nor4_1: Y = (!A&!B&!C&!D)  4n/4p, tapless
# NMOS: M0(B), M3(C), M4(D), M7(A) all in parallel between Y and VGND
# PMOS: series chain VPWR-M2(A)-n2-M1(B)-n1-M5(C)-n3-M6(D)-Y
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges): A, B, C, D
  x1 = 0.66
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: two n-diff strips (like nor3b_1) to break between conflicting nets,
  # one p-diff island for the series PMOS chain
  nd1 = rect diff xspan=(x1 - 0.345, x4 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.345, x4 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.325, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: full-height gates for A, B, C, D
  gA = cross [nd1, nd2, pd1] poly w=L left=x1
  gB = cross [nd1, nd2, pd1] poly w=L left=x2
  gC = cross [nd1, nd2, pd1] poly w=L left=x3
  gD = cross [nd1, nd2, pd1] poly w=L left=x4
  # local interconnect: n-diff supply rails
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.23 + 0.02) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 - 0.04) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l5 = rect li xspan=(x1 + L + 0.04, x4 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=Y
  l6 = rect li xspan=(x1 + L + 0.04, x2 - 0.07) yspan=(nb + 0.02, nb + WN) net=Y
  # gate input li: A and D on the outside, B and C across both rows
  l3 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l4 = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=D
  l12 = rect li xspan=(x2 - 0.06, x2 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l13 = rect li xspan=(x3 - 0.06, x3 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  # PMOS internal nodes on p-diff (between gates): VPWR left of A, n2 A-B, n1 B-C, n3 C-D, Y right of D
  l7 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP, pt - 0.02) net=VPWR
  l8 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l9 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l10 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n3
  l11 = rect li xspan=(x4 + L + 0.04, x4 + L + 0.315) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  # VPWR rail on p-diff going up
  l14 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.22) span=(nb + 0.02, nb + WN - 0.06) net=Y
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23 + 0.02) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.075 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c5 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.23 - 0.06 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.2) span=(pt - WP + 0.08, pt - 0.08) net=VPWR
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.08, pt - 0.08) net=n2
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.08, pt - 0.08) net=n1
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.08, pt - 0.08) net=n3
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.08, pt - 0.08) net=Y
  # gate contacts (on their own gates)
  gcA = contact licon cx=(x1 - 0.07) cy=(nb + WN + 0.275)
  gcB = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gcC = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gcD = contact licon cx=(x4 + L - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply contacts
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x1 - 0.19) cy=H
  mc5 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc6 = contact mcon cx=(x4 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A in on=l3
  port B in on=l12
  port C in on=l13
  port D in on=l4
  port Y out on=l5
end
