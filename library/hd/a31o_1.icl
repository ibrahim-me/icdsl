# a31o_1: lifted from sky130_fd_sc_hd__a31o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a31o_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=VGND b=VNB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=A2 s=n3 b=VNB
  device M3 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M4 nmos w=WN l=L d=n3 g=A1 s=n1 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M6 pmos w=WP l=L d=n4 g=B1 s=n1 b=VPB
  device M7 nmos w=WN l=L d=VGND g=A3 s=n2 b=VNB
  device M8 pmos w=WP l=L d=n4 g=A2 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A3 s=n4 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.355
  x3 = x2 + L + 0.33
  x4 = x3 + L + 0.34
  x5 = x4 + L + 0.34
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.325) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.325) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.13) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.015, x2 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.05, x2 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l2 = rect li xspan=(x5 + L, x5 + L + 0.335) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x2 + 0.04, x3 - 0.13) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A3
  l4 = rect li xspan=(x2 + L - 0.02, x3 - 0.13) yspan=(nb + WN + 0.11, pt - WP + 0.17) net=A3
  l5 = rect li xspan=(x3 + 0.05, x4 - 0.15) yspan=(nb + WN + 0.11, pt - WP + 0.17) net=A2
  l6 = rect li xspan=(x4 + 0.05, x4 + L + 0.17) yspan=(nb + WN + 0.11, pt - WP + 0.17) net=A1
  l7 = rect li xspan=(x5 + 0.05, x5 + L + 0.15) yspan=(nb + WN + 0.11, pt - WP + 0.17) net=B1
  l8 = rect li xspan=(x2 + L - 0.01, x5) yspan=(pt - WP + 0.34, pt - WP + 0.51) net=n4
  l9 = rect li xspan=(x2 + L - 0.01, x3 - 0.085) yspan=(pt - WP + 0.34, pt - 0.07) net=n4
  l10 = rect li xspan=(x4 + L + 0.085, x5) yspan=(pt - WP + 0.34, pt - 0.07) net=n4
  l11 = rect li xspan=(x1 - 0.31, x1 - 0.12) yspan=(nb + 0.065, pt - 0.06) net=X
  l12 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(nb + 0.065, nb + WN - 0.075) net=X
  l13 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - WP + 0.09, pt - 0.06) net=X
  l14 = rect li xspan=(x1 + 0.055, x2 - 0.135) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l15 = rect li xspan=(x1 + L + 0.05, x5 + L + 0.49) yspan=(nb + 0.42, nb + WN - 0.06) net=n1
  l16 = rect li xspan=(x1 + L + 0.05, x2 - 0.135) yspan=(nb + 0.42, pt - WP - 0.16) net=n1
  l17 = rect li xspan=(x4 + L - 0.02, x5 - 0.025) yspan=(nb + 0.08, nb + WN - 0.06) net=n1
  l18 = rect li xspan=(x5 + L + 0.035, x5 + L + 0.365) yspan=(pt - WP + 0.34, pt - 0.06) net=n1
  l19 = rect li xspan=(x5 + L + 0.32, x5 + L + 0.49) yspan=(nb + 0.42, pt - 0.49) net=n1
  l20 = rect li xspan=(x1 + L + 0.05, x2 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l21 = rect li xspan=(x3 + L, x4) yspan=(pt - 0.32, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.065, nb + WN - 0.075) net=X
  c2 = array licon in=nd1 cx=(x2 - 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.15) span=(nb + 0.08, nb + WN - 0.06) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x5 + L + 0.17) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.09, pt - 0.06) net=X
  c6 = array licon in=pd1 cx=(x1 + L + 0.175) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c7 = array licon in=pd1 cx=(x2 + L + 0.16) span=(pt - WP + 0.34 + 0.08, pt - 0.07 - 0.08) margin=0.04 net=n4
  c8 = array licon in=pd1 cx=(x4 + L + 0.17) span=(pt - WP + 0.34 + 0.08, pt - 0.07 - 0.08) margin=0.04 net=n4
  c9 = array licon in=pd1 cx=(x5 + L + 0.2) span=(pt - WP + 0.34, pt - 0.06) net=n1
  c10 = array licon in=pd1 cx=(x3 + L + 0.17) span=(pt - 0.32, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.01) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.025) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x5 + L + 0.75) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.11) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.1) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.08) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.06) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.52) cy=0
  mc8 = contact mcon cx=(x1 - 0.175) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.11) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.1) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.08) cy=H
  mc13 = contact mcon cx=(x5 + L + 0.06) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.52) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l6
  port A2 in on=l5
  port A3 in on=l4
  port B1 in on=l7
  port X out on=l11
end
