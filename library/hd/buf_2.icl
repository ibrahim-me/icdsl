# buf_2: lifted from sky130_fd_sc_hd__buf_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell buf_2 width=5 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M3 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M4 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M5 nmos w=WN2 l=L d=n1 g=A s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.27) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.27) yspan=(pt - 0.04 - WP2, pt - 0.04)
  pd2 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.265, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt + 0.09)
  p3 = rect poly xspan=(x2 - 0.12, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.02, x2 + 0.02) yspan=(-0.085, nb + 0.23) net=VGND
  l2 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.315) yspan=(-0.085, nb + WN + 0.04) net=VGND
  l3 = rect li xspan=(x1 - 0.315, x1 + 0.045) yspan=(nb + WN + 0.1, pt - WP - 0.13) net=A
  l4 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.08) net=n1
  l5 = rect li xspan=(x1 - 0.225, x2 + 0.02) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n1
  l6 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP + 0.05, pt - 0.04 + 0.02) net=n1
  l7 = rect li xspan=(x1 - 0.225, x2 + 0.02) yspan=(pt - WP + 0.05, pt - 0.04 - WP2 - 0.1) net=n1
  l8 = rect li xspan=(x2 - 0.155, x2 + 0.02) yspan=(nb + WN2 - 0.02, pt - 0.04 - WP2 - 0.1) net=n1
  l9 = rect li xspan=(x2 - 0.155, x2 + L - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l10 = rect li xspan=(x2 + L + 0.045, x3 + 0.025) yspan=(nb + 0.02, nb + WN - 0.055) net=X
  l11 = rect li xspan=(x2 + L + 0.045, x3 + 0.025) yspan=(pt - WP + 0.075, pt - 0.04 + 0.02) net=X
  l12 = rect li xspan=(x2 + L + 0.13, x3 + 0.025) yspan=(nb + 0.02, pt - 0.04 + 0.02) net=X
  l13 = rect li xspan=(x1 + L + 0.02, x2 + 0.02) yspan=(pt - 0.04 - WP2 + 0.07, H + 0.085) net=VPWR
  l14 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.315) yspan=(pt - WP, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.15) span=(-0.085, nb + 0.23) net=VGND
  c2 = array licon in=nd2 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.04 - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08 - 0.08) net=n1
  c4 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.055 - 0.08) margin=0.04 net=X
  c5 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - WP + 0.08, H + 0.085 - 0.08) net=VPWR
  c6 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.075 + 0.08, pt - 0.04 + 0.02 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.05 + 0.08, pt - 0.04 + 0.02 - 0.08) net=n1
  c8 = array licon in=pd2 cx=(x2 - 0.15) span=(pt - 0.04 - WP2 + 0.07, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.13) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x3 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc5 = contact mcon cx=(x1 - 0.17) cy=H
  mc6 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc7 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port X out on=l10
end
