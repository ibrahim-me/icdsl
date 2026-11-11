Your last change made things worse (score 5060 vs best 5004). Here is your BEST version so far - continue from it, not from the last one:
```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81                      # n1 | gateA | supply | gateN1 | X
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L left=(ga.right + 0.28)

  # n row: n1(drain M2) | gateA | VGND(shared) | gateN1 | X(source M0)
  sn  = array licon in=nd left_of=ga            # n1 drain of M2
  sv  = array licon in=nd between=[ga, gn]      # VGND shared column
  sx  = array licon in=nd right_of=gn           # X source of M0
  snl = enclose sn li net=n1
  svl = enclose sv li
  sxl = enclose sx li net=X
  gnd = strap li from=svl to=vgnd_li

  # p row: n1(drain M1) | gateA | VPWR(shared) | gateN1 | X(source M3)
  sp  = array licon in=pd left_of=ga            # n1 drain of M1
  pv  = array licon in=pd between=[ga, gn]      # VPWR shared column
  px  = array licon in=pd right_of=gn           # X source of M3
  spl = enclose sp li net=n1
  pvl = enclose pv li
  pxl = enclose px li net=X
  pwr = strap li from=pvl to=vpwr_li

  # join the two n1 drains (n and p rows) and route n1 to the gate contact
  n1s = strap li from=snl to=spl net=n1

  # output strap joins n-side X and p-side X columns
  yst = strap li from=sxl to=pxl net=X

  # gate contacts in the gap between the rows, shifted outward from the central straps
  cb  = max(nd.top + 0.19, snl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcn = contact licon cx=(gn.cx + 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gnc = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  nn  = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  nm  = contact mcon in=nn
  np  = enclose nm m1 by=0.06 net=n1
  xm  = contact mcon in=yst
  xp  = enclose xm m1 by=0.06 net=X
  route n1 layers=m1,m2

  port A in  on=ap
  port X out on=xp
end
```
Its check result:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 4 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 60: net 'n1': pin nn has no legal access point (blocked by xp on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / n1: on li around (0.992, 1.317): shapes of A and n1 overlap/touch there (aa (line 49), n1s (line 37), snl (line 22), spl (line 31))
  SHORT X / n1: on li around (1.767, 1.317): shapes of X and n1 overlap/touch there (nn (line 50), pxl (line 33), sxl (line 24), yst (line 40))
  OPEN net n1 is 2 separate pieces: [aa (line 49), ap (line 55), ga (line 15), gpa (line 46), +5 more] | [gn (line 16), gpn (line 47), nd (line 11), nn (line 50), +6 more] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.165 y=0.625: gate A+n1 [ga (line 15), gpa (line 46)], source/drain A+n1 [aa (line 49), ap (line 55), ga (line 15), +6 more], VGND [gnd (line 25), nd (line 11), svl (line 23), template ptap/vgnd]
    layout nmos at x=1.595 y=0.625: gate X+n1 [gn (line 16), gpn (line 47)], source/drain VGND [gnd (line 25), nd (line 11), svl (line 23), template ptap/vgnd], X+n1 [gn (line 16), gpn (line 47), nd (line 11), +7 more]
    layout pmos at x=1.165 y=2.01: gate A+n1 [ga (line 15), gpa (line 46)], source/drain A+n1 [aa (line 49), ap (line 55), ga (line 15), +6 more], VPWR [pd (line 12), pvl (line 32), pwr (line 34), template ntap/vpwr]
    layout pmos at x=1.595 y=2.01: gate X+n1 [gn (line 16), gpn (line 47)], source/drain VPWR [pd (line 12), pvl (line 32), pwr (line 34), template ntap/vpwr], X+n1 [gn (line 16), gpn (line 47), nd (line 11), +7 more]
DRC root causes (ranked; by the statements in your file):
* gcn (line 45: `gcn = contact licon cx=(gn.cx + 0.13) bottom=cb`) and shapes built from it (gpn, nm, nn, np) - in 4 of 4 errors: mcon.2 x4
    gcn spans x 1.640..1.810, y 1.040..1.210 um
    mcon.2: nm [mcon] vs xm (line 58) [mcon x 1.725..1.895, y 1.230..1.400]: gap 0.020 um, rule needs >= 0.19 um (short by 0.170 um)
    one fix: move gcn down by 0.17 um - line 45: `bottom=cb` -> `bottom=(cb - 0.17)` (or move the other shape the opposite way)
    its position uses cb (line 43: `cb  = max(nd.top + 0.19, snl.top + 0.25)`)
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* yst (line 40: `yst = strap li from=sxl to=pxl net=X`) and shapes built from it (xm, xp) - in 4 of 4 errors: mcon.2 x4
    yst spans x 1.725..1.895, y 0.460..2.175 um
    mcon.2: xm [mcon] vs nm (line 56) [mcon x 1.640..1.810, y 1.040..1.210]: gap 0.020 um, rule needs >= 0.19 um (short by 0.170 um)
    one fix: move yst up by 0.17 um (or move the other shape the opposite way)
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* gn (line 16: `gn  = cross [nd, pd] poly w=L left=(ga.right + 0.28)`) - in 2 of 4 errors: mcon.2 x2
    gn spans x 1.520..1.670, y 0.285..2.435 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
WARNING buf: port X: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.