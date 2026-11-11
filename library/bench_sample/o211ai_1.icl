# o211ai_1: lifted from sky130_fd_sc_hd__o211ai_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o211ai_1 width=8 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.22
  x3 = x2 + L + 0.04
  x4 = x3 + L + 0.22
  x5 = x4 + L + 0.04
  x6 = x5 + L + 0.22
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.61) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.64) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.23, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.13)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb - 0.13, pt - WP - 0.13)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.13, pt + 0.13)
  p10 = rect poly xspan=(x6, x6 + L + 0.285) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.05, x2 + L + 0.02) yspan=(-0.085, nb + WN - 0.44) net=VGND
  l2 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l3 = rect li xspan=(x1 - 0.31, x4 + L + 0.01) yspan=(nb + WN - 0.27, nb + WN - 0.06) net=n2
  l4 = rect li xspan=(x3 + L + 0.04, x4 + L + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l5 = rect li xspan=(x1 - 0.32, x1 - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x4, x6 - 0.05) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=B1
  l7 = rect li xspan=(x5 - 0.015, x6 - 0.05) yspan=(nb + WN + 0.11, pt - 0.87) net=B1
  l8 = rect li xspan=(x6 + L - 0.02, x6 + L + 0.315) yspan=(nb + WN + 0.19, pt - 0.87) net=C1
  l9 = rect li xspan=(x1 + L + 0.06, x2 + 0.015) yspan=(nb + WN + 0.11, pt - 0.235) net=A2
  l10 = rect li xspan=(x1 + L + 0.06, x3 + 0.04) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=A2
  l11 = rect li xspan=(x3 + 0.005, x4 - 0.03) yspan=(pt - WP + 0.11, pt - 0.04) net=Y
  l12 = rect li xspan=(x3 + 0.005, x6 + L + 0.69) yspan=(pt - 0.67, pt - 0.44) net=Y
  l13 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.69) yspan=(nb + 0.02, nb + WN - 0.04) net=Y
  l14 = rect li xspan=(x6 + L - 0.015, x6 + L + 0.69) yspan=(pt - 0.67, pt - 0.02) net=Y
  l15 = rect li xspan=(x6 + L + 0.485, x6 + L + 0.69) yspan=(nb + 0.02, pt - 0.02) net=Y
  l16 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - WP + 0.09, H + 0.085) net=VPWR
  l17 = rect li xspan=(x4 + L - 0.005, x6 - 0.07) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=x2 span=(-0.085, nb + WN - 0.44) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN - 0.06) net=n2
  c3 = array licon in=nd1 cx=(x4 - 0.015) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n2
  c4 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.02, nb + WN - 0.04) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x6 + L + 0.485) span=(nb + 0.02, nb + WN - 0.04) net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.09, H + 0.085) net=VPWR
  c7 = array licon in=pd1 cx=(x3 + L + 0.025) span=(pt - WP + 0.11, pt - 0.04) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x6 + L + 0.155) span=(pt - 0.67, pt - 0.02) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x6 + L + 0.495) span=(pt - 0.67, pt - 0.02) margin=0.04 net=Y
  c10 = array licon in=pd1 cx=(x5 + L - 0.02) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.095) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.15) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.405, x6 + L + 0.775) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a1m = contact mcon cx=(x1 - 0.175) cy=(pt - WP - 0.295)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon cx=(x2 - 0.075) cy=(pt - WP - 0.15)
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon cx=(x5 + L/2) cy=(nb + WN + 0.365)
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  c1m = contact mcon cx=(x6 + L + 0.07) cy=(nb + WN + 0.445)
  c1p = enclose c1m m1 by=0.06 net=C1
  port C1 in on=c1p
  ym = contact mcon cx=(x6 + L + 0.57) cy=(pt - WP - 0.125)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
