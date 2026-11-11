pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=12 height=H
  device M0  pmos w=WP2 l=L d=n1  g=A  s=VPWR
  device M1  nmos w=WN2 l=L d=n2  g=B  s=n3
  device M2  nmos w=WN2 l=L d=n3  g=B  s=n4
  device M3  nmos w=WN  l=L d=VGND g=n3 s=X
  device M4  nmos w=WN2 l=L d=VGND g=A s=n2
  device M5  nmos w=WN2 l=L d=n5  g=A  s=VGND
  device M6  pmos w=WP2 l=L d=n3  g=B  s=n6
  device M7  pmos w=WP2 l=L d=n6  g=C  s=VPWR
  device M8  pmos w=WP  l=L d=VPWR g=n3 s=X
  device M9  nmos w=WN2 l=L d=n4  g=C  s=VGND
  device M10 nmos w=WN2 l=L d=n3  g=C  s=n5
  device M11 pmos w=WP2 l=L d=n3  g=C  s=n1
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7
  device M13 pmos w=WP2 l=L d=n7  g=B  s=n3

  nd1 = rect diff w=4.115 h=WN2 left=(cell.left + 0.18) above=ptap
  pd1 = rect diff w=4.115 h=WP2 left=(cell.left + 0.18) below=ntap
  g0  = cross [nd1, pd1] poly w=L left=(nd1.left + 0.395)
  g1  = cross [nd1, pd1] poly w=L left=(nd1.left + 0.935)
  g2  = cross [nd1, pd1] poly w=L left=(nd1.left + 1.475)
  g3  = cross [nd1, pd1] poly w=L left=(nd1.left + 2.015)
  g4  = cross [nd1, pd1] poly w=L left=(nd1.left + 3.035)
  g5  = cross [nd1, pd1] poly w=L left=(nd1.left + 3.575)
  nd2 = rect diff w=1.335 h=WN left=(g5.right + 0.08) above=ptap
  pd2 = rect diff w=1.335 h=WP left=(g5.right + 0.08) below=ntap
  g6  = cross [nd2, pd2] poly w=L left=(nd1.left + 4.115)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # n3 columns (c0, c4)
  n0  = contact licon in=nd1 cx=(g0.left - 0.27) cy=(nd1.cy)
  p0  = contact licon in=pd1 cx=(g0.left - 0.27) cy=(pd1.cy)
  n4c = array licon in=nd1 between=[g3, g4]
  p4c = array licon in=pd1 between=[g3, g4]
  # rail columns (c2, c6)
  n2c = array licon in=nd1 between=[g1, g2]
  p2c = array licon in=pd1 between=[g1, g2]
  n6c = array licon in=nd1 between=[g5, g6]
  p6c = array licon in=pd1 between=[g5, g6]
  # X column
  xn  = contact licon in=nd2 cx=(g6.right + 0.40) bottom=(nd2.bottom + 0.06)
  xp  = contact licon in=pd2 cx=(g6.right + 0.40) top=(pd2.top - 0.06)

  n0l  = enclose n0 li net=n3
  p0l  = enclose p0 li net=n3
  n4l  = enclose n4c li net=n3
  p4l  = enclose p4c li net=n3
  n2l  = enclose n2c li
  p2l  = enclose p2c li
  n6l  = enclose n6c li
  p6l  = enclose p6c li
  xnl  = enclose xn li net=X
  xpl  = enclose xp li net=X

  s0 = strap li from=n0l to=p0l net=n3
  s4 = strap li from=n4l to=p4l net=n3
  sx = strap li from=xnl to=xpl net=X
  gn2 = strap li from=n2l to=vgnd_li
  gn6 = strap li from=n6l to=vgnd_li
  pp2 = strap li from=p2l to=vpwr_li
  pp6 = strap li from=p6l to=vpwr_li

  grow = max(nd2.top + 0.19, n2l.top + 0.25, n6l.top + 0.25)
  ca = contact licon cx=(g2.cx + 0.09) bottom=grow
  cb = contact licon cx=(g0.cx + 0.09) bottom=grow
  cc = contact licon cx=(g1.cx + 0.09) bottom=grow
  cb2 = contact licon cx=(g3.cx + 0.09) bottom=grow
  cc2 = contact licon cx=(g4.cx + 0.09) bottom=grow
  ca2 = contact licon cx=(g5.cx + 0.09) bottom=grow
  c3 = contact licon cx=(g6.cx + 0.09) bottom=grow
  pp_ca = enclose ca poly by=minx
  pp_cb = enclose cb poly by=minx
  pp_cc = enclose cc poly by=minx
  pp_cb2 = enclose cb2 poly by=minx
  pp_cc2 = enclose cc2 poly by=minx
  pp_ca2 = enclose ca2 poly by=minx
  pp_c3 = enclose c3 poly by=minx
  pn = enclose [ca, cb, cc, cb2, cc2, ca2, c3] npc
  la = enclose ca li net=A
  lb = enclose cb li net=B
  lc = enclose cc li net=C
  lb2 = enclose cb2 li net=B
  lc2 = enclose cc2 li net=C
  la2 = enclose ca2 li net=A
  l3 = enclose c3 li net=n3
  well y=((nd2.top + 0.34 + pd2.bottom - 0.18) / 2)

  m_la = contact mcon in=la
  q_la = enclose m_la m1 by=0.06 net=A
  m_lb = contact mcon in=lb
  q_lb = enclose m_lb m1 by=0.06 net=B
  m_lc = contact mcon in=lc
  q_lc = enclose m_lc m1 by=0.06 net=C
  m_lb2 = contact mcon in=lb2
  q_lb2 = enclose m_lb2 m1 by=0.06 net=B
  m_lc2 = contact mcon in=lc2
  q_lc2 = enclose m_lc2 m1 by=0.06 net=C
  m_la2 = contact mcon in=la2
  q_la2 = enclose m_la2 m1 by=0.06 net=A
  m_l3 = contact mcon in=l3
  q_l3 = enclose m_l3 m1 by=0.06 net=n3
  m_sx = contact mcon in=sx cy=(c3.top + 0.45)
  q_sx = enclose m_sx m1 by=0.06 net=X
  route * layers=m1,m2
  port A in on=q_la
  port B in on=q_lb
  port C in on=q_lc
  port X out on=q_sx
end
