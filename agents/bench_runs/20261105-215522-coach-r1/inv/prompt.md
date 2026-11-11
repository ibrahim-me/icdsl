Design the standard cell `inv`: Y = !A.
Inputs: A; output: Y; internal nets: none.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=<columns, your choice> height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y
  <your geometry>
  port A in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

Your best attempt so far:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  nd  = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  g   = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  sn  = array licon in=nd left_of=g
  dn  = array licon in=nd right_of=g
  sp  = array licon in=pd left_of=g
  dp  = array licon in=pd right_of=g
  snl = enclose sn li
  dnl = enclose dn li net=Y
  s1l = enclose sp li
  dpl = enclose dp li net=Y
  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=s1l to=vpwr_li
  y   = strap li from=dnl to=dpl net=Y
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gc  = contact licon cx=g.cx bottom=cb
  gp  = enclose gc poly by=minx
  gn  = enclose gc npc
  a   = enclose gc li net=A
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  ym  = contact mcon in=y cx=y.cx cy=(cb + 0.55)
  yp  = enclose ym m1 by=0.06 net=Y
  port A in  on=ap
  port Y out on=yp
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 10 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* gc (line 25: `gc  = contact licon cx=g.cx bottom=cb`) and shapes built from it (a, am, ap, gp) - in 10 of 10 errors: li.3 x8, li.c2 x2
    gc spans x 1.295..1.465, y 1.095..1.265 um
    li.3: a [li] vs y (line 23) [li x 1.510..1.680, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc left by 0.13 um - line 25: `cx=g.cx` -> `cx=(g.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: a [li] vs y (line 23) [li x 1.510..1.680, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 24: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* y (line 23: `y   = strap li from=dnl to=dpl net=Y`) and shapes built from it (yp) - in 6 of 10 errors: li.3 x5, li.c2 x1
    y spans x 1.510..1.680, y 0.495..2.265 um
    li.3: y [li] vs a (line 28) [li x 1.295..1.465, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move y right by 0.13 um (or move the other shape the opposite way)
    li.c2: y [li] vs a (line 28) [li x 1.295..1.465, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g (line 12: `g   = cross [nd, pd] poly w=L left=(nd.left + 0.265)`) - in 4 of 10 errors: li.3 x3, li.c2 x1
    g spans x 1.305..1.455, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* dn (line 14: `dn  = array licon in=nd right_of=g`) and shapes built from it (dnl) - in 2 of 10 errors: li.3 x2
    dn spans x 1.510..1.680, y 0.575..0.745 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.

NOTES FROM A SENIOR LAYOUT ENGINEER WHO REVIEWED THIS ATTEMPT (follow them):
- LVS already matches. All 10 DRC errors are one problem: the A gate-contact li (`a`) sits 0.045 um from the Y strap `y` (needs 0.17).
- Move the gate contact left, away from the Y strap: `gc = contact licon cx=(g.cx - 0.13) bottom=cb`. Its poly pad still overlaps the gate, and the left side of the gap between the rows is empty.
- Keep the A pin (ap) and Y pin (yp) met1 at least 0.14 apart; nothing else needs to change.