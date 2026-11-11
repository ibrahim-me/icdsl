# Parametric NAND2: series n-stack (no contact between its gates), parallel p-devices
pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell nand2_p width=4 height=H
  device MNA nmos w=WN l=L d=n1 g=A s=VGND
  device MNB nmos w=WN l=L d=Y  g=B s=n1
  device MPA pmos w=WP l=L d=Y  g=A s=VPWR
  device MPB pmos w=WP l=L d=Y  g=B s=VPWR

  dw  = 2*L + 0.81                      # 2 x 0.265 (end contacts) + 0.28 (middle contact on the p side)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn  = array licon in=nd left_of=ga            # n: VGND | A | n1 (no contact) | B | Y
  dn  = array licon in=nd right_of=gb
  s1  = array licon in=pd left_of=ga            # p: VPWR | A | Y | B | VPWR
  my  = array licon in=pd right_of=ga
  s2  = array licon in=pd right_of=gb
  snl = enclose sn li
  dnl = enclose dn li net=Y
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li
  gnd = strap li from=snl to=vgnd_li
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
