# buf_4: lifted from sky130_fd_sc_hd__buf_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell buf_4 width=8 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M2 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M4 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.26, x1 + L) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.01, x5 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.02, x2 - 0.055) yspan=(-0.085, nb + 0.33) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.305) yspan=(-0.085, nb + WN) net=VGND
  l4 = rect li xspan=(x1 - 0.31, x1 + L/2) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A
  l5 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  l6 = rect li xspan=(x1 - 0.305, x2 - 0.01) yspan=(pt - WP, pt - WP + 0.17) net=n1
  l7 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l8 = rect li xspan=(x1 - 0.225, x2 - 0.01) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l9 = rect li xspan=(x1 + L + 0.1, x2 - 0.01) yspan=(nb + WN - 0.15, pt - WP + 0.17) net=n1
  l10 = rect li xspan=(x1 + L + 0.1, x3 - 0.1) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l11 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l12 = rect li xspan=(x2 + L + 0.055, x5 - 0.055) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=X
  l13 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - WP - 0.04, pt - 0.02) net=X
  l14 = rect li xspan=(x2 + L + 0.055, x5 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=X
  l15 = rect li xspan=(x4 - 0.13, x5 - 0.055) yspan=(nb + WN - 0.15, pt - WP + 0.13) net=X
  l16 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(nb + 0.02, pt - 0.02) net=X
  l17 = rect li xspan=(x1 + L + 0.055, x2 + 0.02) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l18 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l19 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.305) yspan=(pt - WP, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 + L + 0.14) span=(-0.085, nb + WN) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.33 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) net=n1
  c5 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP, pt - 0.02) net=n1
  c8 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP, H + 0.085) net=VPWR
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.095) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x5 + L + 0.54) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x5 - 0.01) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.31) cy=0
  mc7 = contact mcon cx=(x1 - 0.17) cy=H
  mc8 = contact mcon cx=(x2 - 0.13) cy=H
  mc9 = contact mcon cx=(x3 - 0.09) cy=H
  mc10 = contact mcon cx=(x4 - 0.05) cy=H
  mc11 = contact mcon cx=(x5 - 0.01) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.31) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port X out on=l15
end
