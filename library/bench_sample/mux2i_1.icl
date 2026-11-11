# mux2i_1: lifted from sky130_fd_sc_hd__mux2i_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i_1 width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + 0.02
  x3 = x2 + L + 0.26
  x4 = x3 + 0.055
  x5 = x4 + L + 0.405
  x6 = x5 + L + 0.22
  x7 = x6 + L + 0.25
  x8 = x7 + 0.03
  x9 = x8 + L + 0.8
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 - 0.175) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 + L - 0.05, x8 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x9 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.235) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 - 0.295, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.115, pt + 0.13)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x4 + L + 0.16) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, pt + 0.13)
  p8 = rect poly xspan=(x5, x6 + L + 0.035) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.13, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.28, pt + 0.13)
  p11 = rect poly xspan=(x7, x9 + L) yspan=(nb + WN + 0.28, pt - WP - 0.135)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb - 0.13, pt - WP - 0.135)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb - 0.13, pt + 0.13)
  p14 = rect poly xspan=(x9, x9 + L + 0.295) yspan=(nb + WN + 0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x6 + L + 0.055, x7 - 0.025) yspan=(-0.085, nb + WN - 0.34) net=VGND
  l2 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.275) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x6 + 0.03) yspan=(nb + WN - 0.63, nb + WN - 0.46) net=n5
  l4 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + WN - 0.63, nb + WN) net=n5
  l5 = rect li xspan=(x1 - 0.315, x2 + 0.025) yspan=(nb + WN - 0.63, nb + WN - 0.42) net=n5
  l6 = rect li xspan=(x3 + L, x6 + 0.03) yspan=(nb + WN - 0.63, nb + WN - 0.42) net=n5
  l7 = rect li xspan=(x3 + L - 0.01, x5 + L - 0.045) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l8 = rect li xspan=(x5 - 0.125, x8 + L + 0.045) yspan=(nb + WN - 0.17, nb + WN) net=n3
  l9 = rect li xspan=(x8 + L + 0.045, x8 + L + 0.28) yspan=(nb + 0.02, nb + WN) net=n3
  l10 = rect li xspan=(x1 - 0.315, x2 + 0.005) yspan=(nb + WN + 0.175, pt - WP - 0.2) net=A0
  l11 = rect li xspan=(x9 + L - 0.025, x9 + L + 0.315) yspan=(nb + 0.525, pt - 0.865) net=S
  l12 = rect li xspan=(x3 + L - 0.01, x4 + L + 0.11) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=A1
  l13 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.19) yspan=(nb + WN + 0.44, pt - 0.375) net=A1
  l14 = rect li xspan=(x4 + L + 0.02, x5 - 0.185) yspan=(pt - WP - 0.04, pt - 0.375) net=A1
  l15 = rect li xspan=(x4 + L + 0.11, x4 + L + 0.19) yspan=(nb + WN + 0.27, pt - 0.375) net=A1
  l16 = rect li xspan=(x2 + L + 0.03, x3 - 0.04) yspan=(nb + WN - 0.29, pt - 0.36) net=Y
  l17 = rect li xspan=(x2 + L + 0.03, x3 + 0.025) yspan=(nb + WN + 0.57, pt - 0.36) net=Y
  l18 = rect li xspan=(x1 - 0.28, x2 + 0.005) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l19 = rect li xspan=(x1 - 0.28, x5 + L + 0.015) yspan=(pt - 0.19, pt - 0.02) net=n2
  l20 = rect li xspan=(x5 - 0.015, x8 + L + 0.275) yspan=(pt - WP - 0.005, pt - WP + 0.165) net=n2
  l21 = rect li xspan=(x5 - 0.015, x5 + L + 0.015) yspan=(pt - WP - 0.005, pt - 0.02) net=n2
  l22 = rect li xspan=(x7 + L - 0.03, x8 + L + 0.275) yspan=(pt - WP - 0.005, pt - 0.02) net=n2
  l23 = rect li xspan=(x5 - 0.035, x9 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.175) net=n1
  l24 = rect li xspan=(x9 - 0.34, x9 - 0.055) yspan=(nb + 0.02, pt - WP - 0.175) net=n1
  l25 = rect li xspan=(x9 - 0.34, x9 + 0.03) yspan=(nb + 0.02, nb + 0.25) net=n1
  l26 = rect li xspan=(x9 - 0.28, x9 - 0.055) yspan=(nb + 0.02, pt - 0.02) net=n1
  l27 = rect li xspan=(x6 - 0.035, x6 + L + 0.055) yspan=(pt - WP + 0.35, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L + 0.015, x9 + L + 0.31) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + WN - 0.63 + 0.08, nb + WN - 0.08) net=n5
  c2 = array licon in=nd2 cx=(x5 + L + 0.08) span=(nb + WN - 0.63, nb + WN - 0.42) net=n5
  c3 = array licon in=nd2 cx=(x7 - 0.11) span=(-0.085 + 0.08, nb + WN - 0.34 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd3 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c5 = array licon in=nd3 cx=(x9 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c6 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n3
  c7 = array licon in=nd1 cx=(x4 + L + 0.105) span=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  c8 = array licon in=nd1 cx=(x2 + L + 0.12) span=(nb + WN - 0.29 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x1 - 0.12) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x3 - 0.12) span=(nb + WN + 0.57 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c11 = array licon in=pd2 cx=(x9 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x8 + L + 0.11) span=(pt - WP - 0.005, pt - 0.02) net=n2
  c13 = array licon in=pd1 cx=(x6 + 0.055) span=(pt - WP + 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + L + 0.025) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x9 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a0m = contact mcon cx=(x1 - 0.17) cy=(pt - WP - 0.295)
  a0p = enclose a0m m1 by=0.06 net=A0
  port A0 in on=a0p
  a1m = contact mcon cx=(x4 + L + 0.105) cy=(pt - WP - 0.075)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  sm = contact mcon cx=(x9 + L + 0.065) cy=(nb + WN + 0.385)
  sp = enclose sm m1 by=0.06 net=S
  port S in on=sp
  ym = contact mcon cx=(x2 + L + 0.115) cy=(pt - WP - 0.125)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
