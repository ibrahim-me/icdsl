pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=7 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.66
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  # gate A: middle pad (extends left) + full gate
  p1 = rect poly xspan=(x1 - 0.205, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  # gate B: middle pad (small, centred on gate) + full gate
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  # gate C: middle pad (small, centred on gate) + full gate
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # gate D: middle pad (small, centred on gate) + full gate
  p7 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect: NMOS row diffusion strips (VGND | Y | VGND | Y | VGND)
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=VGND
  l2 = rect li xspan=(x1 + L + 0.02, x2 - 0.02) yspan=(nb + 0.02, nb + WN) net=Y
  l3 = rect li xspan=(x2 + L + 0.02, x3 - 0.02) yspan=(nb + 0.02, nb + WN) net=VGND
  l4 = rect li xspan=(x3 + L + 0.02, x4 - 0.02) yspan=(nb + 0.02, nb + WN) net=Y
  l5 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=VGND
  # local interconnect: PMOS row diffusion strips (VPWR | n2 | n1 | n3 | Y)
  l6 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP + 0.02, pt - 0.02) net=VPWR
  l7 = rect li xspan=(x1 + L + 0.02, x2 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=n2
  l8 = rect li xspan=(x2 + L + 0.02, x3 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=n1
  l9 = rect li xspan=(x3 + L + 0.02, x4 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=n3
  l10 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.305) yspan=(pt - WP + 0.02, pt - 0.02) net=Y
  # Gate input nets: li strips only in the middle region between rows
  l11 = rect li xspan=(x1 - 0.285, x1 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A
  l12 = rect li xspan=(x2 - 0.285, x2 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=B
  l13 = rect li xspan=(x3 - 0.285, x3 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=C
  l14 = rect li xspan=(x4 - 0.285, x4 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=D
  # contacts: diffusion columns (n row)
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) net=VGND
  # contacts: diffusion columns (p row)
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=VPWR
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=n2
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=n3
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=Y
  # gate contacts (on middle pads between rows)
  gc1 = contact licon cx=(x1 + 0.05) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.66, x4 + L + 0.635) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply contacts (VGND at bottom, VPWR at top)
  mc1 = contact mcon cx=(x1 - 0.375) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.17) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.405) cy=0
  mc7 = contact mcon cx=(x1 - 0.375) cy=H
  mc8 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc9 = contact mcon cx=(x2 + L + 0.17) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.17) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.17) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.405) cy=H
  # supply straps
  s1 = strap li from=c1 to=vgnd_li
  s2 = strap li from=c6 to=vpwr_li
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # routes for nets with multiple pieces
  route VGND layers=m1,m2
  route VPWR layers=m1,m2
  route Y layers=m1,m2
  # pins
  port A in on=l11
  port B in on=l12
  port C in on=l13
  port D in on=l14
  port Y out on=l10
end
