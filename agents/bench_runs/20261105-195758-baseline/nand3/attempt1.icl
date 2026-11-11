pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=5 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # nmos series stack: Y | A | n2 | B | n1 | C | VGND  (no middle contacts -> 0.21 gate spacing)
  nd  = rect diff w=(3*L + 0.95) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  ga  = cross nd poly w=L left=(nd.left + 0.265)
  gb  = cross nd poly w=L left=(ga.right + 0.21)
  gc  = cross nd poly w=L left=(gb.right + 0.21)
  cn  = array licon in=nd left_of=ga          # Y (drain of M3)
  cg  = array licon in=nd right_of=gc         # VGND (source of M2)
  cnl = enclose cn li net=Y
  cgl = enclose cg li
  gndn = strap li from=cgl to=vgnd_li

  # pmos parallel: VPWR | A | Y | C | VPWR | B | Y  (contacts between gates -> 0.28 gate spacing)
  pd  = rect diff w=(3*L + 1.09) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm
  pa  = cross pd poly w=L left=(pd.left + 0.265)
  pc  = cross pd poly w=L left=(pa.right + 0.28)
  pb  = cross pd poly w=L left=(pc.right + 0.28)
  cp1 = array licon in=pd left_of=pa          # VPWR
  cy1 = array licon in=pd right_of=pa         # Y
  cp2 = array licon in=pd right_of=pc         # VPWR
  cy2 = array licon in=pd right_of=pb         # Y
  cp1l = enclose cp1 li
  cy1l = enclose cy1 li net=Y
  cp2l = enclose cp2 li
  cy2l = enclose cy2 li net=Y
  pwr1 = strap li from=cp1l to=vpwr_li
  pwr2 = strap li from=cp2l to=vpwr_li

  # gate contacts in the gap between the rows, pushed outwards so poly pads clear
  cb  = max(nd.top + 0.19, cnl.top + 0.25, cgl.top + 0.25, cy1l.top + 0.25, cy2l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx)       bottom=cb
  gcc = contact licon cx=(gc.cx + 0.1) bottom=cb
  gpa = contact licon cx=(pa.cx - 0.1) bottom=cb
  gpc = contact licon cx=(pc.cx)       bottom=cb
  gpb = contact licon cx=(pb.cx + 0.1) bottom=cb
  gna = enclose gca poly by=minx
  gnb = enclose gcb poly by=minx
  gnc = enclose gcc poly by=minx
  gpa_en = enclose gpa poly by=minx
  gpc_en = enclose gpc poly by=minx
  gpb_en = enclose gpb poly by=minx
  gn_all = enclose [gca, gcb, gcc] npc
  gp_all = enclose [gpa, gpc, gpb] npc
  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  cc = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=cnl cy=(cnl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
