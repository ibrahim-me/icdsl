# and4bb_1: lifted from sky130_fd_sc_hd__and4bb_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4bb_1 width=12 height=H taps=no
  device M0 pmos w=WP2 l=L d=VPWR g=B_N s=n1 b=VPB
  device M1 pmos w=WP2 l=L d=n2 g=n1 s=VPWR b=VPB
  device M2 nmos w=WN2 l=L d=VGND g=B_N s=n1 b=VNB
  device M3 pmos w=WP2 l=L d=VPWR g=C s=n2 b=VPB
  device M4 nmos w=WN2 l=L d=n3 g=C s=n4 b=VNB
  device M5 pmos w=WP2 l=L d=n5 g=A_N s=VPWR b=VPB
  device M6 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M7 nmos w=WN2 l=L d=n2 g=n5 s=n6 b=VNB
  device M8 nmos w=WN2 l=L d=n6 g=n1 s=n3 b=VNB
  device M9 pmos w=WP2 l=L d=n2 g=D s=VPWR b=VPB
  device M10 nmos w=WN2 l=L d=n5 g=A_N s=VGND b=VNB
  device M11 nmos w=WN2 l=L d=n4 g=D s=VGND b=VNB
  device M12 pmos w=WP2 l=L d=VPWR g=n5 s=n2 b=VPB
  device M13 nmos w=WN l=L d=VGND g=n2 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.54
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.89
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.36
  x6 = x5 + L + 0.38
  x7 = x6 + L + 0.47
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.405, x2 + L + 0.335) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x3 - 0.285, x7 + L + 0.255) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x6 + L + 0.205, x7 + L + 0.255) yspan=(nb, nb + WN)
  nd4 = rect diff xspan=(x6 + L + 0.205, x7 + L + 0.265) yspan=(nb + 0.04, nb + WN2 - 0.09)
  pd1 = rect diff xspan=(x1 - 0.405, x2 + L + 0.325) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x3 - 0.295, x7 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x6 + L + 0.205, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.115, x1 + L + 0.075) yspan=(pt - WP + 0.12, pt - WP2 - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.075, x2 + L + 0.115) yspan=(nb + WN + 0.01, pt - WP - 0.32)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x2 + L + 0.215, x3 + L) yspan=(pt - WP + 0.01, pt - WP2 - 0.24)
  p6 = rect poly xspan=(x3 - 0.215, x3 + L) yspan=(nb + WN + 0.09, pt - WP2 - 0.24)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5 - 0.025, x5 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x6 - 0.065, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x7 - 0.195, x7 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.02) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x6 + L + 0.165, x7 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x1 + 0.07, x1 + L + 0.135) yspan=(nb + WN2 + 0.11, nb + WN + 0.23) net=B_N
  l4 = rect li xspan=(x1 + 0.07, x2 + L + 0.115) yspan=(nb + WN + 0.06, nb + WN + 0.23) net=B_N
  l5 = rect li xspan=(x5 - 0.035, x5 + L + 0.01) yspan=(nb + 0.23 - 0.05, pt - WP + 0.15) net=C
  l6 = rect li xspan=(x5 - 0.035, x5 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  l7 = rect li xspan=(x6 - 0.1, x6 + L - 0.05) yspan=(nb + 0.23 - 0.045, pt - WP + 0.15) net=D
  l8 = rect li xspan=(x6 - 0.1, x6 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=D
  l9 = rect li xspan=(x1 - 0.115, x1 + L + 0.095) yspan=(pt - WP + 0.14, pt - WP2 - 0.11) net=A_N
  l10 = rect li xspan=(x1 - 0.455, x1 - 0.285) yspan=(nb + 0.02, pt - 0.02) net=n5
  l11 = rect li xspan=(x1 - 0.455, x1 - 0.195) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n5
  l12 = rect li xspan=(x1 - 0.455, x2 + L + 0.105) yspan=(nb + WN + 0.4, pt - WP - 0.03) net=n5
  l13 = rect li xspan=(x1 - 0.455, x1 - 0.195) yspan=(pt - WP2 + 0.07, pt - 0.02) net=n5
  l14 = rect li xspan=(x2 + L - 0.07, x2 + L + 0.105) yspan=(nb + WN + 0.4, pt - WP2 - 0.32) net=n5
  l15 = rect li xspan=(x2 + L - 0.07, x3 - 0.375) yspan=(pt - WP2 - 0.49, pt - WP2 - 0.32) net=n5
  l16 = rect li xspan=(x2 + L + 0.055, x4 + L + 0.075) yspan=(nb + 0.02, nb + 0.23 - 0.04) net=n1
  l17 = rect li xspan=(x2 + L + 0.055, x3 - 0.435) yspan=(nb + 0.02, nb + WN2 + 0.1) net=n1
  l18 = rect li xspan=(x2 + L + 0.115, x2 + L + 0.305) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n1
  l19 = rect li xspan=(x2 + L + 0.115, x3 - 0.035) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n1
  l20 = rect li xspan=(x2 + L + 0.285, x3 - 0.435) yspan=(nb + 0.02, pt - WP - 0.08) net=n1
  l21 = rect li xspan=(x2 + L + 0.285, x3 - 0.035) yspan=(pt - WP - 0.25, pt - WP - 0.08) net=n1
  l22 = rect li xspan=(x3 - 0.205, x3 - 0.035) yspan=(pt - WP - 0.25, pt - WP2 + 0.02) net=n1
  l23 = rect li xspan=(x4 + 0.05, x4 + L + 0.075) yspan=(nb + 0.02, pt - WP - 0.16) net=n1
  l24 = rect li xspan=(x3 - 0.245, x4 - 0.125) yspan=(nb + WN2 - 0.06, nb + WN + 0.04) net=n2
  l25 = rect li xspan=(x3 + L - 0.01, x4 - 0.125) yspan=(nb + WN2 - 0.06, pt - WP2 + 0.02) net=n2
  l26 = rect li xspan=(x3 + L - 0.01, x7 + 0.03) yspan=(pt - WP2 - 0.15, pt - WP2 + 0.02) net=n2
  l27 = rect li xspan=(x3 + L + 0.065, x4 - 0.055) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n2
  l28 = rect li xspan=(x5 + L + 0.09, x6 - 0.12) yspan=(pt - WP2 - 0.15, pt - 0.02) net=n2
  l29 = rect li xspan=(x7 - 0.145, x7 + 0.03) yspan=(nb + WN + 0.11, pt - WP2 + 0.02) net=n2
  l30 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.315) yspan=(nb + 0.02, pt - 0.02) net=X
  l31 = rect li xspan=(x1 + L - 0.03, x2 + 0.02) yspan=(pt - WP2 + 0.19, H + 0.085) net=VPWR
  l32 = rect li xspan=(x3 - 0.335, x3) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l33 = rect li xspan=(x4 + L - 0.005, x5 - 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x6 + L + 0.165, x7 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x7 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.28) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n5
  c4 = array licon in=nd1 cx=(x2 + L + 0.21) span=(nb + 0.02 + 0.08, nb + WN2 + 0.1 - 0.08) net=n1
  c5 = array licon in=nd3 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c6 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + WN2 - 0.06 + 0.08, nb + WN + 0.04 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd3 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c8 = array licon in=pd1 cx=(x1 - 0.28) span=(pt - WP2 + 0.07 + 0.08, pt - 0.02 - 0.08) net=n5
  c9 = array licon in=pd1 cx=(x2 + L + 0.2) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) net=n1
  c10 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c11 = array licon in=pd2 cx=(x5 + L + 0.175) span=(pt - WP2 - 0.15 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c12 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.19, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd2 cx=(x3 - 0.17) span=(pt - 0.23, H + 0.085) net=VPWR
  c14 = array licon in=pd2 cx=(x4 + L + 0.165) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd3 cx=(x7 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x2 + L - 0.055) cy=(nb + WN + 0.145)
  gc2 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.06) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x2 + L + 0.35) cy=(pt - WP2 - 0.405)
  gc7 = contact licon cx=(x1 + 0.055) cy=(pt - WP + 0.255)
  np1 = rect npc xspan=(x1 - 0.54, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 - 0.135, x1 + L + 0.095) yspan=(nb + WN + 0.09, pt - WP2 - 0.14)
  np3 = rect npc xspan=(x2 - 0.095, x2 + L + 0.135) yspan=(nb + WN - 0.04, pt - WP - 0.14)
  np4 = rect npc xspan=(x2 + L + 0.165, x3 - 0.355) yspan=(nb + WN + 0.09, pt - WP2 - 0.22)
  # metal
  mc1 = contact mcon cx=(x1 - 0.31) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.01) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.04) cy=0
  mc4 = contact mcon cx=(x3 - 0.39) cy=0
  mc5 = contact mcon cx=(x3 + L/2) cy=0
  mc6 = contact mcon cx=(x4 + L - 0.045) cy=0
  mc7 = contact mcon cx=(x5 + 0.065) cy=0
  mc8 = contact mcon cx=(x6 + 0.005) cy=0
  mc9 = contact mcon cx=(x7 - 0.15) cy=0
  mc10 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc11 = contact mcon cx=(x1 - 0.31) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.01) cy=H
  mc13 = contact mcon cx=(x2 + L + 0.04) cy=H
  mc14 = contact mcon cx=(x3 - 0.39) cy=H
  mc15 = contact mcon cx=(x3 + L/2) cy=H
  mc16 = contact mcon cx=(x4 + L - 0.045) cy=H
  mc17 = contact mcon cx=(x5 + 0.065) cy=H
  mc18 = contact mcon cx=(x6 + 0.005) cy=H
  mc19 = contact mcon cx=(x7 - 0.15) cy=H
  mc20 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l9
  port B_N in on=l3
  port C in on=l5
  port D in on=l7
  port X out on=l30
end
