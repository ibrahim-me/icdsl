Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 56 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 80: net 'A1': pin a1nl has no legal access point (blocked by a2p on m1: 0.000 < 0.140 um)
  line 81: net 'A2': pin a2nl has no legal access point (blocked by a1p on m1: 0.085 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / A2: on li around (1.76, 1.12): shapes of A1 and A2 overlap/touch there (a1pl (line 64), a2nl (line 68))
  SHORT A1 / A2: on li around (2.3, 1.12): shapes of A1 and A2 overlap/touch there (a1nl (line 67), a2pl (line 65))
  OPEN net A1 is 2 separate pieces: [a1p (line 75), a1pl (line 64), a2nl (line 68), gn5 (line 36), +2 more] | [a1nl (line 67), a2p (line 77), a2pl (line 65), gn2 (line 37), +2 more] - join them (strap / shared metal / `route A1`)
  OPEN net A2 is 2 separate pieces: [a1p (line 75), a1pl (line 64), a2nl (line 68), gn5 (line 36), +2 more] | [a1nl (line 67), a2p (line 77), a2pl (line 65), gn2 (line 37), +2 more] - join them (strap / shared metal / `route A2`)
  OPEN net Y is 2 separate pieces: [n3l (line 46), nd (line 34)] | [p02l (line 28), pd (line 17), yp (line 87)] - join them (strap / shared metal / `route Y`)
  DEVICE M2 (nmos g=A1 d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout
    layout nmos at x=1.76 y=0.66: gate A1+A2 [gn5 (line 36), gn5e (line 60), +1 more], source/drain VGND [n23l (line 45), n5l (line 43), nd (line 34), route n2], n2 [n22l (line 44), n22s (line 47), nd (line 34), template ptap/vgnd]
    layout nmos at x=2.3 y=0.66: gate A1+A2 [gn2 (line 37), gn2e (line 61), +1 more], source/drain VGND [n22l (line 44), n22s (line 47), nd (line 34), template ptap/vgnd], n2 [n23l (line 45), n5l (line 43), nd (line 34), route n2]
DRC root causes (ranked; by the statements in your file):
* nd (line 34: `nd  = rect diff w=dpw h=WN cx=cell.cx above=ptap`) - in 36 of 56 errors: li.3 x24, poly.4 x12
    nd spans x 1.420..3.180, y 0.415..0.905 um
    licon.14: nd [diff] vs gc5 (line 54) [licon x 1.675..1.845, y 0.975..1.145]: gap 0.070 um, rule needs >= 0.19 um (short by 0.120 um)
    one fix: move nd down by 0.12 um (or move the other shape the opposite way)
    licon.14: nd [diff] vs gc0 (line 52) [licon x 2.215..2.385, y 0.975..1.145]: gap 0.070 um, rule needs >= 0.19 um (short by 0.120 um)
    licon.14: nd [diff] vs gc3 (line 56) [licon x 2.755..2.925, y 0.975..1.145]: gap 0.070 um, rule needs >= 0.19 um (short by 0.120 um)
    its position uses dpw (line 14: `dpw = 3*L + 2*ggap + 2*endc`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
* gc5 (line 54: `gc5 = contact licon cx=gn5.cx bottom=(cb - 0.12)`) and shapes built from it (a2nl, gn5e) - in 15 of 56 errors: li.3 x8, poly.4 x4, licon.14 x3
    gc5 spans x 1.675..1.845, y 0.975..1.145 um
    li.3: a2nl [li] vs n5l (line 43) [li x 1.460..1.630, y 0.495..0.825]: gap 0.070 um, rule needs >= 0.17 um (short by 0.100 um)
    one fix: move gc5 up by 0.1 um - line 54: `bottom=(cb - 0.12)` -> `bottom=(cb - 0.12 + 0.1)` (or move the other shape the opposite way)
    li.3: a2nl [li] vs n22l (line 44) [li x 1.890..2.060, y 0.495..0.825]: gap 0.070 um, rule needs >= 0.17 um (short by 0.100 um)
    licon.14: gc5 [licon] vs nd (line 34) [diff x 1.420..3.180, y 0.415..0.905]: gap 0.070 um, rule needs >= 0.19 um (short by 0.120 um)
    its position uses cb (line 50: `cb = max(nd.top + 0.19, n22l.top + 0.25, n23l.top + 0.25, n5l.top + 0.25, n3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
* gn5 (line 36: `gn5 = cross [nd] poly w=L left=(nd.left + endc)`) - in 13 of 56 errors: li.3 x8, licon.14 x3, poly.4 x2
    gn5 spans x 1.685..1.835, y 0.285..1.035 um
    poly.4: gn5 [poly] vs nd (line 34) [diff x 1.420..3.180, y 0.415..0.905]: they overlap by 0.415 um, rule needs >= 0.075 um (short by 0.490 um)
    one fix: move gn5 left by 0.49 um - line 36: `left=(nd.left + endc)` -> `left=(nd.left + endc - 0.49)` (or move the other shape the opposite way)
    its position uses endc (line 13: `endc = 0.265`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.14: a poly (gate) contact must stay 0.19 um away from any diffusion or tap - gate contacts belong in the empty band between the n and p diffusions, not over a diffusion and not near the tap rows
* gc0 (line 52: `gc0 = contact licon cx=gp0.cx bottom=(cb - 0.12)`) and shapes built from it (a2m, a2p, a2pl, gp0e) - in 11 of 56 errors: li.3 x4, poly.4 x4, licon.14 x3
    gc0 spans x 2.215..2.385, y 0.975..1.145 um
    li.3: a2pl [li] vs n23l (line 45) [li x 2.430..2.600, y 0.495..0.825]: gap 0.070 um, rule needs >= 0.17 um (short by 0.100 um)
    one fix: move gc0 up by 0.1 um - line 52: `bottom=(cb - 0.12)` -> `bottom=(cb - 0.12 + 0.1)` (or move the other shape the opposite way)
    licon.14: gc0 [licon] vs nd (line 34) [diff x 1.420..3.180, y 0.415..0.905]: gap 0.070 um, rule needs >= 0.19 um (short by 0.120 um)
    its position uses cb (line 50: `cb = max(nd.top + 0.19, n22l.top + 0.25, n23l.top + 0.25, n5l.top + 0.25, n3l.top + 0.25)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.