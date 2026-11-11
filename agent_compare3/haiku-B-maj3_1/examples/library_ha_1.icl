# ha_1: lifted from sky130_fd_sc_hd__ha_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell ha_1 width=12 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=B s=n2 b=VNB
  device M1 nmos w=WN2 l=L d=n3 g=n1 s=n4 b=VNB
  device M2 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=COUT b=VPB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n4 b=VNB
  device M5 pmos w=WP2 l=L d=n3 g=B s=n5 b=VPB
  device M6 pmos w=WP2 l=L d=n5 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=SUM g=n3 s=VGND b=VNB
  device M8 nmos w=WN2 l=L d=n2 g=A s=VGND b=VNB
  device M9 pmos w=WP l=L d=SUM g=n3 s=VPWR b=VPB
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3 b=VPB
  device M11 nmos w=WN2 l=L d=n4 g=B s=VGND b=VNB
  device M12 nmos w=WN l=L d=VGND g=n1 s=COUT b=VNB
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.775
  x3 = x2 + 0.025
  x4 = x3 + L + 0.255
  x5 = x4 + 0.025
  x6 = x5 + L + 0.28
  x7 = x6 + 0.105
  x8 = x7 + L + 0.72
  x9 = x8 + 0.08
  x10 = x9 + L + 0.22
  x11 = x10 + L + 0.335
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x2 - 0.24, x7 + L + 0.16) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x8 - 0.185, x11 + L + 0.265) yspan=(nb, nb + WN2)
  nd4 = rect diff xspan=(x10 + L + 0.08, x11 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x11 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x10 + L + 0.08, x11 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.25) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.065, x3 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(pt - WP + 0.01, H - 0.105)
  p7 = rect poly xspan=(x4, x6 - 0.11) yspan=(pt - WP + 0.01, pt - WP2 - 0.24)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP2 - 0.24)
  p9 = rect poly xspan=(x6 - 0.01, x7 + L) yspan=(nb + WN + 0.25, pt - WP - 0.2)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.2)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.25, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.21) yspan=(nb + WN + 0.35, pt - WP + 0.08)
  p13 = rect poly xspan=(x8 - 0.28, x8 - 0.01) yspan=(pt - WP + 0.09, pt - WP2 - 0.16)
  p14 = rect poly xspan=(x8 - 0.16, x8 - 0.01) yspan=(nb + WN2 + 0.08, pt - WP2 - 0.14)
  p15 = rect poly xspan=(x8 - 0.16, x9 + L) yspan=(nb + WN2 + 0.08, nb + WN)
  p16 = rect poly xspan=(x8 - 0.16, x8 + L) yspan=(pt - WP + 0.29, pt - WP2 - 0.14)
  p17 = rect poly xspan=(x8, x8 + L) yspan=(pt - WP + 0.29, H - 0.105)
  p18 = rect poly xspan=(x9, x9 + L) yspan=(0.105, nb + WN)
  p19 = rect poly xspan=(x9 + L - 0.025, x10 + L) yspan=(nb + WN + 0.27, pt - WP)
  p20 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x11 - 0.12, x11 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p22 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 + L + 0.055, x4 - 0.03) yspan=(nb + 0.11, nb + WN - 0.08) net=n4
  l2 = rect li xspan=(x3 + L + 0.055, x7 + L + 0.12) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n4
  l3 = rect li xspan=(x6 + L + 0.05, x7 + L + 0.12) yspan=(nb + 0.11, nb + WN - 0.08) net=n4
  l4 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.25) yspan=(-0.085, nb + WN) net=VGND
  l5 = rect li xspan=(x4 + L - 0.005, x6 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l6 = rect li xspan=(x10 + L + 0.03, x11 - 0.055) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l7 = rect li xspan=(x6 + L + 0.01, x10 + 0.005) yspan=(pt - WP - 0.17, pt - WP) net=A
  l8 = rect li xspan=(x9 + L - 0.01, x10 + 0.005) yspan=(nb + WN + 0.17, pt - WP + 0.13) net=A
  l9 = rect li xspan=(x1 + L - 0.055, x2 - 0.185) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l10 = rect li xspan=(x2 - 0.355, x2 - 0.185) yspan=(nb + 0.11, pt - WP2 + 0.04) net=n3
  l11 = rect li xspan=(x2 - 0.355, x2 - 0.03) yspan=(nb + 0.11, nb + WN2 + 0.02) net=n3
  l12 = rect li xspan=(x2 - 0.355, x4 - 0.055) yspan=(pt - WP2 - 0.13, pt - WP2 + 0.04) net=n3
  l13 = rect li xspan=(x3 + L + 0.03, x4 - 0.055) yspan=(pt - WP2 - 0.13, pt - 0.13) net=n3
  l14 = rect li xspan=(x2 - 0.015, x8 + 0.03) yspan=(pt - WP - 0.51, pt - WP - 0.34) net=n1
  l15 = rect li xspan=(x2 - 0.015, x2 + L + 0.01) yspan=(pt - WP - 0.51, pt - WP - 0.16) net=n1
  l16 = rect li xspan=(x8 - 0.145, x8 + 0.03) yspan=(nb + 0.11, pt - WP - 0.34) net=n1
  l17 = rect li xspan=(x8 - 0.145, x11 - 0.055) yspan=(nb + WN2 + 0.06, nb + WN) net=n1
  l18 = rect li xspan=(x9 + L - 0.02, x10 - 0.065) yspan=(pt - WP + 0.3, pt - 0.13) net=n1
  l19 = rect li xspan=(x9 + L - 0.02, x11 - 0.055) yspan=(pt - WP + 0.3, pt - WP2 - 0.11) net=n1
  l20 = rect li xspan=(x10 + L + 0.11, x11 - 0.055) yspan=(nb + WN2 + 0.06, pt - WP2 - 0.11) net=n1
  l21 = rect li xspan=(x10 + L + 0.11, x11 + L - 0.045) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n1
  l22 = rect li xspan=(x4 + L - 0.03, x6 - 0.025) yspan=(pt - WP - 0.14, pt - 0.11) net=B
  l23 = rect li xspan=(x4 + L - 0.03, x8 + 0.025) yspan=(pt - WP + 0.17, pt - WP2 - 0.24) net=B
  l24 = rect li xspan=(x1 - 0.31, x1 - 0.08) yspan=(nb + 0.08, pt - 0.07) net=SUM
  l25 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(nb + 0.08, nb + WN - 0.06) net=SUM
  l26 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.08, pt - 0.07) net=SUM
  l27 = rect li xspan=(x11 + L - 0.03, x11 + L + 0.315) yspan=(nb + 0.08, nb + WN - 0.06) net=COUT
  l28 = rect li xspan=(x11 + L - 0.03, x11 + L + 0.315) yspan=(pt - WP + 0.08, pt - 0.07) net=COUT
  l29 = rect li xspan=(x11 + L + 0.13, x11 + L + 0.315) yspan=(nb + 0.08, pt - 0.07) net=COUT
  l30 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.25) yspan=(pt - WP + 0.03, H + 0.085) net=VPWR
  l31 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l32 = rect li xspan=(x7 + L + 0.025, x8 - 0.025) yspan=(pt - WP2 + 0.21, H + 0.085) net=VPWR
  l33 = rect li xspan=(x10 + L + 0.03, x11 - 0.055) yspan=(pt - WP2 + 0.06, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c3 = array licon in=nd4 cx=(x11 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.11 - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.08, nb + WN - 0.06) net=SUM
  c5 = array licon in=nd4 cx=(x11 + L + 0.14) span=(nb + 0.08, nb + WN - 0.06) net=COUT
  c6 = array licon in=nd1 cx=(x2 - 0.115) span=(nb + 0.11 + 0.08, nb + WN2 + 0.02 - 0.08) net=n3
  c7 = array licon in=nd1 cx=(x4 - 0.115) span=(nb + 0.11 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=n4
  c8 = array licon in=nd1 cx=(x7 + L + 0.035) span=(nb + 0.11 + 0.08, nb + WN - 0.08 - 0.08) net=n4
  c9 = array licon in=nd3 cx=(x8 - 0.06) span=(nb + 0.11 + 0.08, pt - WP - 0.34 - 0.08) net=n1
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.07) net=SUM
  c11 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - WP + 0.08, pt - 0.07) net=COUT
  c12 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x3 + L + 0.115) span=(pt - WP2 - 0.13 + 0.08, pt - 0.13 - 0.08) margin=0.04 net=n3
  c14 = array licon in=pd2 cx=(x9 + L + 0.07) span=(pt - WP + 0.3 + 0.08, pt - 0.13 - 0.08) margin=0.04 net=n1
  c15 = array licon in=pd3 cx=(x11 - 0.14) span=(pt - WP2 + 0.06 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd2 cx=(x2 - 0.22) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd2 cx=(x7 + L + 0.19) span=(pt - WP2 + 0.21, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd2 cx=(x8 - 0.19) span=(pt - WP2 + 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.115) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.05) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x11 + 0.02) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x10 - 0.105) cy=(pt - WP - 0.165)
  gc5 = contact licon cx=(x7 + L + 0.075) cy=(pt - WP - 0.085)
  gc6 = contact licon cx=(x5 + L + 0.035) cy=(pt - WP + 0.175)
  gc7 = contact licon cx=(x8 - 0.145) cy=(pt - WP + 0.255)
  np1 = rect npc xspan=(x1 - 0.4, x11 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x5 - 0.005, x9 - 0.035) yspan=(nb + WN + 0.09, pt - WP + 0.1)
  np3 = rect npc xspan=(x5 - 0.005, x6 - 0.06) yspan=(nb + WN + 0.09, pt - WP2 - 0.22)
  np4 = rect npc xspan=(x5 - 0.005, x10 + L - 0.045) yspan=(nb + WN + 0.09, pt - WP2 - 0.56)
  np5 = rect npc xspan=(x8 - 0.33, x9 - 0.035) yspan=(nb + WN + 0.09, pt - WP2 - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.165) cy=0
  mc4 = contact mcon cx=(x4 - 0.125) cy=0
  mc5 = contact mcon cx=(x6 - 0.11) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.105) cy=0
  mc7 = contact mcon cx=(x8 - 0.155) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.085) cy=0
  mc9 = contact mcon cx=(x11 - 0.15) cy=0
  mc10 = contact mcon cx=(x11 + L + 0.17) cy=0
  mc11 = contact mcon cx=(x1 - 0.17) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc13 = contact mcon cx=(x2 - 0.165) cy=H
  mc14 = contact mcon cx=(x4 - 0.125) cy=H
  mc15 = contact mcon cx=(x6 - 0.11) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.105) cy=H
  mc17 = contact mcon cx=(x8 - 0.155) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.085) cy=H
  mc19 = contact mcon cx=(x11 - 0.15) cy=H
  mc20 = contact mcon cx=(x11 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port B in on=l22
  port COUT out on=l28
  port SUM out on=l24
end
