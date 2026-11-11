Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 14 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 32: `pd1 = rect diff xspan=(gA2.left - 0.265, gA1.right + 0.265) yspan=(py1 - WP, py1)`) and shapes built from it (pim) - in 14 of 14 errors: diff/tap.8 x14
    pd1 spans x 0.030..1.250, y 1.555..2.305 um
    its position uses py1 (line 14: `py1 = ntap.bottom - 0.27`)
* nwell (line 73: `well y=((nd.top + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)`) - in 14 of 14 errors: diff/tap.8 x14
    nwell spans x 0.000..2.760, y 1.310..3.045 um
* cpY1 (line 48: `cpY1 = array licon in=pd1 left_of=gA2`) and shapes built from it (cpY1_l) - in 7 of 14 errors: diff/tap.8 x7
    cpY1 spans x 0.070..0.240, y 1.675..2.185 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.