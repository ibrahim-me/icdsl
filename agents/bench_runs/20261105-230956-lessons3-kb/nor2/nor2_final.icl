pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=4 height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1

  gap = max(0.28, 0.54 - L)              # gate gap: contact needs 0.28, poly pads need 0.54 pitch
  dw  = 2*0.265 + 2*L + gap              # end contacts + 2 gates + middle gap
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # n row: VGND | A | Y | B | VGND  (parallel pulldown, Y shared in middle)
  sn  = array licon in=nd left_of=ga
  mn  = array licon in=nd between=[ga, gb]
  dn  = array licon in=nd right_of=gb
  snl = enclose sn li net=VGND
  mnl = enclose mn li net=Y
  dnl = enclose dn li net=VGND
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dnl to=vgnd_li

  # p row: VPWR | A | n1 | B | Y  (series pullup, n1 internal, no middle contact)
  sp  = array licon in=pd left_of=ga
  dp  = array licon in=pd right_of=gb
  spl = enclose sp li net=VPWR
  dpl = enclose dp li net=Y
  pwr = strap li from=spl to=vpwr_li

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb  = max(nd.top + 0.19, snl.top + 0.25, mnl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=dpl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2                     # joins n-row middle Y (mnl) to p-row right Y (dpl)

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
