# nand3b_2: lifted from sky130_fd_sc_hd__nand3b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand3b_2 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=Y b=VPB
  device M1 pmos w=WP l=L d=Y g=n1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=n1 s=Y b=VNB
  device M3 nmos w=WN l=L d=n3 g=B s=n2 b=VNB
  device M4 nmos w=WN l=L d=n3 g=C s=VGND b=VNB
  device M5 pmos w=WP2 l=L d=n1 g=A_N s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=C s=Y b=VPB
  device M8 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M9 nmos w=WN2 l=L d=n1 g=A_N s=VGND b=VNB
  device M10 pmos w=WP l=L d=Y g=C s=VPWR b=VPB
  device M11 nmos w=WN l=L d=VGND g=C s=n3 b=VNB
  device M12 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M13 nmos w=WN l=L d=Y g=n1 s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.405
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + 0.1
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 - 0.015) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x4 - 0.015) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x4 + L + 0.115, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 - 0.115) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x7 - 0.115) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x7 + L + 0.015, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.19) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x7 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x9 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.04, x2 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x4 + 0.03) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l3 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l4 = rect li xspan=(x2 + L - 0.03, x7 + 0.03) yspan=(nb + WN2 + 0.06, nb + WN + 0.02) net=n3
  l5 = rect li xspan=(x4 + L + 0.075, x7 + 0.03) yspan=(nb + WN2 - 0.02, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x4 + L + 0.075, x9 + L + 0.345) yspan=(nb + 0.02, nb + 0.23) net=n2
  l7 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l8 = rect li xspan=(x1 + 0.035, x2 - 0.165) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A_N
  l9 = rect li xspan=(x2 + L - 0.03, x4 - 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=C
  l10 = rect li xspan=(x4 + L + 0.025, x8) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l11 = rect li xspan=(x1 - 0.31, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=n1
  l12 = rect li xspan=(x1 - 0.31, x1 + 0.015) yspan=(nb + 0.02, nb + WN2) net=n1
  l13 = rect li xspan=(x1 - 0.31, x9 + L - 0.06) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n1
  l14 = rect li xspan=(x1 - 0.31, x1 + 0.015) yspan=(pt - WP2, pt - 0.02) net=n1
  l15 = rect li xspan=(x8 + L + 0.035, x9 + L - 0.06) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=n1
  l16 = rect li xspan=(x2 + L - 0.03, x9 + L + 0.345) yspan=(pt - WP + 0.3, pt - WP2 - 0.11) net=Y
  l17 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l18 = rect li xspan=(x2 + L - 0.03, x5 + 0.03) yspan=(pt - WP + 0.3, pt - WP2 - 0.06) net=Y
  l19 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l20 = rect li xspan=(x8 + L - 0.03, x9 + L + 0.345) yspan=(nb + WN2 - 0.02, nb + WN + 0.02) net=Y
  l21 = rect li xspan=(x8 + L - 0.03, x9 - 0.055) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l22 = rect li xspan=(x8 + L - 0.03, x9 + L + 0.345) yspan=(pt - WP + 0.3, pt - WP2 - 0.06) net=Y
  l23 = rect li xspan=(x9 + L + 0.145, x9 + L + 0.345) yspan=(nb + WN2 - 0.02, pt - WP2 - 0.06) net=Y
  l24 = rect li xspan=(x1 + L + 0.04, x2 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  l25 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  l26 = rect li xspan=(x5 + L + 0.05, x7 - 0.075) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  l27 = rect li xspan=(x7 + L - 0.03, x8 - 0.055) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.345) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.2) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.11 - 0.08) net=VGND
  c4 = array licon in=nd3 cx=(x5 - 0.04) span=(nb + 0.02, nb + 0.23) net=n2
  c5 = array licon in=nd3 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n2
  c6 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + 0.23) net=n2
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.08) net=n1
  c8 = array licon in=nd3 cx=(x6 + L + 0.14) span=(nb + WN2 - 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c9 = array licon in=nd3 cx=(x8 + L + 0.14) span=(nb + WN2 - 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c10 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c11 = array licon in=pd2 cx=(x2 - 0.2) span=(pt - WP2 - 0.23 + 0.08, H + 0.085 - 0.08) net=VPWR
  c12 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=Y
  c13 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 + 0.08, pt - 0.02 - 0.08) net=n1
  c15 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c16 = array licon in=pd2 cx=(x6 + L + 0.04) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  c17 = array licon in=pd3 cx=(x7 + L + 0.14) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  c18 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 - 0.09) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.03) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x9 - 0.08) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.435) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.065) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.105) cy=0
  mc5 = contact mcon cx=(x5 - 0.135) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.085) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.125) cy=0
  mc8 = contact mcon cx=(x9 - 0.115) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.205) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.065) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.105) cy=H
  mc14 = contact mcon cx=(x5 - 0.135) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.085) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.125) cy=H
  mc17 = contact mcon cx=(x9 - 0.115) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.205) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l8
  port B in on=l10
  port C in on=l9
  port Y out on=l23
end
