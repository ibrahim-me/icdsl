# maj3_4: lifted from sky130_fd_sc_hd__maj3_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell maj3_4 width=14 height=H taps=no
  device M0 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n1 g=C s=n2 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M4 nmos w=WN l=L d=n1 g=B s=n3 b=VNB
  device M5 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=n4 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n2 g=A s=VGND b=VNB
  device M8 nmos w=WN l=L d=n5 g=B s=n1 b=VNB
  device M9 pmos w=WP l=L d=n6 g=B s=n1 b=VPB
  device M10 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M11 pmos w=WP l=L d=n1 g=C s=n4 b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A s=n6 b=VPB
  device M13 nmos w=WN l=L d=VGND g=A s=n5 b=VNB
  device M14 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M15 pmos w=WP l=L d=n1 g=B s=n7 b=VPB
  device M16 pmos w=WP l=L d=n7 g=C s=VPWR b=VPB
  device M17 nmos w=WN l=L d=n3 g=C s=VGND b=VNB
  device M18 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M19 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.61
  x2 = x1 + L + 0.255
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.22
  x7 = x6 + L + 0.495
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.375, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.185, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.255) net=VGND
  l2 = rect li xspan=(x6 + L + 0.095, x7 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(-0.085, nb + 0.31) net=VGND
  l5 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l6 = rect li xspan=(x2 + 0.06, x3 + 0.03) yspan=(nb + WN + 0.19, pt - WP + 0.15) net=A
  l7 = rect li xspan=(x1 - 0.185, x2 - 0.115) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=C
  l8 = rect li xspan=(x1 + L - 0.035, x2 - 0.115) yspan=(nb + WN + 0.19, pt - WP + 0.6) net=C
  l9 = rect li xspan=(x1 + L - 0.035, x4 - 0.055) yspan=(pt - WP + 0.43, pt - WP + 0.6) net=C
  l10 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.43, pt - 0.09) net=C
  l11 = rect li xspan=(x3 + L + 0.055, x6 + 0.01) yspan=(pt - 0.26, pt - 0.09) net=C
  l12 = rect li xspan=(x5 + L + 0.055, x6 + 0.01) yspan=(nb + WN + 0.19, pt - 0.09) net=C
  l13 = rect li xspan=(x5 + L + 0.055, x6 + L + 0.18) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=C
  l14 = rect li xspan=(x1 - 0.525, x1 + 0.03) yspan=(nb + 0.02, nb + WN) net=n1
  l15 = rect li xspan=(x1 - 0.525, x1 - 0.355) yspan=(nb + 0.02, pt - 0.02) net=n1
  l16 = rect li xspan=(x1 - 0.525, x5 + 0.03) yspan=(nb + WN - 0.225, nb + WN) net=n1
  l17 = rect li xspan=(x1 - 0.525, x7 + 0.03) yspan=(nb + WN - 0.17, nb + WN) net=n1
  l18 = rect li xspan=(x1 - 0.525, x1 - 0.145) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l19 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + WN - 0.225, pt - WP + 0.26) net=n1
  l20 = rect li xspan=(x3 + L + 0.055, x5 + 0.03) yspan=(pt - WP + 0.06, pt - WP + 0.26) net=n1
  l21 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN) net=n1
  l22 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP + 0.06, pt - WP + 0.57) net=n1
  l23 = rect li xspan=(x7 - 0.145, x7 + 0.03) yspan=(nb + WN - 0.17, pt - WP - 0.2) net=n1
  l24 = rect li xspan=(x7 - 0.145, x10 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=n1
  l25 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + 0.255) net=X
  l26 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l27 = rect li xspan=(x7 + L - 0.03, x10 + L + 0.315) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=X
  l28 = rect li xspan=(x7 + L + 0.055, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l29 = rect li xspan=(x7 + L + 0.055, x10 + L + 0.315) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=X
  l30 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l31 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l32 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.315) yspan=(nb + WN - 0.17, pt - WP + 0.14) net=X
  l33 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l34 = rect li xspan=(x6 + L + 0.08, x7 - 0.085) yspan=(pt - WP - 0.03, H + 0.085) net=VPWR
  l35 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l36 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.265) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN) margin=0.04 net=n1
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.255) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x7 - 0.235) span=(-0.085, nb + 0.31) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c7 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x1 - 0.23) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x6 + L + 0.245) span=(pt - WP - 0.03, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.03, pt - 0.02) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP - 0.03, pt - 0.02) margin=0.04 net=X
  c13 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.06, pt - WP + 0.57) margin=0.04 net=n1
  c14 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) net=VPWR
  c16 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.02) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L + 0.14) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x9 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.61, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.38) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.065) cy=0
  mc3 = contact mcon cx=(x2 + L) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.045) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.085) cy=0
  mc6 = contact mcon cx=(x6 - 0.095) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.225) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.05) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.09) cy=0
  mc10 = contact mcon cx=(x9 + L + 0.13) cy=0
  mc11 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc12 = contact mcon cx=(x1 - 0.38) cy=H
  mc13 = contact mcon cx=(x1 + L - 0.065) cy=H
  mc14 = contact mcon cx=(x2 + L) cy=H
  mc15 = contact mcon cx=(x3 + L + 0.045) cy=H
  mc16 = contact mcon cx=(x4 + L + 0.085) cy=H
  mc17 = contact mcon cx=(x6 - 0.095) cy=H
  mc18 = contact mcon cx=(x6 + L + 0.225) cy=H
  mc19 = contact mcon cx=(x7 + L + 0.05) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.09) cy=H
  mc21 = contact mcon cx=(x9 + L + 0.13) cy=H
  mc22 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port B in on=l5
  port C in on=l7
  port X out on=l32
end
