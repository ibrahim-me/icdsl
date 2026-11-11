pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81                      # n1 | gateA | supply | gateN1 | X
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L left=(ga.right + 0.28)

  # n row: n1(drain M2) | gateA | VGND(shared) | gateN1 | X(source M0)
  sn  = array licon in=nd left_of=ga            # n1 drain of M2
  sv  = array licon in=nd between=[ga, gn]      # VGND shared column
  sx  = array licon in=nd right_of=gn           # X source of M0
  snl = enclose sn li net=n1
  svl = enclose sv li
  sxl = enclose sx li net=X
  gnd = strap li from=svl to=vgnd_li

  # p row: n1(drain M1) | gateA | VPWR(shared) | gateN1 | X(source M3)
  sp  = array licon in=pd left_of=ga            # n1 drain of M1
  pv  = array licon in=pd between=[ga, gn]      # VPWR shared column
  px  = array licon in=pd right_of=gn           # X source of M3
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
  nm  = contact mcon in=nn cy=(cb - 0.12)
  np  = enclose nm m1 by=0.06 net=n1
  xm  = contact mcon in=yst cy=(cb + 0.12)
  xp  = enclose xm m1 by=0.06 net=X
  route n1 layers=m1,m2

  port A in  on=ap
  port X out on=xp
end
