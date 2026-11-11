pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # n-row: X | n2 | VGND | B | n2 | A | VGND   (M1,M2,M3)
  # p-row: n2 | B | n1 | A | VPWR | n2 | X     (M4,M0,M5)
  dw  = 4*L + 3*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gn2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate net n2
  gb  = cross [nd, pd] poly w=L left=(gn2.right + 0.28)         # gate net B
  ga  = cross [nd, pd] poly w=L left=(gb.right + 0.28)          # gate net A

  # n-row contacts
  cxn = array licon in=nd left_of=gn2            # X
  cvn = array licon in=nd between=[gn2, gb]      # VGND (M1 drain / M2 drain)
  cnn = array licon in=nd between=[gb, ga]       # n2  (M2 source / M3 drain)
  cvn2= array licon in=nd right_of=ga            # VGND (M3 source)
  cxnl= enclose cxn li net=X
  cvnl= enclose cvn li net=VGND
  cnnl= enclose cnn li net=n2
  cvn2l= enclose cvn2 li net=VGND
  gndn= strap li from=cvnl to=vgnd_li
  gndn2= strap li from=cvn2l to=vgnd_li

  # p-row contacts
  cnp = array licon in=pd left_of=gb             # n2 (M4 drain)
  cnp1= array licon in=pd between=[gb, ga]       # n1 (M4 source / M0 drain)
  cvp = array licon in=pd between=[ga, gn2]      # VPWR (M0 source / M5 drain)
  cxp = array licon in=pd right_of=gn2           # X (M5 source)
  cnp1l= enclose cnp1 li net=n1
  cnpl= enclose cnp li net=n2
  cvpl= enclose cvp li net=VPWR
  cxpl= enclose cxp li net=X
  pwrp= strap li from=cvpl to=vpwr_li

  # output strap joins n-row X and p-row X
  yst = strap li from=cxnl to=cxpl net=X

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, cxnl.top + 0.25, cvnl.top + 0.25, cnnl.top + 0.25, cvn2l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb   # gate A contact, away from output strap
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb   # gate B contact
  gcn = contact licon cx=(gn2.cx) bottom=cb         # gate n2 contact
  gaa = enclose gca poly by=minx
  gbb = enclose gcb poly by=minx
  gnn = enclose gcn poly by=minx
  gna = enclose [gca, gcb, gcn] npc
  al  = enclose gca li net=A
  bl  = enclose gcb li net=B
  nl2 = enclose gcn li net=n2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # internal nets n1, n2: drain li strips and gate-contact li share the net, routed on m1/m2
  route n1 layers=m1,m2
  route n2 layers=m1,m2

  # supply straps
  gndp = strap li from=cnpl to=vpwr_li   # placeholder removed below
  # (n1 net has no supply strap; M0 source VPWR and M4 source n1 handled above)

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
