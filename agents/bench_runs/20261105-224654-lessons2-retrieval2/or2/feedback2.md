Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 159 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 82: net 'n2': pin glN has no legal access point (blocked by vpwr on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / B / VPWR / n2: on li around (1.84, 2.2): shapes of A and B and VPWR and n2 overlap/touch there (c12l (line 57), c12s (line 58), c7l (line 46), c7s (line 47), glA (line 63), glB (line 66), +1 more)
  OPEN net n2 is 3 separate pieces: [c2l (line 33), c3l (line 35), nd1 (line 20), nd2 (line 21)] | [ap (line 75), bp (line 78), c12l (line 57), c12s (line 58), +10 more, template ntap/vpwr] | [c10l (line 53), pd2 (line 24)] - join them (strap / shared metal / `route n2`)
  DEVICE M0 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M4 (pmos g=B d=n2 s=n1) has no matching transistor in the layout
  DEVICE M5 (pmos g=n2 d=VPWR s=X) has no matching transistor in the layout
    layout pmos at x=1.095 y=2.095: gate ?12 [gA (line 16)], source/drain A+B+VPWR+n2 [c12l (line 57), c12s (line 58), c7l (line 46), +6 more], n1 [c8l (line 49), c9l (line 51), pd1 (line 23), +1 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.635 y=2.095: gate ?13 [gB (line 17)], source/drain n1 [c8l (line 49), c9l (line 51), pd1 (line 23), +1 more], n2 [c10l (line 53), pd2 (line 24)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.585 y=1.93: gate ?14 [gN (line 18)], source/drain A+B+VPWR+n2 [c12l (line 57), c12s (line 58), c7l (line 46), +6 more], X [c11l (line 55), c5l (line 40), nd3 (line 22), +1 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* gcA (line 61: `gcA = contact licon cx=gA.cx bottom=cb`) and shapes built from it (am, ap, glA, gn, gpA) - in 50 of 150 errors: licon.9 x9, poly.2 x8, li.3 x7, licon.14 x7
    gcA spans x 1.010..1.180, y 2.515..2.685 um
    li.3: glA [li] vs c7s (line 47) [li x 0.795..0.965, y 1.930..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcA right by 0.13 um - line 61: `cx=gA.cx` -> `cx=(gA.cx + 0.13)` (or move the other shape the opposite way)
    licon.10: gpA [poly] vs template ntap_licon [licon x 0.605..3.075, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gcA [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 60: `cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c2l.top + 0.25, c3l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25)`)
    rule licon.9: a gate contact must be 0.235 um from p-diffusion (psdm) - move the gate contact further from the p row
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcN (line 67: `gcN = contact licon cx=gN.cx bottom=cb`) and shapes built from it (glN, gpN) - in 36 of 150 errors: licon.14 x8, poly.2 x8, li.3 x6, licon.1 x3
    gcN spans x 2.500..2.670, y 2.515..2.685 um
    li.3: glN [li] vs c12s (line 58) [li x 2.715..2.885, y 1.595..2.805]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcN left by 0.13 um - line 67: `cx=gN.cx` -> `cx=(gN.cx - 0.13)` (or move the other shape the opposite way)
    licon.10: gpN [poly] vs template ntap_licon [licon x 0.605..3.075, y 2.635..2.805]: they overlap by 0.100 um, rule needs >= 0.25 um (short by 0.350 um)
    licon.14: gcN [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    its position uses cb (line 60: `cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c2l.top + 0.25, c3l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25)`)
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcB (line 64: `gcB = contact licon cx=gB.cx bottom=cb`) and shapes built from it (bm, bp, glB, gpB) - in 28 of 150 errors: poly.2 x8, licon.14 x7, licon.9 x3, var.2 x3
    gcB spans x 1.550..1.720, y 2.515..2.685 um
    licon.14: gcB [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.19 um (short by 0.300 um)
    one fix: move gcB left by 0.3 um - line 64: `cx=gB.cx` -> `cx=(gB.cx - 0.3)` (or move the other shape the opposite way)
    licon.9: gcB [licon] vs template ntap [tap x 0.180..3.500, y 2.575..2.865]: they overlap by 0.110 um, rule needs >= 0.235 um (short by 0.345 um)
    poly.2: gpB [poly] vs gB (line 17) [poly x 1.560..1.710, y 0.285..2.435]: gap 0.030 um, rule needs >= 0.21 um (short by 0.180 um)
    its position uses cb (line 60: `cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c2l.top + 0.25, c3l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
* c7s (line 47: `c7s = strap li from=c7l to=vpwr_li`) - in 22 of 150 errors: li.3 x4, licon.10 x4, licon.14 x3, poly.2 x3
    c7s spans x 0.795..0.965, y 1.930..2.805 um
    li.3: c7s [li] vs glA (line 63) [li x 1.010..1.180, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move c7s left by 0.13 um (or move the other shape the opposite way)
    li.c2: c7s [li] vs glA (line 63) [li x 1.010..1.180, y 2.435..2.765]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.10: a contact is near poly that sits over a tap (varactor) - keep poly out of the tap rows
WARNING or2: port A: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING or2: port B: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.