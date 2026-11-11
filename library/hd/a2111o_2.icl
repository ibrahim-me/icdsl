# a2111o_2: lifted from sky130_fd_sc_hd__a2111o_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2111o_2 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A1 s=n2 b=VNB
  device M1 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M2 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=VGND g=D1 s=n1 b=VNB
  device M4 nmos w=WN l=L d=n1 g=C1 s=VGND b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M6 nmos w=WN l=L d=VGND g=B1 s=n1 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A2 s=n3 b=VPB
  device M8 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=n3 g=A1 s=VPWR b=VPB
  device M10 pmos w=WP l=L d=n4 g=B1 s=n3 b=VPB
  device M11 pmos w=WP l=L d=n1 g=D1 s=n5 b=VPB
  device M12 pmos w=WP l=L d=n5 g=C1 s=n4 b=VPB
  device M13 nmos w=WN l=L d=X g=n1 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.435
  x2 = x1 + 0.08
  x3 = x2 + L + 0.21
  x4 = x3 + 0.08
  x5 = x4 + L + 0.905
  x6 = x5 + L + 0.22
  x7 = x6 + 0.07
  x8 = x7 + L + 0.33
  x9 = x8 + 0.055
  x10 = x9 + L + 0.345
  x11 = x10 + L + 0.4
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.21, x11 + L + 0.345) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x4 + L + 0.19) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.415, x11 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.29, H - 0.105)
  p2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x4 + L + 0.33) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x5 - 0.185, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x7 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p11 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p12 = rect poly xspan=(x8, x9 + L + 0.13) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p13 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  p14 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  p15 = rect poly xspan=(x10, x10 + L + 0.185) yspan=(nb + WN + 0.095, pt - WP - 0.16)
  p16 = rect poly xspan=(x11, x11 + L) yspan=(0.105, H - 0.105)
  p17 = rect poly xspan=(x11, x11 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.35, x1 + 0.005) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x4 + L - 0.025, x5 + 0.025) yspan=(-0.085, nb + 0.21) net=VGND
  l3 = rect li xspan=(x4 + L - 0.025, x4 + L + 0.24) yspan=(-0.085, nb + WN - 0.02) net=VGND
  l4 = rect li xspan=(x7 + L + 0.03, x9 - 0.02) yspan=(-0.085, nb + 0.21) net=VGND
  l5 = rect li xspan=(x11 + L + 0.055, x11 + L + 0.405) yspan=(-0.085, nb + WN - 0.08) net=VGND
  l6 = rect li xspan=(x8 + 0.02, x9 + L + 0.11) yspan=(nb + WN + 0.11, pt - WP + 0.255) net=B1
  l7 = rect li xspan=(x10 - 0.065, x11 - 0.195) yspan=(nb + WN + 0.07, pt - WP + 0.255) net=A1
  l8 = rect li xspan=(x10 + L - 0.07, x11 - 0.195) yspan=(nb + 0.055, pt - WP + 0.255) net=A1
  l9 = rect li xspan=(x10 + L - 0.07, x11 + 0.03) yspan=(nb + 0.055, nb + 0.59) net=A1
  l10 = rect li xspan=(x11 - 0.025, x11 + L + 0.405) yspan=(nb + WN + 0.11, pt - WP + 0.255) net=A2
  l11 = rect li xspan=(x5 - 0.105, x6 - 0.095) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=D1
  l12 = rect li xspan=(x5 - 0.03, x6 - 0.095) yspan=(nb + WN + 0.11, pt - 0.13) net=D1
  l13 = rect li xspan=(x7 + 0.01, x8 - 0.155) yspan=(nb + WN + 0.11, pt - 0.13) net=C1
  l14 = rect li xspan=(x1 + L + 0.025, x3 + 0.035) yspan=(nb + 0.02, pt - 0.095) net=X
  l15 = rect li xspan=(x4 + L - 0.025, x5 - 0.285) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n1
  l16 = rect li xspan=(x4 + L + 0.41, x5 - 0.285) yspan=(nb + 0.38, pt - 0.02) net=n1
  l17 = rect li xspan=(x4 + L + 0.41, x10 - 0.095) yspan=(nb + 0.38, nb + WN - 0.1) net=n1
  l18 = rect li xspan=(x4 + L + 0.41, x5 - 0.205) yspan=(pt - WP + 0.01, pt - 0.02) net=n1
  l19 = rect li xspan=(x5 + L + 0.05, x7 + 0.005) yspan=(nb + 0.02, nb + WN - 0.1) net=n1
  l20 = rect li xspan=(x9 + L, x10 - 0.095) yspan=(nb + 0.02, nb + WN - 0.1) net=n1
  l21 = rect li xspan=(x9 + L - 0.02, x11 + L + 0.405) yspan=(pt - WP + 0.43, pt - WP + 0.6) net=n3
  l22 = rect li xspan=(x9 + L - 0.02, x10 - 0.03) yspan=(pt - WP + 0.43, pt - 0.02) net=n3
  l23 = rect li xspan=(x11 + L - 0.025, x11 + L + 0.405) yspan=(pt - WP + 0.43, pt - 0.02) net=n3
  l24 = rect li xspan=(x1 - 0.35, x1 + 0.005) yspan=(pt - WP + 0.15, H + 0.085) net=VPWR
  l25 = rect li xspan=(x4 + L - 0.025, x4 + L + 0.23) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l26 = rect li xspan=(x10 + L + 0.02, x11 - 0.05) yspan=(pt - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x4 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.02 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x5 - 0.145) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x8 - 0.135) span=(-0.085, nb + 0.21) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.085) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  c5 = array licon in=nd1 cx=(x11 + L + 0.22) span=(-0.085, nb + WN - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x3 - 0.065) span=(nb + 0.02 + 0.08, pt - 0.095 - 0.08) margin=0.04 net=X
  c7 = array licon in=nd1 cx=(x6 - 0.075) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n1
  c8 = array licon in=nd1 cx=(x9 + L + 0.145) span=(nb + 0.02 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=n1
  c9 = array licon in=pd1 cx=(x4 + L + 0.065) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c10 = array licon in=pd2 cx=(x5 - 0.29) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  c11 = array licon in=pd1 cx=(x2 + L + 0.065) span=(nb + 0.02 + 0.08, pt - 0.095 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.15 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd2 cx=(x9 + L + 0.15) span=(pt - WP + 0.43, pt - 0.02) margin=0.04 net=n3
  c14 = array licon in=pd2 cx=(x11 + L + 0.145) span=(pt - WP + 0.43, pt - 0.02) net=n3
  c15 = array licon in=pd2 cx=(x10 + L + 0.185) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x4 + L + 0.165) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x5 - 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x8 + L + 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x10 + L + 0.02) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x11 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.435, x11 + L + 0.49) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.205) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.035) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.065) cy=0
  mc4 = contact mcon cx=(x5 - 0.38) cy=0
  mc5 = contact mcon cx=(x5 + L - 0.065) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.035) cy=0
  mc7 = contact mcon cx=(x8 + L - 0.045) cy=0
  mc8 = contact mcon cx=(x10 + 0.025) cy=0
  mc9 = contact mcon cx=(x11 - 0.06) cy=0
  mc10 = contact mcon cx=(x11 + L + 0.26) cy=0
  mc11 = contact mcon cx=(x1 - 0.205) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.035) cy=H
  mc13 = contact mcon cx=(x4 + L + 0.065) cy=H
  mc14 = contact mcon cx=(x5 - 0.38) cy=H
  mc15 = contact mcon cx=(x5 + L - 0.065) cy=H
  mc16 = contact mcon cx=(x6 + L + 0.035) cy=H
  mc17 = contact mcon cx=(x8 + L - 0.045) cy=H
  mc18 = contact mcon cx=(x10 + 0.025) cy=H
  mc19 = contact mcon cx=(x11 - 0.06) cy=H
  mc20 = contact mcon cx=(x11 + L + 0.26) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l10
  port B1 in on=l6
  port C1 in on=l13
  port D1 in on=l12
  port X out on=l14
end
