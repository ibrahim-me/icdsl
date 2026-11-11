# nor2_1: lifted from sky130_fd_sc_hd__nor2_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nor2_1 width=4 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M3 pmos w=WP l=L d=Y g=B s=n1 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.205) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.29, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L + 0.315) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.295, x1 - 0.055) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.325) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l4 = rect li xspan=(x3 + L - 0.02, x3 + L + 0.335) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.035) net=Y
  l6 = rect li xspan=(x1 - 0.305, x2 + 0.02) yspan=(pt - WP + 0.01, pt - 0.82) net=Y
  l7 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN + 0.01) net=Y
  l8 = rect li xspan=(x1 + L + 0.065, x2 + 0.02) yspan=(nb + 0.02, pt - 0.82) net=Y
  l9 = rect li xspan=(x3 + L - 0.01, x3 + L + 0.325) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 - 0.08) span=(nb + 0.02, nb + WN + 0.01) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) net=VGND
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.035) net=Y
  c5 = array licon in=pd1 cx=(x3 + L + 0.08) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L + 0.15) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x3 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x1 - 0.17) cy=H
  mc5 = contact mcon cx=(x2 - 0.07) cy=H
  mc6 = contact mcon cx=(x3 + L + 0.19) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l3
  port Y out on=l5
end
