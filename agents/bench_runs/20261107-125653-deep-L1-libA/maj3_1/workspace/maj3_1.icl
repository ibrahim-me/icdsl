# maj3_1: X = (A&B) | (A&C) | (B&C)
# tapless stdcell, PDK widths, gate order A B C n3 (same for n and p rows)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=10 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB

  # gate columns (left edges): same order for n and p rows
  x1 = 0.605                          # gate A
  x2 = x1 + L + max(0.28, 0.54 - L)   # gate B
  x3 = x2 + L + max(0.28, 0.54 - L)   # gate C
  x4 = x3 + L + max(0.28, 0.54 - L)   # gate n3
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                      # top of the p row

  # ===== N ROW diffusion islands =====
  # Island 1: M4(A) s=n2 | M1(B) d=n2,s=n3 | M2(B) d=n3,s=n4 | M9(C) d=n4
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN2)
  # Island 2: M5(A) d=n5,s=VGND | M10(C) d=n3,s=n5
  nd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN2)
  # Island 3: M3(n3) d=VGND,s=X
  nd3 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)

  # ===== P ROW diffusion islands =====
  # Island 1: M0(A) d=n1,s=VPWR | M11(C) d=n3,s=n1
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)
  # Island 2: M12(A) d=VPWR,s=n7 | M13(B) d=n7,s=n3 | M6(B) d=n3,s=n6 | M7(C) d=n6,s=VPWR
  pd2 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)
  # Island 3: M8(n3) d=VPWR,s=X
  pd3 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)

  # implants
  nim1 = enclose [nd1, nd2, nd3] nsdm
  pim1 = enclose [pd1, pd2, pd3] psdm

  # ===== POLY GATES (cross both rows) =====
  pA = cross [nd1, nd2, pd1, pd2] poly w=L x=x1
  pB = cross [nd1, pd2] poly w=L x=x2
  pC = cross [nd1, nd2, pd1, pd2] poly w=L x=x3
  pn3 = cross [nd3, pd3] poly w=L x=x4

  # gate contact height (above n row, below p row)
  cb = nb + WN + 0.275

  # gate contacts (shifted left by 0.12 from gate centre)
  gcA = contact licon cx=(x1 - 0.12) cy=cb net=A
  gcB = contact licon cx=(x2 - 0.12) cy=cb net=B
  gcC = contact licon cx=(x3 - 0.12) cy=cb net=C
  gcn3 = contact licon cx=(x4 - 0.12) cy=cb net=n3
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # ===== N ROW LI =====
  # M4: d=VGND (left end of island 1)
  lN1 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(-0.085, nb + WN2) net=VGND
  cN1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.08) net=VGND
  strapN1 = strap li from=lN1 to=vgnd_li

  # M4 s=n2 / M1 d=n2 (shared between x1 and x2)
  lN2 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN2) net=n2
  cN2a = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN2) net=n2
  cN2b = array licon in=nd1 cx=(x2 - 0.14) span=(nb + 0.02, nb + WN2) net=n2

  # M1 s=n3 / M2 d=n3 (shared within gate B column)
  lN3a = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(nb + 0.02, nb + WN2) net=n3
  cN3a = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN2) net=n3

  # M2 s=n4 / M9 d=n4 (shared between x2 and x3)
  lN4 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN2) net=n4
  cN4a = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN2) net=n4
  cN4b = array licon in=nd1 cx=(x3 - 0.14) span=(nb + 0.02, nb + WN2) net=n4

  # M5: d=n5 (left end of island 2), s=VGND (right end)
  lN5 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(nb + 0.02, nb + WN2) net=n5
  cN5a = array licon in=nd2 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN2) net=n5
  lN6 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(nb + 0.02, nb + WN2) net=VGND
  cN6 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN2) net=VGND
  strapN6 = strap li from=lN6 to=vgnd_li

  # M10: d=n3 (left of x3), s=n5 (right of x3)
  lN7 = rect li xspan=(x3 - 0.335, x3 - 0.055) yspan=(nb + 0.02, nb + WN2) net=n3
  cN7 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.02, nb + WN2) net=n3
  lN8 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(nb + 0.02, nb + WN2) net=n5
  cN8 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN2) net=n5

  # M3: d=VGND (left of x4), s=X (right of x4)
  lN9 = rect li xspan=(x4 - 0.335, x4 - 0.055) yspan=(nb + 0.02, nb + WN) net=VGND
  cN9 = array licon in=nd3 cx=(x4 - 0.14) span=(nb + 0.02, nb + WN) net=VGND
  strapN9 = strap li from=lN9 to=vgnd_li
  lN10 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=X
  cN10 = array licon in=nd3 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) net=X

  # ===== P ROW LI =====
  # M0: d=n1 (left of x1), s=VPWR (right end of island 1)
  lP1 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP2, pt) net=n1
  cP1 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2, pt) net=n1
  lP2 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(pt - WP2, pt) net=VPWR
  cP2 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP2, pt) net=VPWR
  strapP2 = strap li from=lP2 to=vpwr_li

  # M11: d=n3 (left of x3), s=n1 (right of x3)
  lP3 = rect li xspan=(x3 - 0.335, x3 - 0.055) yspan=(pt - WP2, pt) net=n3
  cP3 = array licon in=pd1 cx=(x3 - 0.14) span=(pt - WP2, pt) net=n3
  lP4 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(pt - WP2, pt) net=n1
  cP4 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP2, pt) net=n1

  # M12: d=VPWR (left of x1), s=n7 (right of x1)
  lP5 = rect li xspan=(x1 - 0.335, x1 - 0.055) yspan=(pt - WP2, pt) net=VPWR
  cP5 = array licon in=pd2 cx=(x1 - 0.14) span=(pt - WP2, pt) net=VPWR
  strapP5 = strap li from=lP5 to=vpwr_li
  lP6 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.305) yspan=(pt - WP2, pt) net=n7
  cP6 = array licon in=pd2 cx=(x1 + L + 0.14) span=(pt - WP2, pt) net=n7

  # M13: d=n7 (left of x2), s=n3 (right of x2)
  lP7 = rect li xspan=(x2 - 0.335, x2 - 0.055) yspan=(pt - WP2, pt) net=n7
  cP7 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP2, pt) net=n7
  lP8 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(pt - WP2, pt) net=n3
  cP8 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP2, pt) net=n3

  # M6: d=n3 (left of x2), s=n6 (right of x2)
  lP9 = rect li xspan=(x2 - 0.335, x2 - 0.055) yspan=(pt - WP2, pt) net=n3
  cP9 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - WP2, pt) net=n3
  lP10 = rect li xspan=(x2 + L - 0.03, x2 + L + 0.305) yspan=(pt - WP2, pt) net=n6
  cP10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP2, pt) net=n6

  # M7: d=n6 (left of x3), s=VPWR (right of x3)
  lP11 = rect li xspan=(x3 - 0.335, x3 - 0.055) yspan=(pt - WP2, pt) net=n6
  cP11 = array licon in=pd2 cx=(x3 - 0.14) span=(pt - WP2, pt) net=n6
  lP12 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.305) yspan=(pt - WP2, pt) net=VPWR
  cP12 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP2, pt) net=VPWR
  strapP12 = strap li from=lP12 to=vpwr_li

  # M8: d=VPWR (left of x4), s=X (right of x4)
  lP13 = rect li xspan=(x4 - 0.335, x4 - 0.055) yspan=(pt - WP, pt) net=VPWR
  cP13 = array licon in=pd3 cx=(x4 - 0.14) span=(pt - WP, pt) net=VPWR
  strapP13 = strap li from=lP13 to=vpwr_li
  lP14 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(pt - WP, pt) net=X
  cP14 = array licon in=pd3 cx=(x4 + L + 0.14) span=(pt - WP, pt) net=X

  # ===== OUTPUT X: join n and p drains =====
  route X layers=m1,m2

  # ===== SUPPLY RAILS =====
  mcN = contact mcon cx=(x1 - 0.375) cy=0
  mcP = contact mcon cx=(x1 - 0.375) cy=H

  # n-well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # ===== PORTS =====
  port A in on=gcA
  port B in on=gcB
  port C in on=gcC
  port X out
end
