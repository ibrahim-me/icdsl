Your last change made things worse (score 1000000 vs best 5012). Here is your BEST version so far - continue from it, not from the last one:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=12 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  dw  = 2*0.265 + 0.28 + 3*L + 2*max(0.28, 0.54 - L)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gS  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  g1  = cross [nd, pd] poly w=L left=(gS.right + max(0.28, 0.54 - L))
  gA1 = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))
  gA0 = cross [nd, pd] poly w=L left=(gA1.right + max(0.28, 0.54 - L))

  cnVa  = array licon in=nd left_of=gS
  cn3   = array licon in=nd between=[gS, g1]
  cnY   = array licon in=nd between=[g1, gA1]
  cn5   = array licon in=nd between=[gA1, gA0]
  cn1   = array licon in=nd right_of=gA0
  cnVra = array licon in=nd right_of=cn1
  cnVl  = enclose cnVa li net=VGND
  cnVrl = enclose cnVra li net=VGND
  cn3l  = enclose cn3 li net=n3
  cnYl  = enclose cnY li net=Y
  cn5l  = enclose cn5 li net=n5
  cn1l  = enclose cn1 li net=n1
  gndn  = strap li from=cnVl to=vgnd_li
  gndn2 = strap li from=cnVrl to=vgnd_li

  cpVa  = array licon in=pd left_of=gS
  cp2   = array licon in=pd between=[gS, g1]
  cpY   = array licon in=pd between=[g1, gA1]
  cp4   = array licon in=pd between=[gA1, gA0]
  cpVra = array licon in=pd right_of=gA0
  cpVrra= array licon in=pd right_of=cpVra
  cpVl  = enclose cpVa li net=VPWR
  cpVrl = enclose cpVra li net=VPWR
  cpVrrl= enclose cpVrra li net=VPWR
  cp2l  = enclose cp2 li net=n2
  cpYl  = enclose cpY li net=Y
  cp4l  = enclose cp4 li net=n4
  pwrp  = strap li from=cpVl to=vpwr_li
  pwrp2 = strap li from=cpVrl to=vpwr_li
  pwrp3 = strap li from=cpVrrl to=vpwr_li

  cb = max(nd.top + 0.19, cnVl.top + 0.25, cn3l.top + 0.25, cnYl.top + 0.25, cn5l.top + 0.25, cn1l.top + 0.25)
  gcS = contact licon cx=(gS.cx - 0.09) bottom=cb
  gc1 = contact licon cx=(g1.cx - 0.09) bottom=cb
  gcA1= contact licon cx=(gA1.cx - 0.09) bottom=cb
  gcA0= contact licon cx=(gA0.cx - 0.09) bottom=cb
  gpS = enclose gcS poly by=minx
  gp1 = enclose gc1 poly by=minx
  gpA1= enclose gcA1 poly by=minx
  gpA0= enclose gcA0 poly by=minx
  gn  = enclose [gcS, gc1, gcA1, gcA0] npc
  aS  = enclose gcS li net=S
  a1  = enclose gc1 li net=n1
  aA1 = enclose gcA1 li net=A1
  aA0 = enclose gcA0 li net=A0

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  sm  = contact mcon in=cnVl
  sp  = enclose sm m1 by=0.06 net=VGND
  pm  = contact mcon in=cpVl
  pp  = enclose pm m1 by=0.06 net=VPWR

  ystrap = strap li from=cnYl to=cpYl net=Y
  ym     = contact mcon in=ystrap cy=nd.cy
  yp     = enclose ym m1 by=0.06 net=Y

  sM  = contact mcon in=aS
  sP  = enclose sM m1 by=0.06 net=S
  a0M = contact mcon in=aA0
  a0P = enclose a0M m1 by=0.06 net=A0
  a1M = contact mcon in=aA1
  a1P = enclose a1M m1 by=0.06 net=A1

  port VGND ground on=sp
  port VPWR power  on=pp
  port S   in      on=sP
  port A0  in      on=a0P
  port A1  in      on=a1P
  port Y   out     on=yp
