Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 161 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 130: net 'A': pin a0+ap0 has no legal access point
  line 136: net 'B': pin b1+b3+bp0+bp1 has no legal access point (blocked by ap0 on m1: 0.000 < 0.140 um)
  line 155: net 'X': no legal path to cX3l+xp
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VPWR / X: on li around (2.76, 2.2): shapes of VPWR and X overlap/touch there (cVP1l (line 59), cVP2l (line 71), cX8l (line 61), stVP1 (line 122), stVP2 (line 123))
  SHORT A / B / n1: on li around (2.71, 1.18): shapes of A and n1 overlap/touch there (a6 (line 116), n1g (line 94), n8 (line 115))
  SHORT A / B: on li around (3.527, 1.18): shapes of A and B overlap/touch there (a9 (line 96), b5 (line 117))
  OPEN net A is 4 separate pieces: [a6 (line 116), b1 (line 93), b3 (line 114), bp0 (line 133), +12 more, route n1] | [a4 (line 113), ap1 (line 129), gpA4 (line 105)] | [a0 (line 92), ap0 (line 127), gpA0 (line 84)] | [a9 (line 96), b5 (line 117), b7 (line 95), gpA9 (line 88), +2 more] - join them (strap / shared metal / `route A`)
  OPEN net B is 2 separate pieces: [a6 (line 116), b1 (line 93), b3 (line 114), bp0 (line 133), +12 more, route n1] | [a9 (line 96), b5 (line 117), b7 (line 95), gpA9 (line 88), +2 more] - join them (strap / shared metal / `route B`)
  OPEN net X is 2 separate pieces: [cX3l (line 34), nd (line 18), xp (line 152)] | [cVP1l (line 59), cVP2l (line 71), cX8l (line 61), gA6 (line 64), +6 more, template ntap/vpwr] - join them (strap / shared metal / `route X`)
  DEVICE M3 (pmos g=B d=n2 s=VPWR) has no matching transistor in the layout
  DEVICE M4 (pmos g=A d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M5 (pmos g=B d=n1 s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=A d=n3 s=VPWR) has no matching transistor in the layout
  DEVICE M8 (pmos g=n1 d=n2 s=X) has no matching transistor in the layout
    layout pmos at x=1.745 y=1.93: gate ?23 [gA4 (line 49)], source/drain VPWR+X [cVP1l (line 59), cVP2l (line 71), cX8l (line 61), +4 more], n2 [cN2al (line 58), cN2bl (line 60), pd1 (line 43)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.175 y=1.93: gate ?24 [gB3 (line 50)], source/drain VPWR+X [cVP1l (line 59), cVP2l (line 71), cX8l (line 61), +4 more], n2 [cN2al (line 58), cN2bl (line 60), pd1 (line 43)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.605 y=1.93: gate VPWR+X [gn8 (line 51)], source/drain VPWR+X [cVP1l (line 59), cVP2l (line 71), cX8l (line 61), +4 more], n2 [cN2al (line 58), cN2bl (line 60), pd1 (line 43)]
DRC root causes (ranked; by the statements in your file):
* gcA0 (line 78: `gcA0 = contact licon cx=gA0.cx bottom=cb`) and shapes built from it (a0, am0, ap0, gpA0) - in 35 of 150 errors: poly.2 x20, met1.2 x10, li.3 x3, mcon.2 x2
    gcA0 spans x 1.885..2.055, y 1.095..1.265 um
    mcon.2: am0 [mcon] vs am1 (line 128) [mcon x 1.530..1.700, y 1.095..1.265]: gap 0.185 um, rule needs >= 0.19 um (short by 0.005 um)
    one fix: move gcA0 right by 0.01 um - line 78: `cx=gA0.cx` -> `cx=(gA0.cx + 0.01)` (or move the other shape the opposite way)
    mcon.2: am0 [mcon] vs bm1 (line 134) [mcon x 2.220..2.390, y 1.095..1.265]: gap 0.165 um, rule needs >= 0.19 um (short by 0.025 um)
    li.3: a0 [li] vs b3 (line 114) [li x 2.220..2.390, y 1.015..1.345]: gap 0.165 um, rule needs >= 0.17 um (short by 0.005 um)
    its position uses cb (line 76: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule met1.2: two met1 shapes closer than 0.14 um
* gcB3 (line 100: `gcB3 = contact licon cx=(gB3.cx + 0.13) bottom=cb`) and shapes built from it (b3, bm1, bp1, gpB3) - in 34 of 150 errors: poly.2 x19, li.3 x6, met1.2 x6, mcon.2 x2
    gcB3 spans x 2.220..2.390, y 1.095..1.265 um
    mcon.2: bm1 [mcon] vs am0 (line 126) [mcon x 1.885..2.055, y 1.095..1.265]: gap 0.165 um, rule needs >= 0.19 um (short by 0.025 um)
    one fix: move gcB3 right by 0.03 um - line 100: `cx=(gB3.cx + 0.13)` -> `cx=(gB3.cx + 0.13 + 0.03)` (or move the other shape the opposite way)
    li.3: b3 [li] vs a0 (line 92) [li x 1.885..2.055, y 1.015..1.345]: gap 0.165 um, rule needs >= 0.17 um (short by 0.005 um)
    met1.2: bp1 [m1] vs ap0 (line 127) [m1 x 1.825..2.115, y 1.035..1.325]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 76: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* gcB1 (line 79: `gcB1 = contact licon cx=gB1.cx bottom=cb`) and shapes built from it (b1, bm0, bp0, gpB1) - in 30 of 150 errors: poly.2 x15, li.3 x6, met1.2 x6, mcon.2 x2
    gcB1 spans x 2.245..2.415, y 1.095..1.265 um
    mcon.2: bm0 [mcon] vs nm1 (line 140) [mcon x 2.520..2.690, y 1.095..1.265]: gap 0.105 um, rule needs >= 0.19 um (short by 0.085 um)
    one fix: move gcB1 left by 0.09 um - line 79: `cx=gB1.cx` -> `cx=(gB1.cx - 0.09)` (or move the other shape the opposite way)
    li.3: b1 [li] vs n8 (line 115) [li x 2.520..2.690, y 1.015..1.345]: gap 0.105 um, rule needs >= 0.17 um (short by 0.065 um)
    li.c2: b1 [li] vs n8 (line 115) [li x 2.520..2.690, y 1.015..1.345]: gap 0.105 um, rule needs >= 0.14 um (short by 0.035 um)
    its position uses cb (line 76: `cb = max(nd.top + 0.19, cV2l.top + 0.25, cX3l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule li.3: two li shapes of different nets closer than 0.17 um
* pd2 (line 44: `pd2 = rect diff w=dwp h=WP cx=(cell.cx + 0.6) below=ntap`) - in 28 of 150 errors: met1.2 x16, mcon.2 x4, diff/tap.2 x4, poly.2 x4
    pd2 spans x 2.605..4.115, y 1.555..2.305 um
    its position uses dwp (line 42: `dwp = 3*L + 4*0.265`)
    rule met1.2: two met1 shapes closer than 0.14 um
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
WARNING xor2: port B: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.