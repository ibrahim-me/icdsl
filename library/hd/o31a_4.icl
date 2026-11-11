# o31a_4: lifted from sky130_fd_sc_hd__o31a_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o31a_4 width=18 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 nmos w=WN l=L d=n2 g=A3 s=VGND b=VNB
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=B1 s=n1 b=VPB
  device M4 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M6 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M7 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M8 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M9 pmos w=WP l=L d=n4 g=A3 s=n1 b=VPB
  device M10 pmos w=WP l=L d=n1 g=B1 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M12 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M13 pmos w=WP l=L d=n1 g=A3 s=n4 b=VPB
  device M14 pmos w=WP l=L d=n3 g=A2 s=n4 b=VPB
  device M15 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M16 nmos w=WN l=L d=VGND g=A3 s=n2 b=VNB
  device M17 pmos w=WP l=L d=VPWR g=A1 s=n3 b=VPB
  device M18 nmos w=WN l=L d=n1 g=B1 s=n2 b=VNB
  device M19 nmos w=WN l=L d=n2 g=B1 s=n1 b=VNB
  device M20 nmos w=WN l=L d=VGND g=A2 s=n2 b=VNB
  device M21 pmos w=WP l=L d=n4 g=A2 s=n3 b=VPB
  device M22 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M23 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.515
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.31
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.3
  x7 = x6 + 0.1
  x8 = x7 + L + 0.28
  x9 = x8 + L + 0.32
  x10 = x9 + L + 0.28
  x11 = x10 + L + 0.28
  x12 = x11 + L + 0.28
  x13 = x12 + L + 0.28
  x14 = x13 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 - 0.015) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 + L + 0.115, x14 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 - 0.095) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x8 + L + 0.035, x14 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x4 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.14, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.19)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, pt - WP - 0.19)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x9, x10 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p13 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p14 = rect poly xspan=(x11 - 0.065, x11 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p15 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p16 = rect poly xspan=(x12, x12 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x12, x13 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p18 = rect poly xspan=(x13, x13 + L) yspan=(0.105, H - 0.105)
  p19 = rect poly xspan=(x14, x14 + L) yspan=(0.105, H - 0.105)
  p20 = rect poly xspan=(x14, x14 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.43, x1) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x2 + L - 0.015, x3 + 0.015) yspan=(-0.085, nb + 0.25) net=VGND
  l3 = rect li xspan=(x4 + L - 0.015, x5 + 0.03) yspan=(-0.085, nb + WN) net=VGND
  l4 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x11 + L - 0.03, x12 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l6 = rect li xspan=(x13 + L - 0.03, x14 + 0.03) yspan=(-0.085, nb + 0.21) net=VGND
  l7 = rect li xspan=(x5 + L + 0.075, x9 - 0.075) yspan=(nb + 0.02, nb + 0.23) net=n2
  l8 = rect li xspan=(x8 + L + 0.055, x9 - 0.075) yspan=(nb + 0.02, nb + WN) net=n2
  l9 = rect li xspan=(x8 + L + 0.055, x14 + L + 0.47) yspan=(nb + WN - 0.25, nb + WN) net=n2
  l10 = rect li xspan=(x10 + L + 0.055, x11 - 0.055) yspan=(nb + 0.02, nb + WN) net=n2
  l11 = rect li xspan=(x12 + L + 0.055, x13 - 0.055) yspan=(nb + 0.02, nb + WN) net=n2
  l12 = rect li xspan=(x14 + L + 0.055, x14 + L + 0.47) yspan=(nb + 0.02, nb + WN) net=n2
  l13 = rect li xspan=(x9 + L - 0.025, x10 + 0.035) yspan=(nb + WN + 0.17, pt - WP - 0.125) net=A3
  l14 = rect li xspan=(x12 + L + 0.095, x13 + L) yspan=(nb + WN + 0.17, pt - WP - 0.125) net=A1
  l15 = rect li xspan=(x7 + 0.02, x9 - 0.07) yspan=(nb + WN + 0.17, pt - WP - 0.13) net=B1
  l16 = rect li xspan=(x7 + 0.02, x8 - 0.035) yspan=(nb + WN + 0.17, pt - WP + 0.21) net=B1
  l17 = rect li xspan=(x10 + L + 0.06, x12 + 0.07) yspan=(nb + WN + 0.17, pt - WP - 0.125) net=A2
  l18 = rect li xspan=(x11 + L + 0.055, x12 + 0.07) yspan=(nb + WN + 0.17, pt - WP + 0.215) net=A2
  l19 = rect li xspan=(x11 + L + 0.055, x14 + L + 0.47) yspan=(pt - WP + 0.045, pt - WP + 0.215) net=A2
  l20 = rect li xspan=(x14 - 0.105, x14 + L + 0.47) yspan=(nb + WN + 0.17, pt - WP + 0.215) net=A2
  l21 = rect li xspan=(x1 - 0.43, x1 + L + 0.08) yspan=(nb + WN - 0.17, pt - WP + 0.18) net=X
  l22 = rect li xspan=(x1 - 0.43, x4 - 0.055) yspan=(pt - WP - 0.025, pt - WP + 0.18) net=X
  l23 = rect li xspan=(x1 + L + 0.025, x2 - 0.04) yspan=(nb + 0.02, nb + WN) net=X
  l24 = rect li xspan=(x1 + L + 0.025, x4 - 0.04) yspan=(nb + WN - 0.23, nb + WN) net=X
  l25 = rect li xspan=(x1 + L + 0.025, x2 - 0.04) yspan=(pt - WP - 0.025, pt - 0.02) net=X
  l26 = rect li xspan=(x3 + L + 0.04, x4 - 0.04) yspan=(nb + 0.02, nb + WN) net=X
  l27 = rect li xspan=(x3 + L + 0.04, x4 - 0.055) yspan=(pt - WP - 0.025, pt - 0.02) net=X
  l28 = rect li xspan=(x2 - 0.03, x6 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.195) net=n1
  l29 = rect li xspan=(x5 + L + 0.075, x6 - 0.055) yspan=(nb + WN - 0.25, pt - 0.02) net=n1
  l30 = rect li xspan=(x5 + L + 0.075, x8 + 0.03) yspan=(nb + WN - 0.25, nb + WN) net=n1
  l31 = rect li xspan=(x5 + L + 0.075, x10 + 0.03) yspan=(pt - WP + 0.385, pt - 0.415) net=n1
  l32 = rect li xspan=(x9 + L - 0.03, x10 + 0.03) yspan=(pt - WP + 0.385, pt - 0.02) net=n1
  l33 = rect li xspan=(x8 + L - 0.01, x11 + 0.03) yspan=(pt - WP + 0.045, pt - WP + 0.215) net=n4
  l34 = rect li xspan=(x10 + L + 0.055, x11 + 0.03) yspan=(pt - WP + 0.045, pt - 0.02) net=n4
  l35 = rect li xspan=(x11 + L + 0.055, x14 - 0.025) yspan=(pt - WP + 0.385, pt - 0.415) net=n3
  l36 = rect li xspan=(x11 + L + 0.055, x12 - 0.055) yspan=(pt - WP + 0.385, pt - 0.02) net=n3
  l37 = rect li xspan=(x13 + L + 0.055, x14 - 0.025) yspan=(pt - WP + 0.385, pt - 0.02) net=n3
  l38 = rect li xspan=(x14 + L, x14 + L + 0.47) yspan=(pt - 0.615, pt - 0.02) net=n4
  l39 = rect li xspan=(x1 - 0.43, x1) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l40 = rect li xspan=(x2 + L - 0.015, x3 + 0.015) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l41 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP - 0.025, H + 0.085) net=VPWR
  l42 = rect li xspan=(x7 + 0.02, x8 - 0.075) yspan=(pt - 0.245, H + 0.085) net=VPWR
  l43 = rect li xspan=(x12 + L - 0.03, x13 + 0.03) yspan=(pt - 0.245, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.155) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x6 - 0.04) span=(nb + 0.02, nb + 0.23) margin=0.04 net=n2
  c3 = array licon in=nd2 cx=(x9 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x11 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c5 = array licon in=nd2 cx=(x13 + L + 0.14) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) net=VGND
  c7 = array licon in=nd1 cx=(x4 + L + 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c8 = array licon in=nd2 cx=(x8 + L + 0.15) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n2
  c9 = array licon in=nd2 cx=(x10 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n2
  c10 = array licon in=nd2 cx=(x12 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n2
  c11 = array licon in=nd2 cx=(x14 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n2
  c12 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=X
  c13 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=X
  c14 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + WN - 0.25, nb + WN) margin=0.04 net=n1
  c15 = array licon in=pd2 cx=(x9 - 0.14) span=(pt - WP + 0.045, pt - WP + 0.215) margin=0.04 net=n4
  c16 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP - 0.025, H + 0.085) margin=0.04 net=VPWR
  c17 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP - 0.025 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c18 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP - 0.025 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c19 = array licon in=pd1 cx=(x6 - 0.14) span=(nb + WN - 0.25 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c20 = array licon in=pd2 cx=(x10 + L + 0.14) span=(pt - WP + 0.045 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n4
  c21 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  c22 = array licon in=pd1 cx=(x2 + L + 0.155) span=(pt - 0.65, H + 0.085) margin=0.04 net=VPWR
  c23 = array licon in=pd2 cx=(x9 + L + 0.14) span=(pt - WP + 0.385, pt - 0.02) margin=0.04 net=n1
  c24 = array licon in=pd2 cx=(x11 + L + 0.14) span=(pt - WP + 0.385 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c25 = array licon in=pd2 cx=(x13 + L + 0.14) span=(pt - WP + 0.385 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c26 = array licon in=pd2 cx=(x14 + L + 0.14) span=(pt - 0.615 + 0.08, pt - 0.02 - 0.08) net=n4
  c27 = array licon in=pd1 cx=(x7 + L + 0.04) span=(pt - 0.245, H + 0.085) margin=0.04 net=VPWR
  c28 = array licon in=pd2 cx=(x12 + L + 0.14) span=(pt - 0.245, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.03) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.065) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 - 0.06) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 - 0.135) cy=(nb + WN + 0.275)
  gc6 = contact licon cx=(x11 + L/2) cy=(nb + WN + 0.275)
  gc7 = contact licon cx=(x13 - 0.02) cy=(nb + WN + 0.275)
  gc8 = contact licon cx=(x14 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.515, x14 + L + 0.555) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.285) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.035) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.075) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.085) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.125) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.085) cy=0
  mc8 = contact mcon cx=(x8 + L + 0.125) cy=0
  mc9 = contact mcon cx=(x9 + L + 0.125) cy=0
  mc10 = contact mcon cx=(x11 - 0.115) cy=0
  mc11 = contact mcon cx=(x12 - 0.075) cy=0
  mc12 = contact mcon cx=(x13 - 0.035) cy=0
  mc13 = contact mcon cx=(x14 + 0.01) cy=0
  mc14 = contact mcon cx=(x14 + L + 0.325) cy=0
  mc15 = contact mcon cx=(x11 - 0.115) cy=(pt - 0.275)
  mc16 = contact mcon cx=(x14 + L + 0.325) cy=(pt - 0.275)
  mc17 = contact mcon cx=(x1 - 0.285) cy=H
  mc18 = contact mcon cx=(x1 + L + 0.035) cy=H
  mc19 = contact mcon cx=(x2 + L + 0.075) cy=H
  mc20 = contact mcon cx=(x3 + L + 0.085) cy=H
  mc21 = contact mcon cx=(x4 + L + 0.125) cy=H
  mc22 = contact mcon cx=(x6 - 0.135) cy=H
  mc23 = contact mcon cx=(x7 + L + 0.085) cy=H
  mc24 = contact mcon cx=(x8 + L + 0.125) cy=H
  mc25 = contact mcon cx=(x9 + L + 0.125) cy=H
  mc26 = contact mcon cx=(x11 - 0.115) cy=H
  mc27 = contact mcon cx=(x12 - 0.075) cy=H
  mc28 = contact mcon cx=(x13 - 0.035) cy=H
  mc29 = contact mcon cx=(x14 + 0.01) cy=H
  mc30 = contact mcon cx=(x14 + L + 0.325) cy=H
  w1 = rect m1 xspan=(x10 + L + 0.02, x11 + 0.035) yspan=(pt - WP + 0.61, pt - 0.16) net=n4
  w2 = rect m1 xspan=(x10 + L + 0.02, x14 + L + 0.47) yspan=(pt - WP + 0.655, pt - 0.205) net=n4
  w3 = rect m1 xspan=(x14 + L + 0.18, x14 + L + 0.47) yspan=(pt - WP + 0.61, pt - 0.16) net=n4
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l14
  port A2 in on=l17
  port A3 in on=l13
  port B1 in on=l16
  port X out on=l21
end
