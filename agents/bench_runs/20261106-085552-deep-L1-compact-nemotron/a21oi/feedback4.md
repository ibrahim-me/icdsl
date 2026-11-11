Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 6 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 20: `pd1 = rect diff xspan=(x0, x0 + span) yspan=(py1 - WP, py1)`) - in 4 of 6 errors: licon.5a x4
    pd1 spans x 0.275..2.025, y 1.555..2.305 um
    its position uses span (line 17: `span = 2*end + 3*L + gap_n1 + gap_y`)
    its position uses x0 (line 18: `x0 = cell.cx - span/2`)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* pn2l (line 38: `pn2l = array licon in=pd1 left_of=g1`) and shapes built from it (pn2ll) - in 2 of 6 errors: licon.5a x2
    pn2l spans x 0.310..0.480, y 1.675..2.185 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* py (line 41: `py   = array licon in=pd1 right_of=g3`) and shapes built from it (pyl) - in 2 of 6 errors: licon.5a x2
    py spans x 1.820..1.990, y 1.675..2.185 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* nd1 (line 19: `nd1 = rect diff xspan=(x0, x0 + span) yspan=(ny0, ny0 + WN)`) - in 2 of 6 errors: licon.5a x2
    nd1 spans x 0.275..2.025, y 0.415..0.905 um
    its position uses ny0 (line 12: `ny0 = ptap.top + 0.27`)
    its position uses span (line 17: `span = 2*end + 3*L + gap_n1 + gap_y`)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (6) than your best so far (0); your best version is saved as /best.icl.