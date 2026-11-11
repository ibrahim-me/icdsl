# or2_1: lifted from sky130_fd_sc_hd__or2_1 by icdsl.lift (bench variant)
# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2_1 width=6 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.545
  x2 = x1 + 0.06
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.345
  nb = ptap.top + 0.27                  # bottom of the n row
  pt = ntap.bottom - 0.27               # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x3 + L + 0.08, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.205, x4 + L + 0.345) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x3 + L + 0.08, x4 + L + 0.345) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt - 0.58 + 0.13)
  p5 = rect poly xspan=(x3, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.13, pt + 0.13)
  p7 = rect poly xspan=(x4, x4 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.295, x1 - 0.055) yspan=(-0.085, nb + WN2 - 0.06) net=VGND
  l2 = rect li xspan=(x3 + L + 0.075, x4 - 0.055) yspan=(-0.085, nb + WN2 - 0.06) net=VGND
  l3 = rect li xspan=(x1 - 0.4, x1 - 0.045) yspan=(nb + WN2 + 0.11, pt - WP - 0.16) net=B
  l4 = rect li xspan=(x3 + 0.05, x3 + L + 0.17) yspan=(nb + WN2 + 0.11, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 - 0.275, x4 + L + 0.105) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l6 = rect li xspan=(x1 - 0.275, x1 + L - 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.355) net=n2
  l7 = rect li xspan=(x1 + L - 0.02, x2 + L + 0.095) yspan=(nb + 0.03, pt - WP + 0.18) net=n2
  l8 = rect li xspan=(x1 + L - 0.02, x3 - 0.015) yspan=(nb + 0.03, nb + WN2 - 0.06) net=n2
  l9 = rect li xspan=(x4 + L - 0.07, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n2
  l10 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.59) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l11 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.59) yspan=(pt - WP + 0.36, pt - 0.02) net=X
  l12 = rect li xspan=(x4 + L + 0.275, x4 + L + 0.59) yspan=(nb + 0.02, pt - 0.02) net=X
  l13 = rect li xspan=(x3 + L + 0.04, x4 + 0.03) yspan=(pt - WP + 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) net=X
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.06 - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.08) span=(nb + 0.03 + 0.08, nb + WN2 - 0.06 - 0.08) margin=0.04 net=n2
  c4 = array licon in=nd2 cx=(x4 - 0.145) span=(-0.085 + 0.08, nb + WN2 - 0.06 - 0.08) net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.08) span=(pt - WP + 0.01, pt - WP + 0.355) net=n2
  c6 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP + 0.35, H + 0.085) net=VPWR
  c7 = array licon in=pd2 cx=(x4 + L + 0.22) span=(pt - WP + 0.36, pt - 0.02) net=X
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.545, x4 + L + 0.71) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  am = contact mcon cx=(x3 + L + 0.045) cy=(pt - WP - 0.295)
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon cx=(x1 - 0.315) cy=(pt - WP - 0.295)
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  xm = contact mcon cx=(x4 + L + 0.36) cy=(pt - WP - 0.125)
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
