Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 131 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 24: `pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP, py1)`) and shapes built from it (pim) - in 115 of 131 errors: li.3 x24, li.c2 x20, licon.9 x19, licon.11 x13
    pd1 spans x 0.525..1.205, y 1.555..2.305 um
    licon.14: pd1 [diff] vs c6 (line 40) [licon x 0.995..1.165, y 1.675..2.185]: they overlap by 0.210 um, rule needs >= 0.19 um (short by 0.400 um)
    one fix: move pd1 left by 0.4 um (or move the other shape the opposite way)
    licon.9: pd1 [diff] vs c5 (line 38) [licon x 0.565..0.735, y 1.675..2.185]: they overlap by 0.210 um, rule needs >= 0.235 um (short by 0.445 um)
    licon.9: pd1 [diff] vs c6 (line 40) [licon x 0.995..1.165, y 1.675..2.185]: they overlap by 0.210 um, rule needs >= 0.235 um (short by 0.445 um)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gc1 (line 52: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (gl1, gn, gp1) - in 102 of 131 errors: li.3 x26, li.c2 x22, licon.11 x13, poly.7 x8
    gc1 spans x 0.780..0.950, y 1.505..1.675 um
    licon.2: gc1 [licon] vs c5 (line 38) [licon x 0.565..0.735, y 1.675..2.185]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 down by 0.13 um - line 52: `bottom=cb` -> `bottom=(cb - 0.13)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs c5l (line 39) [li x 0.565..0.735, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.3: gl1 [li] vs c6l (line 41) [li x 0.995..1.165, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    its position uses cb (line 51: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 19: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1`) - in 78 of 131 errors: li.3 x20, li.c2 x16, licon.11 x8, poly.7 x6
    g1 spans x 0.790..0.940, y 0.285..2.435 um
    licon.11: g1 [poly] vs gc1 (line 52) [licon x 0.780..0.950, y 1.505..1.675]: they overlap by 0.160 um, rule needs >= 0.055 um (short by 0.215 um)
    one fix: move g1 right by 0.22 um - line 19: `left=(x0 + 0.265)` -> `left=(x0 + 0.265 + 0.22)` (or move the other shape the opposite way)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* c6 (line 40: `c6 = array licon in=pd1 right_of=g1`) and shapes built from it (c6l) - in 29 of 131 errors: li.3 x6, licon.14 x5, licon.9 x5, licon.11 x5
    c6 spans x 0.995..1.165, y 1.675..2.185 um
    li.3: c6l [li] vs gl1 (line 54) [li x 0.780..0.950, y 1.425..1.755]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move c6 right by 0.13 um (or move the other shape the opposite way)
    licon.14: c6 [licon] vs pd1 (line 24) [diff x 0.525..1.205, y 1.555..2.305]: they overlap by 0.210 um, rule needs >= 0.19 um (short by 0.400 um)
    li.c2: c6l [li] vs gl1 (line 54) [li x 0.780..0.950, y 1.425..1.755]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.