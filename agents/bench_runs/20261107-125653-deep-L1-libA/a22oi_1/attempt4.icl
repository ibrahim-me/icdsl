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

  # gate columns (left edges): order B2, B1, A1, A2
  x1 = 0.605                          # B2
  x2 = x1 + L + max(0.28, 0.54 - L)   # B1
  x3 = x2 + L + 0.80                  # A1 (PMOS island break between B1 and A1)
  x4 = x3 + L + max(0.28, 0.54 - L)   # A2
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                      # top of the p row

  # diffusion: NMOS row (bottom) - one continuous island B2,B1,A1,A2
  nd = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nim = enclose [nd] nsdm
  # diffusion: PMOS row (top) - two islands (break between B1 and A1)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pim = enclose [pd1, pd2] psdm

  # poly gates: cross both rows (and both p islands)
  g1 = cross [nd, pd1, pd2] poly w=L cx=(x1 + L/2)   # B2
  g2 = cross [nd, pd1] poly w=L cx=(x2 + L/2)         # B1
  g3 = cross [nd, pd2] poly w=L cx=(x3 + L/2)         # A1
  g4 = cross [nd, pd2] poly w=L cx=(x4 + L/2)         # A2

  # gate contacts
  cb = max(nd.top + 0.19, 0.5)
  gc1 = contact licon cx=g1.cx bottom=cb net=B2
  gc2 = contact licon cx=g2.cx bottom=cb net=B1
  gc3 = contact licon cx=g3.cx bottom=cb net=A1
  gc4 = contact licon cx=g4.cx bottom=cb net=A2
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nd.top + 0.09, pt - WP - 0.14)

  # NMOS local interconnect (diffusion row): GND | n1 | Y | n3 | GND
  l_nd_left = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=VGND
  l_nd_n1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=n1
  l_nd_y = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  l_nd_n3 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  l_nd_right = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=VGND

  # NMOS diffusion contacts
  c_nd_left = array licon in=nd cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  c_nd_n1 = array licon in=nd cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n1
  c_nd_y = array licon in=nd cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=Y
  c_nd_n3 = array licon in=nd cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n3
  c_nd_right = array licon in=nd cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND

  # PMOS local interconnect - island 1 (B2, B1): n2 | Y | n2
  l_pd1_left = rect li xspan=(x1 - 0.265, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=n2
  l_pd1_y = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  l_pd1_right = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=n2

  # PMOS local interconnect - island 2 (A1, A2): VPWR | n2 | VPWR
  l_pd2_left = rect li xspan=(x3 - 0.265, x3 - 0.055) yspan=(pt - WP, pt - 0.02) net=VPWR
  l_pd2_n2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l_pd2_right = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=VPWR

  # PMOS diffusion contacts - island 1
  c_pd1_left = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2
  c_pd1_y = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  c_pd1_right = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2

  # PMOS diffusion contacts - island 2
  c_pd2_left = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=VPWR
  c_pd2_n2 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2
  c_pd2_right = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=VPWR

  # Supply straps
  s_vgnd = strap li from=c_nd_left to=vgnd_li
  s_vpwr = strap li from=c_pd2_left to=vpwr_li

  # Join nets in separate pieces
  route VGND layers=m1,m2
  route VPWR layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins: gate contacts on li strips for met1 access
  lg1 = rect li xspan=(gc1.cx - 0.1, gc1.cx + 0.1) yspan=(cb, cb + 0.2) net=B2
  lg2 = rect li xspan=(gc2.cx - 0.1, gc2.cx + 0.1) yspan=(cb, cb + 0.2) net=B1
  lg3 = rect li xspan=(gc3.cx - 0.1, gc3.cx + 0.1) yspan=(cb, cb + 0.2) net=A1
  lg4 = rect li xspan=(gc4.cx - 0.1, gc4.cx + 0.1) yspan=(cb, cb + 0.2) net=A2
  port B2 in on=lg1
  port B1 in on=lg2
  port A1 in on=lg3
  port A2 in on=lg4
  port Y out
end
