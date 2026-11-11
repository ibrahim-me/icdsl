# nand2_1: lifted from sky130_fd_sc_hd__nand2_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2_1 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + 0.28
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt + 0.13)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt + 0.13)
  p4 = rect poly xspan=(x2, x2 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B
  l3 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l4 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  l5 = rect li xspan=(x1 + L + 0.04, x2 + L + 0.315) yspan=(nb + 0.02, nb + WN) net=Y
  l6 = rect li xspan=(x1 + L + 0.04, x2 - 0.07) yspan=(nb + 0.02, pt - 0.02) net=Y
  l7 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l8 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c3 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c4 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=Y
  c5 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.125) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x2 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  am = contact mcon cx=(x2 + L + 0.165) cy=(pt - WP - 0.295)
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon cx=(x1 - 0.24) cy=(pt - WP - 0.26)
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  ym = contact mcon cx=(x1 + L + 0.125) cy=(pt - WP - 0.125)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
