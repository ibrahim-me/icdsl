Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 10 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* gc (line 26: `gc  = contact licon cx=g.cx bottom=cb`) and shapes built from it (a, am, ap, gp) - in 10 of 10 errors: li.3 x8, li.c2 x2
    gc spans x 0.835..1.005, y 1.095..1.265 um
    li.3: a [li] vs y (line 24) [li x 1.050..1.220, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc left by 0.13 um - line 26: `cx=g.cx` -> `cx=(g.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: a [li] vs y (line 24) [li x 1.050..1.220, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 25: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* y (line 24: `y   = strap li from=dnl to=dpl        # joins n and p Y columns (same x)`) - in 6 of 10 errors: li.3 x5, li.c2 x1
    y spans x 1.050..1.220, y 0.495..2.265 um
    li.3: y [li] vs a (line 29) [li x 0.835..1.005, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move y right by 0.13 um (or move the other shape the opposite way)
    li.c2: y [li] vs a (line 29) [li x 0.835..1.005, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* g (line 13: `g   = cross [nd, pd] poly w=L`) - in 4 of 10 errors: li.3 x3, li.c2 x1
    g spans x 0.845..0.995, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 9: `nd  = rect diff w=dw h=WN cx=cell.cx above=ptap`) - in 2 of 10 errors: li.3 x2
    nd spans x 0.580..1.260, y 0.415..0.905 um
    its position uses dw (line 8: `dw  = L + 0.53                      # gate + 2 x (contact 0.17 + 0.055 + 0.04)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.