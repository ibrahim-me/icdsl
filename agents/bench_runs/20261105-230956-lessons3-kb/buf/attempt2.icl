pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81                      # 2 x 0.265 end contacts + 0.28 (shared VGND/VPWR contact between the gates)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # n-row: n1 | ga(A) | VGND | gn(n1) | X
  cn1 = array licon in=nd left_of=ga           net=n1
  cnv = array licon in=nd between=[ga, gn]     net=VGND
  cnx = array licon in=nd right_of=gn          net=X
  cn1l = enclose cn1 li net=n1
  cnvl = enclose cnv li net=VGND
  cnxl = enclose cnx li net=X
  gndn = strap li from=cn1l to=vgnd_li         # n1 column also reaches VGND rail? no - keep separate
  gndv = strap li from=cnvl to=vgnd_li
  gndx = strap li from=cnxl to=vgnd_li

  # p-row: n1 | ga(A) | VPWR | gn(n1) | X
  cp1 = array licon in=pd left_of=ga           net=n1
  cpv = array licon in=pd between=[ga, gn]     net=VPWR
  cpx = array licon in=pd right_of=gn          net=X
  cp1l = enclose cp1 li net=n1
  cpvl = enclose cpv li net=VPWR
  cpxl = enclose cpx li net=X
  pwrp1 = strap li from=cp1l to=vpwr_li
  pwrv  = strap li from=cpvl to=vpwr_li
  pwrx  = strap li from=cpxl to=vpwr_li

  # gate contacts on their own gates, in the gap between the diff rows
  cb  = max(nd.top + 0.19, cn1l.top + 0.25, cnvl.top + 0.25, cnxl.top + 0.25)
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
  xm  = contact mcon in=cnxl cy=(nd.cy)
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
