Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 82 errors, LVS MISMATCH)
LVS mismatch (netgen): Netlists do not match.
  layout/reference devices [6, 6], nets [8, 7]
DRC root causes (ranked; by the statements in your file):
* gc2 (line 69: `gc2 = contact licon cx=g2.cx bottom=(cb + 0.25)`) and shapes built from it (bm, bp, gl2, gp2) - in 60 of 82 errors: licon.14 x13, licon.9 x13, poly.7 x10, li.3 x6
    gc2 spans x 1.550..1.720, y 1.345..1.515 um
    li.3: gl2 [li] vs c6l (line 53) [li x 1.765..1.935, y 1.595..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc2 down by 0.13 um - line 69: `bottom=(cb + 0.25)` -> `bottom=(cb + 0.25 - 0.13)` (or move the other shape the opposite way)
    met1.2: bp [m1] vs ap (line 81) [m1 x 1.080..1.370, y 1.035..1.325]: gap 0.120 um, rule needs >= 0.14 um (short by 0.020 um)
    licon.14: gc2 [licon] vs pd1 (line 27) [diff x 0.755..1.975, y 1.555..2.305]: gap 0.040 um, rule needs >= 0.19 um (short by 0.150 um)
    its position uses cb (line 64: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
* pd1 (line 27: `pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)`) and shapes built from it (pim) - in 57 of 82 errors: licon.14 x17, licon.9 x17, li.3 x6, poly.7 x6
    pd1 spans x 0.755..1.975, y 1.555..2.305 um
    licon.14: pd1 [diff] vs c6 (line 52) [licon x 1.765..1.935, y 1.675..2.185]: they overlap by 0.210 um, rule needs >= 0.19 um (short by 0.400 um)
    one fix: move pd1 left by 0.4 um (or move the other shape the opposite way)
    licon.14: pd1 [diff] vs gc2 (line 69) [licon x 1.550..1.720, y 1.345..1.515]: gap 0.040 um, rule needs >= 0.19 um (short by 0.150 um)
    licon.9: pd1 [diff] vs c6 (line 52) [licon x 1.765..1.935, y 1.675..2.185]: they overlap by 0.210 um, rule needs >= 0.235 um (short by 0.445 um)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
* g2 (line 20: `g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B`) - in 55 of 82 errors: licon.14 x13, licon.9 x13, poly.7 x8, poly.2 x6
    g2 spans x 1.560..1.710, y 0.285..2.435 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
* gc1 (line 66: `gc1 = contact licon cx=(g1.cx + 0.13) bottom=cb`) and shapes built from it (ap, gl1, gn, gp1) - in 18 of 82 errors: licon.9 x13, met1.2 x4, poly.7 x1
    gc1 spans x 1.140..1.310, y 1.095..1.265 um
    met1.2: ap [m1] vs bp (line 84) [m1 x 1.490..1.780, y 1.285..1.575]: gap 0.120 um, rule needs >= 0.14 um (short by 0.020 um)
    one fix: move gc1 left by 0.02 um - line 66: `cx=(g1.cx + 0.13)` -> `cx=(g1.cx + 0.13 - 0.02)` (or move the other shape the opposite way)
    poly.2: gp1 [poly] vs gp2 (line 70) [poly x 1.470..1.800, y 1.295..1.565]: gap 0.080 um, rule needs >= 0.21 um (short by 0.130 um)
    its position uses cb (line 64: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,`)
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
    rule met1.2: two met1 shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (5082) than your best so far (5011); your best version is saved as /best.icl.