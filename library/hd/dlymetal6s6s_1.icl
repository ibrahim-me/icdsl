# dlymetal6s6s_1: lifted from sky130_fd_sc_hd__dlymetal6s6s_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell dlymetal6s6s_1 width=12 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=n2 s=VGND b=VNB
  device M1 nmos w=WN2 l=L d=n3 g=A s=VGND b=VNB
  device M2 pmos w=WP l=L d=VPWR g=n3 s=n2 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M4 nmos w=WN l=L d=VGND g=n1 s=n5 b=VNB
  device M5 nmos w=WN l=L d=VGND g=n3 s=n2 b=VNB
  device M6 pmos w=WP2 l=L d=n4 g=n5 s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=n4 g=n5 s=VGND b=VNB
  device M8 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M9 pmos w=WP2 l=L d=n1 g=n2 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=n1 s=n5 b=VPB
  device M11 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.58
  x2 = x1 + L + 0.335
  x3 = x2 + L + 0.8
  x4 = x3 + L + 0.335
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.335
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x2 + L + 0.265) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN2)
  nd4 = rect diff xspan=(x3 + L + 0.08, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd5 = rect diff xspan=(x5 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN2)
  nd6 = rect diff xspan=(x5 + L + 0.08, x6 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x1 + L + 0.08, x2 + L + 0.265) yspan=(pt - WP, pt)
  pd3 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x3 + L + 0.08, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd5 = rect diff xspan=(x5 - 0.265, x6 + L + 0.265) yspan=(pt - WP2, pt)
  pd6 = rect diff xspan=(x5 + L + 0.08, x6 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.12, x2 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.29, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.12, x4 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5 - 0.29, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6 - 0.12, x6 + L + 0.01) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l3 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l4 = rect li xspan=(x1 - 0.495, x1) yspan=(nb + WN + 0.11, pt - WP + 0.215) net=A
  l5 = rect li xspan=(x1 - 0.495, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l6 = rect li xspan=(x1 - 0.495, x2 + 0.03) yspan=(nb + WN2, nb + WN - 0.06) net=n3
  l7 = rect li xspan=(x1 - 0.495, x1 - 0.055) yspan=(pt - WP + 0.385, pt - 0.02) net=n3
  l8 = rect li xspan=(x1 - 0.495, x2 + 0.03) yspan=(pt - WP + 0.385, pt - WP2 - 0.025) net=n3
  l9 = rect li xspan=(x1 + L + 0.025, x2 + 0.03) yspan=(nb + WN2, pt - WP2 - 0.025) net=n3
  l10 = rect li xspan=(x1 + L + 0.025, x2 + L - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l11 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.325) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l12 = rect li xspan=(x2 + L + 0.055, x2 + L + 0.325) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l13 = rect li xspan=(x2 + L + 0.13, x2 + L + 0.325) yspan=(nb + 0.02, pt - 0.02) net=n2
  l14 = rect li xspan=(x2 + L + 0.13, x3 - 0.02) yspan=(nb + WN + 0.11, pt - WP + 0.19) net=n2
  l15 = rect li xspan=(x3 - 0.305, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n1
  l16 = rect li xspan=(x3 - 0.305, x4 + 0.03) yspan=(nb + WN2, nb + WN - 0.06) net=n1
  l17 = rect li xspan=(x3 - 0.305, x3 - 0.055) yspan=(pt - WP + 0.36, pt - 0.02) net=n1
  l18 = rect li xspan=(x3 - 0.305, x4 + 0.03) yspan=(pt - WP + 0.36, pt - WP2 - 0.025) net=n1
  l19 = rect li xspan=(x3 + L + 0.01, x4 + 0.03) yspan=(nb + WN2, pt - WP2 - 0.025) net=n1
  l20 = rect li xspan=(x3 + L + 0.01, x4 + L - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l21 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN - 0.06) net=n5
  l22 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.305) yspan=(pt - WP + 0.01, pt - 0.02) net=n5
  l23 = rect li xspan=(x4 + L + 0.13, x4 + L + 0.305) yspan=(nb + 0.02, pt - 0.02) net=n5
  l24 = rect li xspan=(x4 + L + 0.13, x5 - 0.02) yspan=(nb + WN + 0.11, pt - WP + 0.19) net=n5
  l25 = rect li xspan=(x5 - 0.325, x5 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l26 = rect li xspan=(x5 - 0.325, x6 + 0.03) yspan=(nb + WN2, nb + WN - 0.06) net=n4
  l27 = rect li xspan=(x5 - 0.325, x5 - 0.055) yspan=(pt - WP + 0.36, pt - 0.02) net=n4
  l28 = rect li xspan=(x5 - 0.325, x6 + 0.03) yspan=(pt - WP + 0.36, pt - WP2 - 0.025) net=n4
  l29 = rect li xspan=(x5 + L + 0.01, x6 + 0.03) yspan=(nb + WN2, pt - WP2 - 0.025) net=n4
  l30 = rect li xspan=(x5 + L + 0.01, x6 + L - 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n4
  l31 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.49) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l32 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.49) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l33 = rect li xspan=(x6 + L + 0.13, x6 + L + 0.49) yspan=(nb + 0.02, pt - 0.02) net=X
  l34 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  l35 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  l36 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 + L + 0.165) span=(-0.085, nb + WN2 - 0.17) net=VGND
  c2 = array licon in=nd4 cx=(x3 + L + 0.165) span=(-0.085, nb + WN2 - 0.17) net=VGND
  c3 = array licon in=nd6 cx=(x5 + L + 0.165) span=(-0.085, nb + WN2 - 0.17) net=VGND
  c4 = array licon in=nd2 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n2
  c5 = array licon in=nd3 cx=(x3 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c6 = array licon in=nd4 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n5
  c7 = array licon in=nd5 cx=(x5 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n4
  c8 = array licon in=nd6 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=X
  c9 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) net=n3
  c10 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  c11 = array licon in=pd4 cx=(x4 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n5
  c12 = array licon in=pd6 cx=(x6 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=X
  c13 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.385 + 0.08, pt - 0.02 - 0.08) net=n3
  c14 = array licon in=pd3 cx=(x3 - 0.14) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) net=n1
  c15 = array licon in=pd5 cx=(x5 - 0.14) span=(pt - WP + 0.36 + 0.08, pt - 0.02 - 0.08) net=n4
  c16 = array licon in=pd2 cx=(x2 - 0.165) span=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  c17 = array licon in=pd4 cx=(x4 - 0.165) span=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  c18 = array licon in=pd6 cx=(x6 - 0.165) span=(pt - WP2 + 0.145, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.155) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 - 0.155) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x6 + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.58, x6 + L + 0.575) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.35) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.035) cy=0
  mc3 = contact mcon cx=(x2 + L - 0.05) cy=0
  mc4 = contact mcon cx=(x3 - 0.385) cy=0
  mc5 = contact mcon cx=(x3 + L - 0.07) cy=0
  mc6 = contact mcon cx=(x4 + 0.065) cy=0
  mc7 = contact mcon cx=(x4 + L + 0.38) cy=0
  mc8 = contact mcon cx=(x5 + 0.045) cy=0
  mc9 = contact mcon cx=(x6 + 0.03) cy=0
  mc10 = contact mcon cx=(x6 + L + 0.345) cy=0
  mc11 = contact mcon cx=(x1 - 0.35) cy=H
  mc12 = contact mcon cx=(x1 + L - 0.035) cy=H
  mc13 = contact mcon cx=(x2 + L - 0.05) cy=H
  mc14 = contact mcon cx=(x3 - 0.385) cy=H
  mc15 = contact mcon cx=(x3 + L - 0.07) cy=H
  mc16 = contact mcon cx=(x4 + 0.065) cy=H
  mc17 = contact mcon cx=(x4 + L + 0.38) cy=H
  mc18 = contact mcon cx=(x5 + 0.045) cy=H
  mc19 = contact mcon cx=(x6 + 0.03) cy=H
  mc20 = contact mcon cx=(x6 + L + 0.345) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port X out on=l32
end
