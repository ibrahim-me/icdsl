# and4b_1: lifted from sky130_fd_sc_hd__and4b_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4b_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 nmos w=WN2 l=L d=n1 g=n2 s=n3 b=VNB
  device M2 pmos w=WP2 l=L d=n1 g=D s=VPWR b=VPB
  device M3 pmos w=WP2 l=L d=VPWR g=C s=n1 b=VPB
  device M4 nmos w=WN2 l=L d=n4 g=C s=n5 b=VNB
  device M5 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M6 pmos w=WP2 l=L d=n1 g=B s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M8 pmos w=WP2 l=L d=VPWR g=n2 s=n1 b=VPB
  device M9 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M11 nmos w=WN2 l=L d=n5 g=D s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.38
  x4 = x3 + 0.1
  x5 = x4 + L + 0.12
  x6 = x5 + L + 0.36
  x7 = x6 + L + 0.3
  x8 = x7 + 0.025
  x9 = x8 + L + 0.335
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.015) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.115, x9 + L + 0.265) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x8 + L + 0.07, x9 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x9 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x8 + L + 0.08, x9 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.06, x2 + L + 0.07) yspan=(pt - WP - 0.49, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.49, H - 0.105)
  p5 = rect poly xspan=(x2 + 0.06, x3 + L) yspan=(nb + WN2 + 0.075, nb + WN - 0.005)
  p6 = rect poly xspan=(x2 + 0.06, x2 + L + 0.07) yspan=(nb + WN2 + 0.075, pt - WP - 0.16)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, nb + WN - 0.005)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.25, H - 0.105)
  p9 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.25, pt - WP - 0.08)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.08)
  p11 = rect poly xspan=(x6 - 0.125, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7 - 0.085, x8 + L + 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p14 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p15 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p16 = rect poly xspan=(x9 - 0.105, x9 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + WN2 - 0.19) net=VGND
  l2 = rect li xspan=(x7 + L - 0.03, x9 - 0.055) yspan=(-0.085, nb + WN2 - 0.19) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + 0.055) yspan=(nb + WN + 0.11, pt - WP + 0.19) net=A_N
  l4 = rect li xspan=(x3 + L + 0.035, x5 + L - 0.045) yspan=(nb + 0.185, pt - WP + 0.21) net=B
  l5 = rect li xspan=(x6 - 0.175, x6 + L - 0.05) yspan=(nb + 0.185, pt - WP + 0.21) net=C
  l6 = rect li xspan=(x6 + L + 0.145, x8 + L + 0.02) yspan=(nb + WN2 + 0.01, pt - WP + 0.21) net=D
  l7 = rect li xspan=(x1 - 0.23, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l8 = rect li xspan=(x1 - 0.23, x2 - 0.02) yspan=(nb + WN2, nb + WN - 0.06) net=n2
  l9 = rect li xspan=(x1 - 0.23, x1 - 0.055) yspan=(pt - WP + 0.36, pt - 0.02) net=n2
  l10 = rect li xspan=(x1 - 0.23, x2 - 0.02) yspan=(pt - WP + 0.36, pt - WP2 - 0.05) net=n2
  l11 = rect li xspan=(x1 + L + 0.09, x2 - 0.02) yspan=(nb + WN2, pt - WP2 - 0.05) net=n2
  l12 = rect li xspan=(x1 + L + 0.09, x2 + L + 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l13 = rect li xspan=(x2 + L + 0.13, x3 - 0.02) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n1
  l14 = rect li xspan=(x2 + L + 0.19, x3 - 0.02) yspan=(nb + 0.02, pt - 0.02) net=n1
  l15 = rect li xspan=(x2 + L + 0.19, x9 + 0.03) yspan=(pt - WP + 0.39, pt - WP2 - 0.02) net=n1
  l16 = rect li xspan=(x6 + L + 0.1, x7 - 0.03) yspan=(pt - WP + 0.39, pt - 0.02) net=n1
  l17 = rect li xspan=(x9 - 0.145, x9 + 0.03) yspan=(nb + WN + 0.11, pt - WP2 - 0.02) net=n1
  l18 = rect li xspan=(x9 - 0.145, x9 + L - 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l19 = rect li xspan=(x9 + L - 0.03, x9 + L + 0.31) yspan=(nb + 0.06, nb + WN - 0.08) net=X
  l20 = rect li xspan=(x9 + L + 0.055, x9 + L + 0.315) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l21 = rect li xspan=(x9 + L + 0.145, x9 + L + 0.315) yspan=(nb + 0.105, pt - 0.02) net=X
  l22 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP2 + 0.13, H + 0.085) net=VPWR
  l23 = rect li xspan=(x4 + L - 0.03, x6 + 0.03) yspan=(pt - WP2 + 0.16, H + 0.085) net=VPWR
  l24 = rect li xspan=(x8 + L, x9 + 0.005) yspan=(pt - WP2 + 0.16, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + WN2 - 0.19) net=VGND
  c2 = array licon in=nd2 cx=(x8 + L + 0.115) span=(-0.085, nb + WN2 - 0.19) margin=0.04 net=VGND
  c3 = array licon in=nd3 cx=(x9 + L + 0.14) span=(nb + 0.06, nb + WN - 0.08) net=X
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c5 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n1
  c6 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) net=n2
  c8 = array licon in=pd1 cx=(x3 - 0.105) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x7 - 0.115) span=(pt - WP + 0.39 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x5 + 0.025) span=(pt - WP2 + 0.16, H + 0.085) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x6 - 0.14) span=(pt - WP2 + 0.16, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd2 cx=(x9 - 0.165) span=(pt - WP2 + 0.16, H + 0.085) net=VPWR
  c13 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.13, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.07) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x6 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + 0.03) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x9 + 0.035) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x5 - 0.045) cy=(pt - WP - 0.215)
  np1 = rect npc xspan=(x1 - 0.4, x9 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x3 + L - 0.015, x5 + L + 0.07) yspan=(nb + WN + 0.09, pt - WP - 0.03)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.03) cy=0
  mc5 = contact mcon cx=(x6 - 0.13) cy=0
  mc6 = contact mcon cx=(x7 - 0.11) cy=0
  mc7 = contact mcon cx=(x9 - 0.15) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.17) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.13) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.19) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.03) cy=H
  mc13 = contact mcon cx=(x6 - 0.13) cy=H
  mc14 = contact mcon cx=(x7 - 0.11) cy=H
  mc15 = contact mcon cx=(x9 - 0.15) cy=H
  mc16 = contact mcon cx=(x9 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l3
  port B in on=l4
  port C in on=l5
  port D in on=l6
  port X out on=l19
end
