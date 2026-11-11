Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 15 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 75: net 'n2': pin c8l has no legal access point (blocked by route:Y on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT Y / n2: on li around (1.34, 0.66): shapes of Y and n2 overlap/touch there (c7l (line 42), c8l (line 47))
  SHORT A2 / B1: on m1 around (1.34, 1.18): shapes of A2 and B1 overlap/touch there (a2p (line 68), b1p (line 71))
  OPEN net n2 is 2 separate pieces: [c2l (line 31), c7l (line 42), c8l (line 47), nd1 (line 22), +2 more, route Y] | [c6l (line 40), nd1 (line 22)] - join them (strap / shared metal / `route n2`)
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout
  DEVICE M1 (pmos g=B1 d=Y s=VPWR) has no matching transistor in the layout
  DEVICE M3 (nmos g=B1 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout
    layout nmos at x=1.07 y=0.66: gate A2+B1 [g1 (line 19), g2 (line 20), +2 more], source/drain ?0 [nd1 (line 22), nd2 (line 44)], Y+n2 [c2l (line 31), c7l (line 42), c8l (line 47), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.61 y=0.66: gate A2+B1 [g1 (line 19), g2 (line 20), +2 more], source/drain VGND [c5l (line 37), c5s (line 38), c9l (line 49), +2 more], Y+n2 [c2l (line 31), c7l (line 42), c8l (line 47), +3 more]
    layout pmos at x=1.07 y=1.93: gate A2+B1 [g1 (line 19), g2 (line 20), +2 more], source/drain VPWR [c1l (line 28), c1s (line 29), c4l (line 33), +2 more], Y+n2 [c2l (line 31), c7l (line 42), c8l (line 47), +3 more]
    layout pmos at x=1.61 y=1.93: gate A2+B1 [g1 (line 19), g2 (line 20), +2 more], source/drain ?6 [pd1 (line 23)], Y+n2 [c2l (line 31), c7l (line 42), c8l (line 47), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* gc2 (line 56: `gc2 = contact licon cx=(g2.cx - 0.13) bottom=cb`) and shapes built from it (a2m, a2p, gl2, gp2) - in 7 of 15 errors: li.3 x3, mcon.2 x1, li.c2 x1, poly.2 x1
    gc2 spans x 1.395..1.565, y 1.095..1.265 um
    mcon.2: a2m [mcon] vs b1m (line 70) [mcon x 1.115..1.285, y 1.095..1.265]: gap 0.110 um, rule needs >= 0.19 um (short by 0.080 um)
    one fix: move gc2 right by 0.08 um - line 56: `cx=(g2.cx - 0.13)` -> `cx=(g2.cx - 0.13 + 0.08)` (or move the other shape the opposite way)
    li.3: gl2 [li] vs gl1 (line 55) [li x 1.115..1.285, y 1.015..1.345]: gap 0.110 um, rule needs >= 0.17 um (short by 0.060 um)
    li.c2: gl2 [li] vs gl1 (line 55) [li x 1.115..1.285, y 1.015..1.345]: gap 0.110 um, rule needs >= 0.14 um (short by 0.030 um)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* gc1 (line 53: `gc1 = contact licon cx=(g1.cx + 0.13) bottom=cb`) and shapes built from it (b1m, b1p, gl1, gp1) - in 5 of 15 errors: li.3 x3, mcon.2 x1, li.c2 x1
    gc1 spans x 1.115..1.285, y 1.095..1.265 um
    mcon.2: b1m [mcon] vs a2m (line 67) [mcon x 1.395..1.565, y 1.095..1.265]: gap 0.110 um, rule needs >= 0.19 um (short by 0.080 um)
    one fix: move gc1 left by 0.08 um - line 53: `cx=(g1.cx + 0.13)` -> `cx=(g1.cx + 0.13 - 0.08)` (or move the other shape the opposite way)
    li.3: gl1 [li] vs gl2 (line 58) [li x 1.395..1.565, y 1.015..1.345]: gap 0.110 um, rule needs >= 0.17 um (short by 0.060 um)
    li.c2: gl1 [li] vs gl2 (line 58) [li x 1.395..1.565, y 1.015..1.345]: gap 0.110 um, rule needs >= 0.14 um (short by 0.030 um)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* gc3 (line 59: `gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb`) and shapes built from it (a1p, gp3) - in 3 of 15 errors: poly.2 x3
    gc3 spans x 1.935..2.105, y 1.095..1.265 um
    poly.2: gp3 [poly] vs g2 (line 20) [poly x 1.535..1.685, y 0.285..2.435]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move gc3 right by 0.04 um - line 59: `cx=(g3.cx - 0.13)` -> `cx=(g3.cx - 0.13 + 0.04)` (or move the other shape the opposite way)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* g2 (line 20: `g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2`) - in 1 of 15 errors: poly.2 x1
    g2 spans x 1.535..1.685, y 0.285..2.435 um
    poly.2: g2 [poly] vs gp3 (line 60) [poly x 1.855..2.185, y 1.045..1.315]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move g2 left by 0.04 um - line 20: `left=(g1.right + max(0.28, 0.54 - L))` -> `left=((g1.right + max(0.28, 0.54 - L)) - 0.04)` (or move the other shape the opposite way)
    licon.2: g2 [poly] vs gc2 (line 56) [licon x 1.395..1.565, y 1.095..1.265]: they overlap by 0.030 um, rule needs >= 0.17 um (short by 0.200 um)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING o21ai: port B1: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.