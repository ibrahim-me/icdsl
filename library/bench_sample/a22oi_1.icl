# a22oi_1: lifted from sky130_fd_sc_hd__a22oi_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi_1 width=7 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.24
  x3 = x2 + 0.04
  x4 = x3 + L + 0.8
  x5 = x4 + L + 0.22
  x6 = x5 + 0.06
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.225) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.305) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  p6 = rect poly xspan=(x4 - 0.24, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.13, pt + 0.13)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x6 + L - 0.02, x6 + L + 0.315) yspan=(-0.085, nb + WN - 0.4) net=VGND
  l3 = rect li xspan=(x1 - 0.275, x1 + L + 0.035) yspan=(nb + 0.53, nb + WN + 0.39) net=B2
  l4 = rect li xspan=(x2 - 0.015, x3 + L + 0.28) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=B1
  l5 = rect li xspan=(x3 + L + 0.03, x3 + L + 0.28) yspan=(nb + 0.44, nb + WN + 0.39) net=B1
  l6 = rect li xspan=(x4 - 0.27, x4 - 0.06) yspan=(nb + 0.44, nb + WN + 0.39) net=A1
  l7 = rect li xspan=(x4 - 0.27, x4 + L - 0.065) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=A1
  l8 = rect li xspan=(x4 + L + 0.11, x6 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l9 = rect li xspan=(x1 + L + 0.055, x3 + L + 0.25) yspan=(pt - WP + 0.31, pt - WP + 0.6) net=n2
  l10 = rect li xspan=(x1 + L + 0.055, x4 - 0.285) yspan=(pt - WP + 0.31, pt - WP + 0.55) net=n2
  l11 = rect li xspan=(x1 + L + 0.055, x3 + 0.01) yspan=(pt - WP + 0.31, pt - WP + 0.64) net=n2
  l12 = rect li xspan=(x1 + L + 0.055, x5 + 0.01) yspan=(pt - WP + 0.35, pt - WP + 0.55) net=n2
  l13 = rect li xspan=(x4 + L + 0.055, x5 + 0.01) yspan=(pt - WP + 0.35, pt - WP + 0.68) net=n2
  l14 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.98) net=Y
  l15 = rect li xspan=(x1 - 0.305, x4 + L - 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=Y
  l16 = rect li xspan=(x1 - 0.305, x3 + L + 0.305) yspan=(pt - WP + 0.81, pt - WP + 0.98) net=Y
  l17 = rect li xspan=(x3 + 0.005, x5 + 0.01) yspan=(nb + 0.02, nb + 0.27) net=Y
  l18 = rect li xspan=(x2 + L + 0.01, x3 + L + 0.305) yspan=(pt - WP + 0.77, pt - WP + 0.98) net=Y
  l19 = rect li xspan=(x4 - 0.145, x6 + L + 0.355) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l20 = rect li xspan=(x4 + L + 0.045, x5 + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l21 = rect li xspan=(x4 + L + 0.045, x6 + L + 0.355) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=Y
  l22 = rect li xspan=(x6 + L + 0.185, x6 + L + 0.355) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l23 = rect li xspan=(x4 - 0.325, x4 + 0.055) yspan=(pt - WP + 0.77, H + 0.085) net=VPWR
  l24 = rect li xspan=(x6 + L + 0.04, x6 + L + 0.305) yspan=(pt - WP + 0.37, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x6 + L + 0.15) span=(-0.085, nb + WN - 0.4) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=Y
  c3 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.02, nb + 0.27) net=Y
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.36) net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - WP + 0.98) net=Y
  c6 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - WP + 0.31 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd2 cx=(x5 - 0.08) span=(pt - WP + 0.35 + 0.08, pt - WP + 0.68 - 0.08) margin=0.04 net=n2
  c8 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.37 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.77, pt - WP + 0.98) net=Y
  c10 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP + 0.77, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.085) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a1m = contact mcon cx=(x4 - 0.125) cy=(nb + WN + 0.305)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon cx=(x5 - 0.025) cy=(pt - WP - 0.295)
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon cx=(x3 + L + 0.195) cy=(nb + WN + 0.305)
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon cx=(x1 - 0.165) cy=(nb + WN + 0.305)
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  ym = contact mcon cx=(x6 + L + 0.27) cy=(pt - WP - 0.15)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
