# STARTING POINT: the verified library cell o21bai_1 (Y = (!A1&!A2) | (B1_N)),
# 8 transistors; 5 of them correspond to transistors of o211ai_1.
# Its device lines were replaced by o211ai_1's; net labels were renamed where the circuits
# correspond and removed elsewhere. Change the geometry until it implements the devices below.
# The library cell's own devices (what the geometry below was drawn for):
#   M0 nmos d=VGND g=A1 s=n2
#   M1 nmos d=Y g=C1 s=n2
#   M2 pmos d=VPWR g=C1 s=Y
#   M3 nmos d=n2 g=A2 s=VGND
#   M4 pmos d=n1 g=A1 s=VPWR
#   M5 nmos d=VGND g=B1_N? s=C1
#   M6 pmos d=C1 g=B1_N? s=VPWR
#   M7 pmos d=Y g=A2 s=n1
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell o211ai_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.25
  x3 = x2 + L + 0.41
  x4 = x3 + L + 0.315
  x5 = x4 + 0.005
  x6 = x5 + L + 0.26
  x7 = x6 + 0.02
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + 0.02) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x2 + L + 0.145, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 + L - 0.02, x7 + L + 0.265) yspan=(pt - 0.305 - WP2, pt - 0.305)
  pd2 = rect diff xspan=(x2 + L + 0.08, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.085, x1 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x1 + 0.04, x1 + L + 0.045) yspan=(nb + WN + 0.11, pt - 0.305 - WP2 - 0.075)
  p4 = rect poly xspan=(x1 + 0.04, x2 + L) yspan=(pt - WP + 0.05, pt - 0.305 - WP2 - 0.075)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP + 0.05, H - 0.105)
  p6 = rect poly xspan=(x2 + 0.01, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4 - 0.08, x5 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x6, x7 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.04) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x5 + L + 0.055, x6 - 0.035) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l3 = rect li xspan=(x3 + L + 0.01, x5 + 0.025) yspan=(nb + 0.02, nb + 0.23 + 0.02) net=n2
  l4 = rect li xspan=(x3 + L + 0.09, x4 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x3 + L + 0.09, x7 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l6 = rect li xspan=(x6 + L - 0.01, x7 + L + 0.305) yspan=(nb + 0.035, nb + WN + 0.02) net=n2
  l7 = rect li xspan=(x3 + L + 0.045, x5 + L + 0.085) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l8 = rect li xspan=(x6, x7 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l9 = rect li xspan=(x1 + L - 0.02, x2 + 0.015) yspan=(pt - WP + 0.05, pt - 0.305 + 0.03) net=C1
  l10 = rect li xspan=(x1 + L + 0.04, x2 - 0.02) yspan=(nb + 0.23 + 0.03, nb + WN - 0.06) net=C1
  l11 = rect li xspan=(x2 - 0.07, x2 + L - 0.045) yspan=(nb + 0.23 + 0.19, pt - 0.305 - WP2 - 0.055) net=C1
  l12 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.085) yspan=(nb + WN + 0.11, pt - 0.305 - WP2 - 0.055) net=C1
  l13 = rect li xspan=(x1 - 0.315, x1 - 0.045) yspan=(nb + WN + 0.11, pt - 0.04)
  l14 = rect li xspan=(x1 - 0.315, x1 + L - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.14)
  l15 = rect li xspan=(x2 + L + 0.185, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l16 = rect li xspan=(x3 - 0.155, x3 + 0.02) yspan=(nb + 0.23 + 0.18, pt - 0.305 - WP2 - 0.135) net=Y
  l17 = rect li xspan=(x3 - 0.155, x5) yspan=(pt - WP - 0.03, pt - 0.305 - WP2 - 0.135) net=Y
  l18 = rect li xspan=(x3 + L - 0.015, x5) yspan=(pt - WP - 0.03, pt - 0.02) net=Y
  l19 = rect li xspan=(x2 + L + 0.04, x3 - 0.04) yspan=(pt - 0.305 - WP2 + 0.115, H + 0.085) net=VPWR
  l20 = rect li xspan=(x7 + 0.055, x7 + L + 0.285) yspan=(pt - WP + 0.05, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n2
  c2 = array licon in=nd2 cx=(x6 - 0.12) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.035, nb + WN + 0.02) net=n2
  c4 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x2 - 0.11) span=(nb + 0.23 + 0.03 + 0.08, nb + WN - 0.06 - 0.08) net=C1
  c7 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd2 cx=(x7 + L + 0.12) span=(pt - WP + 0.05, H + 0.085) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x1 + L + 0.11) span=(pt - WP + 0.05 + 0.08, pt - 0.305 + 0.03 - 0.08) net=C1
  c10 = array licon in=pd2 cx=(x2 + L + 0.205) span=(pt - 0.305 - WP2 + 0.115, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + 0.055) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.1) cy=0
  mc3 = contact mcon cx=(x3 - 0.19) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.13) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc7 = contact mcon cx=(x1 - 0.17) cy=H
  mc8 = contact mcon cx=(x2 - 0.1) cy=H
  mc9 = contact mcon cx=(x3 - 0.19) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.13) cy=H
  mc11 = contact mcon cx=(x5 + L + 0.13) cy=H
  mc12 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l7
  # (library port B1_N has no counterpart) port B1_N in on=l13
  port Y out on=l18
  # TODO: port C1 in on=<a met1 pad on C1's li>   (no counterpart in o21bai_1)
  # TODO: port B1 in on=<a met1 pad on B1's li>   (no counterpart in o21bai_1)
end
