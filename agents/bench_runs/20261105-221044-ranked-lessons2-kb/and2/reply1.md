```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=VPWR g=B s=n1
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  nd  = rect diff w=min h=WN cx=cell.cx above=ptap
  pd  = rect diff w=min h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  pitch = max(0.54, L + 0.28)
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.21, 0.54 - L))
  gn  = cross [nd, pd] poly w=L left=(gb.right + pitch)

  # n row: n1 | gA | n2 | gB | VGND | gN | X
  cn1 = array licon in=nd left_of=ga
  cn2 = array licon in=nd between=[ga, gb]
  cv  = array licon in=nd between=[gb, gn]
  cx  = array licon in=nd right_of=gn
  cn1l = enclose cn1 li net=n1
  cn2l = enclose cn2 li
  cvl = enclose cv li
  cxl = enclose cx li net=X
  gndn = strap li from=cvl to=vgnd_li

  # p row: VPWR | gA | n1 | gB | VPWR | gN | X
  cp1 = array licon in=pd left_of=ga
  cpn = array licon in=pd between=[ga, gb]
  cp2 = array licon in=pd between=[gb, gn]
  cpx = array licon in=pd right_of=gn
  cp1l = enclose cp1 li net=VPWR
  cpnl = enclose cpn li net=n1
  cp2l = enclose cp2 li net=VPWR
  cpxl = enclose cpx li net=X
  pwr1 = strap li from=cp1l to=vpwr_li
  pwr2 = strap li from=cp2l to=vpwr_li

  # gate contacts in the gap between the rows, shifted so pads clear
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.13) bottom=cb
  gcn = contact licon cx=(gn.cx + 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gnall = enclose [gca, gcb, gcn] npc
  al = enclose gca li net=A
  bl = enclose gcb li net=B
  nl = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # supply straps
  gndp = strap li from=cp1l to=vpwr_li
  gndp2 = strap li from=cp2l to=vpwr_li

  # output X: join n and p drain columns
  route X layers=m1,m2

  # input ports
  am = contact mcon in=al
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bl
  bp = enclose bm m1 by=0.06 net=B
  port A in on=ap
  port B in on=bp

  # output port on routed met1
  port X out
end
```