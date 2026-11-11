# nor3_1: lifted from sky130_fd_sc_hd__nor3_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3_1 width=5 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.275, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt + 0.13)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt + 0.13)
  p6 = rect poly xspan=(x3, x3 + L + 0.325) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + WN - 0.4) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(-0.085, nb + WN - 0.4) net=VGND
  l3 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  l4 = rect li xspan=(x3 + L + 0.105, x3 + L + 0.375) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=A
  l5 = rect li xspan=(x1 + L + 0.055, x2 + 0.015) yspan=(nb + WN + 0.11, pt - 0.48) net=B
  l6 = rect li xspan=(x1 + L + 0.055, x2 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + WN - 0.5, nb + WN - 0.06) net=Y
  l8 = rect li xspan=(x1 - 0.31, x3 + L - 0.07) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=Y
  l9 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.035) net=Y
  l10 = rect li xspan=(x1 - 0.31, x3 - 0.07) yspan=(pt - 0.205, pt - 0.035) net=Y
  l11 = rect li xspan=(x2 + L + 0.04, x3 - 0.07) yspan=(pt - WP + 0.01, pt - 0.035) net=Y
  l12 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + WN - 0.5, nb + WN - 0.06) net=Y
  l13 = rect li xspan=(x3 - 0.095, x3 + L - 0.07) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l14 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.37) yspan=(pt - WP + 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN - 0.4) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + WN - 0.4) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + WN - 0.5 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + WN - 0.5 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.035) net=Y
  c6 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.35 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L + 0.19) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x3 + L + 0.46) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  am = contact mcon cx=(x3 + L + 0.19) cy=(pt - WP - 0.15)
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon cx=(x1 + L + 0.14) cy=(pt - WP - 0.15)
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon cx=(x1 - 0.165) cy=(pt - WP - 0.295)
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  ym = contact mcon cx=(x1 - 0.225) cy=(pt - WP + 0.18)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
