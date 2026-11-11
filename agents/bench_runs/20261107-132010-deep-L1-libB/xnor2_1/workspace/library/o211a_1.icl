# o211a_1: lifted from sky130_fd_sc_hd__o211a_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o211a_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=C1 s=n1 b=VPB
  device M1 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M3 pmos w=WP l=L d=n4 g=A2 s=n1 b=VPB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=n3 g=C1 s=n1 b=VNB
  device M9 pmos w=WP l=L d=n1 g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.8
  x3 = x2 + L + 0.335
  x4 = x3 + L + 0.45
  x5 = x4 + L + 0.36
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x2 - 0.265, x5 + L + 0.305) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x5 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.22) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p3 = rect poly xspan=(x2 - 0.01, x2 + L + 0.12) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x4 - 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.145) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.53) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x2 - 0.305, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l4 = rect li xspan=(x2 - 0.305, x4 - 0.145) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x3 + L - 0.03, x4 - 0.145) yspan=(nb + 0.02, nb + WN + 0.02) net=n2
  l6 = rect li xspan=(x2 - 0.04, x3 - 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l7 = rect li xspan=(x3 + L - 0.07, x4 - 0.185) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l8 = rect li xspan=(x4 - 0.015, x4 + L + 0.175) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B1
  l9 = rect li xspan=(x5 + L + 0.2, x5 + L + 0.55) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=C1
  l10 = rect li xspan=(x1 - 0.315, x1 - 0.14) yspan=(nb + 0.02, pt - 0.02) net=X
  l11 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.02, nb + WN) net=X
  l12 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l13 = rect li xspan=(x1 + 0.035, x2 - 0.215) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l14 = rect li xspan=(x2 - 0.385, x2 - 0.215) yspan=(nb + WN + 0.19, pt - WP + 0.18) net=n1
  l15 = rect li xspan=(x2 - 0.385, x5 + L + 0.345) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l16 = rect li xspan=(x3 + L - 0.03, x4 - 0.145) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l17 = rect li xspan=(x5 - 0.015, x5 + L + 0.345) yspan=(nb + 0.02, nb + WN - 0.02) net=n1
  l18 = rect li xspan=(x5 - 0.015, x5 + L + 0.015) yspan=(nb + 0.02, pt - WP + 0.18) net=n1
  l19 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.345) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l20 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.225) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l21 = rect li xspan=(x2 - 0.305, x2 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN) net=X
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c3 = array licon in=nd2 cx=(x2 - 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n2
  c4 = array licon in=nd2 cx=(x3 - 0.165) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n2
  c6 = array licon in=nd2 cx=(x5 + L + 0.18) span=(nb + 0.02, nb + WN - 0.02) net=n1
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.02) net=X
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=n1
  c10 = array licon in=pd2 cx=(x5 + L + 0.18) span=(pt - WP + 0.01, pt - 0.02) net=n1
  c11 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c12 = array licon in=pd2 cx=(x4 + L + 0.18) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L + 0.1) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.01) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.365) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.635) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.19) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.115) cy=0
  mc6 = contact mcon cx=(x4 + L - 0.02) cy=0
  mc7 = contact mcon cx=(x5 + L - 0.06) cy=0
  mc8 = contact mcon cx=(x5 + L + 0.405) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc11 = contact mcon cx=(x2 - 0.19) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.115) cy=H
  mc14 = contact mcon cx=(x4 + L - 0.02) cy=H
  mc15 = contact mcon cx=(x5 + L - 0.06) cy=H
  mc16 = contact mcon cx=(x5 + L + 0.405) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l7
  port B1 in on=l8
  port C1 in on=l9
  port X out on=l10
end
