pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell buf width=10 height=H
  device MN1 nmos w=WN l=L d=n1 g=A s=VGND
  device MP1 pmos w=WP l=L d=n1 g=A s=VPWR
  device MN2 nmos w=WN l=L d=X g=n1 s=VGND
  device MP2 pmos w=WP l=L d=X g=n1 s=VPWR

  col = 0.46
  dw  = L + 0.53
  x1  = cell.left + col + 0.52
  x2  = cell.right - col - 0.52

  # Inverter 1 (A -> n1): sources outboard left, drains inboard right
  nd1 = rect diff w=dw h=WN cx=x1 above=ptap
  pd1 = rect diff w=dw h=WP cx=x1 below=ntap
  g1  = cross [nd1, pd1] poly w=L
  sn1 = array licon in=nd1 left_of=g1
  dn1 = array licon in=nd1 right_of=g1
  sp1 = array licon in=pd1 left_of=g1
  dp1 = array licon in=pd1 right_of=g1
  sn1l = enclose sn1 li
  dn1l = enclose dn1 li
  sp1l = enclose sp1 li
  dp1l = enclose dp1 li
  gnd1 = strap li from=sn1l to=vgnd_li
  pwr1 = strap li from=sp1l to=vpwr_li
  n1d  = strap li from=dn1l to=dp1l

  # Inverter 2 (n1 -> X): sources outboard right, drains inboard left
  nd2 = rect diff w=dw h=WN cx=x2 above=ptap
  pd2 = rect diff w=dw h=WP cx=x2 below=ntap
  g2  = cross [nd2, pd2] poly w=L
  sn2 = array licon in=nd2 right_of=g2
  dn2 = array licon in=nd2 left_of=g2
  sp2 = array licon in=pd2 right_of=g2
  dp2 = array licon in=pd2 left_of=g2
  sn2l = enclose sn2 li
  dn2l = enclose dn2 li
  sp2l = enclose sp2 li
  dp2l = enclose dp2 li
  gnd2 = strap li from=sn2l to=vgnd_li
  pwr2 = strap li from=sp2l to=vpwr_li
  xd   = strap li from=dn2l to=dp2l

  # Internal node n1: inv1 drains to inv2 gate
  gc2  = contact licon left_of=g2 xspace=0.17 bottom=max(nd2.top + 0.19, sn2l.top + 0.25, dn2l.top + 0.25)
  gp2  = enclose gc2 poly by=minx
  gn2  = enclose gc2 npc
  gc2l = enclose gc2 li
  n1   = strap li from=n1d to=gc2l

  # Input A: gate contact of inv1 over n-diff only
  ga   = contact licon left_of=g1 xspace=0.17 bottom=max(nd1.top + 0.19, sn1l.top + 0.25, dn1l.top + 0.25)
  gpa  = enclose ga poly by=minx
  gna  = enclose ga npc
  al   = enclose ga li net=A
  am   = contact mcon in=al
  ap   = enclose am m1 by=0.06 net=A
  port A in on=ap

  # Output X: drain of inv2 -> met1
  xm   = contact mcon in=xd
  xp   = enclose xm m1 by=0.06 net=X
  port X out on=xp

  # Single n-well enclosing both p-diffs by 0.18, clear of n-diff/tap by 0.34, ptap by 0.13
  nwb = enclose [pd1, pd2] nwell by=0.18
  well y=max(nwb.bottom, ptap.top + 0.13, ntap.bottom + 0.34 - nwb.h)
end