end
```
Its check result:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 12 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 2 separate pieces: [a1 (line 69), g1 (line 23), gp1 (line 64)] | [cn1l (line 38)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (pmos g=S d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (pmos g=A0 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate A0 at x=3.7 has ?9 and n4 on its sides; it needs n2 and Y: the side labelled ?9 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (pmos g=n1 d=n4 s=VPWR) has no matching transistor in the layout - the pmos with gate n1 at x=2.62 has Y and n2 on its sides; it needs n4 and VPWR: the side labelled Y should be n4 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (nmos g=n1 d=n5 s=VGND) has no matching transistor in the layout - the nmos with gate n1 at x=2.62 has Y and n3 on its sides; it needs n5 and VGND: the side labelled Y should be n5 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M6 (nmos g=S d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M8 (nmos g=A1 d=Y s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=3.16 has Y and n5 on its sides; it needs Y and n3: the side labelled n5 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=2.62 y=0.66: gate n1 [g1 (line 23), gp1 (line 64)], source/drain Y [cnYl (line 36), cpYl (line 52), nd (line 17), +2 more], n3 [cn3l (line 35), nd (line 17)]
    layout nmos at x=3.16 y=0.66: gate A1 [gA1 (line 24), gpA1 (line 65)], source/drain Y [cnYl (line 36), cpYl (line 52), nd (line 17), +2 more], n5 [cn5l (line 37), nd (line 17)]
    layout pmos at x=2.62 y=1.93: gate n1 [g1 (line 23), gp1 (line 64)], source/drain Y [cnYl (line 36), cpYl (line 52), nd (line 17), +2 more], n2 [cp2l (line 51), pd (line 18)]
    layout pmos at x=3.7 y=1.93: gate A0 [gA0 (line 25), gpA0 (line 66)], source/drain ?9 [pd (line 18)], n4 [cp4l (line 53), pd (line 18)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* ystrap (line 80: `ystrap = strap li from=cnYl to=cpYl net=Y`) - in 10 of 12 errors: li.3 x8, li.c2 x2
    ystrap spans x 2.805..2.975, y 0.495..2.265 um
    li.3: ystrap [li] vs aA1 (line 70) [li x 2.985..3.155, y 1.015..1.345]: gap 0.010 um, rule needs >= 0.17 um (short by 0.160 um)
    one fix: move ystrap left by 0.16 um (or move the other shape the opposite way)
    li.c2: ystrap [li] vs aA1 (line 70) [li x 2.985..3.155, y 1.015..1.345]: gap 0.010 um, rule needs >= 0.14 um (short by 0.130 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gcA1 (line 61: `gcA1= contact licon cx=(gA1.cx - 0.09) bottom=cb`) and shapes built from it (a1M, a1P, aA1, gpA1) - in 10 of 12 errors: li.3 x8, li.c2 x2
    gcA1 spans x 2.985..3.155, y 1.095..1.265 um
    li.3: aA1 [li] vs ystrap (line 80) [li x 2.805..2.975, y 0.495..2.265]: gap 0.010 um, rule needs >= 0.17 um (short by 0.160 um)
    one fix: move gcA1 right by 0.16 um - line 61: `cx=(gA1.cx - 0.09)` -> `cx=(gA1.cx - 0.09 + 0.16)` (or move the other shape the opposite way)
    li.c2: aA1 [li] vs ystrap (line 80) [li x 2.805..2.975, y 0.495..2.265]: gap 0.010 um, rule needs >= 0.14 um (short by 0.130 um)
    its position uses cb (line 58: `cb = max(nd.top + 0.19, cnVl.top + 0.25, cn3l.top + 0.25, cnYl.top + 0.25, cn5l.top + 0.25, cn1l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gA1 (line 24: `gA1 = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))`) - in 4 of 12 errors: li.3 x3, li.c2 x1
    gA1 spans x 3.085..3.235, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 17: `nd  = rect diff w=dw h=WN cx=cell.cx above=ptap`) - in 3 of 12 errors: li.3 x2, poly.7 x1
    nd spans x 1.740..3.780, y 0.415..0.905 um
    its position uses dw (line 16: `dw  = 2*0.265 + 0.28 + 3*L + 2*max(0.28, 0.54 - L)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.