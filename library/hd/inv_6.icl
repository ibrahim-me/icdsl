# inv_6: lifted from sky130_fd_sc_hd__inv_6 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell inv_6 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M1 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M2 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M3 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M4 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M5 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M6 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M9 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M10 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M11 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.57
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.385, x6 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.435, x6 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.465, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.44, x1 - 0.175) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l4 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.225) yspan=(-0.085, nb + 0.315) net=VGND
  l5 = rect li xspan=(x1 - 0.465, x6 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l6 = rect li xspan=(x1 + L - 0.03, x6 + L + 0.325) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l7 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l8 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l9 = rect li xspan=(x1 + L + 0.055, x6 + L + 0.325) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l10 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l11 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l12 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l13 = rect li xspan=(x5 + L - 0.03, x6 + L + 0.325) yspan=(pt - WP + 0.01, pt - WP + 0.2) net=Y
  l14 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.325) yspan=(nb + WN - 0.16, pt - WP + 0.2) net=Y
  l16 = rect li xspan=(x1 - 0.44, x1 - 0.145) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l17 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l18 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l19 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.225) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.26) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.315 - 0.08) net=VGND
  c5 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=Y
  c6 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.31) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c10 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c12 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.3) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L + 0.06) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 + L + 0.06) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 + L + 0.06) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.57, x6 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.34) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.025) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.02) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.06) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.1) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.18) cy=0
  mc8 = contact mcon cx=(x1 - 0.34) cy=H
  mc9 = contact mcon cx=(x1 + L - 0.025) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.02) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.06) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.1) cy=H
  mc13 = contact mcon cx=(x5 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l5
  port Y out on=l9
end
