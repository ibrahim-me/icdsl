pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell xnor2_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M2 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B s=n4 b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M7 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M9 nmos w=WN l=L d=n4 g=n2 s=Y b=VNB

  # gate columns, left edges. Order A B n2 B A is shared by both rows.
  # p row: VPWR M7(A) n2 M6(B) VPWR M2(n2) Y M1(B) n1 M0(A) VPWR  (one strip)
  # n row: [n4 M8(A) VGND M4(B) n4 M9(n2) Y]  [n2 M5(B) n3 M3(A) VGND]  (two islands)
  gp = max(0.28, 0.54 - L)
  x1 = 0.5
  x2 = x1 + L + gp
  x3 = x2 + L + gp
  x4 = x3 + L + 1.05
  x5 = x4 + L + gp
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                      # top of the p row
  # contact x positions
  xc0 = x1 - 0.14
  xc1 = x1 + L + gp / 2
  xc2 = x2 + L + gp / 2
  xs = x3 + L + 0.375                 # output strap (Y), right of the n2 gate
  xc4 = x4 - 0.14
  xc5 = x4 + L + gp / 2
  xc6 = x5 + L + 0.14
  xp0 = x1 - 0.14
  xp1 = x1 + L + gp / 2
  xp2 = x2 + L + gp / 2
  xp5 = x5 + L + 0.14
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.5) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gate columns (full height) and gate pads in the middle gap
  q1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  q2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  q3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  q4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  q5 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  k1 = rect poly xspan=(x1 + L/2 - 0.165, x1 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  k2 = rect poly xspan=(x2 + L/2 - 0.165, x2 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  k3 = rect poly xspan=(x3 + L/2 - 0.165, x3 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  k4 = rect poly xspan=(x4 + L/2 - 0.165, x4 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  k5 = rect poly xspan=(x5 + L/2 - 0.165, x5 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # gate contacts and gate local interconnect (one per gate column)
  gc1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275)
  gl1 = rect li xspan=(x1 + L/2 - 0.165, x1 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  gl2 = rect li xspan=(x2 + L/2 - 0.165, x2 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  gl3 = rect li xspan=(x3 + L/2 - 0.165, x3 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  gl4 = rect li xspan=(x4 + L/2 - 0.165, x4 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  gl5 = rect li xspan=(x5 + L/2 - 0.165, x5 + L/2 + 0.165) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  # n-row contacts and local interconnect
  cL0 = array licon in=nd1 cx=xc0 span=(nb + 0.1, nb + WN - 0.14) net=n4
  lL0 = rect li xspan=(xc0 - 0.115, xc0 + 0.115) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  cR1 = array licon in=nd1 cx=xc1 span=(nb + 0.1, nb + WN - 0.14) net=VGND
  lR1 = rect li xspan=(xc1 - 0.115, xc1 + 0.115) yspan=(-0.085, nb + WN - 0.06) net=VGND
  cR2 = array licon in=nd1 cx=xc2 span=(nb + 0.1, nb + WN - 0.14) net=n4
  lR2 = rect li xspan=(xc2 - 0.115, xc2 + 0.115) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  cRY = array licon in=nd1 cx=xs span=(nb + 0.1, nb + WN - 0.14) net=Y
  cL4 = array licon in=nd2 cx=xc4 span=(nb + 0.1, nb + WN - 0.14) net=n2
  lL4 = rect li xspan=(xc4 - 0.115, xc4 + 0.115) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  cR5 = array licon in=nd2 cx=xc5 span=(nb + 0.1, nb + WN - 0.14) net=n3
  lR5 = rect li xspan=(xc5 - 0.115, xc5 + 0.115) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  cR6 = array licon in=nd2 cx=xc6 span=(nb + 0.1, nb + WN - 0.14) net=VGND
  lR6 = rect li xspan=(xc6 - 0.115, xc6 + 0.115) yspan=(-0.085, nb + WN - 0.06) net=VGND
  # output strap: n-row Y contact up to the p-row Y contact (vertical, right of gate 3)
  cPY = array licon in=pd1 cx=xs span=(pt - WP + 0.09, pt - 0.1) net=Y
  lY = rect li xspan=(xs - 0.115, xs + 0.115) yspan=(nb + 0.02, pt - 0.02) net=Y
  # p-row contacts and local interconnect
  cP0 = array licon in=pd1 cx=xp0 span=(pt - WP + 0.09, pt - 0.1) net=VPWR
  lP0 = rect li xspan=(xp0 - 0.115, xp0 + 0.115) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  cP1 = array licon in=pd1 cx=xp1 span=(pt - WP + 0.09, pt - 0.1) net=n2
  lP1 = rect li xspan=(xp1 - 0.115, xp1 + 0.115) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  cP2 = array licon in=pd1 cx=xp2 span=(pt - WP + 0.09, pt - 0.1) net=VPWR
  lP2 = rect li xspan=(xp2 - 0.115, xp2 + 0.115) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  cP5 = array licon in=pd1 cx=xp5 span=(pt - WP + 0.09, pt - 0.1) net=VPWR
  lP5 = rect li xspan=(xp5 - 0.115, xp5 + 0.115) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # metal rails
  mc1 = contact mcon cx=(x1 - 0.375) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.06) cy=0
  mc3 = contact mcon cx=(x1 + L + 0.405) cy=0
  mc4 = contact mcon cx=(x1 - 0.375) cy=H
  mc5 = contact mcon cx=(x1 + L - 0.06) cy=H
  mc6 = contact mcon cx=(x1 + L + 0.405) cy=H
  # wells and implant
  np1 = rect npc xspan=(x1 - 0.42, x5 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # connections that need routing: A, B, n2, n4 (labelled pins above)
  route A layers=m1,m2
  route B layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2
  # pins
  port A in on=gl1
  port B in on=gl2
  port Y out on=lY
end
