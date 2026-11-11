pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=12 height=H
  device M0 nmos w=WN2 l=L d=n1 g=B s=n2
  device M1 nmos w=WN2 l=L d=n3 g=n1 s=n4
  device M2 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M3 pmos w=WP l=L d=VPWR g=n1 s=COUT
  device M4 nmos w=WN2 l=L d=VGND g=A s=n4
  device M5 pmos w=WP2 l=L d=n3 g=B s=n5
  device M6 pmos w=WP2 l=L d=n5 g=A s=VPWR
  device M7 nmos w=WN l=L d=SUM g=n3 s=VGND
  device M8 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M9 pmos w=WP l=L d=SUM g=n3 s=VPWR
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M11 nmos w=WN2 l=L d=n4 g=B s=VGND
  device M12 nmos w=WN l=L d=VGND g=n1 s=COUT
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1

  # n row (left to right): I0 SUM[n3]VGND[n1]COUT (0.49) | I1 VGND[A]n2[B]n1 | I2 n4[A]VGND[B]n4[n1]n3
  # p row:                 P-C SUM[n3]VPWR[n1]COUT (0.75) | P-A VPWR[A]n1[B]VPWR | P-B VPWR[A]n5[B]n3[n1]VPWR
  # stripes s1=n3 s2=n1 | break | s3=A s4=B | break | s5=A s6=B s7=n1
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gc_ = max(0.28, 0.54 - L)
  gb_ = max(0.80, 0.54 - L)
  span = 0.53 + 7*L + 4*gc_ + 2*gb_
  x0 = cell.cx - span/2
  s1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  s2 = rect poly w=L left=(s1.right + gc_) yspan=(ny0 - 0.13, py1 + 0.13)
  s3 = rect poly w=L left=(s2.right + gb_) yspan=(ny0 - 0.13, py1 + 0.13)
  s4 = rect poly w=L left=(s3.right + gc_) yspan=(ny0 - 0.13, py1 + 0.13)
  s5 = rect poly w=L left=(s4.right + gb_) yspan=(ny0 - 0.13, py1 + 0.13)
  s6 = rect poly w=L left=(s5.right + gc_) yspan=(ny0 - 0.13, py1 + 0.13)
  s7 = rect poly w=L left=(s6.right + gc_) yspan=(ny0 - 0.13, py1 + 0.13)
  nd0 = rect diff xspan=(s1.left - 0.265, s2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd1 = rect diff xspan=(s3.left - 0.265, s4.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(s5.left - 0.265, s7.right + 0.265) yspan=(ny0, ny0 + WN2)
  pd0 = rect diff xspan=(s1.left - 0.265, s2.right + 0.265) yspan=(py1 - WP, py1)
  pd1 = rect diff xspan=(s3.left - 0.265, s4.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(s5.left - 0.265, s7.right + 0.265) yspan=(py1 - WP2, py1)
  nim = enclose [nd0, nd1, nd2] nsdm
  pim = enclose [pd0, pd1, pd2] psdm
  n0s = array licon in=nd0 left_of=s1
  n0sl = enclose n0s li net=SUM
  n0v = array licon in=nd0 between=[s1, s2]
  n0vl = enclose n0v li net=VGND
  n0vs = strap li from=n0vl to=vgnd_li
  n0c = array licon in=nd0 right_of=s2
  n0cl = enclose n0c li net=COUT
  n1v = array licon in=nd1 left_of=s3
  n1vl = enclose n1v li net=VGND
  n1vs = strap li from=n1vl to=vgnd_li
  n1n = array licon in=nd1 right_of=s4
  n1nl = enclose n1n li net=n1
  n2a = array licon in=nd2 left_of=s5
  n2al = enclose n2a li net=n4
  n2v = array licon in=nd2 between=[s5, s6]
  n2vl = enclose n2v li net=VGND
  n2vs = strap li from=n2vl to=vgnd_li
  n2b = array licon in=nd2 between=[s6, s7]
  n2bl = enclose n2b li net=n4
  n2c = array licon in=nd2 right_of=s7
  n2cl = enclose n2c li net=n3
  p0s = array licon in=pd0 left_of=s1
  p0sl = enclose p0s li net=SUM
  p0v = array licon in=pd0 between=[s1, s2]
  p0vl = enclose p0v li net=VPWR
  p0vs = strap li from=p0vl to=vpwr_li
  p0c = array licon in=pd0 right_of=s2
  p0cl = enclose p0c li net=COUT
  p1v = array licon in=pd1 left_of=s3
  p1vl = enclose p1v li net=VPWR
  p1vs = strap li from=p1vl to=vpwr_li
  p1n = array licon in=pd1 between=[s3, s4]
  p1nl = enclose p1n li net=n1
  p1r = array licon in=pd1 right_of=s4
  p1rl = enclose p1r li net=VPWR
  p1rs = strap li from=p1rl to=vpwr_li
  p2v = array licon in=pd2 left_of=s5
  p2vl = enclose p2v li net=VPWR
  p2vs = strap li from=p2vl to=vpwr_li
  p2n = array licon in=pd2 between=[s6, s7]
  p2nl = enclose p2n li net=n3
  p2r = array licon in=pd2 right_of=s7
  p2rl = enclose p2r li net=VPWR
  p2rs = strap li from=p2rl to=vpwr_li
  cb = max(nd0.top + 0.19, nd1.top + 0.19, nd2.top + 0.19, n0sl.top + 0.25, n0vl.top + 0.25, n0cl.top + 0.25, n1vl.top + 0.25, n1nl.top + 0.25, n2al.top + 0.25, n2vl.top + 0.25, n2bl.top + 0.25, n2cl.top + 0.25)
  gc1 = contact licon cx=s1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=n3
  gc2 = contact licon cx=s2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=n1
  gc3 = contact licon cx=s3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=A
  gc4 = contact licon cx=s4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B
  gc5 = contact licon cx=s5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A
  gc6 = contact licon cx=s6.cx bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=B
  gc7 = contact licon cx=s7.cx bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=n1
  gn  = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc
  well y=((max(nd0.top, nd1.top, nd2.top) + 0.34 + min(pd0.bottom, pd1.bottom, pd2.bottom) - 0.18) / 2)
  am = contact mcon in=gl3
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl4
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port SUM out
  port COUT out
  route n1 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route SUM layers=m1,m2 prefer=m2
  route COUT layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
end
