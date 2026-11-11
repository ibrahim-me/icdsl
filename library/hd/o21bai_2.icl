# o21bai_2: lifted from sky130_fd_sc_hd__o21bai_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell o21bai_2 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=n1 s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=VGND g=B1_N s=n1 b=VNB
  device M2 pmos w=WP2 l=L d=n1 g=B1_N s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n2 g=A2 s=Y b=VPB
  device M4 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M6 pmos w=WP l=L d=Y g=A2 s=n2 b=VPB
  device M7 nmos w=WN l=L d=Y g=n1 s=n3 b=VNB
  device M8 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M10 nmos w=WN l=L d=n3 g=n1 s=Y b=VNB
  device M11 pmos w=WP l=L d=VPWR g=n1 s=Y b=VPB
  device M12 nmos w=WN l=L d=n3 g=A1 s=VGND b=VNB
  device M13 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.345
  x3 = x2 + L + 0.28
  x4 = x3 + 0.1
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.08) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x2 + L + 0.115, x9 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 - 0.115) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 + L + 0.08, x5 - 0.115) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x5 + L + 0.015, x9 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.23, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x2, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x8, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l3 = rect li xspan=(x8 + L + 0.055, x9 - 0.055) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l4 = rect li xspan=(x2 + L + 0.045, x6 + 0.03) yspan=(nb + 0.02, nb + 0.23 + 0.01) net=n3
  l5 = rect li xspan=(x2 + L + 0.045, x3 + 0.05) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l6 = rect li xspan=(x5 + L + 0.055, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l7 = rect li xspan=(x5 + L + 0.055, x9 + L + 0.33) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=n3
  l8 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n3
  l9 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.33) yspan=(nb + 0.03, nb + WN + 0.02) net=n3
  l10 = rect li xspan=(x5 + L - 0.025, x8 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l11 = rect li xspan=(x8 + L + 0.03, x9 + L + 0.405) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l12 = rect li xspan=(x1 - 0.32, x1 + L - 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1_N
  l13 = rect li xspan=(x1 - 0.225, x2 - 0.025) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l14 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP + 0.01, pt - 0.58 + 0.01) net=n1
  l15 = rect li xspan=(x1 + L + 0.055, x2 - 0.025) yspan=(nb + 0.23 - 0.02, nb + WN - 0.06) net=n1
  l16 = rect li xspan=(x1 + L + 0.15, x2 - 0.025) yspan=(nb + 0.23 - 0.02, pt - WP + 0.18) net=n1
  l17 = rect li xspan=(x1 + L + 0.15, x3 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l18 = rect li xspan=(x2 + L + 0.055, x7 - 0.02) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=Y
  l19 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=Y
  l20 = rect li xspan=(x4 + L - 0.03, x5 - 0.05) yspan=(nb + 0.23 + 0.18, pt - WP + 0.13) net=Y
  l21 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.23 + 0.18, nb + WN + 0.02) net=Y
  l22 = rect li xspan=(x6 + L + 0.015, x7 - 0.02) yspan=(pt - WP - 0.04, pt - 0.58 + 0.22) net=Y
  l23 = rect li xspan=(x5 + L - 0.02, x6 - 0.015) yspan=(pt - 0.58 - 0.11, pt - 0.02) net=n2
  l24 = rect li xspan=(x5 + L - 0.02, x8 - 0.055) yspan=(pt - 0.19, pt - 0.02) net=n2
  l25 = rect li xspan=(x7 + L + 0.055, x9 + L + 0.33) yspan=(pt - WP - 0.03, pt - WP + 0.18) net=n2
  l26 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l27 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.33) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l28 = rect li xspan=(x1 + L + 0.04, x2 + 0.03) yspan=(pt - 0.58 - 0.03, H + 0.085) net=VPWR
  l29 = rect li xspan=(x3 + L + 0.015, x5 - 0.11) yspan=(pt - 0.58 - 0.11, H + 0.085) net=VPWR
  l30 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x3 - 0.04) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c2 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n3
  c3 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n3
  c5 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd2 cx=(x9 + L + 0.14) span=(nb + 0.03, nb + WN + 0.02) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c8 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.23 - 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c9 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.23 + 0.18 + 0.08, pt - WP + 0.13 - 0.08) margin=0.04 net=Y
  c10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c11 = array licon in=pd3 cx=(x6 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.58 + 0.22 - 0.08) margin=0.04 net=Y
  c12 = array licon in=pd3 cx=(x7 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c13 = array licon in=pd3 cx=(x9 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 + 0.01 - 0.08) net=n1
  c15 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - 0.58 - 0.03, H + 0.085) net=VPWR
  c16 = array licon in=pd2 cx=(x4 + L + 0.04) span=(pt - 0.58 - 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  c17 = array licon in=pd3 cx=(x5 + L + 0.14) span=(pt - 0.58 - 0.11 + 0.08, pt - 0.02 - 0.08) net=n2
  c18 = array licon in=pd3 cx=(x8 + L + 0.14) span=(pt - 0.58 - 0.07, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.05) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x9 - 0.085) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x9 + L + 0.49) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.12) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.06) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.1) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x8 - 0.1) cy=0
  mc8 = contact mcon cx=(x9 - 0.06) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.26) cy=0
  mc10 = contact mcon cx=(x1 - 0.175) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.12) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.06) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.1) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.14) cy=H
  mc16 = contact mcon cx=(x8 - 0.1) cy=H
  mc17 = contact mcon cx=(x9 - 0.06) cy=H
  mc18 = contact mcon cx=(x9 + L + 0.26) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l11
  port A2 in on=l10
  port B1_N in on=l12
  port Y out on=l18
end
