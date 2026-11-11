Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 30 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* g2 (line 20: `g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B`) - in 24 of 30 errors: poly.2 x12, licon.11 x5, met1.2 x4, diff/tap.2 x2
    g2 spans x 1.140..1.290, y 0.285..2.435 um
    poly.2: g2 [poly] vs g1 (line 19) [poly x 0.790..0.940, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move g2 right by 0.01 um - line 20: `left=(g1.right + 0.2)` -> `left=(g1.right + 0.2 + 0.01)` (or move the other shape the opposite way)
    licon.11: g2 [poly] vs c2 (line 31) [licon x 0.995..1.165, y 0.540..0.710]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
* gc2 (line 55: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (bm, bp, gl2, gp2) - in 12 of 30 errors: poly.2 x7, met1.2 x4, mcon.2 x1
    gc2 spans x 1.130..1.300, y 1.095..1.265 um
    mcon.2: bm [mcon] vs am (line 63) [mcon x 0.780..0.950, y 1.095..1.265]: gap 0.180 um, rule needs >= 0.19 um (short by 0.010 um)
    one fix: move gc2 right by 0.01 um - line 55: `cx=g2.cx` -> `cx=(g2.cx + 0.01)` (or move the other shape the opposite way)
    met1.2: bp [m1] vs ap (line 64) [m1 x 0.720..1.010, y 1.035..1.325]: gap 0.060 um, rule needs >= 0.14 um (short by 0.080 um)
    poly.2: gp2 [poly] vs gp1 (line 53) [poly x 0.700..1.030, y 1.045..1.315]: gap 0.020 um, rule needs >= 0.21 um (short by 0.190 um)
    its position uses cb (line 51: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule met1.2: two met1 shapes closer than 0.14 um
* nd1 (line 22: `nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)`) - in 11 of 30 errors: licon.11 x5, poly.2 x4, diff/tap.2 x2
    nd1 spans x 0.525..1.555, y 0.415..0.835 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc1 (line 52: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (am, ap, gl1, gp1) - in 9 of 30 errors: met1.2 x4, poly.2 x4, mcon.2 x1
    gc1 spans x 0.780..0.950, y 1.095..1.265 um
    mcon.2: am [mcon] vs bm (line 66) [mcon x 1.130..1.300, y 1.095..1.265]: gap 0.180 um, rule needs >= 0.19 um (short by 0.010 um)
    one fix: move gc1 left by 0.01 um - line 52: `cx=g1.cx` -> `cx=(g1.cx - 0.01)` (or move the other shape the opposite way)
    met1.2: ap [m1] vs bp (line 67) [m1 x 1.070..1.360, y 1.035..1.325]: gap 0.060 um, rule needs >= 0.14 um (short by 0.080 um)
    poly.2: gp1 [poly] vs gp2 (line 56) [poly x 1.050..1.380, y 1.045..1.315]: gap 0.020 um, rule needs >= 0.21 um (short by 0.190 um)
    its position uses cb (line 51: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule met1.2: two met1 shapes closer than 0.14 um
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING or2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING or2: port B: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.