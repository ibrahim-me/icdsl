# a41oi_1: lifted from sky130_fd_sc_hd__a41oi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a41oi_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=n2 b=VNB
  device M1 pmos w=WP l=L d=n3 g=A4 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n4 g=A3 s=n1 b=VNB
  device M3 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M4 nmos w=WN l=L d=VGND g=A4 s=n4 b=VNB
  device M5 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=Y g=B1 s=n3 b=VPB
  device M7 pmos w=WP l=L d=VPWR g=A3 s=n3 b=VPB
  device M8 pmos w=WP l=L d=n3 g=A2 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.435
  x3 = x2 + 0.06
  x4 = x3 + L + 0.36
  x5 = x4 + L + 0.32
  x6 = x5 + L + 0.435
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.375) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 + L + 0.1, x2 - 0.045) yspan=(nb - 0.04, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.375) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 - 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4 - 0.055, x4 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6, x6 + L + 0.29) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.08, x2 - 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x6 + L + 0.07, x6 + L + 0.375) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A1
  l3 = rect li xspan=(x1 + L - 0.005, x2 - 0.195) yspan=(nb + WN + 0.08, pt - WP + 0.18) net=B1
  l4 = rect li xspan=(x2 - 0.015, x3 + L + 0.075) yspan=(nb + WN + 0.08, pt - WP + 0.18) net=A4
  l5 = rect li xspan=(x4 - 0.065, x4 + L + 0.035) yspan=(nb + WN - 0.13, pt - WP + 0.18) net=A3
  l6 = rect li xspan=(x5 - 0.105, x5 + L + 0.075) yspan=(nb + WN - 0.13, pt - WP + 0.18) net=A2
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.05, pt - 0.06) net=Y
  l8 = rect li xspan=(x1 - 0.31, x3 + L + 0.115) yspan=(nb + WN - 0.27, nb + WN - 0.1) net=Y
  l9 = rect li xspan=(x1 - 0.31, x1 - 0.04) yspan=(nb + WN - 0.27, pt - 0.06) net=Y
  l10 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.36, pt - 0.06) net=Y
  l11 = rect li xspan=(x2 + L, x6 + L + 0.305) yspan=(nb + 0.06, nb + 0.23) net=Y
  l12 = rect li xspan=(x2 + L, x3 + L + 0.115) yspan=(nb + 0.06, nb + WN - 0.1) net=Y
  l13 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(nb + 0.06, nb + WN - 0.08) net=Y
  l14 = rect li xspan=(x1 + L + 0.055, x6 + L + 0.305) yspan=(pt - WP + 0.36, pt - WP + 0.53) net=n3
  l15 = rect li xspan=(x1 + L + 0.055, x2 - 0.13) yspan=(pt - WP + 0.36, pt - 0.02) net=n3
  l16 = rect li xspan=(x4 + L + 0.085, x5 - 0.065) yspan=(pt - WP + 0.36, pt - 0.02) net=n3
  l17 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.305) yspan=(pt - WP + 0.36, pt - 0.02) net=n3
  l18 = rect li xspan=(x2 + L, x4 - 0.085) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l19 = rect li xspan=(x5 + L + 0.08, x6 - 0.025) yspan=(pt - 0.29, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.19) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x6 + L + 0.14) span=(nb + 0.06, nb + WN - 0.08) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.05 + 0.08, pt - 0.06 - 0.08) net=Y
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.05 + 0.08, pt - 0.06 - 0.08) net=Y
  c5 = array licon in=pd1 cx=(x2 - 0.215) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c6 = array licon in=pd1 cx=(x5 - 0.15) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c7 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c8 = array licon in=pd1 cx=(x3 + L + 0.11) span=(pt - 0.29, H + 0.085) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x6 - 0.19) span=(pt - 0.29, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.085) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.065) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.155) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.51) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.03) cy=0
  mc4 = contact mcon cx=(x4 + L - 0.07) cy=0
  mc5 = contact mcon cx=(x5 + L - 0.07) cy=0
  mc6 = contact mcon cx=(x6 - 0.04) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.28) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.03) cy=H
  mc11 = contact mcon cx=(x4 + L - 0.07) cy=H
  mc12 = contact mcon cx=(x5 + L - 0.07) cy=H
  mc13 = contact mcon cx=(x6 - 0.04) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.28) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l2
  port A2 in on=l6
  port A3 in on=l5
  port A4 in on=l4
  port B1 in on=l3
  port Y out on=l7
end
