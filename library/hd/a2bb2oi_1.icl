# a2bb2oi_1: lifted from sky130_fd_sc_hd__a2bb2oi_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a2bb2oi_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=A2_N s=n2 b=VPB
  device M1 nmos w=WN l=L d=n3 g=B1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=Y g=B2 s=n3 b=VNB
  device M3 pmos w=WP l=L d=Y g=n2 s=n4 b=VPB
  device M4 pmos w=WP l=L d=VPWR g=B1 s=n4 b=VPB
  device M5 pmos w=WP l=L d=n4 g=B2 s=VPWR b=VPB
  device M6 nmos w=WN l=L d=n2 g=A2_N s=VGND b=VNB
  device M7 nmos w=WN l=L d=VGND g=A1_N s=n2 b=VNB
  device M8 pmos w=WP l=L d=VPWR g=A1_N s=n1 b=VPB
  device M9 nmos w=WN l=L d=VGND g=n2 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  x4 = x3 + L + 0.88
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.205) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x4 - 0.345, x6 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x3 + L + 0.395, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5 - 0.065, x5 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6, x6 + L + 0.18) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l2 = rect li xspan=(x2 + L + 0.03, x4 - 0.235) yspan=(-0.085, nb + 0.255) net=VGND
  l3 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.305) yspan=(-0.085, nb + WN - 0.06) net=VGND
  l4 = rect li xspan=(x2 - 0.035, x3 + L + 0.28) yspan=(nb + WN + 0.125, pt - WP - 0.21) net=A2_N
  l5 = rect li xspan=(x1 - 0.25, x1 + L - 0.025) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A1_N
  l6 = rect li xspan=(x5 - 0.015, x6 - 0.07) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B2
  l7 = rect li xspan=(x5 + L + 0.04, x6 - 0.07) yspan=(nb + 0.19, pt - WP + 0.13) net=B2
  l8 = rect li xspan=(x6 + L - 0.045, x6 + L + 0.25) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B1
  l9 = rect li xspan=(x1 + L + 0.055, x2 + 0.01) yspan=(nb + 0.02, nb + WN - 0.055) net=n2
  l10 = rect li xspan=(x1 + L + 0.055, x4 - 0.26) yspan=(nb + WN - 0.225, nb + WN - 0.055) net=n2
  l11 = rect li xspan=(x2 + L - 0.03, x3 + L + 0.245) yspan=(pt - WP - 0.04, pt - 0.02) net=n2
  l12 = rect li xspan=(x2 + L - 0.03, x4 - 0.26) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=n2
  l13 = rect li xspan=(x4 - 0.43, x4 - 0.26) yspan=(nb + WN - 0.225, pt - WP + 0.13) net=n2
  l14 = rect li xspan=(x4 - 0.42, x4 - 0.055) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l15 = rect li xspan=(x4 - 0.065, x4 + L - 0.04) yspan=(nb + 0.02, pt - WP + 0.47) net=Y
  l16 = rect li xspan=(x4 - 0.065, x5 - 0.055) yspan=(nb + 0.02, nb + WN - 0.06) net=Y
  l17 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - 0.25, pt - 0.02) net=n4
  l18 = rect li xspan=(x4 + L + 0.135, x6 + L + 0.31) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n4
  l19 = rect li xspan=(x4 + L + 0.135, x5 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n4
  l20 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.31) yspan=(pt - WP + 0.3, pt - 0.02) net=n4
  l21 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(pt - 0.68, H + 0.085) net=VPWR
  l22 = rect li xspan=(x5 + L + 0.055, x6 + 0.03) yspan=(pt - 0.35, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085, nb + 0.255) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 - 0.4) span=(-0.085, nb + 0.255) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x6 + L + 0.14) span=(-0.085, nb + WN - 0.06) net=VGND
  c5 = array licon in=nd1 cx=(x2 - 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.055 - 0.08) margin=0.04 net=n2
  c6 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x3 + L + 0.08) span=(pt - WP - 0.04, pt - 0.02) net=n2
  c8 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n4
  c9 = array licon in=pd2 cx=(x4 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.68, H + 0.085) net=VPWR
  c11 = array licon in=pd2 cx=(x4 - 0.22) span=(pt - WP + 0.3, pt - 0.02) net=Y
  c12 = array licon in=pd2 cx=(x4 + L + 0.14) span=(pt - 0.25, pt - 0.02) margin=0.04 net=n4
  c13 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.35 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 - 0.345) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L/2) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.045) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.19) cy=0
  mc4 = contact mcon cx=(x4 - 0.23) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.09) cy=0
  mc6 = contact mcon cx=(x5 + L + 0.13) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.17) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x2 - 0.07) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.19) cy=H
  mc11 = contact mcon cx=(x4 - 0.23) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.09) cy=H
  mc13 = contact mcon cx=(x5 + L + 0.13) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1_N in on=l5
  port A2_N in on=l4
  port B1 in on=l8
  port B2 in on=l7
  port Y out on=l14
end
