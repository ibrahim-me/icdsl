# o32ai_1: lifted from sky130_fd_sc_hd__o32ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o32ai_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B2 s=Y b=VPB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=n3 g=A2 s=n2 b=VPB
  device M3 nmos w=WN l=L d=Y g=B2 s=n4 b=VNB
  device M4 nmos w=WN l=L d=n4 g=A3 s=VGND b=VNB
  device M5 pmos w=WP l=L d=Y g=A3 s=n3 b=VPB
  device M6 nmos w=WN l=L d=n4 g=B1 s=Y b=VNB
  device M7 nmos w=WN l=L d=n4 g=A1 s=VGND b=VNB
  device M8 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M9 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.115
  x4 = x3 + L + 0.32
  x5 = x4 + L + 0.045
  x6 = x5 + L + 0.5
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.365) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.18, H - 0.105)
  p4 = rect poly xspan=(x2 + 0.035, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x4 + L, x5 + L - 0.005) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.18, H - 0.105)
  p9 = rect poly xspan=(x6 - 0.185, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x4 + 0.015) yspan=(nb + 0.02, nb + 0.25) net=n4
  l2 = rect li xspan=(x3 + L - 0.005, x4 + 0.015) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l3 = rect li xspan=(x3 + L - 0.005, x7 - 0.055) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n4
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.14, nb + WN - 0.06) net=n4
  l5 = rect li xspan=(x5, x6 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l6 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.415) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + WN - 0.2, pt - WP - 0.16) net=B1
  l8 = rect li xspan=(x1 - 0.31, x1 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l9 = rect li xspan=(x7, x7 + L + 0.415) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l10 = rect li xspan=(x3, x4 - 0.095) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B2
  l11 = rect li xspan=(x4 + L - 0.07, x5 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A3
  l12 = rect li xspan=(x1 + L - 0.03, x3 - 0.025) yspan=(nb + 0.42, nb + WN - 0.06) net=Y
  l13 = rect li xspan=(x1 + L - 0.015, x2 - 0.06) yspan=(nb + 0.42, pt - 0.02) net=Y
  l14 = rect li xspan=(x1 + L - 0.015, x5 + 0.03) yspan=(pt - 0.7, pt - 0.02) net=Y
  l15 = rect li xspan=(x6 - 0.23, x6 + 0.07) yspan=(nb + WN + 0.11, pt - 0.02) net=A2
  l16 = rect li xspan=(x1 - 0.31, x1 - 0.04) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l17 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.415) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + 0.25) net=n4
  c2 = array licon in=nd1 cx=(x4 - 0.155) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n4
  c3 = array licon in=nd1 cx=(x5 + L + 0.02) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 - 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(-0.085, nb + WN - 0.06) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.14 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n4
  c7 = array licon in=nd1 cx=(x2 - 0.08) span=(nb + 0.42, nb + WN - 0.06) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01, H + 0.085) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x3 + L + 0.025) span=(pt - 0.7, pt - 0.02) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x4 + 0.05) span=(pt - 0.7, pt - 0.02) margin=0.04 net=Y
  gc1 = contact licon cx=(x1 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.05) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.5) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x5 + L - 0.055) cy=0
  mc5 = contact mcon cx=(x6 - 0.09) cy=0
  mc6 = contact mcon cx=(x7 - 0.05) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.27) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.07) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.135) cy=H
  mc11 = contact mcon cx=(x5 + L - 0.055) cy=H
  mc12 = contact mcon cx=(x6 - 0.09) cy=H
  mc13 = contact mcon cx=(x7 - 0.05) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.27) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l9
  port A2 in on=l15
  port A3 in on=l11
  port B1 in on=l7
  port B2 in on=l10
  port Y out on=l14
end
