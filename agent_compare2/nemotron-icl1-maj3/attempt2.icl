pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=11 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4
  device M3 nmos w=WN l=L d=VGND g=n3 s=X
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3

  # Gate order: A B C n3 (same for both rows)
  # NMOS stick: VGND [A] n2 [B] n3 [C] n5 | n3 [n3] X
  # PMOS stick: VPWR [A] n1 [B] n6 [C] n1 | n3 [n3] X

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  span = 0.53 + 4*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L) + max(0.80, 0.54 - L) + max(0.21, 0.54 - L)
  x0 = cell.cx - span/2

  gA = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB = rect poly w=L left=(gA.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gC = rect poly w=L left=(gB.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gN = rect poly w=L left=(gC.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)

  # NMOS diffusion islands
  nd_left = rect diff xspan=(gA.left - 0.265, gC.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd_right = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(ny0, ny0 + WN)

  # PMOS diffusion islands
  pd_left = rect diff xspan=(gA.left - 0.265, gC.right + 0.265) yspan=(py1 - WP2, py1)
  pd_right = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(py1 - WP, py1)

  nim = enclose [nd_left, nd_right] nsdm
  pim = enclose [pd_left, pd_right] psdm

  # NMOS contacts (left island: gates A, B, C)
  cA_n_l = array licon in=nd_left left_of=gA
  cA_n_l_l = enclose cA_n_l li net=VGND
  cA_n_r = array licon in=nd_left right_of=gA
  cA_n_r_l = enclose cA_n_r li net=n2
  cB_n_l = array licon in=nd_left left_of=gB
  cB_n_l_l = enclose cB_n_l li net=n2
  cB_n_r = array licon in=nd_left right_of=gB
  cB_n_r_l = enclose cB_n_r li net=n3
  cC_n_l = array licon in=nd_left left_of=gC
  cC_n_l_l = enclose cC_n_l li net=n3
  cC_n_r = array licon in=nd_left right_of=gC
  cC_n_r_l = enclose cC_n_r li net=n5

  # NMOS contacts (right island: gate n3)
  cN_n_l = array licon in=nd_right left_of=gN
  cN_n_l_l = enclose cN_n_l li net=n3
  cN_n_r = array licon in=nd_right right_of=gN
  cN_n_r_l = enclose cN_n_r li net=X

  # PMOS contacts (left island: gates A, B, C)
  cA_p_l = array licon in=pd_left left_of=gA
  cA_p_l_l = enclose cA_p_l li net=VPWR
  cA_p_r = array licon in=pd_left right_of=gA
  cA_p_r_l = enclose cA_p_r li net=n1
  cB_p_l = array licon in=pd_left left_of=gB
  cB_p_l_l = enclose cB_p_l li net=n1
  cB_p_r = array licon in=pd_left right_of=gB
  cB_p_r_l = enclose cB_p_r li net=n6
  cC_p_l = array licon in=pd_left left_of=gC
  cC_p_l_l = enclose cC_p_l li net=n6
  cC_p_r = array licon in=pd_left right_of=gC
  cC_p_r_l = enclose cC_p_r li net=n1

  # PMOS contacts (right island: gate n3)
  cN_p_l = array licon in=pd_right left_of=gN
  cN_p_l_l = enclose cN_p_l li net=n1
  cN_p_r = array licon in=pd_right right_of=gN
  cN_p_r_l = enclose cN_p_r li net=X

  # Supply straps
  sA_n = strap li from=cA_n_l_l to=vgnd_li
  sB_n = strap li from=cB_n_l_l to=vgnd_li
  sC_n = strap li from=cC_n_l_l to=vgnd_li
  sN_n = strap li from=cN_n_l_l to=vgnd_li

  sA_p = strap li from=cA_p_l_l to=vpwr_li
  sB_p = strap li from=cB_p_l_l to=vpwr_li
  sC_p = strap li from=cC_p_l_l to=vpwr_li
  sN_p = strap li from=cN_p_l_l to=vpwr_li

  # Internal net routes
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n6 layers=m1,m2 prefer=m2

  # Output X: connect n and p drains
  yx = strap li from=cN_n_r_l to=cN_p_r_l net=X

  # Gate contacts
  cb = max(nd_left.top + 0.19, nd_right.top + 0.19,
           cA_n_l_l.top + 0.25, cA_n_r_l.top + 0.25,
           cB_n_l_l.top + 0.25, cB_n_r_l.top + 0.25,
           cC_n_l_l.top + 0.25, cC_n_r_l.top + 0.25,
           cN_n_l_l.top + 0.25, cN_n_r_l.top + 0.25)

  gcA = contact licon cx=gA.cx bottom=cb
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A

  gcB = contact licon cx=gB.cx bottom=cb
  gpB = enclose gcB poly by=minx
  glB = enclose gcB li net=B

  gcC = contact licon cx=gC.cx bottom=cb
  gpC = enclose gcC poly by=minx
  glC = enclose gcC li net=C

  gcN = contact licon cx=gN.cx bottom=cb
  gpN = enclose gcN poly by=minx
  glN = enclose gcN li net=n3

  gn = enclose [gcA, gcB, gcC, gcN] npc

  # Well
  well y=((max(nd_left.top, nd_right.top) + 0.34 + min(pd_left.bottom, pd_right.bottom) - 0.18) / 2)

  # Input ports
  am = contact mcon in=glA
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  bm = contact mcon in=glB
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  cm = contact mcon in=glC
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp

  # Route all nets
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
  route C layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2

  # Output port
  port X out
end