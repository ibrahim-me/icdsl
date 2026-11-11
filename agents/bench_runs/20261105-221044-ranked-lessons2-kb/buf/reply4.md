```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=7 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  ec  = 0.30                            # end contact column (diffusion)
  mg  = 0.34                            # middle contact column (shared supply)
  dw  = ec + L + mg + L + ec            # n1 | gateA | VGND | gateN1 | X
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + ec)
  gn  = cross [nd, pd] poly w=L left=(ga.right + mg)

  # n row: n1(drain M2) | gateA | VGND(shared) | gateN1 | X(source M0)
  sn  = array licon in=nd left_of=ga
  sv  = array licon in=nd between=[ga, gn]
  sx  = array licon in=nd right_of=gn
  snl = enclose sn li net=n1
  svl = enclose sv li
  sxl = enclose sx li net=X
  gnd = strap li from=svl to=vgnd_li

  # p row: n1(drain M1) | gateA | VPWR(shared) | gateN1 | X(source M3)
  sp  = array licon in=pd left_of=ga
  pv  = array licon in=pd between=[ga, gn]
  px  = array licon in=pd right_of=gn
  spl = enclose sp li net=n1
  pvl = enclose pv li
  pxl = enclose px li net=X
  pwr = strap li from=pvl to=vpwr_li

  # join the two n1 drains (n and p rows)
  n1s = strap li from=snl to=spl net=n1

  # output strap joins n-side X and p-side X columns
  yst = strap li from=sxl to=pxl net=X

  # gate contacts on their own gates, in the gap between the rows
  cb  = max(nd.top + 0.19, snl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gnc = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  nn  = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  nm  = contact mcon in=nn
  np  = enclose nm m1 by=0.06 net=n1
  xm  = contact mcon in=yst
  xp  = enclose xm m1 by=0.06 net=X
  route n1 layers=m1,m2

  port A in  on=ap
  port X out on=xp
end
```