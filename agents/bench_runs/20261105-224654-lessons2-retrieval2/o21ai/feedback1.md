Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 145 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 75: net 'n2': pin c8l has no legal access point (blocked by route:Y on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT Y / n2: on li around (1.34, 0.66): shapes of Y and n2 overlap/touch there (c7l (line 43), c8l (line 48))
  SHORT A1 / A2 / B1 / VPWR: on li around (1.61, 2.2): shapes of A1 and A2 and B1 and VPWR overlap/touch there (c1l (line 28), c1s (line 29), c4l (line 34), c4s (line 35), gl1 (line 55), gl2 (line 58), +1 more)
  OPEN net n2 is 2 separate pieces: [c2l (line 31), c7l (line 43), c8l (line 48), nd1 (line 22), +2 more, route Y] | [c6l (line 41), nd1 (line 22)] - join them (strap / shared metal / `route n2`)
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout
  DEVICE M1 (pmos g=B1 d=Y s=VPWR) has no matching transistor in the layout
  DEVICE M3 (nmos g=B1 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M4 (pmos g=A1 d=VPWR s=n1) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout
    layout nmos at x=1.07 y=0.66: gate ?10 [g1 (line 19)], source/drain ?0 [nd1 (line 22), nd2 (line 45)], Y+n2 [c2l (line 31), c7l (line 43), c8l (line 48), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.61 y=0.66: gate ?11 [g2 (line 20)], source/drain VGND [c5l (line 38), c5s (line 39), c9l (line 50), +2 more], Y+n2 [c2l (line 31), c7l (line 43), c8l (line 48), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.07 y=1.93: gate ?10 [g1 (line 19)], source/drain A1+A2+B1+VPWR [c1l (line 28), c1s (line 29), c4l (line 34), +5 more], Y+n2 [c2l (line 31), c7l (line 43), c8l (line 48), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.61 y=1.93: gate ?11 [g2 (line 20)], source/drain ?6 [pd1 (line 23)], Y+n2 [c2l (line 31), c7l (line 43), c8l (line 48), +3 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.15 y=1.93: gate ?12 [g3 (line 21)], source/drain ?6 [pd1 (line 23)], A1+A2+B1+VPWR [c1l (line 28), c1s (line 29), c4l (line 34), +5 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* gc1 (line 53: `gc1 = contact licon cx=g1.cx bottom=cb`) and shapes built from it (b1m, b1p, gl1, gn, gp1) - in 50 of 145 errors: licon.9 x9, poly.2 x8, li.3 x7, licon.14 x7
    gc1 spans x 0.985..1.155, y 2.515..2.685 um
    li.3: gl1 [li] vs c1s (line 29) [li x 0.770..0.940, y 1.595..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc1 right by 0.13 um - line 53: `cx=g1.cx` -> `cx=(g1.cx + 0.13)` (or move the other shape the opposite way)
    licon.10: gp1 [poly] vs template ntap_licon [licon x 0.605..2.615, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gc1 [licon] vs template ntap [tap x 0.180..3.040, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc3 (line 59: `gc3 = contact licon cx=g3.cx bottom=cb`) and shapes built from it (a1m, a1p, gl3, gp3) - in 41 of 145 errors: poly.2 x8, li.3 x7, licon.14 x7, li.c2 x4
    gc3 spans x 2.065..2.235, y 2.515..2.685 um
    li.3: gl3 [li] vs c4s (line 35) [li x 2.280..2.450, y 1.595..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gc3 left by 0.13 um - line 59: `cx=g3.cx` -> `cx=(g3.cx - 0.13)` (or move the other shape the opposite way)
    licon.10: gp3 [poly] vs template ntap_licon [licon x 0.605..2.615, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gc3 [licon] vs template ntap [tap x 0.180..3.040, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* gc2 (line 56: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (a2m, a2p, gl2, gp2) - in 25 of 145 errors: poly.2 x8, licon.14 x5, licon.9 x3, licon.7 x2
    gc2 spans x 1.525..1.695, y 2.515..2.685 um
    licon.10: gp2 [poly] vs template ntap_licon [licon x 0.605..2.615, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    one fix: move gc2 left by 0.35 um - line 56: `cx=g2.cx` -> `cx=(g2.cx - 0.35)` (or move the other shape the opposite way)
    licon.14: gc2 [licon] vs template ntap [tap x 0.180..3.040, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    licon.9: gc2 [licon] vs template ntap [tap x 0.180..3.040, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.235 um (short by 0.345 um)
    its position uses cb (line 52: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
* c1s (line 29: `c1s = strap li from=c1l to=vpwr_li`) - in 22 of 145 errors: li.3 x4, licon.10 x4, licon.14 x3, poly.2 x3
    c1s spans x 0.770..0.940, y 1.595..2.805 um
    li.3: c1s [li] vs gl1 (line 55) [li x 0.985..1.155, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move c1s left by 0.13 um (or move the other shape the opposite way)
    li.c2: c1s [li] vs gl1 (line 55) [li x 0.985..1.155, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.10: a contact is near poly that sits over a tap (varactor) - keep poly out of the tap rows
WARNING o21ai: port A1: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by vpwr on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING o21ai: port A2: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING o21ai: port B1: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by vpwr on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.