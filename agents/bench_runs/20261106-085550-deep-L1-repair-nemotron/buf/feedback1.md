Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 175 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 51: net 'n1': pin c6l has no legal access point (blocked by ap on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [c3l (line 29), nd1 (line 19)] | [c6l (line 36), pd1 (line 20)] | [g1 (line 17), gl1 (line 40), gp1 (line 39)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 20: `pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)`) and shapes built from it (pim) - in 146 of 150 errors: li.3 x40, li.c2 x24, poly.7 x18, diff/tap.2 x15
    pd1 spans x 0.540..1.760, y 1.715..2.305 um
    licon.14: pd1 [diff] vs c5 (line 32) [licon x 1.010..1.180, y 1.925..2.095]: they overlap by 0.380 um, rule needs >= 0.19 um (short by 0.570 um)
    one fix: move pd1 right by 0.57 um (or move the other shape the opposite way)
    licon.14: pd1 [diff] vs c6 (line 35) [licon x 1.550..1.720, y 1.925..2.095]: they overlap by 0.210 um, rule needs >= 0.19 um (short by 0.400 um)
    licon.9: pd1 [diff] vs c5 (line 32) [licon x 1.010..1.180, y 1.925..2.095]: they overlap by 0.380 um, rule needs >= 0.235 um (short by 0.615 um)
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc1 (line 38: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (gl1, gn, gp1) - in 68 of 150 errors: li.3 x14, licon.9 x12, li.c2 x11, poly.7 x8
    gc1 spans x 0.795..0.965, y 1.665..1.835 um
    licon.2: gc1 [licon] vs c4 (line 30) [licon x 0.580..0.750, y 1.925..2.095]: gap 0.090 um, rule needs >= 0.17 um (short by 0.080 um)
    one fix: move gc1 down by 0.08 um - line 38: `bottom=cb` -> `bottom=(cb - 0.08)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs c4l (line 31) [li x 0.580..0.750, y 1.845..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.3: gl1 [li] vs c5l (line 33) [li x 1.010..1.180, y 1.845..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    its position uses cb (line 37: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
* g1 (line 17: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1`) - in 56 of 150 errors: li.3 x12, li.c2 x10, poly.7 x6, diff/tap.2 x6
    g1 spans x 0.805..0.955, y 0.285..2.435 um
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc2 (line 41: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (am, ap, gl2, gp2) - in 50 of 150 errors: li.3 x12, poly.7 x8, licon.9 x5, poly.1a x4
    gc2 spans x 1.335..1.505, y 1.665..1.835 um
    li.3: gl2 [li] vs c5l (line 33) [li x 1.010..1.180, y 1.845..2.175]: gap 0.155 um, rule needs >= 0.17 um (short by 0.015 um)
    one fix: move gc2 right by 0.02 um - line 41: `cx=g2.cx` -> `cx=(g2.cx + 0.02)` (or move the other shape the opposite way)
    li.3: gl2 [li] vs c6l (line 36) [li x 1.550..1.720, y 1.845..2.175]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: gl2 [li] vs c6l (line 36) [li x 1.550..1.720, y 1.845..2.175]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 37: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.