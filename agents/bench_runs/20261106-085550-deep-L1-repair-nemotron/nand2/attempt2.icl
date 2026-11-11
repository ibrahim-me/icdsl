pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=6 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # n row: Y [A] n1 [B] VGND   |   p row: VPWR [A] Y [B] VPWR
  dw  = 2*L + 0.81                      # 2 x 0.265 end contacts + 0.28 middle contact column
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)   # gate A
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265) # gate B

  # n row contacts: Y (left of ga), VGND (right of gb)
  sn  = array licon in=nd left_of=ga            # Y contact (n side)
  dn  = array licon in=nd right_of=gb           # VGND contact
  snl = enclose sn li net=Y
  dnl = enclose dn li net=VGND
  gnd = strap li from=dnl to=vgnd_li

  # p row contacts: VPWR (left of ga), Y (between ga and gb), VPWR (right of gb)
  sp  = array licon in=pd left_of=ga            # VPWR contact
  my  = array licon in=pd between=[ga, gb]      # Y contact (p side)
  s2  = array licon in=pd right_of=gb           # VPWR contact
  s1l = enclose sp li net=VPWR
  myl = enclose my li net=Y
  s2l = enclose s2 li net=VPWR
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  # gate contacts in the gap between the rows, pushed outwards so the two poly pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
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
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1                             # joins the p-side Y pin to the n-side drain

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
