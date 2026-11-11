# buf_8: lifted from sky130_fd_sc_hd__buf_8 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell buf_8 width=15 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M2 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M4 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M6 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M7 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M8 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M11 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M12 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M13 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M14 nmos w=WN l=L d=VGND g=A s=n1 b=VNB
  device M15 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M16 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M17 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M18 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M19 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M20 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M21 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
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
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x11 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x11 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.26, x1 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1 - 0.26, x3 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x11 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l4 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l5 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l6 = rect li xspan=(x11 + L - 0.03, x11 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND
  l7 = rect li xspan=(x1 - 0.26, x3 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l8 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n1
  l9 = rect li xspan=(x1 - 0.305, x4 - 0.065) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n1
  l10 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l11 = rect li xspan=(x1 - 0.225, x4 - 0.065) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l12 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP - 0.04, pt - 0.02) net=n1
  l13 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.025, nb + WN + 0.02) net=n1
  l14 = rect li xspan=(x3 + L + 0.04, x4 - 0.065) yspan=(nb + WN - 0.15, pt - WP + 0.13) net=n1
  l15 = rect li xspan=(x3 + L + 0.04, x10 - 0.135) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l16 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l17 = rect li xspan=(x4 + L + 0.055, x11 - 0.055) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=X
  l18 = rect li xspan=(x4 + L + 0.055, x11 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=X
  l19 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l20 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l21 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l22 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l23 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l24 = rect li xspan=(x10 + L - 0.035, x11 - 0.055) yspan=(nb + WN - 0.15, pt - WP + 0.13) net=X
  l25 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(nb + 0.02, pt - 0.02) net=X
  l26 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l27 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l29 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l30 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l31 = rect li xspan=(x11 + L - 0.03, x11 + L + 0.305) yspan=(pt - WP, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x11 + L + 0.14) span=(-0.085, nb + WN) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x9 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c8 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.025 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c10 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x8 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=nd1 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c13 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.04, pt - 0.02) net=n1
  c14 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.04, pt - 0.02) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x11 + L + 0.14) span=(pt - WP, H + 0.085) net=VPWR
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c17 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c18 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c19 = array licon in=pd1 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c20 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c24 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.095) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x1 + L + 0.105) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x2 + L + 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.04) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L - 0.045) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + 0.025) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 - 0.06) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x7 + L + 0.14) cy=(nb + WN + 0.275)
  gc9 = contact licon cx=(x8 + L + 0.06) cy=(nb + WN + 0.275)
  gc10 = contact licon cx=(x9 + L - 0.025) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x11 + L + 0.78) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x6 + 0.035) cy=0
  mc7 = contact mcon cx=(x7 + L/2) cy=0
  mc8 = contact mcon cx=(x8 + L - 0.035) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.01) cy=0
  mc10 = contact mcon cx=(x10 + L + 0.05) cy=0
  mc11 = contact mcon cx=(x11 + L + 0.09) cy=0
  mc12 = contact mcon cx=(x11 + L + 0.55) cy=0
  mc13 = contact mcon cx=(x1 - 0.17) cy=H
  mc14 = contact mcon cx=(x2 - 0.13) cy=H
  mc15 = contact mcon cx=(x3 - 0.09) cy=H
  mc16 = contact mcon cx=(x4 - 0.05) cy=H
  mc17 = contact mcon cx=(x5 - 0.01) cy=H
  mc18 = contact mcon cx=(x6 + 0.035) cy=H
  mc19 = contact mcon cx=(x7 + L/2) cy=H
  mc20 = contact mcon cx=(x8 + L - 0.035) cy=H
  mc21 = contact mcon cx=(x9 + L + 0.01) cy=H
  mc22 = contact mcon cx=(x10 + L + 0.05) cy=H
  mc23 = contact mcon cx=(x11 + L + 0.09) cy=H
  mc24 = contact mcon cx=(x11 + L + 0.55) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l7
  port X out on=l17
end
