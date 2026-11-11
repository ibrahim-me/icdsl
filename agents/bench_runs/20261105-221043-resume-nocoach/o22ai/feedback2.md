Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 20 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 100: net 'A2': pin a2n has no legal access point (blocked by b2p on m1: 0.000 < 0.140 um)
  line 101: net 'B1': pin b1n has no legal access point (blocked by n3pa on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / A2 / B1 / B2: on li around (2.085, 1.18): shapes of A2 and B1 overlap/touch there (a2 (line 91), b1n (line 95))
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout
  DEVICE M1 (pmos g=A1 d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout
    layout nmos at x=1.655 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain VGND [gnd1 (line 60), gnd2 (line 61), nd (line 16), +2 more, template ptap/vgnd], n3 [n3pa (line 66), n3pb (line 68), nd (line 16), +2 more, route n3]
    layout nmos at x=2.085 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain Y [n3pa (line 66), n3pb (line 68), nd (line 16), +2 more, route n3], n3 [nd (line 16), npl2 (line 56), pd (line 17), +3 more]
    layout nmos at x=2.515 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain Y [nd (line 16), npl2 (line 56), pd (line 17), +3 more], n3 [n3pa (line 66), n3pb (line 68), nd (line 16), +2 more, route n3]
    layout nmos at x=2.945 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain VGND [n3pa (line 66), n3pb (line 68), nd (line 16), +2 more, route n3], n3 [gnd1 (line 60), gnd2 (line 61), nd (line 16), +2 more, template ptap/vgnd]
    layout pmos at x=1.655 y=1.93: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain VPWR [pd (line 17), ppl (line 33), ppl4 (line 37), +2 more, template ntap/vpwr], n1 [pd (line 17), pn1l (line 34)]
DRC root causes (ranked; by the statements in your file):
* gce (line 81: `gce = contact licon cx=gn1.cx bottom=cb`) and shapes built from it (gpb) - in 16 of 20 errors: li.3 x12, li.c2 x4
    gce spans x 1.570..1.740, y 1.095..1.265 um
    its position uses cb (line 75: `cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gca (line 77: `gca = contact licon cx=gp1.cx bottom=cb`) and shapes built from it (gpa) - in 16 of 20 errors: li.3 x12, li.c2 x4
    gca spans x 1.570..1.740, y 1.095..1.265 um
    its position uses cb (line 75: `cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* ys (line 72: `ys = strap li from=npl2 to=ppl2 net=Y`) - in 12 of 20 errors: li.3 x10, li.c2 x2
    ys spans x 2.215..2.385, y 0.495..2.265 um
    li.3: ys [li] vs a2 (line 91) [li x 2.000..2.170, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move ys right by 0.13 um (or move the other shape the opposite way)
    li.3: ys [li] vs b2 (line 92) [li x 2.430..2.600, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    li.c2: ys [li] vs a2 (line 91) [li x 2.000..2.170, y 1.015..1.345]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* gcb (line 78: `gcb = contact licon cx=gp2.cx bottom=cb`) and shapes built from it (a2, a2m, a2p) - in 10 of 20 errors: li.3 x8, li.c2 x2
    gcb spans x 2.000..2.170, y 1.095..1.265 um
    li.3: a2 [li] vs ys (line 72) [li x 2.215..2.385, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.17 um (short by 0.125 um)
    one fix: move gcb left by 0.13 um - line 78: `cx=gp2.cx` -> `cx=(gp2.cx - 0.13)` (or move the other shape the opposite way)
    li.c2: a2 [li] vs ys (line 72) [li x 2.215..2.385, y 0.495..2.265]: gap 0.045 um, rule needs >= 0.14 um (short by 0.095 um)
    its position uses cb (line 75: `cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.