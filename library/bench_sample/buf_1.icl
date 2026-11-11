# buf_1: lifted from sky130_fd_sc_hd__buf_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf_1 width=4 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.3
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.265, x1 + L - 0.03) yspan=(nb + WN + 0.24, nb + WN + 0.57)
  p2 = rect poly xspan=(x1 - 0.035, x1 + L - 0.03) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  p3 = rect poly xspan=(x1, x1 + L - 0.03) yspan=(nb - 0.13, pt + 0.13)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, nb + WN + 0.195)
  p5 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.745, pt + 0.13)
  p6 = rect poly xspan=(x2 - 0.115, x2 + L + 0.015) yspan=(nb + WN + 0.305, nb + WN + 0.635)
  p7 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.13, pt + 0.13)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.02, x2 + 0.02) yspan=(-0.085, nb + WN - 0.29) net=VGND
  l2 = rect li xspan=(x1 - 0.295, x1 + 0.05) yspan=(nb + WN + 0.23, pt - WP - 0.34) net=A
  l3 = rect li xspan=(x1 - 0.235, x1 - 0.055) yspan=(pt - WP - 0.16, pt - 0.02) net=n1
  l4 = rect li xspan=(x1 - 0.235, x2 + 0.005) yspan=(pt - WP - 0.16, pt - WP + 0.01) net=n1
  l5 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.05) net=n1
  l6 = rect li xspan=(x1 - 0.225, x2 + 0.005) yspan=(nb + WN - 0.12, nb + WN + 0.05) net=n1
  l7 = rect li xspan=(x1 + L + 0.13, x2 + 0.005) yspan=(nb + WN - 0.12, pt - WP + 0.01) net=n1
  l8 = rect li xspan=(x1 + L + 0.13, x2 + L - 0.04) yspan=(nb + WN + 0.305, nb + WN + 0.635) net=n1
  l9 = rect li xspan=(x2 + L + 0.045, x2 + L + 0.315) yspan=(nb + WN + 0.805, pt - 0.02) net=X
  l10 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.315) yspan=(nb + 0.02, nb + WN + 0.005) net=X
  l11 = rect li xspan=(x2 + L + 0.135, x2 + L + 0.315) yspan=(nb + 0.02, pt - 0.02) net=X
  l12 = rect li xspan=(x1 + L - 0.02, x2 + 0.02) yspan=(pt - WP + 0.18, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.15) span=(-0.085, nb + WN - 0.29) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.05 - 0.08) net=n1
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.005 - 0.08) net=X
  c4 = array licon in=pd1 cx=(x2 + L + 0.14) span=(nb + WN + 0.805 + 0.08, pt - 0.02 - 0.08) net=X
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.16 + 0.08, pt - 0.02 - 0.08) net=n1
  c6 = array licon in=pd1 cx=(x1 + L + 0.15) span=(pt - WP + 0.18, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.405)
  gc2 = contact licon cx=(x2 + 0.025) cy=(nb + WN + 0.47)
  np1 = rect npc xspan=(x1 - 0.4, x2 + L + 0.4) yspan=(nb + WN + 0.22, nb + WN + 0.655)
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  am = contact mcon cx=(x1 - 0.21) cy=(pt - WP - 0.455)
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  xm = contact mcon cx=(x2 + L + 0.22) cy=(pt - WP - 0.335)
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
