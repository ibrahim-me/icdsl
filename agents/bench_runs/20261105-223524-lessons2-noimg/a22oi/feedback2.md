Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 74 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 67: net 'Y': pin cbl has no legal access point (blocked by bp1 on m1: 0.025 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / B2 / VGND / VPWR / Y / n2: on li around (2.76, 0.37): shapes of VGND and Y overlap/touch there (cgl (line 35), cyl (line 34), sg (line 36))
  DEVICE M0 (nmos g=B1 d=n1 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=0.495 has ?1 and A1+B2+VGND+VPWR+Y+n2 on its sides; it needs n1 and Y: the side labelled ?1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A2 d=n2 s=VPWR) has no matching transistor in the layout - the pmos with gate A2 at x=1.91 has A1+B2+VGND+VPWR+Y+n2 and A1+B2+VGND+VPWR+Y+n2 on its sides; it needs n2 and VPWR: the side labelled A1+B2+VGND+VPWR+Y+n2 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=A1 d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout - the nmos with gate A2 at x=1.91 has ?3 and A1+B2+VGND+VPWR+Y+n2 on its sides; it needs n3 and VGND: the side labelled ?3 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (nmos g=B2 d=VGND s=n1) has no matching transistor in the layout
  DEVICE M5 (pmos g=B2 d=Y s=n2) has no matching transistor in the layout
  DEVICE M6 (nmos g=A1 d=Y s=n3) has no matching transistor in the layout
  DEVICE M7 (pmos g=B1 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B1 at x=0.495 has A1+B2+VGND+VPWR+Y+n2 and A1+B2+VGND+VPWR+Y+n2 on its sides; it needs n2 and Y: the side labelled A1+B2+VGND+VPWR+Y+n2 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=0.495 y=0.66: gate B1 [g1 (line 24), gp1 (line 55)], source/drain ?1 [nd1 (line 16)], A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.035 y=0.66: gate A1+B2+VGND+VPWR+Y+n2 [g2 (line 25), gp2 (line 56)], source/drain ?1 [nd1 (line 16)], A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.37 y=0.66: gate A1+B2+VGND+VPWR+Y+n2 [g3 (line 26), gp3 (line 57)], source/drain ?3 [nd1 (line 16), nd2 (line 17)], A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.91 y=0.66: gate A2 [g4 (line 27), gp4 (line 58)], source/drain ?3 [nd1 (line 16), nd2 (line 17)], A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=0.495 y=1.93: gate B1 [g1 (line 24), gp1 (line 55)], source/drain A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more], A1+B2+VGND+VPWR+Y+n2 [a1 (line 60), b2 (line 63), cbl (line 46), +10 more]
DRC root causes (ranked; by the statements in your file):
* g3 (line 26: `g3 = cross [nd2, pd2] poly w=L left=(nd2.left + 0.265)   # A1`) - in 42 of 74 errors: licon.11 x16, poly.2 x13, met1.2 x4, diff/tap.2 x4
    g3 spans x 1.295..1.445, y 0.285..2.435 um
    poly.2: g3 [poly] vs g2 (line 25) [poly x 0.960..1.110, y 0.285..2.435]: gap 0.185 um, rule needs >= 0.21 um (short by 0.025 um)
    one fix: move g3 right by 0.03 um - line 26: `left=(nd2.left + 0.265)` -> `left=(nd2.left + 0.265 + 0.03)` (or move the other shape the opposite way)
    licon.11: g3 [poly] vs cn2r (line 41) [licon x 1.165..1.335, y 1.675..2.185]: they overlap by 0.040 um, rule needs >= 0.055 um (short by 0.095 um)
    licon.11: g3 [poly] vs cg1 (line 31) [licon x 1.165..1.335, y 0.575..0.745]: they overlap by 0.040 um, rule needs >= 0.055 um (short by 0.095 um)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* pd1 (line 18: `pd1 = rect diff w=0.53+L+0.21+L+0.53 h=WP cx=nd1.cx below=ntap   # p island B1,B2: n2|B1|Y|B2|n2`) and shapes built from it (pim) - in 30 of 74 errors: licon.11 x14, diff/tap.8 x5, diff/tap.2 x4, poly.2 x4
    pd1 spans x 0.155..1.725, y 1.555..2.305 um
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule diff/tap.2: transistor width below 0.42 um
* cn2b (line 39: `cn2b = array licon in=pd1 left_of=g1         # n2 col (islandB left)`) and shapes built from it (cn2l) - in 28 of 74 errors: licon.11 x14, diff/tap.8 x5, diff/tap.2 x4, poly.1a x3
    cn2b spans x 0.195..0.365, y 1.675..2.185 um
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule diff/tap.2: transistor width below 0.42 um
* g2 (line 25: `g2 = cross [nd1, pd1] poly w=L left=(g1.right + gg)      # B2`) - in 27 of 74 errors: licon.11 x10, met1.2 x4, poly.1a x4, diff/tap.2 x4
    g2 spans x 0.960..1.110, y 0.285..2.435 um
    poly.2: g2 [poly] vs g3 (line 26) [poly x 1.295..1.445, y 0.285..2.435]: gap 0.185 um, rule needs >= 0.21 um (short by 0.025 um)
    one fix: move g2 left by 0.03 um - line 25: `left=(g1.right + gg)` -> `left=(g1.right + gg - 0.03)` (or move the other shape the opposite way)
    licon.11: g2 [poly] vs cpw (line 42) [licon x 1.070..1.240, y 1.675..2.185]: they overlap by 0.040 um, rule needs >= 0.055 um (short by 0.095 um)
    licon.11: g2 [poly] vs cy2 (line 32) [licon x 1.070..1.240, y 0.575..0.745]: they overlap by 0.040 um, rule needs >= 0.055 um (short by 0.095 um)
    its position uses gg (line 14: `gg  = max(0.28, 0.54 - L)          # gate-to-gate gap (pad pitch 0.54)`)
    rule licon.11: a diffusion contact is closer than 0.055 um to a gate - use `array licon in=<diff> left_of=<gate>` / right_of so the contacts keep their distance, or widen the gap between gates
    rule met1.2: two met1 shapes closer than 0.14 um
WARNING a22oi: port A1: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.