# or3_1: lifted from sky130_fd_sc_hd__or3_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell or3_1 width=6 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M1 pmos w=WP2 l=L d=n2 g=B s=n3 b=VPB
  device M2 pmos w=WP2 l=L d=n1 g=C s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M4 nmos w=WN2 l=L d=n1 g=C s=VGND b=VNB
  device M5 nmos w=WN2 l=L d=n1 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=VGND g=B s=n1 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.41
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.35
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.285) yspan=(nb + 0.03, nb + 0.03 + WN2)
  nd2 = rect diff xspan=(x4 + L + 0.08, x5 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.285) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x4 + L + 0.08, x5 + L + 0.285) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x4 - 0.08, x4 + L + 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x4, x4 + L) yspan=(nb - 0.1, pt - 0.58 + 0.13)
  p5 = rect poly xspan=(x2 - 0.035, x3 + L + 0.095) yspan=(pt - 0.58 + 0.24, pt - 0.07)
  p6 = rect poly xspan=(x2, x2 + L) yspan=(nb + 0.03 + WN2 + 0.075, pt - 0.07)
  p7 = rect poly xspan=(x3, x3 + L) yspan=(nb - 0.1, nb + WN + 0.025)
  p8 = rect poly xspan=(x5 - 0.09, x5 + L + 0.04) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.03 + 0.22) net=VGND
  l2 = rect li xspan=(x4 + L - 0.03, x5 + 0.01) yspan=(-0.085, nb + 0.03 + 0.22) net=VGND
  l3 = rect li xspan=(x1 - 0.325, x1 + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C
  l4 = rect li xspan=(x1 + L + 0.05, x4 + L + 0.035) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 + L + 0.05, x2 + 0.03) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=A
  l6 = rect li xspan=(x1 - 0.31, x1 - 0.055) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n1
  l7 = rect li xspan=(x1 - 0.31, x5 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, nb + WN - 0.06) net=n1
  l8 = rect li xspan=(x1 - 0.305, x1 + 0.025) yspan=(pt - WP + 0.01, pt - 0.58 + 0.05) net=n1
  l9 = rect li xspan=(x1 - 0.305, x4 + 0.03) yspan=(pt - 0.58 - 0.12, pt - 0.58 + 0.05) net=n1
  l10 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(nb + 0.03 + 0.04, nb + WN - 0.06) net=n1
  l11 = rect li xspan=(x3 + L + 0.135, x5 + 0.03) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n1
  l12 = rect li xspan=(x3 + L + 0.135, x4 + 0.03) yspan=(pt - WP + 0.01, pt - 0.58 + 0.05) net=n1
  l13 = rect li xspan=(x5 - 0.145, x5 + 0.03) yspan=(nb + 0.03 + WN2 - 0.03, pt - WP + 0.18) net=n1
  l14 = rect li xspan=(x5 - 0.145, x5 + L - 0.015) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l15 = rect li xspan=(x1 - 0.325, x4 + 0.03) yspan=(pt - 0.58 + 0.22, pt - 0.07) net=B
  l16 = rect li xspan=(x5 + L + 0.055, x5 + L + 0.33) yspan=(nb + 0.03 + 0.15, nb + 0.03 + WN2 + 0.075) net=X
  l17 = rect li xspan=(x5 + L + 0.055, x5 + L + 0.33) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l18 = rect li xspan=(x5 + L + 0.16, x5 + L + 0.33) yspan=(nb + 0.03 + 0.15, pt - 0.02) net=X
  l19 = rect li xspan=(x4 + L + 0.055, x5 - 0.015) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 - 0.08) span=(-0.085, nb + 0.03 + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd2 cx=(x5 - 0.16) span=(-0.085, nb + 0.03 + 0.22) net=VGND
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) net=n1
  c4 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.03 + 0.04 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c5 = array licon in=nd2 cx=(x5 + L + 0.14) span=(nb + 0.03 + 0.15 + 0.08, nb + 0.03 + WN2 + 0.075 - 0.08) margin=0.04 net=X
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 + 0.05 - 0.08) net=n1
  c7 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd2 cx=(x5 - 0.145) span=(pt - 0.58 - 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.155) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + 0.06) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 + 0.05) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x2 + L - 0.015) cy=(pt - 0.205)
  np1 = rect npc xspan=(x1 - 0.41, x5 + L + 0.42) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 - 0.03, x4 + L - 0.055) yspan=(pt - 0.58 + 0.13, pt + 0.01)
  # metal
  mc1 = contact mcon cx=(x1 - 0.18) cy=0
  mc2 = contact mcon cx=(x2 - 0.08) cy=0
  mc3 = contact mcon cx=(x4 - 0.1) cy=0
  mc4 = contact mcon cx=(x5 - 0.13) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.19) cy=0
  mc6 = contact mcon cx=(x1 - 0.18) cy=H
  mc7 = contact mcon cx=(x2 - 0.08) cy=H
  mc8 = contact mcon cx=(x4 - 0.1) cy=H
  mc9 = contact mcon cx=(x5 - 0.13) cy=H
  mc10 = contact mcon cx=(x5 + L + 0.19) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l15
  port C in on=l3
  port X out on=l17
end
