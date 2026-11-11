# o32ai_2: lifted from sky130_fd_sc_hd__o32ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o32ai_2 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A3 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M3 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M4 nmos w=WN l=L d=Y g=B1 s=n1 b=VNB
  device M5 pmos w=WP l=L d=Y g=A3 s=n3 b=VPB
  device M6 pmos w=WP l=L d=n3 g=A3 s=Y b=VPB
  device M7 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M8 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M10 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M11 pmos w=WP l=L d=n3 g=A2 s=n2 b=VPB
  device M12 nmos w=WN l=L d=Y g=B2 s=n1 b=VNB
  device M13 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M14 pmos w=WP l=L d=n4 g=B1 s=VPWR b=VPB
  device M15 nmos w=WN l=L d=n1 g=B2 s=Y b=VNB
  device M16 pmos w=WP l=L d=n2 g=A2 s=n3 b=VPB
  device M17 pmos w=WP l=L d=n4 g=B2 s=Y b=VPB
  device M18 pmos w=WP l=L d=Y g=B2 s=n4 b=VPB
  device M19 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.44
  x7 = x6 + L + 0.22
  x8 = x7 + 0.06
  x9 = x8 + L + 0.22
  x10 = x9 + 0.06
  x11 = x10 + L + 0.22
  x12 = x11 + 0.06
  x13 = x12 + L + 0.74
  x14 = x13 + 0.08
  x15 = x14 + L + 0.2
  x16 = x15 + 0.08
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x16 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 - 0.015) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 + L + 0.155, x12 + L + 0.285) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x13 - 0.185, x16 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.22)
  p8 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.23, pt - WP - 0.22)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x6, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x9, x12 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(0.105, pt - WP - 0.16)
  p17 = rect poly xspan=(x12, x12 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p18 = rect poly xspan=(x13, x13 + L) yspan=(0.105, pt - WP - 0.16)
  p19 = rect poly xspan=(x13, x16 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p20 = rect poly xspan=(x14, x14 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p21 = rect poly xspan=(x15, x15 + L) yspan=(0.105, pt - WP - 0.16)
  p22 = rect poly xspan=(x16, x16 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x6 - 0.04, x7 - 0.07) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x10 + L - 0.01, x11 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x14 + 0.03, x15 + 0.02) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x1 - 0.31, x5 + L + 0.185) yspan=(nb + 0.02, nb + 0.25) net=n1
  l5 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.185) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l7 = rect li xspan=(x5 + L + 0.015, x16 + L + 0.315) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x7 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x12 + L - 0.01, x13 - 0.075) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l10 = rect li xspan=(x16 + L - 0.02, x16 + L + 0.315) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l11 = rect li xspan=(x1 - 0.31, x2 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B2
  l12 = rect li xspan=(x2 + L + 0.055, x4 + 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B1
  l13 = rect li xspan=(x5 + L + 0.185, x8 - 0.01) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A3
  l14 = rect li xspan=(x9 - 0.07, x13 - 0.32) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A2
  l15 = rect li xspan=(x13 - 0.05, x16 + L + 0.425) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A1
  l16 = rect li xspan=(x1 + L - 0.03, x5 - 0.035) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=Y
  l17 = rect li xspan=(x1 + L - 0.03, x8 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l18 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.61) net=Y
  l19 = rect li xspan=(x4 + L + 0.075, x5 - 0.035) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l20 = rect li xspan=(x4 + L + 0.075, x5 + L - 0.055) yspan=(pt - WP - 0.38, pt - WP + 0.01) net=Y
  l21 = rect li xspan=(x6 + L - 0.03, x8 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.6) net=Y
  l22 = rect li xspan=(x5 + L + 0.115, x6 - 0.075) yspan=(pt - WP + 0.35, pt - 0.04) net=n3
  l23 = rect li xspan=(x5 + L + 0.115, x12 + L + 0.325) yspan=(pt - 0.23, pt - 0.04) net=n3
  l24 = rect li xspan=(x8 + L + 0.055, x9 + 0.01) yspan=(pt - WP + 0.01, pt - 0.04) net=n3
  l25 = rect li xspan=(x12 + L + 0.075, x12 + L + 0.325) yspan=(pt - 0.65, pt - 0.04) net=n3
  l26 = rect li xspan=(x9 + L + 0.03, x16 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l27 = rect li xspan=(x9 + L + 0.03, x12 + 0.03) yspan=(pt - WP + 0.01, pt - 0.4) net=n2
  l28 = rect li xspan=(x14 + L - 0.03, x16 + 0.03) yspan=(pt - WP + 0.01, pt - 0.025) net=n2
  l29 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=n4
  l30 = rect li xspan=(x1 - 0.31, x3 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n4
  l31 = rect li xspan=(x2 + L + 0.055, x3 + 0.03) yspan=(pt - WP + 0.35, pt - 0.02) net=n4
  l32 = rect li xspan=(x2 + L + 0.055, x5 + 0.03) yspan=(pt - WP + 0.35, pt - WP + 0.52) net=n4
  l33 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP + 0.35, pt - 0.03) net=n4
  l34 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l35 = rect li xspan=(x13 - 0.18, x13 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l36 = rect li xspan=(x16 + L + 0.055, x16 + L + 0.275) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x6 + L - 0.02) span=(-0.085, nb + 0.31) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x8 + L + 0.08) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c6 = array licon in=nd1 cx=(x10 + L + 0.08) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x12 + L + 0.16) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c8 = array licon in=nd1 cx=(x13 - 0.24) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c9 = array licon in=nd1 cx=(x14 + L + 0.06) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x16 + L + 0.15) span=(nb + 0.02, nb + WN + 0.02) net=n1
  c11 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=Y
  c12 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n4
  c14 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01, pt - WP + 0.61) margin=0.04 net=Y
  c15 = array licon in=pd2 cx=(x7 - 0.08) span=(pt - WP + 0.01, pt - WP + 0.6) margin=0.04 net=Y
  c16 = array licon in=pd2 cx=(x9 - 0.08) span=(pt - WP + 0.01 + 0.08, pt - 0.04 - 0.08) margin=0.04 net=n3
  c17 = array licon in=pd2 cx=(x11 - 0.08) span=(pt - WP + 0.01, pt - 0.4) margin=0.04 net=n2
  c18 = array licon in=pd3 cx=(x15 - 0.06) span=(pt - WP + 0.01, pt - 0.025) margin=0.04 net=n2
  c19 = array licon in=pd3 cx=(x16 + L + 0.16) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c20 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c21 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.35, pt - 0.03) net=n4
  c22 = array licon in=pd2 cx=(x6 - 0.16) span=(pt - WP + 0.35 + 0.08, pt - 0.04 - 0.08) net=n3
  c23 = array licon in=pd2 cx=(x12 + L + 0.16) span=(pt - 0.65 + 0.08, pt - 0.04 - 0.08) net=n3
  c24 = array licon in=pd3 cx=(x13 - 0.06) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c25 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x6 + L + 0.1) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x10 + L + 0.1) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x14 + L + 0.07) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x16 + L + 0.545) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 - 0.13) cy=0
  mc7 = contact mcon cx=(x7 - 0.03) cy=0
  mc8 = contact mcon cx=(x9 + 0.015) cy=0
  mc9 = contact mcon cx=(x12 - 0.005) cy=0
  mc10 = contact mcon cx=(x12 + L + 0.31) cy=0
  mc11 = contact mcon cx=(x13 + 0.035) cy=0
  mc12 = contact mcon cx=(x16 - 0.005) cy=0
  mc13 = contact mcon cx=(x16 + L + 0.31) cy=0
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x2 - 0.13) cy=H
  mc16 = contact mcon cx=(x3 - 0.09) cy=H
  mc17 = contact mcon cx=(x4 - 0.05) cy=H
  mc18 = contact mcon cx=(x5 - 0.01) cy=H
  mc19 = contact mcon cx=(x6 - 0.13) cy=H
  mc20 = contact mcon cx=(x7 - 0.03) cy=H
  mc21 = contact mcon cx=(x9 + 0.015) cy=H
  mc22 = contact mcon cx=(x12 - 0.005) cy=H
  mc23 = contact mcon cx=(x12 + L + 0.31) cy=H
  mc24 = contact mcon cx=(x13 + 0.035) cy=H
  mc25 = contact mcon cx=(x16 - 0.005) cy=H
  mc26 = contact mcon cx=(x16 + L + 0.31) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l15
  port A2 in on=l14
  port A3 in on=l13
  port B1 in on=l12
  port B2 in on=l11
  port Y out on=l20
end
