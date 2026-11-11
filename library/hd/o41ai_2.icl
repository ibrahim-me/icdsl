# o41ai_2: lifted from sky130_fd_sc_hd__o41ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o41ai_2 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=n2 b=VPB
  device M1 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M2 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M3 nmos w=WN l=L d=n3 g=A3 s=VGND b=VNB
  device M4 pmos w=WP l=L d=n4 g=A3 s=n1 b=VPB
  device M5 pmos w=WP l=L d=Y g=A4 s=n4 b=VPB
  device M6 pmos w=WP l=L d=n1 g=A3 s=n4 b=VPB
  device M7 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M8 pmos w=WP l=L d=n4 g=A4 s=Y b=VPB
  device M9 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M10 nmos w=WN l=L d=n3 g=A4 s=VGND b=VNB
  device M11 nmos w=WN l=L d=Y g=B1 s=n3 b=VNB
  device M12 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M13 nmos w=WN l=L d=n3 g=B1 s=Y b=VNB
  device M14 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M15 pmos w=WP l=L d=n2 g=A2 s=n1 b=VPB
  device M16 nmos w=WN l=L d=VGND g=A4 s=n3 b=VNB
  device M17 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M18 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M19 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.84
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x6 + L + 0.285) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x7 - 0.285, x10 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x6 + L + 0.285) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x7 - 0.285, x10 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.115, pt - WP - 0.175)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.26, x3 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p6 = rect poly xspan=(x3 - 0.26, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.18)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x6 + L + 0.185) yspan=(nb + WN + 0.125, pt - WP - 0.175)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7 - 0.22, x8 + L) yspan=(nb + WN + 0.105, pt - WP - 0.19)
  p13 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x9, x10 + L + 0.335) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 - 0.305, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.29) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l5 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l6 = rect li xspan=(x1 - 0.315, x2 + L + 0.305) yspan=(nb + 0.02, nb + 0.23) net=n3
  l7 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l8 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l9 = rect li xspan=(x2 + L + 0.055, x10 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n3
  l10 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l11 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l12 = rect li xspan=(x7 - 0.305, x7 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l13 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l14 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l15 = rect li xspan=(x1 - 0.295, x1 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B1
  l16 = rect li xspan=(x3 - 0.26, x4 + L) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A4
  l17 = rect li xspan=(x5, x6 + L + 0.42) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A3
  l18 = rect li xspan=(x7 - 0.22, x8 + L - 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l19 = rect li xspan=(x9 - 0.12, x10 + L + 0.495) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l20 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + WN - 0.25, nb + WN) net=Y
  l21 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.02, pt - 0.02) net=Y
  l22 = rect li xspan=(x1 + L + 0.07, x2 + 0.03) yspan=(nb + WN - 0.25, pt - 0.02) net=Y
  l23 = rect li xspan=(x1 + L + 0.07, x4 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l24 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=Y
  l25 = rect li xspan=(x3 - 0.305, x3 - 0.055) yspan=(pt - WP + 0.35, pt - 0.02) net=n4
  l26 = rect li xspan=(x3 - 0.305, x5 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n4
  l27 = rect li xspan=(x4 + L + 0.055, x6 + L + 0.305) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n4
  l28 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=n4
  l29 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.305) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=n4
  l30 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l31 = rect li xspan=(x5 + L - 0.03, x8 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n1
  l32 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - 0.65, pt - 0.02) net=n1
  l33 = rect li xspan=(x7 - 0.305, x10 + L + 0.305) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n2
  l34 = rect li xspan=(x7 - 0.305, x7 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=n2
  l35 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l36 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.305) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l37 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l38 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.305) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l39 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - 0.7, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c3 = array licon in=nd2 cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c5 = array licon in=nd2 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c7 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd3 cx=(x7 - 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c9 = array licon in=nd3 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd3 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c11 = array licon in=nd3 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c13 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.25, nb + WN) margin=0.04 net=Y
  c14 = array licon in=pd3 cx=(x7 - 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c15 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c16 = array licon in=pd3 cx=(x10 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c17 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c18 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n4
  c19 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) margin=0.04 net=Y
  c21 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP - 0.04, pt - WP + 0.64) margin=0.04 net=Y
  c22 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c23 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) net=n4
  c24 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP + 0.35, pt - 0.02) margin=0.04 net=n1
  c25 = array licon in=pd3 cx=(x7 + L + 0.14) span=(pt - 0.65, pt - 0.02) margin=0.04 net=n1
  c26 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - 0.7, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 - 0.095) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 - 0.055) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x8 - 0.1) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x10 - 0.135) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x10 + L + 0.17) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.58) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x3 - 0.15) cy=0
  mc5 = contact mcon cx=(x4 - 0.11) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.03) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.29) cy=0
  mc9 = contact mcon cx=(x7 - 0.09) cy=0
  mc10 = contact mcon cx=(x8 - 0.05) cy=0
  mc11 = contact mcon cx=(x9 - 0.01) cy=0
  mc12 = contact mcon cx=(x10 + 0.035) cy=0
  mc13 = contact mcon cx=(x10 + L + 0.35) cy=0
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x2 - 0.13) cy=H
  mc16 = contact mcon cx=(x2 + L + 0.19) cy=H
  mc17 = contact mcon cx=(x3 - 0.15) cy=H
  mc18 = contact mcon cx=(x4 - 0.11) cy=H
  mc19 = contact mcon cx=(x5 - 0.07) cy=H
  mc20 = contact mcon cx=(x6 - 0.03) cy=H
  mc21 = contact mcon cx=(x6 + L + 0.29) cy=H
  mc22 = contact mcon cx=(x7 - 0.09) cy=H
  mc23 = contact mcon cx=(x8 - 0.05) cy=H
  mc24 = contact mcon cx=(x9 - 0.01) cy=H
  mc25 = contact mcon cx=(x10 + 0.035) cy=H
  mc26 = contact mcon cx=(x10 + L + 0.35) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l19
  port A2 in on=l18
  port A3 in on=l17
  port A4 in on=l16
  port B1 in on=l15
  port Y out on=l21
end
