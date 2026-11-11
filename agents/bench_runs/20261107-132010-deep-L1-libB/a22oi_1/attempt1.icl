pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a22oi_1 width=7 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y b=VNB
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1 b=VNB
  device M5 pmos w=WP l=L d=Y g=B2 s=n2 b=VPB
  device M6 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
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
  l1 = rect li xspan=(x1 - 0.315, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x4 + L + 0.025, x4 + L + 0.315) yspan=(-0.085, nb + WN) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 - 0.025) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l4 = rect li xspan=(x4 + L + 0.025, x4 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l5 = rect li xspan=(x1 + L - 0.03, x2 - 0.07) yspan=(nb + 0.02, nb + WN - 0.02) net=n1
  l6 = rect li xspan=(x2 + L - 0.03, x3 - 0.07) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  l7 = rect li xspan=(x1 + L - 0.03, x2 - 0.07) yspan=(pt - WP + 0.02, pt - 0.02) net=n2
  l8 = rect li xspan=(x3 + L - 0.03, x4 - 0.07) yspan=(pt - WP + 0.02, pt - 0.02) net=n2
  l9 = rect li xspan=(x1 + L - 0.03, x4 - 0.07) yspan=(nb + 0.42, nb + WN - 0.02) net=Y
  l10 = rect li xspan=(x1 + L - 0.03, x4 - 0.07) yspan=(pt - WP + 0.35, pt - 0.02) net=Y
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=n1
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=n3
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c6 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c8 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L + 0.17) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
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
  port A1 in on=p2
  port A2 in on=p4
  port B1 in on=p6
  port B2 in on=p8
  port Y out on=l10
end
