# or2_0: lifted from sky130_fd_sc_hd__or2_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 WP2=0.42 L=0.15 H=2.72

stdcell or2_0 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M1 pmos w=WP2 l=L d=n2 g=A s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=B s=n1 b=VNB
  device M3 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M4 pmos w=WP2 l=L d=n1 g=B s=n2 b=VPB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.545
  x2 = x1 + 0.06
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.345
  nb = 0.465                          # bottom of the n row
  pt = H - 0.305                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.205, x4 + L + 0.345) yspan=(pt - WP, pt - 0.22)
  pd2 = rect diff xspan=(x3 + L + 0.08, x4 + L + 0.345) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.45)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.13, pt - WP - 0.45)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, pt - 0.09)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.13, pt - 0.09)
  p5 = rect poly xspan=(x3, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.45)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.13, pt + 0.13)
  p7 = rect poly xspan=(x4, x4 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.45)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.295, x1 - 0.055) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x3 + L + 0.075, x4 - 0.055) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l3 = rect li xspan=(x1 - 0.4, x1 - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l4 = rect li xspan=(x3 + 0.05, x4 - 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 - 0.275, x4 + L + 0.105) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l6 = rect li xspan=(x1 - 0.275, x1 + L - 0.03) yspan=(pt - WP + 0.01, pt - 0.22 - 0.065) net=n1
  l7 = rect li xspan=(x1 + L - 0.02, x2 + L + 0.095) yspan=(nb - 0.04, pt - WP + 0.18) net=n1
  l8 = rect li xspan=(x1 + L - 0.02, x3 - 0.015) yspan=(nb - 0.04, nb + WN - 0.06) net=n1
  l9 = rect li xspan=(x4 + L - 0.07, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n1
  l10 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.59) yspan=(nb + 0.06, nb + WN - 0.06) net=X
  l11 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.59) yspan=(pt - 0.22 - 0.06, pt + 0.05) net=X
  l12 = rect li xspan=(x4 + L + 0.275, x4 + L + 0.59) yspan=(nb + 0.06, pt + 0.05) net=X
  l13 = rect li xspan=(x3 + L + 0.04, x4 + 0.03) yspan=(pt - 0.22 - 0.07, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.08) span=(nb - 0.04 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x4 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) net=X
  c5 = array licon in=pd1 cx=(x1 - 0.08) span=(pt - WP + 0.01, pt - 0.22 - 0.065) net=n1
  c6 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - 0.22 - 0.07, H + 0.085) net=VPWR
  c7 = array licon in=pd2 cx=(x4 + L + 0.22) span=(pt - 0.22 - 0.06, pt + 0.05) net=X
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.545, x4 + L + 0.71) yspan=(nb + WN + 0.09, pt - WP - 0.43)
  # metal
  mc1 = contact mcon cx=(x1 - 0.315) cy=0
  mc2 = contact mcon cx=(x1 + L) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.045) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.02) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.48) cy=0
  mc6 = contact mcon cx=(x1 - 0.315) cy=H
  mc7 = contact mcon cx=(x1 + L) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.045) cy=H
  mc9 = contact mcon cx=(x4 + L + 0.02) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.48) cy=H
  well y=(nb + WN + 0.42)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l3
  port X out on=l12
end
