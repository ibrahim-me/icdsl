# and2b_2: lifted from sky130_fd_sc_hd__and2b_2 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and2b_2 width=9 height=H taps=no
  device M0 pmos w=WP2 l=L d=VPWR g=n1 s=n2 b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=n1 s=n3 b=VNB
  device M2 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M3 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M4 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M5 pmos w=WP2 l=L d=n2 g=B s=VPWR b=VPB
  device M6 pmos w=WP2 l=L d=n1 g=A_N s=VPWR b=VPB
  device M7 nmos w=WN2 l=L d=VGND g=A_N s=n1 b=VNB
  device M8 nmos w=WN2 l=L d=n3 g=B s=VGND b=VNB
  device M9 nmos w=WN l=L d=X g=n2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.375
  x3 = x2 + L + 0.285
  x4 = x3 + 0.015
  x5 = x4 + L + 0.265
  x6 = x5 + L + 0.35
  x7 = x6 + L + 0.28
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x2 - 0.11) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.02, x7 + L + 0.275) yspan=(nb, nb + WN2)
  nd3 = rect diff xspan=(x5 + L + 0.08, x7 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x7 + L + 0.265) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x5 + L + 0.095, x7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.2, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + WN - 0.08, H - 0.105)
  p4 = rect poly xspan=(x2, x3 - 0.085) yspan=(nb + WN - 0.08, pt - WP - 0.35)
  p5 = rect poly xspan=(x2, x3 + L) yspan=(nb + WN - 0.08, nb + WN + 0.07)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, nb + WN + 0.07)
  p7 = rect poly xspan=(x4, x4 + L) yspan=(pt - WP + 0.04, H - 0.105)
  p8 = rect poly xspan=(x3 + L - 0.015, x5 + L - 0.065) yspan=(nb + WN + 0.28, pt - WP2 - 0.17)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, pt - WP - 0.075)
  p10 = rect poly xspan=(x6 - 0.135, x7 + L) yspan=(nb + WN + 0.1, pt - WP - 0.16)
  p11 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.305, x1 + 0.03) yspan=(-0.085, nb + WN2 - 0.065) net=VGND
  l2 = rect li xspan=(x5 + L - 0.03, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.075) net=VGND
  l3 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.325) yspan=(-0.085, nb + WN2 + 0.065) net=VGND
  l4 = rect li xspan=(x1 - 0.25, x1 + 0.055) yspan=(nb + WN2 + 0.11, pt - WP + 0.13) net=A_N
  l5 = rect li xspan=(x4 + L + 0.01, x6 - 0.05) yspan=(pt - WP + 0.16, pt - WP2 - 0.11) net=B
  l6 = rect li xspan=(x6 + L - 0.02, x7 + 0.015) yspan=(pt - WP + 0.095, pt - 0.12) net=X
  l7 = rect li xspan=(x6 + L + 0.055, x7 + 0.015) yspan=(nb + 0.02, nb + WN - 0.11) net=X
  l8 = rect li xspan=(x6 + L + 0.115, x7 + 0.015) yspan=(nb + 0.02, pt - 0.12) net=X
  l9 = rect li xspan=(x2 + L - 0.015, x3 - 0.01) yspan=(pt - WP - 0.18, pt - 0.065) net=n2
  l10 = rect li xspan=(x2 + L - 0.015, x5 + L) yspan=(pt - WP - 0.18, pt - WP - 0.01) net=n2
  l11 = rect li xspan=(x2 + L + 0.06, x3 - 0.055) yspan=(nb + 0.035, nb + WN2 - 0.045) net=n2
  l12 = rect li xspan=(x2 + L + 0.06, x4 + L + 0.02) yspan=(nb + 0.18, nb + WN2 - 0.045) net=n2
  l13 = rect li xspan=(x4 - 0.005, x4 + L + 0.02) yspan=(nb + 0.18, pt - WP - 0.01) net=n2
  l14 = rect li xspan=(x4 - 0.005, x6 + L - 0.06) yspan=(nb + WN + 0.06, pt - WP - 0.16) net=n2
  l15 = rect li xspan=(x1 - 0.225, x1 - 0.055) yspan=(pt - WP + 0.3, pt - 0.04) net=n1
  l16 = rect li xspan=(x1 - 0.225, x2 - 0.06) yspan=(pt - WP + 0.3, pt - WP2 - 0.05) net=n1
  l17 = rect li xspan=(x1 + L + 0.055, x2 - 0.08) yspan=(nb + 0.045, nb + WN2) net=n1
  l18 = rect li xspan=(x1 + L + 0.08, x2 - 0.08) yspan=(nb + 0.045, pt - WP2 - 0.05) net=n1
  l19 = rect li xspan=(x1 + L + 0.08, x2 + L + 0.12) yspan=(nb + WN - 0.08, nb + WN + 0.25) net=n1
  l20 = rect li xspan=(x1 + L + 0.08, x2 - 0.06) yspan=(nb + WN - 0.08, pt - WP2 - 0.05) net=n1
  l21 = rect li xspan=(x1 + L - 0.03, x2 - 0.07) yspan=(pt - WP2 + 0.12, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.015, x6 - 0.055) yspan=(pt - WP2 + 0.1, H + 0.085) net=VPWR
  l23 = rect li xspan=(x7 + L + 0.055, x7 + L + 0.325) yspan=(pt - WP + 0.195, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(-0.085, nb + WN2 - 0.065) net=VGND
  c2 = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.045 + 0.08, nb + WN2 - 0.08) net=n1
  c3 = array licon in=nd2 cx=(x3 - 0.14) span=(nb + 0.035 + 0.08, nb + WN2 - 0.045 - 0.08) net=n2
  c4 = array licon in=nd3 cx=(x6 - 0.14) span=(-0.085, nb + WN2 - 0.075) net=VGND
  c5 = array licon in=nd3 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.11 - 0.08) margin=0.04 net=X
  c6 = array licon in=nd3 cx=(x7 + L + 0.14) span=(-0.085 + 0.08, nb + WN2 + 0.065 - 0.08) net=VGND
  c7 = array licon in=pd2 cx=(x6 + L + 0.14) span=(pt - WP + 0.095 + 0.08, pt - 0.12 - 0.08) margin=0.04 net=X
  c8 = array licon in=pd2 cx=(x7 + L + 0.14) span=(pt - WP + 0.195 + 0.08, H + 0.085 - 0.08) net=VPWR
  c9 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.3 + 0.08, pt - 0.04 - 0.08) net=n1
  c10 = array licon in=pd1 cx=(x3 - 0.135) span=(pt - WP - 0.18 + 0.08, pt - 0.065 - 0.08) margin=0.04 net=n2
  c11 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP2 + 0.12, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd1 cx=(x5 - 0.075) span=(pt - WP2 + 0.1, H + 0.085) margin=0.04 net=VPWR
  c13 = array licon in=pd1 cx=(x5 + L + 0.125) span=(pt - WP2 + 0.1, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x2 + L + 0.035) cy=(nb + WN + 0.085)
  gc2 = contact licon cx=(x1 - 0.035) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x6 + 0.005) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x5 - 0.09) cy=(pt - WP + 0.245)
  np1 = rect npc xspan=(x1 - 0.4, x7 + L + 0.41) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x2 - 0.185, x5 + 0.03) yspan=(nb + WN - 0.1, pt - WP - 0.14)
  np3 = rect npc xspan=(x3 + L - 0.045, x5 + L - 0.015) yspan=(nb + WN + 0.09, pt - WP2 - 0.15)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.15) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.095) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.115) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x6 + L + 0.14) cy=0
  mc7 = contact mcon cx=(x7 + L + 0.18) cy=0
  mc8 = contact mcon cx=(x1 - 0.17) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.15) cy=H
  mc10 = contact mcon cx=(x2 + L + 0.095) cy=H
  mc11 = contact mcon cx=(x4 + L + 0.115) cy=H
  mc12 = contact mcon cx=(x5 + L + 0.17) cy=H
  mc13 = contact mcon cx=(x6 + L + 0.14) cy=H
  mc14 = contact mcon cx=(x7 + L + 0.18) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A_N in on=l4
  port B in on=l5
  port X out on=l6
end
