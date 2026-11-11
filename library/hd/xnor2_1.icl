# xnor2_1: lifted from sky130_fd_sc_hd__xnor2_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell xnor2_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M2 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B s=n4 b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M7 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M9 nmos w=WN l=L d=n4 g=n2 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.44
  x2 = x1 + 0.06
  x3 = x2 + L + 0.22
  x4 = x3 + L + 0.28
  x5 = x4 + L + 0.32
  x6 = x5 + L + 0.22
  x7 = x6 + 0.12
  x8 = x7 + L + 0.22
  x9 = x8 + 0.06
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.205, x5 - 0.055) yspan=(nb, nb + WN)
  nd2 = rect diff xspan=(x5 + L + 0.075, x9 + L + 0.305) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.305, x9 + L + 0.305) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.065, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.16)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - WP - 0.16)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, pt - WP - 0.16)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(nb + WN + 0.11, H - 0.105)
  p11 = rect poly xspan=(x8, x9 + L + 0.065) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x9, x9 + L) yspan=(0.105, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x3 + L + 0.055, x4 - 0.055) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l2 = rect li xspan=(x5 + L + 0.015, x6 + L) yspan=(-0.085, nb + 0.24) net=VGND
  l3 = rect li xspan=(x4 + L - 0.03, x5 - 0.015) yspan=(nb + 0.02, nb + WN + 0.02) net=n4
  l4 = rect li xspan=(x4 + L - 0.03, x6 + L + 0.06) yspan=(nb + 0.5, nb + WN + 0.02) net=n4
  l5 = rect li xspan=(x6 + 0.04, x9 + 0.01) yspan=(nb + 0.42, nb + WN - 0.06) net=n4
  l6 = rect li xspan=(x7 + L + 0.055, x9 + 0.01) yspan=(nb + 0.02, nb + WN - 0.06) net=n4
  l7 = rect li xspan=(x3 + L/2, x5 - 0.115) yspan=(nb + WN + 0.19, pt - WP - 0.21) net=A
  l8 = rect li xspan=(x1 - 0.015, x2 + L + 0.03) yspan=(nb + WN + 0.11, pt - WP + 0.13) net=B
  l9 = rect li xspan=(x1 - 0.015, x5 + L + 0.085) yspan=(pt - WP - 0.04, pt - WP + 0.13) net=B
  l10 = rect li xspan=(x5 + 0.06, x7 + L + 0.035) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=B
  l11 = rect li xspan=(x5 + 0.06, x5 + L + 0.085) yspan=(nb + WN + 0.19, pt - WP + 0.13) net=B
  l12 = rect li xspan=(x6 + L + 0.02, x9 + 0.01) yspan=(pt - 0.36, pt - 0.19) net=Y
  l13 = rect li xspan=(x8 - 0.105, x9 + L + 0.355) yspan=(pt - WP + 0.27, pt - 0.53) net=Y
  l14 = rect li xspan=(x8 - 0.105, x9 + 0.01) yspan=(pt - WP + 0.27, pt - 0.19) net=Y
  l15 = rect li xspan=(x9 + L + 0.035, x9 + L + 0.355) yspan=(nb + 0.11, nb + WN - 0.06) net=Y
  l16 = rect li xspan=(x9 + L + 0.185, x9 + L + 0.355) yspan=(nb + 0.11, pt - 0.53) net=Y
  l17 = rect li xspan=(x1 - 0.355, x1 - 0.185) yspan=(nb + 0.045, pt - WP + 0.47) net=n2
  l18 = rect li xspan=(x1 - 0.355, x1 + L - 0.035) yspan=(nb + 0.045, nb + WN - 0.06) net=n2
  l19 = rect li xspan=(x1 - 0.355, x6 + L + 0.06) yspan=(pt - WP + 0.3, pt - WP + 0.47) net=n2
  l20 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(pt - WP + 0.3, pt - 0.02) net=n2
  l21 = rect li xspan=(x6 + 0.04, x9 + L + 0.015) yspan=(pt - WP - 0.07, pt - WP + 0.1) net=n2
  l22 = rect li xspan=(x6 + 0.04, x6 + L + 0.06) yspan=(pt - WP - 0.07, pt - WP + 0.47) net=n2
  l23 = rect li xspan=(x9 - 0.01, x9 + L + 0.015) yspan=(nb + WN + 0.11, pt - WP + 0.1) net=n2
  l24 = rect li xspan=(x1 - 0.355, x1 - 0.055) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l25 = rect li xspan=(x3 + L + 0.055, x5 - 0.055) yspan=(pt - 0.36, H + 0.085) net=VPWR
  l26 = rect li xspan=(x9 + L + 0.035, x9 + L + 0.335) yspan=(pt - 0.36, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.08) span=(nb + 0.045, nb + WN - 0.06) net=n2
  c2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) net=n4
  c4 = array licon in=nd2 cx=(x6 - 0.02) span=(-0.085, nb + 0.24) net=VGND
  c5 = array licon in=nd2 cx=(x8 - 0.08) span=(nb + 0.02 + 0.08, nb + WN - 0.06 - 0.08) margin=0.04 net=n4
  c6 = array licon in=nd2 cx=(x9 + L + 0.18) span=(nb + 0.11 + 0.08, nb + WN - 0.06 - 0.08) net=Y
  c7 = array licon in=pd1 cx=(x2 + L + 0.08) span=(pt - WP + 0.3, pt - 0.02) margin=0.04 net=n2
  c8 = array licon in=pd1 cx=(x7 + L + 0.08) span=(pt - 0.36, pt - 0.19) margin=0.04 net=Y
  c9 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c10 = array licon in=pd1 cx=(x5 - 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c11 = array licon in=pd1 cx=(x9 + L + 0.12) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.36 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.095) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x4 + L + 0.015) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x6 + L/2 + 0.06) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x8 + L - 0.015) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.44, x9 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.21) cy=0
  mc2 = contact mcon cx=(x2 + L + 0.05) cy=0
  mc3 = contact mcon cx=(x4 - 0.13) cy=0
  mc4 = contact mcon cx=(x5 - 0.13) cy=0
  mc5 = contact mcon cx=(x6 - 0.03) cy=0
  mc6 = contact mcon cx=(x8 - 0.05) cy=0
  mc7 = contact mcon cx=(x9 + L + 0.21) cy=0
  mc8 = contact mcon cx=(x1 - 0.21) cy=H
  mc9 = contact mcon cx=(x2 + L + 0.05) cy=H
  mc10 = contact mcon cx=(x4 - 0.13) cy=H
  mc11 = contact mcon cx=(x5 - 0.13) cy=H
  mc12 = contact mcon cx=(x6 - 0.03) cy=H
  mc13 = contact mcon cx=(x8 - 0.05) cy=H
  mc14 = contact mcon cx=(x9 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l7
  port B in on=l9
  port Y out on=l13
end
