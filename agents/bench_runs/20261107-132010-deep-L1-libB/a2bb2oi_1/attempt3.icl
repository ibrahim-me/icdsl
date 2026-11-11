pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a2bb2oi_1 width=9 height=H taps=no
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

  # gate columns (left edges): same order for n and p rows
  x1 = 0.405                          # A1_N
  x2 = x1 + L + max(0.28, 0.54 - L)   # A2_N (contact column between x1 and x2)
  x3 = x2 + L + 0.80                  # B1 (island break)
  x4 = x3 + L + max(0.28, 0.54 - L)   # B2 (contact column between x3 and x4)
  x5 = x4 + L + 0.80                  # n2 (island break)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: NMOS islands
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)   # VGND-n2-VGND (A1_N,A2_N)
  nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)   # VGND-n3-Y (B1,B2)
  nd3 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)   # VGND-Y (n2)
  nim = enclose [nd1, nd2, nd3] nsdm

  # diffusion: PMOS islands
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)   # VPWR-n1-n2 (A1_N,A2_N)
  pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)   # VPWR-n4-VPWR (B1,B2)
  pd3 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)   # Y-n4 (n2)
  pim = enclose [pd1, pd2, pd3] psdm

  # poly: gates (cross both rows)
  g1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)   # A1_N
  g2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)   # A2_N
  g3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)   # B1
  g4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)   # B2
  g5 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)   # n2

  # gate pads (extend into diffusion rows)
  gp1 = rect poly xspan=(x1 - 0.285, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # A1_N pad
  gp2 = rect poly xspan=(x2, x2 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # A2_N pad
  gp3 = rect poly xspan=(x3 - 0.275, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # B1 pad
  gp4 = rect poly xspan=(x4, x4 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # B2 pad
  gp5 = rect poly xspan=(x5 - 0.075, x5 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16)   # n2 pad

  # local interconnect: NMOS side
  l1 = rect li xspan=(x1 + L + 0.06, x2 - 0.06) yspan=(-0.085, nb + 0.22) net=VGND   # VGND between A1_N and A2_N
  l2 = rect li xspan=(x2 + L + 0.06, x3 - 0.06) yspan=(-0.085, nb + 0.22) net=VGND   # VGND right of A2_N
  l3 = rect li xspan=(x3 + L + 0.06, x4 - 0.06) yspan=(-0.085, nb + 0.22) net=VGND   # VGND between B1 and B2
  l4 = rect li xspan=(x4 + L + 0.06, x5 - 0.06) yspan=(-0.085, nb + 0.22) net=VGND   # VGND right of B2
  l5 = rect li xspan=(x1 - 0.33, x1 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1_N   # A1_N input
  l6 = rect li xspan=(x2 - 0.33, x2 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2_N   # A2_N input
  l7 = rect li xspan=(x3 - 0.33, x3 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1   # B1 input
  l8 = rect li xspan=(x4 - 0.33, x4 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B2   # B2 input
  l9 = rect li xspan=(x5 - 0.33, x5 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2   # n2 input
  l10 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.03, nb + WN - 0.07) net=n2   # n2 in nd1
  l11 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.03, nb + WN - 0.07) net=n3   # n3 in nd2
  l12 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.03, nb + WN - 0.07) net=Y   # Y in nd2
  l13 = rect li xspan=(x5 + L + 0.045, x5 + L + 0.27) yspan=(nb + 0.03, nb + WN - 0.07) net=Y   # Y right of n2 in nd3
  l14 = rect li xspan=(x5 - 0.315, x5 - 0.05) yspan=(nb + 0.03, nb + WN - 0.07) net=Y   # Y left of n2 in nd3

  # local interconnect: PMOS side
  l15 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(pt - WP + 0.02, pt - 0.03) net=n1   # n1 in pd1
  l16 = rect li xspan=(x2 + L + 0.045, x2 + L + 0.27) yspan=(pt - WP + 0.02, pt - 0.03) net=n2   # n2 right of A2_N in pd1
  l17 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.02, pt - 0.03) net=n4   # n4 in pd2
  l18 = rect li xspan=(x5 - 0.315, x5 - 0.05) yspan=(pt - WP + 0.02, pt - 0.03) net=Y   # Y left of n2 in pd3
  l19 = rect li xspan=(x5 + L + 0.045, x5 + L + 0.27) yspan=(pt - WP + 0.02, pt - 0.03) net=n4   # n4 right of n2 in pd3
  l20 = rect li xspan=(x1 + L - 0.025, x1 + L + 0.31) yspan=(pt - 0.57, H + 0.085) net=VPWR   # VPWR at A1_N
  l21 = rect li xspan=(x3 + L - 0.025, x3 + L + 0.31) yspan=(pt - 0.57, H + 0.085) net=VPWR   # VPWR at B1

  # contacts: NMOS diffusion columns
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.22 - 0.08) net=VGND   # VGND left of A1_N
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=n2   # n2 between A1_N and A2_N
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.22 - 0.08) net=VGND   # VGND right of A2_N
  c4 = array licon in=nd2 cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + 0.22 - 0.08) net=VGND   # VGND left of B1
  c5 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=n3   # n3 between B1 and B2
  c6 = array licon in=nd2 cx=(x4 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=Y   # Y right of B2
  c7 = array licon in=nd3 cx=(x5 - 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=Y   # Y left of n2
  c8 = array licon in=nd3 cx=(x5 + L + 0.14) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=Y   # Y right of n2

  # contacts: PMOS diffusion columns
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=VPWR   # VPWR left of A1_N
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n1   # n1 between A1_N and A2_N
  c11 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n2   # n2 right of A2_N
  c12 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=VPWR   # VPWR left of B1
  c13 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n4   # n4 between B1 and B2
  c14 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=VPWR   # VPWR right of B2
  c15 = array licon in=pd3 cx=(x5 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=Y   # Y left of n2
  c16 = array licon in=pd3 cx=(x5 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n4   # n4 right of n2

  # gate contacts
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(nb + WN + 0.275) net=A1_N   # A1_N gate contact
  gc2 = contact licon cx=(x2 - 0.14) cy=(nb + WN + 0.275) net=A2_N   # A2_N gate contact
  gc3 = contact licon cx=(x3 + L + 0.14) cy=(nb + WN + 0.275) net=B1   # B1 gate contact
  gc4 = contact licon cx=(x4 - 0.14) cy=(nb + WN + 0.275) net=B2   # B2 gate contact
  gc5 = contact licon cx=(x5 + L + 0.14) cy=(nb + WN + 0.275) net=n2   # n2 gate contact

  np1 = rect npc xspan=(x1 - 0.405, x5 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal: supply rails
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 - 0.205) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.115) cy=0
  mc5 = contact mcon cx=(x3 - 0.17) cy=0
  mc6 = contact mcon cx=(x3 + L + 0.145) cy=0
  mc7 = contact mcon cx=(x4 - 0.205) cy=0
  mc8 = contact mcon cx=(x4 + L + 0.115) cy=0
  mc9 = contact mcon cx=(x5 - 0.17) cy=0
  mc10 = contact mcon cx=(x5 + L + 0.145) cy=0
  mc11 = contact mcon cx=(x1 - 0.17) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc13 = contact mcon cx=(x2 - 0.205) cy=H
  mc14 = contact mcon cx=(x2 + L + 0.115) cy=H
  mc15 = contact mcon cx=(x3 - 0.17) cy=H
  mc16 = contact mcon cx=(x3 + L + 0.145) cy=H
  mc17 = contact mcon cx=(x4 - 0.205) cy=H
  mc18 = contact mcon cx=(x4 + L + 0.115) cy=H
  mc19 = contact mcon cx=(x5 - 0.17) cy=H
  mc20 = contact mcon cx=(x5 + L + 0.145) cy=H

  # straps: connect diffusion contacts to rails
  s1 = strap li from=c1 to=vgnd_li
  s2 = strap li from=c3 to=vgnd_li
  s3 = strap li from=c4 to=vgnd_li
  s4 = strap li from=c9 to=vpwr_li
  s5 = strap li from=c12 to=vpwr_li

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # pins
  port A1_N in on=l5
  port A2_N in on=l6
  port B1 in on=l7
  port B2 in on=l8
  port Y out on=l12
end
