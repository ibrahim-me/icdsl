# STARTING POINT: the verified library cell a32oi_1 (Y = (!A1&!B1) | (!A1&!B2) | (!A2&!B1) | (!A3&!B1) | (!A2&!B2) | (!A3&!B2)),
# 10 transistors; 5 of them correspond to transistors of mux2i_1.
# Its device lines were replaced by mux2i_1's; net labels were renamed where the circuits
# correspond and removed elsewhere. Change the geometry until it implements the devices below.
# The library cell's own devices (what the geometry below was drawn for):
#   M0 pmos d=n2 g=A1? s=VPWR
#   M1 nmos d=n2? g=A2? s=n3
#   M2 pmos d=n2 g=S s=VPWR
#   M3 nmos d=n5 g=A0 s=Y
#   M4 pmos d=VPWR g=A2? s=n2
#   M5 nmos d=n3 g=S s=VGND
#   M6 nmos d=Y g=A1? s=n2?
#   M7 nmos d=VGND g=n1 s=n5
#   M8 pmos d=n2 g=n1 s=Y
#   M9 pmos d=Y g=A0 s=n2
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
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

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.24
  x3 = x2 + 0.04
  x4 = x3 + L + 0.44
  x5 = x4 + L + 0.23
  x6 = x5 + 0.05
  x7 = x6 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.025, x3 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.115, x4 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.075)
  p9 = rect poly xspan=(x5, x6 + L + 0.075) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.075, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.295) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x7 + L - 0.04, x7 + L + 0.305) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l3 = rect li xspan=(x4 - 0.17, x4 + L + 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.23)
  l4 = rect li xspan=(x4 + 0.01, x4 + L + 0.055) yspan=(nb + 0.11, pt - WP - 0.23)
  l5 = rect li xspan=(x4 + 0.01, x5 - 0.065) yspan=(nb + 0.11, nb + WN - 0.12)
  l6 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l7 = rect li xspan=(x6 - 0.01, x7 - 0.085) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  l8 = rect li xspan=(x6 + L, x7 - 0.085) yspan=(nb + 0.18, pt - WP - 0.16)
  l9 = rect li xspan=(x7 + L - 0.06, x7 + L + 0.36) yspan=(nb + WN + 0.13, pt - WP - 0.16) net=S
  l10 = rect li xspan=(x3 + 0.04, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A0
  l11 = rect li xspan=(x3 + 0.04, x4 - 0.145) yspan=(pt - WP - 0.06, pt - WP + 0.13) net=A0
  l12 = rect li xspan=(x1 + L - 0.03, x2 - 0.095) yspan=(nb + 0.4, pt - 0.4) net=Y
  l13 = rect li xspan=(x1 + L - 0.03, x3 + L + 0.205) yspan=(nb + 0.4, nb + WN - 0.08) net=Y
  l14 = rect li xspan=(x1 + L - 0.03, x3 + 0.05) yspan=(pt - WP + 0.3, pt - 0.4) net=Y
  l15 = rect li xspan=(x2 + L - 0.01, x3 + L + 0.205) yspan=(nb + 0.06, nb + WN - 0.08) net=Y
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.35, pt - 0.02) net=n2
  l17 = rect li xspan=(x1 - 0.315, x4 - 0.055) yspan=(pt - 0.23, pt - 0.02) net=n2
  l18 = rect li xspan=(x3 + L + 0.135, x7 - 0.065) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n2
  l19 = rect li xspan=(x3 + L + 0.135, x4 - 0.055) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l20 = rect li xspan=(x6 + L + 0.055, x7 - 0.065) yspan=(pt - WP + 0.26, pt - 0.02) net=n2
  l21 = rect li xspan=(x4 + L + 0.015, x6 - 0.01) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l22 = rect li xspan=(x7 + L - 0.04, x7 + L + 0.305) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c2 = array licon in=nd1 cx=(x7 + L + 0.14) span=(-0.085, nb + WN - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.12) span=(nb + 0.06 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=Y
  c4 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  c5 = array licon in=pd1 cx=(x4 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c6 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.26 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) net=n2
  c8 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - WP + 0.3, pt - 0.4) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x5 - 0.09) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.12) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.83) yspan=(nb + WN + 0.09, pt - WP - 0.135)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.07) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.11) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.6) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.09) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.07) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.11) cy=H
  mc13 = contact mcon cx=(x7 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.6) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  # (library port A1 has no counterpart) port A1 in on=l5
  # (library port A2 has no counterpart) port A2 in on=l8
  port S in on=l9
  port A0 in on=l11
  # (library port B2 has no counterpart) port B2 in on=l6
  port Y out on=l12
  # TODO: port A1 in on=<a met1 pad on A1's li>   (no counterpart in a32oi_1)
end
