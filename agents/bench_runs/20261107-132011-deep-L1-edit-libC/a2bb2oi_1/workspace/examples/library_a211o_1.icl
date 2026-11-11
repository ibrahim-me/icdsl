# a211o_1: lifted from sky130_fd_sc_hd__a211o_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WP=1 L=0.15 H=2.72

stdcell a211o_1 width=9 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=A2 s=n1 b=VNB
  device M1 pmos w=WP l=L d=X g=n2 s=VPWR b=VPB
  device M2 nmos w=WN l=L d=X g=n2 s=VGND b=VNB
  device M3 nmos w=WN l=L d=n1 g=A1 s=n2 b=VNB
  device M4 nmos w=WN l=L d=n2 g=B1 s=VGND b=VNB
  device M5 pmos w=WP l=L d=n3 g=C1 s=n2 b=VPB
  device M6 nmos w=WN l=L d=VGND g=C1 s=n2 b=VNB
  device M7 pmos w=WP l=L d=VPWR g=A1 s=n4 b=VPB
  device M8 pmos w=WP l=L d=n4 g=A2 s=VPWR b=VPB
  device M9 pmos w=WP l=L d=n4 g=B1 s=n3 b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.81
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.32
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.27) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x1 + L + 0.27) yspan=(pt - WP, pt)
  pd2 = rect diff xspan=(x2 - 0.27, x5 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p2 = rect poly xspan=(x1, x1 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p3 = rect poly xspan=(x2 - 0.275, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p4 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3 - 0.075, x3 + L + 0.055) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p6 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x4 - 0.025, x4 + L + 0.105) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p8 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x5, x5 + L + 0.275) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x1 + L + 0.06, x2) yspan=(-0.085, nb + 0.22) net=VGND
  l2 = rect li xspan=(x4 + L - 0.01, x5 + 0.01) yspan=(-0.085, nb + 0.22) net=VGND
  l3 = rect li xspan=(x2 - 0.33, x2 - 0.05) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A2
  l4 = rect li xspan=(x2 + L - 0.015, x3 + L + 0.135) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=A1
  l5 = rect li xspan=(x4 + 0.03, x5 + 0.005) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=B1
  l6 = rect li xspan=(x5 + L + 0.04, x5 + L + 0.31) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=C1
  l7 = rect li xspan=(x1 - 0.315, x1 - 0.05) yspan=(nb + 0.03, pt - 0.03) net=X
  l8 = rect li xspan=(x1 - 0.315, x1 + 0.025) yspan=(nb + 0.03, pt - WP + 0.2) net=X
  l9 = rect li xspan=(x2 - 0.31, x4 + 0.025) yspan=(pt - 0.62, pt - 0.39) net=n4
  l10 = rect li xspan=(x2 - 0.31, x2 - 0.05) yspan=(pt - 0.62, pt - 0.03) net=n4
  l11 = rect li xspan=(x3 + L + 0.05, x4 + 0.025) yspan=(pt - 0.62, pt - 0.03) net=n4
  l12 = rect li xspan=(x1 + L + 0.055, x5 + L + 0.27) yspan=(nb + 0.39, nb + WN - 0.07) net=n2
  l13 = rect li xspan=(x1 + L + 0.055, x1 + L + 0.28) yspan=(nb + 0.39, pt - WP + 0.2) net=n2
  l14 = rect li xspan=(x1 + L + 0.055, x5 + L + 0.28) yspan=(pt - WP + 0.02, pt - WP + 0.2) net=n2
  l15 = rect li xspan=(x3 + L - 0.015, x4 - 0.045) yspan=(nb + 0.03, nb + WN - 0.07) net=n2
  l16 = rect li xspan=(x5 + L - 0.015, x5 + L + 0.28) yspan=(pt - WP + 0.02, pt - 0.03) net=n2
  l17 = rect li xspan=(x5 + L + 0.045, x5 + L + 0.27) yspan=(nb + 0.03, nb + WN - 0.07) net=n2
  l18 = rect li xspan=(x1 + L - 0.025, x1 + L + 0.31) yspan=(pt - 0.57, H + 0.085) net=VPWR
  l19 = rect li xspan=(x2 + L - 0.025, x3 + 0.025) yspan=(pt - 0.22, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 + L + 0.225) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x2 - 0.225) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x4 + L + 0.16) span=(-0.085, nb + 0.22) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.03 + 0.08, pt - 0.03 - 0.08) net=X
  c5 = array licon in=nd1 cx=(x3 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) margin=0.04 net=n2
  c6 = array licon in=nd1 cx=(x5 + L + 0.145) span=(nb + 0.03 + 0.08, nb + WN - 0.07 - 0.08) net=n2
  c7 = array licon in=pd1 cx=(x1 - 0.145) span=(nb + 0.03 + 0.08, pt - 0.03 - 0.08) net=X
  c8 = array licon in=pd2 cx=(x5 + L + 0.145) span=(pt - WP + 0.02 + 0.08, pt - 0.03 - 0.08) net=n2
  c9 = array licon in=pd2 cx=(x2 - 0.145) span=(pt - 0.62 + 0.08, pt - 0.03 - 0.08) net=n4
  c10 = array licon in=pd2 cx=(x3 + L + 0.145) span=(pt - 0.62 + 0.08, pt - 0.03 - 0.08) margin=0.04 net=n4
  c11 = array licon in=pd1 cx=(x1 + L + 0.145) span=(pt - 0.57, H + 0.085) net=VPWR
  c12 = array licon in=pd2 cx=(x2 + L + 0.145) span=(pt - 0.22, H + 0.085) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x1 + L + 0.14) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x2 - 0.14) cy=(nb + WN + 0.275)
  gc3 = contact licon cx=(x3 + 0.065) cy=(nb + WN + 0.275)
  gc4 = contact licon cx=(x4 + L - 0.035) cy=(nb + WN + 0.275)
  gc5 = contact licon cx=(x5 + L + 0.14) cy=(nb + WN + 0.275)
  np1 = rect npc xspan=(x1 - 0.405, x5 + L + 0.405) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x2 - 0.205) cy=0
  mc4 = contact mcon cx=(x2 + L + 0.115) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.145) cy=0
  mc6 = contact mcon cx=(x5 - 0.145) cy=0
  mc7 = contact mcon cx=(x5 + L + 0.175) cy=0
  mc8 = contact mcon cx=(x1 - 0.175) cy=H
  mc9 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc10 = contact mcon cx=(x2 - 0.205) cy=H
  mc11 = contact mcon cx=(x2 + L + 0.115) cy=H
  mc12 = contact mcon cx=(x3 + L + 0.145) cy=H
  mc13 = contact mcon cx=(x5 - 0.145) cy=H
  mc14 = contact mcon cx=(x5 + L + 0.175) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A1 in on=l4
  port A2 in on=l3
  port B1 in on=l5
  port C1 in on=l6
  port X out on=l7
end
