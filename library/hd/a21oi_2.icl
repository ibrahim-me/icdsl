# a21oi_2: lifted from sky130_fd_sc_hd__a21oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a21oi_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M4 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB
  device M8 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M9 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M10 nmos w=WN l=L d=n1 g=A1 s=Y b=VNB
  device M11 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + 0.005
  x3 = x2 + L + 0.285
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.22
  x6 = x5 + 0.06
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x8 + L + 0.405) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x8 + L + 0.365) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.185, x1 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.13, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.19)
  p4 = rect poly xspan=(x3 - 0.035, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x8 + L + 0.435) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.32, x1 - 0.025) yspan=(-0.085, nb + WN - 0.02) net=VGND
  l2 = rect li xspan=(x5 + L - 0.025, x7 - 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x8 + L + 0.115, x8 + L + 0.445) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l4 = rect li xspan=(x3 - 0.035, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x8 + L + 0.12, x8 + L + 0.395) yspan=(nb + WN + 0.11, pt - WP + 0.14) net=B1
  l6 = rect li xspan=(x1 - 0.275, x2 + L + 0.08) yspan=(nb + WN + 0.15, pt - WP + 0.19) net=A2
  l7 = rect li xspan=(x1 - 0.275, x6 + L + 0.09) yspan=(pt - WP + 0.01, pt - WP + 0.19) net=A2
  l8 = rect li xspan=(x5 - 0.035, x6 + L + 0.09) yspan=(nb + WN + 0.19, pt - WP + 0.19) net=A2
  l9 = rect li xspan=(x5 - 0.035, x6 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l10 = rect li xspan=(x3 + L - 0.04, x4 + 0.025) yspan=(nb + 0.02, nb + WN - 0.1) net=Y
  l11 = rect li xspan=(x3 + L - 0.04, x8 + L - 0.07) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=Y
  l12 = rect li xspan=(x7 + L + 0.035, x8 + L - 0.07) yspan=(nb + 0.02, nb + WN - 0.1) net=Y
  l13 = rect li xspan=(x7 + L + 0.055, x8 + L - 0.07) yspan=(nb + 0.02, pt - WP + 0.63) net=Y
  l14 = rect li xspan=(x1 - 0.31, x7 + 0.03) yspan=(pt - WP + 0.37, pt - 0.46) net=n2
  l15 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(pt - WP + 0.37, pt - 0.02) net=n2
  l16 = rect li xspan=(x1 - 0.31, x4 - 0.06) yspan=(pt - WP + 0.37, pt - 0.38) net=n2
  l17 = rect li xspan=(x3 + L + 0.06, x4 - 0.06) yspan=(pt - WP + 0.37, pt - 0.02) net=n2
  l18 = rect li xspan=(x5 + L + 0.03, x7 + 0.03) yspan=(pt - WP + 0.37, pt - 0.02) net=n2
  l19 = rect li xspan=(x5 + L + 0.03, x8 + L + 0.41) yspan=(pt - 0.2, pt - 0.02) net=n2
  l20 = rect li xspan=(x8 + L + 0.105, x8 + L + 0.41) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l21 = rect li xspan=(x1 + L - 0.025, x3 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.055, x5 + 0.01) yspan=(pt - 0.29, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.145) span=(nb + 0.02, nb + WN - 0.1) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x6 + L + 0.085) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x8 + L + 0.28) span=(-0.085, nb + WN - 0.06) net=VGND
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.63 - 0.08) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, pt - WP + 0.63 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.37 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c8 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.37 + 0.08, pt - 0.02 - 0.08) net=n2
  c9 = array licon in=pd1 cx=(x8 + L + 0.24) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c10 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.37, pt - 0.02) margin=0.04 net=n2
  c11 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x5 - 0.08) span=(pt - 0.29 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.02) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.045) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x8 + L + 0.27) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x8 + L + 0.54) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc3 = contact mcon cx=(x4 - 0.13) cy=0
  mc4 = contact mcon cx=(x5 - 0.03) cy=0
  mc5 = contact mcon cx=(x7 - 0.05) cy=0
  mc6 = contact mcon cx=(x8 - 0.01) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.31) cy=0
  mc8 = contact mcon cx=(x1 - 0.19) cy=H
  mc9 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc10 = contact mcon cx=(x4 - 0.13) cy=H
  mc11 = contact mcon cx=(x5 - 0.03) cy=H
  mc12 = contact mcon cx=(x7 - 0.05) cy=H
  mc13 = contact mcon cx=(x8 - 0.01) cy=H
  mc14 = contact mcon cx=(x8 + L + 0.31) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l6
  port B1 in on=l5
  port Y out on=l12
end
