# nor3_2: lifted from sky130_fd_sc_hd__nor3_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nor3_2 width=10 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=B s=VGND b=VNB
  device M1 pmos w=WP l=L d=Y g=C s=n1 b=VPB
  device M2 pmos w=WP l=L d=VPWR g=A s=n2 b=VPB
  device M3 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M4 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M5 pmos w=WP l=L d=n2 g=B s=n1 b=VPB
  device M6 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M8 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M9 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M10 pmos w=WP l=L d=n1 g=C s=Y b=VPB
  device M11 nmos w=WN l=L d=VGND g=C s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.42
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.82
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.28, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x4 + L + 0.285) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.265, x6 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.33, x1 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l3 = rect li xspan=(x4 + L + 0.055, x5 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.345) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x1 - 0.285, x2 + L - 0.02) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A
  l6 = rect li xspan=(x3 - 0.125, x4 + L + 0.365) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B
  l7 = rect li xspan=(x5 - 0.265, x5 + 0.005) yspan=(nb + WN + 0.19, pt - WP + 0.14) net=C
  l8 = rect li xspan=(x5 - 0.265, x6 - 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=C
  l9 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l10 = rect li xspan=(x1 + L - 0.03, x6 + L + 0.395) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=Y
  l11 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l12 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=Y
  l13 = rect li xspan=(x5 + L + 0.055, x6 - 0.015) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=Y
  l14 = rect li xspan=(x5 + L + 0.055, x6 + L + 0.395) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=Y
  l15 = rect li xspan=(x6 + L - 0.07, x6 + L + 0.395) yspan=(nb + WN - 0.16, pt - WP + 0.14) net=Y
  l16 = rect li xspan=(x1 - 0.27, x4 + L + 0.265) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n2
  l17 = rect li xspan=(x1 - 0.27, x1 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l18 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=n2
  l19 = rect li xspan=(x4 + L + 0.015, x4 + L + 0.265) yspan=(pt - WP - 0.03, pt - WP + 0.64) net=n2
  l20 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l21 = rect li xspan=(x3 + L + 0.015, x6 + L + 0.265) yspan=(pt - 0.19, pt - 0.02) net=n1
  l22 = rect li xspan=(x5 - 0.225, x5 - 0.015) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l23 = rect li xspan=(x6 + L + 0.015, x6 + L + 0.265) yspan=(pt - WP + 0.31, pt - 0.02) net=n1
  l24 = rect li xspan=(x1 + L + 0.015, x2 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c6 = array licon in=nd2 cx=(x5 - 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c7 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=Y
  c8 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c11 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=n2
  c12 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - WP + 0.64 - 0.08) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c15 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n1
  c16 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) net=n1
  gc1 = contact licon cx=(x1 + L + 0.085) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.125) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.42, x6 + L + 0.48) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.19) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.11) cy=0
  mc4 = contact mcon cx=(x4 - 0.07) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.25) cy=0
  mc6 = contact mcon cx=(x5 - 0.11) cy=0
  mc7 = contact mcon cx=(x6 - 0.07) cy=0
  mc8 = contact mcon cx=(x6 + L + 0.25) cy=0
  mc9 = contact mcon cx=(x1 - 0.19) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc11 = contact mcon cx=(x3 - 0.11) cy=H
  mc12 = contact mcon cx=(x4 - 0.07) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.25) cy=H
  mc14 = contact mcon cx=(x5 - 0.11) cy=H
  mc15 = contact mcon cx=(x6 - 0.07) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.25) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l5
  port B in on=l6
  port C in on=l7
  port Y out on=l14
end
