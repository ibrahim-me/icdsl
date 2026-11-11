# STARTING POINT: the verified library cell a22oi_1 (Y = (!A1&!B1) | (!A1&!B2) | (!A2&!B1) | (!A2&!B2)),
# 8 transistors; 6 of them correspond to transistors of a31oi_1.
# Its device lines were replaced by a31oi_1's; net labels were renamed where the circuits
# correspond and removed elsewhere. Change the geometry until it implements the devices below.
# The library cell's own devices (what the geometry below was drawn for):
#   M0 nmos d=Y g=A1 s=n2
#   M1 pmos d=n1 g=A3 s=VPWR
#   M2 pmos d=VPWR g=A2 s=n1
#   M3 nmos d=n3 g=A3 s=VGND
#   M4 nmos d=VGND g=B1 s=Y
#   M5 pmos d=n2 g=B1 s=n1
#   M6 nmos d=n2 g=A2 s=n3
#   M7 pmos d=n1 g=A1 s=n2
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a31oi_1 width=7 height=H taps=no
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
  x2 = x1 + L + 0.24
  x3 = x2 + 0.04
  x4 = x3 + L + 0.8
  x5 = x4 + L + 0.22
  x6 = x5 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.225) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.305) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.24, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x6 + L - 0.02, x6 + L + 0.315) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + WN - 0.12, pt - WP - 0.21) net=B1
  l4 = rect li xspan=(x2 - 0.015, x3 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l5 = rect li xspan=(x3 + L + 0.03, x3 + L + 0.28) yspan=(nb + WN - 0.21, pt - WP - 0.21) net=A1
  l6 = rect li xspan=(x4 - 0.27, x4 - 0.06) yspan=(nb + WN - 0.21, pt - WP - 0.21) net=A2
  l7 = rect li xspan=(x4 - 0.27, x4 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l8 = rect li xspan=(x4 + L + 0.11, x6 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l9 = rect li xspan=(x1 + L + 0.055, x3 + L + 0.25) yspan=(pt - WP + 0.31, pt - 0.4) net=n1
  l10 = rect li xspan=(x1 + L + 0.055, x4 - 0.285) yspan=(pt - WP + 0.31, pt - 0.45) net=n1
  l11 = rect li xspan=(x1 + L + 0.055, x3 + 0.01) yspan=(pt - WP + 0.31, pt - 0.36) net=n1
  l12 = rect li xspan=(x1 + L + 0.055, x5 + 0.01) yspan=(pt - WP + 0.35, pt - 0.45) net=n1
  l13 = rect li xspan=(x4 + L + 0.055, x5 + 0.01) yspan=(pt - WP + 0.35, pt - 0.32) net=n1
  l14 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l15 = rect li xspan=(x1 - 0.305, x4 + L - 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=n2
  l16 = rect li xspan=(x1 - 0.305, x3 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=n2
  l17 = rect li xspan=(x3 + 0.005, x5 + 0.01) yspan=(nb + 0.02, nb + 0.27) net=n2
  l18 = rect li xspan=(x2 + L + 0.01, x3 + L + 0.305) yspan=(pt - 0.23, pt - 0.02) net=n2
  l19 = rect li xspan=(x4 - 0.145, x6 + L + 0.355) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l20 = rect li xspan=(x4 + L + 0.045, x5 + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l21 = rect li xspan=(x4 + L + 0.045, x6 + L + 0.355) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n2
  l22 = rect li xspan=(x6 + L + 0.185, x6 + L + 0.355) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=n2
  l23 = rect li xspan=(x4 - 0.325, x4 + 0.055) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l24 = rect li xspan=(x6 + L + 0.04, x6 + L + 0.305) yspan=(pt - 0.63, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x6 + L + 0.15) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n2
  c3 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.02, nb + 0.27) net=n2
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.36) net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n2
  c6 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - WP + 0.31 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd2 cx=(x5 - 0.08) span=(pt - WP + 0.35 + 0.08, pt - 0.32 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.23, pt - 0.02) net=n2
  c10 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.085) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.15) cy=0
  mc5 = contact mcon cx=(x5 - 0.05) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.21) cy=0
  mc7 = contact mcon cx=(x1 - 0.17) cy=H
  mc8 = contact mcon cx=(x2 - 0.09) cy=H
  mc9 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc10 = contact mcon cx=(x4 - 0.15) cy=H
  mc11 = contact mcon cx=(x5 - 0.05) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A2 in on=l6
  port A3 in on=l8
  port A1 in on=l5
  port B1 in on=l3
  # (library port Y has no counterpart) port Y out on=l15
  # TODO: port Y out on=<a met1 pad on Y's li>   (no counterpart in a22oi_1)
end
