Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 10 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 83: net 'n1': pin n1 has no legal access point
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [cn1l (line 39), nd (line 16)] | [cpnl (line 44), pd (line 17)] | [gn (line 25), gpn (line 60), n1 (line 66)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* gcn (line 57: `gcn = contact licon cx=gn.cx bottom=cb`) and shapes built from it (gpn, n1) - in 8 of 10 errors: li.3 x6, li.c2 x2
    gcn spans x 2.325..2.495, y 1.095..1.265 um
    li.3: n1 [li] vs yx (line 77) [li x 2.540..2.710, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcn left by 0.13 um - line 57: `cx=gn.cx` -> `cx=(gn.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: n1 [li] vs yx (line 77) [li x 2.540..2.710, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 54: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* yx (line 77: `yx = strap li from=cxl to=cpxl net=X`) and shapes built from it (xp) - in 6 of 10 errors: li.3 x5, li.c2 x1
    yx spans x 2.540..2.710, y 0.495..2.265 um
    li.3: yx [li] vs n1 (line 66) [li x 2.325..2.495, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move yx right by 0.13 um (or move the other shape the opposite way)
    li.c2: yx [li] vs n1 (line 66) [li x 2.325..2.495, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gn (line 25: `gn = cross [nd, pd] poly w=L left=(gb.right + gap)           # gate n1`) - in 4 of 10 errors: li.3 x3, li.c2 x1
    gn spans x 2.335..2.485, y 0.285..2.435 um
    its position uses gap (line 22: `gap = max(0.28, 0.74 - L)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* cx (line 31: `cx  = array licon in=nd right_of=gn           # X (M0.s) -- right of gate n1`) and shapes built from it (cxl) - in 2 of 10 errors: li.3 x2
    cx spans x 2.540..2.710, y 0.575..0.745 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (5010) than your best so far (5007); your best version is saved as /best.icl.