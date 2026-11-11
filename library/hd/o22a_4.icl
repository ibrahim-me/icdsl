# o22a_4: lifted from sky130_fd_sc_hd__o22a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o22a_4 width=17 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=n2 b=VPB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=n3 g=B1 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n4 g=B1 s=n1 b=VNB
  device M4 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M6 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=A2 s=n4 b=VNB
  device M8 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M11 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M12 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M13 nmos w=WN l=L d=VGND g=A1 s=n4 b=VNB
  device M14 pmos w=WP l=L d=n2 g=A2 s=n1 b=VPB
  device M15 nmos w=WN l=L d=n4 g=B2 s=n1 b=VNB
  device M16 nmos w=WN l=L d=n4 g=A1 s=VGND b=VNB
  device M17 pmos w=WP l=L d=VPWR g=B1 s=n3 b=VPB
  device M18 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M19 pmos w=WP l=L d=n1 g=B2 s=n3 b=VPB
  device M20 nmos w=WN l=L d=n1 g=B2 s=n4 b=VNB
  device M21 pmos w=WP l=L d=n3 g=B2 s=n1 b=VPB
  device M22 nmos w=WN l=L d=n1 g=B1 s=n4 b=VNB
  device M23 nmos w=WN l=L d=X g=n1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.485
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.36
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x12 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x12 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5 - 0.065, x5 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8 - 0.065, x8 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9 - 0.065, x9 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x10, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x12 - 0.065, x12 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p19 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x5 - 0.305, x9 + 0.03) yspan=(nb + 0.02, nb + 0.24) net=n4
  l7 = rect li xspan=(x8 + L + 0.055, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l8 = rect li xspan=(x8 + L + 0.055, x12 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n4
  l9 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l10 = rect li xspan=(x10 + L - 0.03, x12 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n4
  l11 = rect li xspan=(x12 + L - 0.03, x12 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l12 = rect li xspan=(x6 + 0.025, x7 + L + 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l13 = rect li xspan=(x10 + 0.04, x11 + L - 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l14 = rect li xspan=(x5 - 0.265, x5 + L + 0.13) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l15 = rect li xspan=(x5 - 0.265, x8 + L + 0.095) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B1
  l16 = rect li xspan=(x8 - 0.095, x8 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l17 = rect li xspan=(x9 - 0.095, x9 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l18 = rect li xspan=(x9 - 0.095, x12 + 0.035) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A1
  l19 = rect li xspan=(x11 + L + 0.14, x12 + L + 0.51) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l20 = rect li xspan=(x11 + L + 0.14, x12 + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l21 = rect li xspan=(x1 + 0.06, x4 + L + 0.345) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=n1
  l22 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.345) yspan=(nb + WN + 0.19, pt - WP + 0.47) net=n1
  l23 = rect li xspan=(x4 + L + 0.015, x11 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n1
  l24 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.345) yspan=(nb + WN - 0.15, pt - WP + 0.47) net=n1
  l25 = rect li xspan=(x4 + L + 0.055, x8 + 0.03) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l26 = rect li xspan=(x5 - 0.27, x8 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n1
  l27 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=n1
  l28 = rect li xspan=(x10 + L + 0.015, x11 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=n1
  l29 = rect li xspan=(x1 - 0.4, x4 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l30 = rect li xspan=(x1 - 0.4, x1 - 0.115) yspan=(nb + WN - 0.16, pt - WP + 0.13) net=X
  l31 = rect li xspan=(x1 - 0.4, x4 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=X
  l32 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.03, nb + WN + 0.02) net=X
  l33 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l34 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l35 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l36 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n3
  l37 = rect li xspan=(x5 + L + 0.015, x8 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n3
  l38 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n3
  l39 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n2
  l40 = rect li xspan=(x9 + L + 0.015, x12 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n2
  l41 = rect li xspan=(x11 + L + 0.015, x12 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l42 = rect li xspan=(x1 - 0.265, x1 - 0.015) yspan=(pt - 0.66, H + 0.085) net=VPWR
  l43 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l44 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l45 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l46 = rect li xspan=(x12 + L + 0.06, x12 + L + 0.265) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.03, nb + WN + 0.02) margin=0.04 net=X
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c6 = array licon in=nd2 cx=(x5 - 0.14) span=(nb + 0.02, nb + 0.24) net=n4
  c7 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02, nb + 0.24) margin=0.04 net=n4
  c8 = array licon in=nd2 cx=(x9 - 0.175) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c9 = array licon in=nd2 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n4
  c11 = array licon in=nd2 cx=(x11 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n4
  c13 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n1
  c14 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c16 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c17 = array licon in=pd1 cx=(x12 + L + 0.145) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c18 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n1
  c19 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n1
  c20 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c21 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.66 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x5 - 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c26 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c27 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  gc1 = contact licon cx=(x1 + L + 0.08) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.065) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L/2) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x6 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 + L/2) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x9 + L/2) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L + 0.14) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x12 + L/2) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.485, x12 + L + 0.595) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.255) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.065) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.105) cy=0
  mc4 = contact mcon cx=(x4 - 0.135) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.185) cy=0
  mc6 = contact mcon cx=(x5 - 0.155) cy=0
  mc7 = contact mcon cx=(x6 - 0.115) cy=0
  mc8 = contact mcon cx=(x7 - 0.075) cy=0
  mc9 = contact mcon cx=(x8 - 0.035) cy=0
  mc10 = contact mcon cx=(x9 - 0.075) cy=0
  mc11 = contact mcon cx=(x10 - 0.035) cy=0
  mc12 = contact mcon cx=(x11 + 0.01) cy=0
  mc13 = contact mcon cx=(x12 + 0.05) cy=0
  mc14 = contact mcon cx=(x12 + L + 0.365) cy=0
  mc15 = contact mcon cx=(x1 - 0.255) cy=H
  mc16 = contact mcon cx=(x1 + L + 0.065) cy=H
  mc17 = contact mcon cx=(x2 + L + 0.105) cy=H
  mc18 = contact mcon cx=(x4 - 0.135) cy=H
  mc19 = contact mcon cx=(x4 + L + 0.185) cy=H
  mc20 = contact mcon cx=(x5 - 0.155) cy=H
  mc21 = contact mcon cx=(x6 - 0.115) cy=H
  mc22 = contact mcon cx=(x7 - 0.075) cy=H
  mc23 = contact mcon cx=(x8 - 0.035) cy=H
  mc24 = contact mcon cx=(x9 - 0.075) cy=H
  mc25 = contact mcon cx=(x10 - 0.035) cy=H
  mc26 = contact mcon cx=(x11 + 0.01) cy=H
  mc27 = contact mcon cx=(x12 + 0.05) cy=H
  mc28 = contact mcon cx=(x12 + L + 0.365) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l19
  port A2 in on=l13
  port B1 in on=l14
  port B2 in on=l12
  port X out on=l30
end
