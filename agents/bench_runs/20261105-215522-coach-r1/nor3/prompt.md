Design the standard cell `nor3`: Y = !(A | B | C).
Inputs: A, B, C; output: Y; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=<columns, your choice> height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port C in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

Your best attempt so far:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=6 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  dw  = 3*L + 1.09                      # 2 end cols (0.265) + 3 gates + 2 contact gaps (0.28)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gc  = cross [nd, pd] poly w=L left=(gb.right + 0.28)

  # n-row: VGND | A | Y | B | VGND | C | Y
  sn  = array licon in=nd left_of=ga            # VGND (M0 source)
  dn  = array licon in=nd right_of=ga           # Y   (M0 drain / M1 source)
  sv  = array licon in=nd right_of=gb           # VGND (M1 drain / M3 source)
  sy  = array licon in=nd right_of=gc           # Y   (M3 drain)
  snl = enclose sn li net=VGND
  dnl = enclose dn li net=Y
  svl = enclose sv li net=VGND
  syl = enclose sy li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li

  # p-row: VPWR | A | n1 | B | n2 | C | Y
  sp  = array licon in=pd left_of=ga            # VPWR (M2 source)
  sy2 = array licon in=pd right_of=gc           # Y   (M4 drain)
  spl = enclose sp li net=VPWR
  syl2= enclose sy2 li net=Y
  pwr = strap li from=spl to=vpwr_li

  # gate contacts on their own gates, bottom from n-row items only
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
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
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 22 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* gcc (line 44: `gcc = contact licon cx=gc.cx bottom=cb`) and shapes built from it (c, cm, cp, gpc) - in 15 of 22 errors: li.3 x8, poly.2 x5, li.c2 x2
    gcc spans x 1.725..1.895, y 1.095..1.265 um
    li.3: c [li] vs yst (line 55) [li x 1.940..2.110, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcc left by 0.13 um - line 44: `cx=gc.cx` -> `cx=(gc.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: c [li] vs yst (line 55) [li x 1.940..2.110, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    poly.2: gpc [poly] vs gpb (line 46) [poly x 1.215..1.545, y 1.045..1.315]: gap 0.100 um, rule needs >= 0.21 um (short by 0.110 um)
    its position uses cb (line 41: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc (line 19: `gc  = cross [nd, pd] poly w=L left=(gb.right + 0.28)`) - in 9 of 22 errors: poly.2 x5, li.3 x3, li.c2 x1
    gc spans x 1.735..1.885, y 0.285..2.435 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* yst (line 55: `yst = strap li from=syl to=syl2 net=Y`) - in 6 of 22 errors: li.3 x5, li.c2 x1
    yst spans x 1.940..2.110, y 0.495..2.265 um
    li.3: yst [li] vs c (line 51) [li x 1.725..1.895, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move yst right by 0.13 um (or move the other shape the opposite way)
    li.c2: yst [li] vs c (line 51) [li x 1.725..1.895, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gb (line 18: `gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)`) - in 6 of 22 errors: poly.2 x6
    gb spans x 1.305..1.455, y 0.285..2.435 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.

NOTES FROM A SENIOR LAYOUT ENGINEER WHO REVIEWED THIS ATTEMPT (follow them):
- LVS already matches. Two DRC problems remain.
- Gate pitch: your gates are 0.43 um apart centre to centre, so the 0.33-wide poly pads are only 0.10 apart (poly.2 needs 0.21). Use gaps of max(0.28, 0.54 - L): `gb ... left=(ga.right + max(0.28, 0.54 - L))`, the same for gc, and `dw = 3*L + 0.53 + 2*max(0.28, 0.54 - L)`.
- The Y strap on the right runs 0.045 um from C's gate-contact li (needs 0.17). Shift ALL THREE gate contacts left by 0.13: `cx=(ga.cx - 0.13)`, `cx=(gb.cx - 0.13)`, `cx=(gc.cx - 0.13)` - the pads still overlap their gates and keep 0.21 between them.