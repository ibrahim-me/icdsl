# o211a_2: lifted from sky130_fd_sc_hd__o211a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o211a_2 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=C1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M3 nmos w=WN l=L d=n1 g=C1 s=n2 b=VNB
  device M4 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M5 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M8 pmos w=WP l=L d=n1 g=A2 s=n4 b=VPB
  device M9 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M11 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.22
  x3 = x2 + 0.07
  x4 = x3 + L + 0.725
  x5 = x4 + 0.02
  x6 = x5 + L + 0.22
  x7 = x6 + 0.05
  x8 = x7 + L + 0.33
  x9 = x8 + 0.02
  x10 = x9 + L + 0.27
  x11 = x10 + 0.02
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x3 + L + 0.185) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.27, x3 + L + 0.195) yspan=(nb + WN - 0.285, nb + WN)
  nd3 = rect diff xspan=(x4 - 0.265, x11 + L + 0.34) yspan=(nb, nb + 0.285)
  nd4 = rect diff xspan=(x4 - 0.255, x11 + L + 0.34) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x11 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.3, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.115)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x2 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x2 + L, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.225, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.1)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.1)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x6, x7 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x8 - 0.015, x11 + L + 0.235) yspan=(nb + WN + 0.11, pt - WP - 0.165)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.165)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.165)
  p17 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x4 - 0.31, x5 + 0.01) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x7 + L + 0.045, x8 - 0.05) yspan=(-0.085, nb + 0.29) net=VGND
  l3 = rect li xspan=(x11 + L + 0.03, x11 + L + 0.36) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x2 + L - 0.03, x7 + 0.025) yspan=(nb + 0.4, nb + WN - 0.06) net=n3
  l5 = rect li xspan=(x1 - 0.32, x1 - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C1
  l6 = rect li xspan=(x2 + L - 0.03, x3 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l7 = rect li xspan=(x4 - 0.17, x4 + L - 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l8 = rect li xspan=(x6 - 0.09, x7 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l9 = rect li xspan=(x1 - 0.315, x9 + 0.05) yspan=(pt - WP + 0.025, pt - WP + 0.28) net=n1
  l10 = rect li xspan=(x1 - 0.315, x1 - 0.05) yspan=(pt - WP + 0.025, pt - 0.02) net=n1
  l11 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x1 - 0.31, x2 - 0.055) yspan=(nb + 0.19, nb + WN - 0.06) net=n1
  l13 = rect li xspan=(x1 + L - 0.02, x2 - 0.055) yspan=(nb + 0.19, pt - WP + 0.28) net=n1
  l14 = rect li xspan=(x3 + L + 0.05, x4) yspan=(pt - WP + 0.025, pt - 0.02) net=n1
  l15 = rect li xspan=(x8 - 0.105, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l16 = rect li xspan=(x8 - 0.105, x9 + 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.28) net=n1
  l17 = rect li xspan=(x8 + L - 0.025, x11 + 0.005) yspan=(nb + 0.02, nb + WN - 0.1) net=X
  l18 = rect li xspan=(x8 + L - 0.025, x11 + L + 0.35) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=X
  l19 = rect li xspan=(x9 + L + 0.05, x10 - 0.03) yspan=(pt - WP + 0.42, pt - 0.02) net=X
  l20 = rect li xspan=(x9 + L + 0.05, x11 + L + 0.35) yspan=(pt - WP + 0.42, pt - WP + 0.59) net=X
  l21 = rect li xspan=(x11 + L + 0.155, x11 + L + 0.35) yspan=(nb + WN - 0.27, pt - WP + 0.59) net=X
  l22 = rect li xspan=(x1 + L - 0.025, x3 + 0.025) yspan=(pt - 0.55, H + 0.085) net=VPWR
  l23 = rect li xspan=(x6 + L - 0.025, x9 + 0.015) yspan=(pt - 0.55, H + 0.085) net=VPWR
  l24 = rect li xspan=(x10 + L - 0.005, x11 + L + 0.31) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd4 cx=(x7 + L + 0.165) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd4 cx=(x9 + L + 0.125) span=(nb + 0.02, nb + WN - 0.1) margin=0.04 net=X
  c3 = array licon in=nd4 cx=(x11 + L + 0.195) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.06) net=n1
  c5 = array licon in=nd4 cx=(x4 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c6 = array licon in=nd4 cx=(x6 - 0.095) span=(nb + 0.4, nb + WN - 0.06) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x3 + L + 0.07) span=(nb + 0.4, nb + WN - 0.06) net=n3
  c8 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.025 + 0.08, pt - 0.02 - 0.08) net=n1
  c9 = array licon in=pd1 cx=(x3 + L + 0.215) span=(pt - WP + 0.025, pt - 0.02) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x4 - 0.17) span=(pt - WP + 0.025, pt - 0.02) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x2 - 0.075) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x10 - 0.125) span=(pt - WP + 0.42 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd1 cx=(x11 + L + 0.145) span=(pt - 0.23, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.005) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + L + 0.005) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x11 + 0.045) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x11 + L + 0.49) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 - 0.075) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x4 - 0.09) cy=0
  mc5 = contact mcon cx=(x6 - 0.01) cy=0
  mc6 = contact mcon cx=(x8 - 0.07) cy=0
  mc7 = contact mcon cx=(x10 - 0.04) cy=0
  mc8 = contact mcon cx=(x11 + L + 0.26) cy=0
  mc9 = contact mcon cx=(x1 - 0.175) cy=H
  mc10 = contact mcon cx=(x2 - 0.075) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc12 = contact mcon cx=(x4 - 0.09) cy=H
  mc13 = contact mcon cx=(x6 - 0.01) cy=H
  mc14 = contact mcon cx=(x8 - 0.07) cy=H
  mc15 = contact mcon cx=(x10 - 0.04) cy=H
  mc16 = contact mcon cx=(x11 + L + 0.26) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l7
  port B1 in on=l6
  port C1 in on=l5
  port X out on=l21
end
