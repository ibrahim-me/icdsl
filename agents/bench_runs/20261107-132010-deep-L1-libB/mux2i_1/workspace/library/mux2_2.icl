# mux2_2: lifted from sky130_fd_sc_hd__mux2_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell mux2_2 width=11 height=H taps=no
  device M0 nmos w=WN2 l=L d=VGND g=n1 s=n2 b=VNB
  device M1 pmos w=WP2 l=L d=n3 g=A1 s=n4 b=VPB
  device M2 nmos w=WN2 l=L d=n2 g=A0 s=n4 b=VNB
  device M3 nmos w=WN2 l=L d=n4 g=A1 s=n5 b=VNB
  device M4 pmos w=WP2 l=L d=VPWR g=S s=n1 b=VPB
  device M5 pmos w=WP2 l=L d=n4 g=A0 s=n6 b=VPB
  device M6 nmos w=WN2 l=L d=VGND g=S s=n1 b=VNB
  device M7 pmos w=WP2 l=L d=n6 g=S s=VPWR b=VPB
  device M8 nmos w=WN2 l=L d=n5 g=S s=VGND b=VNB
  device M9 nmos w=WN l=L d=X g=n4 s=VGND b=VNB
  device M10 nmos w=WN l=L d=VGND g=n4 s=X b=VNB
  device M11 pmos w=WP l=L d=VPWR g=n4 s=X b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=n1 s=n3 b=VPB
  device M13 pmos w=WP l=L d=X g=n4 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.335
  x4 = x3 + 0.09
  x5 = x4 + L + 0.245
  x6 = x5 + L + 0.34
  x7 = x6 + L + 0.355
  x8 = x7 + 0.065
  x9 = x8 + L + 0.22
  x10 = x9 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x10 + L + 0.275) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.265, x10 + L + 0.275) yspan=(pt - WP2, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.39)
  p2 = rect poly xspan=(x5, x5 + L + 0.125) yspan=(nb + WN2 + 0.11, pt - WP - 0.39)
  p3 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x1, x2 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3 - 0.01, x4 + L + 0.03) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.04, H - 0.105)
  p10 = rect poly xspan=(x6, x8 + L) yspan=(nb + WN + 0.04, nb + WN + 0.19)
  p11 = rect poly xspan=(x7 - 0.12, x8 + L) yspan=(nb + WN - 0.08, nb + WN + 0.19)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, nb + WN + 0.19)
  p13 = rect poly xspan=(x7 - 0.12, x8 + L) yspan=(pt - WP - 0.2, pt - WP + 0.07)
  p14 = rect poly xspan=(x8, x8 + L) yspan=(pt - WP - 0.2, H - 0.105)
  p15 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p17 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 - 0.03) yspan=(-0.085, nb + 0.23) net=VGND
  l3 = rect li xspan=(x9 + L + 0.04, x10 - 0.04) yspan=(-0.085, nb + WN2 - 0.07) net=VGND
  l4 = rect li xspan=(x7 - 0.12, x9 - 0.08) yspan=(nb + WN2 + 0.08, nb + WN + 0.14) net=A1
  l5 = rect li xspan=(x7 + L + 0.01, x9 - 0.08) yspan=(nb + 0.185, nb + WN + 0.14) net=A1
  l6 = rect li xspan=(x5 + 0.05, x6 + L + 0.055) yspan=(nb + WN2 + 0.11, pt - WP - 0.205) net=A0
  l7 = rect li xspan=(x6 + 0.03, x6 + L + 0.055) yspan=(nb + WN2 + 0.11, pt - WP + 0.14) net=A0
  l8 = rect li xspan=(x6 + 0.03, x9 - 0.08) yspan=(nb + WN + 0.43, pt - WP + 0.14) net=A0
  l9 = rect li xspan=(x9 + L + 0.05, x10 - 0.04) yspan=(nb + WN2 + 0.1, pt - WP + 0.14) net=S
  l10 = rect li xspan=(x2 + 0.04, x3 - 0.13) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n4
  l11 = rect li xspan=(x2 + L + 0.035, x3 - 0.13) yspan=(nb + WN2 - 0.02, pt - WP2 + 0.16) net=n4
  l12 = rect li xspan=(x2 + L + 0.035, x4 + L + 0.08) yspan=(nb + WN2 - 0.02, nb + WN - 0.08) net=n4
  l13 = rect li xspan=(x2 + L + 0.035, x5 - 0.115) yspan=(pt - WP2 - 0.01, pt - WP2 + 0.16) net=n4
  l14 = rect li xspan=(x3 + L - 0.005, x7 - 0.015) yspan=(nb + 0.06, nb + WN2 - 0.19) net=n4
  l15 = rect li xspan=(x3 + L - 0.005, x4 + L + 0.08) yspan=(nb + 0.06, nb + WN - 0.08) net=n4
  l16 = rect li xspan=(x3 + L + 0.045, x5 - 0.115) yspan=(pt - WP2 - 0.01, pt - 0.06) net=n4
  l17 = rect li xspan=(x3 + L + 0.045, x8 - 0.01) yspan=(pt - 0.23, pt - 0.06) net=n4
  l18 = rect li xspan=(x1 + L - 0.03, x2 - 0.135) yspan=(nb + 0.02, pt - 0.02) net=X
  l19 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(nb + 0.02, nb + WN2 + 0.095) net=X
  l20 = rect li xspan=(x1 + L - 0.03, x2 + 0.01) yspan=(pt - WP + 0.11, pt - 0.02) net=X
  l21 = rect li xspan=(x3 + 0.045, x4 + L - 0.025) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n1
  l22 = rect li xspan=(x3 + 0.045, x5 + L + 0.085) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l23 = rect li xspan=(x5 + 0.06, x5 + L + 0.085) yspan=(pt - WP + 0.01, pt - WP2 + 0.16) net=n1
  l24 = rect li xspan=(x5 + 0.06, x10 + L + 0.32) yspan=(pt - WP2 - 0.01, pt - WP2 + 0.16) net=n1
  l25 = rect li xspan=(x10 + L - 0.02, x10 + L + 0.32) yspan=(pt - WP2 - 0.01, pt - 0.02) net=n1
  l26 = rect li xspan=(x10 + L - 0.015, x10 + L + 0.32) yspan=(nb + 0.02, pt - 0.02) net=n1
  l27 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l28 = rect li xspan=(x2 + L + 0.065, x3 + 0.025) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l29 = rect li xspan=(x9 + L + 0.015, x10 - 0.045) yspan=(pt - 0.31, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.23) net=VGND
  c3 = array licon in=nd1 cx=(x5 + L + 0.14) span=(nb + 0.06, nb + WN2 - 0.19) margin=0.04 net=n4
  c4 = array licon in=nd1 cx=(x6 + L + 0.175) span=(nb + 0.06, nb + WN2 - 0.19) margin=0.04 net=n4
  c5 = array licon in=nd2 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 + 0.095 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd1 cx=(x9 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.07 - 0.08) margin=0.04 net=VGND
  c7 = array licon in=nd1 cx=(x10 + L + 0.15) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.11 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c10 = array licon in=pd2 cx=(x10 + L + 0.15) span=(nb + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  c11 = array licon in=pd2 cx=(x3 - 0.145) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd2 cx=(x7 - 0.115) span=(pt - 0.23, pt - 0.06) margin=0.04 net=n4
  c13 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - 0.31 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x5 + L - 0.015) cy=(nb + WN + 0.045)
  gc2 = contact licon cx=(x8 - 0.015) cy=(nb + WN + 0.055)
  gc3 = contact licon cx=(x2 + L - 0.025) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + L - 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 - 0.135) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 - 0.015) cy=(pt - WP - 0.065)
  np1 = rect npc xspan=(x1 - 0.4, x10 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x5 - 0.055, x6 - 0.165) yspan=(nb + WN2 + 0.09, pt - WP - 0.14)
  np3 = rect npc xspan=(x7 - 0.14, x8 + L + 0.025) yspan=(nb + WN2 + 0.1, pt - WP + 0.12)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.145) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.085) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.16) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x8 + L + 0.04) cy=0
  mc8 = contact mcon cx=(x9 + L + 0.14) cy=0
  mc9 = contact mcon cx=(x10 + L + 0.18) cy=0
  mc10 = contact mcon cx=(x1 - 0.17) cy=H
  mc11 = contact mcon cx=(x2 - 0.13) cy=H
  mc12 = contact mcon cx=(x3 - 0.145) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.085) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.16) cy=H
  mc15 = contact mcon cx=(x6 + L + 0.14) cy=H
  mc16 = contact mcon cx=(x8 + L + 0.04) cy=H
  mc17 = contact mcon cx=(x9 + L + 0.14) cy=H
  mc18 = contact mcon cx=(x10 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A0 in on=l8
  port A1 in on=l4
  port S in on=l9
  port X out on=l20
end
