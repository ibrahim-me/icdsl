# mux2i_1: Y = (!A0&!S) | (!A1&S)
# tapless, PDK widths; x from gate columns; y from row edges nb/pt; clean over sweep
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell mux2i_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=S s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y b=VPB
  device M3 nmos w=WN l=L d=VGND g=S s=n3 b=VNB
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n1 g=S s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=A1 s=n4 b=VPB
  device M8 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y b=VNB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.605                          # gate S
  x2 = x1 + L + 0.80                  # gate A0 (break between islands)
  x3 = x2 + L + 0.80                  # gate n1 (break between islands)
  x4 = x3 + L + 0.28                  # gate A1
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: p row (separate islands per gate column)
  pdS = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)        # VPWR | n1  (M0)
  pdA0 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)       # n2 | Y     (M2)
  pdN1 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)       # VPWR | n4  (M4)
  pdA1 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)       # n4 | Y     (M7)
  pim = enclose [pdS, pdA0, pdN1, pdA1] psdm

  # diffusion: n row (separate islands per gate column)
  ndS = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)        # n1 | VGND | n3 (M6+M3 share VGND)
  ndA0 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)       # Y | n5     (M9)
  ndN1 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)       # VGND | n5  (M5)
  ndA1 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)       # n3 | Y     (M8)
  nim = enclose [ndS, ndA0, ndN1, ndA1] nsdm

  # poly: gates crossing both rows
  gS  = cross [ndS, pdS] poly w=L cx=x1
  gA0 = cross [ndA0, pdA0] poly w=L cx=x2
  gN1 = cross [ndN1, pdN1] poly w=L cx=x3
  gA1 = cross [ndA1, pdA1] poly w=L cx=x4

  # gate contacts: all at cb height, on the left side of each gate
  cb = max(ndS.top + 0.19, 0.60)
  gcS  = contact licon cx=(x1 - 0.12) bottom=cb net=S
  gcA0 = contact licon cx=(x2 - 0.12) bottom=cb net=A0
  gcN1 = contact licon cx=(x3 - 0.12) bottom=cb net=n1
  gcA1 = contact licon cx=(x4 - 0.12) bottom=cb net=A1
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(ndS.top + 0.09, pt - WP - 0.14)

  # p-row local interconnect: horizontal strips ON the diffusion
  lVPWRpS = rect li xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=VPWR
  ln1pS   = rect li xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=n1
  ln2pA0  = rect li xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=n2
  lYpA0   = rect li xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=Y
  lVPWRpN1 = rect li xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=VPWR
  ln4pN1  = rect li xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=n4
  ln4pA1  = rect li xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=n4
  lYpA1   = rect li xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP + 0.02, pt - 0.02) net=Y

  # p-row local interconnect: vertical strips BETWEEN rows (for gate inputs)
  liS  = rect li xspan=(x1 - 0.285, x1 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=S
  liA0 = rect li xspan=(x2 - 0.285, x2 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A0
  liN1 = rect li xspan=(x3 - 0.285, x3 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n1
  liA1 = rect li xspan=(x4 - 0.285, x4 - 0.055) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A1

  # n-row local interconnect: horizontal strips ON the diffusion
  ln1nS  = rect li xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=n1
  lVGNDnS = rect li xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=VGND
  ln3nS  = rect li xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  lYnA0  = rect li xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=Y
  ln5nA0 = rect li xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=n5
  lVGNDnN1 = rect li xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=VGND
  ln5nN1 = rect li xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=n5
  ln3nA1 = rect li xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=n3
  lYnA1  = rect li xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb + 0.02, nb + WN - 0.02) net=Y

  # n-row local interconnect: supply rails extending up/down
  lVGNDnS_up = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  lVGNDnN1_up = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  lVPWRpS_up = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  lVPWRpN1_up = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR

  # internal net routes: n1 (M0.d -> M4.g/M5.g), n2 (M1.s -> M2.d), n4 (M4.d -> M7.s)
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2

  # diffusion contacts: p row
  cVPWRpS = array licon in=pdS cx=(x1 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn1pS   = array licon in=pdS cx=(x1 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=n1
  cn2pA0  = array licon in=pdA0 cx=(x2 - L - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=n2
  cYpA0   = array licon in=pdA0 cx=(x2 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=Y
  cVPWRpN1 = array licon in=pdN1 cx=(x3 - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn4pN1  = array licon in=pdN1 cx=(x3 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=n4
  cn4pA1  = array licon in=pdA1 cx=(x4 - L - 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=n4
  cYpA1   = array licon in=pdA1 cx=(x4 + L + 0.14) span=(pt - WP + 0.02 + 0.08, pt - 0.02 - 0.08) net=Y

  # diffusion contacts: n row
  cn1nS   = array licon in=ndS cx=(x1 - L - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=n1
  cVGNDnS = array licon in=ndS cx=(x1 + 0.0) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=VGND
  cn3nS   = array licon in=ndS cx=(x1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=n3
  cYnA0   = array licon in=ndA0 cx=(x2 - L - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=Y
  cn5nA0  = array licon in=ndA0 cx=(x2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=n5
  cVGNDnN1 = array licon in=ndN1 cx=(x3 - L - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=VGND
  cn5nN1  = array licon in=ndN1 cx=(x3 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=n5
  cn3nA1  = array licon in=ndA1 cx=(x4 - L - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=n3
  cYnA1   = array licon in=ndA1 cx=(x4 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.02 - 0.08) net=Y

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # metal: supply rails contacts
  mcVGND1 = contact mcon cx=(x1 - 0.375) cy=0
  mcVGND2 = contact mcon cx=(x3 - 0.375) cy=0
  mcVPWR1 = contact mcon cx=(x1 - 0.375) cy=H
  mcVPWR2 = contact mcon cx=(x3 - 0.375) cy=H

  # straps: supply li to rails
  strap li from=lVGNDnS_up to=vgnd_li
  strap li from=lVGNDnN1_up to=vgnd_li
  strap li from=lVPWRpS_up to=vpwr_li
  strap li from=lVPWRpN1_up to=vpwr_li

  # pins
  port S in on=liS
  port A0 in on=liA0
  port A1 in on=liA1
  port Y out on=lYpA0
end
