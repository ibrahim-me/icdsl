# a221oi_1: lifted from sky130_fd_sc_hd__a221oi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a221oi_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B2 s=n1 b=VNB
  device M1 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M3 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M4 nmos w=WN l=L d=Y g=A1 s=n2 b=VNB
  device M5 pmos w=WP l=L d=n3 g=B1 s=n4 b=VPB
  device M6 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=C1 s=n4 b=VPB
  device M8 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=n4 g=B2 s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + 0.055
  x4 = x3 + L + 0.225
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.315
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.31) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.31) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.065, x3 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L + 0.15) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5 - 0.205, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6 - 0.1, x6 + L + 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x3 - 0.025) yspan=(-0.085, nb + 0.33) net=VGND
  l2 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=C1
  l4 = rect li xspan=(x1 + L + 0.075, x3 + L + 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B2
  l5 = rect li xspan=(x4 - 0.015, x4 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l6 = rect li xspan=(x4 + L + 0.035, x4 + L + 0.315) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=B1
  l7 = rect li xspan=(x5 - 0.235, x5 + 0.025) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=A1
  l8 = rect li xspan=(x5 - 0.235, x5 + L - 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l9 = rect li xspan=(x5 + L + 0.15, x6 + L - 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l10 = rect li xspan=(x1 - 0.23, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l11 = rect li xspan=(x1 - 0.23, x4) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=Y
  l12 = rect li xspan=(x1 - 0.225, x5 + L - 0.025) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=Y
  l13 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=Y
  l14 = rect li xspan=(x3 + L + 0.05, x6 - 0.055) yspan=(nb + 0.02, nb + 0.27) net=Y
  l15 = rect li xspan=(x3 + L + 0.05, x4) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l16 = rect li xspan=(x5 - 0.03, x6 + L + 0.36) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l17 = rect li xspan=(x5 + L + 0.06, x6 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l18 = rect li xspan=(x5 + L + 0.06, x6 + L + 0.36) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=Y
  l19 = rect li xspan=(x6 + L + 0.15, x6 + L + 0.36) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l20 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(pt - 0.69, pt - 0.02) net=n4
  l21 = rect li xspan=(x1 + L - 0.03, x4 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=n4
  l22 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - 0.23, pt - 0.02) net=n4
  l23 = rect li xspan=(x3 + L - 0.005, x5 - 0.155) yspan=(pt - WP + 0.31, pt - 0.44) net=n3
  l24 = rect li xspan=(x3 + L - 0.005, x4 + 0.005) yspan=(pt - WP + 0.31, pt - 0.36) net=n3
  l25 = rect li xspan=(x3 + L - 0.005, x6 - 0.01) yspan=(pt - WP + 0.35, pt - 0.44) net=n3
  l26 = rect li xspan=(x5 + L + 0.055, x6 - 0.01) yspan=(pt - WP + 0.35, pt - 0.02) net=n3
  l27 = rect li xspan=(x5 - 0.305, x5 + 0.03) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l28 = rect li xspan=(x6 + L + 0.02, x6 + L + 0.35) yspan=(pt - 0.61, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c3 = array licon in=nd2 cx=(x5 - 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c4 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) net=Y
  c7 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.69 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c9 = array licon in=pd1 cx=(x3 + L + 0.085) span=(pt - WP + 0.31 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=n3
  c10 = array licon in=pd2 cx=(x6 + L + 0.185) span=(pt - 0.61, H + 0.085) net=VPWR
  c11 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - 0.27, H + 0.085) net=VPWR
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.23, pt - 0.02) net=n4
  gc1 = contact licon cx=(x1 - 0.15) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.01) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 - 0.07) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + 0.04) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.445) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x4 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.23) cy=0
  mc5 = contact mcon cx=(x5 - 0.11) cy=0
  mc6 = contact mcon cx=(x6 - 0.105) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.215) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.13) cy=H
  mc10 = contact mcon cx=(x4 - 0.09) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.23) cy=H
  mc12 = contact mcon cx=(x5 - 0.11) cy=H
  mc13 = contact mcon cx=(x6 - 0.105) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.215) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l9
  port B1 in on=l5
  port B2 in on=l4
  port C1 in on=l3
  port Y out on=l19
end
