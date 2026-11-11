# inv_12: lifted from sky130_fd_sc_hd__inv_12 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell inv_12 width=16 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M2 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M4 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M5 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M7 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M8 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M9 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M10 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M11 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M13 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M14 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M15 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M16 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M17 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M18 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M19 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M20 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M21 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M22 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M23 pmos w=WP l=L d=VPWR g=A s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.565
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
  nd1 = rect diff xspan=(x1 - 0.265, x12 + L + 0.52) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x12 + L + 0.52) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x12 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l5 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l6 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l7 = rect li xspan=(x12 + L + 0.23, x12 + L + 0.57) yspan=(-0.085, nb + 0.31) net=VGND
  l8 = rect li xspan=(x1 + L - 0.03, x12 + L - 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l9 = rect li xspan=(x1 - 0.48, x12 + L + 0.57) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=Y
  l10 = rect li xspan=(x1 - 0.48, x1 - 0.055) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=Y
  l11 = rect li xspan=(x1 - 0.48, x12 + L + 0.57) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l12 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l13 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l14 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l16 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l17 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l18 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l19 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l20 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l21 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l22 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l23 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l24 = rect li xspan=(x12 + L + 0.22, x12 + L + 0.57) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=Y
  l25 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l26 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l27 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l29 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l30 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l31 = rect li xspan=(x12 + L + 0.23, x12 + L + 0.57) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c10 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c11 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c12 = array licon in=nd1 cx=(x11 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c13 = array licon in=nd1 cx=(x12 + L + 0.395) span=(-0.085, nb + 0.31) net=VGND
  c14 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c17 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c19 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c20 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c21 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c26 = array licon in=pd1 cx=(x12 + L + 0.395) span=(pt - 0.65, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x4 + L + 0.14) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x5 + L + 0.14) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x6 + L + 0.14) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x7 + L + 0.14) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x8 + L + 0.14) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=(x9 + L + 0.14) cy=(pt - WP - 0.325)
  gc10 = contact licon cx=(x10 + L + 0.14) cy=(pt - WP - 0.325)
  gc11 = contact licon cx=(x11 + L + 0.14) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.565, x12 + L + 0.655) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.335) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.02) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.025) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.065) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.105) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x7 - 0.095) cy=0
  mc8 = contact mcon cx=(x8 - 0.055) cy=0
  mc9 = contact mcon cx=(x9 - 0.015) cy=0
  mc10 = contact mcon cx=(x10 + 0.03) cy=0
  mc11 = contact mcon cx=(x11 + 0.07) cy=0
  mc12 = contact mcon cx=(x12 + L - 0.04) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.425) cy=0
  mc14 = contact mcon cx=(x1 - 0.335) cy=H
  mc15 = contact mcon cx=(x1 + L - 0.02) cy=H
  mc16 = contact mcon cx=(x2 + L + 0.025) cy=H
  mc17 = contact mcon cx=(x3 + L + 0.065) cy=H
  mc18 = contact mcon cx=(x4 + L + 0.105) cy=H
  mc19 = contact mcon cx=(x6 - 0.135) cy=H
  mc20 = contact mcon cx=(x7 - 0.095) cy=H
  mc21 = contact mcon cx=(x8 - 0.055) cy=H
  mc22 = contact mcon cx=(x9 - 0.015) cy=H
  mc23 = contact mcon cx=(x10 + 0.03) cy=H
  mc24 = contact mcon cx=(x11 + 0.07) cy=H
  mc25 = contact mcon cx=(x12 + L - 0.04) cy=H
  mc26 = contact mcon cx=(x12 + L + 0.425) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port Y out on=l24
end
