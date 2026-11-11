# a222oi_1: lifted from sky130_fd_sc_hd__a222oi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.64 WP=1 L=0.15 H=2.72

stdcell a222oi_1 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n3 g=B1 s=n2 b=VPB
  device M3 pmos w=WP l=L d=n2 g=B2 s=n3 b=VPB
  device M4 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n4 g=C2 s=VGND b=VNB
  device M6 nmos w=WN l=L d=Y g=A1 s=n5 b=VNB
  device M7 nmos w=WN l=L d=n5 g=A2 s=VGND b=VNB
  device M8 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M9 nmos w=WN l=L d=Y g=C1 s=n4 b=VNB
  device M10 pmos w=WP l=L d=Y g=C1 s=n3 b=VPB
  device M11 pmos w=WP l=L d=n3 g=C2 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  x4 = x3 + L + 0.86
  x5 = x4 + L + 0.22
  x6 = x5 + 0.06
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.34
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.155)
  p4 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.125, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.165, x4 + L) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.155)
  p9 = rect poly xspan=(x5, x6 + L + 0.065) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.125, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.125) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L + 0.125) yspan=(nb + WN + 0.125, pt - WP - 0.155)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.03, x4 - 0.215) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.305) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.125, pt - WP - 0.17) net=C1
  l4 = rect li xspan=(x2 - 0.045, x3 + L + 0.125) yspan=(nb + WN + 0.125, pt - WP - 0.17) net=C2
  l5 = rect li xspan=(x4 - 0.165, x4 + L) yspan=(nb + WN + 0.125, pt - WP - 0.155) net=B2
  l6 = rect li xspan=(x5 - 0.045, x6 + L + 0.065) yspan=(nb + WN + 0.125, pt - WP - 0.155) net=B1
  l7 = rect li xspan=(x7 - 0.045, x7 + L + 0.125) yspan=(nb + WN + 0.125, pt - WP - 0.155) net=A1
  l8 = rect li xspan=(x8 - 0.045, x8 + L + 0.155) yspan=(nb + WN + 0.125, pt - WP - 0.155) net=A2
  l9 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l10 = rect li xspan=(x1 - 0.305, x7 - 0.015) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=Y
  l11 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=Y
  l12 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP, pt - WP + 0.195) net=Y
  l13 = rect li xspan=(x1 - 0.305, x4 - 0.395) yspan=(pt - WP + 0.015, pt - WP + 0.185) net=Y
  l14 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - 0.23, pt - 0.02) net=Y
  l15 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.225) yspan=(pt - WP + 0.015, pt - WP + 0.345) net=Y
  l16 = rect li xspan=(x3 + L + 0.295, x4 - 0.395) yspan=(nb + WN - 0.23, pt - WP + 0.185) net=Y
  l17 = rect li xspan=(x3 + L + 0.295, x4 - 0.34) yspan=(nb + WN - 0.06, pt - WP - 0.155) net=Y
  l18 = rect li xspan=(x5 + L - 0.01, x7 - 0.015) yspan=(nb + 0.06, nb + WN - 0.06) net=Y
  l19 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(pt - WP + 0.39, pt - 0.41) net=n3
  l20 = rect li xspan=(x1 + L + 0.055, x2 + 0.01) yspan=(pt - WP + 0.39, pt - 0.02) net=n3
  l21 = rect li xspan=(x1 + L + 0.055, x5 + 0.01) yspan=(pt - 0.19, pt - 0.02) net=n3
  l22 = rect li xspan=(x4 + L + 0.055, x5 + 0.01) yspan=(pt - 0.35, pt - 0.02) net=n3
  l23 = rect li xspan=(x4 - 0.305, x4 + L + 0.055) yspan=(pt - WP + 0.34, pt - 0.52) net=n2
  l24 = rect li xspan=(x4 - 0.305, x4 + L - 0.05) yspan=(pt - WP + 0.34, pt - 0.49) net=n2
  l25 = rect li xspan=(x4 - 0.305, x4 + L - 0.03) yspan=(pt - WP + 0.34, pt - 0.505) net=n2
  l26 = rect li xspan=(x4 - 0.305, x4 + L + 0.01) yspan=(pt - WP + 0.34, pt - 0.515) net=n2
  l27 = rect li xspan=(x4 + 0.03, x7 - 0.055) yspan=(pt - WP + 0.17, pt - WP + 0.34) net=n2
  l28 = rect li xspan=(x5 + L + 0.03, x7 - 0.055) yspan=(pt - WP + 0.015, pt - 0.02) net=n2
  l29 = rect li xspan=(x5 + L + 0.03, x8 + L + 0.315) yspan=(pt - WP + 0.015, pt - WP + 0.185) net=n2
  l30 = rect li xspan=(x5 + L + 0.03, x7 + 0.03) yspan=(pt - WP + 0.015, pt - WP + 0.25) net=n2
  l31 = rect li xspan=(x5 + L + 0.03, x7 + 0.03) yspan=(pt - 0.23, pt - 0.02) net=n2
  l32 = rect li xspan=(x8 + L - 0.065, x8 + L + 0.315) yspan=(pt - WP + 0.015, pt - WP + 0.25) net=n2
  l33 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.315) yspan=(pt - 0.23, pt - 0.02) net=n2
  l34 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.315) yspan=(pt - WP + 0.015, pt - 0.02) net=n2
  l35 = rect li xspan=(x7 + L - 0.03, x8 - 0.035) yspan=(pt - WP + 0.42, pt - WP + 0.59) net=VPWR
  l36 = rect li xspan=(x7 + L + 0.055, x8 - 0.115) yspan=(pt - WP + 0.42, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.06) net=Y
  c2 = array licon in=nd1 cx=(x3 + L + 0.08) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.42) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 + L + 0.1) span=(nb + 0.06, nb + WN - 0.06) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  c7 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.015 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c8 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.015 + 0.08, pt - 0.02 - 0.08) net=n2
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.015 + 0.08, pt - WP + 0.345 - 0.08) net=Y
  c10 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP + 0.34, pt - 0.49) net=n2
  c11 = array licon in=pd1 cx=(x2 - 0.08) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c12 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP + 0.42 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c13 = array licon in=pd2 cx=(x5 - 0.08) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  gc1 = contact licon cx=(x1 - 0.02) cy=(nb + WN + 0.29)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.29)
  gc3 = contact licon cx=(x4 + 0.005) cy=(nb + WN + 0.29)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.29)
  gc5 = contact licon cx=(x7 + L - 0.015) cy=(nb + WN + 0.29)
  gc6 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.29)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.4) yspan=(nb + WN + 0.1, pt - WP - 0.135)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.21) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.11) cy=0
  mc6 = contact mcon cx=(x7 - 0.13) cy=0
  mc7 = contact mcon cx=(x8 - 0.15) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.07) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc12 = contact mcon cx=(x4 - 0.21) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.11) cy=H
  mc14 = contact mcon cx=(x7 - 0.13) cy=H
  mc15 = contact mcon cx=(x8 - 0.15) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l8
  port B1 in on=l6
  port B2 in on=l5
  port C1 in on=l3
  port C2 in on=l4
  port Y out on=l16
end
