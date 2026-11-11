# xor2_2: lifted from sky130_fd_sc_hd__xor2_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell xor2_2 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n2 g=B s=n1 b=VPB
  device M2 pmos w=WP l=L d=X g=n2 s=n3 b=VPB
  device M3 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M4 pmos w=WP l=L d=n3 g=B s=VPWR b=VPB
  device M5 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=B s=VGND b=VNB
  device M7 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M8 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M9 nmos w=WN l=L d=n4 g=B s=X b=VNB
  device M10 nmos w=WN l=L d=VGND g=B s=n2 b=VNB
  device M11 nmos w=WN l=L d=n4 g=A s=VGND b=VNB
  device M12 pmos w=WP l=L d=n3 g=n2 s=X b=VPB
  device M13 pmos w=WP l=L d=VPWR g=A s=n3 b=VPB
  device M14 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M15 nmos w=WN l=L d=VGND g=A s=n2 b=VNB
  device M16 nmos w=WN l=L d=X g=B s=n4 b=VNB
  device M17 nmos w=WN l=L d=n2 g=A s=VGND b=VNB
  device M18 pmos w=WP l=L d=VPWR g=B s=n3 b=VPB
  device M19 nmos w=WN l=L d=VGND g=n2 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.335
  x9 = x8 + L + 0.8
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.28, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x9 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.28, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x9 - 0.265, x10 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.015, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5 - 0.025, x6 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x9 - 0.225, x9 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l7 = rect li xspan=(x5 - 0.305, x5 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l8 = rect li xspan=(x5 - 0.305, x7 - 0.055) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n4
  l9 = rect li xspan=(x6 + L - 0.03, x8 + L + 0.31) yspan=(nb + 0.02, nb + 0.24) net=n4
  l10 = rect li xspan=(x6 + L - 0.03, x7 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l11 = rect li xspan=(x2 + L + 0.07, x4 - 0.135) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l12 = rect li xspan=(x7 - 0.035, x8 + L + 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l13 = rect li xspan=(x1 + L - 0.015, x2 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l14 = rect li xspan=(x2 - 0.13, x2 + 0.045) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A
  l15 = rect li xspan=(x2 - 0.13, x4 + L + 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A
  l16 = rect li xspan=(x4 + 0.04, x6 + L + 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l17 = rect li xspan=(x4 + 0.04, x4 + L + 0.065) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=A
  l18 = rect li xspan=(x1 - 0.295, x4 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n2
  l19 = rect li xspan=(x1 - 0.295, x1 - 0.125) yspan=(nb + WN - 0.16, pt - WP + 0.47) net=n2
  l20 = rect li xspan=(x1 - 0.295, x5 - 0.395) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n2
  l21 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l22 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l23 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.64) net=n2
  l24 = rect li xspan=(x4 + L + 0.235, x9 - 0.085) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n2
  l25 = rect li xspan=(x4 + L + 0.235, x5 - 0.395) yspan=(pt - WP - 0.04, pt - WP + 0.47) net=n2
  l26 = rect li xspan=(x9 - 0.255, x10 - 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n2
  l27 = rect li xspan=(x9 - 0.255, x9 - 0.085) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=n2
  l28 = rect li xspan=(x7 + L + 0.03, x8 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=X
  l29 = rect li xspan=(x7 + L + 0.03, x10 + L + 0.465) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l30 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=X
  l31 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - WP - 0.07, pt - WP + 0.64) net=X
  l32 = rect li xspan=(x9 + L + 0.015, x10 + L + 0.465) yspan=(pt - WP - 0.07, pt - WP + 0.14) net=X
  l33 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.465) yspan=(nb + WN - 0.16, pt - WP + 0.14) net=X
  l34 = rect li xspan=(x1 - 0.295, x1 - 0.015) yspan=(pt - 0.35, pt - 0.02) net=n1
  l35 = rect li xspan=(x1 - 0.27, x1 - 0.1) yspan=(pt - 0.36, pt - 0.02) net=n1
  l36 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.35, pt - 0.02) net=n1
  l37 = rect li xspan=(x2 + L + 0.015, x4 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n1
  l38 = rect li xspan=(x2 + L + 0.09, x3 - 0.02) yspan=(pt - 0.36, pt - 0.02) net=n1
  l39 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.265) yspan=(pt - 0.35, pt - 0.02) net=n1
  l40 = rect li xspan=(x5 - 0.33, x5 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n3
  l41 = rect li xspan=(x5 - 0.225, x9 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n3
  l42 = rect li xspan=(x5 - 0.225, x5 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l43 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l44 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l45 = rect li xspan=(x8 + L + 0.015, x10 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n3
  l46 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.265) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l47 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l48 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l49 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c6 = array licon in=nd2 cx=(x5 - 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n4
  c7 = array licon in=nd2 cx=(x5 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + 0.24) net=n4
  c9 = array licon in=nd3 cx=(x9 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c10 = array licon in=nd3 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c11 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c12 = array licon in=nd2 cx=(x8 - 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=X
  c13 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=X
  c14 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP - 0.07 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=X
  c15 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c16 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n3
  c17 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c18 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n3
  c19 = array licon in=pd3 cx=(x9 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n3
  c20 = array licon in=pd3 cx=(x10 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c21 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) net=n1
  c22 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c24 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) net=n1
  c25 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c26 = array licon in=pd2 cx=(x8 - 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L - 0.025) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + 0.035) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=x8 cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x9 + L + 0.1) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x10 + L + 0.55) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.135) cy=0
  mc3 = contact mcon cx=(x3 - 0.105) cy=0
  mc4 = contact mcon cx=(x4 - 0.065) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.255) cy=0
  mc6 = contact mcon cx=(x5 - 0.085) cy=0
  mc7 = contact mcon cx=(x6 - 0.045) cy=0
  mc8 = contact mcon cx=x7 cy=0
  mc9 = contact mcon cx=(x8 - 0.02) cy=0
  mc10 = contact mcon cx=(x8 + L + 0.3) cy=0
  mc11 = contact mcon cx=(x9 - 0.04) cy=0
  mc12 = contact mcon cx=(x10 + 0.005) cy=0
  mc13 = contact mcon cx=(x10 + L + 0.32) cy=0
  mc14 = contact mcon cx=(x3 - 0.105) cy=(nb + WN + 0.305)
  mc15 = contact mcon cx=(x8 - 0.02) cy=(nb + WN + 0.305)
  mc16 = contact mcon cx=(x1 - 0.185) cy=(pt - 0.275)
  mc17 = contact mcon cx=(x3 - 0.105) cy=(pt - 0.275)
  mc18 = contact mcon cx=(x1 - 0.185) cy=H
  mc19 = contact mcon cx=(x1 + L + 0.135) cy=H
  mc20 = contact mcon cx=(x3 - 0.105) cy=H
  mc21 = contact mcon cx=(x4 - 0.065) cy=H
  mc22 = contact mcon cx=(x4 + L + 0.255) cy=H
  mc23 = contact mcon cx=(x5 - 0.085) cy=H
  mc24 = contact mcon cx=(x6 - 0.045) cy=H
  mc25 = contact mcon cx=x7 cy=H
  mc26 = contact mcon cx=(x8 - 0.02) cy=H
  mc27 = contact mcon cx=(x8 + L + 0.3) cy=H
  mc28 = contact mcon cx=(x9 - 0.04) cy=H
  mc29 = contact mcon cx=(x10 + 0.005) cy=H
  mc30 = contact mcon cx=(x10 + L + 0.32) cy=H
  w1 = rect m1 xspan=(x2 + L + 0.03, x3 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=B
  w2 = rect m1 xspan=(x2 + L + 0.03, x8 + L - 0.02) yspan=(nb + WN + 0.235, pt - WP - 0.225) net=B
  w3 = rect m1 xspan=(x8 - 0.165, x8 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=B
  w4 = rect m1 xspan=(x1 - 0.33, x1 - 0.04) yspan=(pt - WP + 0.61, pt - 0.16) net=n1
  w5 = rect m1 xspan=(x1 - 0.33, x3 + 0.045) yspan=(pt - WP + 0.655, pt - 0.205) net=n1
  w6 = rect m1 xspan=(x2 + L + 0.03, x3 + 0.045) yspan=(pt - WP + 0.61, pt - 0.16) net=n1
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l15
  port B in on=l12
  port X out on=l32
end
