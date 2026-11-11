# or3b_2: lifted from sky130_fd_sc_hd__or3b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or3b_2 width=9 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=n1 s=n2 b=VNB
  device M1 nmos w=WN2 l=L d=n2 g=B s=VGND b=VNB
  device M2 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M3 pmos w=WP2 l=L d=n1 g=C_N s=VPWR b=VPB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M6 nmos w=WN2 l=L d=n1 g=C_N s=VGND b=VNB
  device M7 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M8 pmos w=WP2 l=L d=VPWR g=A s=n3 b=VPB
  device M9 pmos w=WP2 l=L d=n4 g=n1 s=n2 b=VPB
  device M10 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M11 pmos w=WP2 l=L d=n3 g=B s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.345
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.35
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 - 0.08) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb + 0.03, nb + WN2)
  nd3 = rect diff xspan=(x1 + L + 0.08, x4 - 0.08) yspan=(nb, nb + WN)
  nd4 = rect diff xspan=(x1 + L + 0.08, x6 + L + 0.265) yspan=(nb + 0.03, nb + 0.03 + WN2)
  pd1 = rect diff xspan=(x1 - 0.265, x4 - 0.08) yspan=(pt - 0.265 - WP2, pt - 0.265)
  pd2 = rect diff xspan=(x1 + L + 0.08, x4 - 0.08) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x1 + L + 0.08, x6 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x6 - 0.065, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x6, x6 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p5 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - 0.265 + 0.13)
  p7 = rect poly xspan=(x5 - 0.095, x5 + L + 0.095) yspan=(pt - 0.265 - 0.075, pt - 0.07)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb - 0.1, pt - 0.07)
  p9 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x2, x3 + L + 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.12) yspan=(-0.085, nb + WN2 - 0.09) net=VGND
  l2 = rect li xspan=(x3 + L + 0.075, x4 - 0.105) yspan=(-0.085, nb + WN2 - 0.09) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l4 = rect li xspan=(x4 - 0.1, x5 + 0.02) yspan=(pt - WP - 0.41, pt - WP + 0.13) net=A
  l5 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + WN + 0.19, pt - WP + 0.155) net=C_N
  l6 = rect li xspan=(x2 + 0.055, x2 + L + 0.08) yspan=(nb + 0.03, pt - 0.265 - WP2 - 0.1) net=X
  l7 = rect li xspan=(x2 + 0.055, x3 - 0.02) yspan=(nb + 0.03, nb + WN2 - 0.06) net=X
  l8 = rect li xspan=(x2 + 0.055, x3 + 0.03) yspan=(pt - WP + 0.01, pt - 0.265 - WP2 - 0.1) net=X
  l9 = rect li xspan=(x3 - 0.03, x5 - 0.055) yspan=(nb + WN - 0.12, pt - WP - 0.58) net=n2
  l10 = rect li xspan=(x3 - 0.03, x3 + L - 0.005) yspan=(nb + WN - 0.12, pt - WP - 0.16) net=n2
  l11 = rect li xspan=(x3 - 0.03, x3 + L + 0.15) yspan=(nb + WN - 0.12, nb + WN + 0.05) net=n2
  l12 = rect li xspan=(x3 + L - 0.025, x6 + L + 0.19) yspan=(nb + 0.03 + WN2 + 0.05, nb + WN - 0.06) net=n2
  l13 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.03 + 0.04, pt - WP - 0.58) net=n2
  l14 = rect li xspan=(x4 + L + 0.055, x6 + L + 0.36) yspan=(nb + WN2, nb + WN - 0.06) net=n2
  l15 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.31) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n2
  l16 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.36) yspan=(pt - WP + 0.01, pt - 0.58 + 0.02) net=n2
  l17 = rect li xspan=(x6 + L + 0.19, x6 + L + 0.36) yspan=(nb + WN2 - 0.05, pt - 0.58 + 0.02) net=n2
  l18 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.03 + 0.025, nb + WN + 0.02) net=n1
  l19 = rect li xspan=(x1 - 0.315, x2 - 0.12) yspan=(nb + 0.03 + WN2 + 0.05, nb + WN + 0.02) net=n1
  l20 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - 0.265 - WP2 + 0.01, pt - 0.265) net=n1
  l21 = rect li xspan=(x1 - 0.315, x2 - 0.12) yspan=(pt - 0.265 - WP2 + 0.01, pt - 0.58 + 0.135) net=n1
  l22 = rect li xspan=(x1 - 0.315, x4 - 0.075) yspan=(pt - 0.58 - 0.035, pt - 0.58 + 0.135) net=n1
  l23 = rect li xspan=(x1 + L + 0.055, x2 - 0.12) yspan=(nb + 0.03 + WN2 + 0.05, pt - 0.58 + 0.135) net=n1
  l24 = rect li xspan=(x3 + L + 0.105, x6 + 0.03) yspan=(pt - 0.265 - WP2 - 0.015, pt - 0.58 + 0.05) net=n1
  l25 = rect li xspan=(x5 + L + 0.135, x6 + 0.03) yspan=(nb + WN + 0.11, pt - 0.58 + 0.05) net=n1
  l26 = rect li xspan=(x5 + L + 0.135, x6 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l27 = rect li xspan=(x4 + L - 0.005, x6 + L + 0.36) yspan=(pt - 0.265 - 0.095, pt - 0.12) net=B
  l28 = rect li xspan=(x1 + L + 0.01, x2 + 0.03) yspan=(pt - 0.265 - 0.01, H + 0.085) net=VPWR
  l29 = rect li xspan=(x3 + L - 0.025, x4 - 0.04) yspan=(pt - 0.265 - 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.09 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd3 cx=(x3 + L + 0.16) span=(-0.085 + 0.08, nb + WN2 - 0.09 - 0.08) net=VGND
  c3 = array licon in=nd4 cx=(x5 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c4 = array licon in=nd3 cx=(x2 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN2 - 0.06 - 0.08) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.025 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c6 = array licon in=nd4 cx=(x4 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, pt - WP - 0.58 - 0.08) margin=0.04 net=n2
  c7 = array licon in=nd4 cx=(x6 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c8 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.01, pt - 0.265 - WP2 - 0.1) margin=0.04 net=X
  c9 = array licon in=pd3 cx=(x6 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 + 0.02 - 0.08) net=n2
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.265 - WP2 + 0.01 + 0.08, pt - 0.265 - 0.08) net=n1
  c11 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - 0.265 - 0.01, H + 0.085) net=VPWR
  c12 = array licon in=pd2 cx=(x3 + L + 0.145) span=(pt - 0.265 - 0.01, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + 0.06) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L/2) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x6 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L/2) cy=(pt - 0.265 + 0.06)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.445) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x4 + L + 0.01, x6 + L - 0.05) yspan=(pt - 0.58 + 0.13, pt + 0.045)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.165) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.135) cy=0
  mc6 = contact mcon cx=(x6 - 0.105) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.215) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.165) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.135) cy=H
  mc13 = contact mcon cx=(x6 - 0.105) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.215) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l27
  port C_N in on=l5
  port X out on=l7
end
