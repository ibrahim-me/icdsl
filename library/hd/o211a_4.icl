# o211a_4: lifted from sky130_fd_sc_hd__o211a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o211a_4 width=18 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M1 nmos w=WN l=L d=n2 g=C1 s=n1 b=VNB
  device M2 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M3 pmos w=WP l=L d=n4 g=A2 s=n1 b=VPB
  device M4 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=n1 g=C1 s=n5 b=VNB
  device M6 nmos w=WN l=L d=n5 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M8 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB
  device M10 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M11 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M12 pmos w=WP l=L d=n1 g=B1 s=VPWR b=VPB
  device M13 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M14 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M15 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M16 pmos w=WP l=L d=VPWR g=C1 s=n1 b=VPB
  device M17 pmos w=WP l=L d=n1 g=C1 s=VPWR b=VPB
  device M18 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M19 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M20 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M21 pmos w=WP l=L d=n6 g=A1 s=VPWR b=VPB
  device M22 pmos w=WP l=L d=n1 g=A2 s=n6 b=VPB
  device M23 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.25
  x3 = x2 + 0.03
  x4 = x3 + L + 0.26
  x5 = x4 + 0.02
  x6 = x5 + L + 0.27
  x7 = x6 + 0.01
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.29
  x10 = x9 + 0.13
  x11 = x10 + L + 0.22
  x12 = x11 + L + 0.025
  x13 = x12 + L + 0.29
  x14 = x13 + L + 0.29
  x15 = x14 + 0.11
  x16 = x15 + L + 0.22
  x17 = x16 + 0.11
  x18 = x17 + L + 0.29
  x19 = x18 + L + 0.29
  x20 = x19 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + 0.025) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x9 - 0.14, x20 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 + L - 0.025, x20 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x9 - 0.02, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x9, x10) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(pt - WP - 0.16, H - 0.105)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x11, x13 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x14 - 0.075, x15 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p19 = rect poly xspan=(x14, x14 + L) yspan=(0.105, pt - WP - 0.16)
  p20 = rect poly xspan=(x15, x15 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p21 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.16)
  p22 = rect poly xspan=(x16, x17 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p23 = rect poly xspan=(x17, x17 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p24 = rect poly xspan=(x18, x18 + L) yspan=(0.105, H - 0.105)
  p25 = rect poly xspan=(x18, x19 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p26 = rect poly xspan=(x19, x19 + L) yspan=(0.105, H - 0.105)
  p27 = rect poly xspan=(x20, x20 + L) yspan=(0.105, H - 0.105)
  p28 = rect poly xspan=(x20, x20 + L + 0.255) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x2 + L, x5 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x6 + L - 0.02, x8 + 0.065) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x16 + L + 0.03, x18 - 0.05) yspan=(-0.085, nb + 0.29) net=VGND
  l5 = rect li xspan=(x19 + L + 0.05, x20 - 0.05) yspan=(-0.085, nb + 0.29) net=VGND
  l6 = rect li xspan=(x8 + L + 0.11, x16 + 0.01) yspan=(nb + 0.02, nb + 0.23) net=n3
  l7 = rect li xspan=(x14 + L, x16 + 0.01) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  l8 = rect li xspan=(x14 + L, x20 + L + 0.31) yspan=(nb + WN - 0.19, nb + WN - 0.02) net=n3
  l9 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  l10 = rect li xspan=(x20 + L - 0.025, x20 + L + 0.31) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  l11 = rect li xspan=(x11 + 0.06, x13 + L) yspan=(nb + WN + 0.15, pt - WP - 0.21) net=C1
  l12 = rect li xspan=(x18, x19 + L + 0.1) yspan=(nb + WN + 0.15, pt - WP - 0.16) net=A2
  l13 = rect li xspan=(x9 + 0.035, x10 + L + 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.2) net=B1
  l14 = rect li xspan=(x9 + 0.035, x15 + L) yspan=(pt - WP - 0.04, pt - WP + 0.2) net=B1
  l15 = rect li xspan=(x14 - 0.075, x15 + L) yspan=(nb + WN + 0.15, pt - WP + 0.2) net=B1
  l16 = rect li xspan=(x16, x17 + L + 0.1) yspan=(nb + WN + 0.15, pt - WP + 0.2) net=A1
  l17 = rect li xspan=(x16, x20 + L + 0.255) yspan=(pt - WP + 0.01, pt - WP + 0.2) net=A1
  l18 = rect li xspan=(x20, x20 + L + 0.255) yspan=(nb + WN + 0.15, pt - WP + 0.2) net=A1
  l19 = rect li xspan=(x1 - 0.315, x6 - 0.045) yspan=(nb + 0.4, nb + WN - 0.08) net=X
  l20 = rect li xspan=(x1 - 0.315, x1 - 0.035) yspan=(nb + 0.4, pt - WP + 0.215) net=X
  l21 = rect li xspan=(x1 - 0.315, x8 - 0.05) yspan=(pt - WP - 0.05, pt - WP + 0.215) net=X
  l22 = rect li xspan=(x1 + L + 0.055, x2 - 0.025) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l23 = rect li xspan=(x1 + L + 0.055, x6 - 0.045) yspan=(nb + WN - 0.27, nb + WN - 0.08) net=X
  l24 = rect li xspan=(x3 + L + 0.02, x4 - 0.06) yspan=(pt - WP - 0.05, pt - 0.02) net=X
  l25 = rect li xspan=(x5 + L + 0.055, x6 - 0.045) yspan=(nb + 0.02, nb + WN - 0.08) net=X
  l26 = rect li xspan=(x7 + L + 0.04, x8 - 0.05) yspan=(pt - WP - 0.05, pt - 0.02) net=X
  l27 = rect li xspan=(x1 + L - 0.01, x9 - 0.14) yspan=(nb + WN + 0.18, pt - WP - 0.22) net=n1
  l28 = rect li xspan=(x8 + L - 0.025, x13 - 0.075) yspan=(nb + 0.4, nb + WN - 0.07) net=n1
  l29 = rect li xspan=(x8 + L - 0.025, x9 - 0.14) yspan=(nb + 0.4, pt - 0.46) net=n1
  l30 = rect li xspan=(x8 + L - 0.025, x19 + 0.025) yspan=(pt - WP + 0.37, pt - 0.46) net=n1
  l31 = rect li xspan=(x9 + L + 0.045, x11 + 0.065) yspan=(pt - WP + 0.37, pt - 0.02) net=n1
  l32 = rect li xspan=(x13 + L + 0.05, x15 - 0.01) yspan=(pt - WP + 0.37, pt - 0.02) net=n1
  l33 = rect li xspan=(x18 + L - 0.025, x19 + 0.025) yspan=(pt - WP + 0.37, pt - 0.02) net=n1
  l34 = rect li xspan=(x1 + L - 0.065, x3 - 0.005) yspan=(pt - 0.615, H + 0.085) net=VPWR
  l35 = rect li xspan=(x4 + L - 0.025, x7 + 0.015) yspan=(pt - 0.615, H + 0.085) net=VPWR
  l36 = rect li xspan=(x8 + L - 0.025, x9 + 0.025) yspan=(pt - 0.285, H + 0.085) net=VPWR
  l37 = rect li xspan=(x12 + L - 0.025, x13 + 0.025) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l38 = rect li xspan=(x15 + L + 0.015, x17 - 0.045) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l39 = rect li xspan=(x20 + L - 0.025, x20 + L + 0.31) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x4 - 0.12) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x17 + L + 0.075) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x18 + L + 0.145) span=(nb + 0.02, nb + WN - 0.02) margin=0.04 net=n3
  c4 = array licon in=nd2 cx=(x19 + L + 0.145) span=(-0.085 + 0.08, nb + 0.29 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c6 = array licon in=nd1 cx=(x7 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x9 - 0.015) span=(nb + 0.02, nb + 0.23) net=n3
  c8 = array licon in=nd2 cx=(x20 + L + 0.145) span=(nb + 0.02, nb + WN - 0.02) net=n3
  c9 = array licon in=nd1 cx=(x2 - 0.11) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c10 = array licon in=nd1 cx=(x6 - 0.13) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c11 = array licon in=nd2 cx=(x15 + L + 0.06) span=(nb + 0.02, nb + WN - 0.02) margin=0.04 net=n3
  c12 = array licon in=nd2 cx=(x12 + L + 0.05) span=(nb + 0.4, nb + WN - 0.07) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x3 + L + 0.115) span=(pt - WP - 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd1 cx=(x7 + L + 0.135) span=(pt - WP - 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c15 = array licon in=pd1 cx=(x1 + L + 0.105) span=(pt - 0.615, H + 0.085) net=VPWR
  c16 = array licon in=pd1 cx=(x5 + L + 0.125) span=(pt - 0.615, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x20 + L + 0.145) span=(pt - 0.57, H + 0.085) net=VPWR
  c18 = array licon in=pd1 cx=(x18 + L + 0.145) span=(pt - WP + 0.37, pt - 0.02) margin=0.04 net=n1
  c19 = array licon in=pd1 cx=(x11 - 0.105) span=(pt - WP + 0.37, pt - 0.02) margin=0.04 net=n1
  c20 = array licon in=pd1 cx=(x14 - 0.075) span=(pt - WP + 0.37, pt - 0.02) margin=0.04 net=n1
  c21 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - 0.285, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x12 + L + 0.145) span=(pt - 0.29, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x16 - 0.075) span=(pt - 0.29 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.09) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.08) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.005) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + 0.065) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x10 - 0.01) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x12 + L/2) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x13 - 0.02) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x15 - 0.015) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x16 + L + 0.015) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x18 + L + 0.02) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x19 + L/2) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x20 + L + 0.05) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x20 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.1) cy=0
  mc3 = contact mcon cx=(x4 - 0.07) cy=0
  mc4 = contact mcon cx=(x6 - 0.04) cy=0
  mc5 = contact mcon cx=(x8 - 0.01) cy=0
  mc6 = contact mcon cx=(x9 + 0.025) cy=0
  mc7 = contact mcon cx=(x11 - 0.01) cy=0
  mc8 = contact mcon cx=(x12 + L + 0.145) cy=0
  mc9 = contact mcon cx=(x14 - 0.115) cy=0
  mc10 = contact mcon cx=(x15 + L + 0.095) cy=0
  mc11 = contact mcon cx=(x17 + L + 0.085) cy=0
  mc12 = contact mcon cx=(x18 + L + 0.115) cy=0
  mc13 = contact mcon cx=(x19 + L + 0.145) cy=0
  mc14 = contact mcon cx=(x20 + L + 0.175) cy=0
  mc15 = contact mcon cx=(x1 - 0.17) cy=H
  mc16 = contact mcon cx=(x2 - 0.1) cy=H
  mc17 = contact mcon cx=(x4 - 0.07) cy=H
  mc18 = contact mcon cx=(x6 - 0.04) cy=H
  mc19 = contact mcon cx=(x8 - 0.01) cy=H
  mc20 = contact mcon cx=(x9 + 0.025) cy=H
  mc21 = contact mcon cx=(x11 - 0.01) cy=H
  mc22 = contact mcon cx=(x12 + L + 0.145) cy=H
  mc23 = contact mcon cx=(x14 - 0.115) cy=H
  mc24 = contact mcon cx=(x15 + L + 0.095) cy=H
  mc25 = contact mcon cx=(x17 + L + 0.085) cy=H
  mc26 = contact mcon cx=(x18 + L + 0.115) cy=H
  mc27 = contact mcon cx=(x19 + L + 0.145) cy=H
  mc28 = contact mcon cx=(x20 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l17
  port A2 in on=l12
  port B1 in on=l14
  port C1 in on=l11
  port X out on=l20
end
