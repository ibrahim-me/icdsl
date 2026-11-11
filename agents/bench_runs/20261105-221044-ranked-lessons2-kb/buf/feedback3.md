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