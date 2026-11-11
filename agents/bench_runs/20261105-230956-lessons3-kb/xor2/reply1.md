```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=10 height=H
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

  dw  = 4*L + 3*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gn  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))

  # n-row: VGND | A | n1 | B | X | n4 | A | VGND
  c0  = array licon in=nd left_of=ga
  c1  = array licon in=nd between=[ga, gb] net=n1
  c2  = array licon in=nd between=[gb, gn] net=X
  c3  = array licon in=nd right_of=gn net=n4
  c4  = array licon in=nd right_of=gn
  c0l = enclose c0 li
  c1l = enclose c1 li net=n1
  c2l = enclose c2 li net=X
  c3l = enclose c3 li net=n4
  c4l = enclose c4 li
  gnd0 = strap li from=c0l to=vgnd_li
  gnd4 = strap li from=c4l to=vgnd_li

  # p-row: VPWR | B | n2 | A | n3 | n1 | B | VPWR
  p0  = array licon in=pd left_of=ga
  p1  = array licon in=pd between=[ga, gb] net=n2
  p2  = array licon in=pd between=[gb, gn] net=n3
  p3  = array licon in=pd right_of=gn net=n1
  p4  = array licon in=pd right_of=gn
  p0l = enclose p0 li
  p1l = enclose p1 li net=n2
  p2l = enclose p2 li net=n3
  p3l = enclose p3 li net=n1
  p4l = enclose p4 li
  pwr0 = strap li from=p0l to=vpwr_li
  pwr4 = strap li from=p4l to=vpwr_li

  cb = max(nd.top + 0.19, c0l.top + 0.25, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)

  ac = contact licon cx=(ga.cx - 0.13) bottom=cb
  bc = contact licon cx=(gb.cx - 0.13) bottom=cb
  nc = contact licon cx=(gn.cx + 0.13) bottom=cb
  ap = enclose ac poly by=minx
  bp = enclose bc poly by=minx
  np = enclose nc poly by=minx
  gnpc = enclose [ac, bc, nc] npc
  al = enclose ac li net=A
  bl = enclose bc li net=B
  nl = enclose nc li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=al
  apm = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bl
  bpm = enclose bm m1 by=0.06 net=B
  xm = contact mcon in=c2l cy=(c2l.top - 0.3)
  xp = enclose xm m1 by=0.06 net=X
  route n1 layers=m1,m2

  port A in  on=apm
  port B in  on=bpm
  port X out on=xp
end
```