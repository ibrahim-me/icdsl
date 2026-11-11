# o21ai_0: lifted from sky130_fd_sc_hd__o21ai_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 L=0.15 H=2.72

stdcell o21ai_0 width=5 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M3 nmos w=WN l=L d=n1 g=A1 s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M5 pmos w=WP l=L d=n2 g=A2 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.43
  x2 = x1 + 0.025
  x3 = x2 + L + 0.25
  x4 = x3 + 0.015
  x5 = x4 + L + 0.275
  x6 = x5 + 0.015
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.245, x6 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.315, x1 - 0.045) yspan=(nb + WN + 0.075, pt - WP - 0.11)
  p2 = rect poly xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x1 - 0.315, x2 + L) yspan=(pt - WP - 0.26, pt - WP - 0.11)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, nb + WN + 0.225)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.26, H - 0.105)
  p6 = rect poly xspan=(x2 + L + 0.11, x4 + L) yspan=(nb + WN + 0.39, pt - WP - 0.47)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.39, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.47)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.7, H - 0.105)
  p10 = rect poly xspan=(x5, x6 + L + 0.305) yspan=(nb + WN + 0.7, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.025, x4 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(nb + 0.045, nb + WN + 0.13) net=n1
  l3 = rect li xspan=(x1 - 0.31, x6) yspan=(nb + WN - 0.04, nb + WN + 0.13) net=n1
  l4 = rect li xspan=(x4 + L + 0.05, x6) yspan=(nb + 0.045, nb + WN + 0.13) net=n1
  l5 = rect li xspan=(x1 - 0.345, x1 - 0.015) yspan=(nb + WN + 0.3, pt - WP - 0.23) net=A1
  l6 = rect li xspan=(x2 + L + 0.01, x4 + L) yspan=(nb + WN + 0.445, pt - WP - 0.505) net=A2
  l7 = rect li xspan=(x2 + L + 0.01, x3 - 0.07) yspan=(nb + WN + 0.445, nb + WN + 0.99) net=A2
  l8 = rect li xspan=(x6 + L + 0.085, x6 + L + 0.3) yspan=(pt - WP - 0.49, pt - WP - 0.16) net=B1
  l9 = rect li xspan=(x3 + L - 0.025, x6 + 0.015) yspan=(pt - WP - 0.335, pt - 0.02) net=Y
  l10 = rect li xspan=(x5 - 0.1, x6 + 0.06) yspan=(nb + WN + 0.3, pt - WP - 0.165) net=Y
  l11 = rect li xspan=(x5 - 0.1, x6 + L + 0.31) yspan=(nb + WN + 0.3, nb + WN + 0.47) net=Y
  l12 = rect li xspan=(x6 + L + 0.025, x6 + L + 0.31) yspan=(nb + 0.045, nb + WN + 0.47) net=Y
  l13 = rect li xspan=(x1 - 0.285, x2 + 0.025) yspan=(pt - WP - 0.02, H + 0.085) net=VPWR
  l14 = rect li xspan=(x6 + L + 0.04, x6 + L + 0.295) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.12) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.13 - 0.08) net=n1
  c3 = array licon in=nd1 cx=(x5 - 0.13) span=(nb + 0.045 + 0.08, nb + WN + 0.13 - 0.08) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.47 - 0.08) net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.12) span=(pt - WP - 0.02, H + 0.085) net=VPWR
  c6 = array licon in=pd1 cx=(x4 + L + 0.13) span=(pt - WP - 0.335, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x6 + L + 0.13) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.18) cy=(nb + WN + 0.385)
  gc2 = contact licon cx=x3 cy=(nb + WN + 0.555)
  gc3 = contact licon cx=(x1 - 0.18) cy=(nb + WN + 0.725)
  gc4 = contact licon cx=(x6 + L + 0.17) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.43, x1 + 0.01) yspan=(nb + WN + 0.2, pt - WP - 0.28)
  np2 = rect npc xspan=(x1 - 0.43, x2 + 0.03) yspan=(nb + WN + 0.2, pt - WP - 0.45)
  np3 = rect npc xspan=(x1 - 0.43, x6 + L + 0.41) yspan=(nb + WN + 0.32, pt - WP - 0.5)
  np4 = rect npc xspan=(x1 - 0.43, x4 + L + 0.025) yspan=(nb + WN + 0.32, pt - WP - 0.45)
  np5 = rect npc xspan=(x5 + L - 0.005, x6 + L + 0.41) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.2) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.095) cy=0
  mc3 = contact mcon cx=(x5 - 0.125) cy=0
  mc4 = contact mcon cx=(x6 + L + 0.18) cy=0
  mc5 = contact mcon cx=(x1 - 0.2) cy=H
  mc6 = contact mcon cx=(x2 + L + 0.095) cy=H
  mc7 = contact mcon cx=(x5 - 0.125) cy=H
  mc8 = contact mcon cx=(x6 + L + 0.18) cy=H
  well y=(pt - WP - 0.54)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l5
  port A2 in on=l6
  port B1 in on=l8
  port Y out on=l9
end
