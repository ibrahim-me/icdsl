Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 7 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 81: net 'n1': pin n1 has no legal access point (blocked by bp on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT B / n1: joined through contacts/vias: B: b (line 63), bp (line 72); n1: n1 (line 64)
  OPEN net n1 is 3 separate pieces: [cn1l (line 37), nd (line 16)] | [cpnl (line 42), pd (line 17)] | [b (line 63), bp (line 72), gb (line 22), gn (line 23), +3 more] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M3 (pmos g=B d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M4 (nmos g=B d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M5 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.47 y=0.66: gate B+n1 [gb (line 22), gn (line 23), +2 more], source/drain ?13 [cn2l (line 38), nd (line 16)], VGND [cvnl (line 39), gnd (line 47), nd (line 16)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=2.01 y=0.66: gate B+n1 [gb (line 22), gn (line 23), +2 more], source/drain VGND [cvnl (line 39), gnd (line 47), nd (line 16)], X [cpxl (line 44), cxl (line 40), nd (line 16), +2 more]
    layout pmos at x=1.47 y=1.93: gate B+n1 [gb (line 22), gn (line 23), +2 more], source/drain VPWR [cpw2l (line 43), cpwl (line 41), pd (line 17), +2 more], n1 [cpnl (line 42), pd (line 17)]
    layout pmos at x=2.01 y=1.93: gate B+n1 [gb (line 22), gn (line 23), +2 more], source/drain VPWR [cpw2l (line 43), cpwl (line 41), pd (line 17), +2 more], X [cpxl (line 44), cxl (line 40), nd (line 16), +2 more]
DRC root causes (ranked; by the statements in your file):
* gcn (line 55: `gcn = contact licon cx=(gn.cx - 0.13) bottom=cb     # shift away from output strap on the right`) and shapes built from it (gpn, n1) - in 4 of 7 errors: li.3 x3, licon.2 x1
    gcn spans x 1.795..1.965, y 1.095..1.265 um
    li.3: n1 [li] vs b (line 63) [li x 1.485..1.655, y 1.015..1.345]: gap 0.140 um, rule needs >= 0.17 um (short by 0.030 um)
    one fix: move gcn right by 0.03 um - line 55: `cx=(gn.cx - 0.13)` -> `cx=(gn.cx - 0.13 + 0.03)` (or move the other shape the opposite way)
    licon.2: gcn [licon] vs gn (line 23) [poly x 1.935..2.085, y 0.285..2.435]: they overlap by 0.030 um, rule needs >= 0.17 um (short by 0.200 um)
    its position uses cb (line 52: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.2: two licons closer than 0.17 um
* gcb (line 54: `gcb = contact licon cx=(gb.cx + 0.1) bottom=cb`) and shapes built from it (b, bm, bp, gpb) - in 3 of 7 errors: li.3 x3
    gcb spans x 1.485..1.655, y 1.095..1.265 um
    li.3: b [li] vs n1 (line 64) [li x 1.795..1.965, y 1.015..1.345]: gap 0.140 um, rule needs >= 0.17 um (short by 0.030 um)
    one fix: move gcb left by 0.03 um - line 54: `cx=(gb.cx + 0.1)` -> `cx=(gb.cx + 0.1 - 0.03)` (or move the other shape the opposite way)
    its position uses cb (line 52: `cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.