# o21bai_4: lifted from sky130_fd_sc_hd__o21bai_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21bai_4 width=19 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=Y b=VNB
  device M1 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n3 g=A2 s=Y b=VPB
  device M3 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=n2 s=n1 b=VNB
  device M8 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M9 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=n1 g=n2 s=Y b=VNB
  device M11 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=Y g=A2 s=n3 b=VPB
  device M13 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M14 pmos w=WP l=L d=Y g=A2 s=n3 b=VPB
  device M15 nmos w=WN l=L d=VGND g=B1_N s=n2 b=VNB
  device M16 pmos w=WP l=L d=n2 g=B1_N s=VPWR b=VPB
  device M17 pmos w=WP l=L d=VPWR g=n2 s=Y b=VPB
  device M18 nmos w=WN l=L d=Y g=n2 s=n1 b=VNB
  device M19 pmos w=WP l=L d=VPWR g=n2 s=Y b=VPB
  device M20 pmos w=WP l=L d=n3 g=A2 s=Y b=VPB
  device M21 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M22 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M23 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M24 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M25 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.45
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + 0.1
  x5 = x4 + L + 0.18
  x6 = x5 + 0.1
  x7 = x6 + L + 0.18
  x8 = x7 + 0.1
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  x14 = x13 + L + 0.28
  x15 = x14 + L + 0.28
  x16 = x15 + L + 0.28
  x17 = x16 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x2 - 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 + L + 0.115, x17 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x9 - 0.115) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 + L + 0.015, x17 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.24, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x10, x13 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x14, x17 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p19 = rect poly xspan=(x15, x15 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x16, x16 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x17, x17 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l2 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x12 + L + 0.055, x13 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x14 + L + 0.055, x15 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x16 + L + 0.055, x17 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x2 + L + 0.07, x10 + 0.03) yspan=(nb + 0.07, nb + 0.24) net=n1
  l7 = rect li xspan=(x9 + L + 0.055, x10 + 0.03) yspan=(nb + 0.07, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x9 + L + 0.055, x17 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l10 = rect li xspan=(x13 + L - 0.03, x14 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l11 = rect li xspan=(x15 + L - 0.03, x16 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l12 = rect li xspan=(x17 + L - 0.03, x17 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l13 = rect li xspan=(x10, x13 + L) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l14 = rect li xspan=(x1 - 0.365, x1 + L - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1_N
  l15 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.03, pt - 0.05) net=n2
  l16 = rect li xspan=(x1 - 0.305, x2 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n2
  l17 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.055, nb + WN + 0.01) net=n2
  l18 = rect li xspan=(x1 + L + 0.135, x2 + 0.03) yspan=(nb + 0.055, pt - WP + 0.14) net=n2
  l19 = rect li xspan=(x1 + L + 0.135, x7 + L) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=n2
  l20 = rect li xspan=(x14 - 0.105, x17 + L + 0.66) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l21 = rect li xspan=(x17 + L + 0.435, x17 + L + 0.66) yspan=(nb + WN + 0.19, pt - 0.03) net=A1
  l22 = rect li xspan=(x2 + L + 0.055, x13 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=Y
  l23 = rect li xspan=(x2 + L + 0.055, x3 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=Y
  l24 = rect li xspan=(x3 + L - 0.015, x9 + 0.03) yspan=(nb + 0.41, nb + WN - 0.07) net=Y
  l25 = rect li xspan=(x5 + L + 0.01, x7 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=Y
  l26 = rect li xspan=(x8 + L + 0.075, x9 + 0.03) yspan=(nb + 0.41, pt - WP + 0.14) net=Y
  l27 = rect li xspan=(x8 + L + 0.075, x9 + L + 0.105) yspan=(pt - WP - 0.41, pt - WP + 0.14) net=Y
  l28 = rect li xspan=(x8 + L + 0.075, x13 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.14) net=Y
  l29 = rect li xspan=(x10 + L + 0.015, x11 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=Y
  l30 = rect li xspan=(x12 + L + 0.015, x13 - 0.015) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=Y
  l31 = rect li xspan=(x9 + L - 0.02, x10 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l32 = rect li xspan=(x9 + L - 0.02, x14 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n3
  l33 = rect li xspan=(x11 + L + 0.015, x12 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l34 = rect li xspan=(x13 + L + 0.015, x17 + L + 0.265) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n3
  l35 = rect li xspan=(x13 + L + 0.015, x14 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n3
  l36 = rect li xspan=(x15 + L + 0.015, x16 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n3
  l37 = rect li xspan=(x17 + L + 0.015, x17 + L + 0.265) yspan=(pt - WP - 0.03, pt - 0.02) net=n3
  l38 = rect li xspan=(x1 + L + 0.055, x2 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l39 = rect li xspan=(x3 + L + 0.01, x5 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l40 = rect li xspan=(x7 + L + 0.01, x9 - 0.115) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l41 = rect li xspan=(x14 + L + 0.015, x15 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l42 = rect li xspan=(x16 + L + 0.015, x17 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.055, nb + WN + 0.01) net=n2
  c3 = array licon in=nd2 cx=(x3 - 0.04) span=(nb + 0.07, nb + 0.24) net=n1
  c4 = array licon in=nd2 cx=(x7 - 0.04) span=(nb + 0.07, nb + 0.24) margin=0.04 net=n1
  c5 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.07 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c6 = array licon in=nd2 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c8 = array licon in=nd2 cx=(x12 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x14 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c11 = array licon in=nd2 cx=(x15 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c12 = array licon in=nd2 cx=(x16 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c13 = array licon in=nd2 cx=(x17 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n1
  c14 = array licon in=nd2 cx=(x5 - 0.04) span=(nb + 0.41, nb + WN - 0.07) margin=0.04 net=Y
  c15 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.41, nb + WN - 0.07) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03, pt - 0.05) margin=0.04 net=n2
  c17 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x6 + L + 0.04) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c19 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c20 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c21 = array licon in=pd2 cx=(x13 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c22 = array licon in=pd2 cx=(x15 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c23 = array licon in=pd2 cx=(x17 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c24 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x4 + L + 0.04) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x8 + L + 0.04) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) net=VPWR
  c27 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n3
  c28 = array licon in=pd2 cx=(x11 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c29 = array licon in=pd2 cx=(x14 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c30 = array licon in=pd2 cx=(x16 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.06) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.005) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.08) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x10 + L + 0.02) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x11 + L - 0.065) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x12 + 0.005) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x13 - 0.08) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x14 + L - 0.015) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x15 + 0.055) cy=(nb + WN + 0.275)
  gc12 = contact licon cx=(x16 - 0.03) cy=(nb + WN + 0.275)
  gc13 = contact licon cx=(x17 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.45, x17 + L + 0.75) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.22) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.1) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.14) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.08) cy=0
  mc5 = contact mcon cx=(x7 - 0.06) cy=0
  mc6 = contact mcon cx=(x9 - 0.12) cy=0
  mc7 = contact mcon cx=(x10 - 0.08) cy=0
  mc8 = contact mcon cx=(x11 - 0.04) cy=0
  mc9 = contact mcon cx=(x12 + 0.005) cy=0
  mc10 = contact mcon cx=(x13 + 0.045) cy=0
  mc11 = contact mcon cx=(x14 + L - 0.065) cy=0
  mc12 = contact mcon cx=(x15 + L - 0.025) cy=0
  mc13 = contact mcon cx=(x16 + L + 0.02) cy=0
  mc14 = contact mcon cx=(x17 + L + 0.06) cy=0
  mc15 = contact mcon cx=(x17 + L + 0.52) cy=0
  mc16 = contact mcon cx=(x1 - 0.22) cy=H
  mc17 = contact mcon cx=(x1 + L + 0.1) cy=H
  mc18 = contact mcon cx=(x2 + L + 0.14) cy=H
  mc19 = contact mcon cx=(x4 + L + 0.08) cy=H
  mc20 = contact mcon cx=(x7 - 0.06) cy=H
  mc21 = contact mcon cx=(x9 - 0.12) cy=H
  mc22 = contact mcon cx=(x10 - 0.08) cy=H
  mc23 = contact mcon cx=(x11 - 0.04) cy=H
  mc24 = contact mcon cx=(x12 + 0.005) cy=H
  mc25 = contact mcon cx=(x13 + 0.045) cy=H
  mc26 = contact mcon cx=(x14 + L - 0.065) cy=H
  mc27 = contact mcon cx=(x15 + L - 0.025) cy=H
  mc28 = contact mcon cx=(x16 + L + 0.02) cy=H
  mc29 = contact mcon cx=(x17 + L + 0.06) cy=H
  mc30 = contact mcon cx=(x17 + L + 0.52) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l20
  port A2 in on=l13
  port B1_N in on=l14
  port Y out on=l22
end
