# a21boi_4: lifted from sky130_fd_sc_hd__a21boi_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a21boi_4 width=19 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=n2 s=Y b=VPB
  device M1 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M4 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M5 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M7 nmos w=WN l=L d=n3 g=A1 s=Y b=VNB
  device M8 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB
  device M9 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M10 pmos w=WP l=L d=n1 g=n2 s=Y b=VPB
  device M11 nmos w=WN l=L d=Y g=n2 s=VGND b=VNB
  device M12 pmos w=WP l=L d=Y g=n2 s=n1 b=VPB
  device M13 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M14 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M15 nmos w=WN l=L d=n3 g=A1 s=Y b=VNB
  device M16 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M17 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M18 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB
  device M19 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M20 pmos w=WP l=L d=n2 g=B1_N s=VPWR b=VPB
  device M21 nmos w=WN l=L d=Y g=n2 s=VGND b=VNB
  device M22 pmos w=WP l=L d=Y g=n2 s=n1 b=VPB
  device M23 nmos w=WN l=L d=n2 g=B1_N s=VGND b=VNB
  device M24 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M25 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.435
  x2 = x1 + 0.12
  x3 = x2 + L + 0.39
  x4 = x3 + L + 0.16
  x5 = x4 + 0.13
  x6 = x5 + L + 0.16
  x7 = x6 + 0.13
  x8 = x7 + L + 0.16
  x9 = x8 + 0.13
  x10 = x9 + L + 0.16
  x11 = x10 + L + 0.32
  x12 = x11 + 0.01
  x13 = x12 + L + 0.29
  x14 = x13 + L + 0.29
  x15 = x14 + L + 0.29
  x16 = x15 + L + 0.29
  x17 = x16 + L + 0.29
  x18 = x17 + L + 0.29
  x19 = x18 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.3, x19 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.15) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 + 0.035, x19 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x3, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x11 - 0.105, x12 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x13, x16 + L) yspan=(nb + WN + 0.105, pt - WP - 0.19)
  p17 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x17, x19 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p22 = rect poly xspan=(x18, x18 + L) yspan=(0.105, H - 0.105)
  p23 = rect poly xspan=(x19, x19 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.025, x3 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x5 + L - 0.025, x6 + L + 0.005) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x9 + L - 0.025, x11 - 0.05) yspan=(-0.085, nb + 0.29) net=VGND
  l4 = rect li xspan=(x17 + L + 0.05, x18 - 0.05) yspan=(-0.085, nb + 0.33) net=VGND
  l5 = rect li xspan=(x19 + L + 0.05, x19 + L + 0.31) yspan=(-0.085, nb + WN) net=VGND
  l6 = rect li xspan=(x11 + L - 0.015, x17 + 0.025) yspan=(nb + 0.02, nb + 0.27) net=n3
  l7 = rect li xspan=(x16 + L + 0.05, x17 + 0.025) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l8 = rect li xspan=(x16 + L + 0.05, x19 + 0.025) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n3
  l9 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l10 = rect li xspan=(x13 - 0.03, x16 + L - 0.04) yspan=(pt - WP - 0.42, pt - WP - 0.175) net=A1
  l11 = rect li xspan=(x1 - 0.29, x2 + L - 0.05) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1_N
  l12 = rect li xspan=(x1 + 0.05, x2 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B1_N
  l13 = rect li xspan=(x11 - 0.105, x12 + L + 0.09) yspan=(pt - WP - 0.42, pt - WP + 0.22) net=A2
  l14 = rect li xspan=(x11 - 0.105, x19 + L + 0.155) yspan=(pt - WP - 0.005, pt - WP + 0.22) net=A2
  l15 = rect li xspan=(x17 - 0.09, x19 + L + 0.155) yspan=(nb + WN + 0.19, pt - WP + 0.22) net=A2
  l16 = rect li xspan=(x3 + L + 0.05, x5 - 0.045) yspan=(nb + 0.135, nb + 0.63) net=Y
  l17 = rect li xspan=(x3 + L + 0.05, x9 - 0.045) yspan=(nb + 0.38, nb + 0.63) net=Y
  l18 = rect li xspan=(x3 + L + 0.05, x16 + 0.025) yspan=(nb + 0.46, nb + 0.63) net=Y
  l19 = rect li xspan=(x4 + L + 0.03, x10 + 0.055) yspan=(pt - WP + 0.1, pt - WP + 0.55) net=Y
  l20 = rect li xspan=(x7 + L + 0.05, x9 - 0.045) yspan=(nb + 0.02, nb + 0.63) net=Y
  l21 = rect li xspan=(x9 + L + 0.055, x16 + 0.025) yspan=(nb + 0.46, nb + WN + 0.01) net=Y
  l22 = rect li xspan=(x9 + L + 0.055, x10 + L + 0.045) yspan=(nb + WN + 0.01, pt - WP + 0.22) net=Y
  l23 = rect li xspan=(x11 + L - 0.025, x16 + 0.025) yspan=(nb + WN - 0.21, nb + WN + 0.01) net=Y
  l24 = rect li xspan=(x1 - 0.345, x1 + 0.015) yspan=(nb + 0.02, nb + WN - 0.09) net=n2
  l25 = rect li xspan=(x1 - 0.345, x3 + 0.025) yspan=(nb + WN - 0.27, nb + WN - 0.09) net=n2
  l26 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l27 = rect li xspan=(x1 - 0.31, x3 - 0.095) yspan=(pt - WP + 0.3, pt - WP + 0.52) net=n2
  l28 = rect li xspan=(x2 + L + 0.125, x3 - 0.095) yspan=(nb + WN - 0.27, pt - WP + 0.52) net=n2
  l29 = rect li xspan=(x2 + L + 0.125, x3 + 0.025) yspan=(nb + WN - 0.27, pt - WP - 0.14) net=n2
  l30 = rect li xspan=(x2 + L + 0.125, x8 + L + 0.01) yspan=(nb + WN + 0.15, pt - WP - 0.14) net=n2
  l31 = rect li xspan=(x3 + L - 0.07, x4 - 0.03) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l32 = rect li xspan=(x3 + L - 0.07, x11 - 0.04) yspan=(pt - WP + 0.73, pt - 0.02) net=n1
  l33 = rect li xspan=(x7 - 0.005, x11 - 0.04) yspan=(pt - WP + 0.72, pt - 0.02) net=n1
  l34 = rect li xspan=(x10 + L + 0.08, x19 + L + 0.31) yspan=(pt - WP + 0.39, pt - 0.38) net=n1
  l35 = rect li xspan=(x10 + L + 0.08, x11 - 0.04) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l36 = rect li xspan=(x15 + L + 0.05, x16 - 0.05) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l37 = rect li xspan=(x17 + L + 0.05, x18 - 0.06) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l38 = rect li xspan=(x19 + L + 0.05, x19 + L + 0.31) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l39 = rect li xspan=(x1 + L + 0.045, x2 + L + 0.19) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l40 = rect li xspan=(x11 + L - 0.015, x13 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l41 = rect li xspan=(x14 + L - 0.025, x15 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l42 = rect li xspan=(x16 + L - 0.025, x17 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l43 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.155) span=(nb + 0.02, nb + WN - 0.09) margin=0.04 net=n2
  c2 = array licon in=nd1 cx=(x3 - 0.185) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x6 - 0.015) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x10 - 0.015) span=(-0.085, nb + 0.29) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x11 - 0.135) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x16 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x19 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c8 = array licon in=nd1 cx=(x18 + L + 0.145) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c9 = array licon in=nd1 cx=(x17 + L + 0.145) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x8 - 0.015) span=(nb + 0.02 + 0.08, nb + 0.63 - 0.08) margin=0.04 net=Y
  c11 = array licon in=nd1 cx=(x12 + L + 0.145) span=(nb + 0.02, nb + 0.27) margin=0.04 net=n3
  c12 = array licon in=nd1 cx=(x14 + L + 0.145) span=(nb + 0.02, nb + 0.27) margin=0.04 net=n3
  c13 = array licon in=nd1 cx=(x4 - 0.015) span=(nb + 0.135 + 0.08, nb + 0.63 - 0.08) margin=0.04 net=Y
  c14 = array licon in=nd1 cx=(x13 + L + 0.145) span=(nb + WN - 0.21, nb + WN + 0.01) margin=0.04 net=Y
  c15 = array licon in=nd1 cx=(x15 + L + 0.145) span=(nb + WN - 0.21, nb + WN + 0.01) margin=0.04 net=Y
  c16 = array licon in=pd2 cx=(x5 + L + 0.015) span=(pt - WP + 0.1 + 0.08, pt - WP + 0.55 - 0.08) margin=0.04 net=Y
  c17 = array licon in=pd2 cx=(x9 + L + 0.015) span=(pt - WP + 0.1, pt - WP + 0.55) margin=0.04 net=Y
  c18 = array licon in=pd2 cx=(x3 + L + 0.02) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n1
  c19 = array licon in=pd2 cx=(x15 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c20 = array licon in=pd2 cx=(x19 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) net=n1
  c21 = array licon in=pd2 cx=(x13 + L + 0.145) span=(pt - WP + 0.39, pt - 0.38) margin=0.04 net=n1
  c22 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.3, pt - 0.02) net=n2
  c23 = array licon in=pd2 cx=(x11 - 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c24 = array licon in=pd2 cx=(x17 + L + 0.145) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c25 = array licon in=pd1 cx=(x2 + L + 0.025) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) net=VPWR
  c26 = array licon in=pd2 cx=(x7 + L + 0.015) span=(pt - WP + 0.72, pt - 0.02) margin=0.04 net=n1
  c27 = array licon in=pd2 cx=(x12 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c28 = array licon in=pd2 cx=(x14 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c29 = array licon in=pd2 cx=(x16 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c30 = array licon in=pd2 cx=(x18 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L/2 + 0.06) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 - 0.045) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.01) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x12 + 0.055) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x13 + L + 0.06) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x14 + L - 0.035) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=(x15 + 0.025) cy=(pt - WP - 0.325)
  gc10 = contact licon cx=(x16 - 0.07) cy=(pt - WP - 0.325)
  gc11 = contact licon cx=(x18 - 0.12) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x18 + L + 0.08) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x19 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.435, x19 + L + 0.605) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.205) cy=0
  mc2 = contact mcon cx=(x2 + L - 0.01) cy=0
  mc3 = contact mcon cx=(x3 + 0.07) cy=0
  mc4 = contact mcon cx=(x5 + L - 0.05) cy=0
  mc5 = contact mcon cx=(x7 + L - 0.02) cy=0
  mc6 = contact mcon cx=(x9 + L + 0.015) cy=0
  mc7 = contact mcon cx=(x11 - 0.145) cy=0
  mc8 = contact mcon cx=(x13 - 0.125) cy=0
  mc9 = contact mcon cx=(x14 - 0.095) cy=0
  mc10 = contact mcon cx=(x15 - 0.065) cy=0
  mc11 = contact mcon cx=(x16 - 0.035) cy=0
  mc12 = contact mcon cx=x17 cy=0
  mc13 = contact mcon cx=(x18 + 0.03) cy=0
  mc14 = contact mcon cx=(x19 + 0.06) cy=0
  mc15 = contact mcon cx=(x19 + L + 0.375) cy=0
  mc16 = contact mcon cx=(x1 - 0.205) cy=H
  mc17 = contact mcon cx=(x2 + L - 0.01) cy=H
  mc18 = contact mcon cx=(x3 + 0.07) cy=H
  mc19 = contact mcon cx=(x5 + L - 0.05) cy=H
  mc20 = contact mcon cx=(x7 + L - 0.02) cy=H
  mc21 = contact mcon cx=(x9 + L + 0.015) cy=H
  mc22 = contact mcon cx=(x11 - 0.145) cy=H
  mc23 = contact mcon cx=(x13 - 0.125) cy=H
  mc24 = contact mcon cx=(x14 - 0.095) cy=H
  mc25 = contact mcon cx=(x15 - 0.065) cy=H
  mc26 = contact mcon cx=(x16 - 0.035) cy=H
  mc27 = contact mcon cx=x17 cy=H
  mc28 = contact mcon cx=(x18 + 0.03) cy=H
  mc29 = contact mcon cx=(x19 + 0.06) cy=H
  mc30 = contact mcon cx=(x19 + L + 0.375) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l14
  port B1_N in on=l11
  port Y out on=l19
end
