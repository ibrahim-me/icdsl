pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=10 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  nd  = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order left->right: n2 (M1/M5), A (M0/M3), B (M2/M4)
  gn2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L left=(gn2.right + L + 0.21)
  gb  = cross [nd, pd] poly w=L left=(ga.right + L + 0.21)

  # n row: X | gn2 | VGND | ga | n2 | gb | VGND
  sn1 = array licon in=nd left_of=gn2          # X (M1 source)
  cn  = array licon in=nd right_of=gn2         # VGND (M1 d / M3 s)
  cn2 = array licon in=nd right_of=ga          # n2 (M3 d / M2 s)
  dn  = array licon in=nd right_of=gb          # VGND (M2 drain)
  sn1l = enclose sn1 li net=X
  cnl  = enclose cn li
  cn2l = enclose cn2 li net=n2
  dnl  = enclose dn li
  gndn = strap li from=cnl to=vgnd_li
  gndn2= strap li from=dnl to=vgnd_li

  # p row: X | gn2 | VPWR | ga | n1 | gb | n2
  sp1 = array licon in=pd left_of=gn2          # X (M5 drain)
  cp  = array licon in=pd right_of=gn2         # VPWR (M5 s / M0 s)
  cp2 = array licon in=pd right_of=gb          # n2 (M4 drain)
  spl = enclose sp1 li net=X
  cpl = enclose cp li
  c2l = enclose cp2 li net=n2
  pwrp= strap li from=cpl to=vpwr_li
  pwrp2=strap li from=cpl to=vpwr_li           # same net, both rails tied

  # gate contacts in the gap between the rows, pushed outwards so pads clear
  cb  = max(nd.top + 0.19, cnl.top + 0.25, dnl.top + 0.25, cpl.top + 0.25, c2l.top + 0.25)
  gcn = contact licon cx=(gn2.cx - 0.1) bottom=cb
  gca = contact licon cx=(ga.cx + 0.1)  bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1)  bottom=cb
  gpn = enclose gcn poly by=minx
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gnn = enclose [gcn, gca, gcb] npc
  n2g = enclose gcn li net=n2
  ag  = enclose gca li net=A
  bg  = enclose gcb li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input ports
  am  = contact mcon in=ag
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bg
  bp  = enclose bm m1 by=0.06 net=B
  # output port: X from n-side source strap
  xm  = contact mcon in=sn1l
  xp  = enclose xm m1 by=0.06 net=X
  # internal nets n1, n2 need no met1 pin

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
