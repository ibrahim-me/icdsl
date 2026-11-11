Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 17 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* gc3 (line 59: `gc3 = contact licon cx=g3.cx bottom=cb`) and shapes built from it (gl3, gp3) - in 14 of 17 errors: li.3 x8, li.c2 x6
    gc3 spans x 1.605..1.775, y 1.040..1.210 um
    li.3: gl3 [li] vs y (line 76) [li x 1.820..1.990, y 0.460..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc3 left by 0.13 um - line 59: `cx=g3.cx` -> `cx=(g3.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: gl3 [li] vs y (line 76) [li x 1.820..1.990, y 0.460..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 52: `cb = max(nd.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* y (line 76: `y = strap li from=c4l to=c8l net=X`) and shapes built from it (xp) - in 10 of 17 errors: li.3 x6, li.c2 x4
    y spans x 1.820..1.990, y 0.460..2.265 um
    li.3: y [li] vs gl3 (line 61) [li x 1.605..1.775, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move y right by 0.13 um (or move the other shape the opposite way)
    li.c2: y [li] vs gl3 (line 61) [li x 1.605..1.775, y 0.960..1.290]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g3 (line 22: `g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1`) - in 7 of 17 errors: li.3 x4, li.c2 x3
    g3 spans x 1.615..1.765, y 0.285..2.435 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses gap (line 17: `gap = max(0.28, 0.54 - L)             # gate-to-gate gap (contacted gates)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 23: `nd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN2)`) - in 2 of 17 errors: li.3 x2
    nd spans x 0.270..2.030, y 0.415..0.835 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.