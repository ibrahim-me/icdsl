pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=8 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # Diffusion width: 2 end contacts (0.265 each) + 3 gates (L each) + 3 gaps (0.28 each for contact columns)
  dw  = 2*0.265 + 3*L + 3*0.28
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # Gates: A, B, C in same order in both rows
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gc  = cross [nd, pd] poly w=L left=(gb.right + 0.28)

  # N-row contacts: Y | A | n2 | B | n1 | C | VGND
  snY = array licon in=nd left_of=ga          # Y column (left end)
  dn2 = array licon in=nd between=[ga, gb]    # n2 column (internal, net=n2)
  dn1 = array licon in=nd between=[gb, gc]    # n1 column (internal, net=n1)
  snG = array licon in=nd right_of=gc         # VGND column (right end)

  # P-row contacts: VPWR | A | Y | B | VPWR | C | Y
  sp1 = array licon in=pd left_of=ga          # VPWR column (left end)
  py  = array licon in=pd between=[ga, gb]    # Y column (output)
  sp2 = array licon in=pd between=[gb, gc]    # VPWR column (middle)
  py2 = array licon in=pd right_of=gc         # Y column (right end)

  # Enclose li strips
  snYl = enclose snY li net=Y
  dn2l = enclose dn2 li net=n2
  dn1l = enclose dn1 li net=n1
  snGl = enclose snG li
  sp1l = enclose sp1 li
  pyl  = enclose py li net=Y
  sp2l = enclose sp2 li
  py2l = enclose py2 li net=Y

  # Supply straps
  gnd = strap li from=snGl to=vgnd_li
  p1  = strap li from=sp1l to=vpwr_li
  p2  = strap li from=sp2l to=vpwr_li

  # Gate contacts: cb from n-row items only (lesson 1)
  cb  = max(nd.top + 0.19, snYl.top + 0.25, dn2l.top + 0.25, dn1l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C

  # Output: n-side and p-side drains don't line up, use route
  route Y layers=m1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Ports on met1
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=pyl
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
