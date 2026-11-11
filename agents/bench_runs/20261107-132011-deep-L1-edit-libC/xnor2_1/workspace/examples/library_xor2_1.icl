# xor2_1: lifted from sky130_fd_sc_hd__xor2_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell xor2_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M1 nmos w=WN l=L d=VGND g=B s=n1 b=VNB
  device M2 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR b=VPB
  device M4 pmos w=WP l=L d=VPWR g=A s=n2 b=VPB
  device M5 pmos w=WP l=L d=n1 g=B s=n3 b=VPB
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=n4 g=B s=X b=VNB
  device M8 pmos w=WP l=L d=n2 g=n1 s=X b=VPB
  device M9 nmos w=WN l=L d=VGND g=A s=n4 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.44
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.78
  x6 = x5 + 0.02
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.305) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x5 - 0.245, x6 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.065, x1 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4 - 0.065, x4 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x4 + L + 0.275, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.16)
  p10 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.275, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + 0.24) net=VGND
  l2 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + 0.24) net=VGND
  l3 = rect li xspan=(x6 + L + 0.065, x6 + L + 0.355) yspan=(-0.085, nb + WN + 0.035) net=VGND
  l4 = rect li xspan=(x2 - 0.02, x3 + L - 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l5 = rect li xspan=(x1 - 0.015, x1 + L + 0.09) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B
  l6 = rect li xspan=(x1 - 0.015, x4 + 0.035) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B
  l7 = rect li xspan=(x3 + L + 0.14, x4 + L + 0.095) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=B
  l8 = rect li xspan=(x3 + L + 0.14, x4 + 0.035) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l9 = rect li xspan=(x1 - 0.355, x5 - 0.285) yspan=(nb + WN - 0.23, nb + WN - 0.06) net=n1
  l10 = rect li xspan=(x1 - 0.355, x1 - 0.185) yspan=(nb + WN - 0.23, pt - 0.02) net=n1
  l11 = rect li xspan=(x1 - 0.355, x1 + 0.03) yspan=(pt - 0.7, pt - 0.02) net=n1
  l12 = rect li xspan=(x1 + L + 0.055, x2 - 0.055) yspan=(nb + 0.1, nb + WN - 0.06) net=n1
  l13 = rect li xspan=(x4 + L + 0.265, x5 - 0.285) yspan=(nb + WN - 0.23, pt - WP - 0.16) net=n1
  l14 = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l15 = rect li xspan=(x3 + L - 0.03, x6) yspan=(pt - WP + 0.3, pt - 0.53) net=n2
  l16 = rect li xspan=(x5 - 0.385, x6) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l17 = rect li xspan=(x4 + 0.025, x6 + 0.04) yspan=(nb + 0.08, nb + 0.25) net=X
  l18 = rect li xspan=(x5 - 0.115, x6 + 0.04) yspan=(nb + 0.08, pt - WP + 0.05) net=X
  l19 = rect li xspan=(x5 - 0.115, x6 + L + 0.355) yspan=(pt - WP - 0.12, pt - WP + 0.05) net=X
  l20 = rect li xspan=(x6 + L + 0.035, x6 + L + 0.355) yspan=(pt - WP - 0.12, pt - 0.02) net=X
  l21 = rect li xspan=(x2 + L + 0.055, x3 - 0.055) yspan=(pt - 0.7, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.055, x4 + L + 0.225) yspan=(pt - 0.36, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + 0.24) net=VGND
  c2 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + 0.24) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.08, nb + 0.25) margin=0.04 net=X
  c4 = array licon in=nd1 cx=(x5 - 0.14) span=(nb + 0.08, nb + 0.25) margin=0.04 net=X
  c5 = array licon in=nd1 cx=(x6 + L + 0.15) span=(-0.085 + 0.08, nb + WN + 0.035 - 0.08) margin=0.04 net=VGND
  c6 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.1 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP - 0.12 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.7 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=n2
  c10 = array licon in=pd2 cx=(x5 - 0.12) span=(pt - WP + 0.3 + 0.08, pt - 0.02 - 0.08) net=n2
  c11 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.7, pt - 0.02) net=n1
  c12 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 + L/2) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.095) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L/2) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 - 0.37) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.44, x6 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.21) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.11) cy=0
  mc3 = contact mcon cx=(x3 - 0.13) cy=0
  mc4 = contact mcon cx=(x4 - 0.09) cy=0
  mc5 = contact mcon cx=(x4 + L + 0.23) cy=0
  mc6 = contact mcon cx=(x5 - 0.09) cy=0
  mc7 = contact mcon cx=(x6 + L + 0.21) cy=0
  mc8 = contact mcon cx=(x1 - 0.21) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.11) cy=H
  mc10 = contact mcon cx=(x3 - 0.13) cy=H
  mc11 = contact mcon cx=(x4 - 0.09) cy=H
  mc12 = contact mcon cx=(x4 + L + 0.23) cy=H
  mc13 = contact mcon cx=(x5 - 0.09) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l6
  port X out on=l19
end
