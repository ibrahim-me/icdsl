# nand3_2: lifted from sky130_fd_sc_hd__nand3_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nand3_2 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=C s=VGND b=VNB
  device M1 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M2 nmos w=WN l=L d=n1 g=B s=n2 b=VNB
  device M3 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M4 nmos w=WN l=L d=n2 g=B s=n1 b=VNB
  device M5 nmos w=WN l=L d=VGND g=C s=n1 b=VNB
  device M6 nmos w=WN l=L d=Y g=A s=n2 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M8 nmos w=WN l=L d=n2 g=A s=Y b=VNB
  device M9 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M10 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M11 pmos w=WP l=L d=Y g=B s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.315) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.315) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.065, x4 + L + 0.185) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x6 + L + 0.185) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.185) yspan=(nb + WN + 0.125, pt - WP - 0.17)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x4 + L + 0.305) yspan=(nb + 0.06, nb + 0.23) net=n2
  l2 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.06, nb + WN - 0.1) net=n2
  l3 = rect li xspan=(x5 - 0.305, x5 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.435) yspan=(-0.085, nb + WN) net=VGND
  l5 = rect li xspan=(x3 + L - 0.03, x6 + 0.03) yspan=(nb + WN - 0.25, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x2 + L + 0.11, x4 + L + 0.36) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l7 = rect li xspan=(x5 - 0.13, x6 + L + 0.435) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l8 = rect li xspan=(x1 - 0.31, x1 - 0.07) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l9 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + WN - 0.25, pt - 0.02) net=Y
  l10 = rect li xspan=(x1 + L - 0.03, x6 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l11 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l12 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l13 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l15 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l16 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.435) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.06, nb + 0.23) margin=0.04 net=n2
  c2 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.06, nb + 0.23) net=n2
  c3 = array licon in=nd2 cx=(x5 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c4 = array licon in=nd2 cx=(x6 + L + 0.17) span=(-0.085 + 0.08, nb + WN - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06 + 0.08, nb + WN - 0.1 - 0.08) net=n2
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.25, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=n1
  c8 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.25, pt - 0.02) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c12 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c13 = array licon in=pd2 cx=(x6 + L + 0.17) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.045) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.52) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.27) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.03) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.29) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.13) cy=H
  mc11 = contact mcon cx=(x3 - 0.09) cy=H
  mc12 = contact mcon cx=(x4 - 0.05) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.27) cy=H
  mc14 = contact mcon cx=(x5 - 0.07) cy=H
  mc15 = contact mcon cx=(x6 - 0.03) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.29) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port B in on=l6
  port C in on=l7
  port Y out on=l9
end
