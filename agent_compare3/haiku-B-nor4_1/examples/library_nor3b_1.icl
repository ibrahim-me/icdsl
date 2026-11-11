# nor3b_1: lifted from sky130_fd_sc_hd__nor3b_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nor3b_1 width=7 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=VPWR g=C_N s=n1 b=VPB
  device M2 pmos w=WP l=L d=n2 g=B s=n3 b=VPB
  device M3 nmos w=WN2 l=L d=VGND g=C_N s=n1 b=VNB
  device M4 pmos w=WP l=L d=Y g=n1 s=n2 b=VPB
  device M5 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M6 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M7 nmos w=WN l=L d=Y g=n1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.66
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.345
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.345, x4 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.345, x4 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.325, x4 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.325, x4 + L + 0.265) yspan=(pt - 0.415 - WP2, pt - 0.415)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4 - 0.01, x4 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x4, x4 + L) yspan=(nb + 0.1, pt - 0.415 + 0.13)
  p3 = rect poly xspan=(x1 - 0.205, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x3, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.23 + 0.02) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 - 0.04) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l3 = rect li xspan=(x2 - 0.015, x2 + L + 0.085) yspan=(nb + WN + 0.11, pt - 0.415 - WP2 - 0.035) net=B
  l4 = rect li xspan=(x3 - 0.025, x4 - 0.17) yspan=(nb + WN + 0.11, pt - 0.415 - WP2 - 0.035) net=A
  l5 = rect li xspan=(x4 + 0.005, x4 + L + 0.21) yspan=(nb + WN + 0.11, pt - 0.415 - WP2 - 0.035) net=C_N
  l6 = rect li xspan=(x1 - 0.235, x1 + L + 0.085) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l7 = rect li xspan=(x1 + 0.06, x1 + L + 0.085) yspan=(nb + WN + 0.19, pt - 0.415 - 0.115) net=n1
  l8 = rect li xspan=(x1 + 0.06, x4 + L + 0.55) yspan=(pt - 0.415 - WP2 + 0.135, pt - 0.415 - 0.115) net=n1
  l9 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(nb + 0.23 - 0.06, nb + WN - 0.06) net=n1
  l10 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.55) yspan=(nb + 0.23 + 0.19, nb + WN - 0.06) net=n1
  l11 = rect li xspan=(x4 + L + 0.38, x4 + L + 0.55) yspan=(nb + 0.23 + 0.19, pt - 0.415 - 0.115) net=n1
  l12 = rect li xspan=(x1 - 0.575, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l13 = rect li xspan=(x1 - 0.575, x1 - 0.405) yspan=(nb + 0.02, pt - 0.03) net=Y
  l14 = rect li xspan=(x1 - 0.575, x3 - 0.055) yspan=(nb + 0.23 + 0.19, nb + WN - 0.06) net=Y
  l15 = rect li xspan=(x1 - 0.575, x1 - 0.115) yspan=(pt - WP - 0.04, pt - 0.03) net=Y
  l16 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.075, nb + WN - 0.06) net=Y
  l17 = rect li xspan=(x3 + L - 0.03, x4 - 0.04) yspan=(pt - 0.415 + 0.055, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.22) span=(nb + 0.02, nb + WN - 0.06) net=Y
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23 + 0.02) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.075 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c5 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.23 - 0.06 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c6 = array licon in=pd1 cx=(x1 - 0.2) span=(pt - WP - 0.04 + 0.08, pt - 0.03 - 0.08) net=Y
  c7 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.415 - WP2 + 0.135, pt - 0.415 - 0.115) net=n1
  c8 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.415 + 0.055, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.07) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.66, x4 + L + 0.635) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.43) cy=0
  mc2 = contact mcon cx=(x1 + 0.035) cy=0
  mc3 = contact mcon cx=(x2 + L/2) cy=0
  mc4 = contact mcon cx=(x3 + L - 0.035) cy=0
  mc5 = contact mcon cx=(x4 + L - 0.06) cy=0
  mc6 = contact mcon cx=(x4 + L + 0.405) cy=0
  mc7 = contact mcon cx=(x1 - 0.43) cy=H
  mc8 = contact mcon cx=(x1 + 0.035) cy=H
  mc9 = contact mcon cx=(x2 + L/2) cy=H
  mc10 = contact mcon cx=(x3 + L - 0.035) cy=H
  mc11 = contact mcon cx=(x4 + L - 0.06) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.405) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l3
  port C_N in on=l5
  port Y out on=l13
end
