Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 14 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 82: net 'n1': pin n1 has no legal access point (blocked by bp on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [cn1l (line 37), nd (line 16)] | [cpnl (line 42), pd (line 17)] | [gn (line 23), gpn (line 59), n1 (line 65)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* gcn (line 56: `gcn = contact licon cx=(gn.cx - 0.1) bottom=cb     # shift left, away from output strap on right`) and shapes built from it (gpn, n1) - in 8 of 14 errors: poly.2 x5, li.3 x3
    gcn spans x 1.825..1.995, y 1.095..1.265 um
    li.3: n1 [li] vs yx (line 76) [li x 2.140..2.310, y 0.495..2.265]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    one fix: move gcn left by 0.03 um - line 56: `cx=(gn.cx - 0.1)` -> `cx=(gn.cx - 0.1 - 0.03)` (or move the other shape the opposite way)
    poly.2: gpn [poly] vs gpb (line 58) [poly x 1.405..1.735, y 1.045..1.315]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    its position uses cb (line 53: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* gn (line 23: `gn = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))   # gate n1`) - in 7 of 14 errors: poly.2 x4, li.3 x3
    gn spans x 1.935..2.085, y 0.285..2.435 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* yx (line 76: `yx = strap li from=cxl to=cpxl net=X`) and shapes built from it (xp) - in 5 of 14 errors: li.3 x5
    yx spans x 2.140..2.310, y 0.495..2.265 um
    li.3: yx [li] vs n1 (line 65) [li x 1.825..1.995, y 1.015..1.345]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    one fix: move yx right by 0.03 um (or move the other shape the opposite way)
    rule li.3: two li shapes of different nets closer than 0.17 um
* gcb (line 55: `gcb = contact licon cx=(gb.cx + 0.1) bottom=cb`) and shapes built from it (b, bp, gpb) - in 4 of 14 errors: poly.2 x4
    gcb spans x 1.485..1.655, y 1.095..1.265 um
    poly.2: gpb [poly] vs gpn (line 59) [poly x 1.745..2.075, y 1.045..1.315]: gap 0.010 um, rule needs >= 0.21 um (short by 0.200 um)
    one fix: move gcb left by 0.2 um - line 55: `cx=(gb.cx + 0.1)` -> `cx=(gb.cx + 0.1 - 0.2)` (or move the other shape the opposite way)
    its position uses cb (line 53: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (5014) than your best so far (5007); your best version is saved as /best.icl.