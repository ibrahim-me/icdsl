# o2111ai_1: lifted from sky130_fd_sc_hd__o2111ai_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell o2111ai_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=B1 s=n2 b=VNB
  device M1 nmos w=WN l=L d=n2 g=A2 s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=A1 s=n2 b=VNB
  device M3 nmos w=WN l=L d=Y g=D1 s=n3 b=VNB
  device M4 pmos w=WP l=L d=VPWR g=D1 s=Y b=VPB
  device M5 pmos w=WP l=L d=n4 g=A1 s=VPWR b=VPB
  device M6 pmos w=WP l=L d=VPWR g=B1 s=Y b=VPB
  device M7 pmos w=WP l=L d=Y g=A2 s=n4 b=VPB
  device M8 pmos w=WP l=L d=Y g=C1 s=VPWR b=VPB
  device M9 nmos w=WN l=L d=n3 g=C1 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.6
  x2 = x1 + 0.07
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.4
  x5 = x4 + L + 0.415
  x6 = x5 + L + 0.4
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.2, x6 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x6 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.115, x2 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x2) yspan=(nb + WN + 0.14, H - 0.105)
  p3 = rect poly xspan=(x2, x1 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.19)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4, x4 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.185) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x6, x6 + L + 0.31) yspan=(nb + WN + 0.13, pt - WP - 0.18)
  # local interconnect
  l1 = rect li xspan=(x5 + L + 0.02, x6 - 0.05) yspan=(-0.085, nb + 0.22) net=VGND
  l2 = rect li xspan=(x4 + L + 0.04, x5 - 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l3 = rect li xspan=(x4 + L + 0.04, x6 + L + 0.31) yspan=(nb + WN - 0.26, nb + WN - 0.06) net=n2
  l4 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.31) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l5 = rect li xspan=(x1 - 0.115, x2 + L) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=D1
  l6 = rect li xspan=(x3, x3 + L + 0.185) yspan=(nb + 0.02, pt - WP + 0.13) net=C1
  l7 = rect li xspan=(x4 - 0.045, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B1
  l8 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.31) yspan=(nb + WN + 0.12, pt - WP + 0.13) net=A1
  l9 = rect li xspan=(x5 - 0.14, x6 - 0.05) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A2
  l10 = rect li xspan=(x5 + L, x6 - 0.05) yspan=(nb + WN + 0.11, pt - 0.115) net=A2
  l11 = rect li xspan=(x1 - 0.515, x2 + 0.025) yspan=(nb + 0.02, nb + WN) net=Y
  l12 = rect li xspan=(x1 - 0.515, x1 - 0.285) yspan=(nb + 0.02, pt - 0.46) net=Y
  l13 = rect li xspan=(x1 - 0.515, x5 - 0.03) yspan=(pt - WP + 0.3, pt - 0.46) net=Y
  l14 = rect li xspan=(x2 + L - 0.025, x3) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l15 = rect li xspan=(x4 + L + 0.04, x5 - 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=Y
  l16 = rect li xspan=(x1 - 0.31, x1 + 0.025) yspan=(pt - 0.29, H + 0.085) net=VPWR
  l17 = rect li xspan=(x3 + L + 0.04, x4 - 0.03) yspan=(pt - 0.23, H + 0.085) net=VPWR
  l18 = rect li xspan=(x6 + L - 0.025, x6 + L + 0.31) yspan=(pt - 0.69, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x5 + L + 0.185) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 - 0.075) span=(nb + 0.02, nb + WN) net=Y
  c3 = array licon in=nd1 cx=(x5 - 0.195) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n2
  c4 = array licon in=nd1 cx=(x6 + L + 0.145) span=(nb + 0.02, nb + WN - 0.06) net=n2
  c5 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - 0.69, H + 0.085) net=VPWR
  c6 = array licon in=pd1 cx=(x2 + L + 0.075) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x5 - 0.195) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - 0.29, H + 0.085) net=VPWR
  c9 = array licon in=pd1 cx=(x4 - 0.195) span=(pt - 0.23, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 - 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.02) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.02) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 + L + 0.02) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x6 + L + 0.145) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.6, x6 + L + 0.415) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.37) cy=0
  mc2 = contact mcon cx=(x2 + 0.025) cy=0
  mc3 = contact mcon cx=(x3 + L - 0.025) cy=0
  mc4 = contact mcon cx=(x4 + 0.045) cy=0
  mc5 = contact mcon cx=(x5 - 0.055) cy=0
  mc6 = contact mcon cx=(x6 - 0.135) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.185) cy=0
  mc8 = contact mcon cx=(x1 - 0.37) cy=H
  mc9 = contact mcon cx=(x2 + 0.025) cy=H
  mc10 = contact mcon cx=(x3 + L - 0.025) cy=H
  mc11 = contact mcon cx=(x4 + 0.045) cy=H
  mc12 = contact mcon cx=(x5 - 0.055) cy=H
  mc13 = contact mcon cx=(x6 - 0.135) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.185) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l8
  port A2 in on=l9
  port B1 in on=l7
  port C1 in on=l6
  port D1 in on=l5
  port Y out on=l11
end
