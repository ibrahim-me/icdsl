# nand3_4: lifted from sky130_fd_sc_hd__nand3_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nand3_4 width=17 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A s=Y b=VNB
  device M1 nmos w=WN l=L d=n2 g=B s=n1 b=VNB
  device M2 nmos w=WN l=L d=n2 g=B s=n1 b=VNB
  device M3 nmos w=WN l=L d=n1 g=A s=Y b=VNB
  device M4 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M5 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M6 nmos w=WN l=L d=VGND g=C s=n2 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M8 nmos w=WN l=L d=n1 g=B s=n2 b=VNB
  device M9 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M11 nmos w=WN l=L d=n2 g=C s=VGND b=VNB
  device M12 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M13 nmos w=WN l=L d=VGND g=C s=n2 b=VNB
  device M14 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M15 nmos w=WN l=L d=n2 g=C s=VGND b=VNB
  device M16 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M17 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M18 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M19 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M20 nmos w=WN l=L d=Y g=A s=n1 b=VNB
  device M21 nmos w=WN l=L d=n1 g=B s=n2 b=VNB
  device M22 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M23 nmos w=WN l=L d=Y g=A s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.8
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x9 - 0.265, x12 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x9 - 0.265, x12 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1 - 0.29, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9 - 0.335, x12 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x5 + L - 0.03, x12 + L + 0.32) yspan=(nb + 0.02, nb + 0.25) net=n1
  l2 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(-0.085, nb + 0.33) net=VGND
  l4 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x1 - 0.31, x8 + L + 0.305) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l6 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l7 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=n2
  l8 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=n2
  l9 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.305) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=n2
  l10 = rect li xspan=(x1 - 0.29, x4 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l11 = rect li xspan=(x5 - 0.09, x8 + L + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l12 = rect li xspan=(x8 + L + 0.37, x12 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l13 = rect li xspan=(x1 + L - 0.03, x12 + L + 0.675) yspan=(pt - WP - 0.04, pt - WP + 0.18) net=Y
  l14 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l15 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l16 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l17 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l18 = rect li xspan=(x9 + L - 0.03, x12 + L + 0.675) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=Y
  l19 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l20 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l21 = rect li xspan=(x12 + L + 0.445, x12 + L + 0.675) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l22 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  l23 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l24 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l25 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l26 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l27 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x12 + L + 0.055, x12 + L + 0.32) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n2
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n1
  c6 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n1
  c7 = array licon in=nd2 cx=(x9 - 0.14) span=(nb + 0.02, nb + 0.25) net=n1
  c8 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.02, nb + 0.25) margin=0.04 net=n1
  c9 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.02, nb + 0.25) net=n1
  c10 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=n2
  c11 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=n2
  c12 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) net=n2
  c13 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=Y
  c14 = array licon in=nd2 cx=(x11 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c17 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c18 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c19 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c20 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c21 = array licon in=pd2 cx=(x11 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=Y
  c22 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c25 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c26 = array licon in=pd2 cx=(x9 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c27 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c28 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.125) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x1 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + L + 0.14) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.14) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x9 - 0.17) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x9 + L + 0.135) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x10 + L + 0.14) cy=(nb + WN + 0.275)
  gc11 = contact licon cx=(x11 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x12 + L + 0.76) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 + 0.035) cy=0
  mc7 = contact mcon cx=(x7 + L/2) cy=0
  mc8 = contact mcon cx=(x8 + L - 0.035) cy=0
  mc9 = contact mcon cx=(x9 - 0.37) cy=0
  mc10 = contact mcon cx=(x9 + L - 0.055) cy=0
  mc11 = contact mcon cx=(x10 + L - 0.015) cy=0
  mc12 = contact mcon cx=(x11 + L + 0.03) cy=0
  mc13 = contact mcon cx=(x12 + L + 0.07) cy=0
  mc14 = contact mcon cx=(x12 + L + 0.53) cy=0
  mc15 = contact mcon cx=(x1 - 0.17) cy=H
  mc16 = contact mcon cx=(x2 - 0.13) cy=H
  mc17 = contact mcon cx=(x3 - 0.09) cy=H
  mc18 = contact mcon cx=(x4 - 0.05) cy=H
  mc19 = contact mcon cx=(x5 - 0.01) cy=H
  mc20 = contact mcon cx=(x6 + 0.035) cy=H
  mc21 = contact mcon cx=(x7 + L/2) cy=H
  mc22 = contact mcon cx=(x8 + L - 0.035) cy=H
  mc23 = contact mcon cx=(x9 - 0.37) cy=H
  mc24 = contact mcon cx=(x9 + L - 0.055) cy=H
  mc25 = contact mcon cx=(x10 + L - 0.015) cy=H
  mc26 = contact mcon cx=(x11 + L + 0.03) cy=H
  mc27 = contact mcon cx=(x12 + L + 0.07) cy=H
  mc28 = contact mcon cx=(x12 + L + 0.53) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l12
  port B in on=l11
  port C in on=l10
  port Y out on=l18
end
