```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 1.14                      # 2 x 0.265 end contacts + 0.80 island break + 2 x L gates
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L left=(ga.right + 0.80)

  # n-row: VGND | A | n1 | (break) | X | n1 | VGND
  cn0 = array licon in=nd left_of=ga
  cn1 = array licon in=nd between=[ga, gn] net=n1
  cxn = array licon in=nd between=[ga, gn] net=X
  cn3 = array licon in=nd right_of=gn
  cn0l = enclose cn0 li
  cn1l = enclose cn1 li net=n1
  cxnl = enclose cxn li net=X
  cn3l = enclose cn3 li
  gndn = strap li from=cn0l to=vgnd_li
  gndn2 = strap li from=cn3l to=vgnd_li

  # p-row: VPWR | A | n1 | (break) | X | n1 | VPWR
  cp0 = array licon in=pd left_of=ga
  cp1 = array licon in=pd between=[ga, gn] net=n1
  cxp = array licon in=pd between=[ga, gn] net=X
  cp3 = array licon in=pd right_of=gn
  cp0l = enclose cp0 li
  cp1l = enclose cp1 li net=n1
  cxpl = enclose cxp li net=X
  cp3l = enclose cp3 li
  pwrp = strap li from=cp0l to=vpwr_li
  pwrp2 = strap li from=cp3l to=vpwr_li

  # output strap joins n- and p-side X drains (they line up vertically)
  xy  = strap li from=cxnl to=cxpl net=X

  # gate contacts on their own gates, in the gap between the diff rows
  cb  = max(nd.top + 0.19, cn1l.top + 0.25, cn0l.top + 0.25, cn3l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gnall = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  nn  = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # internal net n1: n-row drain, p-row drain and the n1 gate contact
  route n1 layers=m1,m2

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  xm  = contact mcon in=xy cy=(nd.cy)
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
```