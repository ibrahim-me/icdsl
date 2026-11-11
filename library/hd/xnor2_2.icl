# xnor2_2: lifted from sky130_fd_sc_hd__xnor2_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell xnor2_2 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=B s=n1 b=VPB
  device M1 nmos w=WN l=L d=VGND g=B s=n2 b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M3 pmos w=WP l=L d=Y g=B s=n3 b=VPB
  device M4 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M5 pmos w=WP l=L d=VPWR g=A s=n3 b=VPB
  device M6 pmos w=WP l=L d=n1 g=B s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M8 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n4 g=A s=VGND b=VNB
  device M10 pmos w=WP l=L d=Y g=n1 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=n3 g=B s=Y b=VPB
  device M12 nmos w=WN l=L d=n2 g=B s=VGND b=VNB
  device M13 pmos w=WP l=L d=VPWR g=n1 s=Y b=VPB
  device M14 nmos w=WN l=L d=n4 g=B s=n1 b=VNB
  device M15 nmos w=WN l=L d=n2 g=A s=VGND b=VNB
  device M16 nmos w=WN l=L d=Y g=n1 s=n2 b=VNB
  device M17 nmos w=WN l=L d=n1 g=B s=n4 b=VNB
  device M18 nmos w=WN l=L d=VGND g=A s=n2 b=VNB
  device M19 nmos w=WN l=L d=n2 g=n1 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.415
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.84
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.315
  x9 = x8 + L + 0.8
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.28, x4 + L + 0.285) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.285, x8 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x9 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.28, x4 + L + 0.285) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.285, x8 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x9 - 0.265, x10 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x3 + 0.03) yspan=(nb + 0.02, nb + 0.24) net=n4
  l2 = rect li xspan=(x2 + L + 0.055, x3 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l3 = rect li xspan=(x2 + L + 0.055, x4 + L + 0.305) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n4
  l4 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l5 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x5 - 0.225, x5 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l7 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l8 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l9 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l10 = rect li xspan=(x5 + L - 0.03, x10 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n2
  l11 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l12 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.02) net=n2
  l13 = rect li xspan=(x3 + 0.005, x5 + 0.055) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=A
  l14 = rect li xspan=(x1 + L/2, x2 + L - 0.02) yspan=(nb + WN + 0.19, nb + WN + 0.4) net=B
  l15 = rect li xspan=(x2 - 0.045, x2 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l16 = rect li xspan=(x2 - 0.045, x6 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B
  l17 = rect li xspan=(x5 + L + 0.135, x8 + 0.01) yspan=(nb + WN + 0.19, nb + WN + 0.4) net=B
  l18 = rect li xspan=(x5 + L + 0.135, x6 + 0.03) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l19 = rect li xspan=(x7 + L + 0.09, x10 - 0.015) yspan=(pt - 0.69, pt - 0.52) net=Y
  l20 = rect li xspan=(x7 + L + 0.09, x8 - 0.015) yspan=(pt - 0.69, pt - 0.36) net=Y
  l21 = rect li xspan=(x9 - 0.305, x10 + L + 0.445) yspan=(nb + 0.07, nb + 0.24) net=Y
  l22 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - WP - 0.07, pt - 0.36) net=Y
  l23 = rect li xspan=(x9 + L + 0.015, x10 + L + 0.445) yspan=(pt - WP - 0.07, pt - WP + 0.14) net=Y
  l24 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.445) yspan=(nb + 0.07, pt - WP + 0.14) net=Y
  l25 = rect li xspan=(x1 - 0.33, x1 - 0.1) yspan=(nb + WN - 0.24, pt - 0.02) net=n1
  l26 = rect li xspan=(x1 - 0.33, x2 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.01) net=n1
  l27 = rect li xspan=(x1 - 0.33, x7 - 0.015) yspan=(pt - 0.7, pt - 0.53) net=n1
  l28 = rect li xspan=(x1 - 0.33, x1 - 0.015) yspan=(pt - 0.7, pt - 0.02) net=n1
  l29 = rect li xspan=(x1 - 0.33, x4 + L + 0.265) yspan=(pt - 0.7, pt - 0.52) net=n1
  l30 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.7, pt - 0.02) net=n1
  l31 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.265) yspan=(pt - 0.7, pt - 0.02) net=n1
  l32 = rect li xspan=(x6 + L + 0.095, x9 - 0.085) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l33 = rect li xspan=(x6 + L + 0.095, x7 - 0.015) yspan=(pt - WP - 0.03, pt - 0.53) net=n1
  l34 = rect li xspan=(x9 - 0.255, x10 - 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l35 = rect li xspan=(x9 - 0.255, x9 - 0.085) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=n1
  l36 = rect li xspan=(x5 - 0.265, x5 - 0.015) yspan=(pt - 0.36, pt - 0.02) net=n3
  l37 = rect li xspan=(x6 + L + 0.015, x7 + 0.065) yspan=(pt - 0.36, pt - 0.02) net=n3
  l38 = rect li xspan=(x6 + L + 0.015, x8 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n3
  l39 = rect li xspan=(x8 + L + 0.015, x8 + L + 0.265) yspan=(pt - 0.35, pt - 0.02) net=n3
  l40 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l41 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l42 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l43 = rect li xspan=(x9 - 0.265, x9 - 0.015) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l44 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.445) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + 0.24) net=n4
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n4
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n4
  c5 = array licon in=nd2 cx=(x5 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c7 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd2 cx=(x8 - 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c9 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c10 = array licon in=nd3 cx=(x9 - 0.14) span=(nb + 0.07, nb + 0.24) net=Y
  c11 = array licon in=nd3 cx=(x10 + L + 0.14) span=(nb + 0.07 + 0.08, pt - WP + 0.14 - 0.08) net=Y
  c12 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.01) margin=0.04 net=n1
  c13 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.02) margin=0.04 net=n2
  c14 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP - 0.07 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.7 + 0.08, pt - 0.02 - 0.08) net=n1
  c16 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.7 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c17 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.7 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c18 = array licon in=pd2 cx=(x8 - 0.14) span=(pt - 0.69 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c19 = array licon in=pd3 cx=(x10 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c23 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c25 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) net=n3
  c26 = array licon in=pd3 cx=(x9 - 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.095) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.025) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.06) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.285) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 - 0.195) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L + 0.12) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x9 + L + 0.1) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.415, x10 + L + 0.53) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.185) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.135) cy=0
  mc3 = contact mcon cx=(x3 - 0.105) cy=0
  mc4 = contact mcon cx=(x4 - 0.065) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.255) cy=0
  mc6 = contact mcon cx=(x5 - 0.125) cy=0
  mc7 = contact mcon cx=(x6 - 0.085) cy=0
  mc8 = contact mcon cx=(x7 - 0.045) cy=0
  mc9 = contact mcon cx=(x8 - 0.04) cy=0
  mc10 = contact mcon cx=(x8 + L + 0.28) cy=0
  mc11 = contact mcon cx=(x9 - 0.06) cy=0
  mc12 = contact mcon cx=(x10 - 0.02) cy=0
  mc13 = contact mcon cx=(x10 + L + 0.3) cy=0
  mc14 = contact mcon cx=(x5 - 0.105) cy=(pt - 0.275)
  mc15 = contact mcon cx=(x7 - 0.025) cy=(pt - 0.275)
  mc16 = contact mcon cx=(x1 - 0.185) cy=H
  mc17 = contact mcon cx=(x1 + L + 0.135) cy=H
  mc18 = contact mcon cx=(x3 - 0.105) cy=H
  mc19 = contact mcon cx=(x4 - 0.065) cy=H
  mc20 = contact mcon cx=(x4 + L + 0.255) cy=H
  mc21 = contact mcon cx=(x5 - 0.125) cy=H
  mc22 = contact mcon cx=(x6 - 0.085) cy=H
  mc23 = contact mcon cx=(x7 - 0.045) cy=H
  mc24 = contact mcon cx=(x8 - 0.04) cy=H
  mc25 = contact mcon cx=(x8 + L + 0.28) cy=H
  mc26 = contact mcon cx=(x9 - 0.06) cy=H
  mc27 = contact mcon cx=(x10 - 0.02) cy=H
  mc28 = contact mcon cx=(x10 + L + 0.3) cy=H
  w1 = rect m1 xspan=(x5 - 0.25, x5 + 0.045) yspan=(pt - WP + 0.61, pt - 0.16) net=n3
  w2 = rect m1 xspan=(x5 - 0.25, x7 + L - 0.025) yspan=(pt - WP + 0.655, pt - 0.205) net=n3
  w3 = rect m1 xspan=(x6 + L + 0.11, x7 + L - 0.025) yspan=(pt - WP + 0.61, pt - 0.16) net=n3
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l13
  port B in on=l16
  port Y out on=l23
end
