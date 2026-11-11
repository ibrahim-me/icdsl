# a22o_2: lifted from sky130_fd_sc_hd__a22o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a22o_2 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=n3 g=B1 s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M4 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M6 nmos w=WN l=L d=VGND g=B2 s=n3 b=VNB
  device M7 pmos w=WP l=L d=n1 g=B2 s=n2 b=VPB
  device M8 nmos w=WN l=L d=n1 g=A1 s=n4 b=VNB
  device M9 pmos w=WP l=L d=n2 g=B1 s=n1 b=VPB
  device M10 nmos w=WN l=L d=n4 g=A2 s=VGND b=VNB
  device M11 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.24
  x3 = x2 + 0.04
  x4 = x3 + L + 0.8
  x5 = x4 + L + 0.34
  x6 = x5 + L + 0.325
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.225) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x4 - 0.265, x7 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.265, x7 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.22, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.125, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6 - 0.11, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + L) yspan=(-0.085, nb + WN - 0.035) net=VGND
  l2 = rect li xspan=(x5 + L - 0.03, x6 - 0.02) yspan=(-0.085, nb + 0.33) net=VGND
  l3 = rect li xspan=(x7 + L + 0.065, x7 + L + 0.235) yspan=(-0.085, nb + WN + 0.1) net=VGND
  l4 = rect li xspan=(x1 - 0.31, x1 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l5 = rect li xspan=(x4 + L + 0.11, x5 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l6 = rect li xspan=(x2 - 0.015, x3 + L + 0.28) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=B1
  l7 = rect li xspan=(x3 + L + 0.06, x3 + L + 0.28) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=B1
  l8 = rect li xspan=(x4 - 0.25, x4 - 0.04) yspan=(nb + WN - 0.21, pt - WP - 0.2) net=A1
  l9 = rect li xspan=(x4 - 0.25, x4 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.2) net=A1
  l10 = rect li xspan=(x1 - 0.305, x6 + L - 0.035) yspan=(pt - WP - 0.03, pt - WP + 0.14) net=n1
  l11 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - WP - 0.03, pt - 0.02) net=n1
  l12 = rect li xspan=(x1 - 0.305, x3 + L + 0.305) yspan=(pt - 0.19, pt - 0.02) net=n1
  l13 = rect li xspan=(x3 + 0.005, x5 - 0.095) yspan=(nb + 0.02, nb + 0.27) net=n1
  l14 = rect li xspan=(x2 + L + 0.01, x3 + L + 0.305) yspan=(pt - 0.23, pt - 0.02) net=n1
  l15 = rect li xspan=(x4 + L + 0.075, x5 - 0.095) yspan=(nb + 0.02, nb + WN + 0.02) net=n1
  l16 = rect li xspan=(x4 + L + 0.075, x6 + L - 0.035) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n1
  l17 = rect li xspan=(x6 - 0.06, x6 + L - 0.035) yspan=(nb + WN - 0.15, pt - WP + 0.14) net=n1
  l18 = rect li xspan=(x1 + L + 0.055, x5 - 0.01) yspan=(pt - WP + 0.31, pt - WP + 0.55) net=n2
  l19 = rect li xspan=(x1 + L + 0.055, x3 + 0.01) yspan=(pt - WP + 0.31, pt - 0.36) net=n2
  l20 = rect li xspan=(x4 + L + 0.08, x5 - 0.01) yspan=(pt - WP + 0.31, pt - 0.02) net=n2
  l21 = rect li xspan=(x6 + L + 0.055, x7 + 0.04) yspan=(nb + 0.02, nb + WN - 0.3) net=X
  l22 = rect li xspan=(x6 + L + 0.055, x7 + 0.04) yspan=(pt - WP + 0.3, pt - 0.02) net=X
  l23 = rect li xspan=(x7 - 0.135, x7 + 0.04) yspan=(nb + 0.02, pt - 0.02) net=X
  l24 = rect li xspan=(x4 - 0.305, x4 + 0.055) yspan=(pt - 0.27, H + 0.085) net=VPWR
  l25 = rect li xspan=(x5 + L + 0.02, x6 + 0.03) yspan=(pt - 0.61, H + 0.085) net=VPWR
  l26 = rect li xspan=(x7 + L + 0.065, x7 + L + 0.235) yspan=(pt - WP - 0.04, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN - 0.035) net=VGND
  c2 = array licon in=nd2 cx=(x5 + L + 0.14) span=(-0.085, nb + 0.33) margin=0.04 net=VGND
  c3 = array licon in=nd2 cx=(x7 + L + 0.15) span=(-0.085 + 0.08, nb + WN + 0.1 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x3 + L + 0.1) span=(nb + 0.02, nb + 0.27) net=n1
  c5 = array licon in=nd2 cx=(x4 - 0.14) span=(nb + 0.02, nb + 0.27) net=n1
  c6 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.3 - 0.08) margin=0.04 net=X
  c7 = array licon in=pd2 cx=(x7 + L + 0.15) span=(pt - WP - 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP - 0.03, pt - 0.02) net=n1
  c9 = array licon in=pd2 cx=(x4 + L + 0.165) span=(pt - WP + 0.31 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x2 - 0.1) span=(pt - WP + 0.31 + 0.08, pt - 0.36 - 0.08) margin=0.04 net=n2
  c11 = array licon in=pd2 cx=(x6 - 0.14) span=(pt - 0.61, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c13 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - 0.27, H + 0.085) net=VPWR
  c14 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.23, pt - 0.02) net=n1
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.005) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.085) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + 0.03) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.09) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.15) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.15) cy=0
  mc7 = contact mcon cx=(x7 - 0.135) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.185) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.09) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc12 = contact mcon cx=(x4 - 0.15) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.17) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.15) cy=H
  mc15 = contact mcon cx=(x7 - 0.135) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l5
  port B1 in on=l6
  port B2 in on=l4
  port X out on=l22
end
