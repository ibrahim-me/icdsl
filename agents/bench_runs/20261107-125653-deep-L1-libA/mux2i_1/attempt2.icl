# mux2i_1: Y = (!A0&!S) | (!A1&S)
# tapless, PDK widths; x from gate columns; y from row edges nb/pt; clean over sweep
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell mux2i_1 width=8 height=H taps=no
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
  x2 = x1 + L + max(0.28, 0.54 - L)   # gate A0
  x3 = x2 + L + max(0.28, 0.54 - L)   # gate n1
  x4 = x3 + L + max(0.28, 0.54 - L)   # gate A1
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: p row (shared islands where nets match)
  pdA = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)        # VPWR | n1
  pdB = rect diff xspan=(x1 + L + 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)    # n2 | n2
  pdC = rect diff xspan=(x2 + L + 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)    # Y | n4
  pdD = rect diff xspan=(x3 + L + 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)    # n4 | Y
  pim = enclose [pdA, pdB, pdC, pdD] psdm

  # diffusion: n row
  ndA = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)        # VGND | n1
  ndB = rect diff xspan=(x1 + L + 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)    # n3 | n3
  ndC = rect diff xspan=(x2 + L + 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)    # Y | n5
  ndD = rect diff xspan=(x3 + L + 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)    # n5 | Y
  nim = enclose [ndA, ndB, ndC, ndD] nsdm

  # poly: gates crossing both rows
  gS  = cross [ndA, pdA] poly w=L x1
  gA0 = cross [ndB, pdB] poly w=L x2
  gN1 = cross [ndC, pdC] poly w=L x3
  gA1 = cross [ndD, pdD] poly w=L x4

  # gate contacts: all at cb height, shifted as needed
  cb = max(ndA.top + 0.19, 0.60)
  gcS  = contact licon cx=(x1 - 0.12) bottom=cb net=S
  gcA0 = contact licon cx=(x2 - 0.12) bottom=cb net=A0
  gcN1 = contact licon cx=(x3 - 0.12) bottom=cb net=n1
  gcA1 = contact licon cx=(x4 - 0.12) bottom=cb net=A1
  np1 = rect npc xspan=(x1 - 0.42, x4 + L + 0.4) yspan=(ndA.top + 0.09, pt - WP - 0.14)

  # p-row local interconnect
  lVPWRp = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP + 0.01, pt - 0.02) net=VPWR
  ln2p   = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  lYp    = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  ln4p   = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(pt - WP, pt - 0.02) net=n4
  lVPWRp2 = rect li xspan=(x3 + L + 0.055, x3 + L + 0.315) yspan=(pt - WP + 0.01, H + 0.085) net=VPWR

  # n-row local interconnect
  lVGNDn = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(nb + 0.02, nb + WN) net=VGND
  ln3n   = rect li xspan=(x1 + L - 0.03, x2 + 0.03) yspan=(nb + 0.02, nb + WN) net=n3
  lYn    = rect li xspan=(x2 + L - 0.03, x3 + 0.03) yspan=(nb + 0.02, nb + WN) net=Y
  ln5n   = rect li xspan=(x3 + L - 0.03, x4 + 0.03) yspan=(nb + 0.02, nb + WN) net=n5
  lVGNDn2 = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(-0.085, nb + WN) net=VGND

  # internal net routes: n1 (M0.d -> M4.g/M5.g), n2 (M1.s -> M2.d), n4 (M4.d -> M7.s)
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2

  # diffusion contacts: p row
  cVPWRp = array licon in=pdA cx=(x1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cn2p   = array licon in=pdB cx=(x1 + L + 0.14) span=(pt - WP, pt - 0.02) net=n2
  cYp    = array licon in=pdC cx=(x2 + L + 0.14) span=(pt - WP, pt - 0.02) net=Y
  cn4p   = array licon in=pdD cx=(x3 + L + 0.14) span=(pt - WP, pt - 0.02) net=n4
  cVPWRp2 = array licon in=pdD cx=(x3 + L + 0.14 + max(0.28, 0.54 - L)) span=(pt - WP + 0.01 + 0.08, H + 0.085 - 0.08) net=VPWR

  # diffusion contacts: n row
  cVGNDn = array licon in=ndA cx=(x1 - 0.14) span=(nb + 0.02, nb + WN - 0.08) net=VGND
  cn3n   = array licon in=ndB cx=(x1 + L + 0.14) span=(nb + 0.02, nb + WN) net=n3
  cYn    = array licon in=ndC cx=(x2 + L + 0.14) span=(nb + 0.02, nb + WN) net=Y
  cn5n   = array licon in=ndD cx=(x3 + L + 0.14) span=(nb + 0.02, nb + WN) net=n5
  cVGNDn2 = array licon in=ndA cx=(x1 - 0.14) span=(-0.085 + 0.08, nb + WN - 0.08) net=VGND

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # metal: supply rails contacts
  mcVGND1 = contact mcon cx=(x1 - 0.375) cy=0
  mcVGND2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mcVPWR1 = contact mcon cx=(x1 - 0.375) cy=H
  mcVPWR2 = contact mcon cx=(x3 + L + 0.17) cy=H

  # straps: supply li to rails
  strap li from=lVGNDn2 to=vgnd_li
  strap li from=lVPWRp2 to=vpwr_li

  # pins
  port S in on=gcS
  port A0 in on=gcA0
  port A1 in on=gcA1
  port Y out on=lYp
end
