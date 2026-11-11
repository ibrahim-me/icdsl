# a211o_4: lifted from sky130_fd_sc_hd__a211o_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a211o_4 width=18 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=C1 s=n2 b=VPB
  device M1 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n2 g=C1 s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M5 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M7 nmos w=WN l=L d=n5 g=A1 s=n2 b=VNB
  device M8 nmos w=WN l=L d=VGND g=C1 s=n2 b=VNB
  device M9 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M10 nmos w=WN l=L d=VGND g=A2 s=n5 b=VNB
  device M11 pmos w=WP l=L d=n6 g=B1 s=n3 b=VPB
  device M12 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M13 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M14 pmos w=WP l=L d=n2 g=C1 s=n6 b=VPB
  device M15 nmos w=WN l=L d=VGND g=B1 s=n2 b=VNB
  device M16 nmos w=WN l=L d=n2 g=A1 s=n4 b=VNB
  device M17 pmos w=WP l=L d=n3 g=B1 s=n1 b=VPB
  device M18 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M19 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M20 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M21 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M22 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M23 nmos w=WN l=L d=n2 g=B1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.255
  x3 = x2 + 0.035
  x4 = x3 + L + 0.255
  x5 = x4 + 0.035
  x6 = x5 + L + 0.255
  x7 = x6 + 0.035
  x8 = x7 + L + 0.27
  x9 = x8 + L + 0.295
  x10 = x9 + 0.095
  x11 = x10 + L + 0.235
  x12 = x11 + 0.055
  x13 = x12 + L + 0.29
  x14 = x13 + L + 0.33
  x15 = x14 + 0.07
  x16 = x15 + L + 0.33
  x17 = x16 + 0.11
  x18 = x17 + L + 0.29
  x19 = x18 + L + 0.29
  x20 = x19 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 + L - 0.02, x20 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x8 + L + 0.125, x20 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x8 + L) yspan=(nb + WN + 0.135, pt - WP - 0.135)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.135)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.135)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.135)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.135)
  p10 = rect poly xspan=(x9 - 0.075, x10 + L + 0.02) yspan=(nb + WN + 0.135, pt - WP - 0.135)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.135)
  p12 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p13 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.13)
  p14 = rect poly xspan=(x11, x13 + L) yspan=(nb + WN + 0.105, pt - WP - 0.13)
  p15 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.105, H - 0.105)
  p16 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x14 - 0.115, x15 + L) yspan=(nb + WN + 0.1, pt - WP - 0.135)
  p18 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.1, H - 0.105)
  p19 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.135)
  p20 = rect poly xspan=(x16, x16 + L) yspan=(nb + WN + 0.135, H - 0.105)
  p21 = rect poly xspan=(x16, x17 + L + 0.075) yspan=(nb + WN + 0.135, pt - WP - 0.085)
  p22 = rect poly xspan=(x17, x17 + L) yspan=(0.105, pt - WP - 0.085)
  p23 = rect poly xspan=(x18, x18 + L) yspan=(0.105, H - 0.105)
  p24 = rect poly xspan=(x18, x19 + L) yspan=(nb + WN + 0.135, pt - WP - 0.135)
  p25 = rect poly xspan=(x19, x19 + L) yspan=(0.105, H - 0.105)
  p26 = rect poly xspan=(x20, x20 + L) yspan=(0.105, H - 0.105)
  p27 = rect poly xspan=(x20, x20 + L + 0.185) yspan=(nb + WN + 0.125, pt - WP - 0.135)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.06, x3 - 0.01) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x4 + L - 0.025, x7 - 0.01) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x8 + L - 0.025, x9 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x11 + L - 0.01, x13 - 0.02) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x15 + L + 0.02, x17 - 0.045) yspan=(-0.085, nb + 0.21) net=VGND
  l6 = rect li xspan=(x20 + L - 0.03, x20 + L + 0.305) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l7 = rect li xspan=(x11 - 0.03, x13 + L + 0.015) yspan=(nb + WN + 0.1, nb + WN + 0.39) net=C1
  l8 = rect li xspan=(x18, x19 - 0.09) yspan=(nb + WN + 0.135, pt - WP - 0.155) net=A1
  l9 = rect li xspan=(x9 + 0.01, x10 + L + 0.035) yspan=(nb + WN + 0.1, nb + WN + 0.44) net=B1
  l10 = rect li xspan=(x10, x10 + L + 0.035) yspan=(nb + WN + 0.1, pt - WP + 0.215) net=B1
  l11 = rect li xspan=(x10, x15 + L) yspan=(pt - WP - 0.04, pt - WP + 0.215) net=B1
  l12 = rect li xspan=(x14 - 0.115, x15 + L) yspan=(nb + WN + 0.1, pt - WP + 0.215) net=B1
  l13 = rect li xspan=(x16, x17 + L + 0.075) yspan=(nb + WN + 0.135, pt - WP + 0.215) net=A2
  l14 = rect li xspan=(x16, x20 - 0.055) yspan=(pt - WP + 0.025, pt - WP + 0.215) net=A2
  l15 = rect li xspan=(x19 + L + 0.025, x20 + L + 0.185) yspan=(nb + WN + 0.135, pt - WP - 0.165) net=A2
  l16 = rect li xspan=(x19 + L + 0.025, x20 - 0.055) yspan=(nb + WN + 0.135, pt - WP + 0.215) net=A2
  l17 = rect li xspan=(x1 + L - 0.02, x8 + L + 0.13) yspan=(nb + WN + 0.16, pt - WP - 0.16) net=n2
  l18 = rect li xspan=(x8 + L - 0.06, x8 + L + 0.13) yspan=(nb + WN + 0.16, pt - WP + 0.19) net=n2
  l19 = rect li xspan=(x8 + L - 0.05, x19 + 0.025) yspan=(nb + 0.38, nb + WN - 0.08) net=n2
  l20 = rect li xspan=(x8 + L - 0.05, x8 + L + 0.13) yspan=(nb + 0.38, pt - WP + 0.19) net=n2
  l21 = rect li xspan=(x8 + L + 0.04, x9 - 0.08) yspan=(pt - WP + 0.02, pt - WP + 0.555) net=n2
  l22 = rect li xspan=(x8 + L + 0.04, x13 + 0.025) yspan=(pt - WP + 0.385, pt - WP + 0.555) net=n2
  l23 = rect li xspan=(x9 + L + 0.045, x11 - 0.035) yspan=(nb + 0.02, nb + WN - 0.08) net=n2
  l24 = rect li xspan=(x13 + L + 0.01, x15 - 0.005) yspan=(nb + 0.02, nb + WN - 0.08) net=n2
  l25 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(nb + 0.04, nb + WN - 0.08) net=n2
  l26 = rect li xspan=(x1 - 0.315, x8 - 0.075) yspan=(nb + 0.4, nb + WN - 0.01) net=X
  l27 = rect li xspan=(x1 - 0.315, x1 - 0.06) yspan=(nb + 0.4, pt - WP + 0.22) net=X
  l28 = rect li xspan=(x1 - 0.315, x6 - 0.015) yspan=(pt - WP + 0.01, pt - WP + 0.22) net=X
  l29 = rect li xspan=(x1 + L + 0.055, x2 - 0.015) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l30 = rect li xspan=(x3 + L + 0.015, x4 - 0.05) yspan=(nb + 0.02, nb + WN - 0.01) net=X
  l31 = rect li xspan=(x3 + L + 0.015, x8 - 0.075) yspan=(nb + WN - 0.27, nb + WN - 0.01) net=X
  l32 = rect li xspan=(x5 + L + 0.05, x6 - 0.015) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l33 = rect li xspan=(x7 + L + 0.015, x8 - 0.075) yspan=(nb + 0.02, nb + WN - 0.01) net=X
  l34 = rect li xspan=(x8 + L + 0.08, x16 - 0.05) yspan=(pt - WP + 0.725, pt - 0.02) net=n3
  l35 = rect li xspan=(x14 + L + 0.015, x20 + L + 0.305) yspan=(pt - WP + 0.395, pt - 0.38) net=n3
  l36 = rect li xspan=(x14 + L + 0.015, x16 - 0.05) yspan=(pt - WP + 0.395, pt - 0.02) net=n3
  l37 = rect li xspan=(x18 + L - 0.025, x19 - 0.05) yspan=(pt - WP + 0.395, pt - 0.02) net=n3
  l38 = rect li xspan=(x20 + L - 0.03, x20 + L + 0.305) yspan=(pt - WP + 0.05, pt - 0.38) net=n3
  l39 = rect li xspan=(x20 + L + 0.05, x20 + L + 0.305) yspan=(pt - WP + 0.05, pt - 0.02) net=n3
  l40 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - 0.61, H + 0.085) net=VPWR
  l41 = rect li xspan=(x2 + L + 0.01, x5 + 0.025) yspan=(pt - 0.61, H + 0.085) net=VPWR
  l42 = rect li xspan=(x6 + L + 0.01, x8 - 0.04) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l43 = rect li xspan=(x17 + 0.015, x18 - 0.09) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l44 = rect li xspan=(x19 + L - 0.025, x20 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 + L + 0.11) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x9 - 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x12 + L + 0.105) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x16 - 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x18 + L + 0.145) span=(nb + 0.04, nb + WN - 0.08) margin=0.04 net=n2
  c6 = array licon in=nd1 cx=(x1 + L + 0.11) span=(-0.085, nb + 0.23) net=VGND
  c7 = array licon in=nd1 cx=(x14 - 0.125) span=(nb + 0.02, nb + WN - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd1 cx=(x20 + L + 0.14) span=(-0.085, nb + WN - 0.08) net=VGND
  c9 = array licon in=nd1 cx=(x3 + L + 0.11) span=(nb + 0.02 + 0.08, nb + WN - 0.01 - 0.08) margin=0.04 net=X
  c10 = array licon in=nd1 cx=(x7 + L + 0.11) span=(nb + 0.02 + 0.08, nb + WN - 0.01 - 0.08) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x10 + L + 0.05) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=n2
  c12 = array licon in=pd2 cx=(x20 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=n3
  c13 = array licon in=pd1 cx=(x2 - 0.11) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd1 cx=(x6 - 0.11) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c15 = array licon in=pd2 cx=(x12 + L + 0.145) span=(pt - WP + 0.385, pt - WP + 0.555) margin=0.04 net=n2
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.61, H + 0.085) net=VPWR
  c17 = array licon in=pd1 cx=(x4 - 0.11) span=(pt - 0.61, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd1 cx=(x8 - 0.13) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c19 = array licon in=pd2 cx=(x15 + L + 0.115) span=(pt - WP + 0.395, pt - 0.02) margin=0.04 net=n3
  c20 = array licon in=pd2 cx=(x18 + L + 0.145) span=(pt - WP + 0.395 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c21 = array licon in=pd2 cx=(x9 - 0.045) span=(pt - WP + 0.725, pt - 0.02) net=n3
  c22 = array licon in=pd2 cx=(x17 + L + 0.035) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd2 cx=(x19 + L + 0.145) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.11) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L - 0.04) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=x10 cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x11 + L - 0.01) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x13 - 0.01) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x15 - 0.015) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x16 + L + 0.015) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x18 + L + 0.02) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x20 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x20 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.105) cy=0
  mc3 = contact mcon cx=(x4 - 0.075) cy=0
  mc4 = contact mcon cx=(x6 - 0.045) cy=0
  mc5 = contact mcon cx=(x8 - 0.03) cy=0
  mc6 = contact mcon cx=x9 cy=0
  mc7 = contact mcon cx=(x11 - 0.015) cy=0
  mc8 = contact mcon cx=(x13 - 0.04) cy=0
  mc9 = contact mcon cx=(x14 - 0.05) cy=0
  mc10 = contact mcon cx=(x16 - 0.13) cy=0
  mc11 = contact mcon cx=(x17 + L + 0.08) cy=0
  mc12 = contact mcon cx=(x18 + L + 0.11) cy=0
  mc13 = contact mcon cx=(x19 + L + 0.14) cy=0
  mc14 = contact mcon cx=(x20 + L + 0.17) cy=0
  mc15 = contact mcon cx=(x1 - 0.17) cy=H
  mc16 = contact mcon cx=(x2 - 0.105) cy=H
  mc17 = contact mcon cx=(x4 - 0.075) cy=H
  mc18 = contact mcon cx=(x6 - 0.045) cy=H
  mc19 = contact mcon cx=(x8 - 0.03) cy=H
  mc20 = contact mcon cx=x9 cy=H
  mc21 = contact mcon cx=(x11 - 0.015) cy=H
  mc22 = contact mcon cx=(x13 - 0.04) cy=H
  mc23 = contact mcon cx=(x14 - 0.05) cy=H
  mc24 = contact mcon cx=(x16 - 0.13) cy=H
  mc25 = contact mcon cx=(x17 + L + 0.08) cy=H
  mc26 = contact mcon cx=(x18 + L + 0.11) cy=H
  mc27 = contact mcon cx=(x19 + L + 0.14) cy=H
  mc28 = contact mcon cx=(x20 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l14
  port B1 in on=l11
  port C1 in on=l7
  port X out on=l26
end
