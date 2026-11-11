# o21ai_4: lifted from sky130_fd_sc_hd__o21ai_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21ai_4 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M2 nmos w=WN l=L d=Y g=B1 s=n2 b=VNB
  device M3 nmos w=WN l=L d=Y g=B1 s=n2 b=VNB
  device M4 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M5 nmos w=WN l=L d=n2 g=B1 s=Y b=VNB
  device M6 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M8 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M10 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M13 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M14 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M15 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M16 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M17 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M18 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M19 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M20 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M21 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M22 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M23 nmos w=WN l=L d=n2 g=B1 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.43
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.29
  x8 = x7 + L + 0.29
  x9 = x8 + 0.04
  x10 = x9 + L + 0.29
  x11 = x10 + L + 0.29
  x12 = x11 + L + 0.29
  x13 = x12 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x13 + L + 0.29) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x13 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.305, x3 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x8 - 0.075, x9 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x10, x13 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x5 + L - 0.025, x6 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x7 + L - 0.025, x9 - 0.015) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x1 - 0.31, x10 - 0.05) yspan=(nb + WN - 0.27, nb + WN - 0.065) net=n2
  l6 = rect li xspan=(x9 + L + 0.01, x13 + L + 0.31) yspan=(nb + 0.02, nb + 0.21) net=n2
  l7 = rect li xspan=(x9 + L + 0.01, x10 - 0.05) yspan=(nb + 0.02, nb + WN - 0.065) net=n2
  l8 = rect li xspan=(x10, x13 + 0.06) yspan=(nb + WN + 0.13, pt - WP - 0.21) net=B1
  l9 = rect li xspan=(x4 + L + 0.125, x7 + L + 0.125) yspan=(nb + WN + 0.185, pt - WP - 0.14) net=A2
  l10 = rect li xspan=(x1 - 0.305, x3 + L + 0.045) yspan=(nb + WN + 0.13, pt - WP - 0.165) net=A1
  l11 = rect li xspan=(x1 + L, x3 + L + 0.045) yspan=(nb + WN + 0.13, pt - WP + 0.2) net=A1
  l12 = rect li xspan=(x1 + L, x9 + L + 0.075) yspan=(pt - WP + 0.03, pt - WP + 0.2) net=A1
  l13 = rect li xspan=(x8 + 0.01, x9 + L + 0.075) yspan=(nb + WN + 0.105, pt - WP + 0.2) net=A1
  l14 = rect li xspan=(x1 + L, x4 - 0.05) yspan=(pt - WP + 0.43, pt - 0.4) net=n1
  l15 = rect li xspan=(x1 + L, x2 - 0.05) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l16 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l17 = rect li xspan=(x3 + L + 0.05, x9 - 0.015) yspan=(pt - 0.21, pt - 0.02) net=n1
  l18 = rect li xspan=(x4 + L - 0.025, x13 - 0.05) yspan=(pt - 0.63, pt - 0.46) net=Y
  l19 = rect li xspan=(x10 + 0.03, x13 + L + 0.495) yspan=(pt - WP - 0.04, pt - WP + 0.215) net=Y
  l20 = rect li xspan=(x10 + 0.03, x13 - 0.05) yspan=(pt - WP - 0.04, pt - 0.63) net=Y
  l21 = rect li xspan=(x10 + L - 0.025, x13 + L + 0.495) yspan=(nb + 0.38, nb + WN - 0.04) net=Y
  l22 = rect li xspan=(x10 + L + 0.03, x12 + L + 0.05) yspan=(pt - WP - 0.04, pt - WP + 0.6) net=Y
  l23 = rect li xspan=(x10 + L + 0.03, x11 - 0.05) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l24 = rect li xspan=(x12 + L + 0.05, x13 - 0.05) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l25 = rect li xspan=(x13 + L + 0.085, x13 + L + 0.495) yspan=(nb + 0.38, pt - WP + 0.215) net=Y
  l26 = rect li xspan=(x1 - 0.31, x1 - 0.025) yspan=(pt - WP + 0.335, H + 0.085) net=VPWR
  l27 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L + 0.01, x10 + 0.005) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l29 = rect li xspan=(x11 + L - 0.025, x12 + 0.025) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l30 = rect li xspan=(x13 + L - 0.025, x13 + L + 0.31) yspan=(pt - 0.605, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x5 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x7 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x11 + L + 0.145) span=(nb + 0.02, nb + 0.21) margin=0.04 net=n2
  c6 = array licon in=nd1 cx=(x13 + L + 0.145) span=(nb + 0.02, nb + 0.21) margin=0.04 net=n2
  c7 = array licon in=nd1 cx=(x9 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.065 - 0.08) margin=0.04 net=n2
  c8 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + WN - 0.27, nb + WN - 0.065) net=n2
  c9 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + WN - 0.27, nb + WN - 0.065) margin=0.04 net=n2
  c10 = array licon in=nd1 cx=(x4 + L + 0.145) span=(nb + WN - 0.27, nb + WN - 0.065) margin=0.04 net=n2
  c11 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + WN - 0.27, nb + WN - 0.065) margin=0.04 net=n2
  c12 = array licon in=nd1 cx=(x10 + L + 0.145) span=(nb + 0.38, nb + WN - 0.04) margin=0.04 net=Y
  c13 = array licon in=nd1 cx=(x12 + L + 0.145) span=(nb + 0.38, nb + WN - 0.04) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x10 + L + 0.145) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x12 + L + 0.145) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - 0.63, pt - 0.46) margin=0.04 net=Y
  c17 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - 0.63, pt - 0.46) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x13 + L + 0.145) span=(pt - 0.605, H + 0.085) net=VPWR
  c19 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.335 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - WP + 0.43 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c21 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.43 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c22 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x11 + L + 0.145) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - 0.21, pt - 0.02) margin=0.04 net=n1
  c25 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - 0.21, pt - 0.02) margin=0.04 net=n1
  c26 = array licon in=pd1 cx=(x9 + L + 0.125) span=(pt - 0.29 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x1 + L + 0.06) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x2 + L - 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + 0.025) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + 0.015) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 - 0.02) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x8 + L/2 + 0.02) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L + 0.02) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x11 + L/2) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x12 - 0.02) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x13 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.43, x13 + L + 0.64) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.2) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.12) cy=0
  mc3 = contact mcon cx=(x3 - 0.14) cy=0
  mc4 = contact mcon cx=(x4 - 0.11) cy=0
  mc5 = contact mcon cx=(x5 - 0.08) cy=0
  mc6 = contact mcon cx=(x6 - 0.05) cy=0
  mc7 = contact mcon cx=(x7 - 0.02) cy=0
  mc8 = contact mcon cx=(x8 + 0.015) cy=0
  mc9 = contact mcon cx=(x10 + 0.005) cy=0
  mc10 = contact mcon cx=(x11 + 0.035) cy=0
  mc11 = contact mcon cx=(x12 + 0.065) cy=0
  mc12 = contact mcon cx=(x13 + L - 0.055) cy=0
  mc13 = contact mcon cx=(x13 + L + 0.41) cy=0
  mc14 = contact mcon cx=(x1 - 0.2) cy=H
  mc15 = contact mcon cx=(x1 + L + 0.12) cy=H
  mc16 = contact mcon cx=(x3 - 0.14) cy=H
  mc17 = contact mcon cx=(x4 - 0.11) cy=H
  mc18 = contact mcon cx=(x5 - 0.08) cy=H
  mc19 = contact mcon cx=(x6 - 0.05) cy=H
  mc20 = contact mcon cx=(x7 - 0.02) cy=H
  mc21 = contact mcon cx=(x8 + 0.015) cy=H
  mc22 = contact mcon cx=(x10 + 0.005) cy=H
  mc23 = contact mcon cx=(x11 + 0.035) cy=H
  mc24 = contact mcon cx=(x12 + 0.065) cy=H
  mc25 = contact mcon cx=(x13 + L - 0.055) cy=H
  mc26 = contact mcon cx=(x13 + L + 0.41) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l11
  port A2 in on=l9
  port B1 in on=l8
  port Y out on=l25
end
