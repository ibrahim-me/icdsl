# nand2b_2: lifted from sky130_fd_sc_hd__nand2b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand2b_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B s=VGND b=VNB
  device M1 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M2 nmos w=WN l=L d=Y g=n2 s=n1 b=VNB
  device M3 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M4 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n1 g=n2 s=Y b=VNB
  device M6 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M7 pmos w=WP l=L d=VPWR g=n2 s=Y b=VPB
  device M8 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=VGND g=B s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.35
  x3 = x2 + L + 0.34
  x4 = x3 + 0.04
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.22
  x7 = x6 + 0.06
  x8 = x7 + L + 0.22
  x9 = x8 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.02) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x1 + L + 0.08, x2 - 0.02) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x2 + L + 0.115, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.22) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 + L + 0.085, x9 + L + 0.22) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p2 = rect poly xspan=(x1, x1 + L + 0.135) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.19)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p8 = rect poly xspan=(x6, x9 + L + 0.305) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p12 = rect poly xspan=(x9, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.18)
  p14 = rect poly xspan=(x9, x9 + L + 0.305) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 - 0.045) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x7 + L + 0.055, x8 + 0.01) yspan=(-0.085, nb + 0.23 + 0.06) net=VGND
  l3 = rect li xspan=(x2 + L + 0.05, x7 + 0.03) yspan=(nb + 0.02, nb + 0.23) net=n1
  l4 = rect li xspan=(x2 + L + 0.05, x3 - 0.015) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x5 + L + 0.055, x7 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x5 + L + 0.055, x9 + L + 0.325) yspan=(nb + WN - 0.19, nb + WN + 0.02) net=n1
  l7 = rect li xspan=(x8 + L + 0.03, x9 + L + 0.325) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x1 + 0.06, x2 - 0.09) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A_N
  l9 = rect li xspan=(x5 + L + 0.02, x9 + L + 0.325) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l10 = rect li xspan=(x5 + L + 0.02, x6 - 0.01) yspan=(nb + WN + 0.19, pt - WP + 0.17) net=B
  l11 = rect li xspan=(x1 - 0.29, x1 - 0.12) yspan=(nb + 0.23 + 0.045, pt - 0.58 - 0.045) net=n2
  l12 = rect li xspan=(x1 - 0.29, x1 - 0.055) yspan=(nb + 0.23 + 0.045, nb + WN - 0.045) net=n2
  l13 = rect li xspan=(x1 - 0.29, x3 - 0.01) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l14 = rect li xspan=(x1 - 0.29, x1 + 0.015) yspan=(pt - WP + 0.01, pt - 0.58 - 0.045) net=n2
  l15 = rect li xspan=(x2 + L - 0.005, x3 - 0.01) yspan=(nb + WN + 0.19, pt - WP + 0.18) net=n2
  l16 = rect li xspan=(x2 + L, x3) yspan=(pt - 0.58 - 0.07, pt - 0.02) net=Y
  l17 = rect li xspan=(x2 + L, x8 + 0.03) yspan=(pt - 0.58 - 0.07, pt - 0.58 + 0.1) net=Y
  l18 = rect li xspan=(x3 + L + 0.01, x5 + 0.03) yspan=(nb + 0.23 + 0.17, nb + WN - 0.08) net=Y
  l19 = rect li xspan=(x3 + L + 0.015, x5 - 0.02) yspan=(nb + 0.23 + 0.17, pt - 0.58 + 0.1) net=Y
  l20 = rect li xspan=(x3 + L + 0.015, x5 + 0.03) yspan=(nb + 0.23 + 0.17, nb + WN + 0.02) net=Y
  l21 = rect li xspan=(x7 + 0.035, x8 + 0.03) yspan=(pt - 0.58 - 0.07, pt - 0.02) net=Y
  l22 = rect li xspan=(x6 + L + 0.025, x8 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l23 = rect li xspan=(x1 + L + 0.04, x2 - 0.055) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  l24 = rect li xspan=(x3 + L + 0.02, x6 - 0.08) yspan=(pt - 0.58 + 0.27, H + 0.085) net=VPWR
  l25 = rect li xspan=(x9 + L - 0.01, x9 + L + 0.325) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd3 cx=(x8 - 0.08) span=(-0.085 + 0.08, nb + 0.23 + 0.06 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x2 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  c3 = array licon in=nd3 cx=(x3 - 0.1) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c4 = array licon in=nd3 cx=(x6 - 0.08) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=n1
  c5 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n1
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.23 + 0.045 + 0.08, nb + WN - 0.045 - 0.08) net=n2
  c7 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN - 0.06) margin=0.04 net=VGND
  c8 = array licon in=nd3 cx=(x4 + L + 0.14) span=(nb + 0.23 + 0.17 + 0.08, pt - 0.58 + 0.1 - 0.08) margin=0.04 net=Y
  c9 = array licon in=pd2 cx=(x7 + L + 0.08) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c10 = array licon in=pd2 cx=(x9 + L + 0.08) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 - 0.045 - 0.08) net=n2
  c12 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - 0.58 - 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x2 + L + 0.17) span=(pt - 0.58 - 0.07, pt - 0.02) margin=0.04 net=Y
  c14 = array licon in=pd2 cx=(x4 + L + 0.1) span=(pt - 0.58 + 0.27 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd2 cx=(x5 + L + 0.02) span=(pt - 0.58 + 0.27 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.005) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.165) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 + L + 0.08) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x9 + L + 0.14) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.12) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.06) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.1) cy=0
  mc6 = contact mcon cx=(x8 - 0.08) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.18) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.12) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.06) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.1) cy=H
  mc13 = contact mcon cx=(x8 - 0.08) cy=H
  mc14 = contact mcon cx=(x9 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l8
  port B in on=l9
  port Y out on=l19
end
