# o31ai_1: lifted from sky130_fd_sc_hd__o31ai_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o31ai_1 width=8 height=H
  device M0 pmos w=WP l=L d=Y g=B1 s=VPWR
  device M1 nmos w=WN l=L d=VGND g=A3 s=n1
  device M2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M3 nmos w=WN l=L d=n1 g=B1 s=Y
  device M4 pmos w=WP l=L d=n2 g=A3 s=Y
  device M5 nmos w=WN l=L d=VGND g=A1 s=n1
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n3
  device M7 pmos w=WP l=L d=n3 g=A2 s=n2

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.62
  x5 = x4 + L + 0.035
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.17) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt + 0.13)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt + 0.13)
  p6 = rect poly xspan=(x3, x3 + L + 0.245) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x5 + L + 0.34) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, pt + 0.13)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, pt - WP - 0.58) net=n1
  l4 = rect li xspan=(x1 + L - 0.03, x4 - 0.3) yspan=(nb + 0.5, pt - WP - 0.58) net=n1
  l5 = rect li xspan=(x3 + L - 0.015, x4 - 0.3) yspan=(nb + 0.02, pt - WP - 0.58) net=n1
  l6 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.36) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l8 = rect li xspan=(x3 - 0.015, x4 - 0.3) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A3
  l9 = rect li xspan=(x3 + L + 0.08, x4 - 0.3) yspan=(pt - WP - 0.41, pt - 0.08) net=A3
  l10 = rect li xspan=(x1 + L + 0.07, x2 + L + 0.095) yspan=(pt - WP - 0.41, pt - 0.02) net=A2
  l11 = rect li xspan=(x4 - 0.055, x5 - 0.015) yspan=(nb + 0.025, pt - 0.02) net=Y
  l12 = rect li xspan=(x4 - 0.055, x5 + L + 0.36) yspan=(nb + 0.025, nb + WN - 0.06) net=Y
  l13 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.36) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, pt - WP - 0.58) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.155) span=(nb + 0.02, pt - WP - 0.58) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x5 + L + 0.025) span=(nb + 0.025, nb + WN - 0.06) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x4 + 0.035) span=(nb + 0.025 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  c8 = array licon in=pd1 cx=(x5 + L + 0.18) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.145) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L/2) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.08) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 + L + 0.195) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.445) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a1m = contact mcon cx=(x1 - 0.165) cy=(pt - WP - 0.295)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon cx=(x2 - 0.125) cy=(pt - WP - 0.155)
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  a3m = contact mcon cx=(x3 + L + 0.165) cy=(pt - WP - 0.155)
  a3p = enclose a3m m1 by=0.06 net=A3
  port A3 in on=a3p
  b1m = contact mcon cx=(x5 + L + 0.205) cy=(pt - WP - 0.295)
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  ym = contact mcon cx=(x4 + 0.035) cy=(pt - WP - 0.12)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
