Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 48: net 'n1': pin gl1 has no legal access point (blocked by ap on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / n1: joined through contacts/vias: A: ap (line 56); n1: gl1 (line 41)
  SHORT A / B: joined through contacts/vias: A: gl2 (line 44); B: bp (line 59)
  OPEN net A is 2 separate pieces: [ap (line 56), g1 (line 15), gl1 (line 41), gp1 (line 40)] | [bp (line 59), g2 (line 16), gl2 (line 44), gp2 (line 43)] - join them (strap / shared metal / `route A`)
  OPEN net n1 is 3 separate pieces: [cnnl (line 28), nd (line 17)] | [cppl (line 36), pd (line 18)] | [ap (line 56), g1 (line 15), gl1 (line 41), gp1 (line 40)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.11 y=0.625: gate A+n1 [g1 (line 15), gp1 (line 40)], source/drain VGND [cvnl (line 25), cvns (line 26), nd (line 17)], X [cn1l (line 23), cp1l (line 31), nd (line 17), +1 more]
    layout nmos at x=1.65 y=0.625: gate A+B [g2 (line 16), gp2 (line 43)], source/drain VGND [cvnl (line 25), cvns (line 26), nd (line 17)], n1 [cnnl (line 28), nd (line 17)]
    layout pmos at x=1.11 y=2.01: gate A+n1 [g1 (line 15), gp1 (line 40)], source/drain VPWR [cvpl (line 33), cvps (line 34), pd (line 18)], X [cn1l (line 23), cp1l (line 31), nd (line 17), +1 more]
    layout pmos at x=1.65 y=2.01: gate A+B [g2 (line 16), gp2 (line 43)], source/drain VPWR [cvpl (line 33), cvps (line 34), pd (line 18)], n1 [cppl (line 36), pd (line 18)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.