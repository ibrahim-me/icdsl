# o21ai_2: lifted from sky130_fd_sc_hd__o21ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21ai_2 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M2 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M4 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M6 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M8 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n2 g=B1 s=Y b=VNB
  device M10 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M11 nmos w=WN l=L d=Y g=B1 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.36
  x5 = x4 + 0.04
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x7 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x7 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.075, pt - WP - 0.18)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.075, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.075, x5 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x7 + L) yspan=(nb + WN + 0.075, pt - WP - 0.32)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.06, x2 - 0.06) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x3 + L + 0.11, x4 - 0.08) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(nb + 0.02, nb + WN) net=n2
  l4 = rect li xspan=(x1 - 0.31, x6 + 0.025) yspan=(nb + WN - 0.17, nb + WN) net=n2
  l5 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(nb + 0.02, nb + WN) net=n2
  l6 = rect li xspan=(x4 + L + 0.015, x7 + L + 0.31) yspan=(nb + 0.02, nb + 0.19) net=n2
  l7 = rect li xspan=(x4 + L + 0.015, x6 + 0.025) yspan=(nb + 0.02, nb + WN) net=n2
  l8 = rect li xspan=(x7 + L - 0.005, x7 + L + 0.31) yspan=(nb + 0.02, nb + 0.36) net=n2
  l9 = rect li xspan=(x1 + L + 0.065, x3 + L) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l10 = rect li xspan=(x7 + L - 0.005, x7 + L + 0.315) yspan=(nb + WN - 0.12, pt - WP - 0.085) net=B1
  l11 = rect li xspan=(x1 - 0.295, x1 + 0.04) yspan=(nb + WN + 0.17, pt - WP + 0.13) net=A1
  l12 = rect li xspan=(x1 - 0.295, x5 + L + 0.14) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A1
  l13 = rect li xspan=(x4 - 0.175, x5 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l14 = rect li xspan=(x1 + L + 0.05, x2 - 0.02) yspan=(pt - WP + 0.3, pt - 0.02) net=n1
  l15 = rect li xspan=(x1 + L + 0.05, x4 - 0.06) yspan=(pt - 0.19, pt - 0.02) net=n1
  l16 = rect li xspan=(x3 + L + 0.11, x4 - 0.06) yspan=(pt - 0.35, pt - 0.02) net=n1
  l17 = rect li xspan=(x2 + L + 0.01, x7 - 0.03) yspan=(pt - WP + 0.3, pt - WP + 0.48) net=Y
  l18 = rect li xspan=(x2 + L + 0.01, x3 + 0.025) yspan=(pt - WP + 0.3, pt - 0.36) net=Y
  l19 = rect li xspan=(x6 + L + 0.025, x7 - 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l20 = rect li xspan=(x6 + L + 0.05, x7 - 0.03) yspan=(nb + WN - 0.29, pt - 0.02) net=Y
  l21 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - 0.7, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L - 0.01, x6) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l23 = rect li xspan=(x7 + L - 0.005, x7 + L + 0.31) yspan=(pt - WP + 0.085, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 - 0.165) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN) net=n2
  c4 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + 0.02, nb + WN) margin=0.04 net=n2
  c5 = array licon in=nd1 cx=(x5 + L + 0.145) span=(nb + 0.02, nb + WN) margin=0.04 net=n2
  c6 = array licon in=nd1 cx=(x7 + L + 0.145) span=(nb + 0.02 + 0.08, nb + 0.36 - 0.08) net=n2
  c7 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + WN - 0.29 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x6 + L + 0.145) span=(nb + WN - 0.29 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - WP + 0.085 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - 0.7, H + 0.085) net=VPWR
  c11 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.3 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x4 - 0.165) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c14 = array licon in=pd1 cx=(x5 + L + 0.12) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L/2 + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.15) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x7 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.135) cy=0
  mc3 = contact mcon cx=(x3 - 0.125) cy=0
  mc4 = contact mcon cx=(x4 - 0.165) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.115) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.145) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.175) cy=0
  mc8 = contact mcon cx=(x1 - 0.185) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.135) cy=H
  mc10 = contact mcon cx=(x3 - 0.125) cy=H
  mc11 = contact mcon cx=(x4 - 0.165) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.115) cy=H
  mc13 = contact mcon cx=(x6 + L + 0.145) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l11
  port A2 in on=l9
  port B1 in on=l10
  port Y out on=l17
end
