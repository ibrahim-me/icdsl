# einvp_1: lifted from sky130_fd_sc_hd__einvp_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell einvp_1 width=6 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A s=Z b=VPB
  device M1 nmos w=WN l=L d=VGND g=TE s=n2 b=VNB
  device M2 pmos w=WP2 l=L d=n3 g=TE s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n2 g=A s=Z b=VNB
  device M4 pmos w=WP l=L d=VPWR g=n3 s=n1 b=VPB
  device M5 nmos w=WN2 l=L d=n3 g=TE s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.375
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.275) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x4 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.275) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x4 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.075, pt - WP - 0.375)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.375)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.305) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x3 + L + 0.075) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.11, pt - WP + 0.24) net=TE
  l3 = rect li xspan=(x4 + L + 0.085, x4 + L + 0.325) yspan=(nb + WN + 0.09, pt - WP2 - 0.11) net=A
  l4 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l5 = rect li xspan=(x1 - 0.315, x3 + L + 0.075) yspan=(nb + WN2, nb + WN - 0.06) net=n3
  l6 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 - 0.17, pt - 0.02) net=n3
  l7 = rect li xspan=(x1 - 0.315, x3 + L + 0.075) yspan=(pt - WP2 - 0.17, pt - WP2) net=n3
  l8 = rect li xspan=(x2 - 0.16, x3 + L + 0.075) yspan=(nb + WN2, pt - WP2) net=n3
  l9 = rect li xspan=(x4 - 0.13, x4 + 0.05) yspan=(nb + 0.02, pt - 0.02) net=Z
  l10 = rect li xspan=(x4 - 0.13, x4 + L + 0.325) yspan=(nb + 0.02, nb + WN - 0.08) net=Z
  l11 = rect li xspan=(x4 - 0.13, x4 + L + 0.325) yspan=(pt - WP2 + 0.06, pt - 0.02) net=Z
  l12 = rect li xspan=(x1 + L - 0.03, x3 + L + 0.075) yspan=(pt - WP2 + 0.17, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=Z
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.17 + 0.08, pt - 0.02 - 0.08) net=n3
  c5 = array licon in=pd2 cx=(x4 + L + 0.15) span=(pt - WP2 + 0.06, pt - 0.02) net=Z
  c6 = array licon in=pd1 cx=(x1 + L + 0.15) span=(pt - WP2 + 0.17, H + 0.085) margin=0.04 net=VPWR
  c7 = array licon in=pd2 cx=(x2 + L + 0.015) span=(pt - WP2 + 0.17, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.17) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x3 - 0.085) cy=0
  mc4 = contact mcon cx=(x4 - 0.14) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.18) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc8 = contact mcon cx=(x3 - 0.085) cy=H
  mc9 = contact mcon cx=(x4 - 0.14) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port TE in on=l2
  port Z out on=l11
end
