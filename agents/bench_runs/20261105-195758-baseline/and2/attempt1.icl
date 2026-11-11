pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=8 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=VPWR g=B s=n1
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  # diffusion pitch: end contact column + device width + shared column
  p0 = 0.265 + WN + 0.28
  p1 = 0.265 + WN2 + 0.28
  p2 = 0.265 + WN2 + 0.28
  dw = p0 + p1 + p2                      # total n-diffusion width
  q0 = 0.265 + WP2 + 0.28
  q1 = 0.265 + WP2 + 0.28
  q2 = 0.265 + WP  + 0.28
  dwp = q0 + q1 + q2                     # total p-diffusion width
  dw = max(dw, dwp)                      # common width so gate x-positions match

  # n-row: X | M0(n1) | VGND | M4(B) | n2 | M2(A) | n1   (heights WN, WN2, WN2)
  nd0 = rect diff w=p0 h=WN right=(cell.cx - dw/2 + p0) above=ptap
  nd1 = rect diff w=p1 h=WN2 left=nd0.right above=ptap
  nd2 = rect diff w=p2 h=WN2 left=nd1.right above=ptap
  nd  = enclose [nd0, nd1, nd2] nsdm

  # p-row: X | M5(n1) | VPWR | M3(B) | n1 | M1(A) | VPWR (heights WP, WP2, WP2)
  pd0 = rect diff w=q0 h=WP right=(cell.cx - dw/2 + q0) below=ntap
  pd1 = rect diff w=q1 h=WP2 left=pd0.right below=ntap
  pd2 = rect diff w=q2 h=WP2 left=pd1.right below=ntap
  pd  = enclose [pd0, pd1, pd2] psdm

  # shared gate x-centres (n1, B, A) - identical in both rows
  xn1 = cell.cx - dw/2 + p0/2
  xb  = cell.cx - dw/2 + p0 + p1/2
  xa  = cell.cx - dw/2 + p0 + p1 + p2/2

  gn1 = cross [nd, pd] poly w=L cx=xn1
  gb  = cross [nd, pd] poly w=L cx=xb
  ga  = cross [nd, pd] poly w=L cx=xa

  # n-row contacts
  sn0 = array licon in=nd0 left_of=gn1          # X drain of M0
  dn0 = array licon in=nd0 right_of=gn1         # VGND source of M0
  sn1 = array licon in=nd1 left_of=gb           # VGND drain of M4
  dn1 = array licon in=nd1 right_of=gb          # n2 source of M4
  sn2 = array licon in=nd2 left_of=ga           # n2 drain of M2
  dn2 = array licon in=nd2 right_of=ga          # n1 drain of M2
  snl = enclose [sn0, sn1, sn2] li
  dnl = enclose [dn0, dn1, dn2] li net=VGND
  n2l = enclose [dn1, sn2] li net=n2            # shared column M4 source / M2 drain
  xnl = enclose sn0 li net=X                    # M0 source = output X

  # p-row contacts
  sp0 = array licon in=pd0 left_of=gn1          # X source of M5
  dp0 = array licon in=pd0 right_of=gn1         # VPWR drain of M5
  sp1 = array licon in=pd1 left_of=gb           # VPWR source of M3
  dp1 = array licon in=pd1 right_of=gb          # n1 drain of M3
  sp2 = array licon in=pd2 left_of=ga           # n1 source of M1
  dp2 = array licon in=pd2 right_of=ga          # VPWR drain of M1
  spl = enclose [sp0, sp1, sp2] li
  dpl = enclose [dp0, dp1, dp2] li net=VPWR
  n1p = enclose [dp1, sp2] li net=n1            # shared column M3 drain / M1 source

  # rails
  gnd = strap li from=dnl to=vgnd_li
  pwr = strap li from=dpl to=vpwr_li

  # n1 net: p-row shared diffusion column <-> n-row M2 drain column <-> M0/M5 gates
  route n1 layers=m1

  # gate contacts in the gap between the rows, pushed apart so poly pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, spl.top + 0.25, dpl.top + 0.25)
  gcn = contact licon cx=(xn1 - 0.1) bottom=cb
  gcb = contact licon cx=xb                    bottom=cb
  gca = contact licon cx=(xa + 0.1) bottom=cb
  gpn = enclose gcn poly by=minx
  gpb = enclose gcb poly by=minx
  gpa = enclose gca poly by=minx
  gnn = enclose [gcn, gcb, gca] npc
  an1 = enclose gcn li net=n1
  ab  = enclose gcb li net=B
  aa  = enclose gca li net=A

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output X: n-row source column and p-row source column joined on m1
  xm  = contact mcon in=xnl
  xp  = enclose xm m1 by=0.06 net=X
  xm2 = contact mcon in=spl cy=(spl.top - 0.3)
  xp2 = enclose xm2 m1 by=0.06 net=X
  route X layers=m1

  # inputs A, B
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=B

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
