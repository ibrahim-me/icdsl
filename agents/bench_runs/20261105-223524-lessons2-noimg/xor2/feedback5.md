Your last change made things worse (score 5523 vs best 5064). Here is your BEST version so far - continue from it, not from the last one:
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

  # ---------- n-diffusion row ----------
  ngap = max(0.28, 0.54 - L)
  ndw  = 2*0.265 + 5*L + 4*ngap
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  nim  = enclose nd nsdm

  gA0 = cross [nd] poly w=L left=(nd.left + 0.265)
  gB1 = cross [nd] poly w=L left=(gA0.right + ngap)
  gn1 = cross [nd] poly w=L left=(gB1.right + ngap)
  gB7 = cross [nd] poly w=L left=(gn1.right + ngap)
  gA9 = cross [nd] poly w=L left=(gB7.right + ngap)

  cV0  = array licon in=nd left_of=gA0
  cV2  = array licon in=nd between=[gB1, gn1]
  cX3  = array licon in=nd between=[gn1, gB7] net=X
  cV5  = array licon in=nd right_of=gA9

  cV0l = enclose cV0 li
  cV2l = enclose cV2 li
  cX3l = enclose cX3 li net=X
  cV5l = enclose cV5 li

  stV0 = strap li from=cV0l to=vgnd_li
  stV2 = strap li from=cV2l to=vgnd_li
  stV5 = strap li from=cV5l to=vgnd_li

  # ---------- p-diffusion row (two islands) ----------
  dwp1 = 3*L + 2*0.265 + 2*ngap
  dwp2 = 2*L + 2*0.265 + ngap
  pd1  = rect diff w=dwp1 h=WP cx=(cell.cx - 1.15) below=ntap
  pd2  = rect diff w=dwp2 h=WP cx=(cell.cx + 1.15) below=ntap
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  # island 1: n2 | A | VPWR | B | n2 | n1 | X
  gA4 = cross [pd1] poly w=L left=(pd1.left + 0.265)
  gB3 = cross [pd1] poly w=L left=(gA4.right + ngap)
  gn8 = cross [pd1] poly w=L left=(gB3.right + ngap)

  cN2a = array licon in=pd1 left_of=gA4 net=n2
  cVP1 = array licon in=pd1 between=[gA4, gB3]
  cN2b = array licon in=pd1 between=[gB3, gn8] net=n2
  cX8  = array licon in=pd1 right_of=gn8 net=X

  cN2al = enclose cN2a li net=n2
  cVP1l = enclose cVP1 li
  cN2bl = enclose cN2b li net=n2
  cX8l  = enclose cX8 li net=X

  stVP1 = strap li from=cVP1l to=vpwr_li

  # island 2: VPWR | A | n3 | B | n1
  gA6 = cross [pd2] poly w=L left=(pd2.left + 0.265)
  gB5 = cross [pd2] poly w=L left=(gA6.right + ngap)

  cVP2 = array licon in=pd2 left_of=gA6
  cN3  = array licon in=pd2 between=[gA6, gB5] net=n3
  cN1b = array licon in=pd2 right_of=gB5 net=n1

  cVP2l = enclose cVP2 li
  cN3l  = enclose cN3 li net=n3
  cN1bl = enclose cN1b li net=n1

  stVP2 = strap li from=cVP2l to=vpwr_li

  # ---------- gate contacts (all in gap between rows, at cb) ----------
  cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)

  gcA0 = contact licon cx=gA0.cx bottom=cb
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gcB7 = contact licon cx=gB7.cx bottom=cb
  gcA9 = contact licon cx=gA9.cx bottom=cb

  gpA0 = enclose gcA0 poly by=minx
  gpB1 = enclose gcB1 poly by=minx
  gpN1 = enclose gcn1 poly by=minx
  gpB7 = enclose gcB7 poly by=minx
  gpA9 = enclose gcA9 poly by=minx

  gnall = enclose [gcA0, gcB1, gcn1, gcB7, gcA9] npc

  a0 = enclose gcA0 li net=A
  b1 = enclose gcB1 li net=B
  n1g = enclose gcn1 li net=n1
  b7 = enclose gcB7 li net=B
  a9 = enclose gcA9 li net=A

  gcA4 = contact licon cx=gA4.cx bottom=cb
  gcB3 = contact licon cx=gB3.cx bottom=cb
  gcN8 = contact licon cx=gn8.cx bottom=cb
  gcA6 = contact licon cx=gA6.cx bottom=cb
  gcB5 = contact licon cx=gB5.cx bottom=cb

  gpA4 = enclose gcA4 poly by=minx
  gpB3 = enclose gcB3 poly by=minx
  gpN8 = enclose gcN8 poly by=minx
  gpA6 = enclose gcA6 poly by=minx
  gpB5 = enclose gcB5 poly by=minx

  gnpall = enclose [gcA4, gcB3, gcN8, gcA6, gcB5] npc

  a4 = enclose gcA4 li net=A
  b3 = enclose gcB3 li net=B
  n8 = enclose gcN8 li net=n1
  a6 = enclose gcA6 li net=A
  b5 = enclose gcB5 li net=B

  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  # ---------- metal1 pins and internal routing ----------
  am0 = contact mcon in=a0
  ap0 = enclose am0 m1 by=0.06 net=A
  am1 = contact mcon in=a4
  ap1 = enclose am1 m1 by=0.06 net=A
  route A layers=m1,m2

  bm0 = contact mcon in=b1
  bp0 = enclose bm0 m1 by=0.06 net=B
  bm1 = contact mcon in=b3
  bp1 = enclose bm1 m1 by=0.06 net=B
  route B layers=m1,m2

  nm0 = contact mcon in=n1g
  np0 = enclose nm0 m1 by=0.06 net=n1
  nm1 = contact mcon in=n8
  np1 = enclose nm1 m1 by=0.06 net=n1
  route n1 layers=m1,m2

  n3m = contact mcon in=cN3l
  n3p = enclose n3m m1 by=0.06 net=n3

  n2m = contact mcon in=cN2bl
  n2p = enclose n2m m1 by=0.06 net=n2
  route n2 layers=m1,m2

  xm  = contact mcon in=cX3l cy=(cX3l.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X
  xm2 = contact mcon in=cX8l cy=(cX8l.top - 0.3)
  xp2 = enclose xm2 m1 by=0.06 net=X
  route X layers=m1,m2

  port A in  on=ap0
  port B in  on=bp0
  port X out on=xp
end
```
Its check result:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 64 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 131: net 'A': pin a0+ap0 has no legal access point (blocked by bp1 on m1: 0.000 < 0.140 um)
  line 137: net 'B': pin b1+bp0 has no legal access point (blocked by np1 on m1: 0.000 < 0.140 um)
  line 143: net 'n1': pin n8 has no legal access point (blocked by ap0 on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / B: on li around (1.645, 1.18): shapes of A and B overlap/touch there (a0 (line 98), b3 (line 119))
  SHORT B / n1: on li around (2.185, 1.18): shapes of B and n1 overlap/touch there (b1 (line 99), n8 (line 120))
  OPEN net A is 3 separate pieces: [a4 (line 118), ap1 (line 130), gpA4 (line 110)] | [a0 (line 98), ap0 (line 128), b3 (line 119), bp1 (line 136), +2 more] | [a6 (line 121), a9 (line 102), gpA6 (line 113), gpA9 (line 94)] - join them (strap / shared metal / `route A`)
  OPEN net B is 4 separate pieces: [a0 (line 98), ap0 (line 128), b3 (line 119), bp1 (line 136), +2 more] | [b1 (line 99), bp0 (line 134), gpB1 (line 91), gpN8 (line 112), +2 more] | [b7 (line 101), gpB7 (line 93)] | [b5 (line 122), gpB5 (line 114)] - join them (strap / shared metal / `route B`)
  OPEN net n1 is 3 separate pieces: [cN1bl (line 77), pd2 (line 46)] | [b1 (line 99), bp0 (line 134), gpB1 (line 91), gpN8 (line 112), +2 more] | [gpN1 (line 92), n1g (line 100), np0 (line 140)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* gcA9 (line 88: `gcA9 = contact licon cx=gA9.cx bottom=cb`) and shapes built from it (a9, gpA9) - in 24 of 64 errors: poly.2 x15, li.3 x6, li.c2 x2, licon.2 x1
    gcA9 spans x 3.755..3.925, y 1.095..1.265 um
    poly.2: gpA9 [poly] vs gpB5 (line 114) [poly x 4.015..4.345, y 1.045..1.315]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    one fix: move gcA9 left by 0.2 um - line 88: `cx=gA9.cx` -> `cx=(gA9.cx - 0.2)` (or move the other shape the opposite way)
    poly.2: gpA9 [poly] vs gA9 (line 26) [poly x 3.765..3.915, y 0.285..1.035]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    licon.2: gcA9 [licon] vs gpA6 (line 113) [poly x 3.475..3.805, y 1.045..1.315]: they overlap by 0.050 um, rule needs >= 0.17 um (short by 0.220 um)
    its position uses cb (line 82: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* gcA6 (line 107: `gcA6 = contact licon cx=gA6.cx bottom=cb`) and shapes built from it (a6, gpA6) - in 22 of 64 errors: poly.2 x13, li.3 x6, li.c2 x2, licon.2 x1
    gcA6 spans x 3.555..3.725, y 1.095..1.265 um
    poly.2: gpA6 [poly] vs gpB7 (line 93) [poly x 3.135..3.465, y 1.045..1.315]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    one fix: move gcA6 right by 0.2 um - line 107: `cx=gA6.cx` -> `cx=(gA6.cx + 0.2)` (or move the other shape the opposite way)
    licon.2: gpA6 [poly] vs gcA9 (line 88) [licon x 3.755..3.925, y 1.095..1.265]: they overlap by 0.050 um, rule needs >= 0.17 um (short by 0.220 um)
    its position uses cb (line 82: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* gcB7 (line 87: `gcB7 = contact licon cx=gB7.cx bottom=cb`) and shapes built from it (b7, gpB7) - in 11 of 64 errors: poly.2 x11
    gcB7 spans x 3.215..3.385, y 1.095..1.265 um
    poly.2: gpB7 [poly] vs gpA6 (line 113) [poly x 3.475..3.805, y 1.045..1.315]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    one fix: move gcB7 left by 0.2 um - line 87: `cx=gB7.cx` -> `cx=(gB7.cx - 0.2)` (or move the other shape the opposite way)
    poly.2: gpB7 [poly] vs gB7 (line 25) [poly x 3.225..3.375, y 0.285..1.035]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    its position uses cb (line 82: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcN8 (line 106: `gcN8 = contact licon cx=gn8.cx bottom=cb`) and shapes built from it (gpN8, n8, nm1, np1) - in 9 of 64 errors: poly.2 x9
    gcN8 spans x 2.065..2.235, y 1.095..1.265 um
    its position uses cb (line 82: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING xor2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING xor2: port B: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by np1 on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.