# nand2_2: lifted from sky130_fd_sc_hd__nand2_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell nand2_2 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=Y g=A s=n1 b=VNB
  device M1 nmos w=WN l=L d=n1 g=A s=Y b=VNB
  device M2 nmos w=WN l=L d=VGND g=B s=n1 b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A s=Y b=VPB
  device M4 nmos w=WN l=L d=n1 g=B s=VGND b=VNB
  device M5 pmos w=WP l=L d=VPWR g=B s=Y b=VPB
  device M6 pmos w=WP l=L d=Y g=B s=VPWR b=VPB
  device M7 pmos w=WP l=L d=Y g=A s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(-0.085, nb + 0.31) net=VGND
  l2 = rect li xspan=(x1 - 0.315, x1 + 0.03) yspan=(nb + 0.02, nb + WN) net=n1
  l3 = rect li xspan=(x1 - 0.315, x3 - 0.055) yspan=(nb + WN - 0.17, nb + WN) net=n1
  l4 = rect li xspan=(x2 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + 0.23) net=n1
  l5 = rect li xspan=(x2 + L - 0.03, x3 - 0.055) yspan=(nb + 0.02, nb + WN) net=n1
  l6 = rect li xspan=(x4 + L - 0.03, x4 + L + 0.305) yspan=(nb + 0.02, nb + 0.25) net=n1
  l7 = rect li xspan=(x1 - 0.315, x2 + 0.03) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=B
  l8 = rect li xspan=(x2 + L + 0.055, x4 + L - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.16) net=A
  l9 = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l10 = rect li xspan=(x1 + L - 0.03, x4 + L + 0.415) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=Y
  l11 = rect li xspan=(x3 + L - 0.03, x4 + L + 0.415) yspan=(nb + WN - 0.23, nb + WN + 0.02) net=Y
  l12 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=Y
  l13 = rect li xspan=(x4 + L + 0.135, x4 + L + 0.415) yspan=(nb + WN - 0.23, pt - WP + 0.18) net=Y
  l14 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  l15 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.65, H + 0.085) net=VPWR
  l16 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.31) yspan=(pt - 0.65, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02, nb + WN) net=n1
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(-0.085 + 0.08, nb + 0.31 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) margin=0.04 net=n1
  c4 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + 0.25) net=n1
  c5 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + WN - 0.23, nb + WN + 0.02) margin=0.04 net=Y
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c8 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.65 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.4, x4 + L + 0.5) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.13) cy=0
  mc3 = contact mcon cx=(x3 - 0.09) cy=0
  mc4 = contact mcon cx=(x4 - 0.05) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.27) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x2 - 0.13) cy=H
  mc8 = contact mcon cx=(x3 - 0.09) cy=H
  mc9 = contact mcon cx=(x4 - 0.05) cy=H
  mc10 = contact mcon cx=(x4 + L + 0.27) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l8
  port B in on=l7
  port Y out on=l11
end
