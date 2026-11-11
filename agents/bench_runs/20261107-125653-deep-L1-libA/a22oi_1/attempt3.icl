pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a22oi_1 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1 b=VNB
  device M5 pmos w=WP l=L d=Y g=B2 s=n2 b=VPB
  device M6 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.605
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: NMOS row (bottom) - one island A1,A2,B2,B1
  nd = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nim = enclose [nd] nsdm
  # diffusion: PMOS row (top) - one island A1,A2,B2,B1
  pd = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pim = enclose [pd] psdm

  # poly gates: cross both rows
  g1 = cross [nd, pd] poly w=L cx=(x1 + L/2)
  g2 = cross [nd, pd] poly w=L cx=(x2 + L/2)
  g3 = cross [nd, pd] poly w=L cx=(x3 + L/2)
  g4 = cross [nd, pd] poly w=L cx=(x4 + L/2)

  # gate contacts (shifted away from output strap on the right)
  cb = max(nd.top + 0.19, 0.5)
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb net=A1
  gc2 = contact licon cx=(g2.cx - 0.13) bottom=cb net=A2
  gc3 = contact licon cx=(g3.cx + 0.13) bottom=cb net=B2
  gc4 = contact licon cx=(g4.cx + 0.13) bottom=cb net=B1
  # li strips on gate contacts for ports
  lg1 = rect li xspan=(gc1.cx - 0.1, gc1.cx + 0.1) yspan=(cb, cb + 0.2) net=A1
  lg2 = rect li xspan=(gc2.cx - 0.1, gc2.cx + 0.1) yspan=(cb, cb + 0.2) net=A2
  lg3 = rect li xspan=(gc3.cx - 0.1, gc3.cx + 0.1) yspan=(cb, cb + 0.2) net=B2
  lg4 = rect li xspan=(gc4.cx - 0.1, gc4.cx + 0.1) yspan=(cb, cb + 0.2) net=B1
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nd.top + 0.09, pt - WP - 0.14)

  # NMOS local interconnect
  # left end: Y (M6.d)
  l_nd_left = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=Y
  # between A1-A2: n3 (M6.s, M3.d)
  l_nd_n3 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  # between A2-B2: GND (M3.s, M4.d)
  l_nd_gnd = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=VGND
  # between B2-B1: n1 (M4.s, M0.d)
  l_nd_n1 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=n1
  # right end: Y (M0.s)
  l_nd_right = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=Y

  # NMOS diffusion contacts
  c_nd_left = array licon in=nd cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=Y
  c_nd_n3 = array licon in=nd cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n3
  c_nd_gnd = array licon in=nd cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  c_nd_n1 = array licon in=nd cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n1
  c_nd_right = array licon in=nd cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=Y

  # PMOS local interconnect
  # left end: VPWR (M2.d)
  l_pd_left = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=VPWR
  # between A1-A2: n2 (M2.s, M1.d)
  l_pd_n2a = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  # between A2-B2: n2 (M1.s, M5.s)
  l_pd_n2b = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  # between B2-B1: Y (M5.d, M7.s)
  l_pd_y = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  # right end: n2 (M7.d)
  l_pd_right = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=n2

  # PMOS diffusion contacts
  c_pd_left = array licon in=pd cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=VPWR
  c_pd_n2a = array licon in=pd cx=(x1 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2
  c_pd_n2b = array licon in=pd cx=(x2 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2
  c_pd_y = array licon in=pd cx=(x3 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  c_pd_right = array licon in=pd cx=(x4 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2

  # VPWR rail contacts (left end)
  l_vpwr = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  c_vpwr = array licon in=pd cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  s_vpwr = strap li from=c_vpwr to=vpwr_li

  # VGND rail contacts (between A2-B2)
  l_vgnd = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + WN + 0.02) net=VGND
  c_vgnd = array licon in=nd cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  s_vgnd = strap li from=c_vgnd to=vgnd_li

  # Output Y: join n and p drains with route
  route Y layers=m1,m2

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A1 in on=lg1
  port A2 in on=lg2
  port B1 in on=lg4
  port B2 in on=lg3
  port Y out
end
