# clkbuf_8: lifted from sky130_fd_sc_hd__clkbuf_8 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=1 L=0.15 H=2.72

stdcell clkbuf_8 width=14 height=H taps=no
  device M0 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR b=VPB
  device M2 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M3 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M4 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M5 nmos w=WN l=L d=VGND g=A s=n1 b=VNB
  device M6 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M7 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M9 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M10 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M11 nmos w=WN l=L d=X g=n1 s=VGND b=VNB
  device M12 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M13 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M14 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB
  device M15 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M16 pmos w=WP l=L d=X g=n1 s=VPWR b=VPB
  device M17 nmos w=WN l=L d=n1 g=A s=VGND b=VNB
  device M18 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M19 nmos w=WN l=L d=VGND g=n1 s=X b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.405
  x2 = x1 + L + 0.29
  x3 = x2 + L + 0.29
  x4 = x3 + L + 0.29
  x5 = x4 + L + 0.29
  x6 = x5 + L + 0.29
  x7 = x6 + L + 0.29
  x8 = x7 + L + 0.29
  x9 = x8 + L + 0.29
  x10 = x9 + L + 0.29
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x10 + L + 0.275) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x10 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.3, x2 + L) yspan=(nb + WN + 0.245, pt - WP - 0.075)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  p4 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p5 = rect poly xspan=(x3, x10 + L) yspan=(nb + WN + 0.295, pt - WP - 0.16)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  p7 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  p8 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  p9 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  p10 = rect poly xspan=(x8, x8 + L) yspan=(0.105, H - 0.105)
  p11 = rect poly xspan=(x9, x9 + L) yspan=(0.105, H - 0.105)
  p12 = rect poly xspan=(x10, x10 + L) yspan=(0.105, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x1 - 0.26, x1 - 0.015) yspan=(-0.085, nb + WN - 0.11) net=VGND
  l2 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(-0.085, nb + WN - 0.045) net=VGND
  l3 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l4 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l5 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l6 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.315) yspan=(-0.085, nb + WN - 0.09) net=VGND
  l7 = rect li xspan=(x1 - 0.32, x1) yspan=(nb + WN + 0.06, pt - WP - 0.16) net=A
  l8 = rect li xspan=(x1 + L + 0.025, x2 - 0.015) yspan=(nb + 0.03, pt - 0.025) net=n1
  l9 = rect li xspan=(x1 + L + 0.025, x8 + L + 0.035) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=n1
  l10 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(nb + 0.045, nb + WN + 0.25) net=X
  l11 = rect li xspan=(x3 + L + 0.015, x10 + L + 0.315) yspan=(nb + WN + 0.08, nb + WN + 0.25) net=X
  l12 = rect li xspan=(x3 + L + 0.015, x10 + L + 0.315) yspan=(pt - WP + 0.01, pt - WP + 0.25) net=X
  l13 = rect li xspan=(x3 + L + 0.015, x4 - 0.015) yspan=(pt - WP + 0.01, pt - 0.025) net=X
  l14 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(nb + 0.045, nb + WN + 0.25) net=X
  l15 = rect li xspan=(x5 + L + 0.015, x6 - 0.015) yspan=(pt - WP + 0.01, pt - 0.025) net=X
  l16 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(nb + 0.045, nb + WN + 0.25) net=X
  l17 = rect li xspan=(x7 + L + 0.015, x8 - 0.015) yspan=(pt - WP + 0.01, pt - 0.025) net=X
  l18 = rect li xspan=(x9 - 0.085, x10 + L + 0.315) yspan=(nb + WN + 0.08, pt - WP + 0.25) net=X
  l19 = rect li xspan=(x9 + L + 0.015, x10 - 0.015) yspan=(nb + 0.045, pt - 0.025) net=X
  l20 = rect li xspan=(x1 - 0.31, x1 - 0.015) yspan=(pt - WP + 0.04, H + 0.085) net=VPWR
  l21 = rect li xspan=(x2 + L + 0.015, x3 - 0.015) yspan=(pt - WP + 0.04, H + 0.085) net=VPWR
  l22 = rect li xspan=(x4 + L + 0.015, x5 - 0.015) yspan=(pt - 0.58, H + 0.085) net=VPWR
  l23 = rect li xspan=(x6 + L + 0.015, x7 - 0.015) yspan=(pt - 0.58, H + 0.085) net=VPWR
  l24 = rect li xspan=(x8 + L + 0.015, x9 - 0.015) yspan=(pt - 0.58, H + 0.085) net=VPWR
  l25 = rect li xspan=(x10 + L + 0.015, x10 + L + 0.31) yspan=(pt - 0.58, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x1 - 0.145) span=(-0.085 + 0.08, nb + WN - 0.11 - 0.08) net=VGND
  c2 = array licon in=nd1 cx=(x4 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c3 = array licon in=nd1 cx=(x6 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c4 = array licon in=nd1 cx=(x8 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) margin=0.04 net=VGND
  c5 = array licon in=nd1 cx=(x10 + L + 0.15) span=(-0.085 + 0.08, nb + WN - 0.09 - 0.08) net=VGND
  c6 = array licon in=nd1 cx=(x1 + L + 0.145) span=(nb + 0.03 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n1
  c7 = array licon in=nd1 cx=(x2 + L + 0.145) span=(-0.085 + 0.08, nb + WN - 0.045 - 0.08) margin=0.04 net=VGND
  c8 = array licon in=nd1 cx=(x3 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.25 - 0.08) margin=0.04 net=X
  c9 = array licon in=nd1 cx=(x5 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.25 - 0.08) margin=0.04 net=X
  c10 = array licon in=nd1 cx=(x7 + L + 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.25 - 0.08) margin=0.04 net=X
  c11 = array licon in=nd1 cx=(x9 + L + 0.145) span=(nb + 0.045 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c12 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP + 0.04 + 0.08, H + 0.085 - 0.08) net=VPWR
  c13 = array licon in=pd1 cx=(x1 + L + 0.145) span=(nb + 0.03 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=n1
  c14 = array licon in=pd1 cx=(x2 + L + 0.145) span=(pt - WP + 0.04 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c15 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c16 = array licon in=pd1 cx=(x5 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c17 = array licon in=pd1 cx=(x7 + L + 0.145) span=(pt - WP + 0.01 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c18 = array licon in=pd1 cx=(x9 + L + 0.145) span=(nb + 0.045 + 0.08, pt - 0.025 - 0.08) margin=0.04 net=X
  c19 = array licon in=pd1 cx=(x4 + L + 0.145) span=(pt - 0.58 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c20 = array licon in=pd1 cx=(x6 + L + 0.145) span=(pt - 0.58 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c21 = array licon in=pd1 cx=(x8 + L + 0.145) span=(pt - 0.58 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c22 = array licon in=pd1 cx=(x10 + L + 0.145) span=(pt - 0.58 + 0.08, H + 0.085 - 0.08) net=VPWR
  gc1 = contact licon cx=(x1 - 0.135) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x3 + L + 0.14) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x4 + L + 0.05) cy=(pt - WP - 0.325)
  gc4 = contact licon cx=(x5 + L - 0.045) cy=(pt - WP - 0.325)
  gc5 = contact licon cx=(x6 + 0.015) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x7 - 0.08) cy=(pt - WP - 0.325)
  gc7 = contact licon cx=(x7 + L + 0.12) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.405, x10 + L + 0.645) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.175) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.145) cy=0
  mc3 = contact mcon cx=(x3 - 0.115) cy=0
  mc4 = contact mcon cx=(x4 - 0.085) cy=0
  mc5 = contact mcon cx=(x5 - 0.055) cy=0
  mc6 = contact mcon cx=(x6 - 0.025) cy=0
  mc7 = contact mcon cx=(x7 + 0.01) cy=0
  mc8 = contact mcon cx=(x8 + 0.04) cy=0
  mc9 = contact mcon cx=(x9 + 0.07) cy=0
  mc10 = contact mcon cx=(x10 + L - 0.05) cy=0
  mc11 = contact mcon cx=(x10 + L + 0.415) cy=0
  mc12 = contact mcon cx=(x1 - 0.175) cy=H
  mc13 = contact mcon cx=(x1 + L + 0.145) cy=H
  mc14 = contact mcon cx=(x3 - 0.115) cy=H
  mc15 = contact mcon cx=(x4 - 0.085) cy=H
  mc16 = contact mcon cx=(x5 - 0.055) cy=H
  mc17 = contact mcon cx=(x6 - 0.025) cy=H
  mc18 = contact mcon cx=(x7 + 0.01) cy=H
  mc19 = contact mcon cx=(x8 + 0.04) cy=H
  mc20 = contact mcon cx=(x9 + 0.07) cy=H
  mc21 = contact mcon cx=(x10 + L - 0.05) cy=H
  mc22 = contact mcon cx=(x10 + L + 0.415) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l7
  port X out on=l12
end
