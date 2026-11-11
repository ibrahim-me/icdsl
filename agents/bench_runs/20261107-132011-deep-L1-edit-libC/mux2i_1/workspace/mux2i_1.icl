pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell mux2i_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=S s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y b=VPB
  device M3 nmos w=WN l=L d=VGND g=S s=n3 b=VNB
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n1 g=S s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=A1 s=n4 b=VPB
  device M8 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y b=VNB

  # gate columns (left edges): gate order S, n1, A0, A1 (same for n and p rows)
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: single island per row
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.065, x1 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  # VGND rail contacts (n row)
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.24) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.355) yspan=(-0.085, nb + WN + 0.035) net=VGND
  # n1 net: M0.d(M6.d) -> M4.g(M5.g), route on m1/m2
  l3 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n1
  l4 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n1
  l5 = rect li xspan=(x1 - 0.015, x1 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=S
  l6 = rect li xspan=(x1 - 0.015, x4 + 0.035) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=S
  l7 = rect li xspan=(x3 + L + 0.14, x4 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=S
  l8 = rect li xspan=(x3 + L + 0.14, x4 + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=S
  l9 = rect li xspan=(x1 - 0.355, x4 - 0.285) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l10 = rect li xspan=(x1 - 0.355, x1 - 0.185) yspan=(nb + WN - 0.23, pt - 0.02) net=n1
  l11 = rect li xspan=(x1 - 0.355, x1 + 0.03) yspan=(pt - 0.7, pt - 0.02) net=n1
  l12 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n1
  l13 = rect li xspan=(x4 + L + 0.265, x4 + L + 0.355) yspan=(nb + WN - 0.23, pt - WP - 0.16) net=n1
  # n2 net: M1.s -> M2.d (p row)
  l14 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l15 = rect li xspan=(x3 + L - 0.03, x4) yspan=(pt - WP + 0.3, pt - 0.53) net=n2
  l16 = rect li xspan=(x4 - 0.385, x4) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  # Y net: output
  l17 = rect li xspan=(x4 + 0.025, x4 + L + 0.04) yspan=(nb + 0.08, nb + 0.25) net=Y
  l18 = rect li xspan=(x4 - 0.115, x4 + L + 0.04) yspan=(nb + 0.08, pt - WP + 0.05) net=Y
  l19 = rect li xspan=(x4 - 0.115, x4 + L + 0.355) yspan=(pt - WP - 0.12, pt - WP + 0.05) net=Y
  l20 = rect li xspan=(x4 + L + 0.035, x4 + L + 0.355) yspan=(pt - WP - 0.12, pt - 0.02) net=Y
  # VPWR rail contacts (p row)
  l21 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.7, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(pt - 0.36, H + 0.085) net=VPWR
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.24) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.24) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.035 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.1 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x4 + L + 0.15) span=(nb + 0.08 + 0.08, nb + 0.25 - 0.08) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.12 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.7 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c8 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=n2
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) net=VPWR
  # gate contacts (on n-row side, per rule 1)
  gc1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.44, x4 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: mcon contacts to rails
  mc1 = contact mcon cx=(x1 - 0.21) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.11) cy=0
  mc3 = contact mcon cx=(x3 - 0.13) cy=0
  mc4 = contact mcon cx=(x4 - 0.09) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.23) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.23) cy=H
  mc7 = contact mcon cx=(x1 - 0.21) cy=H
  mc8 = contact mcon cx=(x1 + L + 0.11) cy=H
  mc9 = contact mcon cx=(x3 - 0.13) cy=H
  mc10 = contact mcon cx=(x4 - 0.09) cy=H
  # routes for internal nets
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2
  # pins
  port A0 in on=l4
  port A1 in on=l8
  port S in on=l5
  port Y out on=l19
end
