Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 17 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 66: net 'n1': pin nn has no legal access point
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [nd (line 14), sn1l (line 32)] | [pd (line 15), spnl (line 42)] | [gn (line 20), gpn (line 52), nn (line 56)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* yx (line 63: `yx = strap li from=sxnl to=sxpl net=X`) and shapes built from it (xm, xp) - in 16 of 17 errors: li.3 x11, li.c2 x5
    yx spans x 1.410..1.580, y 0.495..2.265 um
    li.3: yx [li] vs nn (line 56) [li x 1.625..1.795, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move yx left by 0.13 um (or move the other shape the opposite way)
    li.c2: yx [li] vs nn (line 56) [li x 1.625..1.795, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gcn (line 49: `gcn = contact licon cx=gn.cx bottom=cb`) and shapes built from it (gpn, nn) - in 12 of 17 errors: li.3 x8, li.c2 x4
    gcn spans x 1.625..1.795, y 1.095..1.265 um
    li.3: nn [li] vs yx (line 63) [li x 1.410..1.580, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcn right by 0.13 um - line 49: `cx=gn.cx` -> `cx=(gn.cx + 0.13)` (or move the other shape the opposite way)
    li.c2: nn [li] vs yx (line 63) [li x 1.410..1.580, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 48: `cb = max(nd.top + 0.19, sn1l.top + 0.25, sn2l.top + 0.25, svnl.top + 0.25, sxnl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gn (line 20: `gn  = cross [nd, pd] poly w=L left=(nd.left + 0.265)`) - in 6 of 17 errors: li.3 x4, li.c2 x2
    gn spans x 1.635..1.785, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* sxn (line 25: `sxn = array licon in=nd left_of=gn net=X`) and shapes built from it (sxnl) - in 2 of 17 errors: li.3 x2
    sxn spans x 1.410..1.580, y 0.575..0.745 um
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.