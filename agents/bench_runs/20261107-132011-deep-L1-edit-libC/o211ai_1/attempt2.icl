pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell o211ai_1 width=7 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n3 g=C1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=C1 s=Y b=VPB
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M6 nmos w=WN l=L d=n2 g=B1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=Y g=B1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  gap = max(0.28, 0.54 - L)
  x1 = 0.4
  x2 = x1 + L + gap
  x3 = x2 + L + gap
  x4 = x3 + L + gap
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n row - nd1 covers A1,A2 (VGND-n2-VGND), nd2 covers B1,C1 (n2-n3-Y)
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: p row - pd1 covers A1,A2 (VPWR-n1-Y), pd2 covers B1,C1 (Y-VPWR-Y)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: one gate per net, crossing both rows
  gA1 = cross [nd1, pd1] poly w=L left=x1 ext=min
  gA2 = cross [nd1, pd1] poly w=L left=x2 ext=min
  gB1 = cross [nd2, pd2] poly w=L left=x3 ext=min
  gC1 = cross [nd2, pd2] poly w=L left=x4 ext=min
  # local interconnect: n row
  lvgnd_n = rect li xspan=(x1 - 0.315, x4 + L + 0.315) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  ln2_nd1 = rect li xspan=(x1 + L + 0.05, x2 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  ln2_bridge = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  ln3 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  lY_n = rect li xspan=(x4 + L + 0.05, x4 + L + 0.315) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  # local interconnect: p row
  lvpwr_p = rect li xspan=(x1 - 0.315, x4 + L + 0.315) yspan=(pt - WP + 0.05, H + 0.085) net=VPWR
  ln1 = rect li xspan=(x1 + L + 0.05, x2 - 0.05) yspan=(pt - WP + 0.05, pt - 0.02) net=n1
  lY_p1 = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(pt - WP + 0.05, pt - 0.02) net=Y
  lY_p2 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(pt - WP + 0.05, pt - 0.02) net=Y
  lY_p3 = rect li xspan=(x4 + L + 0.05, x4 + L + 0.315) yspan=(pt - WP + 0.05, pt - 0.02) net=Y
  # gate input li: vertical strips at left of each gate column
  lA1 = rect li xspan=(x1 - 0.315, x1 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  lA2 = rect li xspan=(x2 - 0.315, x2 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  lB1 = rect li xspan=(x3 - 0.315, x3 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  lC1 = rect li xspan=(x4 - 0.315, x4 - 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C1
  # contacts: diffusion columns (n row)
  cvgnd_n1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.23 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  cvgnd_n2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.23 + 0.08, nb + WN - 0.06 - 0.08) net=VGND
  cn2_nd1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  cn2_nd2 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  cn3 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  cY_n = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  # contacts: diffusion columns (p row)
  cvpwr_p1 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cvpwr_p2 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn1 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=n1
  cY_p1 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=Y
  cY_p2 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=Y
  cY_p3 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) net=Y
  # gate contacts: bottom from n-row items only
  gcA1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275) net=A1
  gcA2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275) net=A2
  gcB1 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275) net=B1
  gcC1 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275) net=C1
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply rail contacts
  mcvgnd_1 = contact mcon cx=(x1 - 0.17) cy=0
  mcvgnd_2 = contact mcon cx=(x2 - 0.1) cy=0
  mcvgnd_3 = contact mcon cx=(x3 - 0.1) cy=0
  mcvgnd_4 = contact mcon cx=(x4 - 0.1) cy=0
  mcvpwr_1 = contact mcon cx=(x1 - 0.17) cy=H
  mcvpwr_2 = contact mcon cx=(x2 - 0.1) cy=H
  mcvpwr_3 = contact mcon cx=(x3 - 0.1) cy=H
  mcvpwr_4 = contact mcon cx=(x4 - 0.1) cy=H
  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=lA1
  port A2 in on=lA2
  port B1 in on=lB1
  port C1 in on=lC1
  port Y out on=lY_n
end
