# xnor2_1: Y = (!A&!B) | (A&B)
# Gate order (both rows): B, A, n2, A, B
# pmos: M1(B,n1/Y), M0(A,n1/VPWR), M2(n2,Y/VPWR), M7(A,n2/VPWR), M6(B,n2/VPWR)
# nmos: M4(B,n4/VGND), M3(A,n3/VGND), M9(n2,n4/Y), M8(A,n4/VGND), M5(B,n2/n3)
# Islands: pmos [M1,M0 share n1] | [M2] | [M7,M6 share n2]
#          nmos [M4,M3 share VGND] | [M9,M8 share n4] | [M5]
# Gate columns: gB1, gA1, gn2, gA2, gB2

pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell xnor2_1 width=10 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M2 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B s=n4 b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M7 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M9 nmos w=WN l=L d=n4 g=n2 s=Y b=VNB

  # gate columns (left edges)
  gB1 = 0.60
  gA1 = gB1 + L + max(0.28, 0.54 - L)
  gn2 = gA1 + L + max(0.28, 0.54 - L)
  gA2 = gn2 + L + max(0.28, 0.54 - L)
  gB2 = gA2 + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion islands (pmos row)
  pd10 = rect diff xspan=(gB1 - 0.265, gA1 + L + 0.265) yspan=(pt - WP, pt)   # M1, M0 share n1
  pd2  = rect diff xspan=(gn2 - 0.265, gn2 + L + 0.265) yspan=(pt - WP, pt)   # M2 alone
  pd76 = rect diff xspan=(gA2 - 0.265, gB2 + L + 0.265) yspan=(pt - WP, pt)   # M7, M6 share n2
  # diffusion islands (nmos row)
  nd43 = rect diff xspan=(gB1 - 0.265, gA1 + L + 0.265) yspan=(nb, nb + WN)   # M4, M3 share VGND
  nd98 = rect diff xspan=(gn2 - 0.265, gA2 + L + 0.265) yspan=(nb, nb + WN)   # M9, M8 share n4
  nd5  = rect diff xspan=(gB2 - 0.265, gB2 + L + 0.265) yspan=(nb, nb + WN)   # M5 alone

  # implants
  nim = enclose [nd43, nd98, nd5] nsdm
  pim = enclose [pd10, pd2, pd76] psdm

  # poly gates (cross both rows)
  pB1 = cross [nd43, pd10] poly w=L left=gB1
  pA1 = cross [nd43, pd10] poly w=L left=gA1
  pn2 = cross [nd98, pd2] poly w=L left=gn2
  pA2 = cross [nd98, pd76] poly w=L left=gA2
  pB2 = cross [nd5, pd76] poly w=L left=gB2

  # local interconnect - gate inputs
  lB1 = rect li xspan=(gB1 - 0.30, gB1 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B
  lA1 = rect li xspan=(gA1 - 0.30, gA1 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  ln2 = rect li xspan=(gn2 - 0.30, gn2 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n2
  lA2 = rect li xspan=(gA2 - 0.30, gA2 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  lB2 = rect li xspan=(gB2 - 0.30, gB2 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B

  # local interconnect - pmos row, island pd10 (M1 at gB1, M0 at gA1)
  lp1Y = rect li xspan=(gB1 - 0.03, gB1 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  lp1n1 = rect li xspan=(gB1 + L - 0.03, gA1 - 0.03) yspan=(pt - WP, pt - 0.02) net=n1
  lp0VPWR = rect li xspan=(gA1 + L - 0.03, gA1 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR
  # local interconnect - pmos row, island pd2 (M2 at gn2)
  lp2Y = rect li xspan=(gn2 - 0.03, gn2 + 0.03) yspan=(pt - WP, pt - 0.02) net=Y
  lp2VPWR = rect li xspan=(gn2 + L - 0.03, gn2 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR
  # local interconnect - pmos row, island pd76 (M7 at gA2, M6 at gB2)
  lp7n2 = rect li xspan=(gA2 - 0.03, gA2 + 0.03) yspan=(pt - WP, pt - 0.02) net=n2
  lp7VPWR = rect li xspan=(gA2 + L - 0.03, gB2 - 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR
  lp6n2 = rect li xspan=(gB2 + L - 0.03, gB2 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=n2

  # local interconnect - nmos row, island nd43 (M4 at gB1, M3 at gA1)
  ln4n4 = rect li xspan=(gB1 - 0.03, gB1 + 0.03) yspan=(nb, nb + WN) net=n4
  ln4VGND = rect li xspan=(gB1 + L - 0.03, gA1 - 0.03) yspan=(nb, nb + WN) net=VGND
  ln3n3 = rect li xspan=(gA1 + L - 0.03, gA1 + L + 0.03) yspan=(nb, nb + WN) net=n3
  # local interconnect - nmos row, island nd98 (M9 at gn2, M8 at gA2)
  ln9Y = rect li xspan=(gn2 - 0.03, gn2 + 0.03) yspan=(nb, nb + WN) net=Y
  ln9n4 = rect li xspan=(gn2 + L - 0.03, gA2 - 0.03) yspan=(nb, nb + WN) net=n4
  ln8VGND = rect li xspan=(gA2 + L - 0.03, gA2 + L + 0.03) yspan=(nb, nb + WN) net=VGND
  # local interconnect - nmos row, island nd5 (M5 at gB2)
  ln5n2 = rect li xspan=(gB2 - 0.03, gB2 + 0.03) yspan=(nb, nb + WN) net=n2
  ln5n3 = rect li xspan=(gB2 + L - 0.03, gB2 + L + 0.03) yspan=(nb, nb + WN) net=n3

  # contacts: diffusion columns (pmos)
  cp1Y = array licon in=pd10 cx=(gB1 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  cp1n1 = array licon in=pd10 cx=(gB1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  cp0VPWR = array licon in=pd10 cx=(gA1 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp2Y = array licon in=pd2 cx=(gn2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  cp2VPWR = array licon in=pd2 cx=(gn2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp7n2 = array licon in=pd76 cx=(gA2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  cp7VPWR = array licon in=pd76 cx=(gA2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp6n2 = array licon in=pd76 cx=(gB2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  cp6VPWR = array licon in=pd76 cx=(gB2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR

  # contacts: diffusion columns (nmos)
  cn4n4 = array licon in=nd43 cx=(gB1 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n4
  cn3n3 = array licon in=nd43 cx=(gA1 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n3
  cn9Y = array licon in=nd98 cx=(gn2 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y
  cn8VGND = array licon in=nd98 cx=(gA2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  cn5n2 = array licon in=nd5 cx=(gB2 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n2
  cn5n3 = array licon in=nd5 cx=(gB2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n3

  # gate contacts
  gcB1 = contact licon cx=(gB1 - 0.12) cy=(nb + WN + 0.275) net=B
  gcA1 = contact licon cx=(gA1 - 0.12) cy=(nb + WN + 0.275) net=A
  gcn2 = contact licon cx=(gn2 - 0.12) cy=(nb + WN + 0.275) net=n2
  gcA2 = contact licon cx=(gA2 - 0.12) cy=(nb + WN + 0.275) net=A
  gcB2 = contact licon cx=(gB2 - 0.12) cy=(nb + WN + 0.275) net=B

  # NPC around all gate contacts
  np1 = rect npc xspan=(gB1 - 0.45, gB2 + L + 0.45) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal contacts on rails
  mcVGND = contact mcon cx=(gB1 - 0.30) cy=0
  mcVPWR = contact mcon cx=(gB1 - 0.30) cy=H

  # straps from diffusion contacts to rails
  strapVGND = strap li from=cn4VGNDb to=vgnd_li
  strapVPWR = strap li from=cp0VPWR to=vpwr_li

  # well
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)

  # routes for internal nets
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route Y layers=m1,m2

  # pins
  port A in on=lA1
  port B in on=lB1
  port Y out
end