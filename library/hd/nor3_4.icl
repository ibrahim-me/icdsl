# nor3_4: lifted from sky130_fd_sc_hd__nor3_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nor3_4 width=16 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M1 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M4 pmos w=WP l=L d=n2 g=B s=n1 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M6 pmos w=WP l=L d=n2 g=B s=n1 b=VPB
  device M7 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M8 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M9 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M10 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M11 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M12 nmos w=WN l=L d=VGND g=C s=Y b=VNB
  device M13 pmos w=WP l=L d=n2 g=C s=Y b=VPB
  device M14 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M15 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M16 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M17 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M18 pmos w=WP l=L d=Y g=C s=n2 b=VPB
  device M19 pmos w=WP l=L d=Y g=C s=n2 b=VPB
  device M20 pmos w=WP l=L d=n2 g=C s=Y b=VPB
  device M21 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M22 nmos w=WN l=L d=VGND g=C s=Y b=VNB
  device M23 nmos w=WN l=L d=VGND g=B s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x12 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x12 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8, x11 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x12 - 0.045, x12 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l7 = rect li xspan=(x12 + L + 0.055, x12 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l8 = rect li xspan=(x9 + L - 0.07, x11 + L) yspan=(nb + WN + 0.19, nb + WN + 0.39) net=C
  l9 = rect li xspan=(x1 - 0.33, x4 + L) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A
  l10 = rect li xspan=(x5, x9 - 0.095) yspan=(nb + WN + 0.19, nb + WN + 0.4) net=B
  l11 = rect li xspan=(x8 + L + 0.015, x9 - 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l12 = rect li xspan=(x8 + L + 0.015, x12 + L - 0.02) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B
  l13 = rect li xspan=(x12 - 0.045, x12 + L + 0.235) yspan=(nb + WN + 0.19, nb + WN + 0.4) net=B
  l14 = rect li xspan=(x12 - 0.045, x12 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l15 = rect li xspan=(x1 - 0.27, x5 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l16 = rect li xspan=(x1 - 0.27, x1 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l17 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l18 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l19 = rect li xspan=(x4 + L + 0.015, x7 - 0.015) yspan=(pt - 0.4, pt - 0.02) net=n1
  l20 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.69, pt - 0.02) net=n1
  l21 = rect li xspan=(x5 + L + 0.015, x8 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n2
  l22 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.43) net=n2
  l23 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l24 = rect li xspan=(x7 + L + 0.015, x12 - 0.015) yspan=(pt - 0.19, pt - 0.02) net=n2
  l25 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(pt - 0.35, pt - 0.02) net=n2
  l26 = rect li xspan=(x11 + L + 0.015, x12 - 0.015) yspan=(pt - 0.35, pt - 0.02) net=n2
  l27 = rect li xspan=(x12 + L + 0.015, x12 + L + 0.265) yspan=(pt - 0.36, pt - 0.02) net=n1
  l28 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l29 = rect li xspan=(x1 + L - 0.03, x12 + L + 0.715) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l30 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l31 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l32 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l33 = rect li xspan=(x8 + L + 0.015, x12 + L + 0.715) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=Y
  l34 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - WP + 0.3, pt - 0.36) net=Y
  l35 = rect li xspan=(x8 + L + 0.015, x11 - 0.015) yspan=(pt - WP + 0.3, pt - WP + 0.48) net=Y
  l36 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l37 = rect li xspan=(x10 + L + 0.015, x11 - 0.015) yspan=(pt - WP + 0.3, pt - 0.36) net=Y
  l38 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l39 = rect li xspan=(x12 + L + 0.425, x12 + L + 0.715) yspan=(nb + 0.02, pt - WP + 0.47) net=Y
  l40 = rect li xspan=(x12 + L + 0.435, x12 + L + 0.715) yspan=(nb + 0.02, pt - 0.02) net=Y
  l41 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l42 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c11 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd1 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c13 = array licon in=nd1 cx=(x12 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c17 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.43 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c19 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.69 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c22 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c23 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=Y
  c24 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c25 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c26 = array licon in=pd1 cx=(x12 + L + 0.14) span=(pt - 0.36 + 0.08, pt - 0.02 - 0.08) net=n1
  gc1 = contact licon cx=(x1 + L + 0.02) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.005) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.08) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L - 0.065) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + 0.005) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x11 - 0.08) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x12 + L - 0.025) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x12 + L + 0.8) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x4 - 0.07) cy=0
  mc5 = contact mcon cx=(x5 - 0.03) cy=0
  mc6 = contact mcon cx=(x6 + 0.015) cy=0
  mc7 = contact mcon cx=(x7 + 0.055) cy=0
  mc8 = contact mcon cx=(x8 + L - 0.055) cy=0
  mc9 = contact mcon cx=(x9 + L - 0.015) cy=0
  mc10 = contact mcon cx=(x10 + L + 0.03) cy=0
  mc11 = contact mcon cx=(x11 + L + 0.07) cy=0
  mc12 = contact mcon cx=(x12 + L + 0.11) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.57) cy=0
  mc14 = contact mcon cx=(x6 + 0.015) cy=(pt - 0.275)
  mc15 = contact mcon cx=(x12 + L + 0.11) cy=(pt - 0.275)
  mc16 = contact mcon cx=(x1 - 0.19) cy=H
  mc17 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x3 - 0.11) cy=H
  mc19 = contact mcon cx=(x4 - 0.07) cy=H
  mc20 = contact mcon cx=(x5 - 0.03) cy=H
  mc21 = contact mcon cx=(x6 + 0.015) cy=H
  mc22 = contact mcon cx=(x7 + 0.055) cy=H
  mc23 = contact mcon cx=(x8 + L - 0.055) cy=H
  mc24 = contact mcon cx=(x9 + L - 0.015) cy=H
  mc25 = contact mcon cx=(x10 + L + 0.03) cy=H
  mc26 = contact mcon cx=(x11 + L + 0.07) cy=H
  mc27 = contact mcon cx=(x12 + L + 0.11) cy=H
  mc28 = contact mcon cx=(x12 + L + 0.57) cy=H
  w1 = rect m1 xspan=(x6 - 0.135, x6 + L + 0.02) yspan=(pt - WP + 0.58, pt - 0.15) net=n1
  w2 = rect m1 xspan=(x6 - 0.135, x12 + L + 0.26) yspan=(pt - WP + 0.655, pt - 0.205) net=n1
  w3 = rect m1 xspan=(x12 + L - 0.04, x12 + L + 0.26) yspan=(pt - WP + 0.58, pt - 0.15) net=n1
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l9
  port B in on=l10
  port C in on=l8
  port Y out on=l39
end
