# clkbuf_2: lifted from sky130_fd_sc_hd__clkbuf_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=1 L=0.15 H=2.72

stdcell clkbuf_2 width=5 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M2 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M4 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x3 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.06, x1 + L + 0.12) yspan=(nb + WN + 0.32, pt - WP - 0.09)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x1, x1 + L + 0.12) yspan=(nb + WN + 0.245, pt - WP - 0.09)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.09, pt - WP - 0.09)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.01, x2 - 0.05) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.31) yspan=(-0.085, nb + WN - 0.17) net=VGND
  l3 = rect li xspan=(x1 + 0.025, x2 - 0.095) yspan=(nb + WN + 0.09, pt - WP - 0.16) net=A
  l4 = rect li xspan=(x1 - 0.32, x1 - 0.15) yspan=(nb + 0.02, pt - 0.05) net=n1
  l5 = rect li xspan=(x1 - 0.32, x1 - 0.06) yspan=(nb + 0.02, nb + WN - 0.07) net=n1
  l6 = rect li xspan=(x1 - 0.32, x3 - 0.085) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l7 = rect li xspan=(x1 - 0.32, x1 - 0.05) yspan=(pt - WP + 0.01, pt - 0.05) net=n1
  l8 = rect li xspan=(x2 + L - 0.06, x3 - 0.085) yspan=(nb + WN + 0.34, pt - WP + 0.18) net=n1
  l9 = rect li xspan=(x2 + L + 0.02, x3 - 0.055) yspan=(nb + 0.02, nb + WN + 0.17) net=X
  l10 = rect li xspan=(x2 + L + 0.02, x3 + L + 0.285) yspan=(nb + WN, nb + WN + 0.17) net=X
  l11 = rect li xspan=(x2 + L + 0.04, x3 - 0.055) yspan=(pt - WP + 0.37, pt - 0.05) net=X
  l12 = rect li xspan=(x2 + L + 0.04, x3 + L + 0.285) yspan=(pt - WP + 0.37, pt - WP + 0.545) net=X
  l13 = rect li xspan=(x3 + L - 0.06, x3 + L + 0.285) yspan=(nb + WN, pt - WP + 0.545) net=X
  l14 = rect li xspan=(x1 + L - 0.025, x2 - 0.025) yspan=(pt - 0.63, H + 0.085) net=VPWR
  l15 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.31) yspan=(pt - 0.275, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + WN - 0.17) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.07 - 0.08) net=n1
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.17 - 0.08) margin=0.04 net=X
  c5 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.05 - 0.08) net=n1
  c6 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.63, H + 0.085) margin=0.04 net=VPWR
  c7 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.37 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.275, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 + L - 0.02) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.03) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.405, x3 + L + 0.4) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.13) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.17) cy=0
  mc5 = contact mcon cx=(x1 - 0.175) cy=H
  mc6 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc7 = contact mcon cx=(x2 + L + 0.13) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port X out on=l13
end
