# and2_1: lifted from sky130_fd_sc_hd__and2_1 by icdsl.lift (hd variant)
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1 WP2=0.42 L=0.15 H=2.72

stdcell and2_1 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=n1 s=X b=VNB
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1 b=VPB
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2 b=VNB
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR b=VPB
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND b=VNB
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.58
  x2 = x1 + L + 0.28
  x3 = x2 + L + 0.4
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  # diffusion
  nd1 = rect diff xspan=(x1 - 0.285, x3 + L + 0.285) yspan=(nb + 0.14, nb + 0.14 + WN2)
  nd2 = rect diff xspan=(x2 + L + 0.135, x3 + L + 0.285) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.285, x3 + L + 0.48) yspan=(pt - 0.21 - WP2, pt - 0.21)
  pd2 = rect diff xspan=(x2 + L + 0.085, x3 + L + 0.48) yspan=(pt - WP, pt - 0.21)
  pd3 = rect diff xspan=(x2 + L + 0.135, x3 + L + 0.48) yspan=(pt - WP, pt)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # poly: gates, pads and jogs
  p1 = rect poly xspan=(x1 - 0.29, x1 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p2 = rect poly xspan=(x1, x1 + L) yspan=(nb + 0.01, pt - 0.08)
  p3 = rect poly xspan=(x2, x2 + L) yspan=(nb + 0.01, pt - 0.08)
  p4 = rect poly xspan=(x2, x2 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  p5 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  p6 = rect poly xspan=(x3, x3 + L + 0.185) yspan=(nb + WN + 0.11, pt - WP - 0.16)
  # local interconnect
  l1 = rect li xspan=(x2 + L + 0.095, x3 - 0.055) yspan=(-0.085, nb + 0.14 + 0.17) net=VGND
  l2 = rect li xspan=(x2, x2 + L + 0.195) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=B
  l3 = rect li xspan=(x1 - 0.48, x1 + L + 0.055) yspan=(pt - WP - 0.41, pt - WP - 0.16) net=A
  l4 = rect li xspan=(x1 - 0.48, x1 - 0.215) yspan=(pt - WP - 0.41, pt - 0.21 - WP2 - 0.17) net=A
  l5 = rect li xspan=(x1 - 0.295, x1 + 0.04) yspan=(nb + 0.14 - 0.02, pt - WP - 0.58) net=n1
  l6 = rect li xspan=(x1 - 0.295, x3 + L - 0.01) yspan=(nb + 0.14 + WN2 - 0.08, pt - WP - 0.58) net=n1
  l7 = rect li xspan=(x1 + L + 0.015, x2 + 0.04) yspan=(pt - WP + 0.09, pt - 0.21 + 0.02) net=n1
  l8 = rect li xspan=(x1 + L + 0.015, x3 + L - 0.01) yspan=(pt - WP + 0.09, pt - 0.21 - WP2 - 0.11) net=n1
  l9 = rect li xspan=(x3 - 0.035, x3 + L - 0.01) yspan=(nb + 0.14 + WN2 - 0.08, pt - 0.21 - WP2 - 0.11) net=n1
  l10 = rect li xspan=(x3 - 0.035, x3 + L + 0.115) yspan=(nb + WN + 0.11, pt - WP - 0.16) net=n1
  l11 = rect li xspan=(x3 + L - 0.03, x3 + L + 0.535) yspan=(nb + 0.02, nb + 0.14 + 0.17) net=X
  l12 = rect li xspan=(x3 + L + 0.075, x3 + L + 0.535) yspan=(pt - 0.21 - WP2 + 0.06, pt - 0.02) net=X
  l13 = rect li xspan=(x3 + L + 0.285, x3 + L + 0.535) yspan=(nb + 0.02, pt - 0.02) net=X
  l14 = rect li xspan=(x1 - 0.295, x1 - 0.015) yspan=(pt - 0.21 - WP2 + 0.11, H + 0.085) net=VPWR
  l15 = rect li xspan=(x2 + L + 0.095, x3 + 0.03) yspan=(pt - 0.21 - WP2 + 0.06, H + 0.085) net=VPWR
  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates
  c1 = array licon in=nd2 cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + 0.14 + 0.17 - 0.08) net=VGND
  c2 = array licon in=nd2 cx=(x3 + L + 0.14) span=(nb + 0.02, nb + 0.14 + 0.17) margin=0.04 net=X
  c3 = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.14 - 0.02 + 0.08, pt - WP - 0.58 - 0.08) margin=0.04 net=n1
  c4 = array licon in=pd3 cx=(x3 - 0.14) span=(pt - 0.21 - WP2 + 0.06, H + 0.085) net=VPWR
  c5 = array licon in=pd3 cx=(x3 + L + 0.24) span=(pt - 0.21 - WP2 + 0.06, pt - 0.02) margin=0.04 net=X
  c6 = array licon in=pd1 cx=(x1 - 0.14) span=(pt - 0.21 - WP2 + 0.11 + 0.08, H + 0.085 - 0.08) margin=0.04 net=VPWR
  c7 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.09 + 0.08, pt - 0.21 + 0.02 - 0.08) margin=0.04 net=n1
  gc1 = contact licon cx=(x1 - 0.125) cy=(pt - WP - 0.325)
  gc2 = contact licon cx=(x2 + L + 0.02) cy=(pt - WP - 0.325)
  gc3 = contact licon cx=(x3 + L + 0.02) cy=(pt - WP - 0.325)
  np1 = rect npc xspan=(x1 - 0.58, x3 + L + 0.62) yspan=(nb + WN + 0.09, pt - WP - 0.14)
  # metal
  mc1 = contact mcon cx=(x1 - 0.35) cy=0
  mc2 = contact mcon cx=(x1 + L - 0.035) cy=0
  mc3 = contact mcon cx=(x2 + L + 0.01) cy=0
  mc4 = contact mcon cx=(x3 + L/2) cy=0
  mc5 = contact mcon cx=(x3 + L + 0.39) cy=0
  mc6 = contact mcon cx=(x1 - 0.35) cy=H
  mc7 = contact mcon cx=(x1 + L - 0.035) cy=H
  mc8 = contact mcon cx=(x2 + L + 0.01) cy=H
  mc9 = contact mcon cx=(x3 + L/2) cy=H
  mc10 = contact mcon cx=(x3 + L + 0.39) cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in on=l3
  port B in on=l2
  port X out on=l13
end
