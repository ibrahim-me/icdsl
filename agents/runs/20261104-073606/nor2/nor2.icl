pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell nor2 width=6 height=H
  device MNA nmos w=WN l=L d=Y g=A s=VGND
  device MNB nmos w=WN l=L d=Y g=B s=VGND
  device MPA pmos w=WP l=L d=n1 g=A s=VPWR
  device MPB pmos w=WP l=L d=Y g=B s=n1

  dw  = 4*0.265 + 2*L + 0.28          # VGND|A|Y|B|VGND / VPWR|A|n1|B|Y
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn  = array licon in=nd left_of=ga            # n: VGND | A | Y | B | VGND
  yn  = array licon in=nd right_of=ga
  sv  = array licon in=nd right_of=gb
  sp  = array licon in=pd left_of=ga            # p: VPWR | A | n1 | B | Y
  sy  = array licon in=pd right_of=gb
  snl = enclose sn li
  ynl = enclose yn li net=Y
  svl = enclose sv li
  spl = enclose sp li
  syl = enclose sy li net=Y
  gnd1 = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li
  pwr = strap li from=spl to=vpwr_li
  route Y layers=m1                             # joins n-side Y to p-side Y

  cb  = max(nd.top + 0.19, snl.top + 0.25, ynl.top + 0.25, svl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gna = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=ynl
  yp  = enclose ym m1 by=0.06 net=Y
  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
