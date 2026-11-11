# and4_1: lifted from sky130_fd_sc_hd__and4_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and4_1 width=9 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=C s=n2 b=VNB
  device M1 nmos w=WN2 l=L d=n2 g=D s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M3 pmos w=WP2 l=L d=n3 g=D s=VPWR b=VPB
  device M4 pmos w=WP2 l=L d=VPWR g=C s=n3 b=VPB
  device M5 nmos w=WN2 l=L d=n4 g=B s=n1 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M7 pmos w=WP2 l=L d=VPWR g=A s=n3 b=VPB
  device M8 pmos w=WP2 l=L d=n3 g=B s=VPWR b=VPB
  device M9 nmos w=WN2 l=L d=n3 g=A s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.3
  x3 = x2 + 0.06
  x4 = x3 + L + 0.33
  x5 = x4 + 0.05
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.69
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x6 + L + 0.22, x7 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x6 + L + 0.1, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x3 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x5 + L + 0.075) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.175) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7 - 0.28, x7 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x7 - 0.325, x7 - 0.055) yspan=(-0.085, nb + WN) net=VGND
  l2 = rect li xspan=(x3 - 0.01, x4 - 0.135) yspan=(nb + 0.125, pt - WP - 0.16) net=B
  l3 = rect li xspan=(x5, x6 - 0.135) yspan=(nb + 0.12, pt - WP - 0.16) net=C
  l4 = rect li xspan=(x6 + 0.05, x6 + L + 0.185) yspan=(nb + 0.12, pt - WP - 0.16) net=D
  l5 = rect li xspan=(x1 - 0.315, x1 - 0.075) yspan=(nb + WN2 + 0.11, pt - WP2 + 0.01) net=A
  l6 = rect li xspan=(x1 - 0.23, x1 + L + 0.125) yspan=(nb + 0.02, nb + WN2 - 0.07) net=n3
  l7 = rect li xspan=(x1 + L - 0.05, x1 + L + 0.125) yspan=(nb + 0.02, pt - WP + 0.18) net=n3
  l8 = rect li xspan=(x1 + L - 0.05, x7 + 0.01) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l9 = rect li xspan=(x1 + L + 0.055, x2 + 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l10 = rect li xspan=(x5 + L + 0.02, x6 - 0.02) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l11 = rect li xspan=(x7 - 0.31, x7 + 0.01) yspan=(nb + WN + 0.19, pt - WP + 0.18) net=n3
  l12 = rect li xspan=(x7 - 0.31, x7 + 0.025) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n3
  l13 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.315) yspan=(nb + 0.06, nb + WN - 0.08) net=X
  l14 = rect li xspan=(x7 + L - 0.03, x7 + L + 0.315) yspan=(pt - WP2 + 0.14, pt - 0.02) net=X
  l15 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.315) yspan=(nb + 0.06, pt - 0.02) net=X
  l16 = rect li xspan=(x1 - 0.31, x1 + 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l17 = rect li xspan=(x3 + L + 0.025, x5 - 0.02) yspan=(pt - WP2 - 0.15, H + 0.085) net=VPWR
  l18 = rect li xspan=(x6 + L + 0.305, x7 - 0.055) yspan=(pt - WP2 - 0.23, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x7 - 0.215) span=(-0.085 + 0.08, nb + WN - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.06 + 0.08, pt - 0.02 - 0.08) net=X
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN2 - 0.07 - 0.08) net=n3
  c4 = array licon in=pd2 cx=(x7 + L + 0.14) span=(nb + 0.06 + 0.08, pt - 0.02 - 0.08) net=X
  c5 = array licon in=pd2 cx=(x7 - 0.22) span=(pt - WP2 - 0.23, H + 0.085) margin=0.04 net=VPWR
  c6 = array licon in=pd1 cx=(x2 - 0.12) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c7 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n3
  c8 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.23, H + 0.085) net=VPWR
  c9 = array licon in=pd1 cx=(x4 - 0.14) span=(pt - WP2 - 0.15, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 - 0.16) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L - 0.015) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L - 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L - 0.015) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x7 - 0.145) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.11) cy=0
  mc4 = contact mcon cx=(x5 + L + 0.05) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.08) cy=0
  mc6 = contact mcon cx=(x7 - 0.15) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.17) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.11) cy=H
  mc11 = contact mcon cx=(x5 + L + 0.05) cy=H
  mc12 = contact mcon cx=(x6 + L + 0.08) cy=H
  mc13 = contact mcon cx=(x7 - 0.15) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l5
  port B in on=l2
  port C in on=l3
  port D in on=l4
  port X out on=l14
end
