# and3b_4: lifted from sky130_fd_sc_hd__and3b_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and3b_4 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 nmos w=WN l=L d=n2 g=C s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M3 pmos w=WP l=L d=VPWR g=B s=n1 b=VPB
  device M4 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M5 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M6 pmos w=WP2 l=L d=VPWR g=A_N s=n3 b=VPB
  device M7 pmos w=WP l=L d=n1 g=C s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M9 pmos w=WP l=L d=n1 g=n3 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=n1 g=n3 s=n4 b=VNB
  device M11 nmos w=WN2 l=L d=VGND g=A_N s=n3 b=VNB
  device M12 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M13 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M14 nmos w=WN l=L d=n4 g=B s=n2 b=VNB
  device M15 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.615
  x2 = x1 + L + 0.385
  x3 = x2 + L + 0.24
  x4 = x3 + 0.07
  x5 = x4 + L + 0.365
  x6 = x5 + L + 0.29
  x7 = x6 + 0.01
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.29
  x10 = x9 + L + 0.37
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.31, x10 - 0.08) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x1 - 0.31, x10 + L + 0.36) yspan=(nb + 0.23, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.335, x10 - 0.08) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.335, x10 + L + 0.29) yspan=(pt - 0.34 - WP2, pt - 0.34)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2 - 0.17, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.025, x4 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x9 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x10 - 0.13, x10 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x10, x10 + L) yspan=(nb - 0.1, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x4 + L + 0.05, x5 + 0.02) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l2 = rect li xspan=(x6 + L - 0.025, x8 + 0.025) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l3 = rect li xspan=(x9 + L - 0.025, x10 - 0.06) yspan=(-0.085, nb + 0.23 - 0.02) net=VGND
  l4 = rect li xspan=(x2 - 0.12, x2 + L - 0.05) yspan=(nb + WN - 0.16, pt - WP - 0.145) net=B
  l5 = rect li xspan=(x3 + 0.01, x4 + L - 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.145) net=C
  l6 = rect li xspan=(x5 + L - 0.015, x9 + L + 0.01) yspan=(pt - WP + 0.05, pt - 0.34 - WP2 - 0.02) net=X
  l7 = rect li xspan=(x5 + L + 0.05, x6 - 0.05) yspan=(nb + 0.23 + 0.05, nb + WN - 0.04) net=X
  l8 = rect li xspan=(x5 + L + 0.05, x9 + L + 0.01) yspan=(nb + 0.23 + 0.15, nb + WN - 0.04) net=X
  l9 = rect li xspan=(x8 + L + 0.05, x9 - 0.05) yspan=(nb + 0.02, nb + WN - 0.04) net=X
  l10 = rect li xspan=(x9 - 0.115, x9 + L + 0.01) yspan=(nb + 0.23 + 0.15, pt - 0.34 - WP2 - 0.02) net=X
  l11 = rect li xspan=(x10 - 0.18, x10 + L - 0.045) yspan=(nb + 0.23 + 0.15, pt - 0.34 - WP2 - 0.02) net=A_N
  l12 = rect li xspan=(x1 - 0.075, x1 + L + 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l13 = rect li xspan=(x1 + 0.07, x1 + L + 0.095) yspan=(nb + WN + 0.11, pt - 0.34 - 0.04) net=n3
  l14 = rect li xspan=(x1 + 0.07, x10 + L + 0.41) yspan=(pt - 0.34 - WP2 + 0.15, pt - 0.34 - 0.04) net=n3
  l15 = rect li xspan=(x10 + L + 0.13, x10 + L + 0.41) yspan=(nb + 0.23 - 0.04, pt - 0.34 - 0.04) net=n3
  l16 = rect li xspan=(x1 - 0.465, x1 - 0.245) yspan=(nb + 0.02, pt - 0.34 + 0.02) net=n1
  l17 = rect li xspan=(x1 - 0.465, x1 + 0.025) yspan=(nb + 0.02, nb + WN - 0.08) net=n1
  l18 = rect li xspan=(x1 - 0.465, x4 + 0.015) yspan=(nb + 0.23 - 0.11, nb + WN - 0.34) net=n1
  l19 = rect li xspan=(x1 - 0.465, x1 - 0.105) yspan=(pt - WP + 0.01, pt - 0.34 + 0.02) net=n1
  l20 = rect li xspan=(x2 + L - 0.005, x5 - 0.04) yspan=(pt - WP + 0.04, pt - 0.34 - WP2 - 0.03) net=n1
  l21 = rect li xspan=(x3 - 0.1, x4 + 0.015) yspan=(nb + 0.23 - 0.11, nb + WN - 0.08) net=n1
  l22 = rect li xspan=(x3 - 0.1, x5 + 0.025) yspan=(nb + 0.23 + 0.15, nb + WN - 0.08) net=n1
  l23 = rect li xspan=(x4 + L + 0.155, x5 - 0.04) yspan=(nb + 0.23 + 0.15, pt - 0.34 - WP2 - 0.03) net=n1
  l24 = rect li xspan=(x4 + L + 0.155, x5 + 0.025) yspan=(nb + 0.23 + 0.15, pt - WP - 0.13) net=n1
  l25 = rect li xspan=(x4 + L + 0.155, x8 + L) yspan=(nb + WN + 0.135, pt - WP - 0.13) net=n1
  l26 = rect li xspan=(x1 + L - 0.03, x2 + 0.045) yspan=(pt - 0.34 + 0.13, H + 0.085) net=VPWR
  l27 = rect li xspan=(x4 + L + 0.015, x5 - 0.02) yspan=(pt - 0.34 + 0.13, H + 0.085) net=VPWR
  l28 = rect li xspan=(x6 + L - 0.025, x8 + 0.03) yspan=(pt - 0.34 + 0.13, H + 0.085) net=VPWR
  l29 = rect li xspan=(x9 + L - 0.025, x10 - 0.06) yspan=(pt - 0.34 + 0.13, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 - 0.15) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x7 + L + 0.135) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x9 + L + 0.145) span=(-0.085, nb + 0.23 - 0.02) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN - 0.08) margin=0.04 net=n1
  c5 = array licon in=nd1 cx=(x8 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd2 cx=(x10 + L + 0.215) span=(nb + 0.23 - 0.04 + 0.08, pt - 0.34 - 0.04 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x5 + L + 0.145) span=(nb + 0.23 + 0.05 + 0.08, nb + WN - 0.04 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x3 - 0.075) span=(pt - WP + 0.04, pt - 0.34 - WP2 - 0.03) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x6 - 0.135) span=(pt - WP + 0.05, pt - 0.34 - WP2 - 0.02) margin=0.04 net=X
  c10 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - WP + 0.05, pt - 0.34 - WP2 - 0.02) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x1 - 0.19) span=(pt - WP + 0.01 + 0.08, pt - 0.34 + 0.02 - 0.08) margin=0.04 net=n1
  c12 = array licon in=pd2 cx=(x10 + L + 0.145) span=(pt - 0.34 - WP2 + 0.15, pt - 0.34 - 0.04) margin=0.04 net=n3
  c13 = array licon in=pd1 cx=(x2 - 0.175) span=(pt - 0.34 + 0.13, H + 0.085) margin=0.04 net=VPWR
  c14 = array licon in=pd1 cx=(x4 + L + 0.18) span=(pt - 0.34 + 0.13, H + 0.085) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x7 + L + 0.14) span=(pt - 0.34 + 0.13, H + 0.085) margin=0.04 net=VPWR
  c16 = array licon in=pd1 cx=(x9 + L + 0.145) span=(pt - 0.34 + 0.13, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.035) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + L - 0.035) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 + 0.065) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x8 - 0.02) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x10 + 0.01) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.615, x10 + L + 0.565) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.385) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.07) cy=0
  mc3 = contact mcon cx=(x2 + 0.015) cy=0
  mc4 = contact mcon cx=(x4 + 0.025) cy=0
  mc5 = contact mcon cx=(x5 - 0.025) cy=0
  mc6 = contact mcon cx=x7 cy=0
  mc7 = contact mcon cx=(x8 + 0.04) cy=0
  mc8 = contact mcon cx=(x9 + 0.07) cy=0
  mc9 = contact mcon cx=(x10 + 0.02) cy=0
  mc10 = contact mcon cx=(x10 + L + 0.335) cy=0
  mc11 = contact mcon cx=(x1 - 0.385) cy=H
  mc12 = contact mcon cx=(x1 + L - 0.07) cy=H
  mc13 = contact mcon cx=(x2 + 0.015) cy=H
  mc14 = contact mcon cx=(x4 + 0.025) cy=H
  mc15 = contact mcon cx=(x5 - 0.025) cy=H
  mc16 = contact mcon cx=x7 cy=H
  mc17 = contact mcon cx=(x8 + 0.04) cy=H
  mc18 = contact mcon cx=(x9 + 0.07) cy=H
  mc19 = contact mcon cx=(x10 + 0.02) cy=H
  mc20 = contact mcon cx=(x10 + L + 0.335) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l11
  port B in on=l4
  port C in on=l5
  port X out on=l10
end
