# a31o_2: lifted from sky130_fd_sc_hd__a31o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a31o_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=n2 b=VNB
  device M1 nmos w=WN l=L d=n2 g=A1 s=n3 b=VNB
  device M2 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=n4 g=B1 s=n3 b=VPB
  device M6 nmos w=WN l=L d=X g=n3 s=VGND b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A3 s=n4 b=VPB
  device M8 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M9 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M10 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M11 pmos w=WP l=L d=n4 g=A2 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.34
  x6 = x5 + L + 0.34
  x7 = x6 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x6, x7 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x2 + L - 0.01, x3 + 0.05) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.315) yspan=(-0.085, nb + 0.33) net=VGND
  l5 = rect li xspan=(x4 - 0.13, x4 + 0.045) yspan=(nb + 0.165, nb + WN - 0.02) net=A2
  l6 = rect li xspan=(x4 - 0.035, x4 + L - 0.01) yspan=(nb + 0.46, pt - WP - 0.225) net=A2
  l7 = rect li xspan=(x4 - 0.035, x4 + L + 0.155) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l8 = rect li xspan=(x2 + L + 0.105, x3 + 0.035) yspan=(nb + WN - 0.125, pt - WP - 0.16) net=A3
  l9 = rect li xspan=(x2 + L + 0.105, x3 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l10 = rect li xspan=(x4 + L + 0.165, x5 + 0.04) yspan=(nb + 0.18, nb + WN - 0.015) net=A1
  l11 = rect li xspan=(x4 + L + 0.165, x5 + L + 0.075) yspan=(nb + WN - 0.185, nb + WN - 0.015) net=A1
  l12 = rect li xspan=(x5 + 0.05, x5 + L + 0.075) yspan=(nb + WN - 0.185, pt - WP - 0.16) net=A1
  l13 = rect li xspan=(x7 + L + 0.075, x7 + L + 0.27) yspan=(nb + WN - 0.13, pt - WP - 0.16) net=B1
  l14 = rect li xspan=(x3 + L - 0.03, x6 + 0.03) yspan=(pt - 0.65, pt - 0.48) net=n4
  l15 = rect li xspan=(x3 + L - 0.03, x4 - 0.055) yspan=(pt - 0.65, pt - 0.06) net=n4
  l16 = rect li xspan=(x5 + L + 0.055, x6 - 0.035) yspan=(pt - 0.65, pt - 0.06) net=n4
  l17 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + WN - 0.17, pt - 0.48) net=X
  l18 = rect li xspan=(x1 - 0.31, x2 - 0.055) yspan=(nb + WN - 0.17, nb + WN) net=X
  l19 = rect li xspan=(x1 - 0.31, x2 - 0.055) yspan=(pt - 0.65, pt - 0.48) net=X
  l20 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.02, nb + WN) net=X
  l21 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - 0.65, pt - 0.02) net=X
  l22 = rect li xspan=(x1 + L + 0.015, x2 - 0.095) yspan=(nb + WN + 0.19, pt - WP + 0.18) net=n3
  l23 = rect li xspan=(x1 + L + 0.015, x2 + 0.07) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n3
  l24 = rect li xspan=(x1 + L + 0.015, x7 + L + 0.225) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l25 = rect li xspan=(x5 + L + 0.095, x7 + 0.03) yspan=(nb + 0.1, nb + WN - 0.38) net=n3
  l26 = rect li xspan=(x6 - 0.16, x7 + 0.03) yspan=(nb + 0.02, nb + WN - 0.38) net=n3
  l27 = rect li xspan=(x6 - 0.085, x7 + 0.03) yspan=(nb + 0.02, pt - WP + 0.18) net=n3
  l28 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.225) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l29 = rect li xspan=(x1 - 0.265, x1 - 0.015) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l30 = rect li xspan=(x2 + L - 0.03, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l31 = rect li xspan=(x4 + L + 0.015, x5 + 0.01) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x6 - 0.08) span=(nb + 0.1, nb + WN - 0.38) margin=0.04 net=n3
  c6 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.65 + 0.08, pt - 0.06 - 0.08) margin=0.04 net=n4
  c7 = array licon in=pd1 cx=(x6 - 0.14) span=(pt - 0.65 + 0.08, pt - 0.06 - 0.08) margin=0.04 net=n4
  c8 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x5 - 0.16) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x2 - 0.1) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.16) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.07) cy=0
  mc6 = contact mcon cx=(x6 - 0.09) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.13) cy=H
  mc10 = contact mcon cx=(x3 - 0.09) cy=H
  mc11 = contact mcon cx=(x4 - 0.05) cy=H
  mc12 = contact mcon cx=(x5 - 0.07) cy=H
  mc13 = contact mcon cx=(x6 - 0.09) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l5
  port A3 in on=l8
  port B1 in on=l13
  port X out on=l17
end
