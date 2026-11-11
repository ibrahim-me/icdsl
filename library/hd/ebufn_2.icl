# ebufn_2: lifted from sky130_fd_sc_hd__ebufn_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.94 WP3=0.64 L=0.15 H=2.72

stdcell ebufn_2 width=11 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=TE_B s=n1 b=VNB
  device M1 nmos w=WN l=L d=n2 g=n3 s=Z b=VNB
  device M2 pmos w=WP3 l=L d=VPWR g=TE_B s=n1 b=VPB
  device M3 pmos w=WP3 l=L d=n3 g=A s=VPWR b=VPB
  device M4 pmos w=WP l=L d=Z g=n3 s=n4 b=VPB
  device M5 nmos w=WN l=L d=VGND g=n1 s=n2 b=VNB
  device M6 pmos w=WP2 l=L d=VPWR g=TE_B s=n4 b=VPB
  device M7 nmos w=WN2 l=L d=n3 g=A s=VGND b=VNB
  device M8 pmos w=WP l=L d=n4 g=n3 s=Z b=VPB
  device M9 nmos w=WN l=L d=n2 g=n1 s=VGND b=VNB
  device M10 pmos w=WP2 l=L d=n4 g=TE_B s=VPWR b=VPB
  device M11 nmos w=WN l=L d=Z g=n3 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.385
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.22
  x5 = x4 + 0.06
  x6 = x5 + L + 0.22
  x7 = x6 + L + 0.395
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x3 + L - 0.05, x8 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP3, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x8 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x5 + L + 0.08, x8 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.225)
  p2 = rect poly xspan=(x4, x6 + L + 0.18) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x6 - 0.01, x6 + L + 0.18) yspan=(nb + WN + 0.075, pt - WP - 0.19)
  p4 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p5 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x1, x1 + L + 0.17) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x2, x2 + L + 0.215) yspan=(nb + WN + 0.14, pt - WP - 0.015)
  p9 = rect poly xspan=(x2, x5 + L - 0.005) yspan=(pt - WP - 0.165, pt - WP - 0.015)
  p10 = rect poly xspan=(x3, x3 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p11 = rect poly xspan=(x5, x5 + L) yspan=(pt - WP - 0.125, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.075) yspan=(-0.085, nb + WN2 - 0.06) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l3 = rect li xspan=(x3 + 0.04, x4 - 0.055) yspan=(nb + 0.02, nb + WN - 0.03) net=n2
  l4 = rect li xspan=(x3 + 0.04, x7 - 0.055) yspan=(nb + WN2, nb + WN - 0.03) net=n2
  l5 = rect li xspan=(x6 + L + 0.055, x8 + L + 0.31) yspan=(nb + 0.04, nb + 0.23) net=n2
  l6 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.04, nb + WN - 0.03) net=n2
  l7 = rect li xspan=(x2 + 0.03, x2 + L + 0.215) yspan=(nb + WN2 + 0.11, pt - WP - 0.21) net=TE_B
  l8 = rect li xspan=(x7 + 0.07, x8 + 0.06) yspan=(nb + WN + 0.14, pt - WP - 0.21) net=n3
  l9 = rect li xspan=(x1 + L - 0.055, x2 - 0.145) yspan=(nb + WN2 + 0.11, pt - WP2 + 0.13) net=A
  l10 = rect li xspan=(x3 + 0.045, x8 + 0.03) yspan=(pt - WP - 0.04, pt - WP3 - 0.08) net=Z
  l11 = rect li xspan=(x3 + 0.045, x8 + L + 0.315) yspan=(pt - WP - 0.04, pt - WP2 + 0.08) net=Z
  l12 = rect li xspan=(x7 + L - 0.03, x8 + L + 0.315) yspan=(nb + WN2 - 0.02, nb + WN - 0.03) net=Z
  l13 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP - 0.04, pt - WP3 + 0.28) net=Z
  l14 = rect li xspan=(x8 + L + 0.085, x8 + L + 0.315) yspan=(nb + WN2 - 0.02, pt - WP2 + 0.08) net=Z
  l15 = rect li xspan=(x1 - 0.315, x1 - 0.08) yspan=(nb + 0.045, pt - 0.02) net=n3
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.045, nb + WN2 - 0.04) net=n3
  l17 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP3, pt - 0.02) net=n3
  l18 = rect li xspan=(x2 + L - 0.05, x3 - 0.135) yspan=(nb + 0.02, nb + WN2 - 0.06) net=n1
  l19 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.345) yspan=(pt - WP - 0.04, pt - 0.02) net=n1
  l20 = rect li xspan=(x2 + L + 0.055, x3 - 0.13) yspan=(pt - WP - 0.04, pt - WP3 - 0.08) net=n1
  l21 = rect li xspan=(x2 + L + 0.385, x3 - 0.135) yspan=(nb + 0.02, pt - WP3 - 0.08) net=n1
  l22 = rect li xspan=(x2 + L + 0.385, x6 + L + 0.18) yspan=(nb + WN + 0.14, pt - WP - 0.21) net=n1
  l23 = rect li xspan=(x2 + L + 0.385, x3 - 0.13) yspan=(nb + WN + 0.14, pt - WP3 - 0.08) net=n1
  l24 = rect li xspan=(x3 - 0.265, x7 - 0.055) yspan=(pt - WP3 + 0.09, pt - WP3 + 0.26) net=n4
  l25 = rect li xspan=(x3 - 0.265, x3 - 0.055) yspan=(pt - WP3 + 0.09, pt - 0.02) net=n4
  l26 = rect li xspan=(x5 + L + 0.055, x7 - 0.055) yspan=(pt - WP3 + 0.09, pt - 0.02) net=n4
  l27 = rect li xspan=(x5 + L + 0.055, x8 + L + 0.315) yspan=(pt - 0.19, pt - 0.02) net=n4
  l28 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.315) yspan=(pt - WP3 - 0.05, pt - 0.02) net=n4
  l29 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP3, H + 0.085) net=VPWR
  l30 = rect li xspan=(x3 + L - 0.03, x5 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN2 - 0.06) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x5 + L + 0.08) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.04, nb + 0.23) net=n2
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.045 + 0.08, nb + WN2 - 0.04 - 0.08) net=n3
  c5 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN2 - 0.06) net=n1
  c6 = array licon in=nd2 cx=(x3 + L + 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.03 - 0.08) net=n2
  c7 = array licon in=nd2 cx=(x6 + L + 0.195) span=(nb + 0.04 + 0.08, nb + WN - 0.03 - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + WN2 - 0.02, nb + WN - 0.03) margin=0.04 net=Z
  c9 = array licon in=pd3 cx=(x7 + L + 0.14) span=(pt - WP - 0.04, pt - WP3 + 0.28) margin=0.04 net=Z
  c10 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - WP3 - 0.05 + 0.08, pt - 0.02 - 0.08) net=n4
  c11 = array licon in=pd1 cx=(x2 - 0.19) span=(pt - WP3, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP3 + 0.08, pt - 0.02 - 0.08) net=n3
  c13 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) net=n1
  c14 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP3 + 0.09 + 0.08, pt - 0.02 - 0.08) net=n4
  c15 = array licon in=pd3 cx=(x6 - 0.02) span=(pt - WP3 + 0.09 + 0.08, pt - 0.02 - 0.08) net=n4
  c16 = array licon in=pd3 cx=(x6 + L + 0.18) span=(pt - WP3 + 0.09 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c17 = array licon in=pd2 cx=(x4 - 0.08) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.035) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.05) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.085) cy=0
  mc4 = contact mcon cx=(x3 - 0.255) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.065) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.105) cy=0
  mc7 = contact mcon cx=(x7 - 0.19) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.165) cy=(pt - WP - 0.295)
  mc11 = contact mcon cx=(x8 - 0.135) cy=(nb + WN + 0.305)
  mc12 = contact mcon cx=(x1 - 0.17) cy=H
  mc13 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc14 = contact mcon cx=(x2 + L + 0.085) cy=H
  mc15 = contact mcon cx=(x3 - 0.255) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.065) cy=H
  mc17 = contact mcon cx=(x5 + L + 0.105) cy=H
  mc18 = contact mcon cx=(x7 - 0.19) cy=H
  mc19 = contact mcon cx=(x7 + L + 0.13) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.17) cy=H
  w1 = rect m1 xspan=(x1 - 0.315, x1 - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n3
  w2 = rect m1 xspan=(x1 - 0.315, x8 + 0.015) yspan=(nb + WN + 0.235, pt - WP - 0.225) net=n3
  w3 = rect m1 xspan=(x7 + L - 0.005, x8 + 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n3
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l9
  port TE_B in on=l7
  port Z out on=l14
end
