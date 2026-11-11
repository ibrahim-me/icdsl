# a211oi_2: lifted from sky130_fd_sc_hd__a211oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a211oi_2 width=12 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=n2 b=VPB
  device M1 nmos w=WN l=L d=VGND g=C1 s=Y b=VNB
  device M2 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=A2 s=n1 b=VPB
  device M4 nmos w=WN l=L d=VGND g=A2 s=n3 b=VNB
  device M5 nmos w=WN l=L d=n3 g=A1 s=Y b=VNB
  device M6 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M7 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M8 nmos w=WN l=L d=Y g=C1 s=VGND b=VNB
  device M9 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M10 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M11 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  device M12 pmos w=WP l=L d=Y g=C1 s=n2 b=VPB
  device M13 pmos w=WP l=L d=n2 g=C1 s=Y b=VPB
  device M14 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M15 pmos w=WP l=L d=n1 g=A1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.455
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.81
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.29
  x8 = x7 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x4 + L + 0.27) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.27, x8 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x4 + L + 0.27) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.27, x8 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.275, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5 - 0.275, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x8 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.06) yspan=(-0.085, nb + WN - 0.07) net=VGND
  l2 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(-0.085, nb + 0.24) net=VGND
  l3 = rect li xspan=(x4 + L - 0.025, x4 + L + 0.31) yspan=(-0.085, nb + 0.24) net=VGND
  l4 = rect li xspan=(x7 + L - 0.025, x8 + 0.025) yspan=(-0.085, nb + 0.22) net=VGND
  l5 = rect li xspan=(x5 - 0.31, x7 - 0.06) yspan=(nb + 0.03, nb + 0.24) net=n3
  l6 = rect li xspan=(x6 + L + 0.06, x7 - 0.06) yspan=(nb + 0.03, nb + WN - 0.03) net=n3
  l7 = rect li xspan=(x6 + L + 0.06, x8 + L + 0.31) yspan=(nb + WN - 0.25, nb + WN - 0.03) net=n3
  l8 = rect li xspan=(x8 + L + 0.06, x8 + L + 0.31) yspan=(nb + 0.03, nb + WN - 0.03) net=n3
  l9 = rect li xspan=(x5 - 0.325, x6 - 0.045) yspan=(nb + WN + 0.15, pt - WP - 0.2) net=A1
  l10 = rect li xspan=(x1 - 0.355, x1 - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=C1
  l11 = rect li xspan=(x2 + L + 0.01, x4 + 0.045) yspan=(nb + WN + 0.15, pt - WP - 0.2) net=B1
  l12 = rect li xspan=(x2 + L + 0.01, x3 - 0.06) yspan=(nb + WN + 0.15, pt - WP + 0.13) net=B1
  l13 = rect li xspan=(x7 + L + 0.045, x8 + L + 0.375) yspan=(nb + WN + 0.15, pt - WP - 0.2) net=A2
  l14 = rect li xspan=(x8 + L + 0.05, x8 + L + 0.375) yspan=(nb + WN + 0.15, pt - WP + 0.17) net=A2
  l15 = rect li xspan=(x1 + L - 0.025, x2 - 0.05) yspan=(nb + 0.02, pt - 0.38) net=Y
  l16 = rect li xspan=(x1 + L - 0.025, x6 + 0.025) yspan=(nb + WN - 0.23, nb + WN - 0.03) net=Y
  l17 = rect li xspan=(x1 + L - 0.025, x2 - 0.03) yspan=(nb + WN - 0.23, pt - 0.38) net=Y
  l18 = rect li xspan=(x1 + L - 0.025, x2 + 0.025) yspan=(pt - WP + 0.3, pt - 0.38) net=Y
  l19 = rect li xspan=(x3 + L + 0.05, x4 - 0.05) yspan=(nb + 0.05, nb + WN - 0.03) net=Y
  l20 = rect li xspan=(x1 - 0.31, x1 - 0.05) yspan=(pt - WP + 0.3, pt - 0.03) net=n2
  l21 = rect li xspan=(x1 - 0.31, x4 + L + 0.33) yspan=(pt - 0.2, pt - 0.03) net=n2
  l22 = rect li xspan=(x2 + L + 0.05, x3 - 0.05) yspan=(pt - WP + 0.3, pt - 0.03) net=n2
  l23 = rect li xspan=(x2 + L + 0.05, x4 + L + 0.33) yspan=(pt - 0.23, pt - 0.03) net=n2
  l24 = rect li xspan=(x4 + L + 0.05, x4 + L + 0.33) yspan=(pt - 0.65, pt - 0.03) net=n2
  l25 = rect li xspan=(x3 + L - 0.025, x8 - 0.01) yspan=(pt - WP - 0.03, pt - WP + 0.17) net=n1
  l26 = rect li xspan=(x3 + L - 0.025, x4 + 0.025) yspan=(pt - WP - 0.03, pt - WP + 0.59) net=n1
  l27 = rect li xspan=(x5 + L + 0.01, x6 - 0.01) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l28 = rect li xspan=(x7 + L + 0.01, x8 - 0.01) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l29 = rect li xspan=(x5 - 0.26, x5 - 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l30 = rect li xspan=(x6 + L + 0.03, x7 - 0.03) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l31 = rect li xspan=(x8 + L + 0.03, x8 + L + 0.26) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x7 + L + 0.145) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085, nb + 0.24) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.145) span=(-0.085, nb + 0.24) net=VGND
  c4 = array licon in=nd2 cx=(x5 - 0.145) span=(nb + 0.03, nb + 0.24) net=n3
  c5 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.02 + 0.08, pt - 0.38 - 0.08) margin=0.04 net=Y
  c6 = array licon in=nd2 cx=(x6 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.03 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd2 cx=(x8 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.03 - 0.08) net=n3
  c8 = array licon in=nd1 cx=(x3 + L + 0.145) span=(nb + 0.05 + 0.08, nb + WN - 0.03 - 0.08) margin=0.04 net=Y
  c9 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.07 - 0.08) net=VGND
  c10 = array licon in=nd2 cx=(x5 + L + 0.145) span=(nb + WN - 0.23, nb + WN - 0.03) margin=0.04 net=Y
  c11 = array licon in=pd2 cx=(x5 + L + 0.145) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd2 cx=(x7 + L + 0.145) span=(pt - WP - 0.03 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c13 = array licon in=pd1 cx=(x1 + L + 0.145) span=(nb + 0.02 + 0.08, pt - 0.38 - 0.08) margin=0.04 net=Y
  c14 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP - 0.03, pt - WP + 0.59) margin=0.04 net=n1
  c15 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.3 + 0.08, pt - 0.03 - 0.08) net=n2
  c16 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.3 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=n2
  c17 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - 0.65 + 0.08, pt - 0.03 - 0.08) net=n2
  c18 = array licon in=pd2 cx=(x5 - 0.145) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c19 = array licon in=pd2 cx=(x6 + L + 0.145) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd2 cx=(x8 + L + 0.145) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.145) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 - 0.14) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.06) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 - 0.06) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x8 + L + 0.14) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.455, x8 + L + 0.475) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.225) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.095) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x4 - 0.135) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.185) cy=0
  mc6 = contact mcon cx=(x5 - 0.165) cy=0
  mc7 = contact mcon cx=(x6 - 0.135) cy=0
  mc8 = contact mcon cx=(x7 - 0.105) cy=0
  mc9 = contact mcon cx=(x8 - 0.075) cy=0
  mc10 = contact mcon cx=(x8 + L + 0.245) cy=0
  mc11 = contact mcon cx=(x1 - 0.225) cy=H
  mc12 = contact mcon cx=(x1 + L + 0.095) cy=H
  mc13 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc14 = contact mcon cx=(x4 - 0.135) cy=H
  mc15 = contact mcon cx=(x4 + L + 0.185) cy=H
  mc16 = contact mcon cx=(x5 - 0.165) cy=H
  mc17 = contact mcon cx=(x6 - 0.135) cy=H
  mc18 = contact mcon cx=(x7 - 0.105) cy=H
  mc19 = contact mcon cx=(x8 - 0.075) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.245) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l9
  port A2 in on=l13
  port B1 in on=l11
  port C1 in on=l10
  port Y out on=l15
end
