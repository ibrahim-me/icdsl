Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 3 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / VPWR / Y / n1 / n2 / n3: on li around (2.3, 0.37): shapes of VGND and Y and n3 overlap/touch there (dgl (line 30), gnd (line 31), gnd2 (line 32), n3r (line 40), sgl (line 29), sn3bl (line 37), +4 more)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout - the pmos with gate A2 at x=2.07 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs Y and n1: the side labelled VGND+VPWR+Y+n1+n2+n3 should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A1 d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate A1 at x=1.53 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n1 and VPWR: the side labelled VGND+VPWR+Y+n1+n2+n3 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout - the nmos with gate A2 at x=2.07 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n3 and VGND: the side labelled VGND+VPWR+Y+n1+n2+n3 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=3.02 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n3 and Y: the side labelled VGND+VPWR+Y+n1+n2+n3 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout - the pmos with gate B1 at x=3.02 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs VPWR and n2: the side labelled VGND+VPWR+Y+n1+n2+n3 should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=1.53 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs VGND and n3: the side labelled VGND+VPWR+Y+n1+n2+n3 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.53 y=0.66: gate A1 [ga1 (line 19), gpa (line 65)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more]
    layout nmos at x=2.07 y=0.66: gate A2 [ga2 (line 20), gpb (line 66)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more]
    layout nmos at x=3.02 y=0.66: gate B1 [gb1 (line 21), gpc (line 67)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more]
    layout pmos at x=1.53 y=1.93: gate A1 [ga1 (line 19), gpa (line 65)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more]
    layout pmos at x=2.07 y=1.93: gate A2 [ga2 (line 20), gpb (line 66)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 30), gnd (line 31), gnd2 (line 32), +18 more]
DRC root causes (ranked; by the statements in your file):
* pd (line 15: `pd  = rect diff w=(4*L + 2*0.81) h=WP cx=cell.cx below=ntap`) - in 2 of 3 errors: licon.5a x2
    pd spans x 1.190..3.410, y 1.555..2.305 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* n2r (line 57: `n2r = strap li from=sn1l to=sn2l net=n2`) - in 2 of 3 errors: licon.5a x2
    n2r spans x 1.715..3.375, y 1.845..2.015 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* sn2 (line 51: `sn2 = array licon in=pd between=[gb1, gb2] net=n2`) and shapes built from it (sn2l) - in 2 of 3 errors: licon.5a x2
    sn2 spans x 3.205..3.375, y 1.675..2.185 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* nd (line 14: `nd  = rect diff w=(4*L + 2*0.81) h=WN cx=cell.cx above=ptap`) - in 1 of 3 errors: licon.5a x1
    nd spans x 1.190..3.410, y 0.415..0.905 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.