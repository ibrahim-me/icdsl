pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a31oi_1 width=8 height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=Y b=VPB
  device M1 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=n2 b=VNB
  device M4 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M7 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB

  # gate columns (left edges): every x below is measured from one of them
  x1 = 0.605                          # B1 gate
  x2 = x1 + L + max(0.28, 0.54 - L)   # A3 gate
  x3 = x2 + L + max(0.28, 0.54 - L)   # A2 gate
  x4 = x3 + L + max(0.28, 0.54 - L)   # A1 gate
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion: nmos row (gate order B1, A3, A2, A1)
  # cols: Y | B1 | VGND | A3 | n3 | A2 | n2 | A1 | Y
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)
  nim = enclose [nd1] nsdm

  # diffusion: pmos row (same gate order B1, A3, A2, A1)
  # cols: Y | B1 | n1 | A3 | VPWR | A2 | n1 | A1 | VPWR
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)
  pim = enclose [pd1] psdm

  # poly: gates, crossing both rows
  gB1 = cross [nd1, pd1] poly w=L x1
  gA3 = cross [nd1, pd1] poly w=L x2
  gA2 = cross [nd1, pd1] poly w=L x3
  gA1 = cross [nd1, pd1] poly w=L x4

  # gate contacts (all on n-row side, shifted away from output strap)
  cb = nd1.top + 0.19
  gcB1 = contact licon cx=(gB1.cx - 0.13) cy=cb net=B1
  gcA3 = contact licon cx=(gA3.cx - 0.13) cy=cb net=A3
  gcA2 = contact licon cx=(gA2.cx - 0.13) cy=cb net=A2
  gcA1 = contact licon cx=(gA1.cx - 0.13) cy=cb net=A1
  np1 = rect npc xspan=(gB1.left - 0.30, gA1.right + 0.30) yspan=(cb - 0.09, cb + 0.09)

  # nmos local interconnect strips
  lnY_l = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(nb + 0.02, nb + WN) net=Y
  lnVGND = rect li xspan=(x1 + L + 0.02, x2 - 0.02) yspan=(nb + 0.02, nb + WN) net=VGND
  lnn3 = rect li xspan=(x2 + L + 0.02, x3 - 0.02) yspan=(nb + 0.02, nb + WN) net=n3
  lnn2 = rect li xspan=(x3 + L + 0.02, x4 - 0.02) yspan=(nb + 0.02, nb + WN) net=n2
  lnY_r = rect li xspan=(x4 + L + 0.02, x4 + L + 0.335) yspan=(nb + 0.02, nb + WN) net=Y

  # nmos diffusion contacts
  cY_l = array licon in=nd1 cx=(x1 - 0.14) span=(nb + 0.08, nb + WN - 0.08) net=Y
  cVGND = array licon in=nd1 cx=(x1 + L + 0.14) span=(nb + 0.08, nb + WN - 0.08) net=VGND
  cnn3 = array licon in=nd1 cx=(x2 + L + 0.14) span=(nb + 0.08, nb + WN - 0.08) net=n3
  cnn2 = array licon in=nd1 cx=(x3 + L + 0.14) span=(nb + 0.08, nb + WN - 0.08) net=n2
  cY_r = array licon in=nd1 cx=(x4 + L + 0.14) span=(nb + 0.08, nb + WN - 0.08) net=Y

  # pmos local interconnect strips
  lpY_l = rect li xspan=(x1 - 0.335, x1 - 0.025) yspan=(pt - WP + 0.02, pt - 0.02) net=Y
  lpn1_1 = rect li xspan=(x1 + L + 0.02, x2 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=n1
  lpVPWR_1 = rect li xspan=(x2 + L + 0.02, x3 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=VPWR
  lpn1_2 = rect li xspan=(x3 + L + 0.02, x4 - 0.02) yspan=(pt - WP + 0.02, pt - 0.02) net=n1
  lpVPWR_2 = rect li xspan=(x4 + L + 0.02, x4 + L + 0.335) yspan=(pt - WP + 0.02, pt - 0.02) net=VPWR

  # pmos diffusion contacts
  cpY_l = array licon in=pd1 cx=(x1 - 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=Y
  cpn1_1 = array licon in=pd1 cx=(x1 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n1
  cpVPWR_1 = array licon in=pd1 cx=(x2 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=VPWR
  cpn1_2 = array licon in=pd1 cx=(x3 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=n1
  cpVPWR_2 = array licon in=pd1 cx=(x4 + L + 0.14) span=(pt - WP + 0.08, pt - 0.02 - 0.08) net=VPWR

  # route nets that appear in multiple columns
  route Y layers=m1,m2
  route n1 layers=m1,m2
  route VPWR layers=m1,m2

  # supply straps
  strap li from=cVGND to=vgnd_li
  strap li from=cpVPWR_1 to=vpwr_li

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # power/ground rail contacts
  mc1 = contact mcon cx=(x1 - 0.375) cy=0
  mc2 = contact mcon cx=(x1 + L + 0.13) cy=0
  mc3 = contact mcon cx=(x4 + L + 0.405) cy=0
  mc4 = contact mcon cx=(x1 - 0.375) cy=H
  mc5 = contact mcon cx=(x1 + L + 0.13) cy=H
  mc6 = contact mcon cx=(x4 + L + 0.405) cy=H

  # pins
  port A1 in on=gcA1
  port A2 in on=gcA2
  port A3 in on=gcA3
  port B1 in on=gcB1
  port Y out
end
