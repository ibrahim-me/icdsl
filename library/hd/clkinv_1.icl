# clkinv_1: lifted from sky130_fd_sc_hd__clkinv_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.84 L=0.15 H=2.72

stdcell clkinv_1 width=4 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M1 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.275
  x3 = x2 + 0.005
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 + L + 0.01, x3 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x2 + L) yspan=(nb + WN + 0.34, pt - WP - 0.32)
  p2 = rect poly xspan=(x1 - 0.01, x2 + L) yspan=(nb + WN + 0.32, nb + WN + 0.54)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.32, H - 0.105)
  p4 = rect poly xspan=(x1, x2) yspan=(nb + WN + 0.32, pt - WP - 0.3)
  p5 = rect poly xspan=(x2, x3) yspan=(0.105, pt - WP - 0.3)
  p6 = rect poly xspan=(x3, x2 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.54, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 + L + 0.05, x3 + L + 0.335) yspan=(-0.085, nb + WN - 0.065) net=VGND
  l2 = rect li xspan=(x1 - 0.315, x1 - 0.075) yspan=(nb + 0.14, pt - WP - 0.32) net=A
  l3 = rect li xspan=(x1 + L - 0.03, x3 + 0.025) yspan=(nb + 0.02, pt - 0.02) net=Y
  l4 = rect li xspan=(x1 + L - 0.03, x3 + L + 0.335) yspan=(nb + WN + 0.105, pt - WP - 0.355) net=Y
  l5 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(nb + WN + 0.105, pt - 0.02) net=Y
  l6 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.02, H + 0.085) net=VPWR
  l7 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.335) yspan=(pt - WP + 0.02, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.135) span=(-0.085 + 0.08, nb + WN - 0.065 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.135) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=Y
  c3 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.02 + 0.08, H + 0.085 - 0.08) net=VPWR
  c4 = array licon in=pd1 cx=(x2 - 0.135) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c5 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.02 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(pt - WP - 0.485)
  np1 = rect npc xspan=(x1 - 0.4, x3 + L + 0.42) yspan=(nb + WN + 0.32, pt - WP - 0.3)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.125) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x1 - 0.17) cy=H
  mc5 = contact mcon cx=(x2 - 0.125) cy=H
  mc6 = contact mcon cx=(x3 + L + 0.19) cy=H
  well y=(pt - WP - 0.34)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l2
  port Y out on=l4
end
