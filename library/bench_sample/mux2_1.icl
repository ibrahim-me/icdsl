# mux2_1: lifted from sky130_fd_sc_hd__mux2_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell mux2_1 width=11 height=H
  device M0 pmos w=WP2 l=L d=VPWR g=S s=n1
  device M1 nmos w=WN2 l=L d=n2 g=A0 s=n3
  device M2 pmos w=WP2 l=L d=n4 g=n5 s=VPWR
  device M3 pmos w=WP2 l=L d=VPWR g=S s=n5
  device M4 pmos w=WP2 l=L d=n2 g=A1 s=n4
  device M5 nmos w=WN2 l=L d=n6 g=A1 s=n2
  device M6 pmos w=WP2 l=L d=n1 g=A0 s=n2
  device M7 nmos w=WN l=L d=X g=n2 s=VGND
  device M8 pmos w=WP l=L d=X g=n2 s=VPWR
  device M9 nmos w=WN2 l=L d=VGND g=S s=n6
  device M10 nmos w=WN2 l=L d=VGND g=S s=n5
  device M11 nmos w=WN2 l=L d=n3 g=n5 s=VGND

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.405
  x3 = x2 + L + 0.34
  x4 = x3 + 0.035
  x5 = x4 + L + 0.45
  x6 = x5 + L + 0.34
  x7 = x6 + L + 0.22
  x8 = x7 + L + 0.34
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x2 - 0.14) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 - 0.14) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x8 + L + 0.285) yspan=(pt - 0.195 - WP2, pt - 0.195)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt - WP - 0.34)
  p2 = rect poly xspan=(x3, x5 - 0.215) yspan=(nb + WN2 + 0.16, pt - WP - 0.34)
  p3 = rect poly xspan=(x2 - 0.085, x2 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt - 0.065)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(pt - 0.195 - WP2 - 0.225, pt - 0.065)
  p6 = rect poly xspan=(x4, x5 + L) yspan=(pt - 0.195 - WP2 - 0.225, pt - 0.195 - WP2 - 0.075)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb - 0.13, pt - 0.195 - WP2 - 0.075)
  p8 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN2 + 0.16, pt - WP - 0.34)
  p9 = rect poly xspan=(x6 - 0.125, x6 + L) yspan=(pt - WP - 0.105, pt - 0.195 - WP2 - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(pt - WP - 0.105, pt - 0.065)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.13, nb + WN + 0.11)
  p12 = rect poly xspan=(x6, x7 + L + 0.125) yspan=(nb + WN - 0.04, nb + WN + 0.11)
  p13 = rect poly xspan=(x7 - 0.065, x7 + L + 0.125) yspan=(nb + WN - 0.04, nb + WN + 0.23)
  p14 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN - 0.04, pt - 0.065)
  p15 = rect poly xspan=(x8 - 0.125, x8 + L) yspan=(nb + WN + 0.495, pt - 0.195 - WP2 - 0.16)
  p16 = rect poly xspan=(x8, x8 + L) yspan=(nb - 0.13, pt - 0.065)
  p17 = rect poly xspan=(x1 - 0.02, x1 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p18 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.1) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x7 - 0.085, x8 - 0.055) yspan=(-0.085, nb + 0.385) net=VGND
  l3 = rect li xspan=(x5 - 0.06, x5 + L + 0.075) yspan=(nb + 0.02, pt - WP - 0.07) net=A0
  l4 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.185) yspan=(nb + WN2 + 0.16, pt - 0.195 - WP2 - 0.085) net=A1
  l5 = rect li xspan=(x4 + L + 0.015, x6 + L - 0.05) yspan=(pt - 0.195 - WP2 - 0.255, pt - 0.195 - WP2 - 0.085) net=A1
  l6 = rect li xspan=(x6 - 0.095, x6 + L - 0.05) yspan=(nb + 0.02, pt - 0.195 - WP2 - 0.085) net=A1
  l7 = rect li xspan=(x1 + 0.035, x1 + L + 0.145) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n2
  l8 = rect li xspan=(x1 + L - 0.03, x4 - 0.01) yspan=(nb + WN2, nb + WN2 + 0.17) net=n2
  l9 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.145) yspan=(nb + WN2, pt - WP - 0.16) net=n2
  l10 = rect li xspan=(x3 - 0.155, x4 + L + 0.2) yspan=(nb + 0.02, nb + 0.385) net=n2
  l11 = rect li xspan=(x3 - 0.155, x4 - 0.01) yspan=(nb + 0.02, nb + WN2 + 0.17) net=n2
  l12 = rect li xspan=(x3 - 0.15, x4 - 0.01) yspan=(nb + 0.02, pt - 0.195 - 0.165) net=n2
  l13 = rect li xspan=(x3 - 0.15, x6 - 0.13) yspan=(pt - 0.195 - WP2 + 0.085, pt - 0.195 - 0.165) net=n2
  l14 = rect li xspan=(x7 - 0.065, x8 + L + 0.545) yspan=(nb + WN + 0.01, nb + WN + 0.18) net=n5
  l15 = rect li xspan=(x8 + L + 0.025, x8 + L + 0.27) yspan=(nb + 0.055, nb + WN + 0.18) net=n5
  l16 = rect li xspan=(x8 + L + 0.03, x8 + L + 0.545) yspan=(pt - 0.195 - WP2 + 0.005, pt - 0.195 - 0.005) net=n5
  l17 = rect li xspan=(x8 + L + 0.205, x8 + L + 0.545) yspan=(nb + WN + 0.01, pt - 0.195 - 0.005) net=n5
  l18 = rect li xspan=(x1 - 0.31, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=X
  l19 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l20 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l21 = rect li xspan=(x2 - 0.035, x2 + L + 0.02) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=S
  l22 = rect li xspan=(x2 - 0.01, x2 + L + 0.02) yspan=(pt - WP - 0.49, pt - 0.02) net=S
  l23 = rect li xspan=(x2 - 0.01, x7 + L - 0.07) yspan=(pt - 0.19, pt - 0.02) net=S
  l24 = rect li xspan=(x7 - 0.095, x7 + L - 0.07) yspan=(nb + WN + 0.555, pt - 0.02) net=S
  l25 = rect li xspan=(x7 - 0.095, x8 + L + 0.035) yspan=(nb + WN + 0.555, pt - 0.195 - WP2 - 0.24) net=S
  l26 = rect li xspan=(x1 + L + 0.055, x2 - 0.18) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l27 = rect li xspan=(x7 + L + 0.105, x8 - 0.065) yspan=(pt - 0.195 - WP2 + 0.005, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) net=VGND
  c2 = array licon in=nd1 cx=(x4 + L + 0.115) span=(nb + 0.02 + 0.08, nb + 0.385 - 0.08) margin=0.04 net=n2
  c3 = array licon in=nd1 cx=(x7 + 0.005) span=(-0.085 + 0.08, nb + 0.385 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x8 - 0.14) span=(-0.085 + 0.08, nb + 0.385 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + 0.055 + 0.08, nb + WN + 0.18 - 0.08) net=n5
  c6 = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.02) net=X
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd2 cx=(x5 - 0.19) span=(pt - 0.195 - WP2 + 0.085, pt - 0.195 - 0.165) margin=0.04 net=n2
  c10 = array licon in=pd2 cx=(x5 + L + 0.045) span=(pt - 0.195 - WP2 + 0.085, pt - 0.195 - 0.165) margin=0.04 net=n2
  c11 = array licon in=pd2 cx=(x8 - 0.15) span=(pt - 0.195 - WP2 + 0.005 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - 0.195 - WP2 + 0.005 + 0.08, pt - 0.195 - 0.005 - 0.08) margin=0.04 net=n5
  gc1 = contact licon cx=(x4 + L + 0.1) cy=(pt - WP - 0.505)
  gc2 = contact licon cx=(x5 + L - 0.015) cy=(pt - WP - 0.505)
  gc3 = contact licon cx=(x7 + L - 0.045) cy=(nb + WN + 0.095)
  gc4 = contact licon cx=(x1 + L - 0.03) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x2 + 0.055) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x6 + 0.015) cy=(pt - 0.195 - WP2 - 0.325)
  gc7 = contact licon cx=(x8 + 0.015) cy=(pt - 0.195 - WP2 - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.63) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x3 + L - 0.055, x6 - 0.165) yspan=(nb + WN - 0.09, pt - WP - 0.14)
  np3 = rect npc xspan=(x5 + L + 0.165, x6 + L + 0.055) yspan=(nb + WN + 0.09, pt - 0.195 - WP2 - 0.14)
  np4 = rect npc xspan=(x7 - 0.085, x7 + L + 0.145) yspan=(nb + WN - 0.09, pt - WP - 0.14)
  np5 = rect npc xspan=(x7 + L + 0.165, x8 + L + 0.055) yspan=(nb + WN + 0.09, pt - 0.195 - WP2 - 0.14)
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a0m = contact mcon cx=(x5 + 0.03) cy=(pt - WP - 0.21)
  a0p = enclose a0m m1 by=0.06 net=A0
  port A0 in on=a0p
  a1m = contact mcon cx=(x6 - 0.01) cy=(nb + WN + 0.475)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  sm = contact mcon cx=(x2 + L - 0.07) cy=(pt - WP - 0.15)
  sp = enclose sm m1 by=0.06 net=S
  port S in on=sp
  xm = contact mcon cx=(x1 - 0.225) cy=(pt - WP - 0.125)
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
