# o21a_1: lifted from sky130_fd_sc_hd__o21a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21a_1 width=7 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M1 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M2 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M3 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M4 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M5 pmos w=WP l=L d=n3 g=A2 s=n1 b=VPB
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n3 b=VPB
  device M7 nmos w=WN l=L d=X g=n3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + 0.02
  x3 = x2 + L + 0.665
  x4 = x3 + 0.115
  x5 = x4 + L + 0.285
  x6 = x5 + 0.035
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.245) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.15, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x2 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5 - 0.03, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L + 0.285) yspan=(nb + WN + 0.11, pt - WP - 0.14)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.035, x2 + L + 0.205) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x4 + L + 0.015, x6 + 0.03) yspan=(nb + WN - 0.25, nb + WN + 0.02) net=n2
  l4 = rect li xspan=(x4 + L + 0.015, x7 + L + 0.315) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.315) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l6 = rect li xspan=(x3 - 0.16, x4 + L + 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=B1
  l7 = rect li xspan=(x7 + L - 0.02, x7 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l8 = rect li xspan=(x7 + L + 0.085, x7 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l9 = rect li xspan=(x5 - 0.06, x6 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l10 = rect li xspan=(x6 + L - 0.005, x7 - 0.065) yspan=(nb + WN + 0.21, pt - 0.095) net=A2
  l11 = rect li xspan=(x1 - 0.315, x1 - 0.035) yspan=(nb + 0.02, pt - 0.02) net=X
  l12 = rect li xspan=(x1 - 0.315, x2 + 0.01) yspan=(nb + 0.02, nb + WN + 0.145) net=X
  l13 = rect li xspan=(x2 + L + 0.035, x2 + L + 0.32) yspan=(nb + WN - 0.17, pt - WP + 0.205) net=n3
  l14 = rect li xspan=(x2 + L + 0.035, x4 - 0.03) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n3
  l15 = rect li xspan=(x2 + L + 0.035, x5 - 0.02) yspan=(pt - WP - 0.01, pt - WP + 0.205) net=n3
  l16 = rect li xspan=(x3 - 0.22, x4 - 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l17 = rect li xspan=(x3 - 0.22, x3 + L - 0.005) yspan=(nb + 0.02, nb + 0.285) net=n3
  l18 = rect li xspan=(x3 - 0.22, x4 + 0.005) yspan=(nb + 0.02, nb + 0.32) net=n3
  l19 = rect li xspan=(x3 - 0.22, x4 - 0.015) yspan=(nb + 0.02, nb + 0.34) net=n3
  l20 = rect li xspan=(x3 - 0.22, x3 + L - 0.015) yspan=(nb + 0.02, nb + 0.3) net=n3
  l21 = rect li xspan=(x3 - 0.22, x4 - 0.005) yspan=(nb + 0.02, nb + 0.33) net=n3
  l22 = rect li xspan=(x3 - 0.22, x4 + 0.01) yspan=(nb + 0.02, nb + 0.315) net=n3
  l23 = rect li xspan=(x3 - 0.22, x4 + 0.015) yspan=(nb + 0.02, nb + 0.305) net=n3
  l24 = rect li xspan=(x3 - 0.22, x3 + L - 0.01) yspan=(nb + 0.02, nb + 0.29) net=n3
  l25 = rect li xspan=(x3 + L + 0.045, x5 - 0.02) yspan=(pt - WP - 0.01, pt - 0.02) net=n3
  l26 = rect li xspan=(x1 + L - 0.01, x3 + 0.025) yspan=(pt - 0.625, H + 0.085) net=VPWR
  l27 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.305) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.12) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=X
  c4 = array licon in=nd2 cx=(x3 - 0.025) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c5 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n2
  c6 = array licon in=nd2 cx=(x5 - 0.105) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=n2
  c7 = array licon in=pd1 cx=(x1 - 0.12) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x4 + L + 0.1) span=(pt - WP - 0.01, pt - 0.02) margin=0.04 net=n3
  c9 = array licon in=pd1 cx=(x2 + L + 0.15) span=(pt - 0.625, H + 0.085) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x3 - 0.145) span=(pt - 0.625, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.57, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.12) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.04) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.15) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.075) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.13) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc7 = contact mcon cx=(x1 - 0.17) cy=H
  mc8 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc9 = contact mcon cx=(x3 - 0.075) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.13) cy=H
  mc11 = contact mcon cx=(x6 + L + 0.13) cy=H
  mc12 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l10
  port B1 in on=l6
  port X out on=l11
end
