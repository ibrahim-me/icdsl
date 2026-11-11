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

  # gate columns (left edges): order A1, A2, B2, B1 (works for both rows)
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.80
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion: n-row one continuous island (Y-n3-VGND-n1-Y chain matches)
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  # p-row two islands: (A1,A2): VPWR-n2-VPWR ; (B2,B1): Y-n2-Y ; break between x2 and x3
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.025, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.025, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.025, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  # n-row nd1: left Y (M6.s), n3 (M6.d/M3.s), VGND (M3.d/M4.s), n1 (M4.d/M0.s), right Y (M0.d)
  l1 = rect li xspan=(x1 - 0.265, x1 + 0.03) yspan=(nb + 0.06, nb + WN - 0.06) net=Y
  l2 = rect li xspan=(x1 + L + 0.03, x2 - 0.03) yspan=(nb + 0.06, nb + WN - 0.06) net=n3
  l3 = rect li xspan=(x2 + L + 0.03, x3 - 0.03) yspan=(nb + 0.06, nb + WN - 0.06) net=VGND
  l4 = rect li xspan=(x3 + L + 0.03, x4 - 0.03) yspan=(nb + 0.06, nb + WN - 0.06) net=n1
  l5 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.265) yspan=(nb + 0.06, nb + WN - 0.06) net=Y
  # p-row island1 pd1 (x1..x2): left VPWR (M2.d), n2 (M2.s/M1.d), right VPWR (M1.s)
  l6 = rect li xspan=(x1 - 0.265, x1 + 0.03) yspan=(pt - WP + 0.06, pt - 0.06) net=VPWR
  l7 = rect li xspan=(x1 + L + 0.03, x2 - 0.03) yspan=(pt - WP + 0.06, pt - 0.06) net=n2
  l8 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.265) yspan=(pt - WP + 0.06, pt - 0.06) net=VPWR
  # p-row island2 pd2 (x3..x4): left Y (M5.d), n2 (M5.s/M7.d), right Y (M7.s)
  l9 = rect li xspan=(x3 - 0.265, x3 + 0.03) yspan=(pt - WP + 0.06, pt - 0.06) net=Y
  l10 = rect li xspan=(x3 + L + 0.03, x4 - 0.03) yspan=(pt - WP + 0.06, pt - 0.06) net=n2
  l11 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.265) yspan=(pt - WP + 0.06, pt - 0.06) net=Y
  # input li strips crossing each gate (for ports)
  liA1 = rect li xspan=(x1 - 0.315, x1 + L + 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A1
  liA2 = rect li xspan=(x2 - 0.315, x2 + L + 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A2
  liB2 = rect li xspan=(x3 - 0.315, x3 + L + 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B2
  liB1 = rect li xspan=(x4 - 0.315, x4 + L + 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B1
  # contacts: diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06, nb + WN - 0.06) net=Y
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) net=n3
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) net=n1
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.06, nb + WN - 0.06) net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.06, pt - 0.06) net=VPWR
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.06, pt - 0.06) net=n2
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.06, pt - 0.06) net=VPWR
  c9 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.06, pt - 0.06) net=Y
  c10 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.06, pt - 0.06) net=n2
  c11 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.06, pt - 0.06) net=Y
  # gate contacts
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.17) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal: supply contacts
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 - 0.07) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.18) cy=0
  mc5 = contact mcon cx=(x1 - 0.17) cy=H
  mc6 = contact mcon cx=(x2 - 0.07) cy=H
  mc7 = contact mcon cx=(x3 - 0.07) cy=H
  mc8 = contact mcon cx=(x4 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)
  # pins
  port A1 in on=liA1
  port A2 in on=liA2
  port B1 in on=liB1
  port B2 in on=liB2
  port Y out on=l11
end
