# o2111a_2: lifted from sky130_fd_sc_hd__o2111a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2111a_2 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=C1 s=n2 b=VNB
  device M1 pmos w=WP l=L d=X g=n3 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n2 g=B1 s=n4 b=VNB
  device M3 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M5 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M6 nmos w=WN l=L d=VGND g=A1 s=n4 b=VNB
  device M7 nmos w=WN l=L d=n3 g=D1 s=n1 b=VNB
  device M8 pmos w=WP l=L d=n5 g=A1 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=n3 g=A2 s=n5 b=VPB
  device M10 pmos w=WP l=L d=VPWR g=B1 s=n3 b=VPB
  device M11 pmos w=WP l=L d=n3 g=C1 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=VPWR g=D1 s=n3 b=VPB
  device M13 nmos w=WN l=L d=X g=n3 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.74
  x4 = x3 + 0.07
  x5 = x4 + L + 0.22
  x6 = x5 + L + 0.4
  x7 = x6 + L + 0.4
  x8 = x7 + L + 0.4
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.27) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x3 - 0.2, x8 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x8 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.21, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x8, x8 + L + 0.31) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  # local interconnect
  l1 = rect li xspan=(x6 + L + 0.04, x7 - 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l2 = rect li xspan=(x6 + L + 0.04, x8 + L + 0.31) yspan=(nb + WN - 0.26, nb + WN - 0.06) net=n4
  l3 = rect li xspan=(x8 + L - 0.025, x8 + L + 0.31) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l4 = rect li xspan=(x1 - 0.27, x1 - 0.06) yspan=(-0.085, nb + WN) net=VGND
  l5 = rect li xspan=(x2 + L + 0.06, x2 + L + 0.31) yspan=(-0.085, nb + 0.31) net=VGND
  l6 = rect li xspan=(x7 + L + 0.02, x8 - 0.05) yspan=(-0.085, nb + 0.22) net=VGND
  l7 = rect li xspan=(x3 - 0.21, x3 + L - 0.025) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=D1
  l8 = rect li xspan=(x4 + L + 0.08, x5 + L + 0.105) yspan=(nb + 0.02, pt - WP + 0.13) net=C1
  l9 = rect li xspan=(x6, x7 - 0.125) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B1
  l10 = rect li xspan=(x8 + 0.07, x8 + L + 0.61) yspan=(nb + WN + 0.12, pt - WP - 0.17) net=A1
  l11 = rect li xspan=(x8 + L + 0.405, x8 + L + 0.61) yspan=(nb + WN + 0.12, pt - 0.13) net=A1
  l12 = rect li xspan=(x7 + L - 0.07, x8 - 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l13 = rect li xspan=(x7 + L, x8 - 0.105) yspan=(nb + WN + 0.11, pt - 0.115) net=A2
  l14 = rect li xspan=(x1 + L - 0.035, x2 + 0.025) yspan=(nb + 0.02, pt - 0.02) net=X
  l15 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.33) yspan=(nb + WN - 0.17, pt - 0.46) net=n3
  l16 = rect li xspan=(x2 + L + 0.055, x4 + 0.025) yspan=(nb + WN - 0.17, nb + WN) net=n3
  l17 = rect li xspan=(x2 + L + 0.055, x7 - 0.03) yspan=(pt - WP + 0.3, pt - 0.46) net=n3
  l18 = rect li xspan=(x3 - 0.24, x4 + 0.025) yspan=(nb + 0.02, nb + WN) net=n3
  l19 = rect li xspan=(x3 + L, x5) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l20 = rect li xspan=(x6 + L + 0.04, x7 - 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n3
  l21 = rect li xspan=(x1 - 0.27, x1 - 0.06) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l22 = rect li xspan=(x2 + L + 0.06, x3 - 0.06) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l23 = rect li xspan=(x5 + L + 0.04, x6 - 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l24 = rect li xspan=(x8 + L - 0.025, x8 + L + 0.235) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x7 + L + 0.185) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c4 = array licon in=nd2 cx=(x3 - 0.075) span=(nb + 0.02, nb + WN) net=n3
  c5 = array licon in=nd2 cx=(x7 - 0.195) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n4
  c6 = array licon in=nd2 cx=(x8 + L + 0.145) span=(nb + 0.02, nb + WN - 0.06) net=n4
  c7 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.02, pt - 0.02) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 + L + 0.145) span=(nb + 0.02, pt - 0.02) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd1 cx=(x4 + L + 0.075) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c12 = array licon in=pd1 cx=(x7 - 0.195) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=n3
  c13 = array licon in=pd1 cx=(x6 - 0.195) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - 0.29 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x3 - 0.145) span=(pt - 0.29 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 - 0.045) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + L + 0.02) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 + L + 0.145) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x8 + L + 0.695) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.175) cy=0
  mc4 = contact mcon cx=(x3 - 0.105) cy=0
  mc5 = contact mcon cx=(x5 - 0.075) cy=0
  mc6 = contact mcon cx=(x6 - 0.155) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.165) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.085) cy=0
  mc9 = contact mcon cx=(x8 + L) cy=0
  mc10 = contact mcon cx=(x8 + L + 0.465) cy=0
  mc11 = contact mcon cx=(x1 - 0.175) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc13 = contact mcon cx=(x2 + L + 0.175) cy=H
  mc14 = contact mcon cx=(x3 - 0.105) cy=H
  mc15 = contact mcon cx=(x5 - 0.075) cy=H
  mc16 = contact mcon cx=(x6 - 0.155) cy=H
  mc17 = contact mcon cx=(x6 + L + 0.165) cy=H
  mc18 = contact mcon cx=(x7 + L + 0.085) cy=H
  mc19 = contact mcon cx=(x8 + L) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.465) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l10
  port A2 in on=l13
  port B1 in on=l9
  port C1 in on=l8
  port D1 in on=l7
  port X out on=l14
end
