# nand3b_4: lifted from sky130_fd_sc_hd__nand3b_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nand3b_4 width=20 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B s=n2 b=VNB
  device M1 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M2 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M3 nmos w=WN l=L d=n2 g=B s=n1 b=VNB
  device M4 nmos w=WN l=L d=n2 g=n3 s=Y b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n1 b=VNB
  device M6 pmos w=WP l=L d=Y g=n3 s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=C s=n1 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=Y b=VPB
  device M9 pmos w=WP l=L d=VPWR g=n3 s=Y b=VPB
  device M10 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M11 pmos w=WP l=L d=Y g=n3 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M13 nmos w=WN l=L d=n1 g=B s=n2 b=VNB
  device M14 nmos w=WN l=L d=n1 g=C s=VGND b=VNB
  device M15 nmos w=WN l=L d=Y g=n3 s=n2 b=VNB
  device M16 nmos w=WN l=L d=n1 g=C s=VGND b=VNB
  device M17 nmos w=WN l=L d=n2 g=n3 s=Y b=VNB
  device M18 nmos w=WN l=L d=VGND g=C s=n1 b=VNB
  device M19 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M20 nmos w=WN l=L d=n3 g=A_N s=VGND b=VNB
  device M21 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M22 pmos w=WP l=L d=n3 g=A_N s=VPWR b=VPB
  device M23 nmos w=WN l=L d=Y g=n3 s=n2 b=VNB
  device M24 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M25 pmos w=WP l=L d=Y g=C s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.8
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x10 - 0.265, x13 + L + 0.365) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x9 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x10 - 0.265, x13 + L + 0.365) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.22) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p3 = rect poly xspan=(x2 - 0.335, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x9 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x10 - 0.335, x13 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 - 0.305, x9 + L + 0.305) yspan=(nb + 0.02, nb + 0.23) net=n2
  l2 = rect li xspan=(x6 + L - 0.03, x9 + L + 0.305) yspan=(nb + WN - 0.25, nb + WN + 0.02) net=n1
  l3 = rect li xspan=(x6 + L - 0.03, x13 + 0.03) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n1
  l4 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.305) yspan=(-0.085, nb + 0.31) net=VGND
  l7 = rect li xspan=(x10 - 0.305, x10 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l8 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l9 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.385) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l10 = rect li xspan=(x1 + 0.035, x1 + L + 0.24) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A_N
  l11 = rect li xspan=(x6 + L + 0.11, x9 + L + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l12 = rect li xspan=(x9 + L + 0.37, x13 + 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l13 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=n3
  l14 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l15 = rect li xspan=(x1 - 0.315, x2 - 0.055) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n3
  l16 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n3
  l17 = rect li xspan=(x2 - 0.335, x2 - 0.055) yspan=(nb + WN - 0.17, pt - WP - 0.21) net=n3
  l18 = rect li xspan=(x2 - 0.335, x5 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=n3
  l19 = rect li xspan=(x2 + L - 0.03, x6 - 0.055) yspan=(nb + WN - 0.25, nb + WN + 0.02) net=Y
  l20 = rect li xspan=(x2 + L - 0.03, x13 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l21 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l22 = rect li xspan=(x4 + L - 0.03, x7 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.52) net=Y
  l23 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l24 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(nb + WN - 0.25, pt - WP + 0.52) net=Y
  l25 = rect li xspan=(x5 + L + 0.055, x6 + L - 0.065) yspan=(pt - WP - 0.41, pt - WP + 0.52) net=Y
  l26 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l27 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l28 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l29 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l30 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  l31 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l32 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l33 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l34 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l35 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l36 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.385) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n3
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c3 = array licon in=nd2 cx=(x2 - 0.14) span=(nb + 0.02, nb + 0.23) net=n2
  c4 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n2
  c5 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n2
  c6 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n2
  c7 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + 0.23) net=n2
  c8 = array licon in=nd3 cx=(x10 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c9 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c10 = array licon in=nd3 cx=(x11 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c11 = array licon in=nd3 cx=(x12 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c12 = array licon in=nd3 cx=(x13 + L + 0.22) span=(-0.085, nb + WN + 0.02) margin=0.04 net=VGND
  c13 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=Y
  c14 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=Y
  c15 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=n1
  c16 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + WN - 0.25, nb + WN + 0.02) margin=0.04 net=n1
  c17 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n3
  c18 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c19 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c21 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c22 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c23 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c24 = array licon in=pd3 cx=(x10 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c25 = array licon in=pd3 cx=(x12 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c26 = array licon in=pd3 cx=(x13 + L + 0.22) span=(pt - WP - 0.04, H + 0.085) margin=0.04 net=VPWR
  c27 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c29 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c30 = array licon in=pd3 cx=(x10 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c31 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c32 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.17) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + L + 0.14) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=x7 cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 + L + 0.115) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x10 - 0.17) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L + 0.14) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x11 + L + 0.14) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x12 + L + 0.135) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x13 + L + 0.74) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x4 - 0.11) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.03) cy=0
  mc8 = contact mcon cx=(x7 + 0.015) cy=0
  mc9 = contact mcon cx=(x8 + 0.055) cy=0
  mc10 = contact mcon cx=(x9 + L - 0.055) cy=0
  mc11 = contact mcon cx=(x10 - 0.39) cy=0
  mc12 = contact mcon cx=(x10 + L/2) cy=0
  mc13 = contact mcon cx=(x11 + L - 0.035) cy=0
  mc14 = contact mcon cx=(x12 + L + 0.01) cy=0
  mc15 = contact mcon cx=(x13 + L + 0.05) cy=0
  mc16 = contact mcon cx=(x13 + L + 0.51) cy=0
  mc17 = contact mcon cx=(x1 - 0.17) cy=H
  mc18 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc19 = contact mcon cx=(x2 - 0.19) cy=H
  mc20 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc21 = contact mcon cx=(x4 - 0.11) cy=H
  mc22 = contact mcon cx=(x5 - 0.07) cy=H
  mc23 = contact mcon cx=(x6 - 0.03) cy=H
  mc24 = contact mcon cx=(x7 + 0.015) cy=H
  mc25 = contact mcon cx=(x8 + 0.055) cy=H
  mc26 = contact mcon cx=(x9 + L - 0.055) cy=H
  mc27 = contact mcon cx=(x10 - 0.39) cy=H
  mc28 = contact mcon cx=(x10 + L/2) cy=H
  mc29 = contact mcon cx=(x11 + L - 0.035) cy=H
  mc30 = contact mcon cx=(x12 + L + 0.01) cy=H
  mc31 = contact mcon cx=(x13 + L + 0.05) cy=H
  mc32 = contact mcon cx=(x13 + L + 0.51) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l10
  port B in on=l11
  port C in on=l12
  port Y out on=l25
end
