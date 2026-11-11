# clkdlybuf4s15_1: lifted from sky130_fd_sc_hd__clkdlybuf4s15_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.82 L=0.15 H=2.72

stdcell clkdlybuf4s15_1 width=9 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=n2 s=VPWR b=VPB
  device M1 pmos w=WP l=L d=n3 g=A s=VPWR b=VPB
  device M2 pmos w=WP2 l=L d=VPWR g=n3 s=n2 b=VPB
  device M3 nmos w=WN2 l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=n1 s=X b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M6 nmos w=WN l=L d=VGND g=n3 s=n2 b=VNB
  device M7 nmos w=WN l=L d=n1 g=n2 s=VGND b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.72
  x3 = x2 + L + 0.835
  x4 = x3 + L + 0.72
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.27) yspan=(nb, nb + WN2)
  nd2 = rect diff xspan=(x1 + L + 0.08, x2 + L + 0.27) yspan=(nb, nb + WN)
  nd3 = rect diff xspan=(x3 - 0.27, x4 - 0.115) yspan=(nb, nb + WN)
  nd4 = rect diff xspan=(x3 - 0.27, x4 + L + 0.27) yspan=(nb, nb + WN2)
  pd1 = rect diff xspan=(x1 - 0.27, x2 - 0.105) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x1 - 0.27, x2 + L + 0.27) yspan=(pt - WP2, pt)
  pd3 = rect diff xspan=(x3 - 0.27, x4 + L + 0.27) yspan=(pt - WP2, pt)
  pd4 = rect diff xspan=(x3 + L + 0.165, x4 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.175, x1 + L + 0.015) yspan=(nb + WN + 0.14, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x1 + L + 0.225, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.19)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.235, x3 + L + 0.325) yspan=(nb + WN + 0.115, pt - WP - 0.155)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.185, x4 + L) yspan=(nb + WN + 0.115, pt - WP - 0.155)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.05, x2 - 0.355) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l2 = rect li xspan=(x3 + L + 0.33, x4 - 0.06) yspan=(-0.085, nb + WN2 - 0.11) net=VGND
  l3 = rect li xspan=(x1 - 0.32, x1 + L + 0.015) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  l4 = rect li xspan=(x1 - 0.32, x1 + 0.025) yspan=(nb + 0.02, nb + WN) net=n3
  l5 = rect li xspan=(x1 - 0.32, x2 - 0.05) yspan=(nb + WN2 + 0.06, nb + WN) net=n3
  l6 = rect li xspan=(x1 - 0.32, x1 + 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=n3
  l7 = rect li xspan=(x1 - 0.32, x2 - 0.05) yspan=(pt - WP + 0.01, pt - WP2) net=n3
  l8 = rect li xspan=(x1 + L + 0.185, x2 - 0.05) yspan=(nb + WN2 + 0.06, pt - WP2) net=n3
  l9 = rect li xspan=(x2 + L - 0.025, x2 + L + 0.355) yspan=(nb + 0.02, nb + WN - 0.06) net=n2
  l10 = rect li xspan=(x2 + L - 0.025, x2 + L + 0.355) yspan=(pt - WP2 + 0.17, pt - 0.02) net=n2
  l11 = rect li xspan=(x2 + L + 0.185, x2 + L + 0.355) yspan=(nb + 0.02, pt - 0.02) net=n2
  l12 = rect li xspan=(x2 + L + 0.185, x3 + L + 0.305) yspan=(nb + WN + 0.17, pt - WP - 0.235) net=n2
  l13 = rect li xspan=(x3 - 0.31, x3 + 0.025) yspan=(nb + 0.02, nb + WN) net=n1
  l14 = rect li xspan=(x3 - 0.31, x4 + L - 0.05) yspan=(nb + WN2 + 0.06, nb + WN) net=n1
  l15 = rect li xspan=(x3 - 0.31, x3 + L + 0.03) yspan=(pt - WP - 0.065, pt - 0.02) net=n1
  l16 = rect li xspan=(x3 - 0.31, x4 + L - 0.05) yspan=(pt - WP - 0.065, pt - WP2 - 0.075) net=n1
  l17 = rect li xspan=(x4 - 0.245, x4 + L - 0.05) yspan=(nb + WN2 + 0.06, pt - WP2 - 0.075) net=n1
  l18 = rect li xspan=(x4 + L - 0.035, x4 + L + 0.355) yspan=(nb + 0.05, nb + WN2 - 0.11) net=X
  l19 = rect li xspan=(x4 + L - 0.035, x4 + L + 0.355) yspan=(pt - WP2 + 0.095, pt - 0.02) net=X
  l20 = rect li xspan=(x4 + L + 0.125, x4 + L + 0.355) yspan=(nb + 0.05, pt - 0.02) net=X
  l21 = rect li xspan=(x1 + L + 0.05, x2 - 0.34) yspan=(pt - WP2 + 0.17, H + 0.085) net=VPWR
  l22 = rect li xspan=(x3 + L + 0.26, x4 - 0.06) yspan=(pt - WP2 + 0.095, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.02, nb + WN) net=n3
  c2 = array licon in=nd2 cx=(x1 + L + 0.2) span=(-0.085 + 0.08, nb + WN2 - 0.11 - 0.08) net=VGND
  c3 = array licon in=nd2 cx=(x2 + L + 0.145) span=(nb + 0.02, nb + WN - 0.06) net=n2
  c4 = array licon in=nd3 cx=(x3 - 0.145) span=(nb + 0.02, nb + WN) net=n1
  c5 = array licon in=nd3 cx=(x4 - 0.225) span=(-0.085, nb + WN2 - 0.11) net=VGND
  c6 = array licon in=nd4 cx=(x4 + L + 0.145) span=(nb + 0.05, nb + WN2 - 0.11) net=X
  c7 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.01, pt - 0.02) net=n3
  c8 = array licon in=pd1 cx=(x1 + L + 0.215) span=(pt - WP2 + 0.17, H + 0.085) margin=0.04 net=VPWR
  c9 = array licon in=pd2 cx=(x2 + L + 0.145) span=(pt - WP2 + 0.17, pt - 0.02) net=n2
  c10 = array licon in=pd3 cx=(x3 - 0.145) span=(pt - WP - 0.065, pt - 0.02) net=n1
  c11 = array licon in=pd4 cx=(x4 - 0.225) span=(pt - WP2 + 0.095, H + 0.085) margin=0.04 net=VPWR
  c12 = array licon in=pd4 cx=(x4 + L + 0.145) span=(pt - WP2 + 0.095, pt - 0.02) net=X
  gc1 = contact licon cx=(x1 - 0.01) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.33) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 - 0.07) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x3 + L + 0.13) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x4 - 0.02) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x4 + L + 0.44) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 - 0.115) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.205) cy=0
  mc5 = contact mcon cx=(x3 - 0.17) cy=0
  mc6 = contact mcon cx=(x3 + L + 0.15) cy=0
  mc7 = contact mcon cx=(x4 - 0.11) cy=0
  mc8 = contact mcon cx=(x4 + L + 0.21) cy=0
  mc9 = contact mcon cx=(x1 - 0.175) cy=H
  mc10 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc11 = contact mcon cx=(x2 - 0.115) cy=H
  mc12 = contact mcon cx=(x2 + L + 0.205) cy=H
  mc13 = contact mcon cx=(x3 - 0.17) cy=H
  mc14 = contact mcon cx=(x3 + L + 0.15) cy=H
  mc15 = contact mcon cx=(x4 - 0.11) cy=H
  mc16 = contact mcon cx=(x4 + L + 0.21) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port X out on=l20
end
