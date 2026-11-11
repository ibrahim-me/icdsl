# o21a_4: lifted from sky130_fd_sc_hd__o21a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21a_4 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=n2 b=VPB
  device M1 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M4 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n3 g=B1 s=n1 b=VNB
  device M8 nmos w=WN l=L d=n1 g=B1 s=n3 b=VNB
  device M9 pmos w=WP l=L d=n1 g=B1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M11 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB
  device M12 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M13 pmos w=WP l=L d=n4 g=A2 s=n1 b=VPB
  device M14 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M15 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M16 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M17 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M18 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M19 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.18
  x3 = x2 + 0.11
  x4 = x3 + L + 0.18
  x5 = x4 + 0.11
  x6 = x5 + L + 0.18
  x7 = x6 + 0.11
  x8 = x7 + L + 0.18
  x9 = x8 + L + 0.31
  x10 = x9 + L + 0.04
  x11 = x10 + L + 0.11
  x12 = x11 + L + 0.04
  x13 = x12 + L + 0.37
  x14 = x13 + 0.08
  x15 = x14 + L + 0.29
  x16 = x15 + L + 0.29
  x17 = x16 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x8 + L - 0.055) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x9 - 0.09, x17 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 + 0.055, x17 + L + 0.29) yspan=(pt - WP, pt)
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
  p10 = rect poly xspan=(x9, x12 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x13 - 0.15, x14 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.16)
  p17 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p18 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x15, x16 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p20 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  p22 = rect poly xspan=(x17, x17 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x3 + L - 0.025, x4 + L - 0.015) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x7 + L - 0.025, x8 + L - 0.015) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x14 + L - 0.035, x15 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x16 + L - 0.025, x17 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l6 = rect li xspan=(x9 - 0.13, x13 + 0.025) yspan=(nb + 0.02, nb + WN - 0.4) net=n3
  l7 = rect li xspan=(x12 + L + 0.06, x13 + 0.025) yspan=(nb + 0.02, nb + WN - 0.1) net=n3
  l8 = rect li xspan=(x12 + L + 0.06, x17 + L + 0.31) yspan=(nb + 0.38, nb + WN - 0.1) net=n3
  l9 = rect li xspan=(x15 + 0.05, x16 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l10 = rect li xspan=(x9 + 0.025, x12 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l11 = rect li xspan=(x13 - 0.105, x14 + L - 0.025) yspan=(nb + WN + 0.105, pt - WP + 0.22) net=A1
  l12 = rect li xspan=(x13 - 0.105, x17 + L + 0.305) yspan=(pt - WP + 0.01, pt - WP + 0.22) net=A1
  l13 = rect li xspan=(x17 + L - 0.07, x17 + L + 0.305) yspan=(nb + WN + 0.11, pt - WP + 0.22) net=A1
  l14 = rect li xspan=(x1 - 0.315, x6 + L - 0.015) yspan=(nb + 0.4, nb + WN - 0.08) net=X
  l15 = rect li xspan=(x1 - 0.315, x1 - 0.085) yspan=(nb + 0.4, pt - WP + 0.215) net=X
  l16 = rect li xspan=(x1 - 0.315, x8 - 0.06) yspan=(pt - WP + 0.045, pt - WP + 0.215) net=X
  l17 = rect li xspan=(x1 + L + 0.05, x6 + L - 0.015) yspan=(nb + 0.38, nb + WN - 0.08) net=X
  l18 = rect li xspan=(x2 + L + 0.045, x4 - 0.05) yspan=(pt - WP + 0.045, pt - 0.02) net=X
  l19 = rect li xspan=(x6 + L + 0.045, x8 - 0.06) yspan=(pt - WP + 0.045, pt - 0.02) net=X
  l20 = rect li xspan=(x1 + L - 0.06, x9 - 0.15) yspan=(pt - WP - 0.49, pt - WP - 0.15) net=n1
  l21 = rect li xspan=(x8 + L - 0.045, x12 + 0.025) yspan=(nb + WN - 0.23, nb + WN - 0.015) net=n1
  l22 = rect li xspan=(x8 + L - 0.045, x9 - 0.15) yspan=(nb + WN - 0.23, pt - WP - 0.15) net=n1
  l23 = rect li xspan=(x8 + L - 0.035, x9 - 0.15) yspan=(nb + WN - 0.23, pt - 0.4) net=n1
  l24 = rect li xspan=(x8 + L - 0.035, x11 - 0.05) yspan=(pt - WP + 0.345, pt - 0.4) net=n1
  l25 = rect li xspan=(x10 + 0.015, x11 - 0.05) yspan=(pt - WP + 0.345, pt - 0.02) net=n1
  l26 = rect li xspan=(x10 + 0.015, x16 + 0.025) yspan=(pt - WP + 0.39, pt - 0.38) net=n1
  l27 = rect li xspan=(x15 + L - 0.025, x16 + 0.025) yspan=(pt - WP + 0.39, pt - 0.04) net=n1
  l28 = rect li xspan=(x1 + 0.015, x2 + 0.025) yspan=(pt - 0.615, H + 0.085) net=VPWR
  l29 = rect li xspan=(x5 + 0.015, x6 + 0.025) yspan=(pt - 0.615, H + 0.085) net=VPWR
  l30 = rect li xspan=(x8 + L - 0.025, x9 + 0.025) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l31 = rect li xspan=(x11 + L - 0.025, x14 + 0.025) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l32 = rect li xspan=(x17 + L - 0.025, x17 + L + 0.34) yspan=(pt - 0.55, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x4 - 0.035) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x13 - 0.145) span=(nb + 0.02, nb + WN - 0.1) margin=0.04 net=n3
  c3 = array licon in=nd2 cx=(x14 + L + 0.135) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x16 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085, nb + 0.23) net=VGND
  c6 = array licon in=nd1 cx=(x8 - 0.035) span=(-0.085, nb + 0.23) net=VGND
  c7 = array licon in=nd2 cx=(x9 + 0.04) span=(nb + 0.02, nb + WN - 0.4) net=n3
  c8 = array licon in=nd2 cx=(x15 + L + 0.145) span=(nb + 0.38, nb + WN - 0.1) margin=0.04 net=n3
  c9 = array licon in=nd2 cx=(x17 + L + 0.145) span=(nb + 0.38, nb + WN - 0.1) net=n3
  c10 = array licon in=nd1 cx=(x6 - 0.035) span=(nb + 0.38, nb + WN - 0.08) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x2 - 0.035) span=(nb + 0.38 + 0.08, nb + WN - 0.08 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd2 cx=(x11 + 0.04) span=(nb + WN - 0.23, nb + WN - 0.015) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x3 + L + 0.035) span=(pt - WP + 0.045 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c14 = array licon in=pd1 cx=(x7 + L + 0.035) span=(pt - WP + 0.045 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c15 = array licon in=pd1 cx=(x1 + L + 0.035) span=(pt - 0.615, H + 0.085) net=VPWR
  c16 = array licon in=pd1 cx=(x5 + L + 0.035) span=(pt - 0.615, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x10 + L - 0.04) span=(pt - WP + 0.345 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c18 = array licon in=pd1 cx=(x15 + L + 0.145) span=(pt - WP + 0.39, pt - 0.04) margin=0.04 net=n1
  c19 = array licon in=pd1 cx=(x17 + L + 0.145) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x9 - 0.145) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x12 + L - 0.04) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x13 - 0.065) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.09) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L - 0.005) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 + L + 0.015) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x7 - 0.035) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x8 - 0.02) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x10 + 0.01) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x11 + L - 0.05) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x13 + 0.02) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x15 + L - 0.015) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x16 + L - 0.065) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x17 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x17 + L + 0.425) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 - 0.035) cy=0
  mc3 = contact mcon cx=x4 cy=0
  mc4 = contact mcon cx=(x6 + 0.03) cy=0
  mc5 = contact mcon cx=(x8 + 0.06) cy=0
  mc6 = contact mcon cx=(x9 + 0.07) cy=0
  mc7 = contact mcon cx=(x11 + L - 0.05) cy=0
  mc8 = contact mcon cx=(x13 - 0.135) cy=0
  mc9 = contact mcon cx=(x14 + L + 0.105) cy=0
  mc10 = contact mcon cx=(x15 + L + 0.135) cy=0
  mc11 = contact mcon cx=(x17 - 0.125) cy=0
  mc12 = contact mcon cx=(x17 + L + 0.195) cy=0
  mc13 = contact mcon cx=(x1 - 0.175) cy=H
  mc14 = contact mcon cx=(x2 - 0.035) cy=H
  mc15 = contact mcon cx=x4 cy=H
  mc16 = contact mcon cx=(x6 + 0.03) cy=H
  mc17 = contact mcon cx=(x8 + 0.06) cy=H
  mc18 = contact mcon cx=(x9 + 0.07) cy=H
  mc19 = contact mcon cx=(x11 + L - 0.05) cy=H
  mc20 = contact mcon cx=(x13 - 0.135) cy=H
  mc21 = contact mcon cx=(x14 + L + 0.105) cy=H
  mc22 = contact mcon cx=(x15 + L + 0.135) cy=H
  mc23 = contact mcon cx=(x17 - 0.125) cy=H
  mc24 = contact mcon cx=(x17 + L + 0.195) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l12
  port A2 in on=l9
  port B1 in on=l10
  port X out on=l15
end
