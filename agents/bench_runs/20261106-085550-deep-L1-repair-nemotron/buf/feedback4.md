Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 17 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 76: net 'n1': pin gl1 has no legal access point (blocked by xp on m1: 0.105 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [cn_n1l (line 38), nd (line 23)] | [cp_n1l (line 46), pd (line 24)] | [g1 (line 29), gl1 (line 56), gp1 (line 55)] - join them (strap / shared metal / `route n1`)
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
    its position uses cb (line 53: `cb = max(nd.top + 0.19, cn_xl.top + 0.25, cn_vgndl.top + 0.25, cn_n1l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 29: `g1 = cross [nd, pd] poly w=L left=g1l ext=(0.13, 0.13)   # gate n1`) - in 6 of 17 errors: li.3 x4, li.c2 x2
    g1 spans x 0.805..0.955, y 0.285..2.435 um
    its position uses g1l (line 17: `g1l = x0 + 0.265                      # gate n1 left edge`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* cn_x (line 33: `cn_x  = array licon in=nd left_of=g1`) and shapes built from it (cn_xl) - in 2 of 17 errors: li.3 x2
    cn_x spans x 0.580..0.750, y 0.540..0.710 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.