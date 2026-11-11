# and2_4: lifted from sky130_fd_sc_hd__and2_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell and2_4 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M2 nmos w=WN l=L d=n2 g=B s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M4 nmos w=WN l=L d=n1 g=A s=n2 b=VNB
  device M5 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M6 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M7 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M8 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M9 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M11 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.22
  x3 = x2 + 0.07
  x4 = x3 + L + 0.365
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x7 + L + 0.29) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x7 + L + 0.29) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.19, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 + L - 0.025, x4 - 0.055) yspan=(-0.085, nb + 0.21) net=VGND
  l2 = rect li xspan=(x5 + L - 0.025, x6 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x7 + L - 0.025, x7 + L + 0.31) yspan=(-0.085, nb + 0.21) net=VGND
  l4 = rect li xspan=(x1 + L + 0.06, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l5 = rect li xspan=(x1 - 0.28, x1 + 0.035) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l6 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(nb + 0.02, nb + WN - 0.08) net=n1
  l7 = rect li xspan=(x1 - 0.31, x4 + 0.025) yspan=(nb + WN - 0.27, nb + WN - 0.08) net=n1
  l8 = rect li xspan=(x1 + L + 0.06, x2 + 0.025) yspan=(pt - WP + 0.095, pt - 0.02) net=n1
  l9 = rect li xspan=(x1 + L + 0.06, x4 + 0.025) yspan=(pt - WP + 0.095, pt - WP + 0.265) net=n1
  l10 = rect li xspan=(x3 + L + 0.175, x4 + 0.025) yspan=(nb + WN - 0.27, pt - WP + 0.265) net=n1
  l11 = rect li xspan=(x3 + L + 0.175, x7 + 0.06) yspan=(nb + WN + 0.135, pt - WP - 0.13) net=n1
  l12 = rect li xspan=(x4 + L + 0.05, x5 - 0.05) yspan=(nb + 0.28, nb + WN - 0.04) net=X
  l13 = rect li xspan=(x4 + L + 0.05, x7 + L + 0.365) yspan=(nb + WN - 0.27, nb + WN - 0.04) net=X
  l14 = rect li xspan=(x4 + L + 0.05, x7 + L + 0.365) yspan=(pt - WP + 0.05, pt - WP + 0.275) net=X
  l15 = rect li xspan=(x4 + L + 0.05, x5 - 0.05) yspan=(pt - WP + 0.05, pt - 0.02) net=X
  l16 = rect li xspan=(x6 + L + 0.05, x7 - 0.05) yspan=(nb + 0.02, nb + WN - 0.04) net=X
  l17 = rect li xspan=(x6 + L + 0.05, x7 - 0.05) yspan=(pt - WP + 0.05, pt - 0.02) net=X
  l18 = rect li xspan=(x6 + L + 0.05, x7 + L + 0.365) yspan=(pt - WP + 0.05, pt - WP + 0.28) net=X
  l19 = rect li xspan=(x7 + L + 0.085, x7 + L + 0.365) yspan=(nb + WN - 0.27, pt - WP + 0.28) net=X
  l20 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - 0.605, H + 0.085) net=VPWR
  l21 = rect li xspan=(x3 + L + 0.015, x4 - 0.02) yspan=(pt - 0.55, H + 0.085) net=VPWR
  l22 = rect li xspan=(x5 + L - 0.025, x6 + 0.025) yspan=(pt - 0.55, H + 0.085) net=VPWR
  l23 = rect li xspan=(x7 + L - 0.025, x7 + L + 0.31) yspan=(pt - 0.55, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x5 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x7 + L + 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN - 0.08) net=n1
  c5 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x4 + L + 0.145) span=(nb + 0.28 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x2 - 0.075) span=(pt - WP + 0.095 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - WP + 0.05 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - 0.605, H + 0.085) net=VPWR
  c11 = array licon in=pd1 cx=(x3 + L + 0.18) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.055) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 - 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x7 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x7 + L + 0.45) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x2 - 0.075) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x6 - 0.13) cy=0
  mc6 = contact mcon cx=(x7 - 0.1) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.22) cy=0
  mc8 = contact mcon cx=(x1 - 0.175) cy=H
  mc9 = contact mcon cx=(x2 - 0.075) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.175) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.13) cy=H
  mc12 = contact mcon cx=(x6 - 0.13) cy=H
  mc13 = contact mcon cx=(x7 - 0.1) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.22) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l5
  port B in on=l4
  port X out on=l19
end
