# o21a_2: lifted from sky130_fd_sc_hd__o21a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o21a_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=B1 s=n2 b=VPB
  device M4 nmos w=WN l=L d=VGND g=A1 s=n1 b=VNB
  device M5 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M6 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M7 pmos w=WP l=L d=n2 g=A2 s=n3 b=VPB
  device M8 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n2 g=B1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.285
  x3 = x2 + L + 0.81
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.33
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.27) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.27, x5 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L + 0.31) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.15)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.25, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.075, x4 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.295) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x3 + L + 0.05, x4 - 0.03) yspan=(nb + 0.23, nb + WN - 0.06) net=n1
  l2 = rect li xspan=(x3 + L + 0.05, x5 + L + 0.305) yspan=(nb + WN - 0.25, nb + WN - 0.06) net=n1
  l3 = rect li xspan=(x5 + L + 0.03, x5 + L + 0.305) yspan=(nb + 0.26, nb + WN - 0.06) net=n1
  l4 = rect li xspan=(x1 - 0.295, x1 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l5 = rect li xspan=(x2 + L - 0.025, x2 + L + 0.31) yspan=(-0.085, nb + 0.23) net=VGND
  l6 = rect li xspan=(x4 + L - 0.005, x5 + 0.005) yspan=(-0.085, nb + 0.23) net=VGND
  l7 = rect li xspan=(x5 + L + 0.05, x5 + L + 0.31) yspan=(nb + WN + 0.11, pt - WP - 0.035) net=A1
  l8 = rect li xspan=(x3 - 0.33, x3 + L - 0.065) yspan=(nb + WN + 0.125, pt - WP + 0.13) net=B1
  l9 = rect li xspan=(x3 + L + 0.11, x5 - 0.065) yspan=(nb + WN + 0.14, pt - WP - 0.085) net=A2
  l10 = rect li xspan=(x4 + L + 0.06, x5 - 0.065) yspan=(nb + WN + 0.14, pt - WP + 0.5) net=A2
  l11 = rect li xspan=(x1 + L - 0.015, x2 - 0.05) yspan=(nb + 0.02, pt - 0.02) net=X
  l12 = rect li xspan=(x2 + L - 0.025, x2 + L + 0.31) yspan=(nb + 0.4, pt - WP - 0.155) net=n2
  l13 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(nb + 0.4, nb + WN - 0.045) net=n2
  l14 = rect li xspan=(x2 + L + 0.14, x2 + L + 0.31) yspan=(nb + 0.4, pt - 0.48) net=n2
  l15 = rect li xspan=(x2 + L + 0.14, x4 + 0.025) yspan=(pt - WP + 0.3, pt - 0.48) net=n2
  l16 = rect li xspan=(x3 - 0.31, x3 + 0.025) yspan=(nb + 0.02, nb + WN - 0.045) net=n2
  l17 = rect li xspan=(x3 + L + 0.05, x4 + 0.025) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l18 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP + 0.15, H + 0.085) net=VPWR
  l19 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(pt - 0.3, H + 0.085) net=VPWR
  l20 = rect li xspan=(x5 + L - 0.025, x5 + L + 0.305) yspan=(pt - WP + 0.165, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd2 cx=(x4 + L + 0.165) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x3 - 0.145) span=(nb + 0.02, nb + WN - 0.045) net=n2
  c5 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd2 cx=(x3 + L + 0.145) span=(nb + 0.23 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c7 = array licon in=nd2 cx=(x5 + L + 0.145) span=(nb + 0.26 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.15 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - WP + 0.165 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c12 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - 0.3, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x3 - 0.145) span=(pt - 0.3, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.145) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 - 0.085) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.055) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.16) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.135) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.185) cy=0
  mc4 = contact mcon cx=(x3 - 0.165) cy=0
  mc5 = contact mcon cx=(x4 - 0.135) cy=0
  mc6 = contact mcon cx=(x5 - 0.145) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.175) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.135) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.185) cy=H
  mc11 = contact mcon cx=(x3 - 0.165) cy=H
  mc12 = contact mcon cx=(x4 - 0.135) cy=H
  mc13 = contact mcon cx=(x5 - 0.145) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l10
  port B1 in on=l8
  port X out on=l11
end
