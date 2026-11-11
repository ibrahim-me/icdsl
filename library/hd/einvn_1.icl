# einvn_1: lifted from sky130_fd_sc_hd__einvn_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell einvn_1 width=6 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A s=Z b=VPB
  device M1 pmos w=WP2 l=L d=n2 g=TE_B s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=n2 s=n3 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=TE_B s=n1 b=VPB
  device M4 nmos w=WN2 l=L d=n2 g=TE_B s=VGND b=VNB
  device M5 nmos w=WN l=L d=n3 g=A s=Z b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.27
  x4 = x3 + L + 0.335
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x3 - 0.055, x3 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x1 - 0.13, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.375, pt - WP - 0.075)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.375, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.005, x3 + L + 0.015) yspan=(-0.085, nb + WN2 - 0.21) net=VGND
  l2 = rect li xspan=(x4 + L + 0.07, x4 + L + 0.315) yspan=(nb + WN2 + 0.11, pt - WP + 0.13) net=A
  l3 = rect li xspan=(x1 - 0.315, x1 + L - 0.035) yspan=(nb + WN + 0.07, pt - WP2 - 0.12) net=TE_B
  l4 = rect li xspan=(x1 - 0.315, x1 - 0.03) yspan=(nb + 0.02, nb + WN - 0.1) net=n2
  l5 = rect li xspan=(x1 - 0.315, x3 + L + 0.025) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=n2
  l6 = rect li xspan=(x1 - 0.315, x1 - 0.03) yspan=(pt - WP2 + 0.05, pt - 0.02) net=n2
  l7 = rect li xspan=(x1 - 0.315, x2) yspan=(pt - WP2 + 0.05, pt - WP2 + 0.22) net=n2
  l8 = rect li xspan=(x1 + L + 0.145, x3 + L + 0.025) yspan=(nb + WN2 - 0.04, pt - WP + 0.13) net=n2
  l9 = rect li xspan=(x1 + L + 0.145, x2) yspan=(nb + WN2 - 0.04, pt - WP2 + 0.22) net=n2
  l10 = rect li xspan=(x2 + L + 0.025, x4 + L + 0.315) yspan=(pt - WP2 - 0.06, pt - 0.02) net=Z
  l11 = rect li xspan=(x4 - 0.14, x4 + 0.045) yspan=(nb + 0.02, pt - 0.02) net=Z
  l12 = rect li xspan=(x4 - 0.14, x4 + L + 0.315) yspan=(nb + 0.02, nb + WN2 - 0.06) net=Z
  l13 = rect li xspan=(x1 + L - 0.005, x2) yspan=(pt - 0.25, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.135) span=(-0.085, nb + WN2 - 0.21) net=VGND
  c2 = array licon in=nd2 cx=(x2 + L + 0.065) span=(-0.085, nb + WN2 - 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN2 - 0.06) net=Z
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) net=n2
  c5 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP2 - 0.06, pt - 0.02) net=Z
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.05 + 0.08, pt - 0.02 - 0.08) net=n2
  c7 = array licon in=pd2 cx=(x1 + L + 0.165) span=(pt - 0.25, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + 0.01) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x4 - 0.15) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc8 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc9 = contact mcon cx=(x4 - 0.15) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l2
  port TE_B in on=l3
  port Z out on=l10
end
