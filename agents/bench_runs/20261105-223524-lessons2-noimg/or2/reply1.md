```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=5 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # gate order n2 - A - B works for both rows (B and n2 never adjacent on p side)
  pitch = max(0.28, 0.54 - L)            # contact column between gates + poly pad pitch
  dw    = 0.53 + 2*pitch                 # 2 x 0.265 end contacts + 2 gate gaps

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gn2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L left=(gn2.right + pitch)
  gb  = cross [nd, pd] poly w=L left=(ga.right + pitch)

  # n row (left to right): X | VGND | n2 | VGND   devices M1 - M3 - M2
  sx  = array licon in=nd left_of=gn2
  sv  = array licon in=nd between=[gn2, ga]
  sn2 = array licon in=nd between=[ga, gb]
  sv2 = array licon in=nd right_of=gb
  sxl = enclose sx li net=X
  svl = enclose sv li
  n2l = enclose sn2 li net=n2
  sv2l= enclose sv2 li
  gnd1= strap li from=svl to=vgnd_li
  gnd2= strap li from=sv2l to=vgnd_li

  # p row (left to right): X | VPWR | n1 | n2     devices M5 - M0 - M4
  px  = array licon in=pd left_of=gn2
  pv  = array licon in=pd between=[gn2, ga]
  pn1 = array licon in=pd between=[ga, gb]
  pn2 = array licon in=pd right_of=gb
  pxl = enclose px li net=X
  pvl = enclose pv li
  n1l = enclose pn1 li net=n1
  pn2l= enclose pn2 li net=n2
  pwr = strap li from=pvl to=vpwr_li
  xst = strap li from=sxl to=pxl net=X

  # gate contacts on their own gate lines, shifted away from the central n2 strap
  cb  = max(nd.top + 0.19, svl.top + 0.25, n2l.top + 0.25, sv2l.top + 0.25)
  gc2 = contact licon cx=(gn2.cx - 0.13) bottom=cb
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb
  gp2 = enclose gc2 poly by=minx
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gc2, gca, gcb] npc
  a2  = enclose gc2 li net=n2
  aa  = enclose gca li net=A
  ab  = enclose gcb li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  route n2 layers=m1,m2                     # joins n-row n2 strip to gate n2 contact

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=xst
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```