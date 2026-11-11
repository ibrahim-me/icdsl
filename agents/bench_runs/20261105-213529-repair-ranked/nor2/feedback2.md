Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 1 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* c1 (line 23: `c1 = array licon in=nd1 left_of=g1`) and shapes built from it (c1l) - in 1 of 1 errors: licon.5a x1
    c1 spans x 0.580..0.750, y 0.575..0.745 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c1s (line 25: `c1s = strap li from=c1l to=vgnd_li`) - in 1 of 1 errors: licon.5a x1
    c1s spans x 0.580..0.750, y -0.085..0.825 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* nd1 (line 17: `nd1 = rect diff xspan=(x0 + 0.015, x0 + span) yspan=(ny0, ny0 + WN)`) - in 1 of 1 errors: licon.5a x1
    nd1 spans x 0.555..1.760, y 0.415..0.905 um
    its position uses ny0 (line 13: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses span (line 15: `span = 0.53 + 2*L + max(0.28, 0.54 - L)`)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.