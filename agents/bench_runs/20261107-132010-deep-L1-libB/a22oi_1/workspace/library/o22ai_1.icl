# o22ai_1: lifted from sky130_fd_sc_hd__o22ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o22ai_1 width=6 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y b=VNB
  device M5 nmos w=WN l=L d=Y g=B2 s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2 b=VPB
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.235
  x3 = x2 + 0.06
  x4 = x3 + L + 0.365
  x5 = x4 + 0.05
  x6 = x5 + L + 0.22
  x7 = x6 + 0.01
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
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.08) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4 - 0.075, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x7 + L + 0.175) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x5 + L, x6 - 0.045) yspan=(-0.085, nb + 0.29) net=VGND
  l2 = rect li xspan=(x1 - 0.315, x4 + 0.01) yspan=(nb + 0.06, nb + 0.24) net=n3
  l3 = rect li xspan=(x3 + L + 0.04, x4 + 0.01) yspan=(nb + 0.06, nb + WN - 0.06) net=n3
  l4 = rect li xspan=(x4 - 0.155, x7 + L + 0.315) yspan=(nb + 0.46, nb + WN - 0.02) net=n3
  l5 = rect li xspan=(x6 + L - 0.02, x7 + L + 0.315) yspan=(nb + 0.045, nb + WN - 0.02) net=n3
  l6 = rect li xspan=(x7, x7 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l7 = rect li xspan=(x3 + 0.005, x3 + L + 0.03) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=B2
  l8 = rect li xspan=(x3 + 0.005, x4 - 0.105) yspan=(pt - WP - 0.07, pt - WP + 0.18) net=B2
  l9 = rect li xspan=(x1 - 0.315, x1 - 0.075) yspan=(nb + WN - 0.22, pt - WP + 0.505) net=B1
  l10 = rect li xspan=(x4 - 0.12, x5 + L + 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l11 = rect li xspan=(x5 + 0.02, x5 + L + 0.055) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A2
  l12 = rect li xspan=(x5 + L - 0.01, x6 - 0.025) yspan=(pt - WP - 0.04, pt - 0.08) net=A2
  l13 = rect li xspan=(x1 + L - 0.05, x2 - 0.11) yspan=(nb + 0.41, pt - 0.44) net=Y
  l14 = rect li xspan=(x1 + L - 0.05, x3 + 0.015) yspan=(nb + 0.41, nb + WN - 0.06) net=Y
  l15 = rect li xspan=(x1 + L - 0.05, x4) yspan=(pt - WP + 0.35, pt - 0.44) net=Y
  l16 = rect li xspan=(x3 + 0.005, x4) yspan=(pt - WP + 0.35, pt - 0.02) net=Y
  l17 = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l18 = rect li xspan=(x6 + L, x7 + L + 0.315) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 + L + 0.09) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06, nb + 0.24) net=n3
  c3 = array licon in=nd1 cx=(x4 - 0.16) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=n3
  c4 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.045, nb + WN - 0.02) net=n3
  c5 = array licon in=nd1 cx=(x2 - 0.095) span=(nb + 0.41, nb + WN - 0.06) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x7 + L + 0.13) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c7 = array licon in=pd1 cx=(x3 + L + 0.08) span=(pt - WP + 0.35, pt - 0.02) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.085) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x5 + L + 0.08) cy=0
  mc5 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x2 - 0.085) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc9 = contact mcon cx=(x5 + L + 0.08) cy=H
  mc10 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l12
  port B1 in on=l9
  port B2 in on=l8
  port Y out on=l16
end
