```icl
pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell buf width=4 height=H
  device MN1 nmos w=WN l=L d=n1 g=A s=VGND
  device MP1 pmos w=WP l=L d=n1 g=A s=VPWR
  device MN2 nmos w=WN l=L d=X g=n1 s=VGND
  device MP2 pmos w=WP l=L d=X g=n1 s=VPWR

  dw  = 2*L + 0.81                      # end margins + two gates + contact column between gates
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order: A then n1; middle diffusion is shared source (VGND / VPWR)
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # n-row contacts: n1 | VGND | X
  cn1 = array licon in=nd left_of=ga
  cv  = array licon in=nd right_of=ga left_of=gn1
  cxn = array licon in=nd right_of=gn1
  cn1l = enclose cn1 li net=n1
  cvl  = enclose cv li
  cxl  = enclose cxn li net=X
  gnd1 = strap li from=cvl to=vgnd_li

  # p-row contacts: n1 | VPWR | X
  cp1  = array licon in=pd left_of=ga
  cpv  = array licon in=pd right_of=ga left_of=gn1
  cpx  = array licon in=pd right_of=gn1
  cp1l = enclose cp1 li net=n1
  cpvl = enclose cpv li
  cpxl = enclose cpx li net=X
  pwr1 = strap li from=cpvl to=vpwr_li

  # join n1 across n and p rows
  route n1 layers=m1

  # gate contacts in the gap between rows, pushed outwards so pads clear
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cxl.top + 0.25, cp1l.top + 0.25, cpxl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcn = contact licon cx=(gn1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gna = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  n1g = enclose gcn li net=n1

  # connect n1 drains to gate n1 poly
  route n1 layers=m1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ports on met1
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  xm  = contact mcon in=cxl cy=(cxl.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port X out on=xp
end
```