```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # gate order (both rows): B, A, n2
  # n-row: VGND | n2 | VGND | X   (M2,M3,M1)
  # p-row: n2 | n1 | VPWR | X    (M4,M0,M5)
  dw  = 3*L + 2*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gb = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate B
  ga = cross [nd, pd] poly w=L left=(gb.right + 0.28)          # gate A
  gn = cross [nd, pd] poly w=L left=(ga.right + 0.28)          # gate n2

  # n-row contacts
  cvn0 = array licon in=nd left_of=gb            # VGND (M2 drain)
  cnn  = array licon in=nd between=[gb, ga]      # n2  (M2 source / M3 drain)
  cvn1 = array licon in=nd between=[ga, gn]      # VGND (M3 source / M1 drain)
  cxn  = array licon in=nd right_of=gn           # X (M1 source)
  cvn0l= enclose cvn0 li net=VGND
  cnnl = enclose cnn li net=n2
  cvn1l= enclose cvn1 li net=VGND
  cxnl = enclose cxn li net=X
  gnd0 = strap li from=cvn0l to=vgnd_li
  gnd1 = strap li from=cvn1l to=vgnd_li

  # p-row contacts
  cnp0 = array licon in=pd left_of=gb            # n2 (M4 drain)
  cnp1 = array licon in=pd between=[gb, ga]      # n1 (M4 source / M0 drain)
  cvp  = array licon in=pd between=[ga, gn]      # VPWR (M0 source / M5 drain)
  cxp  = array licon in=pd right_of=gn           # X (M5 source)
  cnp0l= enclose cnp0 li net=n2
  cnp1l= enclose cnp1 li net=n1
  cvpl = enclose cvp li net=VPWR
  cxpl = enclose cxp li net=X
  pwrp = strap li from=cvpl to=vpwr_li

  # output X: n-row and p-row drains line up (right of gn)
  yst  = strap li from=cxnl to=cxpl net=X

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, cvn0l.top + 0.25, cnnl.top + 0.25, cvn1l.top + 0.25, cxnl.top + 0.25)
  gcb = contact licon cx=(gb.cx) bottom=cb          # gate B contact
  gca = contact licon cx=(ga.cx) bottom=cb          # gate A contact
  gcn = contact licon cx=(gn.cx - 0.13) bottom=cb   # gate n2 contact, away from output strap
  gbb = enclose gcb poly by=minx
  gaa = enclose gca poly by=minx
  gnn = enclose gcn poly by=minx
  gnnpc = enclose [gcb, gca, gcn] npc
  bl  = enclose gcb li net=B
  al  = enclose gca li net=A
  nl2 = enclose gcn li net=n2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # internal nets n1, n2: drain li strips and gate-contact li share the net
  route n1 layers=m1,m2
  route n2 layers=m1,m2

  am  = contact mcon in=al
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bl
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=cxpl cy=(pd.cy)
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```