# or4b_1: lifted from sky130_fd_sc_hd__or4b_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or4b_1 width=10 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=n1 s=n2 b=VNB
  device M1 nmos w=WN2 l=L d=n2 g=A s=VGND b=VNB
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2 b=VNB
  device M3 pmos w=WP2 l=L d=n3 g=C s=n4 b=VPB
  device M4 pmos w=WP2 l=L d=n2 g=n1 s=n3 b=VPB
  device M5 pmos w=WP2 l=L d=n4 g=B s=n5 b=VPB
  device M6 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M7 nmos w=WN2 l=L d=VGND g=D_N s=n1 b=VNB
  device M8 nmos w=WN2 l=L d=n2 g=C s=VGND b=VNB
  device M9 pmos w=WP2 l=L d=VPWR g=D_N s=n1 b=VPB
  device M10 pmos w=WP2 l=L d=n5 g=A s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.315
  x4 = x3 + 0.02
  x5 = x4 + L + 0.225
  x6 = x5 + 0.035
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.35
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd2 = rect diff xspan=(x2 - 0.265, x8 + L + 0.28) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd3 = rect diff xspan=(x7 + L + 0.08, x8 + L + 0.28) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x2 - 0.265, x8 + L + 0.28) yspan=(pt - WP, pt - 0.58)
  pd3 = rect diff xspan=(x7 + L + 0.08, x8 + L + 0.28) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x2 - 0.31, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p5 = rect poly xspan=(x3 - 0.1, x4 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.1, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13)
  p8 = rect poly xspan=(x7 - 0.08, x7 + L + 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p10 = rect poly xspan=(x5 - 0.05, x6 + L + 0.105) yspan=(pt - 0.32, pt - 0.58 + 0.51)
  p11 = rect poly xspan=(x5 - 0.045, x6 + L + 0.1) yspan=(pt - 0.33, pt - 0.58 + 0.51)
  p12 = rect poly xspan=(x5 - 0.04, x6 + L + 0.095) yspan=(pt - 0.34, pt - 0.58 + 0.51)
  p13 = rect poly xspan=(x5, x5 + L) yspan=(nb + 0.03 + WN2 + 0.075, pt - 0.58 + 0.51)
  p14 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.1, nb + WN + 0.025)
  p15 = rect poly xspan=(x8 - 0.09, x8 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  l2 = rect li xspan=(x2 - 0.305, x2 + 0.03) yspan=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  l3 = rect li xspan=(x3 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + 0.03 + 0.22) net=VGND
  l4 = rect li xspan=(x7 + L - 0.03, x8 + 0.01) yspan=(-0.085, nb + 0.03 + 0.22) net=VGND
  l5 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.03 + WN2 + 0.07, pt - WP - 0.16) net=D_N
  l6 = rect li xspan=(x6 + L + 0.075, x7 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l7 = rect li xspan=(x2 + L + 0.04, x6 + 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=C
  l8 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.295) yspan=(nb + 0.03 + 0.04, pt - 0.58 + 0.015) net=n1
  l9 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.3) yspan=(nb + 0.03 + 0.04, pt - WP - 0.16) net=n1
  l10 = rect li xspan=(x1 + L + 0.055, x2 - 0.09) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l11 = rect li xspan=(x2 - 0.31, x2 + 0.015) yspan=(pt - WP + 0.01, pt - 0.58 + 0.05) net=n2
  l12 = rect li xspan=(x2 - 0.31, x7 + 0.03) yspan=(pt - WP + 0.3, pt - 0.58 + 0.05) net=n2
  l13 = rect li xspan=(x2 + L + 0.085, x3 - 0.06) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n2
  l14 = rect li xspan=(x2 + L + 0.085, x8 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, nb + WN - 0.06) net=n2
  l15 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n2
  l16 = rect li xspan=(x6 + L + 0.135, x8 + 0.03) yspan=(pt - WP + 0.01, pt - 0.58 - 0.24) net=n2
  l17 = rect li xspan=(x6 + L + 0.135, x7 + 0.03) yspan=(pt - WP + 0.01, pt - 0.58 + 0.05) net=n2
  l18 = rect li xspan=(x8 - 0.145, x8 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, pt - 0.58 - 0.24) net=n2
  l19 = rect li xspan=(x8 - 0.145, x8 + L - 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l20 = rect li xspan=(x1 + L + 0.07, x7 + 0.03) yspan=(pt - 0.58 + 0.22, pt - 0.07) net=B
  l21 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.33) yspan=(nb + 0.03 + 0.15, nb + 0.03 + WN2 + 0.075) net=X
  l22 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.33) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l23 = rect li xspan=(x8 + L + 0.16, x8 + L + 0.33) yspan=(nb + 0.03 + 0.15, pt - 0.02) net=X
  l24 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP + 0.075, H + 0.085) net=VPWR
  l25 = rect li xspan=(x7 + L + 0.055, x8 - 0.015) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x5 - 0.105) span=(-0.085, nb + 0.03 + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x8 - 0.16) span=(-0.085, nb + 0.03 + 0.22) net=VGND
  c3 = array licon in=nd2 cx=(x3 - 0.145) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n2
  c4 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n2
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, pt - 0.58 + 0.015 - 0.08) net=n1
  c7 = array licon in=nd2 cx=(x2 - 0.14) span=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  c8 = array licon in=nd3 cx=(x8 + L + 0.14) span=(nb + 0.03 + 0.15 + 0.08, nb + 0.03 + WN2 + 0.075 - 0.08) net=X
  c9 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 + 0.05 - 0.08) net=n2
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.075, H + 0.085) net=VPWR
  c11 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, pt - 0.58 + 0.015 - 0.08) net=n1
  c12 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=X
  c13 = array licon in=pd3 cx=(x8 - 0.145) span=(pt - 0.58 - 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.175) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + 0.06) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x8 + 0.05) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x5 + L - 0.03) cy=(pt - 0.58 + 0.375)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x3 - 0.01, x7 + L - 0.055) yspan=(pt - 0.58 + 0.13, pt + 0.01)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x5 - 0.11) cy=0
  mc6 = contact mcon cx=(x7 - 0.105) cy=0
  mc7 = contact mcon cx=(x8 - 0.135) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.185) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x2 - 0.19) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x5 - 0.11) cy=H
  mc14 = contact mcon cx=(x7 - 0.105) cy=H
  mc15 = contact mcon cx=(x8 - 0.135) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port B in on=l20
  port C in on=l7
  port D_N in on=l5
  port X out on=l22
end
