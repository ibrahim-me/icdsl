# o31a_2: lifted from sky130_fd_sc_hd__o31a_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o31a_2 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A3 s=n2 b=VPB
  device M1 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M2 pmos w=WP l=L d=n2 g=B1 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=VGND g=A1 s=n3 b=VNB
  device M4 nmos w=WN l=L d=n3 g=B1 s=n2 b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M7 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M8 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M9 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M10 nmos w=WN l=L d=n3 g=A2 s=VGND b=VNB
  device M11 pmos w=WP l=L d=n4 g=A2 s=n1 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.545
  x2 = x1 + L + 0.36
  x3 = x2 + L + 0.4
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.34
  x6 = x5 + L + 0.34
  x7 = x6 + 0.095
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.41, x7 + L + 0.22) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.41, x7 + L + 0.345) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3 - 0.125, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.065, x5 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6 - 0.065, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l2 = rect li xspan=(x3 + L + 0.055, x6 - 0.025) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n3
  l3 = rect li xspan=(x5 + L + 0.085, x6 - 0.025) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l4 = rect li xspan=(x1 - 0.46, x1 - 0.165) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l5 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l6 = rect li xspan=(x4 + L - 0.03, x5 + 0.06) yspan=(-0.085, nb + 0.25) net=VGND
  l7 = rect li xspan=(x2 + L + 0.185, x3 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.21) net=A1
  l8 = rect li xspan=(x6 - 0.11, x7 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l9 = rect li xspan=(x4 - 0.06, x4 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l10 = rect li xspan=(x4 - 0.015, x4 + L + 0.045) yspan=(nb + WN + 0.11, pt - WP + 0.64) net=A2
  l11 = rect li xspan=(x5 - 0.095, x5 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP + 0.64) net=A3
  l12 = rect li xspan=(x1 - 0.46, x1 + L + 0.175) yspan=(nb + WN + 0.19, nb + WN + 0.41) net=X
  l13 = rect li xspan=(x1 + 0.01, x1 + L + 0.175) yspan=(nb + 0.03, pt - 0.02) net=X
  l14 = rect li xspan=(x1 + 0.01, x2 - 0.055) yspan=(nb + 0.03, nb + WN - 0.06) net=X
  l15 = rect li xspan=(x1 + 0.01, x2 - 0.055) yspan=(pt - 0.65, pt - 0.02) net=X
  l16 = rect li xspan=(x2 - 0.015, x2 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=n2
  l17 = rect li xspan=(x2 - 0.015, x3 + L + 0.095) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n2
  l18 = rect li xspan=(x3 + 0.07, x3 + L + 0.095) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l19 = rect li xspan=(x3 + 0.07, x7 + 0.025) yspan=(pt - 0.19, pt - 0.02) net=n2
  l20 = rect li xspan=(x6 - 0.135, x7 + 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=n2
  l21 = rect li xspan=(x6 - 0.135, x7 + L + 0.395) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l22 = rect li xspan=(x6 + L, x7 + L + 0.395) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l23 = rect li xspan=(x7 + L + 0.225, x7 + L + 0.395) yspan=(nb + 0.02, pt - WP + 0.18) net=n2
  l24 = rect li xspan=(x1 - 0.46, x1 - 0.165) yspan=(pt - WP - 0.02, H + 0.085) net=VPWR
  l25 = rect li xspan=(x2 + L - 0.025, x3 - 0.105) yspan=(pt - 0.7, H + 0.085) net=VPWR
  l26 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.39) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.03, nb + WN - 0.06) margin=0.04 net=X
  c2 = array licon in=nd1 cx=(x2 + L + 0.2) span=(-0.085, nb + WN - 0.06) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.17) span=(-0.085, nb + 0.25) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x7 + L + 0.075) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n2
  c5 = array licon in=nd1 cx=(x1 - 0.285) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd1 cx=(x5 + L + 0.17) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n3
  c8 = array licon in=pd1 cx=(x1 - 0.285) span=(pt - WP - 0.02 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x6 - 0.05) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c10 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - 0.65, pt - 0.02) margin=0.04 net=X
  c11 = array licon in=pd1 cx=(x2 + L + 0.2) span=(pt - 0.7 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x7 + L + 0.22) span=(pt - 0.65, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x2 + L/2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.545, x7 + L + 0.48) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.315) cy=0
  mc2 = contact mcon cx=(x1 + L) cy=0
  mc3 = contact mcon cx=(x2 + L - 0.04) cy=0
  mc4 = contact mcon cx=(x3 + 0.03) cy=0
  mc5 = contact mcon cx=(x4 + 0.07) cy=0
  mc6 = contact mcon cx=(x5 + 0.05) cy=0
  mc7 = contact mcon cx=(x6 + 0.03) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.25) cy=0
  mc9 = contact mcon cx=(x1 - 0.315) cy=H
  mc10 = contact mcon cx=(x1 + L) cy=H
  mc11 = contact mcon cx=(x2 + L - 0.04) cy=H
  mc12 = contact mcon cx=(x3 + 0.03) cy=H
  mc13 = contact mcon cx=(x4 + 0.07) cy=H
  mc14 = contact mcon cx=(x5 + 0.05) cy=H
  mc15 = contact mcon cx=(x6 + 0.03) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.25) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l7
  port A2 in on=l9
  port A3 in on=l11
  port B1 in on=l8
  port X out on=l13
end
