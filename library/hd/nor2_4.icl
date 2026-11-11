# nor2_4: lifted from sky130_fd_sc_hd__nor2_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nor2_4 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M1 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M4 pmos w=WP l=L d=Y g=B s=n1 b=VPB
  device M5 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M6 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M7 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M9 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M10 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M11 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M12 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M13 pmos w=WP l=L d=Y g=B s=n1 b=VPB
  device M14 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M15 nmos w=WN l=L d=VGND g=B s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
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
  nd1 = rect diff xspan=(x1 - 0.285, x8 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x8 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.34) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x1 - 0.28, x4 + L - 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l7 = rect li xspan=(x5 + 0.025, x8 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B
  l8 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l9 = rect li xspan=(x1 + L - 0.03, x8 + L + 0.555) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l10 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l11 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l12 = rect li xspan=(x5 + L + 0.055, x8 + L + 0.555) yspan=(pt - WP - 0.04, pt - WP + 0.26) net=Y
  l13 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=Y
  l14 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l15 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - WP - 0.04, pt - WP + 0.64) net=Y
  l16 = rect li xspan=(x8 + L + 0.155, x8 + L + 0.555) yspan=(nb + WN - 0.16, pt - WP + 0.26) net=Y
  l17 = rect li xspan=(x1 - 0.33, x5 + 0.03) yspan=(pt - WP - 0.03, pt - WP + 0.18) net=n1
  l18 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l19 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l20 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l21 = rect li xspan=(x4 + L - 0.03, x8 + L + 0.39) yspan=(pt - 0.19, pt - 0.02) net=n1
  l22 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(pt - WP + 0.45, pt - 0.02) net=n1
  l23 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.39) yspan=(pt - WP + 0.43, pt - 0.02) net=n1
  l24 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l25 = rect li xspan=(x3 + L - 0.03, x4 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c11 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.03, pt - 0.02) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.04 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c16 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP + 0.43, pt - 0.02) net=n1
  c18 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP + 0.45, pt - 0.02) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 + L + 0.04) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.045) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 - 0.06) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.055) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + L - 0.03) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 + 0.04) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x8 - 0.045) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x8 + L + 0.64) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x4 - 0.07) cy=0
  mc5 = contact mcon cx=(x5 - 0.03) cy=0
  mc6 = contact mcon cx=(x6 + 0.015) cy=0
  mc7 = contact mcon cx=(x7 + 0.055) cy=0
  mc8 = contact mcon cx=(x8 + L - 0.055) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.41) cy=0
  mc10 = contact mcon cx=(x1 - 0.19) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc12 = contact mcon cx=(x3 - 0.11) cy=H
  mc13 = contact mcon cx=(x4 - 0.07) cy=H
  mc14 = contact mcon cx=(x5 - 0.03) cy=H
  mc15 = contact mcon cx=(x6 + 0.015) cy=H
  mc16 = contact mcon cx=(x7 + 0.055) cy=H
  mc17 = contact mcon cx=(x8 + L - 0.055) cy=H
  mc18 = contact mcon cx=(x8 + L + 0.41) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port B in on=l7
  port Y out on=l12
end
