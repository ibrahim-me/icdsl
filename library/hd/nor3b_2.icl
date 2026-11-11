# nor3b_2: lifted from sky130_fd_sc_hd__nor3b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nor3b_2 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M1 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M2 pmos w=WP l=L d=n2 g=B s=n1 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M4 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M5 pmos w=WP l=L d=Y g=n3 s=n2 b=VPB
  device M6 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M8 pmos w=WP l=L d=n2 g=n3 s=Y b=VPB
  device M9 nmos w=WN l=L d=Y g=n3 s=VGND b=VNB
  device M10 pmos w=WP2 l=L d=n3 g=C_N s=VPWR b=VPB
  device M11 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M12 nmos w=WN l=L d=VGND g=n3 s=Y b=VNB
  device M13 nmos w=WN2 l=L d=n3 g=C_N s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.84
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.84
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.285) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x7 - 0.265, x7 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  pd1 = rect diff xspan=(x7 - 0.265, x7 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 - 0.285, x4 + L + 0.285) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x5 - 0.285, x6 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x7, x7 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p2 = rect poly xspan=(x7, x7 + L + 0.13) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x6 + L + 0.315) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.23 + 0.09) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.26) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l5 = rect li xspan=(x7 + L + 0.015, x7 + L + 0.305) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l6 = rect li xspan=(x1 - 0.31, x2 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A
  l7 = rect li xspan=(x3 - 0.125, x5 - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B
  l8 = rect li xspan=(x7 - 0.03, x7 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=C_N
  l9 = rect li xspan=(x6 + L + 0.015, x7 - 0.2) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=n3
  l10 = rect li xspan=(x7 - 0.37, x7 - 0.2) yspan=(nb + 0.23 - 0.085, pt - 0.58 - 0.035) net=n3
  l11 = rect li xspan=(x7 - 0.37, x7 - 0.015) yspan=(nb + 0.23 - 0.085, nb + WN + 0.02) net=n3
  l12 = rect li xspan=(x7 - 0.37, x7 - 0.015) yspan=(pt - WP - 0.03, pt - 0.58 - 0.035) net=n3
  l13 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l14 = rect li xspan=(x1 + L - 0.03, x6 + 0.03) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l16 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l17 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(nb + 0.02, pt - 0.58 + 0.22) net=Y
  l18 = rect li xspan=(x1 - 0.33, x4 + L + 0.265) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l19 = rect li xspan=(x1 - 0.33, x1 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l20 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l21 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.265) yspan=(pt - WP - 0.03, pt - 0.58 + 0.22) net=n1
  l22 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - 0.58 - 0.11, pt - 0.02) net=n2
  l23 = rect li xspan=(x3 + L + 0.015, x6 + L + 0.26) yspan=(pt - 0.19, pt - 0.02) net=n2
  l24 = rect li xspan=(x5 - 0.285, x5 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l25 = rect li xspan=(x6 + L + 0.015, x6 + L + 0.26) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l26 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.58 - 0.11, H + 0.085) net=VPWR
  l27 = rect li xspan=(x7 + L + 0.015, x7 + L + 0.265) yspan=(pt - WP + 0.055, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) net=VGND
  c6 = array licon in=nd2 cx=(x5 - 0.14) span=(-0.085 + 0.08, nb + 0.23 + 0.09 - 0.08) net=VGND
  c7 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.58 + 0.22 - 0.08) margin=0.04 net=Y
  c8 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) margin=0.04 net=VGND
  c9 = array licon in=nd3 cx=(x7 - 0.14) span=(nb + 0.23 - 0.085 + 0.08, nb + WN + 0.02 - 0.08) net=n3
  c10 = array licon in=nd3 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c11 = array licon in=pd2 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c13 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.58 + 0.22 - 0.08) margin=0.04 net=n1
  c14 = array licon in=pd3 cx=(x5 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c15 = array licon in=pd3 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.58 + 0.22 - 0.08) margin=0.04 net=Y
  c16 = array licon in=pd3 cx=(x6 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c17 = array licon in=pd1 cx=(x7 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.58 - 0.035 - 0.08) net=n3
  c18 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.055 + 0.08, H + 0.085 - 0.08) net=VPWR
  c19 = array licon in=pd2 cx=(x1 + L + 0.14) span=(pt - 0.58 - 0.11 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - 0.58 - 0.11 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  gc1 = contact licon cx=(x1 + L + 0.085) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.18) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L - 0.01) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x4 - 0.07) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.25) cy=0
  mc6 = contact mcon cx=(x5 - 0.13) cy=0
  mc7 = contact mcon cx=(x6 - 0.09) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.23) cy=0
  mc9 = contact mcon cx=(x7 - 0.15) cy=0
  mc10 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc11 = contact mcon cx=(x1 - 0.19) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x3 - 0.11) cy=H
  mc14 = contact mcon cx=(x4 - 0.07) cy=H
  mc15 = contact mcon cx=(x4 + L + 0.25) cy=H
  mc16 = contact mcon cx=(x5 - 0.13) cy=H
  mc17 = contact mcon cx=(x6 - 0.09) cy=H
  mc18 = contact mcon cx=(x6 + L + 0.23) cy=H
  mc19 = contact mcon cx=(x7 - 0.15) cy=H
  mc20 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port B in on=l7
  port C_N in on=l8
  port Y out on=l16
end
