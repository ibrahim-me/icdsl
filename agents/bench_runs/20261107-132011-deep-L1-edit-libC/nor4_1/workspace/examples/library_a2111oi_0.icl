# a2111oi_0: lifted from sky130_fd_sc_hd__a2111oi_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 L=0.15 H=2.72

stdcell a2111oi_0 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M1 nmos w=WN l=L d=Y g=A1 s=n2 b=VNB
  device M2 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=n3 g=B1 s=n1 b=VPB
  device M4 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M5 pmos w=WP l=L d=Y g=D1 s=n4 b=VPB
  device M6 nmos w=WN l=L d=VGND g=D1 s=Y b=VNB
  device M7 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M8 pmos w=WP l=L d=n4 g=C1 s=n3 b=VPB
  device M9 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.63
  x2 = x1 + 0.07
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.22
  x5 = x4 + 0.14
  x6 = x5 + L + 0.15
  x7 = x6 + 0.14
  x8 = x7 + L + 0.22
  x9 = x8 + 0.03
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.305, x9 + L + 0.26) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.23, x9 + L + 0.31) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.415, x1 - 0.145) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  p2 = rect poly xspan=(x1 - 0.415, x1 + L) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p3 = rect poly xspan=(x1 - 0.415, x2 + L) yspan=(pt - WP - 0.225, pt - WP - 0.075)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, nb + WN + 0.225)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.225, H - 0.105)
  p6 = rect poly xspan=(x2 + L + 0.035, x3 + L) yspan=(nb + WN + 0.41, pt - WP - 0.435)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.4, H - 0.105)
  p9 = rect poly xspan=(x4, x5 + L + 0.065) yspan=(nb + WN + 0.4, nb + WN + 0.74)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, nb + WN + 0.74)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(pt - WP - 0.25, H - 0.105)
  p12 = rect poly xspan=(x7 - 0.01, x7 + L) yspan=(nb + WN + 0.4, pt - WP - 0.075)
  p13 = rect poly xspan=(x7 - 0.01, x9 + L + 0.105) yspan=(nb + WN + 0.435, pt - WP - 0.435)
  p14 = rect poly xspan=(x7 - 0.01, x7 + L + 0.035) yspan=(nb + WN + 0.435, pt - WP - 0.075)
  p15 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.075)
  p16 = rect poly xspan=(x8, x8 + L) yspan=(0.105, nb + WN + 0.225)
  p17 = rect poly xspan=(x8, x9 + L + 0.595) yspan=(nb + WN + 0.075, nb + WN + 0.225)
  p18 = rect poly xspan=(x9, x9 + L) yspan=(pt - WP - 0.225, H - 0.105)
  p19 = rect poly xspan=(x9, x9 + L + 0.595) yspan=(pt - WP - 0.225, pt - WP - 0.075)
  p20 = rect poly xspan=(x9 + L + 0.315, x9 + L + 0.595) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.345, x1 - 0.015) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x3 + L + 0.01, x5 - 0.015) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x8 + L - 0.025, x9 + L + 0.28) yspan=(-0.085, nb + 0.245) net=VGND
  l4 = rect li xspan=(x1 - 0.545, x1 - 0.195) yspan=(nb + WN + 0.075, pt - WP - 0.19) net=D1
  l5 = rect li xspan=(x5 - 0.06, x6) yspan=(nb + WN + 0.4, pt - WP - 0.11) net=B1
  l6 = rect li xspan=(x6 + L + 0.04, x9 + L + 0.105) yspan=(nb + WN + 0.415, pt - WP - 0.445) net=A1
  l7 = rect li xspan=(x8 + 0.01, x9 + L + 0.105) yspan=(nb + WN + 0.005, pt - WP - 0.11) net=A1
  l8 = rect li xspan=(x9 + L + 0.275, x9 + L + 0.615) yspan=(nb + WN - 0.005, pt - WP - 0.11) net=A2
  l9 = rect li xspan=(x3 - 0.105, x4 - 0.095) yspan=(nb + WN + 0.4, pt - 0.125) net=C1
  l10 = rect li xspan=(x1 - 0.27, x1 + L + 0.01) yspan=(pt - WP - 0.02, pt - 0.02) net=Y
  l11 = rect li xspan=(x1 - 0.025, x1 + L + 0.01) yspan=(nb + WN - 0.02, pt - 0.02) net=Y
  l12 = rect li xspan=(x1 + L + 0.01, x3 - 0.02) yspan=(nb + 0.02, nb + WN + 0.23) net=Y
  l13 = rect li xspan=(x1 + L + 0.01, x6 + L + 0.045) yspan=(nb + WN - 0.04, nb + WN + 0.23) net=Y
  l14 = rect li xspan=(x5 + L + 0.01, x6 + L + 0.045) yspan=(nb + 0.045, nb + WN + 0.23) net=Y
  l15 = rect li xspan=(x5 - 0.015, x9 + L + 0.35) yspan=(pt - WP + 0.06, pt - WP + 0.24) net=n1
  l16 = rect li xspan=(x5 - 0.015, x6 + 0.025) yspan=(pt - WP + 0.06, pt - 0.02) net=n1
  l17 = rect li xspan=(x9 + L + 0.02, x9 + L + 0.35) yspan=(pt - WP + 0.06, pt - 0.02) net=n1
  l18 = rect li xspan=(x6 + L + 0.045, x9 - 0.005) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x4 - 0.045) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x9 + L + 0.115) span=(-0.085, nb + 0.245) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.18) span=(-0.085, nb + 0.23) net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.075) span=(nb + 0.02 + 0.08, nb + WN + 0.23 - 0.08) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=x6 span=(nb + 0.045 + 0.08, nb + WN + 0.23 - 0.08) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.105) span=(pt - WP - 0.02, pt - 0.02) net=Y
  c7 = array licon in=pd1 cx=(x5 + L) span=(pt - WP + 0.06, pt - 0.02) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x9 + L + 0.185) span=(pt - WP + 0.06, pt - 0.02) net=n1
  c9 = array licon in=pd1 cx=(x7 + L + 0.075) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.28) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x9 + L + 0.46) cy=(nb + WN + 0.5)
  gc3 = contact licon cx=(x3 - 0.02) cy=(nb + WN + 0.565)
  gc4 = contact licon cx=(x4 + L + 0.045) cy=(nb + WN + 0.565)
  gc5 = contact licon cx=(x7 + L - 0.015) cy=(pt - WP - 0.61)
  gc6 = contact licon cx=(x8 + L - 0.035) cy=(nb + WN + 0.58)
  gc7 = contact licon cx=(x1 - 0.28) cy=(nb + WN + 0.66)
  gc8 = contact licon cx=(x9 + L + 0.46) cy=(pt - WP - 0.35)
  np1 = rect npc xspan=(x1 - 0.63, x1 - 0.095) yspan=(nb + WN + 0.09, pt - WP - 0.345)
  np2 = rect npc xspan=(x1 - 0.63, x9 + L + 0.7) yspan=(nb + WN + 0.315, pt - WP - 0.4)
  np3 = rect npc xspan=(x9 + L + 0.145, x9 + L + 0.7) yspan=(nb + WN + 0.315, pt - WP - 0.165)
  # metal
  mc1 = contact mcon cx=(x1 - 0.4) cy=0
  mc2 = contact mcon cx=(x2 - 0.005) cy=0
  mc3 = contact mcon cx=(x3 + L - 0.055) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.045) cy=0
  mc5 = contact mcon cx=(x7 + L - 0.065) cy=0
  mc6 = contact mcon cx=(x9 + L + 0.01) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.47) cy=0
  mc8 = contact mcon cx=(x1 - 0.4) cy=H
  mc9 = contact mcon cx=(x2 - 0.005) cy=H
  mc10 = contact mcon cx=(x3 + L - 0.055) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.045) cy=H
  mc12 = contact mcon cx=(x7 + L - 0.065) cy=H
  mc13 = contact mcon cx=(x9 + L + 0.01) cy=H
  mc14 = contact mcon cx=(x9 + L + 0.47) cy=H
  well y=(pt - WP - 0.54)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l8
  port B1 in on=l5
  port C1 in on=l9
  port D1 in on=l4
  port Y out on=l10
end
