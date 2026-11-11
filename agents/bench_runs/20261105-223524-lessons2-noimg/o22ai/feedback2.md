Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 2 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / VPWR / Y / n1 / n2 / n3: on li around (2.3, 0.37): shapes of VGND and Y and n3 overlap/touch there (dgl (line 32), gnd (line 33), gnd2 (line 34), n3r (line 41), n3r2 (line 42), sgl (line 30), +5 more)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout - the pmos with gate A2 at x=2.215 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs Y and n1: the side labelled VGND+VPWR+Y+n1+n2+n3 should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A1 d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate A1 at x=1.675 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n1 and VPWR: the side labelled VGND+VPWR+Y+n1+n2+n3 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout - the nmos with gate A2 at x=2.215 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n3 and VGND: the side labelled VGND+VPWR+Y+n1+n2+n3 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=3.165 has ?3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs n3 and Y: the side labelled ?3 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout - the pmos with gate B1 at x=3.165 has ?7 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs VPWR and n2: the side labelled ?7 should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=1.675 has VGND+VPWR+Y+n1+n2+n3 and VGND+VPWR+Y+n1+n2+n3 on its sides; it needs VGND and n3: the side labelled VGND+VPWR+Y+n1+n2+n3 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.675 y=0.66: gate A1 [ga1 (line 21), gpa (line 69)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more]
    layout nmos at x=2.215 y=0.66: gate A2 [ga2 (line 22), gpb (line 70)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more]
    layout nmos at x=3.165 y=0.66: gate B1 [gb1 (line 23), gpc (line 71)], source/drain ?3 [nd (line 15)], VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.675 y=1.93: gate A1 [ga1 (line 21), gpa (line 69)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more]
    layout pmos at x=2.215 y=1.93: gate A2 [ga2 (line 22), gpb (line 70)], source/drain VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more], VGND+VPWR+Y+n1+n2+n3 [dgl (line 32), gnd (line 33), gnd2 (line 34), +20 more]
DRC root causes (ranked; by the statements in your file):
* pd (line 16: `pd  = rect diff w=dw h=WP cx=cell.cx below=ntap`) - in 1 of 2 errors: poly.7 x1
    pd spans x 1.335..3.265, y 1.555..2.305 um
    its position uses dw (line 14: `dw  = 4*L + 2*0.265 + 0.80`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* yst2 (line 61: `yst2= strap li from=sy1l to=sy2l net=Y`) - in 1 of 2 errors: poly.7 x1
    yst2 spans x 2.345..4.005, y 1.845..2.015 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* n2r (line 60: `n2r = strap li from=sn1l to=sn2l net=n2`) - in 1 of 2 errors: poly.7 x1
    n2r spans x 1.860..3.520, y 1.845..2.015 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
* sn2 (line 54: `sn2 = array licon in=pd between=[gb1, gb2] net=n2`) and shapes built from it (sn2l) - in 1 of 2 errors: poly.7 x1
    sn2 spans x 3.350..3.520, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.