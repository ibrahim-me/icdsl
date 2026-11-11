# or4b_2: lifted from sky130_fd_sc_hd__or4b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or4b_2 width=10 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=n2 s=VGND b=VNB
  device M1 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M2 nmos w=WN2 l=L d=n2 g=D_N s=VGND b=VNB
  device M3 nmos w=WN2 l=L d=VGND g=C s=n1 b=VNB
  device M4 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M5 nmos w=WN2 l=L d=n1 g=B s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=VPWR g=A s=n3 b=VPB
  device M7 pmos w=WP2 l=L d=n3 g=B s=n4 b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 pmos w=WP2 l=L d=n4 g=C s=n5 b=VPB
  device M10 pmos w=WP2 l=L d=n2 g=D_N s=VPWR b=VPB
  device M11 pmos w=WP2 l=L d=n5 g=n2 s=n1 b=VPB
  device M12 nmos w=WN2 l=L d=VGND g=A s=n1 b=VNB
  device M13 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.345
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.345
  x5 = x4 + L + 0.34
  x6 = x5 + L + 0.22
  x7 = x6 + 0.06
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x4 - 0.08) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 + L - 0.01, x4 + 0.005) yspan=(pt - 0.58 + 0.28, pt)
  pd3 = rect diff xspan=(x1 + L - 0.01, x2 - 0.08) yspan=(pt - 0.58 + 0.28, pt + 0.08)
  pd4 = rect diff xspan=(x1 + L + 0.08, x4 - 0.08) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x3 + L + 0.08, x4 + 0.005) yspan=(pt - 0.58 + 0.28, pt + 0.08)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.275, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p4 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13)
  p6 = rect poly xspan=(x6, x7 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x7, x7 + L) yspan=(nb - 0.1, pt - WP - 0.16)
  p8 = rect poly xspan=(x5 - 0.155, x5 + L + 0.035) yspan=(pt - 0.58 + 0.26, pt - 0.05)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb - 0.1, pt - 0.05)
  p10 = rect poly xspan=(x7 + L + 0.11, x8 + L + 0.02) yspan=(pt - 0.58 + 0.26, pt - 0.05)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb - 0.1, pt - 0.05)
  p12 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.09, x2 - 0.085) yspan=(-0.085, nb + 0.03 + 0.3) net=VGND
  l2 = rect li xspan=(x3 + L - 0.015, x4 + 0.03) yspan=(-0.085, nb + 0.03 + WN2 - 0.2) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x7 + 0.03) yspan=(-0.085, nb + 0.03 + WN2 - 0.2) net=VGND
  l4 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.305) yspan=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  l5 = rect li xspan=(x4 - 0.035, x5 + 0.055) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=A
  l6 = rect li xspan=(x6 - 0.08, x8 + L + 0.3) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=C
  l7 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.05) net=D_N
  l8 = rect li xspan=(x3 - 0.015, x3 + L + 0.14) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=n1
  l9 = rect li xspan=(x3 + L - 0.035, x8 - 0.055) yspan=(nb + 0.03 + WN2 + 0.05, nb + WN + 0.02) net=n1
  l10 = rect li xspan=(x3 + L - 0.035, x3 + L + 0.14) yspan=(nb + 0.03 + WN2 + 0.05, pt - WP - 0.035) net=n1
  l11 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.155) yspan=(nb + WN + 0.47, pt - WP + 0.13) net=n1
  l12 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.165) yspan=(nb + WN + 0.485, pt - WP + 0.13) net=n1
  l13 = rect li xspan=(x3 + L - 0.03, x4 - 0.17) yspan=(nb + WN + 0.495, pt - WP + 0.13) net=n1
  l14 = rect li xspan=(x3 + L - 0.03, x4 - 0.165) yspan=(nb + WN + 0.505, pt - WP + 0.13) net=n1
  l15 = rect li xspan=(x3 + L - 0.03, x4 - 0.16) yspan=(nb + WN + 0.515, pt - WP + 0.13) net=n1
  l16 = rect li xspan=(x3 + L - 0.03, x4 - 0.145) yspan=(nb + WN + 0.525, pt - WP + 0.13) net=n1
  l17 = rect li xspan=(x3 + L - 0.03, x4 - 0.135) yspan=(nb + WN + 0.535, pt - WP + 0.13) net=n1
  l18 = rect li xspan=(x3 + L - 0.03, x4 - 0.125) yspan=(nb + WN + 0.54, pt - WP + 0.13) net=n1
  l19 = rect li xspan=(x3 + L - 0.03, x8 + L + 0.31) yspan=(nb + WN + 0.56, pt - WP + 0.13) net=n1
  l20 = rect li xspan=(x4 + L + 0.055, x5 - 0.115) yspan=(nb + 0.03 + 0.04, nb + WN + 0.02) net=n1
  l21 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(nb + 0.03 + 0.04, nb + WN + 0.02) net=n1
  l22 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.31) yspan=(nb + WN + 0.56, pt - 0.58 - 0.09) net=n1
  l23 = rect li xspan=(x2 + 0.055, x2 + L + 0.08) yspan=(nb + 0.03 + 0.41, pt - 0.58 - 0.08) net=X
  l24 = rect li xspan=(x2 + 0.055, x3 - 0.06) yspan=(nb + 0.03 + 0.41, nb + WN - 0.095) net=X
  l25 = rect li xspan=(x2 + 0.055, x3 - 0.055) yspan=(pt - WP + 0.01, pt - 0.58 - 0.08) net=X
  l26 = rect li xspan=(x2 + L - 0.06, x3 - 0.055) yspan=(nb + 0.03 - 0.005, nb + 0.03 + WN2 - 0.005) net=X
  l27 = rect li xspan=(x1 - 0.315, x1 - 0.05) yspan=(nb + 0.03 + 0.06, nb + WN + 0.02) net=n2
  l28 = rect li xspan=(x1 - 0.315, x2 - 0.12) yspan=(nb + 0.03 + WN2 + 0.05, nb + WN + 0.02) net=n2
  l29 = rect li xspan=(x1 - 0.315, x2 - 0.12) yspan=(pt - WP + 0.12, pt - WP + 0.405) net=n2
  l30 = rect li xspan=(x1 + L - 0.035, x2 - 0.12) yspan=(pt - WP + 0.12, pt - 0.58 + 0.26) net=n2
  l31 = rect li xspan=(x1 + L - 0.035, x4 - 0.075) yspan=(pt - 0.58 + 0.09, pt - 0.58 + 0.26) net=n2
  l32 = rect li xspan=(x1 + L + 0.055, x2 - 0.12) yspan=(nb + 0.03 + WN2 + 0.05, pt - 0.58 + 0.26) net=n2
  l33 = rect li xspan=(x3 + L - 0.01, x8 - 0.08) yspan=(pt - 0.58 - 0.12, pt - 0.58 + 0.05) net=n2
  l34 = rect li xspan=(x3 + L - 0.01, x4 - 0.075) yspan=(pt - 0.58 - 0.12, pt - 0.58 + 0.26) net=n2
  l35 = rect li xspan=(x7 + L + 0.03, x8 - 0.08) yspan=(pt - 0.58 - 0.12, pt - 0.1) net=n2
  l36 = rect li xspan=(x7 + L + 0.03, x8 + L + 0.095) yspan=(pt - 0.27, pt - 0.1) net=n2
  l37 = rect li xspan=(x4 + L + 0.055, x7 - 0.015) yspan=(pt - 0.58 + 0.22, pt - 0.07) net=B
  l38 = rect li xspan=(x1 + L - 0.03, x2 - 0.04) yspan=(pt - 0.15, H + 0.085) net=VPWR
  l39 = rect li xspan=(x3 + L + 0.035, x4 + 0.03) yspan=(pt - 0.15, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.17) span=(-0.085 + 0.08, nb + 0.03 + 0.3 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x3 + L + 0.155) span=(-0.085, nb + 0.03 + WN2 - 0.2) net=VGND
  c3 = array licon in=nd1 cx=(x6 - 0.08) span=(-0.085, nb + 0.03 + WN2 - 0.2) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.06 + 0.08, nb + WN + 0.02 - 0.08) net=n2
  c7 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085, nb + 0.03 + WN2 - 0.1) net=VGND
  c8 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.03 - 0.005 + 0.08, nb + 0.03 + WN2 - 0.005 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x8 + L + 0.14) span=(nb + WN + 0.56, pt - 0.58 - 0.09) net=n1
  c10 = array licon in=pd4 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 - 0.08 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.12, pt - WP + 0.405) net=n2
  c12 = array licon in=pd3 cx=(x1 + L + 0.14) span=(pt - 0.15, H + 0.085) net=VPWR
  c13 = array licon in=pd5 cx=(x4 - 0.14) span=(pt - 0.15, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L/2) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + 0.015) cy=(pt - 0.185)
  gc6 = contact licon cx=x8 cy=(pt - 0.185)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.43) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x4 + L - 0.015, x8 + L + 0.05) yspan=(pt - 0.58 + 0.13, pt + 0.01)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.165) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.14) cy=0
  mc6 = contact mcon cx=(x6 - 0.1) cy=0
  mc7 = contact mcon cx=(x8 - 0.12) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.2) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc12 = contact mcon cx=(x3 + L + 0.165) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x6 - 0.1) cy=H
  mc15 = contact mcon cx=(x8 - 0.12) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.2) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l5
  port B in on=l37
  port C in on=l6
  port D_N in on=l7
  port X out on=l26
end
