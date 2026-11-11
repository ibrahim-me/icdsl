# a22o_1: lifted from sky130_fd_sc_hd__a22o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a22o_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=B1 s=n4 b=VNB
  device M4 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M5 nmos w=WN l=L d=n4 g=A1 s=n2 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M7 nmos w=WN l=L d=VGND g=B2 s=n3 b=VNB
  device M8 pmos w=WP l=L d=n4 g=B2 s=n1 b=VPB
  device M9 pmos w=WP l=L d=n1 g=B1 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.24
  x3 = x2 + 0.04
  x4 = x3 + L + 0.76
  x5 = x4 + 0.03
  x6 = x5 + L + 0.33
  x7 = x6 + L + 0.32
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.225) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.255) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt - WP + 0.285)
  pd3 = rect diff xspan=(x4 - 0.235, x7 + L + 0.265) yspan=(pt - 0.29, pt)
  pd4 = rect diff xspan=(x4 - 0.225, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.225, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.13)
  p7 = rect poly xspan=(x4 - 0.225, x4 + L + 0.005) yspan=(nb + WN + 0.435, pt - WP - 0.13)
  p8 = rect poly xspan=(x4 - 0.225, x4 + L + 0.01) yspan=(nb + WN + 0.44, pt - WP - 0.13)
  p9 = rect poly xspan=(x4 - 0.225, x4 + L + 0.015) yspan=(nb + WN + 0.45, pt - WP - 0.13)
  p10 = rect poly xspan=(x4 - 0.225, x5 + L - 0.01) yspan=(pt - WP - 0.145, pt - WP - 0.13)
  p11 = rect poly xspan=(x4 - 0.085, x5 + L) yspan=(pt - WP - 0.13, pt - WP - 0.075)
  p12 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.075)
  p13 = rect poly xspan=(x5, x5 + L) yspan=(pt - WP - 0.13, H - 0.105)
  p14 = rect poly xspan=(x6 - 0.135, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.22)
  p15 = rect poly xspan=(x6 - 0.13, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.21)
  p16 = rect poly xspan=(x6 - 0.125, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.195)
  p17 = rect poly xspan=(x6 - 0.12, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.18)
  p18 = rect poly xspan=(x6 - 0.115, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.165)
  p19 = rect poly xspan=(x6 - 0.105, x6 + L) yspan=(nb + WN + 0.075, pt - WP - 0.16)
  p20 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x7 - 0.105, x7 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p22 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 + L) yspan=(-0.085, nb + WN - 0.035) net=VGND
  l2 = rect li xspan=(x6 + L + 0.015, x7 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l4 = rect li xspan=(x2 - 0.015, x3 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l5 = rect li xspan=(x3 + L + 0.06, x3 + L + 0.28) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=B1
  l6 = rect li xspan=(x4 - 0.235, x4 - 0.025) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=A1
  l7 = rect li xspan=(x4 - 0.235, x4 + L - 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l8 = rect li xspan=(x5 + L + 0.095, x6 + L + 0.035) yspan=(nb + WN + 0.155, pt - WP - 0.14) net=A2
  l9 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=n4
  l10 = rect li xspan=(x1 - 0.31, x3 + L + 0.305) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n4
  l11 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.76, pt - 0.02) net=n4
  l12 = rect li xspan=(x3 + 0.005, x6 - 0.1) yspan=(nb + 0.02, nb + 0.23) net=n4
  l13 = rect li xspan=(x2 + L + 0.01, x3 + L + 0.305) yspan=(pt - WP - 0.03, pt - WP + 0.23) net=n4
  l14 = rect li xspan=(x2 + L + 0.01, x7 + 0.06) yspan=(pt - WP + 0.03, pt - WP + 0.2) net=n4
  l15 = rect li xspan=(x5 + L + 0.06, x6 - 0.1) yspan=(nb + 0.02, nb + WN - 0.1) net=n4
  l16 = rect li xspan=(x5 + L + 0.06, x7 + 0.03) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=n4
  l17 = rect li xspan=(x7 - 0.155, x7 + 0.03) yspan=(nb + WN - 0.27, nb + WN + 0.02) net=n4
  l18 = rect li xspan=(x7 - 0.085, x7 + 0.06) yspan=(pt - WP - 0.005, pt - WP + 0.2) net=n4
  l19 = rect li xspan=(x7 - 0.055, x7 + L - 0.03) yspan=(nb + WN - 0.145, pt - WP + 0.14) net=n4
  l20 = rect li xspan=(x1 + L + 0.055, x2 + 0.005) yspan=(pt - 0.69, pt - 0.36) net=n1
  l21 = rect li xspan=(x1 + L + 0.055, x6 - 0.015) yspan=(pt - WP + 0.4, pt - 0.4) net=n1
  l22 = rect li xspan=(x1 + L + 0.055, x3 + 0.01) yspan=(pt - WP + 0.4, pt - 0.36) net=n1
  l23 = rect li xspan=(x4 - 0.35, x6 - 0.015) yspan=(pt - WP + 0.39, pt - 0.4) net=n1
  l24 = rect li xspan=(x5 + L + 0.065, x6 - 0.015) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l25 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.315) yspan=(nb + 0.02, nb + WN - 0.3) net=X
  l26 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.315) yspan=(pt - WP + 0.3, pt - 0.02) net=X
  l27 = rect li xspan=(x7 + L + 0.145, x7 + L + 0.315) yspan=(nb + 0.02, pt - 0.02) net=X
  l28 = rect li xspan=(x4 - 0.29, x5 + 0.04) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l29 = rect li xspan=(x6 + L + 0.095, x7 + 0.03) yspan=(pt - 0.63, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x7 - 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.1) span=(nb + 0.02, nb + 0.23) net=n4
  c3 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.02, nb + 0.23) net=n4
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN - 0.035) net=VGND
  c5 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.3 - 0.08) net=X
  c6 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.03, pt - WP + 0.23) net=n4
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) net=n4
  c8 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - 0.69 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd4 cx=(x5 + L + 0.15) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c10 = array licon in=pd4 cx=(x7 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=X
  c11 = array licon in=pd4 cx=(x7 - 0.14) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd4 cx=(x4 - 0.11) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.07) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + 0.035) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x6 - 0.135, x6 + L + 0.11) yspan=(nb + WN + 0.09, pt - WP - 0.135)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.11) cy=0
  mc5 = contact mcon cx=(x6 - 0.15) cy=0
  mc6 = contact mcon cx=(x7 - 0.15) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.09) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc11 = contact mcon cx=(x4 - 0.11) cy=H
  mc12 = contact mcon cx=(x6 - 0.15) cy=H
  mc13 = contact mcon cx=(x7 - 0.15) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l8
  port B1 in on=l4
  port B2 in on=l3
  port X out on=l26
end
