pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=10 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # one gate order for both rows: A1 A2 B2 B1
  endc = 0.265                          # end contact column
  midc = 0.28                           # contact column between two gates
  dw   = 2*endc + 3*midc + 4*L          # diffusion width
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # PMOS row (left to right): VPWR M1(A1) n1 M0(A2) Y M2(B2) n2 M6(B1) VPWR
  ga = cross [nd, pd] poly w=L left=(nd.left + endc)              # A1
  gb = cross [nd, pd] poly w=L left=(ga.right + midc)             # A2
  gc = cross [nd, pd] poly w=L left=(gb.right + midc)             # B2
  gd = cross [nd, pd] poly w=L left=(gc.right + midc)             # B1

  # PMOS contact columns
  pvpwr1 = array mcon in=pd left_of=ga
  pn1    = array mcon in=pd between=[ga, gb]
  pY     = array mcon in=pd between=[gb, gc]
  pn2    = array mcon in=pd between=[gc, gd]
  pvpwr2 = array mcon in=pd right_of=gd
  pvpwr1l = enclose pvpwr1 m1 net=VPWR
  pn1l    = enclose pn1    m1 net=n1
  pYl     = enclose pY     m1 net=Y
  pn2l    = enclose pn2    m1 net=n2
  pvpwr2l = enclose pvpwr2 m1 net=VPWR
  strap m1 from=pvpwr1l to=vpwr
  strap m1 from=pvpwr2l to=vpwr

  # NMOS row (left to right): n3 M7(A1) VGND M3(A2) n3 M5(B2) Y M4(B1) n3
  nn3l  = array mcon in=nd left_of=ga
  nvgnd = array mcon in=nd between=[ga, gb]
  nn3m  = array mcon in=nd between=[gb, gc]
  nY    = array mcon in=nd between=[gc, gd]
  nn3r  = array mcon in=nd right_of=gd
  nn3ll = enclose nn3l  m1 net=n3
  nvgndl= enclose nvgnd m1 net=VGND
  nn3ml = enclose nn3m  m1 net=n3
  nYl   = enclose nY    m1 net=Y
  nn3rl = enclose nn3r  m1 net=n3
  strap m1 from=nvgndl to=vgnd

  # gate contacts (on their own gate, bottom from n-row only)
  cb = max(nd.top + 0.19, nn3ll.top + 0.25, nvgndl.top + 0.25, nn3ml.top + 0.25, nYl.top + 0.25, nn3rl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gcd = contact licon cx=gd.cx bottom=cb
  enclose [gca, gcb, gcc, gcd] poly by=minx
  enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output: join n-side and p-side Y straps (offset columns) on m1/m2
  route Y layers=m1,m2

  # input pins on met1
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  # output pin on the p-side Y strap at diffusion height
  ym  = contact mcon in=pYl cy=pYl.cy
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y  out on=yp
end
