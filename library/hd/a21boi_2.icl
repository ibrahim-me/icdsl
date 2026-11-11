# a21boi_2: lifted from sky130_fd_sc_hd__a21boi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell a21boi_2 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  device M1 nmos w=WN2 l=L d=n2 g=B1_N s=VGND b=VNB
  device M2 nmos w=WN l=L d=Y g=n2 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M4 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M5 pmos w=WP l=L d=n3 g=n2 s=Y b=VPB
  device M6 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M8 pmos w=WP l=L d=Y g=n2 s=n3 b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M10 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB
  device M12 nmos w=WN l=L d=n4 g=A1 s=Y b=VNB
  device M13 pmos w=WP2 l=L d=VPWR g=B1_N s=n2 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.065
  x3 = x2 + L + 0.6
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + 0.06
  x7 = x6 + L + 0.22
  x8 = x7 + L + 0.29
  x9 = x8 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.1, x9 + L + 0.29) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.08, x9 + L + 0.29) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.065) yspan=(pt - 0.175 - WP2, pt - 0.175)
  pd2 = rect diff xspan=(x3 - 0.265, x9 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.23, x1 + L) yspan=(nb + WN2 + 0.075, pt - WP - 0.05)
  p2 = rect poly xspan=(x1 - 0.23, x2 + L) yspan=(nb + WN2 + 0.075, nb + WN - 0.005)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN2 + 0.075, pt - 0.045)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, nb + WN - 0.005)
  p5 = rect poly xspan=(x2 + L + 0.245, x4 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.065, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x8 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L + 0.185) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.235, x3 - 0.125) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x4 + L + 0.03, x6 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x9 + L + 0.025, x9 + L + 0.32) yspan=(-0.085, nb + WN - 0.02) net=VGND
  l4 = rect li xspan=(x7, x8 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x5 - 0.095, x6 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l6 = rect li xspan=(x5 - 0.09, x6 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.19) net=A2
  l7 = rect li xspan=(x5 - 0.09, x9 + L + 0.065) yspan=(pt - WP + 0.01, pt - WP + 0.19) net=A2
  l8 = rect li xspan=(x9 - 0.085, x9 + L + 0.065) yspan=(nb + WN + 0.15, pt - WP + 0.19) net=A2
  l9 = rect li xspan=(x9 - 0.085, x9 + L + 0.185) yspan=(nb + WN + 0.15, pt - WP - 0.19) net=A2
  l10 = rect li xspan=(x1 - 0.285, x1 + 0.025) yspan=(nb + WN2 + 0.11, pt - 0.175 - WP2 - 0.085) net=B1_N
  l11 = rect li xspan=(x3 + L + 0.03, x4 - 0.055) yspan=(nb + 0.02, pt - 0.175 - WP2 + 0.225) net=Y
  l12 = rect li xspan=(x3 + L + 0.03, x4 - 0.05) yspan=(nb + 0.02, nb + WN - 0.1) net=Y
  l13 = rect li xspan=(x3 + L + 0.03, x8 + 0.025) yspan=(nb + WN2 - 0.04, nb + WN - 0.1) net=Y
  l14 = rect li xspan=(x7 + L - 0.025, x8 + 0.025) yspan=(nb + 0.02, nb + WN - 0.1) net=Y
  l15 = rect li xspan=(x1 - 0.14, x2 + L + 0.045) yspan=(nb + 0.125, nb + WN2 - 0.125) net=n2
  l16 = rect li xspan=(x2 - 0.015, x2 + L + 0.045) yspan=(nb + 0.125, pt - 0.175 - 0.045) net=n2
  l17 = rect li xspan=(x2 - 0.015, x3 - 0.025) yspan=(nb + WN + 0.185, pt - WP - 0.2) net=n2
  l18 = rect li xspan=(x2 - 0.015, x2 + L + 0.105) yspan=(nb + WN + 0.185, pt - 0.175 - 0.045) net=n2
  l19 = rect li xspan=(x2 + L + 0.295, x3 + 0.005) yspan=(pt - 0.175 - WP2 - 0.095, pt - 0.02) net=n3
  l20 = rect li xspan=(x2 + L + 0.295, x5 + 0.03) yspan=(pt - 0.175 - 0.025, pt - 0.02) net=n3
  l21 = rect li xspan=(x4 + L - 0.03, x9 + L + 0.31) yspan=(pt - 0.175 - WP2 - 0.035, pt - 0.175 - WP2 + 0.135) net=n3
  l22 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - 0.175 - WP2 - 0.035, pt - 0.02) net=n3
  l23 = rect li xspan=(x7 + L + 0.06, x8 - 0.06) yspan=(pt - 0.175 - WP2 - 0.035, pt - 0.02) net=n3
  l24 = rect li xspan=(x7 + L + 0.06, x9 + L + 0.31) yspan=(pt - 0.175 - WP2 - 0.035, pt - 0.175 - WP2 + 0.215) net=n3
  l25 = rect li xspan=(x9 + L + 0.05, x9 + L + 0.31) yspan=(pt - 0.175 - WP2 - 0.035, pt - 0.02) net=n3
  l26 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - 0.175 - WP2 + 0.19, H + 0.085) net=VPWR
  l27 = rect li xspan=(x6 + L - 0.01, x7 - 0.055) yspan=(pt - 0.175 - 0.115, H + 0.085) net=VPWR
  l28 = rect li xspan=(x8 + L - 0.025, x9 + 0.025) yspan=(pt - 0.175 - 0.035, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x5 - 0.085) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x7 + L + 0.145) span=(nb + 0.02, nb + WN - 0.1) margin=0.04 net=Y
  c3 = array licon in=nd2 cx=(x9 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x3 - 0.245) span=(-0.085 + 0.08, nb + WN - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.175 - WP2 + 0.225 - 0.08) margin=0.04 net=Y
  c6 = array licon in=nd1 cx=(x1 + 0.03) span=(nb + 0.125, nb + WN2 - 0.125) net=n2
  c7 = array licon in=pd2 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.175 - WP2 + 0.225 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd2 cx=(x7 + L + 0.145) span=(pt - 0.175 - WP2 - 0.035 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c9 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - 0.175 - WP2 - 0.095 + 0.08, pt - 0.02 - 0.08) net=n3
  c10 = array licon in=pd2 cx=(x9 + L + 0.145) span=(pt - 0.175 - WP2 - 0.035 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c11 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.175 - WP2 - 0.035, pt - 0.02) margin=0.04 net=n3
  c12 = array licon in=pd1 cx=(x2 + L - 0.065) span=(nb + 0.125 + 0.08, pt - 0.175 - 0.045 - 0.08) net=n2
  c13 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - 0.175 - WP2 + 0.19, H + 0.085) net=VPWR
  c14 = array licon in=pd2 cx=(x6 + L + 0.08) span=(pt - 0.175 - 0.115 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x8 + L + 0.145) span=(pt - 0.175 - 0.035, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.065) cy=(nb + WN + 0.045)
  gc2 = contact licon cx=(x3 - 0.19) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + 0.015) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x7 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + 0.045) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.02) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x1 - 0.065) cy=(pt - WP - 0.215)
  np1 = rect npc xspan=(x1 - 0.405, x1 + L - 0.025) yspan=(nb + WN2 + 0.09, pt - WP - 0.03)
  np2 = rect npc xspan=(x1 - 0.405, x9 + L + 0.53) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 + L - 0.065) cy=0
  mc3 = contact mcon cx=(x3 - 0.2) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.12) cy=0
  mc5 = contact mcon cx=(x5 - 0.12) cy=0
  mc6 = contact mcon cx=(x7 - 0.08) cy=0
  mc7 = contact mcon cx=(x8 - 0.05) cy=0
  mc8 = contact mcon cx=(x9 - 0.02) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.3) cy=0
  mc10 = contact mcon cx=(x1 - 0.175) cy=H
  mc11 = contact mcon cx=(x2 + L - 0.065) cy=H
  mc12 = contact mcon cx=(x3 - 0.2) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.12) cy=H
  mc14 = contact mcon cx=(x5 - 0.12) cy=H
  mc15 = contact mcon cx=(x7 - 0.08) cy=H
  mc16 = contact mcon cx=(x8 - 0.05) cy=H
  mc17 = contact mcon cx=(x9 - 0.02) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.3) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l7
  port B1_N in on=l10
  port Y out on=l11
end
