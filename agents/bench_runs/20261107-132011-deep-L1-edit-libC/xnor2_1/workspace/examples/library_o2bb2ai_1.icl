# o2bb2ai_1: lifted from sky130_fd_sc_hd__o2bb2ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2bb2ai_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2_N s=VPWR b=VPB
  device M1 pmos w=WP l=L d=Y g=B2 s=n2 b=VPB
  device M2 nmos w=WN l=L d=VGND g=B1 s=n3 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A1_N s=n1 b=VPB
  device M4 pmos w=WP l=L d=VPWR g=n1 s=Y b=VPB
  device M5 pmos w=WP l=L d=n2 g=B1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n4 g=A2_N s=n1 b=VNB
  device M7 nmos w=WN l=L d=n3 g=B2 s=VGND b=VNB
  device M8 nmos w=WN l=L d=VGND g=A1_N s=n4 b=VNB
  device M9 nmos w=WN l=L d=Y g=n1 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  x4 = x3 + L + 0.85
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.28, x3 + L + 0.315) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.28, x6 + L + 0.28) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.31, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x3 + L + 0.275, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.065, x5 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6, x6 + L + 0.31) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(-0.085, nb + WN - 0.07) net=VGND
  l2 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.015, x5 + 0.03) yspan=(nb + 0.19, nb + WN + 0.02) net=n3
  l4 = rect li xspan=(x4 + L + 0.015, x6 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n3
  l5 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(nb + 0.04, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x1 - 0.33, x1 + 0.025) yspan=(nb + WN + 0.1, pt - WP - 0.2) net=A1_N
  l7 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.33) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l8 = rect li xspan=(x1 + L + 0.05, x3 - 0.005) yspan=(nb + 0.045, pt - WP - 0.16) net=A2_N
  l9 = rect li xspan=(x1 + L + 0.05, x3 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2_N
  l10 = rect li xspan=(x4 + L + 0.065, x6 - 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B2
  l11 = rect li xspan=(x5 + L + 0.06, x6 - 0.05) yspan=(nb + WN + 0.19, pt - 0.06) net=B2
  l12 = rect li xspan=(x1 + L + 0.015, x3 - 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l13 = rect li xspan=(x1 + L + 0.015, x3 + L + 0.365) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l14 = rect li xspan=(x3 + L + 0.025, x3 + L + 0.365) yspan=(nb + 0.045, nb + WN - 0.06) net=n1
  l15 = rect li xspan=(x3 + L + 0.195, x3 + L + 0.365) yspan=(nb + 0.045, pt - WP + 0.18) net=n1
  l16 = rect li xspan=(x3 + L + 0.195, x4 - 0.355) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l17 = rect li xspan=(x4 - 0.265, x4 - 0.015) yspan=(nb + 0.195, nb + WN - 0.095) net=Y
  l18 = rect li xspan=(x4 - 0.185, x4 - 0.015) yspan=(nb + 0.195, pt - WP + 0.18) net=Y
  l19 = rect li xspan=(x4 - 0.185, x5 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l20 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l21 = rect li xspan=(x1 - 0.265, x1 - 0.015) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  l22 = rect li xspan=(x3 + L + 0.015, x4 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l23 = rect li xspan=(x6 + L + 0.015, x6 + L + 0.265) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.155) span=(-0.085, nb + WN - 0.07) net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.19) span=(nb + 0.045, nb + WN - 0.06) net=n1
  c3 = array licon in=nd2 cx=(x5 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.04, nb + WN + 0.02) net=n3
  c5 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.195 + 0.08, nb + WN - 0.095 - 0.08) net=Y
  c6 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.19 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n3
  c7 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x2 - 0.08) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x3 + L + 0.18) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x4 - 0.22) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L + 0.41) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.145) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x6 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x2 - 0.085) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x4 - 0.215) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.105) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.185) cy=0
  mc8 = contact mcon cx=(x1 - 0.185) cy=H
  mc9 = contact mcon cx=(x2 - 0.085) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc11 = contact mcon cx=(x4 - 0.215) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.105) cy=H
  mc13 = contact mcon cx=(x6 - 0.135) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l6
  port A2_N in on=l8
  port B1 in on=l7
  port B2 in on=l11
  port Y out on=l20
end
