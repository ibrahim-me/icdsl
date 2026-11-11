# o21ba_4: lifted from sky130_fd_sc_hd__o21ba_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21ba_4 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M2 pmos w=WP l=L d=n3 g=B1_N s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M4 nmos w=WN l=L d=n2 g=n3 s=n1 b=VNB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M6 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n2 g=A2 s=n4 b=VPB
  device M8 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M9 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M10 pmos w=WP l=L d=n2 g=n3 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M12 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M13 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M14 pmos w=WP l=L d=n4 g=A2 s=n2 b=VPB
  device M15 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M16 nmos w=WN l=L d=n1 g=n3 s=n2 b=VNB
  device M17 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M18 pmos w=WP l=L d=VPWR g=n3 s=n2 b=VPB
  device M19 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M20 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M21 nmos w=WN l=L d=n3 g=B1_N s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.52
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + 0.1
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.31, x6 - 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x6 + L + 0.115, x13 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.385, x9 - 0.115) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 + L + 0.015, x13 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.065, x1 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x10, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x12, x13 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p18 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x12 + L + 0.055, x13 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x6 + L + 0.045, x10 + 0.03) yspan=(nb + 0.02, nb + 0.24) net=n1
  l7 = rect li xspan=(x9 + L + 0.055, x10 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x9 + L + 0.055, x13 + L + 0.33) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l10 = rect li xspan=(x13 + L - 0.03, x13 + L + 0.33) yspan=(nb + 0.03, nb + WN + 0.02) net=n1
  l11 = rect li xspan=(x9 + L + 0.08, x12 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l12 = rect li xspan=(x12 + L + 0.03, x13 + L + 0.515) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l13 = rect li xspan=(x1 - 0.095, x2 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1_N
  l14 = rect li xspan=(x1 + L - 0.06, x2 - 0.055) yspan=(nb + WN + 0.19, pt - WP + 0.22) net=B1_N
  l15 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, pt - WP + 0.22) net=X
  l16 = rect li xspan=(x2 + L - 0.03, x5 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l17 = rect li xspan=(x2 + L - 0.03, x3 + L - 0.05) yspan=(nb + WN - 0.16, pt - WP + 0.22) net=X
  l18 = rect li xspan=(x2 + L - 0.03, x5 + 0.03) yspan=(pt - WP - 0.04, pt - WP + 0.22) net=X
  l19 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l20 = rect li xspan=(x1 - 0.435, x1 - 0.265) yspan=(nb + 0.03, pt - 0.02) net=n3
  l21 = rect li xspan=(x1 - 0.435, x1 + 0.03) yspan=(nb + 0.03, nb + WN - 0.03) net=n3
  l22 = rect li xspan=(x1 - 0.435, x1 - 0.085) yspan=(pt - WP - 0.03, pt - 0.02) net=n3
  l23 = rect li xspan=(x1 - 0.435, x6 - 0.055) yspan=(pt - WP + 0.39, pt - 0.44) net=n3
  l24 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - WP - 0.04, pt - 0.44) net=n3
  l25 = rect li xspan=(x5 + L + 0.055, x7 - 0.135) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n3
  l26 = rect li xspan=(x6 + L - 0.03, x7 - 0.135) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=n3
  l27 = rect li xspan=(x6 + L - 0.03, x8) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l28 = rect li xspan=(x3 + L + 0.125, x6 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=n2
  l29 = rect li xspan=(x5 + L + 0.055, x9 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.01) net=n2
  l30 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(nb + WN - 0.16, pt - WP - 0.21) net=n2
  l31 = rect li xspan=(x6 + L + 0.055, x11 - 0.02) yspan=(pt - WP + 0.31, pt - WP + 0.48) net=n2
  l32 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l33 = rect li xspan=(x7 + L + 0.05, x9 + 0.03) yspan=(nb + WN - 0.24, nb + WN + 0.01) net=n2
  l34 = rect li xspan=(x8 + L + 0.115, x9 + 0.03) yspan=(nb + WN - 0.24, pt - WP + 0.48) net=n2
  l35 = rect li xspan=(x10 + L + 0.015, x11 - 0.02) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=n2
  l36 = rect li xspan=(x9 + L - 0.02, x10 - 0.055) yspan=(pt - WP + 0.65, pt - 0.02) net=n4
  l37 = rect li xspan=(x9 + L - 0.02, x12 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n4
  l38 = rect li xspan=(x11 + L + 0.055, x13 + L + 0.33) yspan=(pt - WP - 0.03, pt - WP + 0.18) net=n4
  l39 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=n4
  l40 = rect li xspan=(x13 + L + 0.055, x13 + L + 0.33) yspan=(pt - WP - 0.03, pt - 0.02) net=n4
  l41 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l42 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l43 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l44 = rect li xspan=(x7 + L + 0.015, x9 - 0.11) yspan=(pt - 0.35, H + 0.085) net=VPWR
  l45 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03, nb + WN - 0.03) margin=0.04 net=n3
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, pt - WP + 0.22) margin=0.04 net=X
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c7 = array licon in=nd2 cx=(x7 - 0.04) span=(nb + 0.02, nb + 0.24) net=n1
  c8 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd2 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c11 = array licon in=nd2 cx=(x12 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd2 cx=(x13 + L + 0.14) span=(nb + 0.03, nb + WN + 0.02) margin=0.04 net=n1
  c13 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + WN - 0.24, nb + WN + 0.01) margin=0.04 net=n2
  c14 = array licon in=pd1 cx=(x1 - 0.17) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c15 = array licon in=pd1 cx=(x2 + L + 0.14) span=(nb + 0.02, pt - WP + 0.22) margin=0.04 net=X
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.04, pt - WP + 0.22) margin=0.04 net=X
  c17 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd2 cx=(x11 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c19 = array licon in=pd2 cx=(x13 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c20 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c21 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.27, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.27, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.27, H + 0.085) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x8 + L + 0.04) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) net=VPWR
  c26 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP + 0.65 + 0.08, pt - 0.02 - 0.08) net=n4
  gc1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + 0.025) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 - 0.06) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x7 - 0.07) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x10 + L + 0.14) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x13 - 0.085) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.52, x13 + L + 0.6) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.29) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.03) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.07) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.11) cy=0
  mc5 = contact mcon cx=(x5 - 0.13) cy=0
  mc6 = contact mcon cx=(x6 - 0.09) cy=0
  mc7 = contact mcon cx=(x7 - 0.05) cy=0
  mc8 = contact mcon cx=(x9 - 0.11) cy=0
  mc9 = contact mcon cx=(x10 - 0.07) cy=0
  mc10 = contact mcon cx=(x11 - 0.03) cy=0
  mc11 = contact mcon cx=(x12 + 0.015) cy=0
  mc12 = contact mcon cx=(x13 + 0.055) cy=0
  mc13 = contact mcon cx=(x13 + L + 0.37) cy=0
  mc14 = contact mcon cx=(x1 - 0.29) cy=H
  mc15 = contact mcon cx=(x1 + L + 0.03) cy=H
  mc16 = contact mcon cx=(x2 + L + 0.07) cy=H
  mc17 = contact mcon cx=(x3 + L + 0.11) cy=H
  mc18 = contact mcon cx=(x5 - 0.13) cy=H
  mc19 = contact mcon cx=(x6 - 0.09) cy=H
  mc20 = contact mcon cx=(x7 - 0.05) cy=H
  mc21 = contact mcon cx=(x9 - 0.11) cy=H
  mc22 = contact mcon cx=(x10 - 0.07) cy=H
  mc23 = contact mcon cx=(x11 - 0.03) cy=H
  mc24 = contact mcon cx=(x12 + 0.015) cy=H
  mc25 = contact mcon cx=(x13 + 0.055) cy=H
  mc26 = contact mcon cx=(x13 + L + 0.37) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l12
  port A2 in on=l11
  port B1_N in on=l13
  port X out on=l19
end
