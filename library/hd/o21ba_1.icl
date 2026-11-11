# o21ba_1: lifted from sky130_fd_sc_hd__o21ba_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell o21ba_1 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=VPWR g=B1_N s=n2 b=VPB
  device M2 nmos w=WN l=L d=n3 g=n2 s=n1 b=VNB
  device M3 nmos w=WN2 l=L d=VGND g=B1_N s=n2 b=VNB
  device M4 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M5 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M7 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n2 s=n3 b=VPB
  device M9 pmos w=WP l=L d=n3 g=A2 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + 0.08
  x3 = x2 + L + 0.345
  x4 = x3 + L + 0.99
  x5 = x4 + L + 0.34
  x6 = x5 + L + 0.22
  x7 = x6 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.185, x3 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.185, x3 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  nd3 = rect diff xspan=(x4 - 0.265, x7 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.285) yspan=(pt - WP, pt - 0.58)
  pd3 = rect diff xspan=(x4 - 0.305, x7 + L + 0.225) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x3, x3 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p2 = rect poly xspan=(x3, x3 + L + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x1, x2 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x3 + L + 0.375, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.125, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x6, x7 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.09, x3 - 0.085) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x5 + L + 0.055, x6 + 0.01) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l3 = rect li xspan=(x4 + L + 0.035, x5 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l4 = rect li xspan=(x4 + L + 0.035, x7 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x6 + L + 0.03, x7 + L + 0.305) yspan=(nb + 0.035, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x4 + L - 0.03, x5 + L + 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  l7 = rect li xspan=(x6 + 0.02, x7 + L + 0.46) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l8 = rect li xspan=(x3 + 0.07, x3 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1_N
  l9 = rect li xspan=(x3 + L - 0.035, x4 - 0.395) yspan=(pt - WP + 0.04, pt - WP + 0.21) net=n2
  l10 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.225) yspan=(nb + 0.23 - 0.015, nb + WN - 0.06) net=n2
  l11 = rect li xspan=(x3 + L + 0.055, x4 - 0.395) yspan=(nb + 0.23 + 0.19, nb + WN - 0.06) net=n2
  l12 = rect li xspan=(x3 + L + 0.425, x4 - 0.395) yspan=(nb + 0.23 + 0.19, pt - WP + 0.21) net=n2
  l13 = rect li xspan=(x1 - 0.315, x1 - 0.06) yspan=(nb + 0.23 - 0.015, pt - 0.02) net=X
  l14 = rect li xspan=(x1 - 0.315, x2 - 0.03) yspan=(nb + 0.23 - 0.015, nb + WN - 0.06) net=X
  l15 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP - 0.005, pt - 0.02) net=X
  l16 = rect li xspan=(x1 + L/2 + 0.04, x3 - 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l17 = rect li xspan=(x2 + L - 0.03, x3 - 0.105) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13) net=n3
  l18 = rect li xspan=(x2 + L - 0.03, x5 + 0.005) yspan=(pt - 0.58 - 0.04, pt - 0.58 + 0.13) net=n3
  l19 = rect li xspan=(x4 - 0.225, x4 - 0.055) yspan=(nb + 0.02, pt - 0.58 + 0.13) net=n3
  l20 = rect li xspan=(x4 - 0.225, x5 + 0.005) yspan=(pt - WP - 0.03, pt - 0.58 + 0.13) net=n3
  l21 = rect li xspan=(x4 + L + 0.015, x5 + 0.005) yspan=(pt - WP - 0.03, pt - 0.02) net=n3
  l22 = rect li xspan=(x2 + L - 0.03, x3 + 0.045) yspan=(pt - 0.28, H + 0.085) net=VPWR
  l23 = rect li xspan=(x4 - 0.345, x4 - 0.015) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l24 = rect li xspan=(x6 + L - 0.03, x7 + L + 0.245) yspan=(pt - WP + 0.05, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x5 - 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c2 = array licon in=nd3 cx=(x6 - 0.08) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd3 cx=(x7 + L + 0.14) span=(nb + 0.035, nb + WN + 0.02) net=n1
  c4 = array licon in=nd3 cx=(x4 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.58 + 0.13 - 0.08) net=n3
  c5 = array licon in=nd1 cx=(x1 - 0.06) span=(nb + 0.23 - 0.015 + 0.08, nb + WN - 0.06 - 0.08) net=X
  c6 = array licon in=nd1 cx=(x3 - 0.17) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c7 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.23 - 0.015 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c8 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.04, pt - WP + 0.21) margin=0.04 net=n2
  c9 = array licon in=pd3 cx=(x5 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c10 = array licon in=pd3 cx=(x7 + L + 0.08) span=(pt - WP + 0.05, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.005, pt - 0.02) net=X
  c12 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.28, H + 0.085) net=VPWR
  c13 = array licon in=pd3 cx=(x4 - 0.18) span=(pt - 0.27, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x2 + L - 0.03) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.48) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L - 0.025) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.545) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.045) cy=0
  mc4 = contact mcon cx=(x4 - 0.485) cy=0
  mc5 = contact mcon cx=(x4 - 0.025) cy=0
  mc6 = contact mcon cx=(x5 - 0.045) cy=0
  mc7 = contact mcon cx=x7 cy=0
  mc8 = contact mcon cx=(x7 + L + 0.315) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.07) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.045) cy=H
  mc12 = contact mcon cx=(x4 - 0.485) cy=H
  mc13 = contact mcon cx=(x4 - 0.025) cy=H
  mc14 = contact mcon cx=(x5 - 0.045) cy=H
  mc15 = contact mcon cx=x7 cy=H
  mc16 = contact mcon cx=(x7 + L + 0.315) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l6
  port B1_N in on=l8
  port X out on=l13
end
