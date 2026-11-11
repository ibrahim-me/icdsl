The gates are now separate (no SHORTs) and n3 is connected. Remaining: Y's n-side and p-side drains are at different x columns, and the n3 route on m1 blocks Y's access point on nYl. Fix: route n3 on m2 only (keeps m1 clear), route Y on m1/m2, and let the router place the Y port pin (`port Y out` without `on=`).

```icl
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

  endc = 0.265
  gap  = max(0.28, 0.54 - L)          # gate-to-gate gap: 0.28 contact room, 0.54 pad pitch
  dw   = 2*endc + 4*L + 3*gap
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # single gate order for both rows: A1 A2 B2 B1
  ga = cross [nd, pd] poly w=L left=(nd.left + endc)              # A1
  gb = cross [nd, pd] poly w=L left=(ga.right + gap)              # A2
  gc = cross [nd, pd] poly w=L left=(gb.right + gap)              # B2
  gd = cross [nd, pd] poly w=L left=(gc.right + gap)              # B1

  # PMOS row: VPWR A1 n1 A2 Y B2 n2 B1 VPWR
  pvpwr1 = array licon in=pd left_of=ga
  pn1    = array licon in=pd between=[ga, gb]
  pY     = array licon in=pd between=[gb, gc]
  pn2    = array licon in=pd between=[gc, gd]
  pvpwr2 = array licon in=pd right_of=gd
  pvpwr1l = enclose pvpwr1 li net=VPWR
  pn1l    = enclose pn1    li net=n1
  pYl     = enclose pY     li net=Y
  pn2l    = enclose pn2    li net=n2
  pvpwr2l = enclose pvpwr2 li net=VPWR
  strap li from=pvpwr1l to=vpwr_li
  strap li from=pvpwr2l to=vpwr_li

  # NMOS row: n3 A1 VGND A2 n3 B2 Y B1 n3
  nn3l  = array licon in=nd left_of=ga
  nvgnd = array licon in=nd between=[ga, gb]
  nn3m  = array licon in=nd between=[gb, gc]
  nY    = array licon in=nd between=[gc, gd]
  nn3r  = array licon in=nd right_of=gd
  nn3ll = enclose nn3l  li net=n3
  nvgndl= enclose nvgnd li net=VGND
  nn3ml = enclose nn3m  li net=n3
  nYl   = enclose nY    li net=Y
  nn3rl = enclose nn3r  li net=n3
  strap li from=nvgndl to=vgnd_li

  # gate contacts on their own gates; bottom from n-row items only
  cb = max(nd.top + 0.19, nn3ll.top + 0.25, nvgndl.top + 0.25, nn3ml.top + 0.25, nYl.top + 0.25, nn3rl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gcd = contact licon cx=gd.cx bottom=cb
  enclose gca poly by=minx
  enclose gcb poly by=minx
  enclose gcc poly by=minx
  enclose gcd poly by=minx
  enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # n3 on m2 only (keeps m1 clear for Y); Y on m1+m2, pin placed by router
  route n3 layers=m2
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

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y  out
end
```