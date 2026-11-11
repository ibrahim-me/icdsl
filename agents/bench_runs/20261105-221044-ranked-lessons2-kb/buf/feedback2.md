Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 102 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 57: net 'n1': pin nn has no legal access point (blocked by vpwr on m1: 0.035 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / VPWR / n1: on li around (1.38, 2.325): shapes of A and VPWR and n1 overlap/touch there (aa (line 46), nn (line 47), pvl (line 32), pwr (line 34))
  OPEN net n1 is 3 separate pieces: [nd (line 11), snl (line 22)] | [pd (line 12), spl (line 31)] | [aa (line 46), ap (line 52), ga (line 15), gn (line 16), +7 more, template ntap/vpwr] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.165 y=0.625: gate A+VPWR+n1 [ga (line 15), gpa (line 43)], source/drain VGND [nd (line 11), snl (line 22)], n1 [gnd (line 25), nd (line 11), svl (line 23), template ptap/vgnd]
    layout nmos at x=1.595 y=0.625: gate A+VPWR+n1 [gn (line 16), gpn (line 44)], source/drain VGND [gnd (line 25), nd (line 11), svl (line 23), template ptap/vgnd], X [nd (line 11), pd (line 12), pxl (line 33), +3 more]
    layout pmos at x=1.165 y=2.01: gate A+VPWR+n1 [ga (line 15), gpa (line 43)], source/drain A+VPWR+n1 [pd (line 12), spl (line 31)], n1 [aa (line 46), ap (line 52), ga (line 15), +8 more, template ntap/vpwr]
    layout pmos at x=1.595 y=2.01: gate A+VPWR+n1 [gn (line 16), gpn (line 44)], source/drain A+VPWR+n1 [aa (line 46), ap (line 52), ga (line 15), +8 more, template ntap/vpwr], X [nd (line 11), pd (line 12), pxl (line 33), +3 more]
DRC root causes (ranked; by the statements in your file):
* gca (line 41: `gca = contact licon cx=(ga.cx - 0.1) bottom=cb`) and shapes built from it (aa, am, ap, gnc, gpa) - in 37 of 102 errors: licon.14 x10, licon.7 x5, mcon.2 x4, li.3 x4
    gca spans x 0.980..1.150, y 2.425..2.595 um
    mcon.2: am [mcon] vs template ntap_mcon [mcon x 0.145..2.615, y 2.635..2.805]: gap 0.040 um, rule needs >= 0.19 um (short by 0.150 um)
    one fix: move gca down by 0.15 um - line 41: `bottom=cb` -> `bottom=(cb - 0.15)` (or move the other shape the opposite way)
    li.3: aa [li] vs pwr (line 34) [li x 1.295..1.465, y 1.845..2.805]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    licon.10: gca [licon] vs ga (line 15) [poly x 1.090..1.240, y 0.285..2.435]: they overlap by 0.010 um, rule needs >= 0.25 um (short by 0.260 um)
    its position uses cb (line 40: `cb  = max(nd.top + 0.19, snl.top + 0.25, spl.top + 0.25)`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule licon.7: something overlaps the template tap contacts - keep your shapes out of the tap rows
* gcn (line 42: `gcn = contact licon cx=(gn.cx + 0.1) bottom=cb`) and shapes built from it (gpn, nm, nn, np) - in 34 of 102 errors: licon.14 x10, licon.7 x5, mcon.2 x4, li.3 x4
    gcn spans x 1.610..1.780, y 2.425..2.595 um
    mcon.2: nm [mcon] vs template ntap_mcon [mcon x 0.145..2.615, y 2.635..2.805]: gap 0.040 um, rule needs >= 0.19 um (short by 0.150 um)
    one fix: move gcn down by 0.15 um - line 42: `bottom=cb` -> `bottom=(cb - 0.15)` (or move the other shape the opposite way)
    li.3: nn [li] vs pwr (line 34) [li x 1.295..1.465, y 1.845..2.805]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    licon.10: gcn [licon] vs gn (line 16) [poly x 1.520..1.670, y 0.285..2.435]: they overlap by 0.010 um, rule needs >= 0.25 um (short by 0.260 um)
    its position uses cb (line 40: `cb  = max(nd.top + 0.19, snl.top + 0.25, spl.top + 0.25)`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule licon.7: something overlaps the template tap contacts - keep your shapes out of the tap rows
* pwr (line 34: `pwr = strap li from=pvl to=vpwr_li`) - in 19 of 102 errors: li.3 x10, licon.14 x4, licon.1 x4, varac.7 x1
    pwr spans x 1.295..1.465, y 1.845..2.805 um
    li.3: pwr [li] vs aa (line 46) [li x 0.980..1.150, y 2.345..2.675]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    one fix: move pwr right by 0.03 um (or move the other shape the opposite way)
    li.3: pwr [li] vs nn (line 47) [li x 1.610..1.780, y 2.345..2.675]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
* pd (line 12: `pd  = rect diff w=dw h=WP cx=cell.cx below=ntap`) and shapes built from it (pim) - in 13 of 102 errors: li.3 x4, poly.4 x4, licon.9 x4, varac.7 x1
    pd spans x 0.825..1.935, y 1.715..2.305 um
    poly.4: pd [diff] vs gpa (line 43) [poly x 0.900..1.230, y 2.375..2.645]: gap 0.070 um, rule needs >= 0.075 um (short by 0.005 um)
    one fix: move pd down by 0.01 um (or move the other shape the opposite way)
    poly.4: pd [diff] vs ga (line 15) [poly x 1.090..1.240, y 0.285..2.435]: they overlap by 0.415 um, rule needs >= 0.075 um (short by 0.490 um)
    poly.4: pd [diff] vs gn (line 16) [poly x 1.520..1.670, y 0.285..2.435]: they overlap by 0.415 um, rule needs >= 0.075 um (short by 0.490 um)
    its position uses dw (line 10: `dw  = 2*L + 0.81                      # n1 | gateA | supply | gateN1 | X`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
WARNING buf: port A: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by vpwr on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.