pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=6 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  dw  = 2*L + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # gate order B (left), A (right) works for both rows:
  # n-row: VGND | gB | n1 | gA | Y
  # p-row: VPWR | gB | Y | gA | VPWR
  gb  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn  = array licon in=nd left_of=gb            # n-row VGND end
  dn  = array licon in=nd right_of=ga           # n-row Y end
  s1  = array licon in=pd left_of=gb            # p-row VPWR end
  my  = array licon in=pd between=[gb, ga]      # p-row Y middle
  s2  = array licon in=pd right_of=ga           # p-row VPWR end
  snl = enclose sn li net=VGND
  dnl = enclose dn li net=Y
  s1l = enclose s1 li net=VPWR
  myl = enclose my li net=Y
  s2l = enclose s2 li net=VPWR
  gnd = strap li from=snl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gcb = contact licon cx=gb.cx bottom=cb
  gca = contact licon cx=ga.cx bottom=cb
  gpb = enclose gcb poly by=minx
  gpa = enclose gca poly by=minx
  gnb = enclose gcb npc
  gna = enclose gca npc
  b   = enclose gcb li net=B
  a   = enclose gca li net=A
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
