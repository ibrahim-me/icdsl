# a21o_1: lifted from sky130_fd_sc_hd__a21o_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21o_1 width=7 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=X g=n2 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B1 s=n3
  device M3 nmos w=WN l=L d=VGND g=B1 s=n2
  device M4 pmos w=WP l=L d=n3 g=A1 s=VPWR
  device M5 pmos w=WP l=L d=VPWR g=A2 s=n3
  device M6 nmos w=WN l=L d=X g=n2 s=VGND
  device M7 nmos w=WN l=L d=n2 g=A1 s=n1

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.41
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.285
  x4 = x3 + L + 0.29
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x4 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p2 = rect poly xspan=(x1, x1 + L + 0.28) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.28, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt + 0.13)
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt + 0.13)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.13, pt + 0.13)
  p8 = rect poly xspan=(x4, x4 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.065, x2 - 0.065) yspan=(-0.085, nb + WN - 0.43) net=VGND
  l2 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.31) yspan=(-0.085, nb + WN - 0.07) net=VGND
  l3 = rect li xspan=(x2 - 0.335, x2 + L - 0.015) yspan=(nb + WN + 0.13, pt - WP - 0.16) net=B1
  l4 = rect li xspan=(x3 - 0.115, x4 - 0.02) yspan=(nb + WN + 0.13, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x3 + L + 0.04, x4 - 0.02) yspan=(nb + 0.14, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.32) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l7 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.03, pt - 0.03) net=X
  l8 = rect li xspan=(x1 + L - 0.01, x1 + L + 0.285) yspan=(nb + WN - 0.25, pt - WP + 0.24) net=n2
  l9 = rect li xspan=(x1 + L - 0.01, x3 + 0.005) yspan=(nb + WN - 0.25, nb + WN - 0.05) net=n2
  l10 = rect li xspan=(x1 + L - 0.01, x2 - 0.035) yspan=(pt - WP + 0.02, pt - WP + 0.24) net=n2
  l11 = rect li xspan=(x2 - 0.305, x2 - 0.035) yspan=(pt - WP + 0.02, pt - 0.03) net=n2
  l12 = rect li xspan=(x2 + L - 0.03, x3 + 0.005) yspan=(nb + 0.03, nb + WN - 0.05) net=n2
  l13 = rect li xspan=(x2 + L, x4 + L + 0.31) yspan=(pt - WP + 0.02, pt - WP + 0.26) net=n3
  l14 = rect li xspan=(x2 + L, x3 - 0.05) yspan=(pt - WP + 0.02, pt - 0.03) net=n3
  l15 = rect li xspan=(x4 + L + 0.05, x4 + L + 0.31) yspan=(pt - WP + 0.02, pt - 0.03) net=n3
  l16 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.315) yspan=(pt - WP + 0.42, H + 0.085) net=VPWR
  l17 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(pt - WP + 0.44, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.23) span=(-0.085, nb + WN - 0.43) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 - 0.23) span=(-0.085, nb + WN - 0.43) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.07 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.05 - 0.08) margin=0.04 net=n2
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.08, pt - 0.03 - 0.08) net=X
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.08, pt - 0.03 - 0.08) net=X
  c7 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n2
  c8 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=n3
  c9 = array licon in=pd2 cx=(x4 + L + 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n3
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.42, H + 0.085) net=VPWR
  c11 = array licon in=pd2 cx=(x3 + L + 0.145) span=(pt - WP + 0.44, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.145) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.41, x4 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  a1m = contact mcon cx=(x3 + L + 0.125) cy=(pt - WP - 0.26)
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon cx=(x4 + L + 0.185) cy=(pt - WP - 0.295)
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon cx=(x2 - 0.2) cy=(pt - WP - 0.295)
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  xm = contact mcon cx=(x1 - 0.23) cy=(pt - WP - 0.115)
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
