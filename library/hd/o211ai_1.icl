# o211ai_1: lifted from sky130_fd_sc_hd__o211ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o211ai_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.22
  x3 = x2 + L + 0.04
  x4 = x3 + L + 0.22
  x5 = x4 + L + 0.04
  x6 = x5 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.61) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.64) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.23, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.13)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.13)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.285) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.05, x2 + L + 0.02) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l3 = rect li xspan=(x1 - 0.31, x4 + L + 0.01) yspan=(nb + WN - 0.27, nb + WN - 0.06) net=n2
  l4 = rect li xspan=(x3 + L + 0.04, x4 + L + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l5 = rect li xspan=(x1 - 0.32, x1 - 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l6 = rect li xspan=(x4, x6 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l7 = rect li xspan=(x5 - 0.015, x6 - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B1
  l8 = rect li xspan=(x6 + L - 0.02, x6 + L + 0.315) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=C1
  l9 = rect li xspan=(x1 + L + 0.06, x2 + 0.015) yspan=(nb + WN + 0.11, pt - 0.235) net=A2
  l10 = rect li xspan=(x1 + L + 0.06, x3 + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l11 = rect li xspan=(x3 + 0.005, x4 - 0.03) yspan=(pt - WP + 0.11, pt - 0.04) net=Y
  l12 = rect li xspan=(x3 + 0.005, x6 + L + 0.69) yspan=(pt - WP + 0.33, pt - WP + 0.56) net=Y
  l13 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.69) yspan=(nb + 0.02, nb + WN - 0.04) net=Y
  l14 = rect li xspan=(x6 + L - 0.015, x6 + L + 0.69) yspan=(pt - WP + 0.33, pt - 0.02) net=Y
  l15 = rect li xspan=(x6 + L + 0.485, x6 + L + 0.69) yspan=(nb + 0.02, pt - 0.02) net=Y
  l16 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - WP + 0.09, H + 0.085) net=VPWR
  l17 = rect li xspan=(x4 + L - 0.005, x6 - 0.07) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=x2 span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN - 0.06) net=n2
  c3 = array licon in=nd1 cx=(x4 - 0.015) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n2
  c4 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.02, nb + WN - 0.04) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x6 + L + 0.485) span=(nb + 0.02, nb + WN - 0.04) net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.09, H + 0.085) net=VPWR
  c7 = array licon in=pd1 cx=(x3 + L + 0.025) span=(pt - WP + 0.11, pt - 0.04) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x6 + L + 0.155) span=(pt - WP + 0.33, pt - 0.02) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x6 + L + 0.495) span=(pt - WP + 0.33, pt - 0.02) margin=0.04 net=Y
  c10 = array licon in=pd1 cx=(x5 + L - 0.02) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.095) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.15) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x6 + L + 0.775) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 - 0.075) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.065) cy=0
  mc4 = contact mcon cx=(x5 + L - 0.02) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.085) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.545) cy=0
  mc7 = contact mcon cx=(x1 - 0.175) cy=H
  mc8 = contact mcon cx=(x2 - 0.075) cy=H
  mc9 = contact mcon cx=(x3 + L + 0.065) cy=H
  mc10 = contact mcon cx=(x5 + L - 0.02) cy=H
  mc11 = contact mcon cx=(x6 + L + 0.085) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.545) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l9
  port B1 in on=l6
  port C1 in on=l8
  port Y out on=l13
end
