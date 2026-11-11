# nand2b_1: lifted from sky130_fd_sc_hd__nand2b_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nand2b_1 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=n2 s=Y b=VNB
  device M1 nmos w=WN2 l=L d=n2 g=A_N s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=B s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M4 pmos w=WP2 l=L d=n2 g=A_N s=VPWR b=VPB
  device M5 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.345
  x3 = x2 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(nb + 0.23, nb + WN)
  nd2 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.27) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x1 + L + 0.08, x3 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.1, pt - 0.58 + 0.13)
  p3 = rect poly xspan=(x2 - 0.13, x2 + L + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.04, x2 + 0.03) yspan=(-0.085, nb + 0.23 + 0.08) net=VGND
  l2 = rect li xspan=(x1 - 0.31, x1 + 0.045) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A_N
  l3 = rect li xspan=(x1 + L + 0.07, x2 + L + 0.06) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=B
  l4 = rect li xspan=(x1 - 0.31, x1 - 0.04) yspan=(nb + 0.23 + 0.06, nb + WN + 0.02) net=n2
  l5 = rect li xspan=(x1 - 0.31, x3 + L - 0.025) yspan=(nb + WN - 0.15, nb + WN + 0.02) net=n2
  l6 = rect li xspan=(x1 - 0.31, x3 + L - 0.025) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n2
  l7 = rect li xspan=(x1 - 0.31, x1 - 0.03) yspan=(pt - WP + 0.01, pt - 0.58 - 0.08) net=n2
  l8 = rect li xspan=(x3 - 0.05, x3 + L - 0.025) yspan=(nb + WN - 0.15, pt - WP + 0.18) net=n2
  l9 = rect li xspan=(x3 - 0.05, x3 + L + 0.185) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=n2
  l10 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.58 - 0.07, pt - 0.02) net=Y
  l11 = rect li xspan=(x2 + L - 0.03, x3 + L + 0.725) yspan=(pt - 0.58 - 0.07, pt - 0.58 + 0.1) net=Y
  l12 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.725) yspan=(nb + 0.02, nb + 0.23 + 0.08) net=Y
  l13 = rect li xspan=(x3 + L + 0.355, x3 + L + 0.725) yspan=(nb + 0.02, pt - 0.58 + 0.1) net=Y
  l14 = rect li xspan=(x1 + L + 0.04, x2 - 0.055) yspan=(pt - 0.58 - 0.07, H + 0.085) net=VPWR
  l15 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.27) yspan=(pt - 0.58 + 0.27, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x2 - 0.14) span=(-0.085, nb + 0.23 + 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + 0.23 + 0.08) net=Y
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.23 + 0.06 + 0.08, nb + WN + 0.02 - 0.08) net=n2
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.58 - 0.08 - 0.08) net=n2
  c5 = array licon in=pd2 cx=(x2 - 0.14) span=(pt - 0.58 - 0.07 + 0.08, H + 0.085 - 0.08) net=VPWR
  c6 = array licon in=pd2 cx=(x2 + L + 0.14) span=(pt - 0.58 - 0.07, pt - 0.02) margin=0.04 net=Y
  c7 = array licon in=pd2 cx=(x3 + L + 0.14) span=(pt - 0.58 + 0.27 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.125) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + 0.04) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x3 + L + 0.855) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.125) cy=0
  mc4 = contact mcon cx=(x3 + L + 0.165) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.625) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc8 = contact mcon cx=(x2 + L + 0.125) cy=H
  mc9 = contact mcon cx=(x3 + L + 0.165) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.625) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l2
  port B in on=l3
  port Y out on=l11
end
