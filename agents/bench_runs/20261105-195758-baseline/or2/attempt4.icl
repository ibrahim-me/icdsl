pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=10 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  dw  = 3*L + 1.838
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265) ext=(0,0)
  gb  = cross [nd, pd] poly w=L left=(ga.right + L + 0.28) ext=(0,0)
  gn2 = cross [nd, pd] poly w=L left=(gb.right + L + 0.28) ext=(0,0)

  # n row: VGND | ga | n2 | gb | VGND | gn2 | X
  cn  = array licon in=nd left_of=ga
  cn2 = array licon in=nd right_of=ga
  cv  = array licon in=nd right_of=gb
  sx  = array licon in=nd right_of=gn2
  cnl  = enclose cn li
  cn2l = enclose cn2 li net=n2
  cvl  = enclose cv li
  sxl  = enclose sx li net=X
  gnd1 = strap li from=cnl to=vgnd_li
  gnd2 = strap li from=cvl to=vgnd_li

  # p row: VPWR | ga | n1 | gb | n2 | gn2 | X | VPWR
  cp  = array licon in=pd left_of=ga
  cn1 = array licon in=pd right_of=gb
  cn2p= array licon in=pd right_of=gn2
  sxp = array licon in=pd right_of=cn2p
  svp = array licon in=pd right_of=sxp
  cpl = enclose cp li
  c1l = enclose cn1 li net=n1
  c2l = enclose cn2p li net=n2
  s2l = enclose sxp li net=X
  sv2 = enclose svp li
  pwr1= strap li from=cpl to=vpwr_li
  pwr2= strap li from=sv2 to=vpwr_li

  # join X nets on met1 (different rows, cannot strap)
  route X layers=m1

  # gate contacts in gap between rows, pushed outwards so pads clear
  cb  = max(nd.top + 0.19, cnl.top + 0.25, cvl.top + 0.25,
            cpl.top + 0.25, c2l.top + 0.25, sv2.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcn = contact licon cx=(gn2.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gnn = enclose [gca, gcb, gcn] npc
  ag  = enclose gca li net=A
  bg  = enclose gcb li net=B
  n2g = enclose gcn li net=n2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ports on met1
  am  = contact mcon in=ag
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bg
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=s2l
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
