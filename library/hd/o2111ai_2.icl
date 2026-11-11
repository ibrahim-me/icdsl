# o2111ai_2: lifted from sky130_fd_sc_hd__o2111ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2111ai_2 width=15 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M4 pmos w=WP l=L d=VPWR g=D1 s=Y b=VPB
  device M5 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n4 g=D1 s=Y b=VNB
  device M7 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M9 pmos w=WP l=L d=Y g=D1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M11 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M12 pmos w=WP l=L d=Y g=C1 s=VPWR b=VPB
  device M13 nmos w=WN l=L d=Y g=D1 s=n4 b=VNB
  device M14 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M15 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M16 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M17 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M18 nmos w=WN l=L d=n4 g=C1 s=n3 b=VNB
  device M19 nmos w=WN l=L d=n3 g=C1 s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.485
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.29
  x7 = x6 + 0.125
  x8 = x7 + L + 0.29
  x9 = x8 + L + 0.29
  x10 = x9 + L + 0.29
  x11 = x10 + L + 0.29
  x12 = x11 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.35, x5 + 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 + L + 0.14, x12 + L + 0.335) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x7 + L + 0.145) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x8 + L - 0.015, x12 + L + 0.335) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.36, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.19)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x11, x12 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x9 + L - 0.025, x10 + 0.025) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x11 + L - 0.025, x12 + 0.025) yspan=(-0.085, nb + 0.245) net=VGND
  l3 = rect li xspan=(x3 + L - 0.02, x8 + 0.025) yspan=(nb + 0.02, nb + WN - 0.44) net=n3
  l4 = rect li xspan=(x3 + L - 0.02, x4 - 0.015) yspan=(nb + 0.02, nb + WN - 0.32) net=n3
  l5 = rect li xspan=(x3 + L - 0.02, x4 + 0.005) yspan=(nb + 0.02, nb + WN - 0.355) net=n3
  l6 = rect li xspan=(x7 + L - 0.025, x8 + 0.025) yspan=(nb + 0.02, nb + WN - 0.4) net=n3
  l7 = rect li xspan=(x5 + L + 0.105, x12 + L + 0.385) yspan=(nb + WN - 0.23, nb + WN - 0.045) net=n2
  l8 = rect li xspan=(x8 + L + 0.05, x9 - 0.05) yspan=(nb + 0.13, nb + WN - 0.045) net=n2
  l9 = rect li xspan=(x10 + L + 0.05, x11 - 0.05) yspan=(nb + 0.13, nb + WN - 0.045) net=n2
  l10 = rect li xspan=(x10 + L + 0.05, x12 + L + 0.385) yspan=(nb + WN - 0.235, nb + WN - 0.045) net=n2
  l11 = rect li xspan=(x12 + L + 0.05, x12 + L + 0.385) yspan=(nb + 0.13, nb + WN - 0.045) net=n2
  l12 = rect li xspan=(x1 - 0.31, x3 - 0.045) yspan=(nb + 0.025, nb + 0.21) net=n4
  l13 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(nb + 0.025, nb + WN - 0.02) net=n4
  l14 = rect li xspan=(x2 + L + 0.06, x3 - 0.045) yspan=(nb + 0.025, nb + WN + 0.02) net=n4
  l15 = rect li xspan=(x2 + L + 0.06, x5 + L/2) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n4
  l16 = rect li xspan=(x4 + L + 0.01, x5 + L/2) yspan=(nb + WN - 0.265, nb + WN + 0.02) net=n4
  l17 = rect li xspan=(x2 + L - 0.015, x4 + 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=C1
  l18 = rect li xspan=(x5, x8) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B1
  l19 = rect li xspan=(x8 + L + 0.035, x11 - 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A2
  l20 = rect li xspan=(x11 + L + 0.015, x12 + L + 0.385) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A1
  l21 = rect li xspan=(x1 - 0.4, x1 - 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.13) net=D1
  l22 = rect li xspan=(x1 + L - 0.025, x2 - 0.05) yspan=(nb + 0.38, pt - 0.02) net=Y
  l23 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(nb + 0.38, nb + WN + 0.02) net=Y
  l24 = rect li xspan=(x1 + L - 0.025, x10 - 0.045) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l25 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l26 = rect li xspan=(x5 + L + 0.05, x6 - 0.06) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l27 = rect li xspan=(x9 + L + 0.055, x10 - 0.045) yspan=(pt - WP + 0.01, pt - WP + 0.62) net=Y
  l28 = rect li xspan=(x8 + L - 0.025, x9 - 0.05) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l29 = rect li xspan=(x8 + L - 0.025, x11 + 0.025) yspan=(pt - 0.21, pt - 0.02) net=n1
  l30 = rect li xspan=(x10 + L + 0.05, x11 + 0.025) yspan=(pt - WP + 0.03, pt - 0.02) net=n1
  l31 = rect li xspan=(x10 + L + 0.05, x12 + L + 0.31) yspan=(pt - WP + 0.03, pt - WP + 0.2) net=n1
  l32 = rect li xspan=(x12 + L + 0.05, x12 + L + 0.31) yspan=(pt - WP + 0.03, pt - 0.02) net=n1
  l33 = rect li xspan=(x1 - 0.31, x1 - 0.06) yspan=(pt - WP + 0.04, H + 0.085) net=VPWR
  l34 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l35 = rect li xspan=(x4 + L - 0.025, x5 + 0.025) yspan=(pt - 0.645, H + 0.085) net=VPWR
  l36 = rect li xspan=(x7, x8 - 0.105) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l37 = rect li xspan=(x11 + L + 0.05, x12 + 0.025) yspan=(pt - 0.63, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.025 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=n4
  c2 = array licon in=nd1 cx=(x4 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.32 - 0.08) margin=0.04 net=n3
  c3 = array licon in=nd2 cx=(x7 + L + 0.145) span=(nb + 0.02, nb + WN - 0.4) margin=0.04 net=n3
  c4 = array licon in=nd2 cx=(x9 + L + 0.145) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=nd2 cx=(x11 + L + 0.145) span=(-0.085, nb + 0.245) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.13 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=n2
  c7 = array licon in=nd2 cx=(x10 + L + 0.145) span=(nb + 0.13 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd2 cx=(x12 + L + 0.205) span=(nb + 0.13 + 0.08, nb + WN - 0.045 - 0.08) net=n2
  c9 = array licon in=nd1 cx=(x3 - 0.14) span=(nb + 0.025 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c10 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.38 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c11 = array licon in=nd1 cx=(x5 - 0.115) span=(nb + WN - 0.265, nb + WN + 0.02) net=n4
  c12 = array licon in=nd2 cx=(x6 - 0.02) span=(nb + WN - 0.23, nb + WN - 0.045) net=n2
  c13 = array licon in=pd2 cx=(x10 + L + 0.145) span=(pt - WP + 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c14 = array licon in=pd2 cx=(x12 + L + 0.145) span=(pt - WP + 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x1 + L + 0.145) span=(nb + 0.38 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c17 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c19 = array licon in=pd2 cx=(x9 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - WP + 0.62 - 0.08) margin=0.04 net=Y
  c20 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - 0.645, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x7 + L + 0.02) span=(pt - 0.65, H + 0.085) net=VPWR
  c23 = array licon in=pd2 cx=(x8 + L + 0.145) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c24 = array licon in=pd2 cx=(x11 + L + 0.145) span=(pt - 0.63 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.225) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.12) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 - 0.135) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x12 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.485, x12 + L + 0.47) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.255) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.065) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.095) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.125) cy=0
  mc5 = contact mcon cx=(x5 - 0.135) cy=0
  mc6 = contact mcon cx=(x6 - 0.105) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.09) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.12) cy=0
  mc9 = contact mcon cx=(x10 - 0.14) cy=0
  mc10 = contact mcon cx=(x11 - 0.11) cy=0
  mc11 = contact mcon cx=(x12 - 0.08) cy=0
  mc12 = contact mcon cx=(x12 + L + 0.24) cy=0
  mc13 = contact mcon cx=(x1 - 0.255) cy=H
  mc14 = contact mcon cx=(x1 + L + 0.065) cy=H
  mc15 = contact mcon cx=(x2 + L + 0.095) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.125) cy=H
  mc17 = contact mcon cx=(x5 - 0.135) cy=H
  mc18 = contact mcon cx=(x6 - 0.105) cy=H
  mc19 = contact mcon cx=(x7 + L + 0.09) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.12) cy=H
  mc21 = contact mcon cx=(x10 - 0.14) cy=H
  mc22 = contact mcon cx=(x11 - 0.11) cy=H
  mc23 = contact mcon cx=(x12 - 0.08) cy=H
  mc24 = contact mcon cx=(x12 + L + 0.24) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l20
  port A2 in on=l19
  port B1 in on=l18
  port C1 in on=l17
  port D1 in on=l21
  port Y out on=l22
end
