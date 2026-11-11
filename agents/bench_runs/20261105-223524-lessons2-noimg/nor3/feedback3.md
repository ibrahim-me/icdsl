Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 15 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* pd (line 15: `pd = rect diff w=dw h=WP cx=cell.cx below=ntap`) - in 10 of 15 errors: poly.7 x5, licon.1 x3, licon.5a x2
    pd spans x 0.270..2.030, y 1.555..2.305 um
    its position uses dw (line 13: `dw = 1.61 + L`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* yp (line 40: `yp  = array licon in=pd right_of=gc net=Y`) and shapes built from it (yp3, ypl) - in 10 of 15 errors: poly.7 x5, licon.1 x3, licon.5a x2
    yp spans x 1.895..2.065, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* nd (line 14: `nd = rect diff w=dw h=WN cx=cell.cx above=ptap`) - in 5 of 15 errors: poly.7 x3, licon.1 x1, licon.5a x1
    nd spans x 0.270..2.030, y 0.415..0.905 um
    its position uses dw (line 13: `dw = 1.61 + L`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* y2 (line 28: `y2  = array licon in=nd right_of=gc net=Y`) and shapes built from it (y2l, ym2, yp2) - in 5 of 15 errors: poly.7 x3, licon.1 x1, licon.5a x1
    y2 spans x 1.895..2.065, y 0.575..0.745 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.