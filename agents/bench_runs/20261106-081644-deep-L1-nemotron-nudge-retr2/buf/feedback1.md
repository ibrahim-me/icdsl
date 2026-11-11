Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 32 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 59: net 'n1': pin gl1+n1g_p has no legal access point (blocked by xp on m1: 0.105 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT X / n1: on m1 around (1.002, 1.22): shapes of X and n1 overlap/touch there (n1g_p (line 58), xp (line 67))
  OPEN net n1 is 2 separate pieces: [cnl (line 26), cpl (line 28), g1 (line 17), gl1 (line 48), +6 more] | [cel (line 39), cepl (line 41), n1p (line 56), n1s (line 42), +2 more] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.11 y=0.625: gate X+n1 [g1 (line 17), gp1 (line 47)], source/drain VGND [cmnl (line 32), cmns (line 33), nd (line 19)], X+n1 [cnl (line 26), cpl (line 28), gl1 (line 48), +3 more]
    layout pmos at x=1.11 y=2.01: gate X+n1 [g1 (line 17), gp1 (line 47)], source/drain VPWR [cmpl (line 35), cmps (line 36), pd (line 20)], X+n1 [cnl (line 26), cpl (line 28), gl1 (line 48), +3 more]
DRC root causes (ranked; by the statements in your file):
* xst (line 29: `xst = strap li from=cnl to=cpl net=X          # output X (both rows line up)`) and shapes built from it (xm, xp) - in 21 of 32 errors: li.3 x11, li.c2 x5, mcon.2 x4, met1.1 x1
    xst spans x 0.810..0.980, y 0.460..2.175 um
    mcon.2: xm [mcon] vs n1g (line 57) [mcon x 1.025..1.195, y 1.040..1.210]: gap 0.045 um, rule needs >= 0.19 um (short by 0.145 um)
    one fix: move xst up by 0.15 um (or move the other shape the opposite way)
    li.3: xst [li] vs gl1 (line 48) [li x 1.025..1.195, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: xst [li] vs gl1 (line 48) [li x 1.025..1.195, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc1 (line 46: `gc1 = contact licon cx=g1.cx bottom=cb        # gate n1 contact`) and shapes built from it (gl1, gp1, n1g, n1g_p) - in 20 of 32 errors: li.3 x10, li.c2 x5, mcon.2 x4, met1.1 x1
    gc1 spans x 1.025..1.195, y 1.040..1.210 um
    mcon.2: n1g [mcon] vs xm (line 66) [mcon x 0.810..0.980, y 1.230..1.400]: gap 0.045 um, rule needs >= 0.19 um (short by 0.145 um)
    one fix: move gc1 down by 0.15 um - line 46: `bottom=cb` -> `bottom=(cb - 0.15)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs xst (line 29) [li x 0.810..0.980, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: gl1 [li] vs xst (line 29) [li x 0.810..0.980, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 45: `cb = max(nd.top + 0.19, cnl.top + 0.25, cel.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc2 (line 49: `gc2 = contact licon cx=g2.cx bottom=cb        # gate A contact`) and shapes built from it (am, ap, gl2, gp2) - in 10 of 32 errors: li.3 x8, li.c2 x2
    gc2 spans x 1.565..1.735, y 1.040..1.210 um
    li.3: gl2 [li] vs n1s (line 42) [li x 1.780..1.950, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc2 left by 0.13 um - line 49: `cx=g2.cx` -> `cx=(g2.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: gl2 [li] vs n1s (line 42) [li x 1.780..1.950, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 45: `cb = max(nd.top + 0.19, cnl.top + 0.25, cel.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 17: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1`) - in 9 of 32 errors: li.3 x4, mcon.2 x2, li.c2 x2, met1.1 x1
    g1 spans x 1.035..1.185, y 0.285..2.435 um
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row`)
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
WARNING buf: port X: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.