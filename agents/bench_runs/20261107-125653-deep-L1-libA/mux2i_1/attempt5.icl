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
  x2 = x1 + L + 0.80                  # gate A0 (break: n-row n3 vs n5)
  x3 = x2 + L + 0.80                  # gate n1 (break: p-row Y vs VPWR, n-row Y vs VGND)
  x4 = x3 + L + 0.28                  # gate A1 (share n4 on p-row; n-row n5 vs n3 needs break but p-row shares)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: p row (separate islands where nets don't match)
  pdA = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)        # VPWR | n1  (M0)
  pdB = rect diff xspan=(x1 + L + 0.265, x2 - 0.265) yspan=(pt - WP, pt)        # n2 | VPWR  (M1)
  pdC = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)        # n2 | Y     (M2)
  pdD = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)        # VPWR | n4  (M4)
  pdE = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)        # n4 | Y     (M7)
  pim = enclose [pdA, pdB, pdC, pdD, pdE] psdm

  # diffusion: n row (separate islands everywhere)
  ndA = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)        # n1 | VGND  (M6)
  ndB = rect diff xspan=(x1 + L + 0.265, x2 - 0.265) yspan=(nb, nb + WN)        # VGND | n3  (M3)
  ndC = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)        # n5 | Y     (M9)
  ndD = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)        # VGND | n5  (M5)
  ndE = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)        # n3 | Y     (M8)
  nim = enclose [ndA, ndB, ndC, ndD, ndE] nsdm

  # poly: gates crossing both rows
  gS  = cross [ndA, pdA] poly w=L cx=x1
  gA0 = cross [ndC, pdC] poly w=L cx=x2
  gN1 = cross [ndD, pdD] poly w=L cx=x3
  gA1 = cross [ndE, pdE] poly w=L cx=x4

  # gate contacts: all at cb height
  cb = max(ndA.top + 0.19, 0.60)
  gcS  = contact licon cx=(x1 - 0.12) bottom=cb net=S
  gcA0 = contact licon cx=(x2 - 0.12) bottom=cb net=A0
  gcN1 = contact licon cx=(x3 - 0.12) bottom=cb net=n1
  gcA1 = contact licon cx=(x4 - 0.12) bottom=cb net=A1
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(ndA.top + 0.09, pt - WP - 0.14)

  # p-row local interconnect
  lVPWRpA = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=VPWR
  ln2pB   = rect li xspan=(x1 + L + 0.04, x2 - 0.04) yspan=(pt - WP, pt - 0.02) net=n2
  lVPWRpB = rect li xspan=(x1 + L + 0.04, x2 - 0.04) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  ln2pC   = rect li xspan=(x2 - 0.04, x2 + L - 0.04) yspan=(pt - WP, pt - 0.02) net=n2
  lYpC    = rect li xspan=(x2 + L - 0.04, x2 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y
  lVPWRpD = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=VPWR
  ln4pD   = rect li xspan=(x3 + L - 0.03, x3 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=n4
  lVPWRpD2 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR
  ln4pE   = rect li xspan=(x4 - 0.04, x4 + L - 0.04) yspan=(pt - WP, pt - 0.02) net=n4
  lYpE    = rect li xspan=(x4 + L - 0.04, x4 + L + 0.305) yspan=(pt - WP, pt - 0.02) net=Y

  # n-row local interconnect
  lVGNDnA = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(nb + 0.02, nb + WN) net=VGND
  ln1nA   = rect li xspan=(x1 - 0.04, x1 + L + 0.04) yspan=(nb + 0.02, nb + WN) net=n1
  lVGNDnB = rect li xspan=(x1 + L + 0.04, x2 - 0.04) yspan=(nb + 0.02, nb + WN) net=VGND
  ln3nB   = rect li xspan=(x1 + L + 0.04, x2 - 0.04) yspan=(-0.085, nb + WN) net=n3
  ln5nC   = rect li xspan=(x2 - 0.04, x2 + L + 0.04) yspan=(nb + 0.02, nb + WN) net=n5
  lYnC    = rect li xspan=(x2 + L - 0.04, x2 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=Y
  lVGNDnD = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(nb + 0.02, nb + WN) net=VGND
  ln5nD   = rect li xspan=(x3 + L - 0.03, x3 + L + 0.03) yspan=(nb + 0.02, nb + WN) net=n5
  lVGNDnD2 = rect li xspan=(x3 - 0.335, x3 - 0.025) yspan=(-0.085, nb + WN) net=VGND
  ln3nE   = rect li xspan=(x4 - 0.04, x4 + L + 0.04) yspan=(nb + 0.02, nb + WN) net=n3
  lYnE    = rect li xspan=(x4 + L - 0.04, x4 + L + 0.305) yspan=(nb + 0.02, nb + WN) net=Y

  # input gate li strips (vertical, alongside gates, connect gate contact to port)
  liS  = rect li xspan=(x1 - 0.285, x1 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=S
  liA0 = rect li xspan=(x2 - 0.285, x2 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A0
  liN1 = rect li xspan=(x3 - 0.285, x3 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=n1
  liA1 = rect li xspan=(x4 - 0.285, x4 - 0.055) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A1

  # internal net routes: n1 (M0.d -> M4.g/M5.g), n2 (M1.s -> M2.d), n4 (M4.d -> M7.s)
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2

  # diffusion contacts: p row
  cVPWRpA = array licon in=pdA cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn1pA   = array licon in=pdA cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) net=n1
  cn2pB   = array licon in=pdB cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) net=n2
  cVPWRpB = array licon in=pdB cx=(x2 - L - 0.14) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  cn2pC   = array licon in=pdC cx=(x2 - L - 0.14) span=(pt - WP, pt - 0.02) net=n2
  cYpC    = array licon in=pdC cx=(x2 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y
  cVPWRpD = array licon in=pdD cx=(x3 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn4pD   = array licon in=pdD cx=(x3 + L + 0.14) span=(pt - WP, pt - 0.02) net=n4
  cVPWRpD2 = array licon in=pdD cx=(x3 + L + 0.14 + max(0.28, 0.54 - L)) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR
  cn4pE   = array licon in=pdE cx=(x4 - L - 0.14) span=(pt - WP, pt - 0.02) net=n4
  cYpE    = array licon in=pdE cx=(x4 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y

  # diffusion contacts: n row
  cn1nA   = array licon in=ndA cx=(x1 - L - 0.14) span=(nb + 0.02, nb + WN) net=n1
  cVGNDnA = array licon in=ndA cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  cVGNDnB = array licon in=ndB cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  cn3nB   = array licon in=ndB cx=(x2 - L - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=n3
  cn5nC   = array licon in=ndC cx=(x2 - L - 0.14) span=(nb + 0.02, nb + WN) net=n5
  cYnC    = array licon in=ndC cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  cVGNDnD = array licon in=ndD cx=(x3 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  cn5nD   = array licon in=ndD cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=n5
  cVGNDnD2 = array licon in=ndD cx=(x3 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND
  cn3nE   = array licon in=ndE cx=(x4 - L - 0.14) span=(nb + 0.02, nb + WN) net=n3
  cYnE    = array licon in=ndE cx=(x4 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # metal: supply rails contacts
  mcVGND1 = contact mcon cx=(x1 - 0.375) cy=0
  mcVGND2 = contact mcon cx=(x3 - 0.375) cy=0
  mcVPWR1 = contact mcon cx=(x1 - 0.375) cy=H
  mcVPWR2 = contact mcon cx=(x3 + L + 0.17) cy=H

  # straps: supply li to rails
  strap li from=lVGNDnD2 to=vgnd_li
  strap li from=lVPWRpD2 to=vpwr_li

  # pins
  port S in on=liS
  port A0 in on=liA0
  port A1 in on=liA1
  port Y out on=lYpC
end
