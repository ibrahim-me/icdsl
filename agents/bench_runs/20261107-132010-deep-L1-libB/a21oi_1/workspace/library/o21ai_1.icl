# o21ai_1: lifted from sky130_fd_sc_hd__o21ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 WP2=0.7 L=0.15 H=2.72

stdcell o21ai_1 width=5 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.12
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.135) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.21, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L + 0.295) yspan=(nb + WN + 0.41, pt - WP + 0.14)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.035, x2 + L) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x1 - 0.31, x1 - 0.02) yspan=(nb + 0.03, nb + WN - 0.1) net=n2
  l3 = rect li xspan=(x1 - 0.31, x4 + 0.01) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=n2
  l4 = rect li xspan=(x3 + L + 0.055, x4 + 0.01) yspan=(nb + 0.075, nb + WN - 0.1) net=n2
  l5 = rect li xspan=(x1 - 0.25, x1 + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x4 + L + 0.065, x4 + L + 0.31) yspan=(pt - WP - 0.19, pt - WP2 - 0.13) net=B1
  l7 = rect li xspan=(x1 + L + 0.05, x2 + 0.03) yspan=(nb + WN + 0.11, pt - 0.11) net=A2
  l8 = rect li xspan=(x1 + L + 0.05, x3 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l9 = rect li xspan=(x2 + L + 0.06, x4) yspan=(pt - WP + 0.02, pt - 0.02) net=Y
  l10 = rect li xspan=(x3 + L + 0.125, x4 + 0.02) yspan=(nb + WN + 0.07, pt - WP2) net=Y
  l11 = rect li xspan=(x3 + L + 0.125, x4 + L + 0.225) yspan=(nb + WN + 0.07, nb + WN + 0.24) net=Y
  l12 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(nb + 0.155, nb + WN + 0.24) net=Y
  l13 = rect li xspan=(x1 - 0.31, x1 + 0.015) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.31) yspan=(pt - WP2 + 0.05, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 - 0.02) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.1 - 0.08) net=n2
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.075 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n2
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.155 + 0.08, nb + WN + 0.24 - 0.08) net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c6 = array licon in=pd2 cx=(x3 + L + 0.11) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP2 + 0.05 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.075) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2 + 0.06) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.16) cy=(pt - WP - 0.025)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x4 + 0.01, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP2 - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.13) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc5 = contact mcon cx=(x1 - 0.17) cy=H
  mc6 = contact mcon cx=(x2 - 0.07) cy=H
  mc7 = contact mcon cx=(x3 + L + 0.13) cy=H
  mc8 = contact mcon cx=(x4 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l7
  port B1 in on=l6
  port Y out on=l9
end
