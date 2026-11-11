Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 17 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 76: net 'n1': pin gl1 has no legal access point (blocked by xp on m1: 0.105 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / X / n1: on diff around (1.15, 0.625): shapes of VGND and X and n1 overlap/touch there (nd_n1 (line 20), nd_vgnd (line 19), nd_x (line 18))
  SHORT VGND / n1: on diff around (1.627, 0.625): shapes of VGND and n1 overlap/touch there (nd_n1 (line 20), nd_vgnd (line 19))
  SHORT VPWR / X / n1: on diff around (1.15, 2.01): shapes of VPWR and X and n1 overlap/touch there (pd_n1 (line 24), pd_vpwr (line 23), pd_x (line 22))
  SHORT VPWR / n1: on diff around (1.627, 2.01): shapes of VPWR and n1 overlap/touch there (pd_n1 (line 24), pd_vpwr (line 23))
  OPEN net VGND is 2 separate pieces: [cn_vgndl (line 36), nd_n1 (line 20), nd_vgnd (line 19), nd_x (line 18), +1 more, template ptap/vgnd] | [cn_n1l (line 38), nd_n1 (line 20), nd_vgnd (line 19)] - join them (strap / shared metal / `route VGND`)
  OPEN net VPWR is 2 separate pieces: [cp_vpwrl (line 44), pd_n1 (line 24), pd_vpwr (line 23), pd_x (line 22), +1 more, template ntap/vpwr] | [cp_n1l (line 46), pd_n1 (line 24), pd_vpwr (line 23)] - join them (strap / shared metal / `route VPWR`)
  OPEN net X is 3 separate pieces: [cn_xl (line 34), cp_xl (line 42), nd_x (line 18), pd_x (line 22), +2 more] | [cn_vgndl (line 36), nd_n1 (line 20), nd_vgnd (line 19), nd_x (line 18), +1 more, template ptap/vgnd] | [cp_vpwrl (line 44), pd_n1 (line 24), pd_vpwr (line 23), pd_x (line 22), +1 more, template ntap/vpwr] - join them (strap / shared metal / `route X`)
  OPEN net n1 is 5 separate pieces: [cn_vgndl (line 36), nd_n1 (line 20), nd_vgnd (line 19), nd_x (line 18), +1 more, template ptap/vgnd] | [cn_n1l (line 38), nd_n1 (line 20), nd_vgnd (line 19)] | [cp_vpwrl (line 44), pd_n1 (line 24), pd_vpwr (line 23), pd_x (line 22), +1 more, template ntap/vpwr] | [cp_n1l (line 46), pd_n1 (line 24), pd_vpwr (line 23)] | [g1 (line 29), gl1 (line 56), gp1 (line 55)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout - the nmos with gate n1 at x=0.88 has VGND+X+n1 and X on its sides; it needs VGND and X: the side labelled VGND+X+n1 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate A at x=1.42 has VPWR+X+n1 and VPWR+n1 on its sides; it needs n1 and VPWR: the side labelled VPWR+X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout - the nmos with gate A at x=1.42 has VGND+X+n1 and VGND+n1 on its sides; it needs n1 and VGND: the side labelled VGND+X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout - the pmos with gate n1 at x=0.88 has VPWR+X+n1 and X on its sides; it needs VPWR and X: the side labelled VPWR+X+n1 should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=0.88 y=0.625: gate n1 [g1 (line 29), gp1 (line 55)], source/drain VGND+X+n1 [cn_vgndl (line 36), nd_n1 (line 20), nd_vgnd (line 19), +2 more], X [cn_xl (line 34), cp_xl (line 42), nd_x (line 18), +2 more]
    layout nmos at x=1.42 y=0.625: gate A [g2 (line 30), gp2 (line 58)], source/drain VGND+X+n1 [cn_vgndl (line 36), nd_n1 (line 20), nd_vgnd (line 19), +2 more], VGND+n1 [cn_n1l (line 38), nd_n1 (line 20), nd_vgnd (line 19)]
DRC root causes (ranked; by the statements in your file):
* sx (line 70: `sx = strap li from=cn_xl to=cp_xl net=X`) and shapes built from it (xm, xp) - in 16 of 17 errors: li.3 x11, li.c2 x5
    sx spans x 0.580..0.750, y 0.460..2.175 um
    li.3: sx [li] vs gl1 (line 56) [li x 0.795..0.965, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move sx left by 0.13 um (or move the other shape the opposite way)
    li.c2: sx [li] vs gl1 (line 56) [li x 0.795..0.965, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc1 (line 54: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (gl1, gp1) - in 12 of 17 errors: li.3 x8, li.c2 x4
    gc1 spans x 0.795..0.965, y 1.040..1.210 um
    li.3: gl1 [li] vs sx (line 70) [li x 0.580..0.750, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 right by 0.13 um - line 54: `cx=g1.cx` -> `cx=(g1.cx + 0.13)` (or move the other shape the opposite way)
    li.c2: gl1 [li] vs sx (line 70) [li x 0.580..0.750, y 0.460..2.175]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 53: `cb = max(nd_x.top + 0.19, nd_vgnd.top + 0.19, nd_n1.top + 0.19, cn_xl.top + 0.25, cn_vgndl.top + 0.25, cn_n1l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 29: `g1 = cross [nd_x, nd_vgnd, nd_n1, pd_x, pd_vpwr, pd_n1] poly w=L left=(x0 + 0.265) ext=(0.13, 0.13)   # gate n1`) - in 6 of 17 errors: li.3 x4, li.c2 x2
    g1 spans x 0.805..0.955, y 0.285..2.435 um
    its position uses x0 (line 15: `x0 = cell.cx - span/2`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* cn_x (line 33: `cn_x  = array licon in=nd_x left_of=g1`) and shapes built from it (cn_xl) - in 2 of 17 errors: li.3 x2
    cn_x spans x 0.580..0.750, y 0.540..0.710 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.