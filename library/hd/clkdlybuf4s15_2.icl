# clkdlybuf4s15_2: lifted from sky130_fd_sc_hd__clkdlybuf4s15_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.82 L=0.15 H=2.72

stdcell clkdlybuf4s15_2 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M2 pmos w=WP2 l=L d=VPWR g=n3 s=n2 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M4 nmos w=WN l=L d=VGND g=n3 s=n2 b=VNB
  device M5 pmos w=WP2 l=L d=n1 g=n2 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=VGND g=n1 s=X b=VNB
  device M8 nmos w=WN2 l=L d=X g=n1 s=VGND b=VNB
  device M9 nmos w=WN2 l=L d=n3 g=A s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.41
  x2 = x1 + L + 0.445
  x3 = x2 + L + 0.945
  x4 = x3 + L + 0.72
  x5 = x4 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.275, x2 + L + 0.41) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.115, x2 + L + 0.41) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x3 - 0.265, x5 + L + 0.495) yspan=(nb, nb + WN2)
  nd4 = rect diff xspan=(x3 - 0.265, x3 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.275, x2 - 0.19) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.275, x2 + L + 0.385) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x3 - 0.27, x5 + L + 0.495) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x4 - 0.255, x5 + L + 0.495) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.19, x1 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p5 = rect poly xspan=(x3 - 0.335, x3 + L + 0.195) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.085, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.035, x2 - 0.08) yspan=(-0.085, nb + WN2 - 0.105) net=VGND
  l2 = rect li xspan=(x3 + L + 0.33, x4 - 0.06) yspan=(-0.085, nb + WN2 - 0.09) net=VGND
  l3 = rect li xspan=(x5 + L + 0.21, x5 + L + 0.545) yspan=(-0.085, nb + WN2 - 0.01) net=VGND
  l4 = rect li xspan=(x1 - 0.325, x1 + L) yspan=(nb + WN + 0.175, pt - WP2 - 0.04) net=A
  l5 = rect li xspan=(x1 - 0.325, x1 + 0.01) yspan=(nb + 0.02, nb + WN + 0.005) net=n3
  l6 = rect li xspan=(x1 - 0.325, x2 + 0.07) yspan=(nb + WN2 + 0.065, nb + WN + 0.005) net=n3
  l7 = rect li xspan=(x1 - 0.325, x1 + 0.025) yspan=(pt - WP2 + 0.13, pt - 0.02) net=n3
  l8 = rect li xspan=(x1 - 0.325, x2 + 0.07) yspan=(pt - WP2 + 0.13, pt - WP2 + 0.3) net=n3
  l9 = rect li xspan=(x2 - 0.105, x2 + 0.07) yspan=(nb + WN2 + 0.065, pt - WP2 + 0.3) net=n3
  l10 = rect li xspan=(x2 - 0.105, x2 + L + 0.185) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l11 = rect li xspan=(x2 + L + 0.095, x3 - 0.42) yspan=(pt - WP2 + 0.12, pt - 0.02) net=n2
  l12 = rect li xspan=(x2 + L + 0.145, x3 - 0.42) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l13 = rect li xspan=(x2 + L + 0.355, x3 - 0.42) yspan=(nb + 0.02, pt - 0.02) net=n2
  l14 = rect li xspan=(x2 + L + 0.355, x3 + L + 0.195) yspan=(nb + WN + 0.19, pt - WP) net=n2
  l15 = rect li xspan=(x3 - 0.25, x3 + 0.025) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l16 = rect li xspan=(x3 - 0.25, x4 - 0.04) yspan=(nb + WN2 + 0.08, nb + WN + 0.02) net=n1
  l17 = rect li xspan=(x3 - 0.25, x3 + 0.025) yspan=(pt - WP2 + 0.125, pt - 0.02) net=n1
  l18 = rect li xspan=(x3 - 0.25, x4 - 0.04) yspan=(pt - WP2 + 0.125, pt - WP2 + 0.3) net=n1
  l19 = rect li xspan=(x4 - 0.21, x4 - 0.04) yspan=(nb + WN2 + 0.08, pt - WP2 + 0.3) net=n1
  l20 = rect li xspan=(x4 - 0.21, x4 + L + 0.105) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l21 = rect li xspan=(x4 + L - 0.035, x5 + L + 0.04) yspan=(nb + 0.02, nb + WN2 - 0.015) net=X
  l22 = rect li xspan=(x4 + L - 0.015, x5 + L + 0.04) yspan=(pt - WP, pt - 0.02) net=X
  l23 = rect li xspan=(x5 - 0.015, x5 + L + 0.04) yspan=(nb + 0.02, pt - 0.02) net=X
  l24 = rect li xspan=(x1 + L + 0.05, x2 - 0.065) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l25 = rect li xspan=(x3 + L + 0.33, x4 - 0.06) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l26 = rect li xspan=(x5 + L + 0.21, x5 + L + 0.545) yspan=(pt - WP, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x4 - 0.225) span=(-0.085, nb + WN2 - 0.09) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02 + 0.08, nb + WN + 0.005 - 0.08) net=n3
  c3 = array licon in=nd2 cx=(x1 + L + 0.2) span=(-0.085, nb + WN2 - 0.105) net=VGND
  c4 = array licon in=nd2 cx=(x2 + L + 0.285) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n2
  c5 = array licon in=nd4 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c6 = array licon in=nd3 cx=(x4 + L + 0.145) span=(nb + 0.02, nb + WN2 - 0.015) margin=0.04 net=X
  c7 = array licon in=nd3 cx=(x5 + L + 0.37) span=(-0.085 + 0.08, nb + WN2 - 0.01 - 0.08) net=VGND
  c8 = array licon in=pd4 cx=(x4 + L + 0.145) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd4 cx=(x5 + L + 0.37) span=(pt - WP + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP2 + 0.13, pt - 0.02) net=n3
  c11 = array licon in=pd2 cx=(x2 + L + 0.26) span=(pt - WP2 + 0.12, pt - 0.02) net=n2
  c12 = array licon in=pd3 cx=(x3 - 0.145) span=(pt - WP2 + 0.125 + 0.08, pt - 0.02 - 0.08) net=n1
  c13 = array licon in=pd2 cx=(x1 + L + 0.215) span=(pt - 0.35, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd3 cx=(x4 - 0.225) span=(pt - 0.35, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.025) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.02) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 - 0.17) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x3 + L + 0.03) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x4 + L - 0.065) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.41, x5 + L + 0.63) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.18) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.14) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.015) cy=0
  mc4 = contact mcon cx=(x3 - 0.47) cy=0
  mc5 = contact mcon cx=(x3 - 0.01) cy=0
  mc6 = contact mcon cx=(x3 + L + 0.31) cy=0
  mc7 = contact mcon cx=(x4 + 0.055) cy=0
  mc8 = contact mcon cx=(x5 + L - 0.065) cy=0
  mc9 = contact mcon cx=(x5 + L + 0.4) cy=0
  mc10 = contact mcon cx=(x1 - 0.18) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.14) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.015) cy=H
  mc13 = contact mcon cx=(x3 - 0.47) cy=H
  mc14 = contact mcon cx=(x3 - 0.01) cy=H
  mc15 = contact mcon cx=(x3 + L + 0.31) cy=H
  mc16 = contact mcon cx=(x4 + 0.055) cy=H
  mc17 = contact mcon cx=(x5 + L - 0.065) cy=H
  mc18 = contact mcon cx=(x5 + L + 0.4) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port X out on=l22
end
