Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}: VIOLATIONS  (DRC 34 errors, LVS MISMATCH)
LVS mismatch (netgen): Netlists do not match.
  layout/reference devices [6, 6], nets [12, 10]
DRC root causes (ranked; by the statements in your file):
* p3 (line 39: `p3 = rect poly xspan=(x2 - 0.315, x2 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)`) - in 9 of 34 errors: poly.2 x5, li.5 x4
    p3 spans x 0.830..1.295, y 0.995..1.325 um
    poly.2: p3 [poly] vs p1 (line 37) [poly x 0.290..0.755, y 0.995..1.325]: gap 0.075 um, rule needs >= 0.21 um (short by 0.135 um)
    one fix: move p3 right by 0.14 um (or move the other shape the opposite way)
    poly.2: p3 [poly] vs p5 (line 41) [poly x 1.370..1.835, y 0.995..1.325]: gap 0.075 um, rule needs >= 0.21 um (short by 0.135 um)
    its position uses nb (line 16: `nb = 0.235                          # bottom of the n row`)
    its position uses pt (line 17: `pt = H - 0.235                     # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* lg2 (line 57: `lg2 = rect li xspan=(x2 - 0.315, x2 + 0.005) yspan=(nb + WN + 0.19, pt - WP - 0.17) net=A1`) - in 9 of 34 errors: poly.2 x5, li.5 x4
    lg2 spans x 0.830..1.150, y 1.075..1.315 um
    its position uses nb (line 16: `nb = 0.235                          # bottom of the n row`)
    its position uses pt (line 17: `pt = H - 0.235                     # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* pd1 (line 31: `pd1 = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)`) - in 8 of 34 errors: poly.2 x4, li.3 x3, li.c2 x1
    pd1 spans x 0.340..2.100, y 1.485..2.485 um
    its position uses pt (line 17: `pt = H - 0.235                     # top of the p row`)
    its position uses x3 (line 15: `x3 = x2 + L + max(0.28, 0.54 - L)   # gate A2`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* p5 (line 41: `p5 = rect poly xspan=(x3 - 0.315, x3 + L) yspan=(nb + WN + 0.11, pt - WP - 0.16)`) - in 8 of 34 errors: li.5 x4, poly.2 x4
    p5 spans x 1.370..1.835, y 0.995..1.325 um
    poly.2: p5 [poly] vs p3 (line 39) [poly x 0.830..1.295, y 0.995..1.325]: gap 0.075 um, rule needs >= 0.21 um (short by 0.135 um)
    one fix: move p5 right by 0.14 um (or move the other shape the opposite way)
    its position uses nb (line 16: `nb = 0.235                          # bottom of the n row`)
    its position uses pt (line 17: `pt = H - 0.235                     # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.