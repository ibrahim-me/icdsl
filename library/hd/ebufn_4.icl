# ebufn_4: lifted from sky130_fd_sc_hd__ebufn_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 WP2=0.94 L=0.15 H=2.72

stdcell ebufn_4 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=TE_B s=n2 b=VNB
  device M2 pmos w=WP l=L d=Z g=n3 s=n4 b=VPB
  device M3 nmos w=WN l=L d=Z g=n3 s=n1 b=VNB
  device M4 pmos w=WP l=L d=Z g=n3 s=n4 b=VPB
  device M5 nmos w=WN l=L d=VGND g=n2 s=n1 b=VNB
  device M6 nmos w=WN l=L d=Z g=n3 s=n1 b=VNB
  device M7 nmos w=WN l=L d=VGND g=n2 s=n1 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=TE_B s=n2 b=VPB
  device M9 pmos w=WP l=L d=n4 g=n3 s=Z b=VPB
  device M10 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB
  device M11 pmos w=WP2 l=L d=VPWR g=TE_B s=n4 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=TE_B s=n4 b=VPB
  device M13 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M14 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M15 pmos w=WP2 l=L d=n4 g=TE_B s=VPWR b=VPB
  device M16 pmos w=WP2 l=L d=n4 g=TE_B s=VPWR b=VPB
  device M17 nmos w=WN l=L d=n1 g=n3 s=Z b=VNB
  device M18 pmos w=WP l=L d=n4 g=n3 s=Z b=VPB
  device M19 nmos w=WN l=L d=n1 g=n3 s=Z b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.385
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.225
  x5 = x4 + 0.055
  x6 = x5 + L + 0.225
  x7 = x6 + 0.055
  x8 = x7 + L + 0.225
  x9 = x8 + 0.055
  x10 = x9 + L + 0.225
  x11 = x10 + L + 0.4
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  x14 = x13 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 + L - 0.045, x14 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x14 + L + 0.285) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x9 + L + 0.08, x14 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.225)
  p2 = rect poly xspan=(x4, x10 + L + 0.18) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x6, x6 + L) yspan=(0.105, nb + WN + 0.225)
  p4 = rect poly xspan=(x8, x8 + L) yspan=(0.105, nb + WN + 0.225)
  p5 = rect poly xspan=(x10 - 0.01, x10 + L + 0.18) yspan=(nb + WN + 0.075, pt - WP - 0.19)
  p6 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.19)
  p7 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x1, x1 + L + 0.17) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x2, x2 + L + 0.215) yspan=(nb + WN + 0.14, pt - WP - 0.075)
  p11 = rect poly xspan=(x2, x2 + L + 0.235) yspan=(nb + WN + 0.165, pt - WP - 0.075)
  p12 = rect poly xspan=(x2, x3 - 0.27) yspan=(nb + WN + 0.375, pt - WP - 0.075)
  p13 = rect poly xspan=(x2 + L + 0.34, x9 + L) yspan=(pt - WP - 0.165, pt - WP - 0.015)
  p14 = rect poly xspan=(x3, x3 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p15 = rect poly xspan=(x5, x5 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p16 = rect poly xspan=(x7, x7 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p17 = rect poly xspan=(x9, x9 + L) yspan=(pt - WP - 0.165, H - 0.105)
  p18 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x11, x14 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p20 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p21 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p22 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.01) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x7 - 0.025) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x8 + L - 0.03, x10 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l4 = rect li xspan=(x3 + 0.035, x4 - 0.055) yspan=(nb + 0.02, nb + WN - 0.03) net=n1
  l5 = rect li xspan=(x3 + 0.035, x11 - 0.055) yspan=(nb + WN - 0.23, nb + WN - 0.03) net=n1
  l6 = rect li xspan=(x7 + L - 0.005, x8 - 0.055) yspan=(nb + 0.04, nb + WN - 0.03) net=n1
  l7 = rect li xspan=(x10 + L + 0.055, x14 + L + 0.305) yspan=(nb + 0.02, nb + 0.21) net=n1
  l8 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(nb + 0.02, nb + WN - 0.03) net=n1
  l9 = rect li xspan=(x11 - 0.05, x14 + L + 0.075) yspan=(nb + WN + 0.14, pt - WP - 0.21) net=n3
  l10 = rect li xspan=(x2 + 0.03, x2 + L + 0.215) yspan=(nb + WN - 0.12, pt - WP - 0.06) net=TE_B
  l11 = rect li xspan=(x1 + L - 0.055, x2 - 0.145) yspan=(nb + WN - 0.12, pt - WP2 + 0.13) net=A
  l12 = rect li xspan=(x3 + 0.035, x14 + L + 0.465) yspan=(pt - WP - 0.04, pt - WP2 + 0.18) net=Z
  l13 = rect li xspan=(x11 + L - 0.03, x14 + L + 0.465) yspan=(nb + 0.38, nb + WN - 0.03) net=Z
  l14 = rect li xspan=(x14 + L + 0.245, x14 + L + 0.465) yspan=(nb + 0.38, pt - WP2 + 0.18) net=Z
  l15 = rect li xspan=(x1 - 0.315, x1 - 0.08) yspan=(nb + 0.045, pt - 0.02) net=n3
  l16 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.045, nb + WN - 0.22) net=n3
  l17 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP2 + 0.22, pt - 0.02) net=n3
  l18 = rect li xspan=(x2 + L + 0.035, x3 - 0.14) yspan=(nb + 0.02, nb + WN - 0.29) net=n2
  l19 = rect li xspan=(x2 + L + 0.035, x2 + L + 0.29) yspan=(pt - WP2 + 0.05, pt - 0.02) net=n2
  l20 = rect li xspan=(x2 + L + 0.035, x3 - 0.14) yspan=(pt - WP2 + 0.05, pt - WP2 + 0.22) net=n2
  l21 = rect li xspan=(x2 + L + 0.385, x3 - 0.14) yspan=(nb + 0.02, pt - WP2 + 0.22) net=n2
  l22 = rect li xspan=(x2 + L + 0.385, x10 + L + 0.18) yspan=(nb + WN + 0.14, pt - WP - 0.21) net=n2
  l23 = rect li xspan=(x3 - 0.3, x3 - 0.055) yspan=(pt - WP2 + 0.39, pt - 0.02) net=n4
  l24 = rect li xspan=(x3 - 0.3, x14 + L + 0.465) yspan=(pt - WP2 + 0.39, pt - 0.38) net=n4
  l25 = rect li xspan=(x3 + 0.035, x14 + L + 0.465) yspan=(pt - WP2 + 0.35, pt - 0.38) net=n4
  l26 = rect li xspan=(x5 + L + 0.055, x6 + 0.005) yspan=(pt - WP2 + 0.35, pt - 0.02) net=n4
  l27 = rect li xspan=(x9 + L + 0.055, x14 + L + 0.465) yspan=(pt - WP2 + 0.35, pt - 0.02) net=n4
  l28 = rect li xspan=(x1 + L - 0.03, x2 + 0.01) yspan=(pt - 0.64, H + 0.085) net=VPWR
  l29 = rect li xspan=(x3 + L - 0.03, x5 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l30 = rect li xspan=(x6 + L + 0.025, x9 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.36) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x5 + L + 0.085) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x9 + L + 0.085) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.02, nb + 0.21) margin=0.04 net=n1
  c5 = array licon in=nd2 cx=(x14 + L + 0.14) span=(nb + 0.02, nb + 0.21) margin=0.04 net=n1
  c6 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.29 - 0.08) net=n2
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.045 + 0.08, nb + WN - 0.22 - 0.08) net=n3
  c8 = array licon in=nd2 cx=(x3 + L + 0.085) span=(nb + 0.02 + 0.08, nb + WN - 0.03 - 0.08) net=n1
  c9 = array licon in=nd2 cx=(x7 + L + 0.085) span=(nb + 0.04 + 0.08, nb + WN - 0.03 - 0.08) margin=0.04 net=n1
  c10 = array licon in=nd2 cx=(x10 + L + 0.2) span=(nb + 0.02 + 0.08, nb + WN - 0.03 - 0.08) margin=0.04 net=n1
  c11 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.38, nb + WN - 0.03) margin=0.04 net=Z
  c12 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.38, nb + WN - 0.03) margin=0.04 net=Z
  c13 = array licon in=pd3 cx=(x11 + L + 0.14) span=(pt - WP - 0.04, pt - WP2 + 0.18) margin=0.04 net=Z
  c14 = array licon in=pd3 cx=(x13 + L + 0.14) span=(pt - WP - 0.04, pt - WP2 + 0.18) margin=0.04 net=Z
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.22 + 0.08, pt - 0.02 - 0.08) net=n3
  c16 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP2 + 0.05 + 0.08, pt - 0.02 - 0.08) net=n2
  c17 = array licon in=pd1 cx=(x1 + L + 0.18) span=(pt - 0.64, H + 0.085) margin=0.04 net=VPWR
  c18 = array licon in=pd3 cx=(x10 + 0.01) span=(pt - WP2 + 0.35, pt - 0.02) margin=0.04 net=n4
  c19 = array licon in=pd3 cx=(x11 - 0.195) span=(pt - WP2 + 0.35, pt - 0.02) margin=0.04 net=n4
  c20 = array licon in=pd3 cx=(x12 + L + 0.14) span=(pt - WP2 + 0.35, pt - 0.02) margin=0.04 net=n4
  c21 = array licon in=pd3 cx=(x14 + L + 0.14) span=(pt - WP2 + 0.35, pt - 0.02) margin=0.04 net=n4
  c22 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP2 + 0.39 + 0.08, pt - 0.02 - 0.08) net=n4
  c23 = array licon in=pd2 cx=(x6 - 0.085) span=(pt - WP2 + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c24 = array licon in=pd2 cx=(x4 - 0.085) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd2 cx=(x8 - 0.085) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.035) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.05) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x10 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x11 + L + 0.08) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x12 + L - 0.005) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x13 + 0.065) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x14 - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x14 + L + 0.55) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.085) cy=0
  mc4 = contact mcon cx=(x3 - 0.255) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.065) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.105) cy=0
  mc7 = contact mcon cx=(x8 - 0.08) cy=0
  mc8 = contact mcon cx=(x10 - 0.04) cy=0
  mc9 = contact mcon cx=(x11 - 0.12) cy=0
  mc10 = contact mcon cx=(x12 - 0.08) cy=0
  mc11 = contact mcon cx=(x13 - 0.04) cy=0
  mc12 = contact mcon cx=(x14 + 0.005) cy=0
  mc13 = contact mcon cx=(x14 + L + 0.32) cy=0
  mc14 = contact mcon cx=(x1 - 0.165) cy=(pt - WP - 0.295)
  mc15 = contact mcon cx=(x12 - 0.055) cy=(nb + WN + 0.305)
  mc16 = contact mcon cx=(x1 - 0.17) cy=H
  mc17 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc18 = contact mcon cx=(x2 + L + 0.085) cy=H
  mc19 = contact mcon cx=(x3 - 0.255) cy=H
  mc20 = contact mcon cx=(x3 + L + 0.065) cy=H
  mc21 = contact mcon cx=(x5 + L + 0.105) cy=H
  mc22 = contact mcon cx=(x8 - 0.08) cy=H
  mc23 = contact mcon cx=(x10 - 0.04) cy=H
  mc24 = contact mcon cx=(x11 - 0.12) cy=H
  mc25 = contact mcon cx=(x12 - 0.08) cy=H
  mc26 = contact mcon cx=(x13 - 0.04) cy=H
  mc27 = contact mcon cx=(x14 + 0.005) cy=H
  mc28 = contact mcon cx=(x14 + L + 0.32) cy=H
  w1 = rect m1 xspan=(x1 - 0.315, x1 - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n3
  w2 = rect m1 xspan=(x1 - 0.315, x12 + L - 0.055) yspan=(nb + WN + 0.235, pt - WP - 0.225) net=n3
  w3 = rect m1 xspan=(x11 + L + 0.08, x12 + L - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n3
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l11
  port TE_B in on=l10
  port Z out on=l12
end
