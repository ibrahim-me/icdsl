# o31ai_2: lifted from sky130_fd_sc_hd__o31ai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o31ai_2 width=13 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A3 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M2 pmos w=WP l=L d=n1 g=A2 s=n2 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M4 pmos w=WP l=L d=n2 g=A2 s=n1 b=VPB
  device M5 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=Y g=B1 s=n3 b=VNB
  device M10 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M11 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M12 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M13 pmos w=WP l=L d=Y g=A3 s=n1 b=VPB
  device M14 nmos w=WN l=L d=n3 g=B1 s=Y b=VNB
  device M15 nmos w=WN l=L d=n3 g=A3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.2
  x6 = x5 + L + 0.4
  x7 = x6 + 0.08
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.4
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x5 + 0.07) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 + L + 0.195, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.105, x2 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p8 = rect poly xspan=(x6 - 0.025, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x10 + L + 0.335) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x6 + L - 0.03, x8 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x1 - 0.33, x1 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  l5 = rect li xspan=(x1 - 0.33, x9 + 0.03) yspan=(nb + WN - 0.17, nb + WN) net=n3
  l6 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  l7 = rect li xspan=(x5 + L + 0.015, x6 - 0.055) yspan=(nb + 0.02, nb + WN) net=n3
  l8 = rect li xspan=(x8 + L - 0.03, x10 + L + 0.355) yspan=(nb + 0.02, nb + 0.19) net=n3
  l9 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  l10 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.355) yspan=(nb + 0.02, nb + 0.35) net=n3
  l11 = rect li xspan=(x1 - 0.33, x3 - 0.02) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A1
  l12 = rect li xspan=(x3 + L + 0.01, x5 + L + 0.06) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A2
  l13 = rect li xspan=(x6 - 0.17, x8 + L) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A3
  l14 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.355) yspan=(nb + WN - 0.13, pt - WP - 0.16) net=B1
  l15 = rect li xspan=(x1 - 0.33, x5 + L - 0.04) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l16 = rect li xspan=(x1 - 0.33, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l17 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l18 = rect li xspan=(x4 + L - 0.03, x5 + L - 0.04) yspan=(pt - WP + 0.01, pt - WP + 0.64) net=n2
  l19 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.35, pt - 0.02) net=n1
  l20 = rect li xspan=(x3 + L + 0.055, x8 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n1
  l21 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - 0.65, pt - 0.02) net=n1
  l22 = rect li xspan=(x5 + L + 0.175, x10 + L + 0.355) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l23 = rect li xspan=(x5 + L + 0.175, x7 + 0.03) yspan=(pt - WP + 0.01, pt - 0.36) net=Y
  l24 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l25 = rect li xspan=(x9 + L + 0.055, x10 - 0.015) yspan=(nb + WN - 0.29, pt - WP + 0.18) net=Y
  l26 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.355) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l27 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L + 0.055, x10 - 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN) margin=0.04 net=n3
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) margin=0.04 net=n3
  c3 = array licon in=nd1 cx=(x5 + L + 0.18) span=(nb + 0.02, nb + WN) margin=0.04 net=n3
  c4 = array licon in=nd1 cx=(x7 + L + 0.06) span=(-0.085, nb + 0.31) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + 0.02, nb + WN) margin=0.04 net=n3
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x4 + L + 0.06) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, nb + 0.35 - 0.08) net=n3
  c10 = array licon in=nd1 cx=(x10 - 0.18) span=(nb + WN - 0.29, pt - WP + 0.18) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n2
  c12 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n2
  c13 = array licon in=pd1 cx=(x5 - 0.06) span=(pt - WP + 0.01, pt - WP + 0.64) net=n2
  c14 = array licon in=pd2 cx=(x6 - 0.06) span=(pt - WP + 0.01, pt - 0.36) margin=0.04 net=Y
  c15 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c16 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  c17 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c18 = array licon in=pd2 cx=(x10 - 0.18) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c19 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c20 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.65 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 + 0.065) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.105) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.095) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L - 0.005) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 - 0.02) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + L + 0.2) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x10 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x4 - 0.07) cy=0
  mc5 = contact mcon cx=(x5 + 0.055) cy=0
  mc6 = contact mcon cx=(x6 - 0.03) cy=0
  mc7 = contact mcon cx=(x8 - 0.07) cy=0
  mc8 = contact mcon cx=(x9 - 0.03) cy=0
  mc9 = contact mcon cx=(x10 - 0.11) cy=0
  mc10 = contact mcon cx=(x10 + L + 0.21) cy=0
  mc11 = contact mcon cx=(x1 - 0.19) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x3 - 0.11) cy=H
  mc14 = contact mcon cx=(x4 - 0.07) cy=H
  mc15 = contact mcon cx=(x5 + 0.055) cy=H
  mc16 = contact mcon cx=(x6 - 0.03) cy=H
  mc17 = contact mcon cx=(x8 - 0.07) cy=H
  mc18 = contact mcon cx=(x9 - 0.03) cy=H
  mc19 = contact mcon cx=(x10 - 0.11) cy=H
  mc20 = contact mcon cx=(x10 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l11
  port A2 in on=l12
  port A3 in on=l13
  port B1 in on=l14
  port Y out on=l26
end
