Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 8 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 65: net 'n1': pin nn has no legal access point (blocked by xp on m1: 0.020 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [nd (line 14), sn1l (line 31)] | [pd (line 15), spnl (line 41)] | [gn (line 19), gpn (line 51), nn (line 55)] - join them (strap / shared metal / `route n1`)
DRC root causes (ranked; by the statements in your file):
* gb (line 20: `gb  = cross [nd, pd] poly w=L left=(gn.right + gap)    # gate B`) - in 4 of 8 errors: poly.2 x4
    gb spans x 2.225..2.375, y 0.285..2.435 um
    poly.2: gb [poly] vs gpn (line 51) [poly x 1.725..2.055, y 1.045..1.315]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move gb right by 0.04 um - line 20: `left=(gn.right + gap)` -> `left=(gn.right + gap + 0.04)` (or move the other shape the opposite way)
    its position uses gap (line 12: `gap = max(0.28, 0.54 - L)          # gate pitch = L + gap >= 0.54 (gate-contact pads clear)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcb (line 49: `gcb = contact licon cx=(gb.cx + 0.13) bottom=cb`) and shapes built from it (bp, gpb) - in 4 of 8 errors: poly.2 x4
    gcb spans x 2.345..2.515, y 1.095..1.265 um
    poly.2: gpb [poly] vs ga (line 21) [poly x 2.765..2.915, y 0.285..2.435]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move gcb left by 0.04 um - line 49: `cx=(gb.cx + 0.13)` -> `cx=(gb.cx + 0.13 - 0.04)` (or move the other shape the opposite way)
    its position uses cb (line 47: `cb = max(nd.top + 0.19, sn1l.top + 0.25, sn2l.top + 0.25, svnl.top + 0.25, sxnl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* ga (line 21: `ga  = cross [nd, pd] poly w=L left=(gb.right + gap)    # gate A`) - in 4 of 8 errors: poly.2 x4
    ga spans x 2.765..2.915, y 0.285..2.435 um
    poly.2: ga [poly] vs gpb (line 52) [poly x 2.265..2.595, y 1.045..1.315]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move ga right by 0.04 um - line 21: `left=(gb.right + gap)` -> `left=(gb.right + gap + 0.04)` (or move the other shape the opposite way)
    its position uses gap (line 12: `gap = max(0.28, 0.54 - L)          # gate pitch = L + gap >= 0.54 (gate-contact pads clear)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca (line 50: `gca = contact licon cx=(ga.cx + 0.13) bottom=cb`) and shapes built from it (ap, gpa) - in 4 of 8 errors: poly.2 x4
    gca spans x 2.885..3.055, y 1.095..1.265 um
    its position uses cb (line 47: `cb = max(nd.top + 0.19, sn1l.top + 0.25, sn2l.top + 0.25, svnl.top + 0.25, sxnl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.