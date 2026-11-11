Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 159 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 90: net 'n2': pin gl3 has no legal access point (blocked by vpwr on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / B / VPWR / n2: on li around (1.84, 2.2): shapes of A and B and VPWR and n2 overlap/touch there (c5l (line 50), c5s (line 51), c8l (line 59), c8s (line 60), gl1 (line 67), gl2 (line 70), +1 more)
  OPEN net n2 is 2 separate pieces: [ap (line 80), bp (line 83), c5l (line 50), c5s (line 51), +10 more, template ntap/vpwr] | [c6l (line 53), pd1 (line 27)] - join them (strap / shared metal / `route n2`)
  DEVICE M0 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (nmos g=B d=VGND s=n2) has no matching transistor in the layout
  DEVICE M3 (nmos g=A d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M5 (pmos g=n2 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.635 y=0.66: gate ?13 [g2 (line 20)], source/drain ?1 [nd1 (line 24)], VGND [c1l (line 35), c1s (line 36), c2l (line 38), +5 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=2.585 y=0.66: gate ?14 [g3 (line 21)], source/drain VGND [c1l (line 35), c1s (line 36), c2l (line 38), +5 more], X [c3l (line 43), c7l (line 57), nd2 (line 25), +1 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.095 y=1.93: gate ?12 [g1 (line 19)], source/drain ?6 [pd1 (line 27)], A+B+VPWR+n2 [c5l (line 50), c5s (line 51), c8l (line 59), +6 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.585 y=2.095: gate ?14 [g3 (line 21)], source/drain A+B+VPWR+n2 [c5l (line 50), c5s (line 51), c8l (line 59), +6 more], X [c3l (line 43), c7l (line 57), nd2 (line 25), +1 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* gc1 (line 65: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (am, ap, gl1, gn, gp1) - in 50 of 150 errors: licon.9 x9, poly.2 x8, li.3 x7, licon.14 x7
    gc1 spans x 1.010..1.180, y 2.515..2.685 um
    li.3: gl1 [li] vs c5s (line 51) [li x 0.795..0.965, y 1.595..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 right by 0.13 um - line 65: `cx=g1.cx` -> `cx=(g1.cx + 0.13)` (or move the other shape the opposite way)
    licon.10: gp1 [poly] vs template ntap_licon [licon x 0.605..3.075, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gc1 [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 63: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,`)
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc3 (line 71: `gc3 = contact licon cx=g3.cx bottom=cb`) and shapes built from it (gl3, gp3) - in 36 of 150 errors: licon.14 x8, poly.2 x8, li.3 x6, licon.1 x3
    gc3 spans x 2.500..2.670, y 2.515..2.685 um
    li.3: gl3 [li] vs c8s (line 60) [li x 2.715..2.885, y 1.930..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc3 left by 0.13 um - line 71: `cx=g3.cx` -> `cx=(g3.cx - 0.13)` (or move the other shape the opposite way)
    licon.10: gp3 [poly] vs template ntap_licon [licon x 0.605..3.075, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gc3 [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 63: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc2 (line 68: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (bm, bp, gl2, gp2) - in 28 of 150 errors: poly.2 x8, licon.14 x7, licon.9 x3, var.2 x3
    gc2 spans x 1.550..1.720, y 2.515..2.685 um
    licon.14: gc2 [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    one fix: move gc2 left by 0.3 um - line 68: `cx=g2.cx` -> `cx=(g2.cx - 0.3)` (or move the other shape the opposite way)
    licon.9: gc2 [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.235 um (short by 0.345 um)
    poly.2: gp2 [poly] vs g2 (line 20) [poly x 1.560..1.710, y 0.285..2.435]: gap 0.030 um, rule needs >= 0.21 um (short by 0.180 um)
    its position uses cb (line 63: `cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
* c5s (line 51: `c5s = strap li from=c5l to=vpwr_li`) - in 22 of 150 errors: li.3 x4, licon.10 x4, licon.14 x3, poly.2 x3
    c5s spans x 0.795..0.965, y 1.595..2.805 um
    li.3: c5s [li] vs gl1 (line 67) [li x 1.010..1.180, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move c5s left by 0.13 um (or move the other shape the opposite way)
    li.c2: c5s [li] vs gl1 (line 67) [li x 1.010..1.180, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.10: a contact is near poly that sits over a tap (varactor) - keep poly out of the tap rows
WARNING or2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING or2: port B: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.