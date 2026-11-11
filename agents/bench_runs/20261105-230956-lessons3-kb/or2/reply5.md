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

  p = 0.42                      # gate-to-gate gap -> pitch L+p = 0.57 (>= 0.54 for 0.33 um gate-contact pads)
  dw  = 3*L + 2*p + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order (both rows): n2, A, B   (output X drains line up on the left)
  gn = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate n2
  ga = cross [nd, pd] poly w=L left=(gn.right + p)             # gate A
  gb = cross [nd, pd] poly w=L left=(ga.right + p)             # gate B

  # n-row: X | VGND | n2 | VGND   (M1,M3,M2)
  cxn  = array licon in=nd left_of=gn            # X (M1 source)
  cvn0 = array licon in=nd between=[gn, ga]      # VGND (M1 drain / M3 source)
  cnn  = array licon in=nd between=[ga, gb]      # n2  (M3 drain / M2 source)
  cvn1 = array licon in=nd right_of=gb           # VGND (M2 drain)
  cxnl = enclose cxn li net=X
  cvn0l= enclose cvn0 li net=VGND
  cnnl = enclose cnn li net=n2
  cvn1l= enclose cvn1 li net=VGND
  gnd0 = strap li from=cvn0l to=vgnd_li
  gnd1 = strap li from=cvn1l to=vgnd_li

  # p-row: X | VPWR | n1 | n2    (M5,M0,M4)
  cxp  = array licon in=pd left_of=gn            # X (M5 source)
  cvp  = array licon in=pd between=[gn, ga]      # VPWR (M5 drain / M0 source)
  cnp1 = array licon in=pd between=[ga, gb]      # n1  (M0 drain / M4 source)
  cnp0 = array licon in=pd right_of=gb           # n2  (M4 drain)
  cxpl = enclose cxp li net=X
  cvpl = enclose cvp li net=VPWR
  cnp1l= enclose cnp1 li net=n1
  cnp0l= enclose cnp0 li net=n2
  pwrp = strap li from=cvpl to=vpwr_li

  # output X: join n-row and p-row drains on metal (avoids li strap next to gate contact)
  route X layers=m1,m2

  # gate contacts in the gap between the rows (n-row items only in cb); centred on their gates
  cb = max(nd.top + 0.19, cxnl.top + 0.25, cvn0l.top + 0.25, cnnl.top + 0.25, cvn1l.top + 0.25)
  gcn = contact licon cx=(gn.cx) bottom=cb          # gate n2 contact
  gca = contact licon cx=(ga.cx) bottom=cb          # gate A contact
  gcb = contact licon cx=(gb.cx) bottom=cb          # gate B contact
  gnn = enclose gcn poly by=minx
  gaa = enclose gca poly by=minx
  gbb = enclose gcb poly by=minx
  gnnpc = enclose [gcn, gca, gcb] npc
  nl2 = enclose gcn li net=n2
  al  = enclose gca li net=A
  bl  = enclose gcb li net=B
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