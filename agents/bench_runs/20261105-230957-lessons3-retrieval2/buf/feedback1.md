Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 22 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 47: net 'n1': pin gl1 has no legal access point (blocked by ap on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / X / n1: on m1 around (1.002, 1.22): shapes of A and X overlap/touch there (ap (line 49), xp (line 54))
  SHORT A / B: joined through contacts/vias: A: gl2 (line 44); B: bp (line 52)
  OPEN net A is 2 separate pieces: [ap (line 49), cn1l (line 23), cp1l (line 31), g1 (line 15), +6 more] | [bp (line 52), g2 (line 16), gl2 (line 44), gp2 (line 43)] - join them (strap / shared metal / `route A`)
  OPEN net n1 is 3 separate pieces: [ap (line 49), cn1l (line 23), cp1l (line 31), g1 (line 15), +6 more] | [cnnl (line 28), nd (line 17)] | [cppl (line 36), pd (line 18)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.11 y=0.625: gate A+X+n1 [g1 (line 15), gp1 (line 40)], source/drain A+X+n1 [cn1l (line 23), cp1l (line 31), gl1 (line 41), +3 more], VGND [cvnl (line 25), cvns (line 26), nd (line 17)]
    layout nmos at x=1.65 y=0.625: gate A+B [g2 (line 16), gp2 (line 43)], source/drain VGND [cvnl (line 25), cvns (line 26), nd (line 17)], n1 [cnnl (line 28), nd (line 17)]
    layout pmos at x=1.11 y=2.01: gate A+X+n1 [g1 (line 15), gp1 (line 40)], source/drain A+X+n1 [cn1l (line 23), cp1l (line 31), gl1 (line 41), +3 more], VPWR [cvpl (line 33), cvps (line 34), pd (line 18)]
    layout pmos at x=1.65 y=2.01: gate A+B [g2 (line 16), gp2 (line 43)], source/drain VPWR [cvpl (line 33), cvps (line 34), pd (line 18)], n1 [cppl (line 36), pd (line 18)]
DRC root causes (ranked; by the statements in your file):
* yx (line 37: `yx = strap li from=cn1l to=cp1l net=X`) and shapes built from it (xm, xp) - in 21 of 22 errors: li.3 x11, li.c2 x5, mcon.2 x4, met1.1 x1
    yx spans x 0.810..0.980, y 0.460..2.175 um
    mcon.2: xm [mcon] vs am (line 48) [mcon x 1.025..1.195, y 1.040..1.210]: gap 0.045 um, rule needs >= 0.19 um (short by 0.145 um)
    one fix: move yx up by 0.15 um (or move the other shape the opposite way)
    li.3: yx [li] vs gl1 (line 41) [li x 1.025..1.195, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: yx [li] vs gl1 (line 41) [li x 1.025..1.195, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc1 (line 39: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (am, ap, gl1, gp1) - in 20 of 22 errors: li.3 x10, li.c2 x5, mcon.2 x4, met1.1 x1
    gc1 spans x 1.025..1.195, y 1.040..1.210 um
    mcon.2: am [mcon] vs xm (line 53) [mcon x 0.810..0.980, y 1.230..1.400]: gap 0.045 um, rule needs >= 0.19 um (short by 0.145 um)
    one fix: move gc1 down by 0.15 um - line 39: `bottom=cb` -> `bottom=(cb - 0.15)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs yx (line 37) [li x 0.810..0.980, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: gl1 [li] vs yx (line 37) [li x 0.810..0.980, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 38: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cvnl.top + 0.25, cnnl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 15: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1`) - in 9 of 22 errors: li.3 x4, mcon.2 x2, li.c2 x2, met1.1 x1
    g1 spans x 1.035..1.185, y 0.285..2.435 um
    its position uses x0 (line 14: `x0 = cell.cx - span/2`)
    its position uses ny0 (line 10: `ny0 = ptap.top + 0.27                 # bottom of the n row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* cn1 (line 22: `cn1 = array licon in=nd left_of=g1`) and shapes built from it (cn1l) - in 2 of 22 errors: li.3 x2
    cn1 spans x 0.810..0.980, y 0.540..0.710 um
    rule li.3: two li shapes of different nets closer than 0.17 um
WARNING buf: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING buf: port X: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.