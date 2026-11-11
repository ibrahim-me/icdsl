# a2bb2oi_1: Y = (A1_N&!B1) | (A1_N&!B2) | (A2_N&!B1) | (A2_N&!B2)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a2bb2oi_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2_N s=n2 b=VPB
  device M1 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=Y g=B2 s=n3 b=VNB
  device M3 pmos w=WP l=L d=Y g=n2 s=n4 b=VPB
  device M4 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=n4 g=B2 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=A2_N s=VGND b=VNB
  device M7 nmos w=WN l=L d=VGND g=A1_N s=n2 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=A1_N s=n1 b=VPB
  device M9 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405                          # A2_N (M0 pmos, M6 nmos)
  x2 = x1 + L + max(0.28, 0.54 - L)   # B1  (M4 pmos, M1 nmos)
  x3 = x2 + L + max(0.28, 0.54 - L)   # B2  (M5 pmos, M2 nmos)
  x4 = x3 + L + max(0.21, 0.54 - L)   # n2  (M3 pmos, M9 nmos) - series node, no contact column
  x5 = x4 + L + max(0.28, 0.54 - L)   # A1_N (M8 pmos, M7 nmos)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: nmos row
  nd1 = rect diff xspan=(x1 - 0.27, x3 + L + 0.27) yspan=(nb, nb + WN)   # M1,M2: VGND-n3-Y
  nd2 = rect diff xspan=(x4 - 0.27, x5 + L + 0.27) yspan=(nb, nb + WN)   # M6,M7: n2-VGND-n2
  nd3 = rect diff xspan=(x5 - 0.27, x5 + L + 0.27) yspan=(nb, nb + WN)   # M9: VGND-Y
  nim = enclose [nd1, nd2, nd3] nsdm
  # diffusion: pmos row
  pd1 = rect diff xspan=(x1 - 0.27, x4 + L + 0.27) yspan=(pt - WP, pt)   # M0,M3: n1-n2-Y
  pd2 = rect diff xspan=(x2 - 0.27, x3 + L + 0.27) yspan=(pt - WP, pt)   # M4,M5: VPWR-n4-VPWR
  pd3 = rect diff xspan=(x5 - 0.27, x5 + L + 0.27) yspan=(pt - WP, pt)   # M8: VPWR-n1
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, crossing both rows
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)             # A2_N
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)             # B1
  p3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)             # B2
  p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)             # n2
  p5 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)             # A1_N
  # local interconnect: n row
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.05) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x3 + L + 0.04, x3 + L + 0.31) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l3 = rect li xspan=(x2 - 0.33, x2 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l4 = rect li xspan=(x3 - 0.33, x3 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B2
  l5 = rect li xspan=(x5 - 0.33, x5 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1_N
  l6 = rect li xspan=(x1 - 0.33, x1 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2_N
  l7 = rect li xspan=(x4 + L + 0.04, x5 - 0.05) yspan=(nb + 0.03, nb + WN - 0.07) net=n2
  l8 = rect li xspan=(x3 + L + 0.04, x5 + L + 0.27) yspan=(nb + 0.03, nb + WN - 0.07) net=Y
  # local interconnect: p row
  l9 = rect li xspan=(x2 + L - 0.01, x3 + 0.01) yspan=(pt - WP + 0.02, H + 0.085) net=VPWR
  l10 = rect li xspan=(x2 - 0.33, x2 - 0.05) yspan=(pt - WP + 0.02, H + 0.085) net=B1
  l11 = rect li xspan=(x3 - 0.33, x3 - 0.05) yspan=(pt - WP + 0.02, H + 0.085) net=B2
  l12 = rect li xspan=(x5 - 0.33, x5 - 0.05) yspan=(pt - WP + 0.02, H + 0.085) net=A1_N
  l13 = rect li xspan=(x1 - 0.33, x1 - 0.05) yspan=(pt - WP + 0.02, H + 0.085) net=A2_N
  l14 = rect li xspan=(x2 + L + 0.04, x3 - 0.05) yspan=(pt - WP + 0.02, pt - 0.03) net=n4
  l15 = rect li xspan=(x4 + L + 0.04, x4 + L + 0.31) yspan=(pt - WP + 0.02, pt - 0.03) net=Y
  l16 = rect li xspan=(x1 + L + 0.04, x5 - 0.05) yspan=(pt - WP + 0.02, pt - 0.03) net=n1
  # contacts: diffusion columns (n row)
  c1 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x4 - 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=n2
  c4 = array licon in=nd2 cx=(x5 - 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=VGND
  c5 = array licon in=nd3 cx=(x5 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=VGND
  c6 = array licon in=nd3 cx=(x5 - 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=Y
  # contacts: diffusion columns (p row)
  c7 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n1
  c8 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=Y
  c9 = array licon in=pd2 cx=(x2 - 0.145) span=(pt - WP + 0.02 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd2 cx=(x3 + L + 0.145) span=(pt - WP + 0.02 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd3 cx=(x5 - 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=VPWR
  c12 = array licon in=pd3 cx=(x5 + L + 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n1
  # gate contacts
  cb = max(nd1.top + 0.19, l3.top + 0.25, l4.top + 0.25, l5.top + 0.25, l6.top + 0.25)
  gc1 = contact licon cx=(x1 + L + 0.14) cy=cb net=A2_N
  gc2 = contact licon cx=(x2 - 0.14) cy=cb net=B1
  gc3 = contact licon cx=(x3 - 0.14) cy=cb net=B2
  gc4 = contact licon cx=(x4 + L / 2) cy=cb net=n2
  gc5 = contact licon cx=(x5 - 0.14) cy=cb net=A1_N
  np1 = rect npc xspan=(x1 - 0.405, x5 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: rail contacts
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.175) cy=H
  mc4 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc5 = contact mcon cx=(x1 - 0.175) cy=H
  # straps
  strap li from=l1 to=vgnd_li
  strap li from=l2 to=vgnd_li
  strap li from=l9 to=vpwr_li
  # routes for nets that need metal
  route n2 layers=m1,m2
  route Y layers=m1,m2
  route n1 layers=m1,m2
  route n4 layers=m1,m2
  # pins
  port A1_N in on=l5
  port A2_N in on=l6
  port B1 in on=l3
  port B2 in on=l4
  port Y out on=l15
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
end
