Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 299 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 26: `pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)`) - in 134 of 150 errors: li.3 x56, poly.7 x28, licon.14 x19, poly.1a x16
    pd1 spans x 0.460..2.760, y 1.555..2.305 um
    licon.14: pd1 [diff] vs c7 (line 43) [licon x 0.930..1.100, y 1.675..2.185]: they overlap by 0.630 um, rule needs >= 0.19 um (short by 0.820 um)
    one fix: move pd1 right by 0.82 um (or move the other shape the opposite way)
    licon.14: pd1 [diff] vs gc2 (line 54) [licon x 1.255..1.425, y 1.505..1.675]: they overlap by 0.120 um, rule needs >= 0.19 um (short by 0.310 um)
    licon.14: pd1 [diff] vs c8 (line 45) [licon x 2.010..2.180, y 1.675..2.185]: they overlap by 0.630 um, rule needs >= 0.19 um (short by 0.820 um)
    its position uses py1 (line 18: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* gc1 (line 51: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (a2m, a2p, gl1, gp1) - in 41 of 150 errors: li.3 x20, poly.7 x8, licon.14 x5, poly.1a x4
    gc1 spans x 0.715..0.885, y 1.505..1.675 um
    licon.2: gc1 [licon] vs c6 (line 41) [licon x 0.500..0.670, y 1.675..2.185]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 down by 0.13 um - line 51: `bottom=cb` -> `bottom=(cb - 0.13)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs c6l (line 42) [li x 0.500..0.670, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.3: gl1 [li] vs c7l (line 44) [li x 0.930..1.100, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    its position uses cb (line 50: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* gc4 (line 60: `gc4 = contact licon cx=g4.cx bottom=cb`) and shapes built from it (a1m, a1p, gl4, gp4) - in 35 of 150 errors: li.3 x15, poly.7 x8, licon.14 x5, poly.1a x4
    gc4 spans x 2.335..2.505, y 1.505..1.675 um
    licon.2: gc4 [licon] vs c8 (line 45) [licon x 2.010..2.180, y 1.675..2.185]: gap 0.155 um, rule needs >= 0.17 um (short by 0.015 um)
    one fix: move gc4 down by 0.02 um - line 60: `bottom=cb` -> `bottom=(cb - 0.02)` (or move the other shape the opposite way)
    li.3: gl4 [li] vs c8l (line 46) [li x 2.010..2.180, y 1.595..2.265]: gap 0.155 um, rule needs >= 0.17 um (short by 0.015 um)
    li.3: gl4 [li] vs c9l (line 49) [li x 2.550..2.720, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    its position uses cb (line 50: `cb = max(pd1.bottom - 0.05, nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* g1 (line 21: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2`) - in 30 of 150 errors: li.3 x14, poly.7 x6, poly.1a x4, licon.14 x3
    g1 spans x 0.725..0.875, y 0.285..2.435 um
    its position uses py1 (line 18: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 17: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.