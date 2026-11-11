Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT X / n1: joined through contacts/vias: X: cn2l (line 25), cp2l (line 37), xp (line 62), +1 more; n1: cn1l (line 24), cp1l (line 36), nn (line 53), route n1
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate A at x=0.67 has VPWR and X+n1 on its sides; it needs n1 and VPWR: the side labelled X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout - the nmos with gate A at x=0.67 has VGND and X+n1 on its sides; it needs n1 and VGND: the side labelled X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=0.67 y=0.625: gate A [ga (line 15), gpa (line 49)], source/drain VGND [cn0l (line 23), cn3l (line 26), gnd0 (line 27), +2 more], X+n1 [cn1l (line 24), cn2l (line 25), cp1l (line 36), +5 more]
    layout nmos at x=2.09 y=0.625: gate X+n1 [gn (line 16), gpn (line 50)], source/drain VGND [cn0l (line 23), cn3l (line 26), gnd0 (line 27), +2 more], X+n1 [cn1l (line 24), cn2l (line 25), cp1l (line 36), +5 more]
    layout pmos at x=0.67 y=2.01: gate A [ga (line 15), gpa (line 49)], source/drain VPWR [cp0l (line 35), cp3l (line 38), pd (line 12), +2 more], X+n1 [cn1l (line 24), cn2l (line 25), cp1l (line 36), +5 more]
    layout pmos at x=2.09 y=2.01: gate X+n1 [gn (line 16), gpn (line 50)], source/drain VPWR [cp0l (line 35), cp3l (line 38), pd (line 12), +2 more], X+n1 [cn1l (line 24), cn2l (line 25), cp1l (line 36), +5 more]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.