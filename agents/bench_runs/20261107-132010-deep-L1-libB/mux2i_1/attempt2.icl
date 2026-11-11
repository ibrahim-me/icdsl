pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell mux2i_1 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=S s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y b=VPB
  device M3 nmos w=WN l=L d=VGND g=S s=n3 b=VNB
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n1 g=S s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=A1 s=n4 b=VPB
  device M8 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y b=VNB

  # gate columns (left edges): order S, A1, A0, n1, S (same in both rows)
  x1 = 0.4
  x2 = x1 + L + 0.80
  x3 = x2 + L + max(0.28, 0.54 - L)
  x4 = x3 + L + 0.80
  x5 = x4 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n-row one island, p-row three islands
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x4 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates (full height) and pads (row area only)
  pS1 = rect poly xspan=(x1 - 0.285, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  pS1_full = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  pA1 = rect poly xspan=(x2 - 0.025, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  pA1_full = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  pA0 = rect poly xspan=(x3 - 0.025, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  pA0_full = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  pn1 = rect poly xspan=(x4 - 0.025, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  pn1_full = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  pS2 = rect poly xspan=(x5 - 0.285, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  pS2_full = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  # n-row li strips (diffusion segments)
  l_n_vgnd_l = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l_n_n3 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  l_n_Y = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  l_n_n5 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=n5
  l_n_vgnd_r = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN) net=VGND
  l_n_n1 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=n1
  # p-row li strips (island 1: M0 at x1)
  l_p_n1_l = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP, pt + 0.085) net=n1
  l_p_vpwr_l = rect li xspan=(x1 + L - 0.03, x1 + L + 0.305) yspan=(pt - WP, pt + 0.085) net=VPWR
  # p-row li strips (island 2: M7 at x2, M2 at x3)
  l_p_Y_l = rect li xspan=(x2 - 0.31, x2 - 0.055) yspan=(pt - WP, pt + 0.085) net=Y
  l_p_Y_m = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt + 0.085) net=Y
  l_p_n2_r = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(pt - WP, pt + 0.085) net=n2
  # p-row li strips (island 3: M4 at x4, M1 at x5)
  l_p_n4_l = rect li xspan=(x4 - 0.31, x4 - 0.055) yspan=(pt - WP, pt + 0.085) net=n4
  l_p_vpwr_m = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP, pt + 0.085) net=VPWR
  l_p_n2_r2 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.305) yspan=(pt - WP, pt + 0.085) net=n2
  # gate input li strips
  l_S1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=S
  l_A1 = rect li xspan=(x2 - 0.31, x2 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l_A0 = rect li xspan=(x3 - 0.31, x3 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A0
  l_n1_g = rect li xspan=(x4 - 0.31, x4 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l_S2 = rect li xspan=(x5 - 0.31, x5 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=S
  # contacts: n-row diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN) net=n3
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=n5
  c5 = array licon in=nd1 cx=(x4 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN) net=n1
  # contacts: p-row diffusion columns
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=n1
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=Y
  c10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=Y
  c11 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=n2
  c12 = array licon in=pd3 cx=(x4 - 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=n4
  c13 = array licon in=pd3 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=VPWR
  c14 = array licon in=pd3 cx=(x5 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt + 0.085 - 0.08) net=n2
  # gate contacts
  gcS1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gcA1 = contact licon cx=(x2 - 0.16) cy=(nb + WN + 0.275)
  gcA0 = contact licon cx=(x3 - 0.16) cy=(nb + WN + 0.275)
  gcn1 = contact licon cx=(x4 - 0.16) cy=(nb + WN + 0.275)
  gcS2 = contact licon cx=(x5 - 0.16) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.83) yspan=(nb + WN + 0.09, pt - WP - 0.135)
  # metal contacts to rails
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.14) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.6) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x2 - 0.09) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc9 = contact mcon cx=(x4 + L + 0.14) cy=H
  mc10 = contact mcon cx=(x5 + L + 0.6) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A0 in on=l_A0
  port A1 in on=l_A1
  port S in on=l_S1
  port Y out on=l_n_Y
end
