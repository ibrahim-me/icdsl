# clkbuf_1: lifted from sky130_fd_sc_hd__clkbuf_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.52 WP=0.79 L=0.15 H=2.72

stdcell clkbuf_1 width=4 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A s=n1 b=VNB
  device M1 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.3
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.025, x1 + L + 0.105) yspan=(nb + WN + 0.305, pt - WP - 0.305)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, nb + WN + 0.195)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(pt - WP - 0.195, H - 0.105)
  p5 = rect poly xspan=(x2 + 0.03, x2 + L + 0.035) yspan=(nb + WN + 0.075, pt - WP - 0.075)
  p6 = rect poly xspan=(x2 + 0.03, x2 + L + 0.265) yspan=(nb + WN + 0.24, nb + WN + 0.57)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.02, x2 + 0.02) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x2 + L - 0.04, x2 + L + 0.295) yspan=(nb + WN + 0.23, pt - WP - 0.34) net=A
  l3 = rect li xspan=(x1 - 0.315, x1 - 0.145) yspan=(nb + 0.02, pt - 0.02) net=X
  l4 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.005) net=X
  l5 = rect li xspan=(x1 - 0.315, x1 - 0.045) yspan=(pt - WP - 0.135, pt - 0.02) net=X
  l6 = rect li xspan=(x1 + 0.03, x2 - 0.13) yspan=(nb + WN + 0.305, nb + WN + 0.635) net=n1
  l7 = rect li xspan=(x1 + L - 0.005, x2 - 0.13) yspan=(nb + WN - 0.12, pt - WP + 0.01) net=n1
  l8 = rect li xspan=(x1 + L - 0.005, x2 + L + 0.225) yspan=(nb + WN - 0.12, nb + WN + 0.05) net=n1
  l9 = rect li xspan=(x1 + L - 0.005, x2 + L + 0.225) yspan=(pt - WP - 0.16, pt - WP + 0.01) net=n1
  l10 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.225) yspan=(nb + 0.02, nb + WN + 0.05) net=n1
  l11 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.225) yspan=(pt - WP - 0.16, pt - 0.02) net=n1
  l12 = rect li xspan=(x1 + L - 0.02, x2 + 0.02) yspan=(pt - 0.61, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.15) span=(-0.085, nb + 0.23) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.05 - 0.08) net=n1
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.005 - 0.08) net=X
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.135 + 0.08, pt - 0.02 - 0.08) net=X
  c5 = array licon in=pd1 cx=(x1 + L + 0.15) span=(pt - 0.61, H + 0.085) margin=0.04 net=VPWR
  c6 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.16 + 0.08, pt - 0.02 - 0.08) net=n1
  gc1 = contact licon cx=(x2 + L + 0.13) cy=(nb + WN + 0.405)
  gc2 = contact licon cx=(x1 + L - 0.035) cy=(nb + WN + 0.47)
  np1 = rect npc xspan=(x1 - 0.4, x2 + L + 0.4) yspan=(nb + WN + 0.22, pt - WP - 0.285)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.17) cy=0
  mc4 = contact mcon cx=(x1 - 0.17) cy=H
  mc5 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc6 = contact mcon cx=(x2 + L + 0.17) cy=H
  well y=(pt - WP - 0.39)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l2
  port X out on=l3
end
