# maj3_2: lifted from sky130_fd_sc_hd__maj3_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.64 L=0.15 H=2.72

stdcell maj3_2 width=11 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=A s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=n2 g=C s=n3 b=VPB
  device M2 pmos w=WP2 l=L d=VPWR g=A s=n4 b=VPB
  device M3 pmos w=WP2 l=L d=n4 g=B s=n2 b=VPB
  device M4 nmos w=WN2 l=L d=n2 g=B s=n5 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=C s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=A s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=n2 g=C s=n1 b=VNB
  device M8 pmos w=WP2 l=L d=n2 g=B s=n6 b=VPB
  device M9 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M10 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M11 nmos w=WN2 l=L d=n7 g=B s=n2 b=VNB
  device M12 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M13 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M14 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M15 nmos w=WN2 l=L d=VGND g=A s=n7 b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.5
  x2 = x1 + L + 0.22
  x3 = x2 + L + 0.28
  x4 = x3 + L + 0.22
  x5 = x4 + L + 0.28
  x6 = x5 + L + 0.22
  x7 = x6 + L + 0.61
  x8 = x7 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.275) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x6 + L + 0.29, x8 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x8 + L + 0.275) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x7 - 0.255, x8 + L + 0.275) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.125, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4, x5 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x6, x6 + L + 0.185) yspan=(pt - WP - 0.1, pt - WP2 - 0.19)
  p11 = rect poly xspan=(x7 - 0.225, x8 + L) yspan=(nb + WN + 0.14, pt - WP - 0.19)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p13 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l2 = rect li xspan=(x6 + L + 0.075, x7 - 0.205) yspan=(-0.085, nb + WN2 - 0.17) net=VGND
  l3 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.325) yspan=(-0.085, nb + WN + 0.02) net=VGND
  l4 = rect li xspan=(x2 + L, x4 + 0.06) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A
  l5 = rect li xspan=(x4 + L + 0.085, x5 + L - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B
  l6 = rect li xspan=(x1 - 0.075, x2 - 0.085) yspan=(nb + WN + 0.11, pt - WP + 0.18) net=C
  l7 = rect li xspan=(x1 - 0.075, x7 - 0.1) yspan=(pt - WP + 0.01, pt - WP + 0.18) net=C
  l8 = rect li xspan=(x6, x7 - 0.1) yspan=(pt - WP - 0.07, pt - WP + 0.18) net=C
  l9 = rect li xspan=(x1 - 0.415, x1 - 0.245) yspan=(nb + 0.045, pt - 0.02) net=n2
  l10 = rect li xspan=(x1 - 0.415, x1 + 0.03) yspan=(nb + 0.045, nb + WN - 0.06) net=n2
  l11 = rect li xspan=(x1 - 0.415, x7 - 0.065) yspan=(nb + WN2, nb + WN - 0.06) net=n2
  l12 = rect li xspan=(x1 - 0.415, x5 + 0.03) yspan=(pt - WP2 - 0.01, pt - WP2 + 0.16) net=n2
  l13 = rect li xspan=(x1 - 0.415, x1 + L - 0.03) yspan=(pt - WP2 - 0.01, pt - 0.02) net=n2
  l14 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l15 = rect li xspan=(x4 + L - 0.03, x5 + 0.03) yspan=(pt - WP2 - 0.01, pt - 0.02) net=n2
  l16 = rect li xspan=(x7 - 0.245, x7 - 0.065) yspan=(nb + WN2, pt - WP - 0.24) net=n2
  l17 = rect li xspan=(x7 - 0.245, x7 + L - 0.04) yspan=(nb + WN + 0.19, pt - WP - 0.24) net=n2
  l18 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(nb + 0.02, nb + WN + 0.02) net=X
  l19 = rect li xspan=(x7 + L - 0.03, x8 + 0.03) yspan=(pt - WP + 0.01, pt - 0.02) net=X
  l20 = rect li xspan=(x7 + L + 0.135, x8 + 0.03) yspan=(nb + 0.02, pt - 0.02) net=X
  l21 = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - 0.31, H + 0.085) net=VPWR
  l22 = rect li xspan=(x6 + L - 0.03, x6 + L + 0.3) yspan=(pt - WP2 - 0.01, H + 0.085) net=VPWR
  l23 = rect li xspan=(x8 + L + 0.055, x8 + L + 0.325) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x2 + L + 0.14) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN - 0.06) margin=0.04 net=n2
  c3 = array licon in=nd1 cx=(x6 + L + 0.24) span=(-0.085, nb + WN2 - 0.17) margin=0.04 net=VGND
  c4 = array licon in=nd2 cx=(x7 + L + 0.14) span=(nb + 0.02, nb + WN + 0.02) margin=0.04 net=X
  c5 = array licon in=nd2 cx=(x8 + L + 0.14) span=(-0.085 + 0.08, nb + WN + 0.02 - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.045, nb + WN - 0.06) net=n2
  c7 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP + 0.01, pt - 0.02) margin=0.04 net=X
  c8 = array licon in=pd2 cx=(x8 + L + 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP2 - 0.01, pt - 0.02) net=n2
  c10 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP2 - 0.01, pt - 0.02) margin=0.04 net=n2
  c11 = array licon in=pd1 cx=(x6 + L + 0.14) span=(pt - WP2 - 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - 0.31, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + 0.015) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 + L + 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x5 - 0.11) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x7 - 0.06) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x6 + L + 0.02) cy=(pt - WP + 0.035)
  np1 = rect npc xspan=(x1 - 0.5, x8 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x6 - 0.025, x6 + L + 0.205) yspan=(nb + WN + 0.09, pt - WP2 - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.27) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.05) cy=0
  mc3 = contact mcon cx=(x3 - 0.13) cy=0
  mc4 = contact mcon cx=(x4 - 0.03) cy=0
  mc5 = contact mcon cx=(x5 + 0.015) cy=0
  mc6 = contact mcon cx=(x6 + L - 0.035) cy=0
  mc7 = contact mcon cx=(x7 - 0.18) cy=0
  mc8 = contact mcon cx=(x7 + L + 0.14) cy=0
  mc9 = contact mcon cx=(x8 + L + 0.18) cy=0
  mc10 = contact mcon cx=(x1 - 0.27) cy=H
  mc11 = contact mcon cx=(x1 + L + 0.05) cy=H
  mc12 = contact mcon cx=(x3 - 0.13) cy=H
  mc13 = contact mcon cx=(x4 - 0.03) cy=H
  mc14 = contact mcon cx=(x5 + 0.015) cy=H
  mc15 = contact mcon cx=(x6 + L - 0.035) cy=H
  mc16 = contact mcon cx=(x7 - 0.18) cy=H
  mc17 = contact mcon cx=(x7 + L + 0.14) cy=H
  mc18 = contact mcon cx=(x8 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l4
  port B in on=l5
  port C in on=l7
  port X out on=l18
end
