# a41o_2: lifted from sky130_fd_sc_hd__a41o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a41o_2 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=n2 b=VNB
  device M1 pmos w=WP l=L d=VPWR g=A3 s=n3 b=VPB
  device M2 pmos w=WP l=L d=n3 g=A4 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n4 g=B1 s=n3 b=VPB
  device M4 nmos w=WN l=L d=n5 g=A3 s=n1 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M6 nmos w=WN l=L d=VGND g=A4 s=n5 b=VNB
  device M7 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M8 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M9 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M11 nmos w=WN l=L d=n4 g=B1 s=VGND b=VNB
  device M12 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB
  device M13 nmos w=WN l=L d=n2 g=A1 s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.44
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L + 0.24) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.33, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6 - 0.065, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7, x7 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l4 = rect li xspan=(x3 - 0.36, x3 - 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.19) net=B1
  l5 = rect li xspan=(x3 + L + 0.1, x4 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP + 0.14) net=A4
  l6 = rect li xspan=(x5 + L - 0.06, x5 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP + 0.14) net=A3
  l7 = rect li xspan=(x5 + L - 0.06, x6 - 0.09) yspan=(pt - WP - 0.05, pt - WP + 0.14) net=A3
  l8 = rect li xspan=(x6 - 0.095, x7 - 0.05) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=A2
  l9 = rect li xspan=(x6 + L + 0.015, x7 - 0.05) yspan=(nb + WN - 0.14, pt - WP + 0.14) net=A2
  l10 = rect li xspan=(x7 + L + 0.045, x7 + L + 0.265) yspan=(nb + WN - 0.155, pt - WP + 0.14) net=A1
  l11 = rect li xspan=(x2 + L + 0.02, x5 - 0.055) yspan=(nb + WN - 0.25, nb + WN - 0.08) net=n4
  l12 = rect li xspan=(x2 + L + 0.02, x2 + L + 0.19) yspan=(nb + WN - 0.25, pt - WP + 0.18) net=n4
  l13 = rect li xspan=(x2 + L + 0.02, x3 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n4
  l14 = rect li xspan=(x3 - 0.305, x3 + 0.03) yspan=(pt - WP + 0.01, pt - 0.06) net=n4
  l15 = rect li xspan=(x3 - 0.265, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=n4
  l16 = rect li xspan=(x4 + L + 0.055, x7 + L + 0.305) yspan=(nb + 0.06, nb + 0.23) net=n4
  l17 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.06, nb + WN - 0.08) net=n4
  l18 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.06, pt - 0.02) net=X
  l19 = rect li xspan=(x1 + L + 0.055, x2 - 0.035) yspan=(nb + WN - 0.13, pt - 0.02) net=X
  l20 = rect li xspan=(x3 + L + 0.055, x7 + L + 0.225) yspan=(pt - WP + 0.31, pt - WP + 0.48) net=n3
  l21 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l22 = rect li xspan=(x5 + L + 0.055, x6 - 0.215) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l23 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.225) yspan=(pt - WP + 0.31, pt - 0.02) net=n3
  l24 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l25 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.305) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l26 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l27 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.06, nb + 0.23) net=n4
  c5 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n4
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.06 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.06 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c10 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c11 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n3
  c12 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.01, pt - 0.06) net=n4
  c14 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.105) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 - 0.195) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.03) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L/2) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 + L + 0.13) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x3 - 0.15) cy=0
  mc5 = contact mcon cx=(x4 - 0.11) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.19) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x2 - 0.13) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.19) cy=H
  mc13 = contact mcon cx=(x3 - 0.15) cy=H
  mc14 = contact mcon cx=(x4 - 0.11) cy=H
  mc15 = contact mcon cx=(x5 - 0.07) cy=H
  mc16 = contact mcon cx=(x6 - 0.19) cy=H
  mc17 = contact mcon cx=(x6 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l9
  port A3 in on=l7
  port A4 in on=l5
  port B1 in on=l4
  port X out on=l18
end
