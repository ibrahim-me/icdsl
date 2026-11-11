Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 8 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 104: net 'Y': no legal path to y1nl, sy2l
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VPWR / Y: on li around (2.3, 2.2): shapes of VPWR and Y overlap/touch there (pwr1 (line 94), pwr2 (line 95), sp1l (line 58), sp2l (line 60), sy1l (line 66))
  OPEN net Y is 3 separate pieces: [nd (line 26), y1nl (line 50)] | [pd1 (line 30), pd2 (line 33), pwr1 (line 94), pwr2 (line 95), +4 more, template ntap/vpwr] | [pd2 (line 33), sy2l (line 68)] - join them (strap / shared metal / `route Y`)
  DEVICE M1 (pmos g=A2 d=n2 s=VPWR) has no matching transistor in the layout - the pmos with gate A2 at x=1.32 has VPWR+Y and n2 on its sides; it needs n2 and VPWR: the side labelled VPWR+Y should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=A1 d=VPWR s=n2) has no matching transistor in the layout - the pmos with gate A1 at x=1.86 has VPWR+Y and n2 on its sides; it needs VPWR and n2: the side labelled VPWR+Y should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (pmos g=B1 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B1 at x=2.4 has VPWR+Y and n2 on its sides; it needs n2 and Y: the side labelled VPWR+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
    layout pmos at x=1.32 y=1.93: gate A2 [ga2 (line 37), gpa2 (line 79)], source/drain VPWR+Y [pd1 (line 30), pd2 (line 33), pwr1 (line 94), +4 more], n2 [n2al (line 59), n2bl (line 67), pd1 (line 30), +1 more]
    layout pmos at x=1.86 y=1.93: gate A1 [ga1 (line 38), gpa1 (line 80)], source/drain VPWR+Y [pd1 (line 30), pd2 (line 33), pwr1 (line 94), +4 more], n2 [n2al (line 59), n2bl (line 67), pd1 (line 30), +1 more]
    layout pmos at x=2.4 y=1.93: gate B1 [gb1 (line 39), gpb1 (line 81)], source/drain VPWR+Y [pd1 (line 30), pd2 (line 33), pwr1 (line 94), +4 more], n2 [n2al (line 59), n2bl (line 67), pd1 (line 30), +1 more]
DRC root causes (ranked; by the statements in your file):
* gb2 (line 40: `gb2 = cross [nd, pd2] poly w=L left=(gb1.right + gpitch)`) - in 4 of 8 errors: poly.2 x4
    gb2 spans x 2.865..3.015, y 0.285..2.435 um
    poly.2: gb2 [poly] vs gpb1 (line 81) [poly x 2.335..2.665, y 1.045..1.315]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move gb2 right by 0.01 um - line 40: `left=(gb1.right + gpitch)` -> `left=(gb1.right + gpitch + 0.01)` (or move the other shape the opposite way)
    its position uses gpitch (line 15: `gpitch = max(0.28, 0.54 - L)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcb2 (line 77: `gcb2 = contact licon cx=(gb2.cx + 0.1) bottom=cb`) and shapes built from it (b2p, gpb2) - in 4 of 8 errors: poly.2 x4
    gcb2 spans x 2.955..3.125, y 1.095..1.265 um
    its position uses cb (line 71: `cb = max(nd.top + 0.19, sn3l.top + 0.25, n3nl.top + 0.25, y1nl.top + 0.25,`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca1 (line 75: `gca1 = contact licon cx=(ga1.cx - 0.1) bottom=cb`) and shapes built from it (a1p, gpa1) - in 3 of 8 errors: poly.2 x3
    gca1 spans x 1.675..1.845, y 1.095..1.265 um
    poly.2: gpa1 [poly] vs ga2 (line 37) [poly x 1.245..1.395, y 0.285..2.435]: gap 0.200 um, rule needs >= 0.21 um (short by 0.010 um)
    one fix: move gca1 right by 0.01 um - line 75: `cx=(ga1.cx - 0.1)` -> `cx=(ga1.cx - 0.1 + 0.01)` (or move the other shape the opposite way)
    its position uses cb (line 71: `cb = max(nd.top + 0.19, sn3l.top + 0.25, n3nl.top + 0.25, y1nl.top + 0.25,`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca2 (line 74: `gca2 = contact licon cx=(ga2.cx - 0.1) bottom=cb`) and shapes built from it (a2p, gpa2) - in 1 of 8 errors: poly.2 x1
    gca2 spans x 1.135..1.305, y 1.095..1.265 um
    its position uses cb (line 71: `cb = max(nd.top + 0.19, sn3l.top + 0.25, n3nl.top + 0.25, y1nl.top + 0.25,`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
WARNING a22oi: port Y: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by route:n2 on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.