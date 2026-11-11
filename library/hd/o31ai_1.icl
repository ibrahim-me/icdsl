# o31ai_1: lifted from sky130_fd_sc_hd__o31ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o31ai_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB
  device M1 nmos w=WN l=L d=VGND g=A3 s=n1 b=VNB
  device M2 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=n2 g=A3 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M7 pmos w=WP l=L d=n3 g=A2 s=n2 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.62
  x5 = x4 + L + 0.035
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.17) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.065, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.245) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x5 + L + 0.34) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l4 = rect li xspan=(x1 + L - 0.03, x4 - 0.3) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l5 = rect li xspan=(x3 + L - 0.015, x4 - 0.3) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l6 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.36) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l8 = rect li xspan=(x3 - 0.015, x4 - 0.3) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A3
  l9 = rect li xspan=(x3 + L + 0.08, x4 - 0.3) yspan=(nb + WN + 0.19, pt - 0.08) net=A3
  l10 = rect li xspan=(x1 + L + 0.07, x2 + L + 0.095) yspan=(nb + WN + 0.19, pt - 0.02) net=A2
  l11 = rect li xspan=(x4 - 0.055, x5 - 0.015) yspan=(nb + 0.025, pt - 0.02) net=Y
  l12 = rect li xspan=(x4 - 0.055, x5 + L + 0.36) yspan=(nb + 0.025, nb + WN - 0.06) net=Y
  l13 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l14 = rect li xspan=(x5 + L + 0.015, x5 + L + 0.36) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.155) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x5 + L + 0.025) span=(nb + 0.025, nb + WN - 0.06) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x4 + 0.035) span=(nb + 0.025 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  c8 = array licon in=pd1 cx=(x5 + L + 0.18) span=(pt - WP + 0.01, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L + 0.08) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.195) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.445) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.23) cy=0
  mc5 = contact mcon cx=(x4 + L/2) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.215) cy=0
  mc7 = contact mcon cx=(x1 - 0.17) cy=H
  mc8 = contact mcon cx=(x2 - 0.13) cy=H
  mc9 = contact mcon cx=(x3 - 0.09) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.23) cy=H
  mc11 = contact mcon cx=(x4 + L/2) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.215) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l10
  port A3 in on=l8
  port B1 in on=l7
  port Y out on=l11
end
