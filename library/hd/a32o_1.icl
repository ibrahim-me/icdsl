# a32o_1: lifted from sky130_fd_sc_hd__a32o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a32o_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B2 s=n2 b=VPB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=n4 b=VNB
  device M4 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 nmos w=WN l=L d=n1 g=B1 s=n5 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M8 nmos w=WN l=L d=n4 g=A1 s=n1 b=VNB
  device M9 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A3 s=n2 b=VPB
  device M11 nmos w=WN l=L d=n5 g=B2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.47
  x2 = x1 + L + 0.495
  x3 = x2 + 0.03
  x4 = x3 + L + 0.31
  x5 = x4 + L + 0.46
  x6 = x5 + L + 0.38
  x7 = x6 + 0.07
  x8 = x7 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.335, x8 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.335, x8 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5 - 0.125, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6 - 0.055, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.02, x2 - 0.18) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x8 + L - 0.025, x8 + L + 0.31) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l3 = rect li xspan=(x2 - 0.035, x3 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l4 = rect li xspan=(x4 - 0.055, x4 + L + 0.075) yspan=(nb + WN - 0.22, pt - WP - 0.16) net=A2
  l5 = rect li xspan=(x5 - 0.195, x5 + L - 0.05) yspan=(nb + WN - 0.22, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x5 + L + 0.125, x6 + L + 0.02) yspan=(nb + WN - 0.225, pt - WP - 0.16) net=B1
  l7 = rect li xspan=(x8 + 0.05, x8 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B2
  l8 = rect li xspan=(x8 + L + 0.05, x8 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B2
  l9 = rect li xspan=(x1 + L - 0.045, x2 - 0.23) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l10 = rect li xspan=(x1 + L + 0.095, x2 - 0.23) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=n1
  l11 = rect li xspan=(x1 + L + 0.095, x2 + L + 0.015) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x1 + L + 0.095, x8 - 0.06) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l13 = rect li xspan=(x2 - 0.01, x6 + 0.01) yspan=(nb + 0.08, nb + 0.25) net=n1
  l14 = rect li xspan=(x2 - 0.01, x2 + L + 0.015) yspan=(nb + 0.08, nb + WN - 0.06) net=n1
  l15 = rect li xspan=(x7 + L - 0.015, x8 - 0.06) yspan=(pt - WP + 0.01, pt - WP + 0.64) net=n1
  l16 = rect li xspan=(x1 - 0.38, x1 - 0.125) yspan=(nb + 0.065, pt - 0.06) net=X
  l17 = rect li xspan=(x1 - 0.38, x1 - 0.045) yspan=(nb + 0.065, nb + WN - 0.325) net=X
  l18 = rect li xspan=(x1 - 0.38, x1 - 0.045) yspan=(pt - WP + 0.43, pt - 0.06) net=X
  l19 = rect li xspan=(x2 + L, x6 - 0.03) yspan=(pt - WP + 0.39, pt - 0.44) net=n2
  l20 = rect li xspan=(x2 + L, x4 - 0.05) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l21 = rect li xspan=(x5 + L + 0.02, x6 - 0.03) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l22 = rect li xspan=(x5 + L + 0.02, x8 + L + 0.23) yspan=(pt - 0.19, pt - 0.02) net=n2
  l23 = rect li xspan=(x8 + L + 0.06, x8 + L + 0.23) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l24 = rect li xspan=(x1 + L + 0.065, x2 - 0.1) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l25 = rect li xspan=(x4 + L + 0.065, x5 - 0.065) yspan=(pt - 0.27, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x8 + L + 0.145) span=(-0.085, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.21) span=(nb + 0.065 + 0.08, pt - 0.06 - 0.08) net=X
  c3 = array licon in=nd1 cx=(x1 + L + 0.15) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 - 0.16) span=(nb + 0.08, nb + 0.25) margin=0.04 net=n1
  c5 = array licon in=pd1 cx=(x1 - 0.21) span=(nb + 0.065 + 0.08, pt - 0.06 - 0.08) net=X
  c6 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd1 cx=(x7 + L + 0.075) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c9 = array licon in=pd1 cx=(x1 + L + 0.23) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x5 + L + 0.185) span=(pt - WP + 0.39, pt - 0.02) margin=0.04 net=n2
  c11 = array licon in=pd1 cx=(x4 + L + 0.23) span=(pt - 0.27, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.045) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.47, x8 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.24) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.08) cy=0
  mc3 = contact mcon cx=(x3 + 0.02) cy=0
  mc4 = contact mcon cx=(x4 + 0.03) cy=0
  mc5 = contact mcon cx=(x5 - 0.115) cy=0
  mc6 = contact mcon cx=(x6 - 0.175) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.075) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.175) cy=0
  mc9 = contact mcon cx=(x1 - 0.24) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.08) cy=H
  mc11 = contact mcon cx=(x3 + 0.02) cy=H
  mc12 = contact mcon cx=(x4 + 0.03) cy=H
  mc13 = contact mcon cx=(x5 - 0.115) cy=H
  mc14 = contact mcon cx=(x6 - 0.175) cy=H
  mc15 = contact mcon cx=(x7 + L + 0.075) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l4
  port A3 in on=l3
  port B1 in on=l6
  port B2 in on=l7
  port X out on=l16
end
