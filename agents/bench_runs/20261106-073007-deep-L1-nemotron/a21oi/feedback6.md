Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 11 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* dpy (line 34: `dpy = array licon in=pd right_of=gb1 net=Y`) and shapes built from it (dpyl) - in 7 of 11 errors: poly.7 x5, licon.5a x2
    dpy spans x 1.840..2.010, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* pd (line 17: `pd  = rect diff w=dnw h=WP cx=cell.cx below=ntap`) - in 7 of 11 errors: poly.7 x5, licon.5a x2
    pd spans x 0.270..2.030, y 1.555..2.305 um
    its position uses dnw (line 15: `dnw = 0.265 + L + 0.39 + L + 0.39 + L + 0.265`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* gnd2 (line 46: `gnd2= strap li from=sn2l to=vgnd_li`) - in 4 of 11 errors: poly.7 x3, licon.5a x1
    gnd2 spans x 1.840..2.010, y -0.085..0.825 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* nd (line 16: `nd  = rect diff w=dnw h=WN cx=cell.cx above=ptap`) - in 4 of 11 errors: poly.7 x3, licon.5a x1
    nd spans x 0.270..2.030, y 0.415..0.905 um
    its position uses dnw (line 15: `dnw = 0.265 + L + 0.39 + L + 0.39 + L + 0.265`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (11) than your best so far (4); your best version is saved as /best.icl.