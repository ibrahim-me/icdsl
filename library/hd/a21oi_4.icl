# a21oi_4: lifted from sky130_fd_sc_hd__a21oi_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a21oi_4 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M4 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M5 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M7 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M8 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M9 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M10 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB
  device M11 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M12 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M13 nmos w=WN l=L d=n1 g=A1 s=Y b=VNB
  device M14 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M15 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M16 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M17 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M18 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  device M19 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M20 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M21 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M22 nmos w=WN l=L d=n1 g=A1 s=Y b=VNB
  device M23 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.32
  x6 = x5 + 0.01
  x7 = x6 + L + 0.29
  x8 = x7 + L + 0.29
  x9 = x8 + L + 0.29
  x10 = x9 + L + 0.29
  x11 = x10 + L + 0.29
  x12 = x11 + L + 0.29
  x13 = x12 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x13 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x13 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5 - 0.105, x6 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x10 + L) yspan=(nb + WN + 0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x13 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.315, x1 + 0.025) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l2 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x4 + L - 0.005, x5 - 0.04) yspan=(-0.085, nb + 0.29) net=VGND
  l4 = rect li xspan=(x11 + L + 0.05, x12 - 0.05) yspan=(-0.085, nb + 0.33) net=VGND
  l5 = rect li xspan=(x13 + L + 0.05, x13 + L + 0.31) yspan=(-0.085, nb + WN) net=VGND
  l6 = rect li xspan=(x5 + L - 0.015, x11 + 0.025) yspan=(nb + 0.02, nb + 0.27) net=n1
  l7 = rect li xspan=(x10 + L + 0.05, x11 + 0.025) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x10 + L + 0.05, x13 + 0.025) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x12 + L - 0.025, x13 + 0.025) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l10 = rect li xspan=(x7 - 0.03, x10 + L - 0.03) yspan=(pt - WP - 0.42, pt - WP - 0.175) net=A1
  l11 = rect li xspan=(x1 - 0.315, x1) yspan=(nb + WN + 0.11, pt - WP - 0.07) net=B1
  l12 = rect li xspan=(x1 - 0.315, x3 + L + 0.025) yspan=(nb + WN + 0.15, pt - WP - 0.07) net=B1
  l13 = rect li xspan=(x5 - 0.105, x6 + L + 0.09) yspan=(pt - WP - 0.42, pt - WP + 0.22) net=A2
  l14 = rect li xspan=(x5 - 0.105, x13 + L + 0.155) yspan=(pt - WP - 0.005, pt - WP + 0.22) net=A2
  l15 = rect li xspan=(x11 - 0.09, x13 + L + 0.155) yspan=(nb + WN + 0.19, pt - WP + 0.22) net=A2
  l16 = rect li xspan=(x1 + L + 0.035, x4 + 0.055) yspan=(pt - WP + 0.1, pt - WP + 0.55) net=Y
  l17 = rect li xspan=(x1 + L + 0.05, x2 - 0.05) yspan=(nb + 0.135, nb + 0.63) net=Y
  l18 = rect li xspan=(x1 + L + 0.05, x4 - 0.05) yspan=(nb + 0.38, nb + 0.63) net=Y
  l19 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(nb + 0.02, nb + 0.63) net=Y
  l20 = rect li xspan=(x4 - 0.095, x10 + 0.025) yspan=(nb + 0.46, nb + WN + 0.01) net=Y
  l21 = rect li xspan=(x4 - 0.095, x4 + L + 0.045) yspan=(nb + WN + 0.01, pt - WP + 0.22) net=Y
  l22 = rect li xspan=(x5 + L - 0.025, x10 + 0.025) yspan=(nb + WN - 0.21, nb + WN + 0.01) net=Y
  l23 = rect li xspan=(x1 - 0.225, x1 - 0.03) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l24 = rect li xspan=(x1 - 0.225, x5 - 0.04) yspan=(pt - WP + 0.73, pt - 0.02) net=n2
  l25 = rect li xspan=(x2 + L - 0.025, x5 - 0.04) yspan=(pt - WP + 0.72, pt - 0.02) net=n2
  l26 = rect li xspan=(x4 + L + 0.08, x13 + L + 0.31) yspan=(pt - WP + 0.39, pt - 0.38) net=n2
  l27 = rect li xspan=(x4 + L + 0.08, x5 - 0.04) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l28 = rect li xspan=(x7 + L + 0.05, x8 - 0.05) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l29 = rect li xspan=(x9 + L + 0.05, x10 - 0.05) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l30 = rect li xspan=(x11 + L + 0.05, x12 - 0.06) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l31 = rect li xspan=(x13 + L + 0.05, x13 + L + 0.31) yspan=(pt - WP + 0.39, pt - 0.02) net=n2
  l32 = rect li xspan=(x5 + L - 0.015, x7 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l33 = rect li xspan=(x8 + L - 0.025, x9 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l34 = rect li xspan=(x10 + L - 0.025, x11 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l35 = rect li xspan=(x12 + L - 0.025, x13 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x5 - 0.135) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x10 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085, nb + WN - 0.08) net=VGND
  c5 = array licon in=nd1 cx=(x13 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x12 + L + 0.145) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c7 = array licon in=nd1 cx=(x11 + L + 0.145) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x3 + L + 0.145) span=(nb + 0.02 + 0.08, nb + 0.63 - 0.08) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.02, nb + 0.27) margin=0.04 net=n1
  c10 = array licon in=nd1 cx=(x8 + L + 0.145) span=(nb + 0.02, nb + 0.27) margin=0.04 net=n1
  c11 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.135 + 0.08, nb + 0.63 - 0.08) margin=0.04 net=Y
  c12 = array licon in=nd1 cx=(x7 + L + 0.145) span=(nb + WN - 0.21, nb + WN + 0.01) margin=0.04 net=Y
  c13 = array licon in=nd1 cx=(x9 + L + 0.145) span=(nb + WN - 0.21, nb + WN + 0.01) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - WP + 0.1 + 0.08, pt - WP + 0.55 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.1, pt - WP + 0.55) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n2
  c17 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x9 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c19 = array licon in=pd1 cx=(x13 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) net=n2
  c20 = array licon in=pd1 cx=(x5 - 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c21 = array licon in=pd1 cx=(x11 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c22 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.72, pt - 0.02) margin=0.04 net=n2
  c23 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x10 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x12 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x1 + L + 0.04) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x2 + L - 0.055) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x3 + 0.005) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x6 + 0.055) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x7 + L + 0.06) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x8 + L - 0.035) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x9 + 0.025) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=(x10 - 0.07) cy=(pt - WP - 0.325)
  gc10 = contact licon cx=(x12 - 0.12) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x12 + L + 0.08) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x13 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x13 + L + 0.665) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x3 - 0.115) cy=0
  mc4 = contact mcon cx=(x4 - 0.085) cy=0
  mc5 = contact mcon cx=(x5 - 0.085) cy=0
  mc6 = contact mcon cx=(x7 - 0.065) cy=0
  mc7 = contact mcon cx=(x8 - 0.035) cy=0
  mc8 = contact mcon cx=x9 cy=0
  mc9 = contact mcon cx=(x10 + 0.03) cy=0
  mc10 = contact mcon cx=(x11 + 0.06) cy=0
  mc11 = contact mcon cx=(x12 + L - 0.06) cy=0
  mc12 = contact mcon cx=(x13 + L - 0.03) cy=0
  mc13 = contact mcon cx=(x13 + L + 0.435) cy=0
  mc14 = contact mcon cx=(x1 - 0.175) cy=H
  mc15 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc16 = contact mcon cx=(x3 - 0.115) cy=H
  mc17 = contact mcon cx=(x4 - 0.085) cy=H
  mc18 = contact mcon cx=(x5 - 0.085) cy=H
  mc19 = contact mcon cx=(x7 - 0.065) cy=H
  mc20 = contact mcon cx=(x8 - 0.035) cy=H
  mc21 = contact mcon cx=x9 cy=H
  mc22 = contact mcon cx=(x10 + 0.03) cy=H
  mc23 = contact mcon cx=(x11 + 0.06) cy=H
  mc24 = contact mcon cx=(x12 + L - 0.06) cy=H
  mc25 = contact mcon cx=(x13 + L - 0.03) cy=H
  mc26 = contact mcon cx=(x13 + L + 0.435) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l14
  port B1 in on=l12
  port Y out on=l16
end
