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
  x1 = 0.605
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  x5 = x4 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: NMOS row - two islands
  # Island 1: M6(A2_N), M7(A1_N): VGND | n2 | VGND
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  # Island 2: M1(B1), M2(B2), M9(n2): VGND | n3 | Y | VGND
  nd2 = rect diff xspan=(x3 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: PMOS row - two islands
  # Island 1: M0(A2_N), M8(A1_N): n2 | n1 | VPWR
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  # Island 2: M4(B1), M5(B2), M3(n2): VPWR | n4 | Y
  pd2 = rect diff xspan=(x3 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)

  nim1 = enclose [nd1] nsdm
  nim2 = enclose [nd2] nsdm
  pim1 = enclose [pd1] psdm
  pim2 = enclose [pd2] psdm

  # poly: gates crossing both rows
  g1 = cross [nd1, pd1] poly w=L 0.605
  g2 = cross [nd1, pd1] poly w=L 1.19
  g3 = cross [nd2, pd2] poly w=L 1.775
  g4 = cross [nd2, pd2] poly w=L 2.36
  g5 = cross [nd2, pd2] poly w=L 2.945

  # gate contact height: above n row, below p row
  cb = max(nd1.top + 0.19, pt - WP - 0.17)

  # gate contacts (one per gate, shifted as needed)
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb net=A2_N
  gc2 = contact licon cx=(g2.cx - 0.13) bottom=cb net=A1_N
  gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb net=B1
  gc4 = contact licon cx=(g4.cx - 0.13) bottom=cb net=B2
  gc5 = contact licon cx=(g5.cx - 0.13) bottom=cb net=n2

  np1 = rect npc xspan=(x1 - 0.42, x5 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # NMOS diffusion contacts
  # nd1: VGND column (left of M6), n2 column (between M6 and M7), VGND column (right of M7)
  c_nd1_vgnd_l = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  c_nd1_n2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n2
  c_nd1_vgnd_r = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  # nd2: VGND column (left of M1), n3 column (between M1 and M2), Y column (between M2 and M9), VGND column (right of M9)
  c_nd2_vgnd_l = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  c_nd2_n3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n3
  c_nd2_Y = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=Y
  c_nd2_vgnd_r = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND

  # PMOS diffusion contacts
  # pd1: n2 column (left of M0), n1 column (between M0 and M8), VPWR column (right of M8)
  c_pd1_n2 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.02, pt - 0.02) net=n2
  c_pd1_n1 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) net=n1
  c_pd1_vpwr = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) net=VPWR
  # pd2: VPWR column (left of M4), n4 column (between M4 and M5), Y column (between M5 and M3)
  c_pd2_vpwr = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.02, pt - 0.02) net=VPWR
  c_pd2_n4 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) net=n4
  c_pd2_Y = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.02, pt - 0.02) net=Y

  # li strips connecting diffusion contacts to gate contacts for internal nets
  # n2: pd1 left column (x1-0.14) to gc5 (x5-0.13) - route on m1,m2
  # n1: pd1 middle column (x1+L+0.14) to ... n1 connects M0.d and M8.s, both in pd1
  # n3: nd2 middle column (x3+L+0.14) - connects M1.d and M2.s, both in nd2
  # n4: pd2 middle column (x3+L+0.14) - connects M3.s, M4.s, M5.d, all in pd2

  # Route internal nets that connect drain to gate
  # n2: connects pd1 left diffusion (M0.s) to gc5 (M9 gate) and M0 gate is g1
  # Actually n2 is a gate for M0, M3, M9. The gate contact gc5 is on g5.
  # n2 diffusion is at pd1 left (x1-0.14) and nd1 middle (x1+L+0.14)
  route n2 layers=m1,m2

  # n1: connects M0.d (pd1 middle) and M8.s (pd1 middle) - same column, already connected
  route n1 layers=m1,m2

  # n3: connects M1.d (nd2 middle) and M2.s (nd2 middle) - same column, already connected
  route n3 layers=m1,m2

  # n4: connects M3.s, M4.s, M5.d (all pd2 middle) - same column, already connected
  route n4 layers=m1,m2

  # Y: connects nd2 Y column (x4+L+0.14) and pd2 Y column (x4+L+0.14) - vertically aligned
  # Use a strap to join n and p Y drains
  strap_Y = strap li from=c_nd2_Y to=c_pd2_Y

  # Supply straps
  strap_vgnd_nd1 = strap li from=c_nd1_vgnd_l to=vgnd_li
  strap_vgnd_nd1r = strap li from=c_nd1_vgnd_r to=vgnd_li
  strap_vgnd_nd2l = strap li from=c_nd2_vgnd_l to=vgnd_li
  strap_vgnd_nd2r = strap li from=c_nd2_vgnd_r to=vgnd_li
  strap_vpwr_pd1 = strap li from=c_pd1_vpwr to=vpwr_li
  strap_vpwr_pd2 = strap li from=c_pd2_vpwr to=vpwr_li

  # n2: connect pd1 n2 diffusion to gate contact gc5
  # n2 li strip from pd1 left column up to gate contact level
  l_n2_pd1 = rect li xspan=(x1 - 0.285, x1 - 0.055) yspan=(pt - WP + 0.02, cb + 0.1) net=n2
  # connect l_n2_pd1 to c_pd1_n2 (they overlap)
  # connect l_n2_pd1 to gc5 - need route
  route n2 layers=m1,m2

  # metal contacts for rails
  mc_vgnd_1 = contact mcon cx=(x1 - 0.375) cy=0
  mc_vgnd_2 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc_vgnd_3 = contact mcon cx=(x5 + L + 0.405) cy=0
  mc_vpwr_1 = contact mcon cx=(x1 - 0.375) cy=H
  mc_vpwr_2 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc_vpwr_3 = contact mcon cx=(x5 + L + 0.405) cy=H

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A1_N in on=gc2
  port A2_N in on=gc1
  port B1 in on=gc3
  port B2 in on=gc4
  port Y out on=c_pd2_Y
end