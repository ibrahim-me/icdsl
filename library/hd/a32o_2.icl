# a32o_2: lifted from sky130_fd_sc_hd__a32o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a32o_2 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=n2 b=VNB
  device M1 nmos w=WN l=L d=VGND g=B2 s=n3 b=VNB
  device M2 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n5 g=B1 s=n4 b=VPB
  device M4 pmos w=WP l=L d=n4 g=B2 s=n5 b=VPB
  device M5 nmos w=WN l=L d=n3 g=B1 s=n5 b=VNB
  device M6 nmos w=WN l=L d=n5 g=A1 s=n1 b=VNB
  device M7 pmos w=WP l=L d=n4 g=A3 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=X g=n5 s=VGND b=VNB
  device M9 nmos w=WN l=L d=VGND g=n5 s=X b=VNB
  device M10 pmos w=WP l=L d=VPWR g=A2 s=n4 b=VPB
  device M11 pmos w=WP l=L d=X g=n5 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=VPWR g=n5 s=X b=VPB
  device M13 nmos w=WN l=L d=n2 g=A3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.655
  x4 = x3 + 0.145
  x5 = x4 + L + 0.22
  x6 = x5 + 0.06
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.44
  x9 = x8 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.12, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2 + L + 0.27, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x7 + L + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8 - 0.065, x8 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.31) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l4 = rect li xspan=(x2 + L + 0.155, x3 - 0.085) yspan=(nb + WN - 0.14, pt - WP - 0.21) net=B2
  l5 = rect li xspan=(x7 + L - 0.06, x8 - 0.195) yspan=(nb + WN + 0.07, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x7 + L + 0.015, x8 - 0.195) yspan=(nb + 0.18, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x7 + L + 0.015, x8 - 0.075) yspan=(nb + 0.18, nb + WN - 0.275) net=A1
  l8 = rect li xspan=(x5 - 0.035, x7 - 0.085) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=B1
  l9 = rect li xspan=(x6 + L + 0.025, x7 - 0.085) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l10 = rect li xspan=(x6 + L + 0.025, x7 - 0.05) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B1
  l11 = rect li xspan=(x8 - 0.015, x9 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l12 = rect li xspan=(x8 + L - 0.02, x9 - 0.055) yspan=(nb + 0.19, pt - WP + 0.14) net=A2
  l13 = rect li xspan=(x9 + L + 0.075, x9 + L + 0.315) yspan=(nb + WN + 0.11, pt - WP + 0.145) net=A3
  l14 = rect li xspan=(x1 + L - 0.01, x2 - 0.115) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=n5
  l15 = rect li xspan=(x1 + L - 0.01, x5 + 0.01) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n5
  l16 = rect li xspan=(x4 - 0.055, x4 + L - 0.015) yspan=(nb + 0.38, pt - WP + 0.13) net=n5
  l17 = rect li xspan=(x4 - 0.055, x7 - 0.015) yspan=(nb + 0.38, nb + WN - 0.1) net=n5
  l18 = rect li xspan=(x4 + L - 0.03, x5 + 0.01) yspan=(pt - WP - 0.04, pt - 0.37) net=n5
  l19 = rect li xspan=(x4 + L - 0.03, x6 + 0.03) yspan=(pt - WP + 0.46, pt - 0.37) net=n5
  l20 = rect li xspan=(x5 + L - 0.01, x7 - 0.015) yspan=(nb + 0.04, nb + WN - 0.1) net=n5
  l21 = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(nb + 0.42, pt - 0.02) net=X
  l22 = rect li xspan=(x1 - 0.265, x2 + 0.03) yspan=(nb + 0.42, nb + WN - 0.06) net=X
  l23 = rect li xspan=(x1 - 0.265, x2 + L + 0.225) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=X
  l24 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.225) yspan=(pt - WP + 0.3, pt - 0.02) net=X
  l25 = rect li xspan=(x3 - 0.08, x4 - 0.05) yspan=(pt - WP + 0.3, pt - 0.02) net=n4
  l26 = rect li xspan=(x3 - 0.08, x7 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n4
  l27 = rect li xspan=(x6 + L + 0.055, x9 - 0.055) yspan=(pt - WP + 0.31, pt - WP + 0.48) net=n4
  l28 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l29 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n4
  l30 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l31 = rect li xspan=(x7 + L - 0.03, x8 - 0.135) yspan=(pt - 0.345, H + 0.085) net=VPWR
  l32 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.31) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 - 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x6 + L + 0.1) span=(nb + 0.04, nb + WN - 0.1) margin=0.04 net=n5
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.23) net=VGND
  c5 = array licon in=nd1 cx=(x9 + L + 0.14) span=(-0.085, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.42, nb + WN - 0.06) margin=0.04 net=X
  c7 = array licon in=pd2 cx=(x5 - 0.08) span=(pt - WP - 0.04 + 0.08, pt - 0.37 - 0.08) margin=0.04 net=n5
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.42 + 0.08, pt - 0.02 - 0.08) net=X
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=X
  c10 = array licon in=pd2 cx=(x3 + 0.01) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n4
  c11 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c12 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c13 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.57, H + 0.085) net=VPWR
  c14 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.36, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.345, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.08) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 - 0.25) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.03) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + L/2) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 + L + 0.16) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.19) cy=0
  mc4 = contact mcon cx=x3 cy=0
  mc5 = contact mcon cx=(x5 - 0.05) cy=0
  mc6 = contact mcon cx=(x7 - 0.07) cy=0
  mc7 = contact mcon cx=(x8 - 0.19) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x2 - 0.13) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.19) cy=H
  mc13 = contact mcon cx=x3 cy=H
  mc14 = contact mcon cx=(x5 - 0.05) cy=H
  mc15 = contact mcon cx=(x7 - 0.07) cy=H
  mc16 = contact mcon cx=(x8 - 0.19) cy=H
  mc17 = contact mcon cx=(x8 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l12
  port A3 in on=l13
  port B1 in on=l9
  port B2 in on=l4
  port X out on=l21
end
