# or2b_2: lifted from sky130_fd_sc_hd__or2b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or2b_2 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M1 nmos w=WN2 l=L d=n1 g=A s=VGND b=VNB
  device M2 nmos w=WN2 l=L d=n2 g=B_N s=VGND b=VNB
  device M3 pmos w=WP2 l=L d=n1 g=n2 s=n3 b=VPB
  device M4 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB
  device M5 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M6 pmos w=WP2 l=L d=VPWR g=B_N s=n2 b=VPB
  device M7 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 nmos w=WN2 l=L d=VGND g=n2 s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.755
  x3 = x2 + 0.06
  x4 = x3 + L + 0.22
  x5 = x4 + L + 0.35
  x6 = x5 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.315) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd2 = rect diff xspan=(x4 + L + 0.08, x6 + L + 0.315) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x2 - 0.205, x6 + L + 0.315) yspan=(pt - WP, pt - 0.58)
  pd3 = rect diff xspan=(x4 + L + 0.08, x6 + L + 0.315) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.295, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x2 - 0.215, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(nb - 0.1, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13)
  p6 = rect poly xspan=(x1 + L + 0.3, x2 - 0.125) yspan=(pt - 0.58 + 0.24, pt - 0.07)
  p7 = rect poly xspan=(x1 + L + 0.3, x4 + L) yspan=(pt - 0.22, pt - 0.07)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.1, pt - 0.07)
  p9 = rect poly xspan=(x5 - 0.135, x6 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p10 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.05, x2 + 0.03) yspan=(-0.085, nb + 0.03 + WN2 - 0.12) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x5 + 0.01) yspan=(-0.085, nb + 0.03 + 0.22) net=VGND
  l3 = rect li xspan=(x6 + L + 0.035, x6 + L + 0.29) yspan=(-0.085, nb + WN + 0.04) net=VGND
  l4 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=B_N
  l5 = rect li xspan=(x1 - 0.295, x1 + 0.025) yspan=(nb + 0.03, pt - WP - 0.58) net=n2
  l6 = rect li xspan=(x1 - 0.295, x1 + L + 0.3) yspan=(nb + 0.03 + WN2 + 0.05, pt - WP - 0.58) net=n2
  l7 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.225) yspan=(nb + 0.03 + WN2 + 0.05, pt - 0.58 - 0.02) net=n2
  l8 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.3) yspan=(nb + 0.03 + WN2 + 0.05, pt - WP - 0.16) net=n2
  l9 = rect li xspan=(x1 + L + 0.055, x3 - 0.02) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n2
  l10 = rect li xspan=(x2 - 0.31, x5 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l11 = rect li xspan=(x2 - 0.31, x2 + L - 0.035) yspan=(pt - WP + 0.01, pt - 0.58 + 0.01) net=n1
  l12 = rect li xspan=(x3 + L - 0.01, x4 - 0.055) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n1
  l13 = rect li xspan=(x3 + L - 0.01, x5 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, nb + WN - 0.06) net=n1
  l14 = rect li xspan=(x5 - 0.145, x5 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, pt - WP + 0.18) net=n1
  l15 = rect li xspan=(x5 - 0.145, x5 + L - 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l16 = rect li xspan=(x1 + L - 0.005, x4 + 0.02) yspan=(pt - 0.58 + 0.18, pt - 0.07) net=A
  l17 = rect li xspan=(x5 + L + 0.055, x6 + 0.01) yspan=(nb + 0.03 + 0.15, nb + 0.03 + WN2 + 0.075) net=X
  l18 = rect li xspan=(x5 + L + 0.055, x6 + 0.01) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l19 = rect li xspan=(x5 + L + 0.115, x6 + 0.01) yspan=(nb + 0.03 + 0.15, pt - 0.02) net=X
  l20 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l21 = rect li xspan=(x4 + L + 0.055, x5 - 0.015) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  l22 = rect li xspan=(x6 + L + 0.035, x6 + L + 0.29) yspan=(pt - WP - 0.025, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x6 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.04 - 0.08) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.03 + WN2 - 0.12 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 - 0.14) span=(-0.085, nb + 0.03 + WN2 - 0.12) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x5 - 0.16) span=(-0.085, nb + 0.03 + 0.22) net=VGND
  c5 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.08, pt - WP - 0.58 - 0.08) net=n2
  c6 = array licon in=nd1 cx=(x3 + L + 0.08) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c7 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.03 + 0.15 + 0.08, nb + 0.03 + WN2 + 0.075 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x1 + L + 0.14) span=(nb + 0.03 + WN2 + 0.05 + 0.08, pt - 0.58 - 0.02 - 0.08) net=n2
  c9 = array licon in=pd3 cx=(x6 + L + 0.14) span=(pt - WP - 0.025 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c11 = array licon in=pd2 cx=(x2 - 0.08) span=(pt - WP + 0.01, pt - 0.58 + 0.01) net=n1
  c12 = array licon in=pd3 cx=(x5 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c13 = array licon in=pd3 cx=(x5 - 0.145) span=(pt - 0.58 - 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 - 0.08) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 + 0.005) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x2 - 0.29) cy=(pt - 0.205)
  np1 = rect npc xspan=(x1 - 0.4, x6 + L + 0.455) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 + L + 0.075, x4 - 0.08) yspan=(pt - 0.58 + 0.13, pt + 0.01)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 - 0.145) cy=0
  mc4 = contact mcon cx=(x4 - 0.105) cy=0
  mc5 = contact mcon cx=(x5 - 0.135) cy=0
  mc6 = contact mcon cx=(x6 - 0.095) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.225) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 - 0.145) cy=H
  mc11 = contact mcon cx=(x4 - 0.105) cy=H
  mc12 = contact mcon cx=(x5 - 0.135) cy=H
  mc13 = contact mcon cx=(x6 - 0.095) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.225) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l16
  port B_N in on=l4
  port X out on=l18
end
