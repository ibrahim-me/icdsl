# and3_1: lifted from sky130_fd_sc_hd__and3_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and3_1 width=7 height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=C s=VGND b=VNB
  device M1 pmos w=WP2 l=L d=n2 g=A s=VPWR b=VPB
  device M2 pmos w=WP2 l=L d=VPWR g=B s=n2 b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n2 s=X b=VPB
  device M4 nmos w=WN2 l=L d=n3 g=B s=n1 b=VNB
  device M5 nmos w=WN2 l=L d=n2 g=A s=n3 b=VNB
  device M6 nmos w=WN l=L d=VGND g=n2 s=X b=VNB
  device M7 pmos w=WP2 l=L d=n2 g=C s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.4
  x2 = x1 + L + 0.22
  x3 = x2 + 0.06
  x4 = x3 + L + 0.16
  x5 = x4 + L + 0.025
  x6 = x5 + L + 0.335
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x5 + L + 0.08, x6 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x6 + L + 0.265) yspan=(pt - 0.565 - WP2, pt - 0.565)
  pd2 = rect diff xspan=(x5 + L + 0.07, x6 + L + 0.265) yspan=(pt - 0.565 + 0.27, pt)
  pd3 = rect diff xspan=(x5 + L + 0.08, x6 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.245)
  p2 = rect poly xspan=(x4 + 0.06, x5 + 0.02) yspan=(nb + WN2 + 0.075, pt - WP - 0.19)
  p3 = rect poly xspan=(x4 + 0.06, x5 + 0.045) yspan=(nb + WN - 0.035, pt - WP - 0.19)
  p4 = rect poly xspan=(x4 + 0.06, x5 + L + 0.02) yspan=(nb + WN + 0.08, pt - WP - 0.19)
  p5 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.08, pt - 0.565 + 0.13)
  p6 = rect poly xspan=(x1 - 0.275, x1 + L) yspan=(nb + WN2 + 0.075, pt - WP - 0.23)
  p7 = rect poly xspan=(x1, x1 + L) yspan=(0.105, pt - 0.565 + 0.205)
  p8 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.075)
  p9 = rect poly xspan=(x3, x3 + L) yspan=(pt - WP - 0.2, pt - 0.025)
  p10 = rect poly xspan=(x3, x4 - 0.035) yspan=(pt - 0.565 + 0.21, pt - 0.025)
  p11 = rect poly xspan=(x6 - 0.105, x6 + L + 0.025) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p12 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x5 + L + 0.11, x6 + 0.03) yspan=(-0.085, nb + WN2 - 0.03) net=VGND
  l2 = rect li xspan=(x1 - 0.315, x1 + L + 0.095) yspan=(nb + WN2 - 0.02, nb + WN + 0.135) net=A
  l3 = rect li xspan=(x4 + 0.03, x5 + L - 0.065) yspan=(nb + 0.07, nb + WN + 0.33) net=C
  l4 = rect li xspan=(x4 + 0.03, x5 + L + 0.05) yspan=(nb + WN - 0.095, nb + WN + 0.33) net=C
  l5 = rect li xspan=(x1 - 0.315, x3 + L + 0.015) yspan=(nb + 0.06, nb + WN2 - 0.19) net=n2
  l6 = rect li xspan=(x1 - 0.315, x1 - 0.055) yspan=(nb + WN + 0.305, pt - 0.565 - 0.11) net=n2
  l7 = rect li xspan=(x1 - 0.315, x3 + L + 0.015) yspan=(nb + WN + 0.305, pt - WP - 0.125) net=n2
  l8 = rect li xspan=(x2 - 0.05, x3 + L + 0.03) yspan=(nb + WN + 0.4, pt - WP - 0.095) net=n2
  l9 = rect li xspan=(x2 - 0.05, x3 + L + 0.035) yspan=(nb + WN + 0.415, pt - WP - 0.095) net=n2
  l10 = rect li xspan=(x2 - 0.05, x3 + L + 0.045) yspan=(nb + WN + 0.43, pt - WP - 0.095) net=n2
  l11 = rect li xspan=(x2 - 0.05, x3 + L + 0.05) yspan=(nb + WN + 0.435, pt - WP - 0.095) net=n2
  l12 = rect li xspan=(x2 - 0.05, x3 + L + 0.055) yspan=(nb + WN + 0.445, pt - WP - 0.095) net=n2
  l13 = rect li xspan=(x2 - 0.05, x3 + L + 0.065) yspan=(nb + WN + 0.455, pt - WP - 0.095) net=n2
  l14 = rect li xspan=(x2 - 0.05, x3 + L + 0.075) yspan=(nb + WN + 0.46, pt - WP - 0.095) net=n2
  l15 = rect li xspan=(x2 - 0.02, x3 + L + 0.015) yspan=(nb + WN + 0.305, pt - WP - 0.06) net=n2
  l16 = rect li xspan=(x2 + 0.02, x6 + L - 0.03) yspan=(nb + WN + 0.5, pt - WP - 0.035) net=n2
  l17 = rect li xspan=(x3 - 0.01, x3 + L + 0.015) yspan=(nb + 0.06, pt - WP - 0.005) net=n2
  l18 = rect li xspan=(x3 + 0.01, x3 + L + 0.015) yspan=(nb + 0.06, pt - 0.565 - WP2 + 0.01) net=n2
  l19 = rect li xspan=(x3 + 0.03, x6 + L - 0.03) yspan=(nb + WN + 0.5, pt - 0.565 - WP2 + 0.04) net=n2
  l20 = rect li xspan=(x2 + L + 0.01, x6 + L - 0.03) yspan=(nb + WN + 0.5, pt - 0.565 - WP2 + 0.05) net=n2
  l21 = rect li xspan=(x3 + L - 0.025, x6 + L - 0.03) yspan=(nb + WN + 0.5, pt - 0.565 - WP2 + 0.06) net=n2
  l22 = rect li xspan=(x3 + L - 0.005, x3 + L + 0.02) yspan=(pt - WP - 0.225, pt - 0.565 - WP2 + 0.075) net=n2
  l23 = rect li xspan=(x3 + L + 0.02, x4 - 0.075) yspan=(pt - WP - 0.13, pt - 0.565 - WP2 + 0.09) net=n2
  l24 = rect li xspan=(x3 + L + 0.02, x4 - 0.06) yspan=(pt - WP - 0.12, pt - 0.565 - WP2 + 0.09) net=n2
  l25 = rect li xspan=(x3 + L + 0.02, x4 - 0.045) yspan=(pt - WP - 0.115, pt - 0.565 - WP2 + 0.09) net=n2
  l26 = rect li xspan=(x3 + L + 0.02, x4 - 0.02) yspan=(pt - WP - 0.105, pt - 0.565 - WP2 + 0.09) net=n2
  l27 = rect li xspan=(x3 + L + 0.025, x6 + 0.015) yspan=(nb + WN + 0.5, pt - 0.565 - WP2 + 0.1) net=n2
  l28 = rect li xspan=(x3 + L + 0.04, x6 + 0.015) yspan=(nb + WN + 0.5, pt - 0.565 - WP2 + 0.135) net=n2
  l29 = rect li xspan=(x3 + L + 0.055, x6 + 0.015) yspan=(nb + WN + 0.5, pt - 0.565 - 0.035) net=n2
  l30 = rect li xspan=(x6 - 0.115, x6 + L - 0.03) yspan=(nb + WN + 0.105, pt - 0.565 - WP2 + 0.09) net=n2
  l31 = rect li xspan=(x2 + L - 0.04, x5 + 0.065) yspan=(pt - 0.565 + 0.205, pt - 0.02) net=B
  l32 = rect li xspan=(x6 + L + 0.04, x6 + L + 0.315) yspan=(pt - 0.565 - 0.155, pt - 0.02) net=X
  l33 = rect li xspan=(x6 + L + 0.055, x6 + L + 0.315) yspan=(nb + 0.02, nb + WN2 + 0.08) net=X
  l34 = rect li xspan=(x6 + L + 0.145, x6 + L + 0.315) yspan=(nb + 0.02, pt - 0.02) net=X
  l35 = rect li xspan=(x1 - 0.315, x2 - 0.07) yspan=(pt - 0.565 + 0.06, H - 0.085) net=VPWR
  l36 = rect li xspan=(x1 + L - 0.03, x3 + 0.03) yspan=(pt - 0.565 - 0.21, pt - 0.565 + 0.035) net=VPWR
  l37 = rect li xspan=(x1 + L - 0.03, x2 - 0.06) yspan=(pt - 0.565 - 0.21, pt - 0.565 + 0.16) net=VPWR
  l38 = rect li xspan=(x5 + L + 0.09, x6 + 0.015) yspan=(pt - 0.565 + 0.17, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.06, nb + WN2 - 0.19) net=n2
  c2 = array licon in=nd2 cx=(x6 - 0.14) span=(-0.085 + 0.08, nb + WN2 - 0.03 - 0.08) net=VGND
  c3 = array licon in=nd2 cx=(x6 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN2 + 0.08 - 0.08) net=X
  c4 = array licon in=pd1 cx=(x1 - 0.14) span=(nb + WN + 0.305 + 0.08, pt - 0.565 - 0.11 - 0.08) net=n2
  c5 = array licon in=pd1 cx=(x4 + 0.03) span=(nb + WN + 0.5 + 0.08, pt - 0.565 - 0.035 - 0.08) margin=0.04 net=n2
  c6 = array licon in=pd1 cx=(x2 - 0.08) span=(pt - 0.565 - 0.21, pt - 0.565 + 0.035) margin=0.04 net=VPWR
  c7 = array licon in=pd3 cx=(x6 + L + 0.14) span=(pt - 0.565 - 0.155 + 0.08, pt - 0.02 - 0.08) net=X
  c8 = array licon in=pd3 cx=(x6 - 0.14) span=(pt - 0.565 + 0.17 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.14) cy=(nb + WN + 0.045)
  gc2 = contact licon cx=(x5 + 0.03) cy=(nb + WN + 0.245)
  gc3 = contact licon cx=(x6 + 0.035) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x3 + L - 0.015) cy=(pt - 0.19)
  np1 = rect npc xspan=(x1 - 0.4, x1 + 0.05) yspan=(nb + WN2 + 0.09, pt - WP - 0.14)
  np2 = rect npc xspan=(x1 - 0.4, x6 + L + 0.4) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  np3 = rect npc xspan=(x4 + 0.01, x5 + L + 0.07) yspan=(nb + WN + 0.06, pt - WP - 0.14)
  np4 = rect npc xspan=(x1 - 0.02, x5 + 0.065) yspan=(pt - 0.565 + 0.18, pt + 0.045)
  # metal
  mc1 = contact mcon cx=(x1 - 0.17) cy=0
  mc2 = contact mcon cx=(x2 - 0.07) cy=0
  mc3 = contact mcon cx=(x4 + 0.035) cy=0
  mc4 = contact mcon cx=(x6 - 0.15) cy=0
  mc5 = contact mcon cx=(x6 + L + 0.17) cy=0
  mc6 = contact mcon cx=(x1 - 0.17) cy=H
  mc7 = contact mcon cx=(x2 - 0.07) cy=H
  mc8 = contact mcon cx=(x4 + 0.035) cy=H
  mc9 = contact mcon cx=(x6 - 0.15) cy=H
  mc10 = contact mcon cx=(x6 + L + 0.17) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l2
  port B in on=l31
  port C in on=l3
  port X out on=l32
end
