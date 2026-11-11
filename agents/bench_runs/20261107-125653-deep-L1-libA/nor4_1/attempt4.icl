# nor4_1: 4-input NOR gate Y = !(A|B|C|D)
# library conventions: tapless, PDK widths; x from gate columns, y from row edges nb/pt
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges): gate order A, B, C, D (same for n and p rows)
  x1 = 0.42
  x2 = x1 + L + max(0.28, 0.54 - L)
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: n row (NMOS: A=M7, B=M0, C=M3, D=M4; alternate VGND/Y sharing)
  #   col0: VGND | M7(A) | col1: Y | M0(B) | col2: VGND | M3(C) | col3: Y | M4(D) | col4: VGND
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: p row (PMOS: A=M2, B=M1, C=M5, D=M6; series VPWR-n2-n1-n3-Y)
  #   col0: VPWR | M2(A) | col1: n2 | M1(B) | col2: n1 | M5(C) | col3: n3 | M6(D) | col4: Y
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)

  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  # poly: full-height gates crossing both rows (no extension)
  pA = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  pB = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  pC = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  pD = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)

  # poly pads in channel (alternating sides: A left, B right, C left, D right)
  padA = rect poly xspan=(x1 - 0.18, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  padB = rect poly xspan=(x2, x2 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  padC = rect poly xspan=(x3 - 0.18, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  padD = rect poly xspan=(x4, x4 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.16)

  # local interconnect: n-row diffusion columns (within columns, not under gates)
  l_n_vgnd0 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=VGND
  l_n_y1 = rect li xspan=(x1 + L + 0.03, x2 - 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  l_n_vgnd2 = rect li xspan=(x2 + L + 0.03, x3 - 0.03) yspan=(nb + 0.02, nb + WN) net=VGND
  l_n_y3 = rect li xspan=(x3 + L + 0.03, x4 - 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  l_n_vgnd4 = rect li xspan=(x4 + L + 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=VGND

  # local interconnect: p-row diffusion columns (within columns, not under gates)
  l_p_vpwr0 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=VPWR
  l_p_n2_1 = rect li xspan=(x1 + L + 0.03, x2 - 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l_p_n1_2 = rect li xspan=(x2 + L + 0.03, x3 - 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l_p_n3_3 = rect li xspan=(x3 + L + 0.03, x4 - 0.03) yspan=(pt - WP, pt - 0.02) net=n3
  l_p_y4 = rect li xspan=(x4 + L + 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y

  # gate input li strips (matching pad side: A left, B right, C left, D right)
  l_gA = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l_gB = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B
  l_gC = rect li xspan=(x3 - 0.325, x3 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=C
  l_gD = rect li xspan=(x4 + L - 0.045, x4 + L + 0.295) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=D

  # contacts: n-row diffusion columns
  c_n_vgnd0 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  c_n_y1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  c_n_vgnd2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  c_n_y3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  c_n_vgnd4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND

  # contacts: p-row diffusion columns
  c_p_vpwr0 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  c_p_n2_1 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c_p_n1_2 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  c_p_n3_3 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c_p_y4 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y

  # gate contacts (on poly pads, matching pad side)
  gcA = contact licon cx=(x1 - 0.09) cy=(nb + WN + 0.275) net=A
  gcB = contact licon cx=(x2 + L + 0.09) cy=(nb + WN + 0.275) net=B
  gcC = contact licon cx=(x3 - 0.09) cy=(nb + WN + 0.275) net=C
  gcD = contact licon cx=(x4 + L + 0.09) cy=(nb + WN + 0.275) net=D

  # NPC around all gate contacts
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply rail contacts
  mc_vgnd0 = contact mcon cx=(x1 - 0.19) cy=0 net=VGND
  mc_vgnd2 = contact mcon cx=(x2 + L + 0.13) cy=0 net=VGND
  mc_vgnd4 = contact mcon cx=(x4 + L + 0.17) cy=0 net=VGND
  mc_vpwr0 = contact mcon cx=(x1 - 0.19) cy=H net=VPWR
  mc_vpwr1 = contact mcon cx=(x1 + L + 0.13) cy=H net=VPWR
  mc_vpwr2 = contact mcon cx=(x4 + L + 0.17) cy=H net=VPWR

  # route nets that need metal connections
  route VGND layers=m1,m2
  route VPWR layers=m1,m2
  route Y layers=m1,m2
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A in on=l_gA
  port B in on=l_gB
  port C in on=l_gC
  port D in on=l_gD
  port Y out on=l_p_y4
end
