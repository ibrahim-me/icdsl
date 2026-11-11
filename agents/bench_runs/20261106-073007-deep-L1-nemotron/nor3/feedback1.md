Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 34 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 2 separate pieces: [dn1l (line 32), nd (line 16)] | [dn3l (line 34), dp3l (line 44), nd (line 16), pd (line 17), +2 more] - join them (strap / shared metal / `route Y`)
DRC root causes (ranked; by the statements in your file):
* gcc (line 58: `gcc = contact licon cx=(gc.cx - 0.1) bottom=cb`) and shapes built from it (c, cm, cp, gpc) - in 19 of 34 errors: met1.2 x10, li.3 x4, poly.2 x3, mcon.2 x2
    gcc spans x 1.505..1.675, y 1.095..1.265 um
    mcon.2: cm [mcon] vs ym (line 81) [mcon x 1.820..1.990, y 1.295..1.465]: gap 0.145 um, rule needs >= 0.19 um (short by 0.045 um)
    one fix: move gcc down by 0.05 um - line 58: `bottom=cb` -> `bottom=(cb - 0.05)` (or move the other shape the opposite way)
    li.3: c [li] vs y (line 52) [li x 1.820..1.990, y 0.495..2.265]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    met1.2: cp [m1] vs yp (line 82) [m1 x 1.760..2.050, y 1.235..1.525]: gap 0.025 um, rule needs >= 0.14 um (short by 0.115 um)
    its position uses cb (line 55: `cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, sn2l.top + 0.25, dn3l.top + 0.25)`)
    rule met1.2: two met1 shapes closer than 0.14 um
    rule li.3: two li shapes of different nets closer than 0.17 um
* gc (line 24: `gc = cross [nd, pd] poly w=L left=(gb.right + gap)`) - in 16 of 34 errors: met1.2 x10, li.3 x4, mcon.2 x2
    gc spans x 1.615..1.765, y 0.285..2.435 um
    its position uses gap (line 13: `gap = max(0.28, 0.54 - L)`)
    rule met1.2: two met1 shapes closer than 0.14 um
    rule li.3: two li shapes of different nets closer than 0.17 um
* y (line 52: `y = strap li from=dn3l to=dp3l net=Y`) and shapes built from it (ym, yp) - in 14 of 34 errors: li.3 x6, met1.2 x6, mcon.2 x2
    y spans x 1.820..1.990, y 0.495..2.265 um
    mcon.2: ym [mcon] vs cm (line 77) [mcon x 1.505..1.675, y 1.095..1.265]: gap 0.145 um, rule needs >= 0.19 um (short by 0.045 um)
    one fix: move y up by 0.05 um (or move the other shape the opposite way)
    li.3: y [li] vs c (line 67) [li x 1.505..1.675, y 1.015..1.345]: gap 0.145 um, rule needs >= 0.17 um (short by 0.025 um)
    met1.2: yp [m1] vs cp (line 78) [m1 x 1.445..1.735, y 1.035..1.325]: gap 0.025 um, rule needs >= 0.14 um (short by 0.115 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule met1.2: two met1 shapes closer than 0.14 um
* gcb (line 57: `gcb = contact licon cx=(gb.cx - 0.1) bottom=cb`) and shapes built from it (bp, gpb) - in 4 of 34 errors: poly.2 x4
    gcb spans x 0.965..1.135, y 1.095..1.265 um
    poly.2: gpb [poly] vs ga (line 22) [poly x 0.535..0.685, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move gcb right by 0.01 um - line 57: `cx=(gb.cx - 0.1)` -> `cx=(gb.cx - 0.1 + 0.01)` (or move the other shape the opposite way)
    its position uses cb (line 55: `cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, sn2l.top + 0.25, dn3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING nor3: port C: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING nor3: port Y: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.