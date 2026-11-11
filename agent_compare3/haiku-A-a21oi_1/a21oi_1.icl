pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a21oi_1 width=5 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB

  # gate columns (left edges), left to right: B1, A1, A2
  x1 = 0.42
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.49
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  gy = nb + WN + 0.275               # gate-contact height, between the rows
  # diffusion (shared by both rows' gates)
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates and pads (pads on the outside of each gate, >= 0.21 from the next gate)
  gB = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  pB = rect poly xspan=(x1 - 0.315, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  gA1 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  pA1 = rect poly xspan=(x2, x2 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  gA2 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  pA2 = rect poly xspan=(x3, x3 + L + 0.265) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect: gate straps
  lB = rect li xspan=(x1 - 0.325, x1 + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.2) net=B1
  lA1 = rect li xspan=(x2 + L - 0.045, x2 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  lA2 = rect li xspan=(x3 + L - 0.045, x3 + L + 0.295) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A2
  # local interconnect: diffusion columns
  l1 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x1 - 0.25, x1 - 0.025) yspan=(pt - WP, pt - 0.02) net=Y
  l3 = rect li xspan=(x1 + L + 0.04, x1 + L + 0.24) yspan=(nb + 0.02, nb + WN) net=Y
  l4 = rect li xspan=(x1 + L + 0.04, x1 + L + 0.24) yspan=(pt - WP, pt - 0.02) net=n2
  l5 = rect li xspan=(x2 + L + 0.145, x2 + L + 0.345) yspan=(nb + 0.02, nb + WN) net=n1
  l6 = rect li xspan=(x2 + L + 0.145, x2 + L + 0.345) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l7 = rect li xspan=(x3 + L - 0.055, x3 + L + 0.255) yspan=(-0.085, nb + WN) net=VGND
  l8 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.255) yspan=(pt - WP, pt - 0.02) net=n2
  # contacts: diffusion columns, gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.085, nb + WN - 0.085) net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.245) span=(nb + 0.085, nb + WN - 0.085) net=n1
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  d1 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.085, pt - 0.085) net=Y
  d2 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.085, pt - 0.085) net=n2
  d3 = array licon in=pd1 cx=(x2 + L + 0.245) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  d4 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.085, pt - 0.085) net=n2
  gcB = contact licon cx=(x1 - 0.155) cy=gy
  gcA1 = contact licon cx=(x2 + L + 0.125) cy=gy
  gcA2 = contact licon cx=(x3 + L + 0.125) cy=gy
  np1 = rect npc xspan=(x1 - 0.42, x3 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x3 + L + 0.09) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.195) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  route Y layers=m1,m2
  route n2 layers=m1,m2
  port A1 in on=lA1
  port A2 in on=lA2
  port B1 in on=lB
  port Y out
end
