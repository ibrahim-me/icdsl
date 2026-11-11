# and3b_2: lifted from sky130_fd_sc_hd__and3b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and3b_2 width=10 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=C s=VGND b=VNB
  device M1 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M2 pmos w=WP2 l=L d=n2 g=C s=VPWR b=VPB
  device M3 pmos w=WP2 l=L d=n2 g=n3 s=VPWR b=VPB
  device M4 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M5 nmos w=WN2 l=L d=n4 g=B s=n1 b=VNB
  device M6 pmos w=WP2 l=L d=VPWR g=B s=n2 b=VPB
  device M7 nmos w=WN2 l=L d=VGND g=A_N s=n3 b=VNB
  device M8 nmos w=WN2 l=L d=n2 g=n3 s=n4 b=VNB
  device M9 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M10 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M11 pmos w=WP2 l=L d=VPWR g=A_N s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + 0.02
  x4 = x3 + L + 0.22
  x5 = x4 + 0.04
  x6 = x5 + L + 0.225
  x7 = x6 + 0.11
  x8 = x7 + L + 0.345
  x9 = x8 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.285) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd2 = rect diff xspan=(x2 - 0.245, x9 + L + 0.265) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd3 = rect diff xspan=(x7 + L + 0.045, x9 + L + 0.265) yspan=(nb + 0.03, nb + WN)
  nd4 = rect diff xspan=(x7 + L + 0.06, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - 0.51 - WP2, pt - 0.51)
  pd2 = rect diff xspan=(x2 - 0.265, x6 + 0.035) yspan=(pt - 0.51 - WP2, pt - 0.51)
  pd3 = rect diff xspan=(x5 + L + 0.08, x9 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd4 = rect diff xspan=(x7 + L + 0.08, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.1, pt - WP - 0.16)
  p2 = rect poly xspan=(x6, x7 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, pt - 0.51 + 0.06)
  p4 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p5 = rect poly xspan=(x1 - 0.26, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.1, pt - 0.51 + 0.15)
  p7 = rect poly xspan=(x2 - 0.255, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, pt - 0.51 + 0.15)
  p9 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.1, pt - WP - 0.16)
  p10 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.1, pt - WP - 0.285)
  p11 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.13, pt + 0.015)
  p12 = rect poly xspan=(x5, x6 - 0.09) yspan=(pt - 0.51 + 0.16, pt + 0.015)
  p13 = rect poly xspan=(x8 - 0.12, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.045) yspan=(-0.085, nb + 0.03 + WN2 - 0.11) net=VGND
  l2 = rect li xspan=(x7 + L + 0.035, x8 + 0.025) yspan=(-0.085, nb + 0.03 + WN2 - 0.105) net=VGND
  l3 = rect li xspan=(x9 + L + 0.05, x9 + L + 0.315) yspan=(-0.085, nb + 0.03 + WN2 + 0.06) net=VGND
  l4 = rect li xspan=(x5 + L + 0.11, x7 - 0.01) yspan=(nb + 0.03 + 0.04, pt - WP - 0.24) net=C
  l5 = rect li xspan=(x5 + L + 0.11, x7 + L + 0.045) yspan=(nb + 0.03 + WN2 + 0.08, pt - WP - 0.24) net=C
  l6 = rect li xspan=(x1 - 0.255, x1 + 0.015) yspan=(nb + 0.03 + WN2 + 0.06, pt - WP - 0.16) net=A_N
  l7 = rect li xspan=(x1 + L + 0.04, x1 + L + 0.315) yspan=(nb + 0.03 + 0.04, pt - 0.58) net=n3
  l8 = rect li xspan=(x1 + L + 0.04, x3 + 0.06) yspan=(nb + WN + 0.13, pt - WP - 0.24) net=n3
  l9 = rect li xspan=(x2 - 0.29, x8 + L - 0.045) yspan=(pt - WP - 0.06, pt - 0.51 - WP2 + 0.04) net=n2
  l10 = rect li xspan=(x2 - 0.29, x2 - 0.055) yspan=(pt - WP - 0.06, pt - 0.51 - 0.015) net=n2
  l11 = rect li xspan=(x2 - 0.285, x4 + L - 0.025) yspan=(nb + 0.03 + 0.04, nb + 0.03 + WN2 - 0.115) net=n2
  l12 = rect li xspan=(x3 + L + 0.085, x4 + L - 0.025) yspan=(nb + 0.03 + 0.04, pt - 0.51 - WP2 + 0.04) net=n2
  l13 = rect li xspan=(x5 + L + 0.11, x7 - 0.03) yspan=(pt - WP - 0.06, pt - 0.58 - 0.015) net=n2
  l14 = rect li xspan=(x8 - 0.13, x8 + L - 0.045) yspan=(nb + WN + 0.11, pt - 0.51 - WP2 + 0.04) net=n2
  l15 = rect li xspan=(x4 + L - 0.05, x6 + L + 0.02) yspan=(pt - 0.51 + 0.15, pt - 0.02) net=B
  l16 = rect li xspan=(x8 + L + 0.015, x9 + 0.025) yspan=(pt - 0.58 - 0.11, pt - 0.02) net=X
  l17 = rect li xspan=(x8 + L + 0.055, x9 + 0.025) yspan=(nb + 0.03 - 0.01, nb + 0.03 + WN2 + 0.03) net=X
  l18 = rect li xspan=(x8 + L + 0.13, x9 + 0.025) yspan=(nb + 0.03 - 0.01, pt - 0.02) net=X
  l19 = rect li xspan=(x8 + L + 0.13, x9 + L + 0.315) yspan=(nb + WN + 0.04, pt - WP - 0.04) net=X
  l20 = rect li xspan=(x1 - 0.315, x1 + 0.005) yspan=(pt - 0.51 - WP2 + 0.02, H + 0.085) net=VPWR
  l21 = rect li xspan=(x2 - 0.31, x4 - 0.075) yspan=(pt - 0.51 + 0.155, H + 0.085) net=VPWR
  l22 = rect li xspan=(x2 + L - 0.03, x4 - 0.075) yspan=(pt - 0.58 - 0.14, H + 0.085) net=VPWR
  l23 = rect li xspan=(x2 + L - 0.03, x5 + 0.03) yspan=(pt - 0.58 - 0.14, pt - 0.51 - 0.02) net=VPWR
  l24 = rect li xspan=(x7 + L + 0.085, x8 - 0.045) yspan=(pt - 0.58 - 0.115, H + 0.085) net=VPWR
  l25 = rect li xspan=(x9 + L + 0.05, x9 + L + 0.315) yspan=(pt - 0.51 - WP2 + 0.07, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.03 + WN2 - 0.11 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.16) span=(nb + 0.03 + 0.04 + 0.08, pt - 0.58 - 0.08) net=n3
  c3 = array licon in=nd2 cx=(x2 - 0.12) span=(nb + 0.03 + 0.04, nb + 0.03 + WN2 - 0.115) net=n2
  c4 = array licon in=nd4 cx=(x8 - 0.145) span=(-0.085, nb + 0.03 + WN2 - 0.105) net=VGND
  c5 = array licon in=nd4 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.03 + WN2 + 0.06 - 0.08) net=VGND
  c6 = array licon in=nd4 cx=(x8 + L + 0.14) span=(nb + 0.03 - 0.01 + 0.08, nb + 0.03 + WN2 + 0.03 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd3 cx=(x6 - 0.03) span=(pt - WP - 0.06 + 0.08, pt - 0.58 - 0.015 - 0.08) net=n2
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.51 - WP2 + 0.02 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, pt - 0.58 - 0.08) net=n3
  c10 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP - 0.06 + 0.08, pt - 0.51 - 0.015 - 0.08) net=n2
  c11 = array licon in=pd2 cx=(x4 - 0.1) span=(pt - 0.58 - 0.14, pt - 0.51 - 0.02) margin=0.04 net=VPWR
  c12 = array licon in=pd4 cx=(x8 - 0.14) span=(pt - 0.58 - 0.115 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd4 cx=(x8 + L + 0.14) span=(pt - 0.58 - 0.11 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd4 cx=(x9 + L + 0.14) span=(pt - 0.51 - WP2 + 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.12) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L - 0.005) cy=(pt - 0.185)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x2 - 0.015, x6 + L + 0.02) yspan=(pt - 0.51 + 0.14, pt + 0.045)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.11) cy=0
  mc5 = contact mcon cx=(x6 - 0.055) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.155) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.13) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x2 - 0.19) cy=H
  mc12 = contact mcon cx=(x3 + L + 0.11) cy=H
  mc13 = contact mcon cx=(x6 - 0.055) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.155) cy=H
  mc15 = contact mcon cx=(x8 + L + 0.13) cy=H
  mc16 = contact mcon cx=(x9 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l6
  port B in on=l15
  port C in on=l4
  port X out on=l17
end
