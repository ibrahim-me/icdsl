# clkinv_4: lifted from sky130_fd_sc_hd__clkinv_4 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=1 L=0.15 H=2.72

stdcell clkinv_4 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M1 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M2 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M3 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M5 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M6 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M8 pmos w=WP l=L d=Y g=A s=VPWR b=VPB
  device M9 pmos w=WP l=L d=VPWR g=A s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.445
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 + L - 0.05, x6 + L - 0.035) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.31, x6 + L + 0.35) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x6 + L) yspan=(nb + WN + 0.37, pt - WP - 0.19)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.37, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.37, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.025, x2 - 0.015) yspan=(-0.085, nb + WN - 0.1) net=VGND
  l2 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(-0.085, nb + WN - 0.1) net=VGND
  l3 = rect li xspan=(x5 + L + 0.01, x6 + 0.025) yspan=(-0.085, nb + WN - 0.1) net=VGND
  l4 = rect li xspan=(x1 + 0.005, x6 + 0.07) yspan=(nb + WN + 0.41, pt - WP - 0.195) net=A
  l5 = rect li xspan=(x1 - 0.34, x6 + L + 0.4) yspan=(nb + WN + 0.07, nb + WN + 0.24) net=Y
  l6 = rect li xspan=(x1 - 0.34, x1 - 0.17) yspan=(nb + WN + 0.07, pt - WP + 0.145) net=Y
  l7 = rect li xspan=(x1 - 0.34, x6 + L + 0.4) yspan=(pt - WP - 0.025, pt - WP + 0.145) net=Y
  l8 = rect li xspan=(x1 + L + 0.02, x2 - 0.015) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l9 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(nb + 0.045, nb + WN + 0.24) net=Y
  l10 = rect li xspan=(x3 + L + 0.02, x4 - 0.015) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l11 = rect li xspan=(x4 + L + 0.015, x5 - 0.02) yspan=(nb + 0.045, nb + WN + 0.24) net=Y
  l12 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - WP - 0.025, pt - 0.05) net=Y
  l13 = rect li xspan=(x6 + L + 0.1, x6 + L + 0.4) yspan=(nb + WN + 0.07, pt - WP + 0.145) net=Y
  l14 = rect li xspan=(x1 - 0.36, x1 - 0.015) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l15 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l16 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.685, H + 0.085) net=VPWR
  l17 = rect li xspan=(x6 + L + 0.015, x6 + L + 0.4) yspan=(pt - 0.685, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x3 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x5 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.1 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x2 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.24 - 0.08) margin=0.04 net=Y
  c5 = array licon in=nd1 cx=(x4 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.24 - 0.08) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c7 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - WP - 0.025 + 0.08, pt - 0.05 - 0.08) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - 0.685 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.075) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L - 0.02) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + 0.04) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x4 - 0.055) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x4 + L + 0.145) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x5 + L + 0.055) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.445, x6 + L + 0.485) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.215) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.105) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.135) cy=0
  mc4 = contact mcon cx=(x4 - 0.125) cy=0
  mc5 = contact mcon cx=(x5 - 0.095) cy=0
  mc6 = contact mcon cx=(x6 - 0.065) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.255) cy=0
  mc8 = contact mcon cx=(x1 - 0.215) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.105) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.135) cy=H
  mc11 = contact mcon cx=(x4 - 0.125) cy=H
  mc12 = contact mcon cx=(x5 - 0.095) cy=H
  mc13 = contact mcon cx=(x6 - 0.065) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.255) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port Y out on=l5
end
