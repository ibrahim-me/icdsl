# a21oi_1: derived from the verified library cell a211oi_1 by removing the C1 column
# (one nmos VGND-C1-Y and one pmos n2-C1-Y). The pmos parallel node is n2 (A1||A2 to VPWR side),
# the B1 pmos drains into Y; the nmos Y drain (between A1 and B1) is joined to the pmos Y drain by route.
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a21oi_1 width=5 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.55
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.415, x3 + L + 0.30) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x3 + L + 0.30) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.335, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.075, x2 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.025, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.465, x1 - 0.125) yspan=(-0.085, nb + 0.36) net=VGND
  l2 = rect li xspan=(x3 + L - 0.02, x3 + L + 0.33) yspan=(-0.085, nb + 0.22) net=VGND
  l3 = rect li xspan=(x1 - 0.455, x1 - 0.115) yspan=(nb + WN - 0.12, pt - WP - 0.16) net=A2
  l4 = rect li xspan=(x1 + 0.06, x2 - 0.125) yspan=(nb + 0.03, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x1 + 0.06, x2 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l7 = rect li xspan=(x1 - 0.3, x1 - 0.05) yspan=(pt - WP + 0.04, pt - 0.03) net=n2
  l8 = rect li xspan=(x1 - 0.3, x3 - 0.055) yspan=(pt - WP + 0.04, pt - WP + 0.24) net=n2
  l9 = rect li xspan=(x2 + L + 0.05, x3 - 0.055) yspan=(pt - WP + 0.04, pt - 0.03) net=n2
  l10 = rect li xspan=(x3 + 0.02, x3 + L + 0.33) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l12 = rect li xspan=(x2 + L + 0.06, x3 - 0.045) yspan=(nb + 0.03, nb + WN - 0.07) net=Y
  l14 = rect li xspan=(x3 + L - 0.02, x3 + L + 0.33) yspan=(pt - 0.7, pt - 0.03) net=Y
  l17 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(pt - 0.58, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.29) span=(-0.085, nb + 0.36) net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) margin=0.04 net=Y
  c5 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.04 + 0.08, pt - 0.03 - 0.08) net=n2
  c6 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.04 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=n2
  c7 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - 0.7, pt - 0.03) net=Y
  c8 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.58, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.035) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.55, x3 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # route the nmos and pmos Y drains together (metal over the gate gap)
  route Y layers=m1,m2
  # metal
  mc1 = contact mcon cx=(x1 - 0.32) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.005) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.03) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.06) cy=0
  mc7 = contact mcon cx=(x1 - 0.32) cy=H
  mc8 = contact mcon cx=(x1 + L - 0.005) cy=H
  mc9 = contact mcon cx=(x2 + L + 0.03) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l3
  port B1 in on=l10
  port Y out
end
