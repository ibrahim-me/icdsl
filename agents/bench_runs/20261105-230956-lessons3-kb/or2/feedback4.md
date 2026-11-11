Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 22 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* yst (line 48: `yst  = strap li from=cxnl to=cxpl net=X`) - in 17 of 22 errors: li.3 x10, li.c2 x7
    yst spans x 1.200..1.370, y 0.495..2.265 um
    li.3: yst [li] vs nl2 (line 59) [li x 1.385..1.555, y 1.015..1.345]: gap 0.015 um, rule needs >= 0.17 um (short by 0.155 um)
    one fix: move yst left by 0.16 um (or move the other shape the opposite way)
    li.c2: yst [li] vs nl2 (line 59) [li x 1.385..1.555, y 1.015..1.345]: gap 0.015 um, rule needs >= 0.14 um (short by 0.125 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gcn (line 52: `gcn = contact licon cx=(gn.cx - 0.03) bottom=cb   # gate n2 contact, clear of output strap`) and shapes built from it (gnn, nl2) - in 17 of 22 errors: li.3 x10, li.c2 x7
    gcn spans x 1.385..1.555, y 1.095..1.265 um
    li.3: nl2 [li] vs yst (line 48) [li x 1.200..1.370, y 0.495..2.265]: gap 0.015 um, rule needs >= 0.17 um (short by 0.155 um)
    one fix: move gcn right by 0.16 um - line 52: `cx=(gn.cx - 0.03)` -> `cx=(gn.cx - 0.03 + 0.16)` (or move the other shape the opposite way)
    li.c2: nl2 [li] vs yst (line 48) [li x 1.200..1.370, y 0.495..2.265]: gap 0.015 um, rule needs >= 0.14 um (short by 0.125 um)
    its position uses cb (line 51: `cb = max(nd.top + 0.19, cxnl.top + 0.25, cvn0l.top + 0.25, cnnl.top + 0.25, cvn1l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* nd (line 14: `nd  = rect diff w=dw h=WN cx=cell.cx above=ptap`) - in 8 of 22 errors: via.1a x3, li.3 x2, li.c2 x2, met1.1 x1
    nd spans x 1.160..2.980, y 0.415..0.905 um
    its position uses dw (line 13: `dw  = 3*L + 2*p + 2*0.265`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gn (line 20: `gn = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate n2`) - in 7 of 22 errors: li.3 x4, li.c2 x3
    gn spans x 1.425..1.575, y 0.285..2.435 um
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.