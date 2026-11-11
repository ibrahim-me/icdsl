# einvn_2: lifted from sky130_fd_sc_hd__einvn_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.94 WP3=0.64 L=0.15 H=2.72

stdcell einvn_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=n1 s=n2 b=VNB
  device M1 pmos w=WP l=L d=Z g=A s=n3 b=VPB
  device M2 pmos w=WP2 l=L d=n3 g=TE_B s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n2 g=A s=Z b=VNB
  device M4 pmos w=WP2 l=L d=VPWR g=TE_B s=n3 b=VPB
  device M5 pmos w=WP l=L d=n3 g=A s=Z b=VPB
  device M6 nmos w=WN l=L d=n2 g=n1 s=VGND b=VNB
  device M7 pmos w=WP3 l=L d=n1 g=TE_B s=VPWR b=VPB
  device M8 nmos w=WN2 l=L d=n1 g=TE_B s=VGND b=VNB
  device M9 nmos w=WN l=L d=Z g=A s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  x4 = x3 + 0.04
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.355
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.08) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x2 - 0.07) yspan=(nb, nb + 0.29)
  nd3 = rect diff xspan=(x2 + L + 0.055, x7 + L + 0.265) yspan=(nb + WN2 - 0.055, nb + WN)
  nd4 = rect diff xspan=(x2 + L + 0.065, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 - 0.06) yspan=(pt - WP3, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x5 - 0.055) yspan=(pt - WP3 + 0.305, pt)
  pd3 = rect diff xspan=(x1 + L + 0.08, x5 - 0.06) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x5 + L + 0.07, x7 + L + 0.265) yspan=(pt - WP, pt - WP3 - 0.05)
  pd5 = rect diff xspan=(x5 + L + 0.1, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.225)
  p2 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x5 - 0.05, x5 + L + 0.14) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p4 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p5 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x1, x3 + L) yspan=(pt - WP - 0.165, pt - WP - 0.015)
  p8 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p9 = rect poly xspan=(x3, x3 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6, x7 + L + 0.305) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7, x7 + L + 0.305) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x3 + L + 0.01, x5 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l3 = rect li xspan=(x2 + L - 0.005, x3 - 0.015) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l4 = rect li xspan=(x2 + L - 0.005, x6 - 0.055) yspan=(nb + WN2, nb + WN - 0.06) net=n2
  l5 = rect li xspan=(x5 + L + 0.055, x7 + L + 0.325) yspan=(nb + 0.02, nb + 0.19) net=n2
  l6 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l7 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.325) yspan=(nb + 0.02, nb + WN - 0.11) net=n2
  l8 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.325) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l9 = rect li xspan=(x1 - 0.315, x1 - 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.1) net=TE_B
  l10 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l11 = rect li xspan=(x1 - 0.315, x2 - 0.035) yspan=(nb + WN2, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 + 0.01, pt - 0.02) net=n1
  l13 = rect li xspan=(x1 - 0.315, x2 + 0.025) yspan=(pt - WP2 + 0.01, pt - WP3 - 0.12) net=n1
  l14 = rect li xspan=(x1 + L - 0.05, x2 - 0.035) yspan=(nb + WN2, pt - WP3 - 0.12) net=n1
  l15 = rect li xspan=(x1 + L - 0.05, x5 + L + 0.14) yspan=(nb + WN + 0.11, pt - WP - 0.21) net=n1
  l16 = rect li xspan=(x1 + L - 0.05, x2 + 0.025) yspan=(nb + WN + 0.11, pt - WP3 - 0.12) net=n1
  l17 = rect li xspan=(x2 + L + 0.055, x5 + 0.025) yspan=(pt - WP - 0.04, pt - WP3 + 0.24) net=n3
  l18 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=n3
  l19 = rect li xspan=(x2 + L + 0.055, x7 - 0.055) yspan=(pt - WP3 + 0.02, pt - WP3 + 0.24) net=n3
  l20 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP3 + 0.02, pt - 0.02) net=n3
  l21 = rect li xspan=(x5 + L + 0.05, x7 + L + 0.325) yspan=(pt - WP - 0.04, pt - WP2 + 0.15) net=Z
  l22 = rect li xspan=(x6 + L - 0.03, x7 - 0.055) yspan=(nb + WN2 - 0.06, pt - WP2 + 0.15) net=Z
  l23 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(nb + WN2 - 0.06, nb + WN - 0.04) net=Z
  l24 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.325) yspan=(pt - WP - 0.04, pt - 0.02) net=Z
  l25 = rect li xspan=(x1 + L - 0.03, x2 + 0.025) yspan=(pt - WP3 + 0.05, H + 0.085) net=VPWR
  l26 = rect li xspan=(x3 + L - 0.03, x6 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd4 cx=(x4 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c4 = array licon in=nd4 cx=(x6 - 0.175) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n2
  c5 = array licon in=nd4 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.11 - 0.08) net=n2
  c6 = array licon in=nd4 cx=(x3 - 0.1) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c7 = array licon in=nd4 cx=(x6 + L + 0.14) span=(nb + WN2 - 0.06 + 0.08, pt - WP2 + 0.15 - 0.08) margin=0.04 net=Z
  c8 = array licon in=pd5 cx=(x6 - 0.14) span=(pt - WP - 0.04, pt - WP2 + 0.15) net=Z
  c9 = array licon in=pd5 cx=(x7 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) net=Z
  c10 = array licon in=pd3 cx=(x2 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c11 = array licon in=pd3 cx=(x1 + L + 0.165) span=(pt - WP3 + 0.05, H + 0.085) net=VPWR
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  c13 = array licon in=pd5 cx=(x6 + L + 0.14) span=(pt - WP3 + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c14 = array licon in=pd3 cx=(x4 + L + 0.1) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 + L - 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.135) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.175) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.18) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.135) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.175) cy=H
  mc13 = contact mcon cx=(x6 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port TE_B in on=l9
  port Z out on=l22
end
