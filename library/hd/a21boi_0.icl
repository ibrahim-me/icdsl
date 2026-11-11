# a21boi_0: lifted from sky130_fd_sc_hd__a21boi_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 WP2=0.42 L=0.15 H=2.72

stdcell a21boi_0 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1_N s=VGND b=VNB
  device M1 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=Y g=n1 s=n3 b=VPB
  device M4 nmos w=WN l=L d=VGND g=n1 s=Y b=VNB
  device M5 nmos w=WN l=L d=Y g=A1 s=n2 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M7 pmos w=WP2 l=L d=n1 g=B1_N s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.63
  x3 = x2 + L + 0.04
  x4 = x3 + L + 0.29
  x5 = x4 + 0.07
  x6 = x5 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x1 + L + 0.27) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x2 - 0.09, x6 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.205) yspan=(pt - WP - 0.58, pt - WP + 0.04)
  p3 = rect poly xspan=(x1 + L + 0.27, x3 + L) yspan=(nb + WN + 0.14, nb + WN + 0.41)
  p4 = rect poly xspan=(x2 - 0.165, x3 + L) yspan=(nb + WN + 0.41, pt - WP - 0.165)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.165)
  p6 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.115, pt - WP - 0.165)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.115, H - 0.105)
  p8 = rect poly xspan=(x4 - 0.055, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.41)
  p9 = rect poly xspan=(x4, x5) yspan=(nb + WN + 0.11, H - 0.105)
  p10 = rect poly xspan=(x5, x4 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.41)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x6, x6 + L + 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.41)
  # local interconnect
  l1 = rect li xspan=(x1 + L, x2 - 0.03) yspan=(-0.085, nb + WN - 0.045) net=VGND
  l2 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.31) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l3 = rect li xspan=(x6 + L - 0.02, x6 + L + 0.26) yspan=(nb + WN + 0.11, pt - WP - 0.41) net=A2
  l4 = rect li xspan=(x4, x6 - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.23) net=A1
  l5 = rect li xspan=(x1 + 0.07, x2 - 0.28) yspan=(pt - WP - 0.645, pt - WP + 0.11) net=B1_N
  l6 = rect li xspan=(x1 - 0.31, x1 - 0.105) yspan=(nb + 0.045, pt - 0.02) net=n1
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.025) yspan=(nb + 0.045, nb + WN + 0.375) net=n1
  l8 = rect li xspan=(x1 - 0.31, x2 - 0.03) yspan=(nb + WN + 0.125, nb + WN + 0.375) net=n1
  l9 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(pt - WP2 + 0.02, pt - 0.02) net=n1
  l10 = rect li xspan=(x2 - 0.11, x2 + L - 0.015) yspan=(nb + WN + 0.545, pt - 0.02) net=Y
  l11 = rect li xspan=(x2 - 0.11, x3 + L + 0.115) yspan=(nb + WN + 0.545, pt - WP - 0.19) net=Y
  l12 = rect li xspan=(x2 + L - 0.005, x3 + L + 0.115) yspan=(nb + 0.02, pt - WP - 0.19) net=Y
  l13 = rect li xspan=(x3 + L - 0.025, x6 + L + 0.31) yspan=(pt - WP - 0.02, pt - WP2 - 0.06) net=n3
  l14 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(pt - WP - 0.02, pt - 0.02) net=n3
  l15 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.31) yspan=(pt - WP - 0.02, pt - 0.02) net=n3
  l16 = rect li xspan=(x1 + L - 0.025, x1 + L + 0.31) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  l17 = rect li xspan=(x5 + L - 0.025, x6 - 0.05) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x6 + L + 0.145) span=(-0.085, nb + WN - 0.06) net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.375 - 0.08) net=n1
  c3 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x2 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x3 + L - 0.04) span=(nb + 0.02 + 0.08, pt - WP - 0.19 - 0.08) margin=0.04 net=Y
  c6 = array licon in=pd2 cx=(x3 + L + 0.145) span=(pt - WP - 0.02, pt - 0.02) margin=0.04 net=n3
  c7 = array licon in=pd2 cx=(x6 + L + 0.145) span=(pt - WP - 0.02, pt - 0.02) net=n3
  c8 = array licon in=pd2 cx=(x2 + 0.04) span=(nb + WN + 0.545 + 0.08, pt - 0.02 - 0.08) net=Y
  c9 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP2 + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c10 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  c11 = array licon in=pd2 cx=(x5 + L + 0.075) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.195) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.08) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.615)
  gc5 = contact licon cx=(x6 + L + 0.08) cy=(nb + WN + 0.615)
  gc6 = contact licon cx=(x1 + L + 0.04) cy=(pt - WP - 0.445)
  gc7 = contact licon cx=(x1 + L + 0.04) cy=(pt - WP - 0.105)
  np1 = rect npc xspan=(x1 - 0.405, x6 + L + 0.405) yspan=(nb + WN + 0.32, pt - WP - 0.5)
  np2 = rect npc xspan=(x1, x1 + L + 0.225) yspan=(nb + WN + 0.32, pt - WP + 0.08)
  np3 = rect npc xspan=(x1 + L + 0.25, x2 - 0.01) yspan=(nb + WN + 0.09, pt - WP - 0.5)
  np4 = rect npc xspan=(x4 - 0.105, x6 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.39)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 - 0.025) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.115) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.075) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.175) cy=0
  mc7 = contact mcon cx=(x1 - 0.175) cy=H
  mc8 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc9 = contact mcon cx=(x2 - 0.025) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.115) cy=H
  mc11 = contact mcon cx=(x5 + L + 0.075) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.175) cy=H
  well y=(pt - WP - 0.54)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l3
  port B1_N in on=l5
  port Y out on=l10
end
