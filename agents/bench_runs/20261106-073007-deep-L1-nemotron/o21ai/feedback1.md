Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 8 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout - the pmos with gate A2 at x=2.36 has ?7 and VPWR on its sides; it needs n1 and Y: the side labelled ?7 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=A1 d=n2 s=VGND) has no matching transistor in the layout - the nmos with gate A1 at x=1.28 has VGND and n1 on its sides; it needs n2 and VGND: the side labelled n1 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=B1 d=n2 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=1.82 has ?2 and n1 on its sides; it needs n2 and Y: the side labelled ?2 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (pmos g=A1 d=VPWR s=n1) has no matching transistor in the layout - the pmos with gate A1 at x=1.28 has VPWR and Y on its sides; it needs VPWR and n1: the side labelled Y should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout - the nmos with gate A2 at x=2.36 has ?2 and Y on its sides; it needs VGND and n2: the side labelled ?2 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.28 y=0.66: gate A1 [ga (line 18), gpa (line 40)], source/drain VGND [gnd (line 32), nd (line 13), snl (line 27)], n1 [n1l (line 60), nd (line 13)]
    layout nmos at x=1.82 y=0.66: gate B1 [gb (line 19), gpb (line 41)], source/drain ?2 [nd (line 13)], n1 [n1l (line 60), nd (line 13)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=2.36 y=0.66: gate A2 [gc (line 20), gpc (line 42)], source/drain ?2 [nd (line 13)], Y [dnl (line 28), myl (line 30), nd (line 13), +1 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.28 y=1.93: gate A1 [ga (line 18), gpa (line 40)], source/drain VPWR [p1 (line 33), p2 (line 34), pd (line 14), +2 more], Y [dnl (line 28), myl (line 30), nd (line 13), +1 more]
    layout pmos at x=2.36 y=1.93: gate A2 [gc (line 20), gpc (line 42)], source/drain ?7 [pd (line 14)], VPWR [p1 (line 33), p2 (line 34), pd (line 14), +2 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* gcb (line 38: `gcb = contact licon cx=(gb.cx - 0.1) bottom=cb`) and shapes built from it (bp, gpb) - in 4 of 8 errors: poly.2 x4
    gcb spans x 1.635..1.805, y 1.095..1.265 um
    poly.2: gpb [poly] vs ga (line 18) [poly x 1.205..1.355, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move gcb right by 0.01 um - line 38: `cx=(gb.cx - 0.1)` -> `cx=(gb.cx - 0.1 + 0.01)` (or move the other shape the opposite way)
    its position uses cb (line 36: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcc (line 39: `gcc = contact licon cx=(gc.cx - 0.1) bottom=cb`) and shapes built from it (cp, gpc) - in 3 of 8 errors: poly.2 x3
    gcc spans x 2.175..2.345, y 1.095..1.265 um
    poly.2: gpc [poly] vs gb (line 19) [poly x 1.745..1.895, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move gcc right by 0.01 um - line 39: `cx=(gc.cx - 0.1)` -> `cx=(gc.cx - 0.1 + 0.01)` (or move the other shape the opposite way)
    its position uses cb (line 36: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca (line 37: `gca = contact licon cx=(ga.cx - 0.1) bottom=cb`) and shapes built from it (ap, gpa) - in 1 of 8 errors: poly.2 x1
    gca spans x 1.095..1.265, y 1.095..1.265 um
    its position uses cb (line 36: `cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* ga (line 18: `ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)`) - in 1 of 8 errors: poly.2 x1
    ga spans x 1.205..1.355, y 0.285..2.435 um
    poly.2: ga [poly] vs gpb (line 41) [poly x 1.555..1.885, y 1.045..1.315]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move ga left by 0.01 um - line 18: `left=(nd.left + 0.265)` -> `left=(nd.left + 0.265 - 0.01)` (or move the other shape the opposite way)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.