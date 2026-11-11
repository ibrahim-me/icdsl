Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 17 errors, LVS MISMATCH)
LVS mismatch (netgen): Netlists do not match.
  layout/reference devices [6, 6], nets [8, 7]
DRC root causes (ranked; by the statements in your file):
* gc1 (line 51: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (gl1, gp1) - in 14 of 17 errors: li.3 x8, li.c2 x6
    gc1 spans x 0.780..0.950, y 1.095..1.265 um
    li.3: gl1 [li] vs xst (line 49) [li x 0.565..0.735, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 right by 0.13 um - line 51: `cx=g1.cx` -> `cx=(g1.cx + 0.13)` (or move the other shape the opposite way)
    li.c2: gl1 [li] vs xst (line 49) [li x 0.565..0.735, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 50: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* xst (line 49: `xst = strap li from=c1l to=c5l net=X`) - in 10 of 17 errors: li.3 x6, li.c2 x4
    xst spans x 0.565..0.735, y 0.495..2.265 um
    li.3: xst [li] vs gl1 (line 53) [li x 0.780..0.950, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move xst left by 0.13 um (or move the other shape the opposite way)
    li.c2: xst [li] vs gl1 (line 53) [li x 0.780..0.950, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g1 (line 19: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n2`) - in 7 of 17 errors: li.3 x4, li.c2 x3
    g1 spans x 0.790..0.940, y 0.285..2.435 um
    its position uses x0 (line 18: `x0 = cell.cx - span/2`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* c1 (line 28: `c1 = array licon in=nd1 left_of=g1`) and shapes built from it (c1l) - in 2 of 17 errors: li.3 x2
    c1 spans x 0.565..0.735, y 0.575..0.745 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.