# a2111oi_1: lifted from sky130_fd_sc_hd__a2111oi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2111oi_1 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M2 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M4 pmos w=WP l=L d=Y g=D1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M7 nmos w=WN l=L d=VGND g=D1 s=Y b=VNB
  device M8 pmos w=WP l=L d=n4 g=C1 s=n1 b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.9
  x2 = x1 + 0.04
  x3 = x2 + L + 0.355
  x4 = x3 + L + 0.38
  x5 = x4 + L + 0.59
  x6 = x5 + 0.01
  x7 = x6 + L + 0.27
  x8 = x7 + 0.005
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.745, x8 + L + 0.295) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.72, x8 + L + 0.295) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.115, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L + 0.165) yspan=(nb + WN + 0.085, pt - WP - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L + 0.15) yspan=(nb + WN + 0.075, pt - WP - 0.155)
  p8 = rect poly xspan=(x5 - 0.23, x5 + L) yspan=(nb + WN + 0.08, pt - WP - 0.165)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.08, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.22)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x8 + L + 0.19) yspan=(nb + WN + 0.08, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.08, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.585, x1 - 0.27) yspan=(-0.085, nb + 0.29) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 - 0.075) yspan=(-0.085, nb + 0.3) net=VGND
  l3 = rect li xspan=(x8 + L + 0.02, x8 + L + 0.26) yspan=(-0.085, nb + WN - 0.125) net=VGND
  l4 = rect li xspan=(x6 + L + 0.07, x7 - 0.015) yspan=(nb + 0.115, pt - WP - 0.195) net=A2
  l5 = rect li xspan=(x6 + L + 0.07, x8 + L + 0.29) yspan=(nb + WN + 0.135, pt - WP - 0.195) net=A2
  l6 = rect li xspan=(x5 - 0.245, x6 + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.085) net=A1
  l7 = rect li xspan=(x1 - 0.115, x2 + L + 0.155) yspan=(nb + WN + 0.165, pt - 0.03) net=D1
  l8 = rect li xspan=(x3 + 0.005, x4 - 0.185) yspan=(nb + WN + 0.165, pt - 0.03) net=C1
  l9 = rect li xspan=(x4 - 0.015, x4 + L + 0.12) yspan=(nb + WN + 0.165, pt - 0.03) net=B1
  l10 = rect li xspan=(x4 - 0.015, x4 + L + 0.175) yspan=(nb + WN + 0.165, pt - WP - 0.085) net=B1
  l11 = rect li xspan=(x1 - 0.755, x1 - 0.37) yspan=(nb + 0.465, pt - 0.025) net=Y
  l12 = rect li xspan=(x1 - 0.755, x3 - 0.06) yspan=(nb + 0.465, nb + WN - 0.005) net=Y
  l13 = rect li xspan=(x1 - 0.755, x4 + L - 0.01) yspan=(nb + 0.47, nb + WN - 0.005) net=Y
  l14 = rect li xspan=(x1 - 0.755, x5 - 0.265) yspan=(nb + 0.47, nb + WN - 0.07) net=Y
  l15 = rect li xspan=(x1 + L, x3 - 0.06) yspan=(nb + 0.025, nb + WN - 0.005) net=Y
  l16 = rect li xspan=(x4 + L - 0.01, x5 - 0.265) yspan=(nb + 0.07, nb + 0.47) net=Y
  l17 = rect li xspan=(x4 + L - 0.01, x4 + L + 0.205) yspan=(nb + 0.07, nb + WN - 0.005) net=Y
  l18 = rect li xspan=(x5 - 0.29, x5 - 0.06) yspan=(pt - WP + 0.095, pt - 0.025) net=n2
  l19 = rect li xspan=(x5 - 0.29, x8 + L + 0.255) yspan=(pt - WP + 0.095, pt - WP + 0.265) net=n2
  l20 = rect li xspan=(x8 + L + 0.06, x8 + L + 0.255) yspan=(pt - WP + 0.095, pt - 0.025) net=n2
  l21 = rect li xspan=(x5 + L - 0.03, x8 + 0.025) yspan=(pt - 0.565, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.42) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.3) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.13) span=(nb + 0.025, nb + WN - 0.005) margin=0.04 net=Y
  c4 = array licon in=nd1 cx=(x4 + L + 0.16) span=(nb + 0.07, nb + WN - 0.07) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x8 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.125 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x2 + L + 0.125) span=(nb + 0.025 + 0.08, nb + WN - 0.005 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x1 - 0.455) span=(nb + 0.465 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x5 - 0.145) span=(pt - WP + 0.095 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n2
  c9 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - WP + 0.095 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x6 + L + 0.13) span=(pt - 0.565, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.01) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 - 0.065) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + L + 0.01) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.9, x8 + L + 0.43) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.67) cy=0
  mc2 = contact mcon cx=(x1 - 0.21) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.07) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.035) cy=0
  mc5 = contact mcon cx=(x4 + L - 0.03) cy=0
  mc6 = contact mcon cx=(x5 - 0.155) cy=0
  mc7 = contact mcon cx=(x7 - 0.115) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.2) cy=0
  mc9 = contact mcon cx=(x1 - 0.67) cy=H
  mc10 = contact mcon cx=(x1 - 0.21) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.07) cy=H
  mc12 = contact mcon cx=(x3 + L + 0.035) cy=H
  mc13 = contact mcon cx=(x4 + L - 0.03) cy=H
  mc14 = contact mcon cx=(x5 - 0.155) cy=H
  mc15 = contact mcon cx=(x7 - 0.115) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.2) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l5
  port B1 in on=l9
  port C1 in on=l8
  port D1 in on=l7
  port Y out on=l11
end
