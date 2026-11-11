```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  PITCH = max(0.28, 0.54 - L)
  END   = 0.265
  dw    = 2*END + 5*L + 4*PITCH
  nd    = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd    = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim   = enclose nd nsdm
  pim   = enclose pd psdm

  ga = cross [nd, pd] poly w=L left=(nd.left + END)
  gb = cross [nd, pd] poly w=L left=(ga.right + PITCH)
  gn = cross [nd, pd] poly w=L left=(gb.right + PITCH)
  g2 = cross [nd, pd] poly w=L left=(gn.right + PITCH)
  g3 = cross [nd, pd] poly w=L left=(g2.right + PITCH)

  # n-row: VGND A n1 B VGND n1 X B n4 A VGND  (gates A,B,n1,B,A)
  c0  = array licon in=nd left_of=ga
  c1  = array licon in=nd between=[ga, gb] net=n1
  c2  = array licon in=nd between=[gb, gn]
  c3  = array licon in=nd between=[gn, g2] net=X
  c4  = array licon in=nd between=[g2, g3] net=n4
  c5  = array licon in=nd right_of=g3
  c0l = enclose c0 li
  c1l = enclose c1 li net=n1
  c2l = enclose c2 li
  c3l = enclose c3 li net=X
  c4l = enclose c4 li net=n4
  c5l = enclose c5 li
  gnd0 = strap li from=c0l to=vgnd_li
  gnd2 = strap li from=c2l to=vgnd_li
  gnd5 = strap li from=c5l to=vgnd_li

  # p-row: n2 A VPWR B n3 B n1 A VPWR X  (gates A,B,n1,B,A; M8 at right edge)
  p0  = array licon in=pd left_of=ga net=n2
  p1  = array licon in=pd between=[ga, gb]
  p2  = array licon in=pd between=[gb, gn] net=n3
  p3  = array licon in=pd between=[gn, g2] net=n1
  p4  = array licon in=pd between=[g2, g3]
  p5  = array licon in=pd right_of=g3 net=X
  p0l = enclose p0 li net=n2
  p1l = enclose p1 li
  p2l = enclose p2 li net=n3
  p3l = enclose p3 li net=n1
  p4l = enclose p4 li
  p5l = enclose p5 li net=X
  pwr1 = strap li from=p1l to=vpwr_li
  pwr4 = strap li from=p4l to=vpwr_li

  cb = max(nd.top + 0.19, c0l.top + 0.25, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)

  ac = contact licon cx=(ga.cx - 0.13) bottom=cb
  bc = contact licon cx=(gb.cx - 0.13) bottom=cb
  nc = contact licon cx=(gn.cx + 0.13) bottom=cb
  c2c = contact licon cx=(g2.cx - 0.13) bottom=cb
  c3c = contact licon cx=(g3.cx + 0.13) bottom=cb
  ap = enclose ac poly by=minx
  bp = enclose bc poly by=minx
  np = enclose nc poly by=minx
  p2p = enclose c2c poly by=minx
  p3p = enclose c3c poly by=minx
  gnpc = enclose [ac, bc, nc, c2c, c3c] npc
  al = enclose ac li net=A
  bl = enclose bc li net=B
  nl = enclose nc li net=n1
  c2l2 = enclose c2c li net=n1
  c3l2 = enclose c3c li net=X

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=al
  apm = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bl
  bpm = enclose bm m1 by=0.06 net=B
  xm = contact mcon in=p5l cy=(p5l.top - 0.3)
  xp = enclose xm m1 by=0.06 net=X
  route n1 layers=m1,m2

  port A in  on=apm
  port B in  on=bpm
  port X out on=xp
end
```