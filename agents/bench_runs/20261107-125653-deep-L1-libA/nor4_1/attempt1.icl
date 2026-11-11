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
  pitch = L + max(0.28, 0.54 - L)

  # diffusion: n row (NMOS: A=M7, B=M0, C=M3, D=M4; alternate VGND/Y sharing)
  #   col0: VGND | M7(A) | col1: Y | M0(B) | col2: VGND | M3(C) | col3: Y | M4(D) | col4: VGND
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # diffusion: p row (PMOS: A=M2, B=M1, C=M5, D=M6; series VPWR-n2-n1-n3-Y)
  #   col0: VPWR | M2(A) | col1: n2 | M1(B) | col2: n1 | M5(C) | col3: n3 | M6(D) | col4: Y
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)

  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  # poly: gates crossing both rows, plus vertical jogs
  pA = cross [nd1, pd1] poly w=L left=x1
  pB = cross [nd1, pd1] poly w=L left=x2
  pC = cross [nd1, pd1] poly w=L left=x3
  pD = cross [nd1, pd1] poly w=L left=x4

  # local interconnect: n-row diffusion columns
  # col0: VGND (left of M7)
  l_n_vgnd = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(nb + 0.02, nb + WN) net=VGND
  # col1: Y (between M7 and M0)
  l_n_y1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  # col2: VGND (between M0 and M3)
  l_n_vgnd2 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=VGND
  # col3: Y (between M3 and M4)
  l_n_y2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  # col4: VGND (right of M4)
  l_n_vgnd3 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=VGND

  # local interconnect: p-row diffusion columns
  # col0: VPWR (left of M2)
  l_p_vpwr = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=VPWR
  # col1: n2 (between M2 and M1)
  l_p_n2 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  # col2: n1 (between M1 and M5)
  l_p_n1 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  # col3: n3 (between M5 and M6)
  l_p_n3 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n3
  # col4: Y (right of M6)
  l_p_y = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y

  # gate input nets: li strips on gates (extend from gate contact up/down to connect to input ports)
  # Gate A contact li
  l_gA = rect li xspan=(x1 - 0.14, x1 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A
  # Gate B contact li
  l_gB = rect li xspan=(x2 - 0.14, x2 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=B
  # Gate C contact li
  l_gC = rect li xspan=(x3 - 0.14, x3 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=C
  # Gate D contact li
  l_gD = rect li xspan=(x4 - 0.14, x4 + L + 0.14) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=D

  # contacts: n-row diffusion columns
  c_n_vgnd = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  c_n_y1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  c_n_vgnd2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  c_n_y2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  c_n_vgnd3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND

  # contacts: p-row diffusion columns
  c_p_vpwr = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  c_p_n2 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c_p_n1 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  c_p_n3 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n3
  c_p_y = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y

  # gate contacts (on each gate, shifted as needed)
  gcA = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275) net=A
  gcB = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275) net=B
  gcC = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275) net=C
  gcD = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275) net=D

  # NPC around all gate contacts
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply rails contacts
  mc_vgnd_n = contact mcon cx=(x1 - 0.19) cy=0 net=VGND
  mc_vgnd_n2 = contact mcon cx=(x2 + L + 0.13) cy=0 net=VGND
  mc_vgnd_n3 = contact mcon cx=(x4 + L + 0.17) cy=0 net=VGND
  mc_vpwr_p = contact mcon cx=(x1 - 0.19) cy=H net=VPWR
  mc_vpwr_p2 = contact mcon cx=(x1 + L + 0.13) cy=H net=VPWR
  mc_vpwr_p3 = contact mcon cx=(x4 + L + 0.17) cy=H net=VPWR

  # output Y: connect n-row Y col and p-row Y col
  # n-row Y is at col1 (x1+L) and col3 (x3+L); p-row Y is at col4 (x4+L)
  # Use route to connect all Y pieces
  route Y layers=m1,m2

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A in on=l_gA
  port B in on=l_gB
  port C in on=l_gC
  port D in on=l_gD
  port Y out on=l_p_y
end
