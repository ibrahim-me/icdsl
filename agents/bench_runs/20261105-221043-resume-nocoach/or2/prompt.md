Design the standard cell `or2`: X = A | B (NOR2 + inverter).
Inputs: A, B; output: X; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=<columns, your choice> height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port X out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

Your best attempt so far:
```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  gapg = max(0.28, 0.60 - L)
  ndw  = 3*L + 2*0.265 + 2*gapg
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm
  # gate order left->right: n2, A, B  (pitch >= 0.60 so poly contact pads clear)
  gn2  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga   = cross [nd, pd] poly w=L left=(gn2.right + gapg)
  gb   = cross [nd, pd] poly w=L left=(ga.right + gapg)
  # n-diff columns: c0=X c1=VGND c2=n2 c3=VGND
  dxn  = array licon in=nd left_of=gn2
  dvn  = array licon in=nd right_of=gn2 left_of=ga
  dn2n = array licon in=nd right_of=ga left_of=gb
  dvn2 = array licon in=nd right_of=gb
  # p-diff columns: c0=X c1=VPWR c2=n1 c3=n2
  dxp  = array licon in=pd left_of=gn2
  dvp  = array licon in=pd right_of=gn2 left_of=ga
  dn1p = array licon in=pd right_of=ga left_of=gb
  dn2p = array licon in=pd right_of=gb
  dxnl = enclose dxn li net=X
  dvnl = enclose dvn li
  dn2nl= enclose dn2n li net=n2
  dvn2l= enclose dvn2 li
  dxpl = enclose dxp li net=X
  dvpl = enclose dvp li
  dn1pl= enclose dn1p li net=n1
  dn2pl= enclose dn2p li net=n2
  xst  = strap li from=dxnl to=dxpl net=X
  gnd1 = strap li from=dvnl to=vgnd_li
  gnd2 = strap li from=dvn2l to=vgnd_li
  pwr1 = strap li from=dvpl to=vpwr_li
  n2st = strap li from=dn2nl to=dn2pl net=n2 cy=dn2nl.cy
  route n2 layers=m1,m2
  # gate contacts in gap between rows, on their own gate lines (n-row items only in cb)
  cb   = max(nd.top + 0.19, dxnl.top + 0.25, dvnl.top + 0.25, dn2nl.top + 0.25, dvn2l.top + 0.25)
  gn2c = contact licon cx=gn2.cx bottom=cb
  gac  = contact licon cx=ga.cx bottom=cb
  gbc  = contact licon cx=gb.cx bottom=cb
  gn2p = enclose gn2c poly by=minx
  gap  = enclose gac poly by=minx
  gbp  = enclose gbc poly by=minx
  gn   = enclose [gn2c, gac, gbc] npc
  an2  = enclose gn2c li net=n2
  aa   = enclose gac li net=A
  ab   = enclose gbc li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # input ports on met1
  bm   = contact mcon in=ab
  bp   = enclose bm m1 by=0.06 net=B
  am   = contact mcon in=aa
  ap   = enclose am m1 by=0.06 net=A
  # output X on met1 (n-side and p-side X straps already joined)
  xm   = contact mcon in=dxnl
  xp   = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 17 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / n2: on li around (2.07, 0.37): shapes of VGND and n2 overlap/touch there (dn2nl (line 34), dvn2l (line 35), dvnl (line 33), gnd1 (line 41), gnd2 (line 42), n2st (line 44))
  DEVICE M1 (nmos g=n2 d=VGND s=X) has no matching transistor in the layout
  DEVICE M2 (nmos g=B d=VGND s=n2) has no matching transistor in the layout
  DEVICE M3 (nmos g=A d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M4 (pmos g=B d=n2 s=n1) has no matching transistor in the layout
  DEVICE M5 (pmos g=n2 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.47 y=0.66: gate VGND+n2 [gn2 (line 19), gn2p (line 51)], source/drain VGND+n2 [dxnl (line 32), dxpl (line 36), nd (line 14), +3 more], X [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2]
    layout nmos at x=2.07 y=0.66: gate A [ga (line 20), gap (line 52)], source/drain VGND+n2 [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2], VGND+n2 [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2]
    layout nmos at x=2.67 y=0.66: gate B [gb (line 21), gbp (line 53)], source/drain VGND+n2 [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2], VGND+n2 [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2]
    layout pmos at x=1.47 y=1.93: gate VGND+n2 [gn2 (line 19), gn2p (line 51)], source/drain VPWR [dxnl (line 32), dxpl (line 36), nd (line 14), +3 more], X [dvpl (line 37), pd (line 15), pwr1 (line 43), template ntap/vpwr]
    layout pmos at x=2.67 y=1.93: gate B [gb (line 21), gbp (line 53)], source/drain VGND+n2 [dn1pl (line 38), pd (line 15)], n1 [an2 (line 55), dn2nl (line 34), dn2pl (line 39), +9 more, template ptap/vgnd, route n2]
DRC root causes (ranked; by the statements in your file):
* gn2c (line 48: `gn2c = contact licon cx=gn2.cx bottom=cb`) and shapes built from it (an2, gn2p) - in 14 of 17 errors: li.3 x8, li.c2 x6
    gn2c spans x 1.385..1.555, y 1.095..1.265 um
    li.3: an2 [li] vs xst (line 40) [li x 1.170..1.340, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gn2c right by 0.13 um - line 48: `cx=gn2.cx` -> `cx=(gn2.cx + 0.13)` (or move the other shape the opposite way)
    li.c2: an2 [li] vs xst (line 40) [li x 1.170..1.340, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 47: `cb   = max(nd.top + 0.19, dxnl.top + 0.25, dvnl.top + 0.25, dn2nl.top + 0.25, dvn2l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* xst (line 40: `xst  = strap li from=dxnl to=dxpl net=X`) - in 10 of 17 errors: li.3 x6, li.c2 x4
    xst spans x 1.170..1.340, y 0.495..2.265 um
    li.3: xst [li] vs an2 (line 55) [li x 1.385..1.555, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move xst left by 0.13 um (or move the other shape the opposite way)
    li.c2: xst [li] vs an2 (line 55) [li x 1.385..1.555, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gn2 (line 19: `gn2  = cross [nd, pd] poly w=L left=(nd.left + 0.265)`) - in 7 of 17 errors: li.3 x4, li.c2 x3
    gn2 spans x 1.395..1.545, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 14: `nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap`) - in 4 of 17 errors: li.3 x2, li.c2 x2
    nd spans x 1.130..3.010, y 0.415..0.905 um
    its position uses ndw (line 13: `ndw  = 3*L + 2*0.265 + 2*gapg`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.