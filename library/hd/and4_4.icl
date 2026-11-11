# and4_4: lifted from sky130_fd_sc_hd__and4_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell and4_4 width=11 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=D s=VPWR b=VPB
  device M1 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M2 nmos w=WN l=L d=n2 g=D s=VGND b=VNB
  device M3 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M4 nmos w=WN l=L d=n3 g=B s=n4 b=VNB
  device M5 pmos w=WP l=L d=VPWR g=C s=n1 b=VPB
  device M6 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 nmos w=WN l=L d=n1 g=A s=n3 b=VNB
  device M10 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M11 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M12 pmos w=WP l=L d=n1 g=B s=VPWR b=VPB
  device M13 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M14 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M15 nmos w=WN l=L d=n4 g=C s=n2 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.255
  x3 = x2 + 0.025
  x4 = x3 + L + 0.32
  x5 = x4 + L + 0.44
  x6 = x5 + 0.005
  x7 = x6 + L + 0.335
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.1) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.01, x4 + L + 0.215) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.08, H - 0.105)
  p9 = rect poly xspan=(x5, x6 + L + 0.12) yspan=(nb + WN + 0.08, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x6 + L + 0.02, x7) yspan=(-0.085, nb + 0.315) net=VGND
  l2 = rect li xspan=(x8 + L - 0.03, x9 + 0.03) yspan=(-0.085, nb + 0.235) net=VGND
  l3 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(-0.085, nb + 0.235) net=VGND
  l4 = rect li xspan=(x3 + 0.025, x4 - 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l5 = rect li xspan=(x2 + L - 0.05, x4 - 0.035) yspan=(nb + 0.185, pt - WP - 0.16) net=B
  l6 = rect li xspan=(x4 + L - 0.01, x5 - 0.16) yspan=(nb + 0.19, pt - WP - 0.16) net=C
  l7 = rect li xspan=(x6 + 0.045, x6 + L + 0.07) yspan=(nb + WN - 0.155, pt - WP - 0.16) net=D
  l8 = rect li xspan=(x6 + 0.045, x6 + L + 0.15) yspan=(nb + WN - 0.155, nb + WN + 0.05) net=D
  l9 = rect li xspan=(x1 - 0.275, x1 - 0.07) yspan=(nb + WN - 0.12, pt - WP + 0.17) net=A
  l10 = rect li xspan=(x1 - 0.225, x2 - 0.125) yspan=(nb + 0.02, nb + WN - 0.3) net=n1
  l11 = rect li xspan=(x1 + L - 0.045, x2 - 0.125) yspan=(nb + 0.02, pt - WP + 0.18) net=n1
  l12 = rect li xspan=(x1 + L - 0.045, x7 + L - 0.07) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l13 = rect li xspan=(x1 + L + 0.015, x2 - 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l14 = rect li xspan=(x4 + L + 0.035, x5 - 0.215) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l15 = rect li xspan=(x7 - 0.095, x10 - 0.015) yspan=(nb + WN + 0.22, pt - WP - 0.18) net=n1
  l16 = rect li xspan=(x7 - 0.095, x7 + L - 0.07) yspan=(nb + WN + 0.22, pt - WP + 0.18) net=n1
  l17 = rect li xspan=(x7 + L + 0.095, x10 - 0.015) yspan=(nb + WN + 0.19, pt - WP - 0.18) net=n1
  l18 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(nb + 0.02, nb + WN - 0.075) net=X
  l19 = rect li xspan=(x7 + L + 0.055, x10 + L + 0.31) yspan=(nb + WN - 0.245, nb + WN - 0.075) net=X
  l20 = rect li xspan=(x7 + L + 0.055, x8 + 0.03) yspan=(pt - 0.69, pt - 0.02) net=X
  l21 = rect li xspan=(x7 + L + 0.135, x10 + L + 0.31) yspan=(pt - WP, pt - WP + 0.17) net=X
  l22 = rect li xspan=(x7 + L + 0.135, x8 + 0.03) yspan=(pt - WP, pt - 0.02) net=X
  l23 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(nb + 0.02, nb + WN - 0.075) net=X
  l24 = rect li xspan=(x9 + L + 0.055, x10 - 0.055) yspan=(pt - WP, pt - 0.02) net=X
  l25 = rect li xspan=(x9 + L + 0.055, x10 + L + 0.31) yspan=(pt - WP, pt - WP + 0.26) net=X
  l26 = rect li xspan=(x10 + L + 0.06, x10 + L + 0.31) yspan=(nb + WN - 0.245, pt - WP + 0.26) net=X
  l27 = rect li xspan=(x1 - 0.295, x1 - 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l28 = rect li xspan=(x3 + L - 0.01, x4 + 0.01) yspan=(pt - 0.55, H + 0.085) net=VPWR
  l29 = rect li xspan=(x6 + L + 0.02, x7 + 0.02) yspan=(pt - 0.63, H + 0.085) net=VPWR
  l30 = rect li xspan=(x8 + L + 0.055, x9 + 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l31 = rect li xspan=(x10 + L - 0.03, x10 + L + 0.305) yspan=(pt - 0.57, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x7 - 0.15) span=(-0.085 + 0.08, nb + 0.315 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085, nb + 0.235) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x10 + L + 0.14) span=(-0.085, nb + 0.235) net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.3 - 0.08) net=n1
  c5 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.075 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x9 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.075 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd1 cx=(x2 - 0.115) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c8 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.69 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c12 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x10 + L + 0.14) span=(pt - 0.57, H + 0.085) net=VPWR
  c14 = array licon in=pd1 cx=(x3 + L + 0.16) span=(pt - 0.55, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x7 - 0.15) span=(pt - 0.63, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.08) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x9 - 0.1) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x9 + L + 0.1) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.105) cy=0
  mc3 = contact mcon cx=(x4 - 0.13) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.19) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.065) cy=0
  mc6 = contact mcon cx=(x7 + L + 0.05) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.09) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.13) cy=0
  mc9 = contact mcon cx=(x10 + L + 0.17) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x2 - 0.105) cy=H
  mc12 = contact mcon cx=(x4 - 0.13) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.19) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.065) cy=H
  mc15 = contact mcon cx=(x7 + L + 0.05) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.09) cy=H
  mc17 = contact mcon cx=(x9 + L + 0.13) cy=H
  mc18 = contact mcon cx=(x10 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l9
  port B in on=l5
  port C in on=l6
  port D in on=l7
  port X out on=l26
end
