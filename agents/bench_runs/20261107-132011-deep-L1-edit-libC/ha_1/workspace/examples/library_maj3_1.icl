# maj3_1: lifted from sky130_fd_sc_hd__maj3_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=10 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.22
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.22
  x7 = x6 + L + 0.575
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.37) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x7 - 0.255, x7 + L + 0.37) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.37) yspan=(pt - 0.36 - WP2, pt - 0.36)
  pd2 = rect diff xspan=(x6 + L + 0.095, x7 + L + 0.37) yspan=(pt - WP, pt - 0.36)
  pd3 = rect diff xspan=(x6 + L + 0.135, x7 + L + 0.37) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - 0.36 + 0.13)
  p2 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, pt - 0.36 + 0.13)
  p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, pt - 0.36 + 0.13)
  p5 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - 0.36 + 0.13)
  p7 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x1, x6 + L) yspan=(pt - 0.02, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.28) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p11 = rect poly xspan=(x7 - 0.085, x7 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x6 + L + 0.085, x7 - 0.155) yspan=(-0.085, nb + WN2 - 0.185) net=VGND
  l3 = rect li xspan=(x6 + L - 0.05, x7 - 0.28) yspan=(nb + WN2 + 0.11, pt - WP - 0.16) net=C
  l4 = rect li xspan=(x4 - 0.04, x5 - 0.055) yspan=(nb + WN + 0.11, pt - 0.36 - WP2 - 0.09) net=B
  l5 = rect li xspan=(x1 - 0.265, x1) yspan=(nb + 0.02, pt - 0.36) net=n3
  l6 = rect li xspan=(x1 - 0.265, x6 - 0.075) yspan=(nb + WN2, nb + WN - 0.06) net=n3
  l7 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=n3
  l8 = rect li xspan=(x4 + L - 0.03, x6 - 0.075) yspan=(nb + WN2 - 0.015, nb + WN - 0.06) net=n3
  l9 = rect li xspan=(x4 + L - 0.03, x6 - 0.075) yspan=(pt - 0.36 - WP2 + 0.11, pt - 0.36 - 0.045) net=n3
  l10 = rect li xspan=(x5 + L - 0.03, x6 - 0.075) yspan=(nb + WN2 - 0.015, pt - 0.36 - 0.045) net=n3
  l11 = rect li xspan=(x5 + L - 0.03, x7 + 0.065) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=n3
  l12 = rect li xspan=(x7 - 0.11, x7 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n3
  l13 = rect li xspan=(x7 - 0.11, x7 + 0.065) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=n3
  l14 = rect li xspan=(x1 + L + 0.07, x2 + 0.025) yspan=(nb + WN + 0.11, pt - 0.025) net=A
  l15 = rect li xspan=(x1 + L + 0.07, x3 - 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l16 = rect li xspan=(x7 + L + 0.08, x7 + L + 0.42) yspan=(nb + 0.02, nb + WN - 0.06) net=X
  l17 = rect li xspan=(x7 + L + 0.08, x7 + L + 0.42) yspan=(pt - 0.36 + 0.035, pt - 0.02) net=X
  l18 = rect li xspan=(x7 + L + 0.09, x7 + L + 0.42) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l19 = rect li xspan=(x7 + L + 0.195, x7 + L + 0.42) yspan=(nb + 0.02, pt - 0.02) net=X
  l20 = rect li xspan=(x2 + L + 0.055, x3 + 0.03) yspan=(pt - 0.36 - WP2 + 0.01, H + 0.085) net=VPWR
  l21 = rect li xspan=(x6 + L + 0.095, x7 - 0.15) yspan=(pt - 0.36 - WP2 + 0.14, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x7 + L + 0.245) span=(nb + 0.02, nb + WN - 0.06) net=X
  c2 = array licon in=nd1 cx=(x6 + L + 0.25) span=(-0.085, nb + WN2 - 0.185) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.36 - 0.08) net=n3
  c5 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n3
  c6 = array licon in=pd3 cx=(x7 + L + 0.245) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=X
  c7 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + 0.02 + 0.08, pt - 0.36 - 0.08) net=n3
  c8 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.36 - WP2 + 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - 0.36 - WP2 + 0.11, pt - 0.36 - 0.045) margin=0.04 net=n3
  c10 = array licon in=pd3 cx=(x6 + L + 0.26) span=(pt - 0.36 - WP2 + 0.14, H + 0.085) net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x4 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + L + 0.115) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 + L - 0.065) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.505) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x3 - 0.03) cy=0
  mc4 = contact mcon cx=(x4 + L/2) cy=0
  mc5 = contact mcon cx=(x5 + L - 0.035) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.07) cy=0
  mc7 = contact mcon cx=(x7 - 0.045) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.275) cy=0
  mc9 = contact mcon cx=(x1 - 0.17) cy=H
  mc10 = contact mcon cx=(x2 - 0.07) cy=H
  mc11 = contact mcon cx=(x3 - 0.03) cy=H
  mc12 = contact mcon cx=(x4 + L/2) cy=H
  mc13 = contact mcon cx=(x5 + L - 0.035) cy=H
  mc14 = contact mcon cx=(x6 + L + 0.07) cy=H
  mc15 = contact mcon cx=(x7 - 0.045) cy=H
  mc16 = contact mcon cx=(x7 + L + 0.275) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l14
  port B in on=l4
  port C in on=l3
  port X out on=l16
end
