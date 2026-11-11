# einvp_4: lifted from sky130_fd_sc_hd__einvp_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 WP2=0.94 L=0.15 H=2.72

stdcell einvp_4 width=14 height=H taps=no
  device M0 pmos w=WP2 l=L d=VPWR g=n1 s=n2 b=VPB
  device M1 nmos w=WN l=L d=VGND g=TE s=n3 b=VNB
  device M2 nmos w=WN l=L d=Z g=A s=n3 b=VNB
  device M3 pmos w=WP2 l=L d=n2 g=n1 s=VPWR b=VPB
  device M4 pmos w=WP2 l=L d=n2 g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n3 g=TE s=VGND b=VNB
  device M6 pmos w=WP l=L d=n2 g=A s=Z b=VPB
  device M7 pmos w=WP2 l=L d=VPWR g=n1 s=n2 b=VPB
  device M8 nmos w=WN l=L d=Z g=A s=n3 b=VNB
  device M9 pmos w=WP l=L d=Z g=A s=n2 b=VPB
  device M10 pmos w=WP l=L d=Z g=A s=n2 b=VPB
  device M11 nmos w=WN l=L d=n3 g=A s=Z b=VNB
  device M12 nmos w=WN l=L d=VGND g=TE s=n3 b=VNB
  device M13 nmos w=WN l=L d=n3 g=A s=Z b=VNB
  device M14 pmos w=WP l=L d=n2 g=A s=Z b=VPB
  device M15 nmos w=WN l=L d=n1 g=TE s=VGND b=VNB
  device M16 pmos w=WP l=L d=n1 g=TE s=VPWR b=VPB
  device M17 nmos w=WN l=L d=n3 g=TE s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.3
  x4 = x3 + 0.08
  x5 = x4 + L + 0.2
  x6 = x5 + 0.08
  x7 = x6 + L + 0.2
  x8 = x7 + 0.08
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.335
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x9 - 0.075) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x9 + L + 0.07, x13 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 - 0.015) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 + L + 0.115, x13 + L + 0.265) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x9 + L + 0.08, x13 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x1, x7 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, nb + WN + 0.225)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, nb + WN + 0.225)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, nb + WN + 0.225)
  p7 = rect poly xspan=(x7, x7 + L) yspan=(0.105, nb + WN + 0.225)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.435, H - 0.105)
  p9 = rect poly xspan=(x4, x9 + L) yspan=(nb + WN + 0.435, pt - WP - 0.015)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.435, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.435, H - 0.105)
  p12 = rect poly xspan=(x9 - 0.125, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.015)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x10, x13 + L + 0.275) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p17 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x13, x13 + L + 0.275) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x5 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x7 + L - 0.03, x9 - 0.045) yspan=(-0.085, nb + 0.25) net=VGND
  l4 = rect li xspan=(x2 + L + 0.075, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l5 = rect li xspan=(x2 + L + 0.075, x10 - 0.055) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l6 = rect li xspan=(x6 + L - 0.03, x7 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l7 = rect li xspan=(x9 + L - 0.01, x13 + L + 0.5) yspan=(nb + 0.02, nb + 0.23) net=n3
  l8 = rect li xspan=(x9 + L - 0.01, x10 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l9 = rect li xspan=(x11 + L + 0.105, x13 + L + 0.5) yspan=(nb + WN + 0.135, pt - WP - 0.21) net=A
  l10 = rect li xspan=(x1 - 0.315, x1 - 0.07) yspan=(nb + WN + 0.11, pt - WP2 + 0.07) net=TE
  l11 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(nb + 0.4, pt - WP2 + 0.58) net=Z
  l12 = rect li xspan=(x10 + L - 0.03, x13 + L + 0.5) yspan=(nb + 0.4, nb + WN - 0.035) net=Z
  l13 = rect li xspan=(x10 + L - 0.03, x11 + L - 0.07) yspan=(nb + 0.4, pt - WP2 + 0.07) net=Z
  l14 = rect li xspan=(x10 + L - 0.03, x13 + 0.03) yspan=(pt - WP - 0.04, pt - WP2 + 0.07) net=Z
  l15 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(pt - WP - 0.04, pt - WP2 + 0.58) net=Z
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l17 = rect li xspan=(x1 - 0.315, x2 - 0.125) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l18 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 + 0.24, pt - 0.02) net=n1
  l19 = rect li xspan=(x1 - 0.315, x2 + 0.06) yspan=(pt - WP2 + 0.24, pt - WP2 + 0.41) net=n1
  l20 = rect li xspan=(x1 + L - 0.045, x2 - 0.125) yspan=(nb + WN - 0.23, pt - WP2 + 0.41) net=n1
  l21 = rect li xspan=(x1 + L - 0.045, x10 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l22 = rect li xspan=(x1 + L - 0.045, x2 + 0.06) yspan=(nb + WN + 0.11, pt - WP2 + 0.41) net=n1
  l23 = rect li xspan=(x2 + L + 0.115, x10 - 0.08) yspan=(pt - WP2 + 0.01, pt - WP2 + 0.18) net=n2
  l24 = rect li xspan=(x2 + L + 0.115, x3 + 0.03) yspan=(pt - WP2 + 0.01, pt - 0.02) net=n2
  l25 = rect li xspan=(x6 + L + 0.055, x7 + 0.03) yspan=(pt - WP2 + 0.01, pt - 0.02) net=n2
  l26 = rect li xspan=(x9 + L + 0.085, x10 - 0.08) yspan=(pt - WP2 + 0.01, pt - 0.02) net=n2
  l27 = rect li xspan=(x9 + L + 0.085, x13 + L + 0.5) yspan=(pt - 0.19, pt - 0.02) net=n2
  l28 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - WP2 + 0.24, pt - 0.02) net=n2
  l29 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.5) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l30 = rect li xspan=(x1 + L - 0.03, x2 + 0.06) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l31 = rect li xspan=(x4 + L - 0.03, x6 + 0.03) yspan=(pt - 0.59, H + 0.085) net=VPWR
  l32 = rect li xspan=(x8 + L - 0.03, x9 + 0.06) yspan=(pt - 0.59, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 + L + 0.06) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x8 + L + 0.06) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n3
  c5 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n3
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c7 = array licon in=nd1 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c8 = array licon in=nd1 cx=(x6 + L + 0.06) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c9 = array licon in=nd2 cx=(x10 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c10 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.4, pt - WP2 + 0.58) margin=0.04 net=Z
  c11 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.4, nb + WN - 0.035) margin=0.04 net=Z
  c12 = array licon in=pd3 cx=(x10 + L + 0.14) span=(nb + 0.4, pt - WP2 + 0.58) margin=0.04 net=Z
  c13 = array licon in=pd3 cx=(x12 + L + 0.14) span=(pt - WP - 0.04, pt - WP2 + 0.58) margin=0.04 net=Z
  c14 = array licon in=pd2 cx=(x7 - 0.06) span=(pt - WP2 + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c15 = array licon in=pd3 cx=(x10 - 0.165) span=(pt - WP2 + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c16 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - WP2 + 0.24 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c17 = array licon in=pd3 cx=(x13 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) net=n2
  c18 = array licon in=pd2 cx=(x5 - 0.06) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c19 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - 0.59, H + 0.085) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.24 + 0.08, pt - 0.02 - 0.08) net=n1
  c21 = array licon in=pd2 cx=(x3 - 0.06) span=(pt - WP2 + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c22 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.36, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x9 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x12 - 0.01) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x13 - 0.09) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x13 + L + 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x13 + L + 0.585) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x5 - 0.07) cy=0
  mc5 = contact mcon cx=(x7 - 0.03) cy=0
  mc6 = contact mcon cx=(x9 - 0.07) cy=0
  mc7 = contact mcon cx=(x10 - 0.085) cy=0
  mc8 = contact mcon cx=(x11 - 0.045) cy=0
  mc9 = contact mcon cx=x12 cy=0
  mc10 = contact mcon cx=(x13 + 0.04) cy=0
  mc11 = contact mcon cx=(x13 + L + 0.355) cy=0
  mc12 = contact mcon cx=(x1 - 0.17) cy=H
  mc13 = contact mcon cx=(x2 - 0.13) cy=H
  mc14 = contact mcon cx=(x3 - 0.11) cy=H
  mc15 = contact mcon cx=(x5 - 0.07) cy=H
  mc16 = contact mcon cx=(x7 - 0.03) cy=H
  mc17 = contact mcon cx=(x9 - 0.07) cy=H
  mc18 = contact mcon cx=(x10 - 0.085) cy=H
  mc19 = contact mcon cx=(x11 - 0.045) cy=H
  mc20 = contact mcon cx=x12 cy=H
  mc21 = contact mcon cx=(x13 + 0.04) cy=H
  mc22 = contact mcon cx=(x13 + L + 0.355) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l9
  port TE in on=l10
  port Z out on=l14
end
