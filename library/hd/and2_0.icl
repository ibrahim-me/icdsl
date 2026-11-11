# and2_0: lifted from sky130_fd_sc_hd__and2_0 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.42 WP=0.64 WP2=0.42 L=0.15 H=2.72

stdcell and2_0 width=6 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=B s=VPWR b=VPB
  device M1 nmos w=WN l=L d=n2 g=B s=VGND b=VNB
  device M2 nmos w=WN l=L d=n1 g=A s=n2 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M4 pmos w=WP2 l=L d=VPWR g=A s=n1 b=VPB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.47
  x2 = x1 + L + 0.22
  x3 = x2 + 0.08
  x4 = x3 + L + 0.39
  x5 = x4 + L + 0.1
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.03) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.27, x5 + L + 0.27) yspan=(pt - WP2, pt)
  pd2 = rect diff xspan=(x3 + L + 0.135, x5 + L + 0.27) yspan=(pt - WP, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1, pd2] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.555, pt - WP + 0.035)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(0.105, pt - WP - 0.135)
  p4 = rect poly xspan=(x2, x4 - 0.17) yspan=(nb + WN + 0.39, pt - WP - 0.135)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(nb + WN + 0.39, H - 0.105)
  p6 = rect poly xspan=(x4, x4 + L) yspan=(0.105, nb + WN + 0.26)
  p7 = rect poly xspan=(x4 + 0.045, x5) yspan=(nb + WN + 0.11, pt - WP - 0.41)
  p8 = rect poly xspan=(x5, x5 + L) yspan=(nb + WN + 0.11, H - 0.105)
  # local interconnect
  l1 = rect li xspan=(x2 + L - 0.025, x4 - 0.05) yspan=(-0.085, nb + WN - 0.13) net=VGND
  l2 = rect li xspan=(x2 + L/2 + 0.04, x4 - 0.17) yspan=(nb + WN + 0.425, pt - WP - 0.23) net=B
  l3 = rect li xspan=(x1 - 0.385, x1 - 0.04) yspan=(pt - WP - 0.66, pt - WP + 0.11) net=A
  l4 = rect li xspan=(x1 - 0.285, x1 + 0.025) yspan=(nb + 0.045, nb + WN + 0.295) net=n1
  l5 = rect li xspan=(x1 - 0.285, x5 + L - 0.045) yspan=(nb + WN + 0.04, nb + WN + 0.255) net=n1
  l6 = rect li xspan=(x1 - 0.285, x2 - 0.06) yspan=(nb + WN + 0.04, nb + WN + 0.295) net=n1
  l7 = rect li xspan=(x1 + L - 0.015, x2 - 0.06) yspan=(nb + WN + 0.04, pt - 0.02) net=n1
  l8 = rect li xspan=(x1 + L - 0.015, x2 + 0.04) yspan=(pt - WP2 + 0.07, pt - 0.02) net=n1
  l9 = rect li xspan=(x4 + 0.015, x5 + L - 0.045) yspan=(nb + WN + 0.04, pt - WP - 0.41) net=n1
  l10 = rect li xspan=(x4 + L - 0.025, x5 + L + 0.395) yspan=(nb + 0.02, nb + WN - 0.13) net=X
  l11 = rect li xspan=(x5 + L - 0.035, x5 + L + 0.395) yspan=(pt - WP - 0.01, pt - 0.02) net=X
  l12 = rect li xspan=(x5 + L + 0.13, x5 + L + 0.395) yspan=(nb + 0.02, pt - 0.02) net=X
  l13 = rect li xspan=(x1 - 0.31, x1 - 0.04) yspan=(pt - WP2 + 0.11, H + 0.085) net=VPWR
  l14 = rect li xspan=(x3 + L + 0.06, x4 + L + 0.04) yspan=(pt - WP - 0.01, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd1 cx=(x3 + L + 0.13) span=(-0.085, nb + WN - 0.13) margin=0.04 net=VGND
  c2 = array licon in=nd1 cx=(x5 + 0.05) span=(nb + 0.02, nb + WN - 0.13) net=X
  c3 = array licon in=nd1 cx=(x1 - 0.145) span=(nb + 0.045 + 0.08, nb + WN + 0.295 - 0.08) net=n1
  c4 = array licon in=pd2 cx=(x4 + L - 0.06) span=(pt - WP - 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c5 = array licon in=pd2 cx=(x5 + L + 0.145) span=(pt - WP - 0.01, pt - 0.02) net=X
  c6 = array licon in=pd1 cx=(x2 - 0.065) span=(pt - WP2 + 0.07 + 0.08, pt - 0.02 - 0.08) margin=0.04 net=n1
  c7 = array licon in=pd1 cx=(x1 - 0.145) span=(pt - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) net=VPWR
  c8 = array licon in=pd1 cx=(x3 + L + 0.145) span=(pt - WP - 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c9 = array licon in=pd2 cx=(x4 + L - 0.05) span=(pt - WP - 0.01 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  gc1 = contact licon cx=(x4 + L + 0.035) cy=(nb + WN + 0.275)
  gc2 = contact licon cx=(x3 + L + 0.055) cy=(nb + WN + 0.525)
  gc3 = contact licon cx=(x4 + L + 0.035) cy=(nb + WN + 0.615)
  gc4 = contact licon cx=(x1 - 0.125) cy=(pt - WP - 0.47)
  gc5 = contact licon cx=(x3 + L + 0.055) cy=(pt - WP - 0.325)
  gc6 = contact licon cx=(x1 - 0.125) cy=(pt - WP - 0.13)
  np1 = rect npc xspan=(x1 - 0.47, x5 + L + 0.48) yspan=(nb + WN + 0.32, pt - WP - 0.5)
  np2 = rect npc xspan=(x1 - 0.47, x1 + 0.065) yspan=(nb + WN + 0.32, pt - WP - 0.13)
  np3 = rect npc xspan=(x1 - 0.31, x1 + 0.065) yspan=(nb + WN + 0.32, pt - WP + 0.055)
  np4 = rect npc xspan=(x3 + 0.015, x4 - 0.01) yspan=(nb + WN + 0.32, pt - WP - 0.14)
  np5 = rect npc xspan=(x4 - 0.01, x5 + L - 0.025) yspan=(nb + WN + 0.09, pt - WP - 0.39)
  # metal
  mc1 = contact mcon cx=(x1 - 0.24) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.08) cy=0
  mc3 = contact mcon cx=(x3 + L + 0.1) cy=0
  mc4 = contact mcon cx=(x4 + L + 0.03) cy=0
  mc5 = contact mcon cx=(x5 + L + 0.25) cy=0
  mc6 = contact mcon cx=(x1 - 0.24) cy=H
  mc7 = contact mcon cx=(x1 + L + 0.08) cy=H
  mc8 = contact mcon cx=(x3 + L + 0.1) cy=H
  mc9 = contact mcon cx=(x4 + L + 0.03) cy=H
  mc10 = contact mcon cx=(x5 + L + 0.25) cy=H
  well y=(pt - WP - 0.54)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port B in on=l2
  port X out on=l11
end
