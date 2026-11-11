# nor2b_1: lifted from sky130_fd_sc_hd__nor2b_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell nor2b_1 width=6 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=B_N s=VPWR b=VPB
  device M1 nmos w=WN l=L d=Y g=n1 s=VGND b=VNB
  device M2 nmos w=WN l=L d=VGND g=A s=Y b=VNB
  device M3 nmos w=WN2 l=L d=n1 g=B_N s=VGND b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A s=n2 b=VPB
  device M5 pmos w=WP l=L d=n2 g=n1 s=Y b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.635
  x2 = x1 + 0.005
  x3 = x2 + L + 0.34
  x4 = x3 + 0.06
  x5 = x4 + L + 0.22
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.075, x5 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.26, x5 + L + 0.265) yspan=(pt - WP, pt - 0.58)
  pd2 = rect diff xspan=(x2 + L + 0.135, x5 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.53, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - WP - 0.16)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN + 0.11, pt - 0.58 + 0.13)
  p4 = rect poly xspan=(x3 - 0.125, x4 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x5, x5 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.075, x3 - 0.055) yspan=(-0.085, nb + WN + 0.01) net=VGND
  l2 = rect li xspan=(x5 + L + 0.055, x5 + L + 0.44) yspan=(-0.085, nb + WN2 - 0.1) net=VGND
  l3 = rect li xspan=(x1 - 0.535, x1 - 0.31) yspan=(nb + WN2 + 0.07, pt - WP - 0.16) net=B_N
  l4 = rect li xspan=(x3 - 0.16, x4 + L) yspan=(nb + WN + 0.18, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x1 - 0.305, x2 + 0.04) yspan=(nb + 0.135, nb + WN2 - 0.11) net=n1
  l6 = rect li xspan=(x1 - 0.22, x5 + L + 0.025) yspan=(pt - WP + 0.025, pt - WP + 0.195) net=n1
  l7 = rect li xspan=(x1 - 0.22, x2 + 0.04) yspan=(pt - WP + 0.025, pt - 0.58) net=n1
  l8 = rect li xspan=(x1 - 0.14, x2 + 0.04) yspan=(nb + 0.135, pt - 0.58) net=n1
  l9 = rect li xspan=(x5, x5 + L + 0.025) yspan=(nb + WN + 0.19, pt - WP + 0.195) net=n1
  l10 = rect li xspan=(x5, x5 + L + 0.185) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n1
  l11 = rect li xspan=(x3 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN + 0.01) net=Y
  l12 = rect li xspan=(x3 + L - 0.03, x5 + L + 0.535) yspan=(nb + WN2 + 0.07, nb + WN + 0.01) net=Y
  l13 = rect li xspan=(x5 + L - 0.03, x5 + L + 0.535) yspan=(pt - 0.58 - 0.055, pt - 0.02) net=Y
  l14 = rect li xspan=(x5 + L + 0.355, x5 + L + 0.535) yspan=(nb + WN2 + 0.07, pt - 0.02) net=Y
  l15 = rect li xspan=(x2 + L + 0.095, x4 + 0.03) yspan=(pt - 0.58 - 0.05, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + WN + 0.01 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x4 + L + 0.08) span=(nb + 0.02, nb + WN + 0.01) margin=0.04 net=Y
  c3 = array licon in=nd2 cx=(x5 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.1 - 0.08) net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.135, nb + WN2 - 0.11) net=n1
  c5 = array licon in=pd1 cx=(x1 - 0.135) span=(pt - WP + 0.025 + 0.08, pt - 0.58 - 0.08) net=n1
  c6 = array licon in=pd2 cx=(x3 - 0.08) span=(pt - 0.58 - 0.05, H + 0.085) net=VPWR
  c7 = array licon in=pd2 cx=(x5 + L + 0.14) span=(pt - 0.58 - 0.055, pt - 0.02) net=Y
  gc1 = contact licon cx=(x1 - 0.395) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 - 0.015) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x5 + L + 0.02) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.635, x5 + L + 0.62) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.405) cy=0
  mc2 = contact mcon cx=(x2 + 0.055) cy=0
  mc3 = contact mcon cx=(x4 - 0.025) cy=0
  mc4 = contact mcon cx=(x5 + L/2) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.39) cy=0
  mc6 = contact mcon cx=(x1 - 0.405) cy=H
  mc7 = contact mcon cx=(x2 + 0.055) cy=H
  mc8 = contact mcon cx=(x4 - 0.025) cy=H
  mc9 = contact mcon cx=(x5 + L/2) cy=H
  mc10 = contact mcon cx=(x5 + L + 0.39) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B_N in on=l3
  port Y out on=l13
end
