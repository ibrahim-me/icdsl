# clkbuf_4: lifted from sky130_fd_sc_hd__clkbuf_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=1 L=0.15 H=2.72

stdcell clkbuf_4 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M4 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M6 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M7 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M8 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.34
  x3 = x2 + 0.005
  x4 = x3 + L + 0.285
  x5 = x4 + 0.005
  x6 = x5 + L + 0.285
  x7 = x6 + 0.005
  x8 = x7 + L + 0.285
  x9 = x8 + 0.005
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x9 + L + 0.295) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x9 + L + 0.3) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.06, x1 + L + 0.1) yspan=(nb + WN + 0.34, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.395, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.19)
  p5 = rect poly xspan=(x3, x8 + L) yspan=(nb + WN + 0.365, pt - WP - 0.19)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.365, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.19)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.365, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.365, H - 0.105)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.3)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.01, x2 - 0.055) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l2 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l3 = rect li xspan=(x9 + L + 0.015, x9 + L + 0.295) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l4 = rect li xspan=(x1 + 0.025, x2 - 0.11) yspan=(nb + WN + 0.1, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 - 0.32, x1 - 0.15) yspan=(nb + 0.02, pt - 0.02) net=n1
  l6 = rect li xspan=(x1 - 0.32, x1 - 0.02) yspan=(nb + 0.02, nb + WN - 0.07) net=n1
  l7 = rect li xspan=(x1 - 0.32, x3 + L + 0.085) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l8 = rect li xspan=(x1 - 0.32, x1 - 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l9 = rect li xspan=(x3 + 0.06, x8 - 0.09) yspan=(nb + WN + 0.42, pt - WP - 0.24) net=n1
  l10 = rect li xspan=(x3 + 0.06, x3 + L + 0.085) yspan=(nb + WN + 0.42, pt - WP + 0.18) net=n1
  l11 = rect li xspan=(x2 + L - 0.02, x4 - 0.01) yspan=(nb + 0.11, nb + WN + 0.25) net=X
  l12 = rect li xspan=(x2 + L - 0.02, x9 + L + 0.34) yspan=(nb + WN + 0.08, nb + WN + 0.25) net=X
  l13 = rect li xspan=(x3 + L + 0.015, x4 - 0.01) yspan=(pt - WP + 0.35, pt - 0.02) net=X
  l14 = rect li xspan=(x3 + L + 0.015, x8 - 0.01) yspan=(pt - WP + 0.35, pt - WP + 0.52) net=X
  l15 = rect li xspan=(x7 + L + 0.015, x8 - 0.01) yspan=(nb + 0.11, nb + WN + 0.25) net=X
  l16 = rect li xspan=(x7 + L + 0.015, x8 - 0.01) yspan=(pt - WP - 0.07, pt - 0.02) net=X
  l17 = rect li xspan=(x7 + L + 0.015, x9 + L + 0.34) yspan=(pt - WP - 0.07, pt - WP + 0.1) net=X
  l18 = rect li xspan=(x8 + L - 0.065, x9 + L + 0.34) yspan=(nb + WN + 0.08, pt - WP + 0.1) net=X
  l19 = rect li xspan=(x1 + L + 0.02, x2 - 0.01) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l20 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l21 = rect li xspan=(x9 + L + 0.015, x9 + L + 0.3) yspan=(pt - 0.72, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x6 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x9 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) net=n1
  c5 = array licon in=nd1 cx=(x4 - 0.14) span=(nb + 0.11 + 0.08, nb + WN + 0.25 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x8 - 0.14) span=(nb + 0.11 + 0.08, nb + WN + 0.25 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.07 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  c9 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.72 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.35 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.04) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x4 - 0.075) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 + L + 0.12) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x7 + L + 0.03) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.405, x9 + L + 0.44) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.12) cy=0
  mc4 = contact mcon cx=(x6 - 0.135) cy=0
  mc5 = contact mcon cx=(x8 - 0.105) cy=0
  mc6 = contact mcon cx=(x9 + L + 0.21) cy=0
  mc7 = contact mcon cx=(x1 - 0.175) cy=H
  mc8 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc9 = contact mcon cx=(x3 + L + 0.12) cy=H
  mc10 = contact mcon cx=(x6 - 0.135) cy=H
  mc11 = contact mcon cx=(x8 - 0.105) cy=H
  mc12 = contact mcon cx=(x9 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port X out on=l16
end
