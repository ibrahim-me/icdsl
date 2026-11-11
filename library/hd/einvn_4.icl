# einvn_4: lifted from sky130_fd_sc_hd__einvn_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 WP2=0.94 L=0.15 H=2.72

stdcell einvn_4 width=14 height=H taps=no
  device M0 nmos w=WN l=L d=Z g=A s=n1 b=VNB
  device M1 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n3 g=A s=Z b=VPB
  device M3 pmos w=WP2 l=L d=n3 g=TE_B s=VPWR b=VPB
  device M4 pmos w=WP2 l=L d=n3 g=TE_B s=VPWR b=VPB
  device M5 pmos w=WP2 l=L d=VPWR g=TE_B s=n3 b=VPB
  device M6 pmos w=WP2 l=L d=VPWR g=TE_B s=n3 b=VPB
  device M7 nmos w=WN l=L d=Z g=A s=n1 b=VNB
  device M8 pmos w=WP l=L d=Z g=A s=n3 b=VPB
  device M9 nmos w=WN l=L d=VGND g=n2 s=n1 b=VNB
  device M10 pmos w=WP l=L d=Z g=A s=n3 b=VPB
  device M11 nmos w=WN l=L d=n1 g=A s=Z b=VNB
  device M12 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M13 nmos w=WN l=L d=n1 g=A s=Z b=VNB
  device M14 pmos w=WP l=L d=n3 g=A s=Z b=VPB
  device M15 nmos w=WN l=L d=n2 g=TE_B s=VGND b=VNB
  device M16 pmos w=WP l=L d=n2 g=TE_B s=VPWR b=VPB
  device M17 nmos w=WN l=L d=VGND g=n2 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  x4 = x3 + 0.045
  x5 = x4 + L + 0.235
  x6 = x5 + 0.045
  x7 = x6 + L + 0.235
  x8 = x7 + 0.045
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.335
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.07) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 + L + 0.06, x13 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x9 - 0.06) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x9 + L + 0.07, x13 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.225)
  p2 = rect poly xspan=(x4, x9 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x6, x6 + L) yspan=(0.105, nb + WN + 0.225)
  p4 = rect poly xspan=(x8, x8 + L) yspan=(0.105, nb + WN + 0.225)
  p5 = rect poly xspan=(x9 - 0.11, x9 + L + 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x1 - 0.29, x2 + L) yspan=(nb + WN + 0.29, pt - WP - 0.16)
  p9 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.29, H - 0.105)
  p11 = rect poly xspan=(x2, x7 + L) yspan=(pt - WP - 0.165, pt - WP - 0.015)
  p12 = rect poly xspan=(x3, x3 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p13 = rect poly xspan=(x5, x5 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p14 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x10, x13 + L + 0.48) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p18 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x3 + L + 0.015, x6 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x7 + L + 0.015, x9 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l4 = rect li xspan=(x2 + L - 0.005, x3 - 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l5 = rect li xspan=(x2 + L - 0.005, x10 - 0.08) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l6 = rect li xspan=(x6 + L + 0.055, x7 - 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l7 = rect li xspan=(x9 + L + 0.085, x13 + L + 0.5) yspan=(nb + 0.02, nb + 0.215) net=n1
  l8 = rect li xspan=(x9 + L + 0.085, x10 - 0.08) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l9 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=TE_B
  l10 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.5) yspan=(nb + WN - 0.265, pt - WP - 0.16) net=A
  l11 = rect li xspan=(x10 + L - 0.03, x13 + 0.03) yspan=(nb + WN - 0.265, pt - WP - 0.005) net=Z
  l12 = rect li xspan=(x10 + L - 0.03, x11 + 0.03) yspan=(nb + WN - 0.265, pt - WP2 + 0.53) net=Z
  l13 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(nb + WN - 0.265, pt - WP2 + 0.53) net=Z
  l14 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l15 = rect li xspan=(x1 - 0.315, x2 - 0.03) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n2
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l17 = rect li xspan=(x1 - 0.315, x2 - 0.03) yspan=(pt - WP + 0.01, pt - WP2 + 0.12) net=n2
  l18 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(nb + WN - 0.23, pt - WP2 + 0.12) net=n2
  l19 = rect li xspan=(x1 + L - 0.03, x10 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l20 = rect li xspan=(x2 + L - 0.005, x10 - 0.055) yspan=(pt - WP + 0.01, pt - WP2 + 0.12) net=n3
  l21 = rect li xspan=(x2 + L - 0.005, x3 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l22 = rect li xspan=(x6 + L + 0.01, x7 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l23 = rect li xspan=(x9 + L + 0.07, x10 - 0.055) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l24 = rect li xspan=(x9 + L + 0.07, x13 + L + 0.5) yspan=(pt - 0.19, pt - 0.02) net=n3
  l25 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - WP2 + 0.105, pt - 0.02) net=n3
  l26 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.5) yspan=(pt - WP2 + 0.105, pt - 0.02) net=n3
  l27 = rect li xspan=(x1 + L - 0.03, x2 - 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x3 + L - 0.03, x6 - 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l29 = rect li xspan=(x7 + L - 0.03, x9 + 0.045) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x5 - 0.095) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + 0.215) margin=0.04 net=n1
  c4 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.02, nb + 0.215) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.25) net=VGND
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c7 = array licon in=nd2 cx=(x3 - 0.095) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c8 = array licon in=nd2 cx=(x7 - 0.095) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd2 cx=(x10 - 0.165) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + WN - 0.265, pt - WP2 + 0.53) margin=0.04 net=Z
  c11 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + WN - 0.265, pt - WP2 + 0.53) margin=0.04 net=Z
  c12 = array licon in=pd3 cx=(x10 + L + 0.14) span=(nb + WN - 0.265, pt - WP2 + 0.53) margin=0.04 net=Z
  c13 = array licon in=pd3 cx=(x12 + L + 0.14) span=(nb + WN - 0.265, pt - WP2 + 0.53) margin=0.04 net=Z
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c15 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c16 = array licon in=pd2 cx=(x6 + L + 0.095) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c17 = array licon in=pd3 cx=(x10 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c18 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - WP2 + 0.105 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c19 = array licon in=pd3 cx=(x13 + L + 0.14) span=(pt - WP2 + 0.105 + 0.08, pt - 0.02 - 0.08) net=n3
  c20 = array licon in=pd2 cx=(x8 + L + 0.095) span=(pt - 0.65, H + 0.085) net=VPWR
  c21 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65, H + 0.085) net=VPWR
  c22 = array licon in=pd2 cx=(x4 + L + 0.095) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x9 + 0.03) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x13 + L + 0.345) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x13 + L + 0.585) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x5 - 0.105) cy=0
  mc5 = contact mcon cx=(x7 - 0.065) cy=0
  mc6 = contact mcon cx=(x9 - 0.07) cy=0
  mc7 = contact mcon cx=(x10 - 0.085) cy=0
  mc8 = contact mcon cx=(x11 - 0.045) cy=0
  mc9 = contact mcon cx=x12 cy=0
  mc10 = contact mcon cx=(x13 + 0.04) cy=0
  mc11 = contact mcon cx=(x13 + L + 0.355) cy=0
  mc12 = contact mcon cx=(x1 - 0.17) cy=H
  mc13 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc14 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc15 = contact mcon cx=(x5 - 0.105) cy=H
  mc16 = contact mcon cx=(x7 - 0.065) cy=H
  mc17 = contact mcon cx=(x9 - 0.07) cy=H
  mc18 = contact mcon cx=(x10 - 0.085) cy=H
  mc19 = contact mcon cx=(x11 - 0.045) cy=H
  mc20 = contact mcon cx=x12 cy=H
  mc21 = contact mcon cx=(x13 + 0.04) cy=H
  mc22 = contact mcon cx=(x13 + L + 0.355) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l10
  port TE_B in on=l9
  port Z out on=l11
end
