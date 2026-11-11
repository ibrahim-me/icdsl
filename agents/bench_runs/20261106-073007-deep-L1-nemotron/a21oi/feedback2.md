Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 7 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* dn2r (line 40: `dn2r= array licon in=pdr left_of=gb1 net=n2`) and shapes built from it (dn2rl) - in 7 of 7 errors: diff/tap.3 x7
    dn2r spans x 2.150..2.320, y 1.675..2.185 um
    rule diff/tap.3: two diffusions closer than 0.27 um
* pdr (line 20: `pdr = rect diff w=(0.265 + L + 0.265) h=WP cx=(cell.cx + (0.265 + L + 0.80) / 2) below=ntap`) - in 7 of 7 errors: diff/tap.3 x7
    pdr spans x 2.110..2.790, y 1.555..2.305 um
    rule diff/tap.3: two diffusions closer than 0.27 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.