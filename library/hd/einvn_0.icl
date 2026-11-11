# einvn_0: lifted from sky130_fd_sc_hd__einvn_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 WP2=0.42 L=0.15 H=2.72

stdcell einvn_0 width=5 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=TE_B s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=TE_B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=Z b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=Z b=VNB
  device M4 nmos w=WN l=L d=n1 g=TE_B s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=n1 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.375
  x3 = x2 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x2 - 0.16, x2 + L) yspan=(nb + WN + 0.34, nb + WN + 0.67)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, nb + WN + 0.67)
  p3 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.34, pt - WP - 0.52)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x1, x2 + L) yspan=(pt - WP - 0.225, pt - WP - 0.075)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.225, H - 0.105)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x3, x3 + L + 0.29) yspan=(nb + WN + 0.34, pt - WP - 0.52)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.065) yspan=(-0.085, nb + WN - 0.17) net=VGND
  l2 = rect li xspan=(x1 - 0.33, x1 + L + 0.095) yspan=(nb + WN + 0.34, pt - WP - 0.12) net=TE_B
  l3 = rect li xspan=(x3 + L + 0.07, x3 + L + 0.325) yspan=(nb + WN + 0.11, pt - WP + 0.11) net=A
  l4 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.17) net=n1
  l5 = rect li xspan=(x1 - 0.33, x2 + 0.065) yspan=(nb + WN, nb + WN + 0.17) net=n1
  l6 = rect li xspan=(x1 - 0.33, x1 - 0.015) yspan=(pt - WP + 0.05, pt - 0.02) net=n1
  l7 = rect li xspan=(x1 - 0.33, x2 + 0.065) yspan=(pt - WP + 0.05, pt - WP2) net=n1
  l8 = rect li xspan=(x2 - 0.11, x2 + 0.065) yspan=(nb + WN, pt - WP2) net=n1
  l9 = rect li xspan=(x2 + L + 0.09, x3 + 0.045) yspan=(nb + 0.02, pt - 0.02) net=Z
  l10 = rect li xspan=(x2 + L + 0.09, x3 + L + 0.325) yspan=(nb + 0.02, nb + WN - 0.06) net=Z
  l11 = rect li xspan=(x2 + L + 0.09, x3 + L + 0.325) yspan=(pt - WP2 + 0.06, pt - 0.02) net=Z
  l12 = rect li xspan=(x1 + L + 0.015, x2 + 0.065) yspan=(pt - WP2 + 0.17, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.185) span=(-0.085, nb + WN - 0.17) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) net=Z
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.17 - 0.08) net=n1
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=n1
  c5 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP2 + 0.06, pt - 0.02) net=Z
  c6 = array licon in=pd2 cx=(x2 - 0.185) span=(pt - WP2 + 0.17, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.505)
  gc2 = contact licon cx=(x2 - 0.025) cy=(nb + WN + 0.505)
  gc3 = contact licon cx=(x3 + L + 0.155) cy=(nb + WN + 0.505)
  np1 = rect npc xspan=(x1 - 0.415, x3 + L + 0.41) yspan=(nb + WN + 0.32, pt - WP - 0.5)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.135) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.08) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.18) cy=0
  mc5 = contact mcon cx=(x1 - 0.185) cy=H
  mc6 = contact mcon cx=(x1 + L + 0.135) cy=H
  mc7 = contact mcon cx=(x2 + L + 0.08) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.18) cy=H
  well y=(pt - WP - 0.54)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port TE_B in on=l2
  port Z out on=l11
end
