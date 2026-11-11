# o221ai_2: lifted from sky130_fd_sc_hd__o221ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o221ai_2 width=15 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 nmos w=WN l=L d=n2 g=B2 s=n3 b=VNB
  device M2 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M4 pmos w=WP l=L d=Y g=A2 s=n1 b=VPB
  device M5 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M6 pmos w=WP l=L d=n4 g=B2 s=Y b=VPB
  device M7 nmos w=WN l=L d=Y g=C1 s=n3 b=VNB
  device M8 nmos w=WN l=L d=n3 g=B2 s=n2 b=VNB
  device M9 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M10 pmos w=WP l=L d=n4 g=B1 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M12 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M13 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M14 pmos w=WP l=L d=Y g=B2 s=n4 b=VPB
  device M15 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M16 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M17 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M18 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M19 pmos w=WP l=L d=Y g=C1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.36
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.3, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6 - 0.065, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7 - 0.065, x7 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x10 - 0.065, x10 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l2 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x1 - 0.305, x2 + L + 0.305) yspan=(nb + 0.02, nb + 0.24) net=n3
  l4 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.01) net=n3
  l5 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x2 + L + 0.055, x6 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n3
  l7 = rect li xspan=(x3 - 0.305, x7 + 0.03) yspan=(nb + 0.02, nb + 0.24) net=n2
  l8 = rect li xspan=(x6 + L + 0.055, x7 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l9 = rect li xspan=(x6 + L + 0.055, x10 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l10 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l11 = rect li xspan=(x8 + L - 0.03, x10 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n2
  l12 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l13 = rect li xspan=(x1 - 0.32, x1 + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C1
  l14 = rect li xspan=(x4 + 0.025, x5 + L + 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l15 = rect li xspan=(x8 + 0.04, x9 + L - 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l16 = rect li xspan=(x2 + L + 0.055, x3 + L + 0.13) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l17 = rect li xspan=(x2 + L + 0.055, x6 + L + 0.095) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B1
  l18 = rect li xspan=(x6 - 0.095, x6 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l19 = rect li xspan=(x7 - 0.095, x7 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l20 = rect li xspan=(x7 - 0.095, x10 + 0.035) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A1
  l21 = rect li xspan=(x9 + L + 0.14, x10 + L + 0.51) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l22 = rect li xspan=(x9 + L + 0.14, x10 + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A1
  l23 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.41, nb + WN - 0.02) net=Y
  l24 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l25 = rect li xspan=(x1 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=Y
  l26 = rect li xspan=(x1 + L + 0.06, x2 + 0.03) yspan=(nb + 0.41, pt - WP + 0.47) net=Y
  l27 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=Y
  l28 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=Y
  l29 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP + 0.64, pt - 0.02) net=n4
  l30 = rect li xspan=(x3 + L + 0.015, x6 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n4
  l31 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n4
  l32 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP + 0.64, pt - 0.02) net=n1
  l33 = rect li xspan=(x7 + L + 0.015, x10 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n1
  l34 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n1
  l35 = rect li xspan=(x1 - 0.265, x1 - 0.015) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  l36 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l37 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l38 = rect li xspan=(x10 + L + 0.06, x10 + L + 0.265) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.01 - 0.08) net=n3
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c3 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02, nb + 0.24) net=n2
  c4 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.24) margin=0.04 net=n2
  c5 = array licon in=nd2 cx=(x7 - 0.175) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n2
  c6 = array licon in=nd2 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c8 = array licon in=nd2 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n2
  c10 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.41, nb + WN - 0.02) margin=0.04 net=Y
  c11 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n3
  c12 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n3
  c13 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x10 + L + 0.145) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c17 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c19 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x3 - 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.64 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c22 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c23 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.64 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 - 0.135) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L/2) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + L/2) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x10 + L + 0.595) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 - 0.135) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.185) cy=0
  mc4 = contact mcon cx=(x3 - 0.155) cy=0
  mc5 = contact mcon cx=(x4 - 0.115) cy=0
  mc6 = contact mcon cx=(x5 - 0.075) cy=0
  mc7 = contact mcon cx=(x6 - 0.035) cy=0
  mc8 = contact mcon cx=(x7 - 0.075) cy=0
  mc9 = contact mcon cx=(x8 - 0.035) cy=0
  mc10 = contact mcon cx=(x9 + 0.01) cy=0
  mc11 = contact mcon cx=(x10 + 0.05) cy=0
  mc12 = contact mcon cx=(x10 + L + 0.365) cy=0
  mc13 = contact mcon cx=(x1 - 0.175) cy=H
  mc14 = contact mcon cx=(x2 - 0.135) cy=H
  mc15 = contact mcon cx=(x2 + L + 0.185) cy=H
  mc16 = contact mcon cx=(x3 - 0.155) cy=H
  mc17 = contact mcon cx=(x4 - 0.115) cy=H
  mc18 = contact mcon cx=(x5 - 0.075) cy=H
  mc19 = contact mcon cx=(x6 - 0.035) cy=H
  mc20 = contact mcon cx=(x7 - 0.075) cy=H
  mc21 = contact mcon cx=(x8 - 0.035) cy=H
  mc22 = contact mcon cx=(x9 + 0.01) cy=H
  mc23 = contact mcon cx=(x10 + 0.05) cy=H
  mc24 = contact mcon cx=(x10 + L + 0.365) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l21
  port A2 in on=l15
  port B1 in on=l16
  port B2 in on=l14
  port C1 in on=l13
  port Y out on=l25
end
