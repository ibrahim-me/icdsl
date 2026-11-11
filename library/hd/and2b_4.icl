# and2b_4: lifted from sky130_fd_sc_hd__and2b_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and2b_4 width=10 height=H taps=no
  device M0 pmos w=WP2 l=L d=VPWR g=A_N s=n1 b=VPB
  device M1 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M2 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M4 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M5 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M6 nmos w=WN2 l=L d=VGND g=A_N s=n1 b=VNB
  device M7 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M8 nmos w=WN l=L d=n2 g=n1 s=n3 b=VNB
  device M9 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=VPWR g=n1 s=n2 b=VPB
  device M11 pmos w=WP l=L d=n2 g=B s=VPWR b=VPB
  device M12 nmos w=WN l=L d=n3 g=B s=VGND b=VNB
  device M13 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.23
  x3 = x2 + 0.05
  x4 = x3 + L + 0.38
  x5 = x4 + L + 0.29
  x6 = x5 + 0.02
  x7 = x6 + L + 0.27
  x8 = x7 + 0.01
  x9 = x8 + L + 0.28
  x10 = x9 + L + 0.365
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x10 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.265, x10 + L + 0.27) yspan=(nb + 0.23, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x10 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x10 + L + 0.27) yspan=(pt - WP, pt - 0.58)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x10 - 0.15, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.145)
  p2 = rect poly xspan=(x10, x10 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x1 - 0.235, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x2 - 0.015, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x4, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p14 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 + L - 0.01, x4 - 0.055) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l2 = rect li xspan=(x5 + L - 0.03, x8 + 0.01) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l3 = rect li xspan=(x9 + L - 0.03, x10 - 0.06) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l4 = rect li xspan=(x1 + L + 0.07, x3 + L + 0.015) yspan=(nb + WN + 0.11, nb + WN + 0.44) net=B
  l5 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(nb + 0.02, nb + WN - 0.08) net=n2
  l6 = rect li xspan=(x1 - 0.31, x4 + 0.02) yspan=(nb + 0.23 + 0.15, nb + WN - 0.08) net=n2
  l7 = rect li xspan=(x1 + L - 0.03, x4 - 0.025) yspan=(pt - 0.58 - 0.405, pt - 0.58 - 0.16) net=n2
  l8 = rect li xspan=(x3 + L + 0.15, x4 - 0.025) yspan=(nb + WN + 0.55, pt - 0.58 - 0.405) net=n2
  l9 = rect li xspan=(x3 + L + 0.185, x4 - 0.025) yspan=(nb + 0.23 + 0.15, pt - 0.58 - 0.16) net=n2
  l10 = rect li xspan=(x3 + L + 0.185, x4 + 0.02) yspan=(nb + 0.23 + 0.15, pt - WP - 0.13) net=n2
  l11 = rect li xspan=(x3 + L + 0.185, x4 - 0.02) yspan=(nb + 0.23 + 0.15, pt - WP) net=n2
  l12 = rect li xspan=(x3 + L + 0.185, x8 + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.13) net=n2
  l13 = rect li xspan=(x4 + L, x9 + L - 0.045) yspan=(pt - WP + 0.05, pt - 0.58 - 0.16) net=X
  l14 = rect li xspan=(x4 + L + 0.045, x5 - 0.055) yspan=(nb + 0.23 + 0.03, nb + WN - 0.06) net=X
  l15 = rect li xspan=(x4 + L + 0.045, x9 + L - 0.045) yspan=(nb + 0.23 + 0.15, nb + WN - 0.06) net=X
  l16 = rect li xspan=(x8 + L + 0.09, x9 + L - 0.045) yspan=(nb + 0.23 + 0.15, pt - 0.58 - 0.16) net=X
  l17 = rect li xspan=(x9 + L + 0.13, x10 + 0.025) yspan=(nb + 0.23 + 0.16, pt - 0.58 - 0.16) net=A_N
  l18 = rect li xspan=(x9 + L + 0.13, x10 + L/2) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A_N
  l19 = rect li xspan=(x1 - 0.235, x1 - 0.065) yspan=(nb + WN + 0.11, pt - 0.58 + 0.18) net=n1
  l20 = rect li xspan=(x1 - 0.235, x1 + 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l21 = rect li xspan=(x1 - 0.235, x10 + L + 0.23) yspan=(pt - 0.58 + 0.01, pt - 0.58 + 0.18) net=n1
  l22 = rect li xspan=(x10 + L + 0.055, x10 + L + 0.225) yspan=(nb + 0.23 + 0.03, nb + WN - 0.04) net=n1
  l23 = rect li xspan=(x10 + L + 0.06, x10 + L + 0.23) yspan=(pt - WP + 0.045, pt - 0.58 + 0.18) net=n1
  l24 = rect li xspan=(x10 + L + 0.1, x10 + L + 0.27) yspan=(nb + 0.23 + 0.21, pt - 0.58 - 0.205) net=n1
  l25 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l26 = rect li xspan=(x3 + L + 0.03, x4 - 0.02) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l27 = rect li xspan=(x5 + L - 0.01, x8 + 0.03) yspan=(pt - 0.21, H + 0.085) net=VPWR
  l28 = rect li xspan=(x9 + L - 0.03, x10 - 0.06) yspan=(pt - 0.21, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.16) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x6 + L + 0.12) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x9 + L + 0.14) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=n2
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.23 + 0.03 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.23 + 0.03 + 0.08, nb + WN - 0.04 - 0.08) net=n1
  c7 = array licon in=nd1 cx=(x8 + L + 0.135) span=(nb + 0.23 + 0.15, nb + WN - 0.06) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x5 - 0.12) span=(pt - WP + 0.05, pt - 0.58 - 0.16) margin=0.04 net=X
  c9 = array licon in=pd1 cx=(x8 + L + 0.14) span=(pt - WP + 0.05, pt - 0.58 - 0.16) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x2 - 0.09) span=(pt - 0.58 - 0.405, pt - 0.58 - 0.16) margin=0.04 net=n2
  c11 = array licon in=pd2 cx=(x10 + L + 0.145) span=(pt - WP + 0.045 + 0.08, pt - 0.58 + 0.18 - 0.08) net=n1
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  c13 = array licon in=pd1 cx=(x4 - 0.185) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x7 - 0.13) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x9 + L + 0.14) span=(pt - 0.21, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.06) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.025) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + 0.05) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.025) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x10 - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.08) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.13) cy=0
  mc5 = contact mcon cx=(x7 - 0.13) cy=0
  mc6 = contact mcon cx=(x9 - 0.1) cy=0
  mc7 = contact mcon cx=(x10 - 0.145) cy=0
  mc8 = contact mcon cx=(x10 + L + 0.175) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.08) cy=H
  mc11 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.13) cy=H
  mc13 = contact mcon cx=(x7 - 0.13) cy=H
  mc14 = contact mcon cx=(x9 - 0.1) cy=H
  mc15 = contact mcon cx=(x10 - 0.145) cy=H
  mc16 = contact mcon cx=(x10 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l17
  port B in on=l4
  port X out on=l16
end
