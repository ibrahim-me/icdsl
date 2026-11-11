# inv_8: lifted from sky130_fd_sc_hd__inv_8 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell inv_8 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M1 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M2 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M3 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M5 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M6 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M7 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M8 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M10 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M11 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M12 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M13 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M14 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M15 pmos w=WP l=L d=VPWR g=A s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.565
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l5 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.36) yspan=(-0.085, nb + 0.31) net=VGND
  l6 = rect li xspan=(x1 + L - 0.03, x8 + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l7 = rect li xspan=(x1 - 0.48, x8 + L + 0.41) yspan=(nb + WN - 0.17, nb + WN + 0.02) net=Y
  l8 = rect li xspan=(x1 - 0.48, x1 - 0.135) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=Y
  l9 = rect li xspan=(x1 - 0.48, x8 + L + 0.41) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l10 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l11 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l12 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l13 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l14 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l16 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l17 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l18 = rect li xspan=(x8 + L + 0.09, x8 + L + 0.41) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=Y
  l19 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l20 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l21 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l22 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l23 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.355) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c12 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c15 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c18 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x4 + L + 0.14) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x5 + L + 0.14) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x6 + L + 0.14) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x7 + L + 0.14) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.565, x8 + L + 0.495) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.335) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.02) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.025) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.065) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.105) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x7 - 0.095) cy=0
  mc8 = contact mcon cx=(x8 - 0.055) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.265) cy=0
  mc10 = contact mcon cx=(x1 - 0.335) cy=H
  mc11 = contact mcon cx=(x1 + L - 0.02) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.025) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.065) cy=H
  mc14 = contact mcon cx=(x4 + L + 0.105) cy=H
  mc15 = contact mcon cx=(x6 - 0.135) cy=H
  mc16 = contact mcon cx=(x7 - 0.095) cy=H
  mc17 = contact mcon cx=(x8 - 0.055) cy=H
  mc18 = contact mcon cx=(x8 + L + 0.265) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port Y out on=l18
end
