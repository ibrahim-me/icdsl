Your last change made things worse (score 5000 vs best 10). Here is your BEST version so far - continue from it, not from the last one:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=7 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  gap = max(0.28, 0.54 - L)                 # gate pitch >= 0.54 -> poly pads keep 0.21
  dw  = 3*L + 0.53 + 2*gap                  # 2 end cols (0.265) + 3 gates + 2 gaps
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gap)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gap)

  # n-row: VGND | A | Y | B | VGND | C | Y
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=ga
  sv  = array licon in=nd right_of=gb
  sy  = array licon in=nd right_of=gc
  snl = enclose sn li net=VGND
  dnl = enclose dn li net=Y
  svl = enclose sv li net=VGND
  syl = enclose sy li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li

  # p-row: VPWR | A | n1 | B | n2 | C | Y   (n1,n2 are internal: contacts only, no straps)
  sp  = array licon in=pd left_of=ga
  sn1 = array licon in=pd right_of=ga
  sn2 = array licon in=pd right_of=gb
  sy2 = array licon in=pd right_of=gc
  spl = enclose sp li net=VPWR
  n1l = enclose sn1 li net=n1
  n2l = enclose sn2 li net=n2
  syl2= enclose sy2 li net=Y
  pwr = strap li from=spl to=vpwr_li

  # gate contacts on their own gates, bottom from n-row items only, shifted left to clear the Y strap
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.09) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.09) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.09) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Y: n-col after C and p-col after C line up; n-col between A/B joins via m1/m2 route
  yst = strap li from=syl to=syl2 net=Y
  route Y layers=m1,m2

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=syl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```
Its check result:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 10 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* yst (line 60: `yst = strap li from=syl to=syl2 net=Y`) - in 6 of 10 errors: li.3 x5, li.c2 x1
    yst spans x 2.280..2.450, y 0.495..2.265 um
    li.3: yst [li] vs c (line 56) [li x 1.975..2.145, y 1.015..1.345]: gap 0.135 um, rule needs >= 0.17 um (short by 0.035 um)
    one fix: move yst right by 0.04 um (or move the other shape the opposite way)
    li.c2: yst [li] vs c (line 56) [li x 1.975..2.145, y 1.015..1.345]: gap 0.135 um, rule needs >= 0.14 um (short by 0.005 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc (line 20: `gc  = cross [nd, pd] poly w=L left=(gb.right + gap)`) - in 4 of 10 errors: li.3 x3, li.c2 x1
    gc spans x 2.075..2.225, y 0.285..2.435 um
    its position uses gap (line 12: `gap = max(0.28, 0.54 - L)                 # gate pitch >= 0.54 -> poly pads keep 0.21`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gcc (line 49: `gcc = contact licon cx=(gc.cx - 0.09) bottom=cb`) and shapes built from it (c, cm, cp, gpc) - in 4 of 10 errors: li.3 x3, li.c2 x1
    gcc spans x 1.975..2.145, y 1.095..1.265 um
    li.3: c [li] vs yst (line 60) [li x 2.280..2.450, y 0.495..2.265]: gap 0.135 um, rule needs >= 0.17 um (short by 0.035 um)
    one fix: move gcc left by 0.04 um - line 49: `cx=(gc.cx - 0.09)` -> `cx=(gc.cx - 0.09 - 0.04)` (or move the other shape the opposite way)
    li.c2: c [li] vs yst (line 60) [li x 2.280..2.450, y 0.495..2.265]: gap 0.135 um, rule needs >= 0.14 um (short by 0.005 um)
    its position uses cb (line 46: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* sy (line 26: `sy  = array licon in=nd right_of=gc`) and shapes built from it (syl) - in 2 of 10 errors: li.3 x2
    sy spans x 2.280..2.450, y 0.575..0.745 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.