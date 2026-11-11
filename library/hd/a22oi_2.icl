# a22oi_2: lifted from sky130_fd_sc_hd__a22oi_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a22oi_2 width=12 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  device M2 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=B1 s=n3 b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n2 b=VPB
  device M5 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n3 g=B1 s=Y b=VNB
  device M7 nmos w=WN l=L d=n1 g=A1 s=Y b=VNB
  device M8 nmos w=WN l=L d=VGND g=B2 s=n3 b=VNB
  device M9 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M10 pmos w=WP l=L d=n2 g=A2 s=VPWR b=VPB
  device M11 nmos w=WN l=L d=n3 g=B2 s=VGND b=VNB
  device M12 pmos w=WP l=L d=Y g=B2 s=n2 b=VPB
  device M13 pmos w=WP l=L d=n2 g=B2 s=Y b=VPB
  device M14 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M15 pmos w=WP l=L d=n2 g=B1 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.8
  x6 = x5 + L + 0.28
  x7 = x6 + L + 0.28
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 - 0.265, x8 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.265, x8 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5 - 0.125, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x7, x8 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(-0.085, nb + 0.275) net=VGND
  l2 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(-0.085, nb + 0.275) net=VGND
  l3 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(nb + 0.02, nb + WN - 0.035) net=n3
  l4 = rect li xspan=(x1 - 0.305, x3 - 0.055) yspan=(nb + WN - 0.205, nb + WN - 0.035) net=n3
  l5 = rect li xspan=(x2 + L + 0.055, x4 + L + 0.305) yspan=(nb + 0.02, nb + 0.27) net=n3
  l6 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(nb + 0.02, nb + WN - 0.035) net=n3
  l7 = rect li xspan=(x5 - 0.305, x7 - 0.055) yspan=(nb + 0.02, nb + 0.27) net=n1
  l8 = rect li xspan=(x6 + L + 0.055, x7 - 0.055) yspan=(nb + 0.02, nb + WN - 0.035) net=n1
  l9 = rect li xspan=(x6 + L + 0.055, x8 + L + 0.375) yspan=(nb + WN - 0.205, nb + WN - 0.035) net=n1
  l10 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.375) yspan=(nb + 0.02, nb + WN - 0.035) net=n1
  l11 = rect li xspan=(x1 - 0.25, x2 - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B2
  l12 = rect li xspan=(x2 + L + 0.11, x4 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=B1
  l13 = rect li xspan=(x5 - 0.155, x6 + L - 0.065) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A1
  l14 = rect li xspan=(x7 - 0.05, x8 + L + 0.5) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A2
  l15 = rect li xspan=(x1 - 0.305, x4 + L + 0.36) yspan=(pt - WP, pt - WP + 0.17) net=Y
  l16 = rect li xspan=(x1 - 0.305, x1 - 0.055) yspan=(pt - WP, pt - 0.02) net=Y
  l17 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - WP + 0.64) net=Y
  l18 = rect li xspan=(x3 + L - 0.03, x6 + 0.03) yspan=(nb + 0.44, nb + WN - 0.04) net=Y
  l19 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.36) yspan=(pt - WP, pt - WP + 0.64) net=Y
  l20 = rect li xspan=(x4 + L + 0.07, x4 + L + 0.36) yspan=(nb + 0.44, pt - WP + 0.64) net=Y
  l21 = rect li xspan=(x1 + L - 0.03, x2 - 0.055) yspan=(pt - WP + 0.34, pt - 0.02) net=n2
  l22 = rect li xspan=(x1 + L - 0.03, x5 + 0.03) yspan=(pt - 0.19, pt - 0.02) net=n2
  l23 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(pt - WP + 0.34, pt - 0.02) net=n2
  l24 = rect li xspan=(x5 - 0.225, x8 + L + 0.305) yspan=(pt - WP, pt - WP + 0.17) net=n2
  l25 = rect li xspan=(x5 - 0.225, x5 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l26 = rect li xspan=(x6 + L - 0.03, x7 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  l27 = rect li xspan=(x8 + L - 0.03, x8 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=n2
  l28 = rect li xspan=(x5 + L + 0.055, x6 - 0.055) yspan=(pt - 0.66, H + 0.085) net=VPWR
  l29 = rect li xspan=(x7 + L + 0.055, x8 - 0.055) yspan=(pt - 0.66, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085, nb + 0.275) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x7 + L + 0.14) span=(-0.085, nb + 0.275) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.27) net=n3
  c4 = array licon in=nd2 cx=(x5 - 0.14) span=(nb + 0.02, nb + 0.27) net=n1
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.035 - 0.08) net=n3
  c6 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.035 - 0.08) margin=0.04 net=n3
  c7 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.035 - 0.08) margin=0.04 net=n1
  c8 = array licon in=nd2 cx=(x8 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.035 - 0.08) net=n1
  c9 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.44, nb + WN - 0.04) margin=0.04 net=Y
  c10 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.44, nb + WN - 0.04) margin=0.04 net=Y
  c11 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP, pt - WP + 0.64) margin=0.04 net=Y
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP, pt - WP + 0.64) net=Y
  c13 = array licon in=pd2 cx=(x5 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n2
  c14 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP, pt - 0.02) margin=0.04 net=n2
  c15 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP, pt - 0.02) net=n2
  c16 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  c17 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.34 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c18 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.34 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n2
  c19 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.66 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - 0.66 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x8 + L + 0.6) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.27) cy=0
  mc6 = contact mcon cx=(x5 - 0.07) cy=0
  mc7 = contact mcon cx=(x6 - 0.03) cy=0
  mc8 = contact mcon cx=(x7 + 0.015) cy=0
  mc9 = contact mcon cx=(x8 + 0.055) cy=0
  mc10 = contact mcon cx=(x8 + L + 0.37) cy=0
  mc11 = contact mcon cx=(x1 - 0.17) cy=H
  mc12 = contact mcon cx=(x2 - 0.13) cy=H
  mc13 = contact mcon cx=(x3 - 0.09) cy=H
  mc14 = contact mcon cx=(x4 - 0.05) cy=H
  mc15 = contact mcon cx=(x4 + L + 0.27) cy=H
  mc16 = contact mcon cx=(x5 - 0.07) cy=H
  mc17 = contact mcon cx=(x6 - 0.03) cy=H
  mc18 = contact mcon cx=(x7 + 0.015) cy=H
  mc19 = contact mcon cx=(x8 + 0.055) cy=H
  mc20 = contact mcon cx=(x8 + L + 0.37) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l13
  port A2 in on=l14
  port B1 in on=l12
  port B2 in on=l11
  port Y out on=l20
end
