# or4_4: lifted from sky130_fd_sc_hd__or4_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell or4_4 width=11 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=C s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=C s=n3 b=VPB
  device M2 nmos w=WN l=L d=VGND g=D s=n1 b=VNB
  device M3 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M4 pmos w=WP l=L d=n1 g=D s=n2 b=VPB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M10 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M11 pmos w=WP l=L d=n4 g=A s=VPWR b=VPB
  device M12 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M13 nmos w=WN l=L d=VGND g=B s=n1 b=VNB
  device M14 pmos w=WP l=L d=n3 g=B s=n4 b=VPB
  device M15 nmos w=WN l=L d=VGND g=n1 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.425
  x2 = x1 + L + 0.39
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.39
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.28) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.275, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.125, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.065, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.125) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(-0.085, nb + 0.35) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x4 + L + 0.025, x5 + 0.02) yspan=(-0.085, nb + 0.25) net=VGND
  l4 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(-0.085, nb + 0.32) net=VGND
  l5 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.225) yspan=(-0.085, nb + 0.32) net=VGND
  l6 = rect li xspan=(x1 - 0.34, x1 - 0.055) yspan=(nb + WN - 0.13, pt - WP - 0.16) net=D
  l7 = rect li xspan=(x4 + 0.05, x4 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l8 = rect li xspan=(x4 + 0.05, x5 - 0.05) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=A
  l9 = rect li xspan=(x2 - 0.075, x2 + L - 0.05) yspan=(nb + WN + 0.11, pt - 0.11) net=C
  l10 = rect li xspan=(x2 - 0.075, x2 + L + 0.135) yspan=(pt - WP + 0.135, pt - 0.11) net=C
  l11 = rect li xspan=(x3 - 0.095, x3 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.035) net=B
  l12 = rect li xspan=(x3 + 0.03, x3 + L + 0.095) yspan=(nb + WN + 0.11, pt - 0.11) net=B
  l13 = rect li xspan=(x3 + 0.03, x4 - 0.075) yspan=(pt - WP + 0.3, pt - 0.11) net=B
  l14 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - WP + 0.01, pt - 0.035) net=n1
  l15 = rect li xspan=(x1 - 0.31, x1 + L + 0.145) yspan=(pt - WP + 0.01, pt - 0.82) net=n1
  l16 = rect li xspan=(x1 + L - 0.03, x5 + 0.03) yspan=(nb + 0.42, nb + WN - 0.06) net=n1
  l17 = rect li xspan=(x1 + L - 0.03, x1 + L + 0.145) yspan=(nb + 0.42, pt - 0.82) net=n1
  l18 = rect li xspan=(x1 + L + 0.135, x2 - 0.085) yspan=(nb + 0.07, nb + WN - 0.06) net=n1
  l19 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.07, nb + WN - 0.06) net=n1
  l20 = rect li xspan=(x5 - 0.145, x5 + 0.03) yspan=(nb + 0.42, pt - WP - 0.24) net=n1
  l21 = rect li xspan=(x5 - 0.145, x8 + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l22 = rect li xspan=(x5 + L + 0.015, x8 + L + 0.33) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=X
  l23 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l24 = rect li xspan=(x5 + L + 0.055, x6 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l25 = rect li xspan=(x5 + L + 0.055, x8 + L + 0.33) yspan=(nb + WN - 0.16, nb + WN + 0.02) net=X
  l26 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l27 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP - 0.03, pt - 0.02) net=X
  l28 = rect li xspan=(x8 + L + 0.085, x8 + L + 0.33) yspan=(nb + WN - 0.16, pt - WP + 0.14) net=X
  l29 = rect li xspan=(x4 + L + 0.07, x5 - 0.07) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l30 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.69, H + 0.085) net=VPWR
  l31 = rect li xspan=(x8 + L + 0.015, x8 + L + 0.265) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c3 = array licon in=nd1 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + 0.32 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x5 - 0.15) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.35 - 0.08) net=VGND
  c7 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=nd1 cx=(x2 - 0.17) span=(nb + 0.07 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c9 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.07 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c10 = array licon in=pd1 cx=(x5 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01, pt - 0.035) net=n1
  c13 = array licon in=pd1 cx=(x4 + L + 0.195) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - 0.69 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + 0.055) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x7 - 0.03) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x8 - 0.11) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.425, x8 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.195) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.125) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.055) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.095) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.135) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.065) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.105) cy=0
  mc8 = contact mcon cx=(x8 - 0.135) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.185) cy=0
  mc10 = contact mcon cx=(x1 - 0.195) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.125) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.055) cy=H
  mc13 = contact mcon cx=(x3 + L + 0.095) cy=H
  mc14 = contact mcon cx=(x4 + L + 0.135) cy=H
  mc15 = contact mcon cx=(x5 + L + 0.065) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.105) cy=H
  mc17 = contact mcon cx=(x8 - 0.135) cy=H
  mc18 = contact mcon cx=(x8 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port B in on=l12
  port C in on=l10
  port D in on=l6
  port X out on=l25
end
