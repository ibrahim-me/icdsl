Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 17 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* g3 (line 24: `g3 = rect poly w=L left=(g2.right + 0.28) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1`) - in 7 of 17 errors: poly.2 x5, poly.4 x2
    g3 spans x 1.965..2.115, y 0.285..2.435 um
    poly.4: g3 [poly] vs pd2 (line 34) [diff x 1.700..2.380, y 1.785..2.305]: they overlap by 0.415 um, rule needs >= 0.075 um (short by 0.490 um)
    one fix: move g3 right by 0.49 um - line 24: `left=(g2.right + 0.28)` -> `left=(g2.right + 0.28 + 0.49)` (or move the other shape the opposite way)
    poly.4: g3 [poly] vs pd1 (line 33) [diff x 0.840..1.950, y 1.555..2.305]: gap 0.015 um, rule needs >= 0.075 um (short by 0.060 um)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
* gc2 (line 65: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (a1m, a1p, gl2, gp2) - in 6 of 17 errors: poly.2 x6
    gc2 spans x 1.525..1.695, y 1.095..1.265 um
    poly.2: gp2 [poly] vs gp1 (line 63) [poly x 1.015..1.345, y 1.045..1.315]: gap 0.100 um, rule needs >= 0.21 um (short by 0.110 um)
    one fix: move gc2 right by 0.11 um - line 65: `cx=g2.cx` -> `cx=(g2.cx + 0.11)` (or move the other shape the opposite way)
    poly.2: gp2 [poly] vs gp3 (line 69) [poly x 1.875..2.205, y 1.045..1.315]: gap 0.100 um, rule needs >= 0.21 um (short by 0.110 um)
    its position uses cb (line 61: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* g2 (line 23: `g2 = rect poly w=L left=(g1.right + 0.28) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1`) - in 6 of 17 errors: poly.2 x6
    g2 spans x 1.535..1.685, y 0.285..2.435 um
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* c6 (line 51: `c6 = array licon in=pd1 right_of=g2`) and shapes built from it (c6l) - in 5 of 17 errors: poly.4 x3, licon.2 x2
    c6 spans x 1.740..1.910, y 1.675..2.185 um
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
    rule licon.2: two licons closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (17) than your best so far (6); your best version is saved as /best.icl.