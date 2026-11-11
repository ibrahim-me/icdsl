Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 10 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [cn1l (line 27), nd (line 12)] | [gn (line 20), gpn (line 52), nl (line 56)] | [cpnl (line 39)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=VPWR s=n1) has no matching transistor in the layout
  DEVICE M2 (nmos g=A d=n1 s=n2) has no matching transistor in the layout
  DEVICE M3 (pmos g=B d=VPWR s=n1) has no matching transistor in the layout
  DEVICE M4 (nmos g=B d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M5 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
DRC root causes (ranked; by the statements in your file):
* gndp (line 61: `gndp = strap li from=cp1l to=vpwr_li`) - in 4 of 10 errors: licon.1 x2, licon.5a x2
    gndp spans x 2.265..2.435, y 1.595..2.805 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* pd (line 13: `pd  = rect diff w=min h=WP cx=cell.cx below=ntap`) - in 4 of 10 errors: licon.1 x2, licon.5a x2
    pd spans x 2.225..2.375, y 1.555..2.305 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* cp1 (line 34: `cp1 = array licon in=pd left_of=ga`) and shapes built from it (cp1l) - in 4 of 10 errors: licon.1 x2, licon.5a x2
    cp1 spans x 2.265..2.435, y 1.675..2.185 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* pwr1 (line 42: `pwr1 = strap li from=cp1l to=vpwr_li`) - in 4 of 10 errors: licon.1 x2, licon.5a x2
    pwr1 spans x 2.265..2.435, y 1.595..2.805 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.