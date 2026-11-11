Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 44 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 88: net 'A': pin gl1+ap has no legal access point
  line 87: net 'n2': pin c11l has no legal access point (blocked by route:n1 on m1: 0.000 < 0.140 um)
  line 89: net 'B': pin gl4 has no legal access point (blocked by route:X on m1: 0.070 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT B / n1 / n2: joined through contacts/vias: B: bp (line 82), gl2 (line 66); n1: c2l (line 37), c9l (line 55), gl5 (line 75), route n1; n2: c7l (line 50)
  OPEN net A is 2 separate pieces: [ap (line 79), g1 (line 23), gl1 (line 63), gp1 (line 62)] | [g3 (line 25), gl3 (line 69), gp3 (line 68)] - join them (strap / shared metal / `route A`)
  OPEN net B is 2 separate pieces: [bp (line 82), c2l (line 37), c7l (line 50), c9l (line 55), +8 more, route n1] | [g4 (line 26), gl4 (line 72), gp4 (line 71)] - join them (strap / shared metal / `route B`)
  OPEN net n2 is 2 separate pieces: [bp (line 82), c2l (line 37), c7l (line 50), c9l (line 55), +8 more, route n1] | [c11l (line 59), pd2 (line 30)] - join them (strap / shared metal / `route n2`)
  DEVICE M1 (nmos g=B d=VGND s=n1) has no matching transistor in the layout - the nmos with gate B at x=2.445 has ?3 and X on its sides; it needs VGND and n1: the side labelled ?3 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=n1 d=X s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=B d=n2 s=VPWR) has no matching transistor in the layout - the pmos with gate B at x=2.445 has ?9 and B+n1+n2 on its sides; it needs n2 and VPWR: the side labelled ?9 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (pmos g=B d=n1 s=n3) has no matching transistor in the layout - the pmos with gate B at x=2.445 has ?9 and B+n1+n2 on its sides; it needs n1 and n3: the side labelled ?9 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M6 (pmos g=A d=n3 s=VPWR) has no matching transistor in the layout - the pmos with gate A at x=1.015 has B+n1+n2 and VPWR on its sides; it needs n3 and VPWR: the side labelled B+n1+n2 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (nmos g=B d=n4 s=X) has no matching transistor in the layout - the nmos with gate B at x=2.445 has ?3 and X on its sides; it needs n4 and X: the side labelled ?3 should be n4 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M8 (pmos g=n1 d=n2 s=X) has no matching transistor in the layout
  DEVICE M9 (nmos g=A d=VGND s=n4) has no matching transistor in the layout - the nmos with gate A at x=1.015 has B+n1+n2 and VGND on its sides; it needs VGND and n4: the side labelled B+n1+n2 should be n4 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.015 y=0.66: gate A [g1 (line 23), gp1 (line 62)], source/drain B+n1+n2 [c2l (line 37), c7l (line 50), c9l (line 55), +4 more], VGND [c1l (line 34), c1s (line 35), c3l (line 39), +4 more]
    layout nmos at x=1.365 y=0.66: gate B+n1+n2 [g2 (line 24), gp2 (line 65)], source/drain B+n1+n2 [c2l (line 37), c7l (line 50), c9l (line 55), +4 more], VGND [c1l (line 34), c1s (line 35), c3l (line 39), +4 more]
DRC root causes (ranked; by the statements in your file):
* g2 (line 24: `g2 = rect poly w=L left=(g1.right + 0.2) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B`) - in 38 of 44 errors: licon.11 x15, poly.2 x14, met1.2 x4, diff/tap.2 x4
    g2 spans x 1.290..1.440, y 0.285..2.435 um
    poly.2: g2 [poly] vs g1 (line 23) [poly x 0.940..1.090, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move g2 right by 0.01 um - line 24: `left=(g1.right + 0.2)` -> `left=(g1.right + 0.2 + 0.01)` (or move the other shape the opposite way)
    licon.11: g2 [poly] vs c7 (line 49) [licon x 1.145..1.315, y 1.675..2.185]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    licon.11: g2 [poly] vs c2 (line 36) [licon x 1.145..1.315, y 0.575..0.745]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    its position uses ny0 (line 19: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 20: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* pd1 (line 29: `pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)`) - in 17 of 44 errors: licon.11 x10, poly.2 x5, diff/tap.2 x2
    pd1 spans x 0.675..2.785, y 1.555..2.305 um
    its position uses py1 (line 20: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* c7 (line 49: `c7 = array licon in=pd1 right_of=g1`) and shapes built from it (c7l) - in 15 of 44 errors: licon.11 x10, poly.2 x3, diff/tap.2 x2
    c7 spans x 1.145..1.315, y 1.675..2.185 um
    licon.11: c7 [licon] vs g2 (line 24) [poly x 1.290..1.440, y 0.285..2.435]: they overlap by 0.025 um, rule needs >= 0.055 um (short by 0.080 um)
    one fix: move c7 left by 0.08 um (or move the other shape the opposite way)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc2 (line 64: `gc2 = contact licon cx=g2.cx bottom=cb`) and shapes built from it (bm, bp, gl2, gp2) - in 12 of 44 errors: poly.2 x7, met1.2 x4, mcon.2 x1
    gc2 spans x 1.280..1.450, y 1.095..1.265 um
    mcon.2: bm [mcon] vs am (line 78) [mcon x 0.930..1.100, y 1.095..1.265]: gap 0.180 um, rule needs >= 0.19 um (short by 0.010 um)
    one fix: move gc2 right by 0.01 um - line 64: `cx=g2.cx` -> `cx=(g2.cx + 0.01)` (or move the other shape the opposite way)
    met1.2: bp [m1] vs ap (line 79) [m1 x 0.870..1.160, y 1.035..1.325]: gap 0.060 um, rule needs >= 0.14 um (short by 0.080 um)
    poly.2: gp2 [poly] vs gp1 (line 62) [poly x 0.850..1.180, y 1.045..1.315]: gap 0.020 um, rule needs >= 0.21 um (short by 0.190 um)
    its position uses cb (line 60: `cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
    rule met1.2: two met1 shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.