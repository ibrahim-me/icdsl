Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 6 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd1 (line 25: `pd1 = rect diff xspan=(g1.left - end, g3.right + end) yspan=(py1 - WP, py1)`) - in 4 of 6 errors: licon.5a x4
    pd1 spans x 0.280..2.020, y 1.555..2.305 um
    its position uses end (line 17: `end = 0.255`)
    its position uses py1 (line 13: `py1 = ntap.bottom - 0.27`)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c5 (line 39: `c5 = array licon in=pd1 left_of=g1`) and shapes built from it (c5l) - in 2 of 6 errors: licon.5a x2
    c5 spans x 0.310..0.480, y 1.675..2.185 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c5s (line 41: `c5s = strap li from=c5l to=vpwr_li`) - in 2 of 6 errors: licon.5a x2
    c5s spans x 0.310..0.480, y 1.595..2.805 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c6 (line 42: `c6 = array licon in=pd1 right_of=g3`) and shapes built from it (c6l) - in 2 of 6 errors: licon.5a x2
    c6 spans x 1.820..1.990, y 1.675..2.185 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (6) than your best so far (0); your best version is saved as /best.icl.