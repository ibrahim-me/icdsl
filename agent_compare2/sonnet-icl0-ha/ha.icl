# Half adder, 14 transistors: 7 shared poly columns n1 n1 B A A B n3
pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=11 height=H
  device M0  nmos w=WN2 l=L d=n1   g=B  s=n2
  device M1  nmos w=WN2 l=L d=n3   g=n1 s=n4
  device M2  pmos w=WP2 l=L d=n1   g=A  s=VPWR
  device M3  pmos w=WP  l=L d=VPWR g=n1 s=COUT
  device M4  nmos w=WN2 l=L d=VGND g=A  s=n4
  device M5  pmos w=WP2 l=L d=n3   g=B  s=n5
  device M6  pmos w=WP2 l=L d=n5   g=A  s=VPWR
  device M7  nmos w=WN  l=L d=SUM  g=n3 s=VGND
  device M8  nmos w=WN2 l=L d=n2   g=A  s=VGND
  device M9  pmos w=WP  l=L d=SUM  g=n3 s=VPWR
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M11 nmos w=WN2 l=L d=n4   g=B  s=VGND
  device M12 nmos w=WN  l=L d=VGND g=n1 s=COUT
  device M13 pmos w=WP2 l=L d=VPWR g=B  s=n1

  # ---- diffusions ----
  pd  = rect diff w=4.47 h=WP2 cx=cell.cx below=ntap
  pt1 = rect diff xspan=(pd.left, pd.left + 0.665) h=WP top=pd.top
  pt7 = rect diff xspan=(pd.left + 3.805, pd.right) h=WP top=pd.top
  nA  = rect diff xspan=(pd.left, pd.left + 0.68) h=WN2 above=ptap
  nB  = rect diff xspan=(pd.left + 0.95, pd.left + 3.52) h=WN2 bottom=nA.bottom
  nBt = rect diff xspan=(pd.left + 0.95, pd.left + 1.665) h=WN bottom=nA.bottom
  nC  = rect diff xspan=(pd.left + 3.79, pd.right) h=WN bottom=nA.bottom
  nim = enclose [nA, nB, nBt, nC] nsdm
  pim = enclose [pd, pt1, pt7] psdm

  # ---- gates ----
  g1 = cross [nA, pt1] poly w=L left=(pd.left + 0.265)
  g2 = cross [nB, pd]  poly w=L left=(g1.right + 0.8)
  g3 = cross [nB, pd]  poly w=L left=(g2.right + 0.45)
  g4 = cross [nB, pd]  poly w=L left=(g3.right + 0.28)
  g5 = cross [nB, pd]  poly w=L left=(g4.right + 0.28)
  g6 = cross [nB, pd]  poly w=L left=(g5.right + 0.28)
  g7 = cross [nC, pt7] poly w=L left=(g6.right + 0.8)

  # ---- N contacts ----
  nc0 = array licon in=nA  left_of=g1       # n3
  nc1 = array licon in=nA  right_of=g1      # n4
  nc2 = array licon in=nBt left_of=g2       # COUT
  nc3 = array licon in=nBt right_of=g2      # VGND
  nc4 = array licon in=nB  between=[g3, g4] # n4
  nc5 = array licon in=nB  between=[g4, g5] # VGND
  nc6 = array licon in=nB  right_of=g6      # n1
  nc7 = array licon in=nC  left_of=g7       # SUM
  nc8 = array licon in=nC  right_of=g7      # VGND
  nl0 = enclose nc0 li net=n3
  nl1 = enclose nc1 li net=n4
  nl2 = enclose nc2 li net=COUT
  nl3 = enclose nc3 li
  nl4 = enclose nc4 li net=n4
  nl5 = enclose nc5 li
  nl6 = enclose nc6 li net=n1
  nl7 = enclose nc7 li net=SUM
  nl8 = enclose nc8 li
  gs3 = strap li from=nl3 to=vgnd_li
  gs5 = strap li from=nl5 to=vgnd_li
  gs8 = strap li from=nl8 to=vgnd_li

  # ---- P contacts ----
  pc0 = array licon in=pt1 left_of=g1       # COUT
  pc1 = array licon in=pd between=[g1, g2]  # VPWR
  pc2 = array licon in=pd between=[g2, g3]  # n3
  pc4 = array licon in=pd between=[g4, g5]  # VPWR
  pc5 = array licon in=pd between=[g5, g6]  # n1
  pc6 = array licon in=pd between=[g6, g7]  # VPWR
  pc7 = array licon in=pt7 right_of=g7      # SUM
  pl0 = enclose pc0 li net=COUT
  pl1 = enclose pc1 li
  pl2 = enclose pc2 li net=n3
  pl4 = enclose pc4 li
  pl5 = enclose pc5 li net=n1
  pl6 = enclose pc6 li
  pl7 = enclose pc7 li net=SUM
  vs1 = strap li from=pl1 to=vpwr_li
  vs4 = strap li from=pl4 to=vpwr_li
  vs6 = strap li from=pl6 to=vpwr_li

  # ---- gate contacts in the channel ----
  cb = max(nBt.top + 0.19, nC.top + 0.19, nl0.top + 0.25, nl2.top + 0.25, nl5.top + 0.25)
  gc12 = contact licon cx=((g1.right + g2.left) / 2) bottom=cb
  gb12 = rect poly xspan=(g1.left, g2.right) cy=gc12.cy h=0.33
  gc3  = contact licon cx=(g3.cx - 0.1) bottom=cb
  gp3  = enclose gc3 poly by=minx
  gc45 = contact licon cx=((g4.right + g5.left) / 2) bottom=cb
  gb45 = rect poly xspan=(g4.left, g5.right) cy=gc45.cy h=0.33
  gc6  = contact licon cx=(g6.cx + 0.1) bottom=cb
  gp6  = enclose gc6 poly by=minx
  gc7  = contact licon cx=g7.cx bottom=cb
  gp7  = enclose gc7 poly by=minx
  gn   = enclose [gc12, gc3, gc45, gc6, gc7] npc
  l12 = enclose gc12 li net=n1
  l3  = enclose gc3 li net=B
  l45 = enclose gc45 li net=A
  l6  = enclose gc6 li net=B
  l7  = enclose gc7 li net=n3
  well y=(min(pt1.bottom, pt7.bottom) - 0.25)

  # ---- m1 pads ----
  m_n3a = contact mcon in=nl0
  m_n4a = contact mcon in=nl1
  m_cn  = contact mcon in=nl2
  m_n4b = contact mcon in=nl4
  m_n1n = contact mcon in=nl6
  m_sn  = contact mcon in=nl7
  m_cp  = contact mcon in=pl0
  m_n3p = contact mcon in=pl2
  m_n1p = contact mcon in=pl5
  m_sp  = contact mcon in=pl7
  m_g12 = contact mcon in=l12
  m_g3  = contact mcon in=l3
  m_g45 = contact mcon in=l45
  m_g6  = contact mcon in=l6
  m_g7  = contact mcon in=l7
  p_n3a = enclose m_n3a m1 by=0.06 net=n3
  p_n4a = enclose m_n4a m1 by=0.06 net=n4
  p_cn  = enclose m_cn m1 by=0.06 net=COUT
  p_n4b = enclose m_n4b m1 by=0.06 net=n4
  p_n1n = enclose m_n1n m1 by=0.06 net=n1
  p_sn  = enclose m_sn m1 by=0.06 net=SUM
  p_cp  = enclose m_cp m1 by=0.06 net=COUT
  p_n3p = enclose m_n3p m1 by=0.06 net=n3
  p_n1p = enclose m_n1p m1 by=0.06 net=n1
  p_sp  = enclose m_sp m1 by=0.06 net=SUM
  p_g12 = enclose m_g12 m1 by=0.06 net=n1
  p_g3  = enclose m_g3 m1 by=0.06 net=B
  p_g45 = enclose m_g45 m1 by=0.06 net=A
  p_g6  = enclose m_g6 m1 by=0.06 net=B
  p_g7  = enclose m_g7 m1 by=0.06 net=n3

  route * layers=m1,m2

  port A in on=p_g45
  port B in on=p_g3
  port COUT out on=p_cp
  port SUM out on=p_sp
end
