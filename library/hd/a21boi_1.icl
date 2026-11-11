# a21boi_1: lifted from sky130_fd_sc_hd__a21boi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell a21boi_1 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB
  device M2 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=Y g=n2 s=n3 b=VPB
  device M4 nmos w=WN2 l=L d=n2 g=B1_N s=VGND b=VNB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  device M6 pmos w=WP2 l=L d=n2 g=B1_N s=VPWR b=VPB
  device M7 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.15
  x3 = x2 + L + 0.35
  x4 = x3 + L + 0.03
  x5 = x4 + L + 0.28
  x6 = x5 + 0.01
  x7 = x6 + L + 0.28
  x8 = x7 + 0.01
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 + 0.025, x8 + L + 0.26) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.08, x8 + L + 0.26) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x2 + L - 0.025) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x3 - 0.1, x8 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.3, x1 - 0.03) yspan=(nb + WN2 + 0.1, pt - WP2 - 0.1)
  p2 = rect poly xspan=(x1 - 0.3, x2 + L) yspan=(nb + WN2 + 0.1, nb + WN + 0.02)
  p3 = rect poly xspan=(x1 - 0.3, x1 + L) yspan=(pt - WP2 - 0.25, pt - WP2 - 0.1)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(pt - WP2 - 0.25, H - 0.105)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, nb + WN + 0.02)
  p6 = rect poly xspan=(x1 + L + 0.04, x4 + L) yspan=(nb + WN + 0.3, pt - WP - 0.1)
  p7 = rect poly xspan=(x1 + L + 0.04, x2 + L + 0.02) yspan=(nb + WN + 0.3, pt - WP + 0.12)
  p8 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.1)
  p9 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.3, H - 0.105)
  p10 = rect poly xspan=(x5 - 0.055, x6 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p13 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x7, x8 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.09, x3 - 0.03) yspan=(-0.085, nb + WN - 0.02) net=VGND
  l2 = rect li xspan=(x7 + L - 0.025, x8 + L + 0.3) yspan=(-0.085, nb + WN - 0.07) net=VGND
  l3 = rect li xspan=(x5 - 0.015, x7 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.14) net=A1
  l4 = rect li xspan=(x6 + L + 0.02, x7 - 0.05) yspan=(nb + 0.14, pt - WP - 0.14) net=A1
  l5 = rect li xspan=(x7 + L, x8 + L + 0.285) yspan=(nb + WN + 0.11, pt - WP - 0.14) net=A2
  l6 = rect li xspan=(x1 - 0.3, x1 - 0.07) yspan=(nb + WN + 0.09, pt - WP + 0.18) net=B1_N
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(pt - WP2 - 0.22, pt - 0.05) net=n2
  l8 = rect li xspan=(x1 - 0.31, x2 + L + 0.02) yspan=(pt - WP2 - 0.22, pt - WP2 - 0.02) net=n2
  l9 = rect li xspan=(x1 - 0.04, x2 + 0.055) yspan=(nb + 0.03, nb + WN2 + 0.06) net=n2
  l10 = rect li xspan=(x1 + L - 0.035, x2 + 0.055) yspan=(nb + 0.03, pt - WP2 - 0.02) net=n2
  l11 = rect li xspan=(x1 + L - 0.035, x2 + L + 0.02) yspan=(nb + WN + 0.28, pt - WP2 - 0.02) net=n2
  l12 = rect li xspan=(x3 - 0.14, x4 + 0.025) yspan=(nb + WN + 0.16, pt - 0.03) net=Y
  l13 = rect li xspan=(x3 + L + 0.01, x4 + L + 0.085) yspan=(nb + 0.03, pt - WP - 0.14) net=Y
  l14 = rect li xspan=(x3 + L + 0.01, x5 - 0.01) yspan=(nb + 0.03, nb + WN - 0.09) net=Y
  l15 = rect li xspan=(x4 + L + 0.05, x8 + L + 0.23) yspan=(pt - WP + 0.04, pt - WP + 0.24) net=n3
  l16 = rect li xspan=(x4 + L + 0.05, x5 - 0.04) yspan=(pt - WP + 0.04, pt - 0.03) net=n3
  l17 = rect li xspan=(x8 + L + 0.06, x8 + L + 0.23) yspan=(pt - WP + 0.04, pt - 0.03) net=n3
  l18 = rect li xspan=(x1 + L - 0.025, x2 + L + 0.02) yspan=(pt - WP2 + 0.16, H + 0.085) net=VPWR
  l19 = rect li xspan=(x5 + L - 0.015, x8 + 0.025) yspan=(pt - WP2 - 0.16, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x3 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.02 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x8 + L + 0.135) span=(-0.085, nb + WN - 0.07) net=VGND
  c3 = array licon in=nd1 cx=(x1 + L) span=(nb + 0.03, nb + WN2 + 0.06) net=n2
  c4 = array licon in=nd2 cx=(x4 + L + 0.055) span=(nb + 0.03, nb + WN - 0.09) margin=0.04 net=Y
  c5 = array licon in=pd2 cx=(x3 + 0.03) span=(nb + WN + 0.16, pt - 0.03) net=Y
  c6 = array licon in=pd2 cx=(x5 - 0.135) span=(pt - WP + 0.04 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=n3
  c7 = array licon in=pd2 cx=(x8 + L + 0.145) span=(pt - WP + 0.04 + 0.08, pt - 0.03 - 0.08) net=n3
  c8 = array licon in=pd2 cx=(x7 - 0.135) span=(pt - WP2 - 0.16, H + 0.085) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP2 - 0.22 + 0.08, pt - 0.05 - 0.08) net=n2
  c10 = array licon in=pd1 cx=x2 span=(pt - WP2 + 0.16, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.165) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 + L - 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x8 + L + 0.13) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x2 + 0.03) cy=(pt - WP - 0.045)
  gc5 = contact licon cx=(x1 - 0.165) cy=(pt - WP + 0.015)
  np1 = rect npc xspan=(x1 - 0.405, x8 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 - 0.405, x2 + L + 0.07) yspan=(nb + WN + 0.09, pt - WP2 - 0.38)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=x2 cy=0
  mc3 = contact mcon cx=(x3 - 0.035) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.115) cy=0
  mc5 = contact mcon cx=(x7 - 0.135) cy=0
  mc6 = contact mcon cx=(x8 + L + 0.175) cy=0
  mc7 = contact mcon cx=(x1 - 0.175) cy=H
  mc8 = contact mcon cx=x2 cy=H
  mc9 = contact mcon cx=(x3 - 0.035) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.115) cy=H
  mc11 = contact mcon cx=(x7 - 0.135) cy=H
  mc12 = contact mcon cx=(x8 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l3
  port A2 in on=l5
  port B1_N in on=l6
  port Y out on=l14
end
