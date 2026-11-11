# xnor2_1: Y = (!A&!B) | (A&B)
# Gate order (both rows): A, B, n2
# pmos: M0(A,n1), M1(B,Y), M2(n2,Y), M6(B,n2), M7(A,n2)
# nmos: M3(A,n3), M4(B,n4), M5(B,n2), M8(A,n4), M9(n2,Y)
# Diffusion islands:
#   pmos: [M0,M1] | [M2] | [M6,M7]   (n1, Y, n2 breaks)
#   nmos: [M3]   | [M4,M8] | [M5,M9]  (n3, n4, n2 breaks)
# Gate columns: gA, gB, gn2
# Contacts: gA on M0/M3, gB on M1/M4, gn2 on M2/M5/M9

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

  # gate columns (left edges): every x below is measured from one of them
  gA = 0.60
  gB = gA + L + max(0.28, 0.54 - L)
  gn2 = gB + L + max(0.28, 0.54 - L)
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row

  # diffusion islands (pmos row)
  pdA = rect diff xspan=(gA - 0.265, gB + L + 0.265) yspan=(pt - WP, pt)      # M0, M1 share n1
  pd2 = rect diff xspan=(gn2 - 0.265, gn2 + L + 0.265) yspan=(pt - WP, pt)    # M2 alone
  pd67 = rect diff xspan=(gn2 + L + 0.54, gn2 + L + 0.54 + L + 0.53) yspan=(pt - WP, pt)  # M6, M7 share n2
  # diffusion islands (nmos row)
  nd3 = rect diff xspan=(gA - 0.265, gA + L + 0.265) yspan=(nb, nb + WN)     # M3 alone
  nd48 = rect diff xspan=(gB - 0.265, gB + L + 0.265) yspan=(nb, nb + WN)    # M4, M8 share n4
  nd59 = rect diff xspan=(gn2 - 0.265, gn2 + L + 0.265) yspan=(nb, nb + WN)  # M5, M9 share n2

  # implants
  nim = enclose [nd3, nd48, nd59] nsdm
  pim = enclose [pdA, pd2, pd67] psdm

  # poly gates (cross both rows)
  pA = cross [nd3, pdA] poly w=L left=gA
  pB = cross [nd48, pdA] poly w=L left=gB
  pn2 = cross [nd59, pd2] poly w=L left=gn2
  # extend pn2 to cross pd67 as well
  pn2b = cross [pd67] poly w=L left=gn2

  # local interconnect - gate inputs
  lA = rect li xspan=(gA - 0.30, gA - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=A
  lB = rect li xspan=(gB - 0.30, gB - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=B
  ln2 = rect li xspan=(gn2 - 0.30, gn2 - 0.05) yspan=(nb + WN + 0.17, pt - WP - 0.16) net=n2

  # local interconnect - pmos row
  lp0 = rect li xspan=(gA - 0.03, gA + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR   # M0 drain VPWR
  lp1n1 = rect li xspan=(gB - 0.03, gB + L + 0.03) yspan=(pt - WP, pt - 0.02) net=n1   # M1 drain n1 / M0 source n1
  lp1Y = rect li xspan=(gB - 0.03, gB + L + 0.03) yspan=(pt - WP, pt - 0.02) net=Y     # M1 source Y
  lp2Y = rect li xspan=(gn2 - 0.03, gn2 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=Y   # M2 drain Y
  lp2VPWR = rect li xspan=(gn2 - 0.03, gn2 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR  # M2 source VPWR
  lp6VPWR = rect li xspan=(gn2 + L + 0.54 - 0.03, gn2 + L + 0.54 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR  # M6 drain VPWR
  lp6n2 = rect li xspan=(gn2 + L + 0.54 - 0.03, gn2 + L + 0.54 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=n2   # M6 source n2 / M7 drain n2
  lp7VPWR = rect li xspan=(gn2 + L + 0.54 - 0.03, gn2 + L + 0.54 + L + 0.03) yspan=(pt - WP, pt - 0.02) net=VPWR  # M7 source VPWR

  # local interconnect - nmos row
  ln3VGND = rect li xspan=(gA - 0.03, gA + L + 0.03) yspan=(nb, nb + WN) net=VGND   # M3 source VGND
  ln3n3 = rect li xspan=(gA - 0.03, gA + L + 0.03) yspan=(nb, nb + WN) net=n3       # M3 drain n3 / M5 source n3
  ln4VGND = rect li xspan=(gB - 0.03, gB + L + 0.03) yspan=(nb, nb + WN) net=VGND   # M4 drain VGND / M8 drain VGND
  ln4n4 = rect li xspan=(gB - 0.03, gB + L + 0.03) yspan=(nb, nb + WN) net=n4       # M4 source n4 / M8 source n4
  ln2n2 = rect li xspan=(gn2 - 0.03, gn2 + L + 0.03) yspan=(nb, nb + WN) net=n2     # M5 drain n2 / M9 drain n2
  ln4Y = rect li xspan=(gn2 - 0.03, gn2 + L + 0.03) yspan=(nb, nb + WN) net=Y       # M9 source Y

  # contacts: diffusion columns
  cp0VPWR = array licon in=pdA cx=(gA - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp1n1 = array licon in=pdA cx=(gB - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n1
  cp1Y = array licon in=pdA cx=(gB + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  cp2Y = array licon in=pd2 cx=(gn2 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=Y
  cp2VPWR = array licon in=pd2 cx=(gn2 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp6VPWR = array licon in=pd67 cx=(gn2 + L + 0.54 - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR
  cp6n2 = array licon in=pd67 cx=(gn2 + L + 0.54 + L - 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=n2
  cp7VPWR = array licon in=pd67 cx=(gn2 + L + 0.54 + L + 0.14) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) net=VPWR

  cn3VGND = array licon in=nd3 cx=(gA - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  cn3n3 = array licon in=nd3 cx=(gA + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n3
  cn4VGND = array licon in=nd48 cx=(gB - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=VGND
  cn4n4 = array licon in=nd48 cx=(gB + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n4
  cn2n2 = array licon in=nd59 cx=(gn2 - 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=n2
  cn2Y = array licon in=nd59 cx=(gn2 + L + 0.14) span=(nb + 0.02 + 0.08, nb + WN - 0.08) net=Y

  # gate contacts
  gcA = contact licon cx=(gA - 0.12) cy=(nb + WN + 0.275) net=A
  gcB = contact licon cx=(gB - 0.12) cy=(nb + WN + 0.275) net=B
  gcn2 = contact licon cx=(gn2 - 0.12) cy=(nb + WN + 0.275) net=n2

  # NPC around all gate contacts
  np1 = rect npc xspan=(gA - 0.45, gn2 + L + 0.45) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # metal contacts on rails
  mcVGND = array mcon in=nd3 cx=(gA - 0.30) span=(nb + 0.02 + 0.08, nb + WN - 0.08) cy=0
  mcVPWR = array mcon in=pdA cx=(gA - 0.30) span=(pt - WP + 0.01 + 0.08, pt - 0.02 - 0.08) cy=H

  # straps from diffusion contacts to rails
  strapVGND = strap li from=cn3VGND to=vgnd_li
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
  port A in on=lA
  port B in on=lB
  port Y out
end