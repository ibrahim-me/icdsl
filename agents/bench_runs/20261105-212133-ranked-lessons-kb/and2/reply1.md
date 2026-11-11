```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 4*L + 2*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gn  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))

  # n-row: n1 | n2 | VGND | X   (gates A, B, n1)
  sn1 = array licon in=nd left_of=ga net=n1
  sn2 = array licon in=nd between=[ga, gb] net=n2
  svn = array licon in=nd between=[gb, gn] net=VGND
  sxn = array licon in=nd right_of=gn net=X
  sn1l = enclose sn1 li net=n1
  sn2l = enclose sn2 li net=n2
  svnl = enclose svn li net=VGND
  sxnl = enclose sxn li net=X
  gndn = strap li from=svnl to=vgnd_li

  # p-row: VPWR | n1 | VPWR | X   (gates A, B, n1)
  sp1 = array licon in=pd left_of=ga net=VPWR
  spn = array licon in=pd between=[ga, gb] net=n1
  sp2 = array licon in=pd between=[gb, gn] net=VPWR
  sxp = array licon in=pd right_of=gn net=X
  sp1l = enclose sp1 li net=VPWR
  spnl = enclose spn li net=n1
  spl2 = enclose sp2 li net=VPWR
  sxpl = enclose sxp li net=X
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=spl2 to=vpwr_li

  # gate contacts in the gap between the rows, n-row items only for cb
  cb = max(nd.top + 0.19, sn1l.top + 0.25, sn2l.top + 0.25, svnl.top + 0.25, sxnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gnall = enclose [gca, gcb, gcn] npc
  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  nn = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output X: n-side and p-side drains line up vertically
  yx = strap li from=sxnl to=sxpl net=X

  # input / internal nets
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bb
  bp = enclose bm m1 by=0.06 net=B
  nm = contact mcon in=nn
  np = enclose nm m1 by=0.06 net=n1
  xm = contact mcon in=yx
  xp = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```