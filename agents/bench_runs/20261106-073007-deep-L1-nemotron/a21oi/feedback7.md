Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 24 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* nwell (line 69: `well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)`) - in 24 of 24 errors: diff/tap.8 x24
    nwell spans x 0.000..2.300, y 1.310..3.045 um
* pd (line 21: `pd  = rect diff w=dnw h=WP cx=cell.cx below=ntap`) and shapes built from it (pim) - in 24 of 24 errors: diff/tap.8 x24
    pd spans x 0.050..2.250, y 1.555..2.305 um
    its position uses dnw (line 19: `dnw = 2*endm + 3*L + 2*gap`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (24) than your best so far (4); your best version is saved as /best.icl.