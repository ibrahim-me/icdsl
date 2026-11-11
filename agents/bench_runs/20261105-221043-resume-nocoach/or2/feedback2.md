Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 17 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* gn2c (line 51: `gn2c = contact licon cx=gn2.cx bottom=cb`) and shapes built from it (an2, gn2p) - in 14 of 17 errors: li.3 x8, li.c2 x6
    gn2c spans x 1.515..1.685, y 1.095..1.265 um
    li.3: an2 [li] vs xst (line 46) [li x 1.300..1.470, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gn2c right by 0.13 um - line 51: `cx=gn2.cx` -> `cx=(gn2.cx + 0.13)` (or move the other shape the opposite way)
    li.c2: an2 [li] vs xst (line 46) [li x 1.300..1.470, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 50: `cb   = max(nd.top + 0.19, dxnl.top + 0.25, dvnl.top + 0.25, dn2nl.top + 0.25, dvn2l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* xst (line 46: `xst  = strap li from=dxnl to=dxpl net=X`) - in 10 of 17 errors: li.3 x6, li.c2 x4
    xst spans x 1.300..1.470, y 0.495..2.265 um
    li.3: xst [li] vs an2 (line 58) [li x 1.515..1.685, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move xst left by 0.13 um (or move the other shape the opposite way)
    li.c2: xst [li] vs an2 (line 58) [li x 1.515..1.685, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gn2 (line 19: `gn2  = cross [nd, pd] poly w=L left=(nd.left + 0.265)`) - in 7 of 17 errors: li.3 x4, li.c2 x3
    gn2 spans x 1.525..1.675, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 14: `nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap`) - in 4 of 17 errors: li.3 x2, li.c2 x2
    nd spans x 1.260..3.340, y 0.415..0.905 um
    its position uses ndw (line 13: `ndw  = 3*L + 2*0.265 + 2*gapg`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.