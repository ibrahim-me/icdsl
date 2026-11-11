# clkinv_8: lifted from sky130_fd_sc_hd__clkinv_8 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=1 L=0.15 H=2.72

stdcell clkinv_8 width=17 height=H taps=no
  device M0 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M1 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M2 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M3 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M4 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M5 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M6 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M8 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M9 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M10 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M11 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M12 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M13 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M14 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M15 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M16 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M17 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M18 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M19 pmos w=WP l=L d=Y g=A s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.285
  x4 = x3 + 0.1
  x5 = x4 + L + 0.18
  x6 = x5 + 0.11
  x7 = x6 + L + 0.17
  x8 = x7 + 0.12
  x9 = x8 + L + 0.16
  x10 = x9 + 0.13
  x11 = x10 + L + 0.15
  x12 = x11 + 0.14
  x13 = x12 + L + 0.14
  x14 = x13 + L + 0.005
  x15 = x14 + L + 0.135
  x16 = x15 + L + 0.02
  x17 = x16 + L + 0.12
  x18 = x17 + L + 0.03
  x19 = x18 + L + 0.11
  x20 = x19 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x2 + L + 0.115, x19 + L + 0.02) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x20 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x20 + L) yspan=(nb + WN + 0.155, pt - WP - 0.1)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.1)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.1)
  p8 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p9 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.1)
  p10 = rect poly xspan=(x9, x9 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p11 = rect poly xspan=(x10, x10 + L) yspan=(0.105, pt - WP - 0.1)
  p12 = rect poly xspan=(x11, x11 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p13 = rect poly xspan=(x12, x12 + L) yspan=(0.105, pt - WP - 0.1)
  p14 = rect poly xspan=(x13, x13 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p15 = rect poly xspan=(x13 + L, x14 + L) yspan=(0.105, pt - WP - 0.1)
  p16 = rect poly xspan=(x15, x15 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p17 = rect poly xspan=(x16, x16 + L) yspan=(0.105, pt - WP - 0.1)
  p18 = rect poly xspan=(x17, x17 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p19 = rect poly xspan=(x18, x18 + L) yspan=(0.105, pt - WP - 0.1)
  p20 = rect poly xspan=(x19, x19 + L) yspan=(nb + WN + 0.155, H - 0.105)
  p21 = rect poly xspan=(x20, x20 + L) yspan=(nb + WN + 0.155, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.075, x3 + L/2 + 0.05) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l2 = rect li xspan=(x6 + L - 0.025, x7 + L - 0.005) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l3 = rect li xspan=(x10 + L - 0.025, x11 + L + 0.015) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l4 = rect li xspan=(x14 + L - 0.025, x16 + 0.025) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l5 = rect li xspan=(x18 + L - 0.025, x19 + L + 0.06) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l6 = rect li xspan=(x1 + 0.06, x19 + L + 0.12) yspan=(nb + WN + 0.38, pt - WP - 0.195) net=A
  l7 = rect li xspan=(x1 - 0.285, x20 + L + 0.275) yspan=(nb + WN + 0.04, nb + WN + 0.21) net=Y
  l8 = rect li xspan=(x1 - 0.285, x1 - 0.115) yspan=(nb + WN + 0.04, pt - WP + 0.145) net=Y
  l9 = rect li xspan=(x1 - 0.285, x20 + L + 0.275) yspan=(pt - WP - 0.025, pt - WP + 0.145) net=Y
  l10 = rect li xspan=(x1 + L + 0.025, x2 - 0.015) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l11 = rect li xspan=(x3 + L + 0.015, x5 - 0.02) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l12 = rect li xspan=(x4 + L + 0.05, x6 - 0.045) yspan=(nb + 0.045, nb + WN + 0.21) net=Y
  l13 = rect li xspan=(x7 + L + 0.015, x9 - 0.01) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l14 = rect li xspan=(x8 + L + 0.05, x10 - 0.045) yspan=(nb + 0.045, nb + WN + 0.21) net=Y
  l15 = rect li xspan=(x11 + L + 0.01, x13 - 0.02) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l16 = rect li xspan=(x12 + L + 0.05, x13 + L - 0.05) yspan=(nb + 0.045, nb + WN + 0.21) net=Y
  l17 = rect li xspan=(x16, x17 - 0.01) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l18 = rect li xspan=(x16 + L + 0.05, x17 + L - 0.025) yspan=(nb + 0.045, nb + WN + 0.21) net=Y
  l19 = rect li xspan=(x19 + L + 0.02, x20 - 0.02) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l20 = rect li xspan=(x20 + L, x20 + L + 0.275) yspan=(nb + WN + 0.04, pt - WP + 0.145) net=Y
  l21 = rect li xspan=(x1 - 0.265, x1) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l22 = rect li xspan=(x2 + L + 0.015, x3 - 0.01) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l23 = rect li xspan=(x5 + L + 0.005, x7 - 0.01) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l24 = rect li xspan=(x9 + L + 0.015, x11 - 0.015) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l25 = rect li xspan=(x13 + L + 0.01, x15 - 0.015) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l26 = rect li xspan=(x18 - 0.01, x19 - 0.01) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l27 = rect li xspan=(x20 + L + 0.01, x20 + L + 0.265) yspan=(pt - 0.685, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 - 0.045) span=(-0.085, nb + WN - 0.13) net=VGND
  c2 = array licon in=nd1 cx=(x7 - 0.025) span=(-0.085, nb + WN - 0.13) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=x11 span=(-0.085, nb + WN - 0.13) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x15 + 0.02) span=(-0.085, nb + WN - 0.13) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x19 + 0.04) span=(-0.085, nb + WN - 0.13) net=VGND
  c6 = array licon in=nd1 cx=(x5 - 0.035) span=(nb + 0.045 + 0.08, nb + WN + 0.21 - 0.08) margin=0.04 net=Y
  c7 = array licon in=nd1 cx=(x9 - 0.015) span=(nb + 0.045 + 0.08, nb + WN + 0.21 - 0.08) margin=0.04 net=Y
  c8 = array licon in=nd1 cx=(x13 + 0.01) span=(nb + 0.045 + 0.08, nb + WN + 0.21 - 0.08) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x17 + 0.03) span=(nb + 0.045 + 0.08, nb + WN + 0.21 - 0.08) margin=0.04 net=Y
  c10 = array licon in=pd1 cx=(x4 + L + 0.04) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x8 + L + 0.02) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c12 = array licon in=pd1 cx=(x12 + L - 0.005) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c13 = array licon in=pd1 cx=(x16 + L - 0.025) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x19 + L + 0.14) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c15 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) net=VPWR
  c17 = array licon in=pd1 cx=(x3 - 0.14) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c18 = array licon in=pd1 cx=(x6 + L + 0.03) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c19 = array licon in=pd1 cx=(x10 + L + 0.01) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x14 + L - 0.015) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x18 + L - 0.035) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x20 + L + 0.14) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.08) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L - 0.005) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 - 0.04) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 - 0.025) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x6 + L + 0.065) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x8 + L - 0.03) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x9 + L + 0.01) cy=(pt - WP - 0.325)
  gc8 = contact licon cx=(x12 - 0.06) cy=(pt - WP - 0.325)
  gc9 = contact licon cx=x13 cy=(pt - WP - 0.325)
  gc10 = contact licon cx=(x14 + L + 0.045) cy=(pt - WP - 0.325)
  gc11 = contact licon cx=(x16 + L - 0.05) cy=(pt - WP - 0.325)
  gc12 = contact licon cx=(x18 + 0.01) cy=(pt - WP - 0.325)
  gc13 = contact licon cx=(x19 + L - 0.05) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x20 + L + 0.815) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.095) cy=0
  mc4 = contact mcon cx=(x5 - 0.055) cy=0
  mc5 = contact mcon cx=(x7 - 0.015) cy=0
  mc6 = contact mcon cx=(x9 + 0.03) cy=0
  mc7 = contact mcon cx=(x11 + 0.07) cy=0
  mc8 = contact mcon cx=(x13 + L - 0.045) cy=0
  mc9 = contact mcon cx=(x15 + L) cy=0
  mc10 = contact mcon cx=(x18 + 0.02) cy=0
  mc11 = contact mcon cx=(x19 + L + 0.085) cy=0
  mc12 = contact mcon cx=(x20 + L + 0.125) cy=0
  mc13 = contact mcon cx=(x20 + L + 0.585) cy=0
  mc14 = contact mcon cx=(x1 - 0.17) cy=H
  mc15 = contact mcon cx=(x2 - 0.13) cy=H
  mc16 = contact mcon cx=(x3 - 0.095) cy=H
  mc17 = contact mcon cx=(x5 - 0.055) cy=H
  mc18 = contact mcon cx=(x7 - 0.015) cy=H
  mc19 = contact mcon cx=(x9 + 0.03) cy=H
  mc20 = contact mcon cx=(x11 + 0.07) cy=H
  mc21 = contact mcon cx=(x13 + L - 0.045) cy=H
  mc22 = contact mcon cx=(x15 + L) cy=H
  mc23 = contact mcon cx=(x18 + 0.02) cy=H
  mc24 = contact mcon cx=(x19 + L + 0.085) cy=H
  mc25 = contact mcon cx=(x20 + L + 0.125) cy=H
  mc26 = contact mcon cx=(x20 + L + 0.585) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l6
  port Y out on=l9
end
