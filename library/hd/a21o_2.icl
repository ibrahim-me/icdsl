# a21o_2: lifted from sky130_fd_sc_hd__a21o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a21o_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A1 s=n2 b=VNB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M3 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M4 nmos w=WN l=L d=VGND g=B1 s=n1 b=VNB
  device M5 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M7 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M8 pmos w=WP l=L d=n1 g=B1 s=n3 b=VPB
  device M9 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.03
  x3 = x2 + L + 0.12
  x4 = x3 + L + 0.03
  x5 = x4 + L + 0.35
  x6 = x5 + L + 0.15
  x7 = x6 + L + 0.22
  x8 = x7 + 0.07
  x9 = x8 + L + 0.32
  x10 = x9 + 0.005
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.1, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x4 + L + 0.1) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 + 0.025, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.34)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.34)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x8 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x7 + L, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.35)
  p15 = rect poly xspan=(x9, x10 + L + 0.01) yspan=(nb + WN + 0.12, pt - WP - 0.35)
  p16 = rect poly xspan=(x10, x10 + L) yspan=(nb + WN + 0.12, H - 0.105)
  p17 = rect poly xspan=(x10, x10 + L + 0.24) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.14, x2 + 0.025) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x4 + L - 0.025, x5 - 0.04) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x9 + L - 0.015, x10 + L + 0.315) yspan=(-0.085, nb + 0.33) net=VGND
  l4 = rect li xspan=(x8 + 0.03, x9 - 0.055) yspan=(nb + 0.13, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x9 + L - 0.01, x10 + L + 0.305) yspan=(nb + WN - 0.135, pt - WP - 0.16) net=A2
  l6 = rect li xspan=(x5 - 0.03, x6 + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.075) net=B1
  l7 = rect li xspan=(x1 + L + 0.01, x3 - 0.05) yspan=(nb + 0.4, pt - 0.02) net=X
  l8 = rect li xspan=(x2 + L + 0.05, x3 + L - 0.025) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l9 = rect li xspan=(x3 + L - 0.025, x4 + L + 0.15) yspan=(nb + WN + 0.11, pt - WP + 0.435) net=n1
  l10 = rect li xspan=(x3 + L - 0.025, x6 + 0.01) yspan=(pt - WP + 0.205, pt - WP + 0.435) net=n1
  l11 = rect li xspan=(x4 + L - 0.025, x6 + L - 0.065) yspan=(nb + 0.42, nb + WN - 0.06) net=n1
  l12 = rect li xspan=(x4 + L - 0.025, x4 + L + 0.15) yspan=(nb + 0.42, pt - WP + 0.435) net=n1
  l13 = rect li xspan=(x5 - 0.02, x6 + 0.01) yspan=(pt - WP + 0.205, pt - 0.02) net=n1
  l14 = rect li xspan=(x5 + L + 0.04, x6 + L - 0.065) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l15 = rect li xspan=(x6 + L + 0.035, x10 + L + 0.255) yspan=(pt - WP + 0.185, pt - WP + 0.45) net=n3
  l16 = rect li xspan=(x6 + L + 0.035, x8 - 0.025) yspan=(pt - WP + 0.185, pt - 0.02) net=n3
  l17 = rect li xspan=(x10 + L + 0.035, x10 + L + 0.255) yspan=(pt - WP + 0.185, pt - 0.02) net=n3
  l18 = rect li xspan=(x1 - 0.31, x1 - 0.02) yspan=(pt - WP + 0.18, H + 0.085) net=VPWR
  l19 = rect li xspan=(x3 + L - 0.025, x4 + L + 0.14) yspan=(pt - 0.265, H + 0.085) net=VPWR
  l20 = rect li xspan=(x8 + L - 0.005, x10 + 0.01) yspan=(pt - 0.36, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x4 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + 0.03) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x3 + 0.03) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=X
  c5 = array licon in=nd1 cx=x6 span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c6 = array licon in=pd1 cx=(x2 + L - 0.03) span=(nb + 0.4 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.18 + 0.08, H + 0.085 - 0.08) net=VPWR
  c8 = array licon in=pd2 cx=(x7 - 0.075) span=(pt - WP + 0.185 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c9 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.185 + 0.08, pt - 0.02 - 0.08) net=n3
  c10 = array licon in=pd2 cx=(x5 + L) span=(pt - WP + 0.205 + 0.08, pt - 0.02 - 0.08) net=n1
  c11 = array licon in=pd1 cx=(x4 + L - 0.03) span=(pt - 0.265, H + 0.085) net=VPWR
  c12 = array licon in=pd2 cx=(x9 - 0.155) span=(pt - 0.36, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x4 + L - 0.065) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x7 + L + 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x10 + L + 0.075) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 + L - 0.03) cy=0
  mc3 = contact mcon cx=(x4 + L) cy=0
  mc4 = contact mcon cx=(x5 + L - 0.03) cy=0
  mc5 = contact mcon cx=(x7 - 0.075) cy=0
  mc6 = contact mcon cx=(x9 - 0.145) cy=0
  mc7 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc8 = contact mcon cx=(x1 - 0.175) cy=H
  mc9 = contact mcon cx=(x2 + L - 0.03) cy=H
  mc10 = contact mcon cx=(x4 + L) cy=H
  mc11 = contact mcon cx=(x5 + L - 0.03) cy=H
  mc12 = contact mcon cx=(x7 - 0.075) cy=H
  mc13 = contact mcon cx=(x9 - 0.145) cy=H
  mc14 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l5
  port B1 in on=l6
  port X out on=l7
end
