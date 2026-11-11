Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 91: net 'n3': pin c5l has no legal access point (blocked by route:Y on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / Y: on li around (1.84, 0.37): shapes of VGND and Y overlap/touch there (c1l (line 33), c1s (line 34), c3l (line 38), c3s (line 39), c4l (line 42))
  OPEN net n3 is 2 separate pieces: [c2l (line 36), nd1 (line 25)] | [c5l (line 44), nd2 (line 26)] - join them (strap / shared metal / `route n3`)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout - the pmos with gate A2 at x=1.57 has VGND+Y and n1 on its sides; it needs Y and n1: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B2 at x=2.11 has VGND+Y and n2 on its sides; it needs n2 and Y: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout - the nmos with gate A2 at x=1.57 has VGND+Y and n3 on its sides; it needs n3 and VGND: the side labelled VGND+Y should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=2.65 has VGND+Y and n3 on its sides; it needs n3 and Y: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout - the nmos with gate B2 at x=2.11 has VGND+Y and n3 on its sides; it needs Y and n3: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=1.03 has VGND+Y and n3 on its sides; it needs VGND and n3: the side labelled VGND+Y should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.03 y=0.66: gate A1 [g1 (line 21), gp1 (line 62)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n3 [c2l (line 36), nd1 (line 25)]
    layout nmos at x=1.57 y=0.66: gate A2 [g2 (line 22), gp2 (line 65)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n3 [c2l (line 36), nd1 (line 25)]
    layout nmos at x=2.11 y=0.66: gate B2 [g3 (line 23), gp3 (line 68)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n3 [c5l (line 44), nd2 (line 26)]
    layout nmos at x=2.65 y=0.66: gate B1 [g4 (line 24), gp4 (line 71)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n3 [c5l (line 44), nd2 (line 26)]
    layout pmos at x=1.57 y=1.93: gate A2 [g2 (line 22), gp2 (line 65)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n1 [c8l (line 52), pd1 (line 27)]
    layout pmos at x=2.11 y=1.93: gate B2 [g3 (line 23), gp3 (line 68)], source/drain VGND+Y [c1l (line 33), c1s (line 34), c3l (line 38), +7 more], n2 [c10l (line 56), pd1 (line 27)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.