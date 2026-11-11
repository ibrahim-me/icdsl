Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 19 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd (line 17: `pd  = rect diff w=pdw h=WP cx=cell.cx below=ntap`) - in 19 of 19 errors: poly.7 x10, licon.1 x5, licon.5a x4
    pd spans x 0.610..2.150, y 1.555..2.305 um
    its position uses pdw (line 14: `pdw = 0.53 + 3*L + 2*0.28          # p-row: VPWR | A | Y | B | VPWR | C | Y`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* s3 (line 36: `s3  = array licon in=pd right_of=gcg          # Y`) and shapes built from it (s3l) - in 10 of 19 errors: poly.7 x5, licon.1 x3, licon.5a x2
    s3 spans x 2.050..2.220, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* p1 (line 41: `p1  = strap li from=s1l to=vpwr_li`) - in 9 of 19 errors: poly.7 x5, licon.1 x2, licon.5a x2
    p1 spans x 0.540..0.710, y 1.595..2.805 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* s1 (line 33: `s1  = array licon in=pd left_of=ga            # VPWR`) and shapes built from it (s1l) - in 9 of 19 errors: poly.7 x5, licon.1 x2, licon.5a x2
    s1 spans x 0.540..0.710, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.