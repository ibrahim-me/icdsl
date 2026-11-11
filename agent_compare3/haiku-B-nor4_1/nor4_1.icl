pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=6 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate columns (left edges), pitch 0.54 (poly pads of 0.33 need 0.21 space)
  x1 = 0.45
  x2 = x1 + 0.54
  x3 = x2 + 0.54
  x4 = x3 + 0.54
  nb = 0.235                          # bottom of the n row
  nt = nb + WN                        # top of the n row
  pt = H - 0.235                      # top of the p row
  pb = pt - WP                        # bottom of the p row
  cg = nt + 0.275                     # gate-contact band: 0.19 above the n row, 0.24 below p-diffusion
  cn = (nb + nt) / 2                  # n-row contact height
  cp = (pb + pt) / 2                  # p-row contact height
  m12 = x1 + 0.27 + L / 2             # contact column between gates A and B
  m23 = x2 + 0.27 + L / 2             # between B and C
  m34 = x3 + 0.27 + L / 2             # between C and D
  e0 = x1 - 0.14                      # left end column (left of A)
  e4 = x4 + L + 0.14                  # right end column (right of D)
  g1 = x1 + L / 2
  g2 = x2 + L / 2
  g3 = x3 + L / 2
  g4 = x4 + L / 2

  # diffusion (n row and p row, continuous; gates split the channels)
  nd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(nb, nt)
  pd1 = rect diff xspan=(x1 - 0.265, x4 + L + 0.265) yspan=(pb, pt)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  # poly: one full-height gate per input, with a pad in the contact band
  pA = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  pB = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  pC = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  pD = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  padA = rect poly xspan=(g1 - 0.165, g1 + 0.165) yspan=(cg - 0.165, cg + 0.165)
  padB = rect poly xspan=(g2 - 0.165, g2 + 0.165) yspan=(cg - 0.165, cg + 0.165)
  padC = rect poly xspan=(g3 - 0.165, g3 + 0.165) yspan=(cg - 0.165, cg + 0.165)
  padD = rect poly xspan=(g4 - 0.165, g4 + 0.165) yspan=(cg - 0.165, cg + 0.165)

  # gate contacts (in the band between the rows)
  gcA = contact licon cx=g1 cy=cg
  gcB = contact licon cx=g2 cy=cg
  gcC = contact licon cx=g3 cy=cg
  gcD = contact licon cx=g4 cy=cg
  lA = enclose gcA li net=A
  lB = enclose gcB li net=B
  lC = enclose gcC li net=C
  lD = enclose gcD li net=D
  npc1 = enclose [gcA, gcB, gcC, gcD] npc

  # n row: Y, VGND, Y, VGND, Y
  cn0 = contact licon cx=e0 cy=cn
  ln0 = enclose cn0 li net=Y
  cn1 = contact licon cx=m12 cy=cn
  ln1 = rect li xspan=(m12 - 0.155, m12 + 0.155) yspan=(-0.085, cg - 0.345) net=VGND
  cn2 = contact licon cx=m23 cy=cn
  ln2 = enclose cn2 li net=Y
  cn3 = contact licon cx=m34 cy=cn
  ln3 = rect li xspan=(m34 - 0.155, m34 + 0.155) yspan=(-0.085, cg - 0.345) net=VGND
  cn4 = contact licon cx=e4 cy=cn
  ln4 = enclose cn4 li net=Y
  mv1 = contact mcon cx=m12 cy=0
  mv3 = contact mcon cx=m34 cy=0

  # p row: VPWR, (series nodes, no contact), Y
  cp0 = contact licon cx=e0 cy=cp
  lp0 = rect li xspan=(e0 - 0.155, e0 + 0.155) yspan=(cg + 0.345, H + 0.085) net=VPWR
  cp4 = contact licon cx=e4 cy=cp
  lp4 = enclose cp4 li net=Y
  mv0 = contact mcon cx=e0 cy=H

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells

  route Y layers=m1,m2

  # pins
  mA = contact mcon in=lA
  mAm = enclose mA m1 by=0.06
  port A in on=mAm
  mB = contact mcon in=lB
  mBm = enclose mB m1 by=0.06
  port B in on=mBm
  mC = contact mcon in=lC
  mCm = enclose mC m1 by=0.06
  port C in on=mCm
  mD = contact mcon in=lD
  mDm = enclose mD m1 by=0.06
  port D in on=mDm
  port Y out on=ln2
end
