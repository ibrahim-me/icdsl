# ebufn_1: lifted from sky130_fd_sc_hd__ebufn_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell ebufn_1 width=10 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=TE_B s=n1 b=VNB
  device M1 nmos w=WN l=L d=VGND g=n1 s=n2 b=VNB
  device M2 nmos w=WN l=L d=n2 g=n3 s=Z b=VNB
  device M3 pmos w=WP l=L d=VPWR g=TE_B s=n4 b=VPB
  device M4 pmos w=WP l=L d=n4 g=n3 s=Z b=VPB
  device M5 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB
  device M6 pmos w=WP2 l=L d=VPWR g=TE_B s=n1 b=VPB
  device M7 nmos w=WN2 l=L d=n3 g=A s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + 0.085
  x4 = x3 + L + 0.725
  x5 = x4 + L + 0.6
  x6 = x5 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + 0.01) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x4 - 0.105) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x4 + L + 0.245, x6 + L + 0.445) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.18) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x4 - 0.275, x6 + L + 0.32) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x5 - 0.275, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x1 - 0.265, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x2, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.04, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l2 = rect li xspan=(x4 + L + 0.285, x6 + L - 0.06) yspan=(-0.085, nb + WN2 - 0.09) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 - 0.045) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l4 = rect li xspan=(x3 + 0.01, x3 + L + 0.195) yspan=(nb + WN + 0.19, pt - WP + 0.145) net=TE_B
  l5 = rect li xspan=(x3 + L - 0.035, x3 + L + 0.225) yspan=(pt - WP2 - 0.045, pt - 0.025) net=n1
  l6 = rect li xspan=(x3 + L - 0.035, x4 + 0.04) yspan=(pt - WP2 - 0.045, pt - WP2 + 0.16) net=n1
  l7 = rect li xspan=(x3 + L + 0.31, x4 - 0.085) yspan=(nb + WN2 - 0.02, nb + WN) net=n1
  l8 = rect li xspan=(x4 - 0.36, x4 - 0.085) yspan=(nb + WN2 - 0.02, pt - WP2 + 0.16) net=n1
  l9 = rect li xspan=(x4 - 0.36, x5 + 0.03) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=n1
  l10 = rect li xspan=(x4 - 0.36, x4 + 0.04) yspan=(pt - WP - 0.41, pt - WP2 + 0.16) net=n1
  l11 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.045, nb + WN - 0.06) net=n3
  l12 = rect li xspan=(x1 - 0.315, x3 + L + 0.14) yspan=(nb + WN2 - 0.04, nb + WN - 0.06) net=n3
  l13 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 - 0.06, pt - 0.02) net=n3
  l14 = rect li xspan=(x1 - 0.315, x2 - 0.08) yspan=(pt - WP2 - 0.06, pt - WP2 + 0.16) net=n3
  l15 = rect li xspan=(x1 + L - 0.02, x2 - 0.08) yspan=(nb + WN2 - 0.04, pt - WP2 + 0.16) net=n3
  l16 = rect li xspan=(x3 + L - 0.035, x4 + L + 0.115) yspan=(nb + 0.02, nb + 0.23) net=n3
  l17 = rect li xspan=(x3 + L - 0.035, x3 + L + 0.14) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l18 = rect li xspan=(x4 + L - 0.06, x4 + L + 0.115) yspan=(nb + 0.02, pt - WP - 0.58) net=n3
  l19 = rect li xspan=(x4 + L - 0.06, x6 + L - 0.06) yspan=(nb + WN2 + 0.08, pt - WP - 0.58) net=n3
  l20 = rect li xspan=(x5 + L + 0.055, x6 + L - 0.06) yspan=(nb + WN2 + 0.08, pt - WP - 0.16) net=n3
  l21 = rect li xspan=(x5 + L + 0.055, x6 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l22 = rect li xspan=(x4 + L + 0.065, x6 + L + 0.585) yspan=(pt - WP + 0.01, pt - 0.02) net=Z
  l23 = rect li xspan=(x6 + L + 0.115, x6 + L + 0.585) yspan=(nb + 0.02, nb + WN - 0.06) net=Z
  l24 = rect li xspan=(x6 + L + 0.245, x6 + L + 0.585) yspan=(nb + 0.02, pt - 0.02) net=Z
  l25 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l26 = rect li xspan=(x4 - 0.33, x4 + 0.04) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x6 + L + 0.28) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=Z
  c3 = array licon in=nd3 cx=(x5 - 0.23) span=(-0.085 + 0.08, nb + WN2 - 0.09 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.045 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c5 = array licon in=nd2 cx=(x4 - 0.25) span=(nb + WN2 - 0.02 + 0.08, pt - WP2 + 0.16 - 0.08) margin=0.04 net=n1
  c6 = array licon in=pd2 cx=(x6 + L + 0.195) span=(pt - WP + 0.01, pt - 0.02) net=Z
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.06 + 0.08, pt - 0.02 - 0.08) net=n3
  c8 = array licon in=pd2 cx=(x4 - 0.15) span=(pt - 0.31, H + 0.085) net=VPWR
  c9 = array licon in=pd1 cx=(x3 + L + 0.055) span=(pt - WP2 - 0.045 + 0.08, pt - 0.025 - 0.08) net=n1
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 - 0.14) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x6 + L - 0.015) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.67) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.105) cy=0
  mc4 = contact mcon cx=(x4 - 0.16) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.16) cy=0
  mc6 = contact mcon cx=(x5 + 0.025) cy=0
  mc7 = contact mcon cx=(x6 + L - 0.025) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.44) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.13) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.105) cy=H
  mc12 = contact mcon cx=(x4 - 0.16) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.16) cy=H
  mc14 = contact mcon cx=(x5 + 0.025) cy=H
  mc15 = contact mcon cx=(x6 + L - 0.025) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.44) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port TE_B in on=l4
  port Z out on=l22
end
