Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 72: net 'Y': pin nYl has no legal access point (blocked by route:n3 on m1: 0.040 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / A2 / B1 / B2: joined through contacts/vias: A1: a1 (line 63), a1p (line 76); A2: a2 (line 64), a2p (line 78); B1: b1 (line 66), b1p (line 80); B2: b2 (line 65), b2p (line 82)
  OPEN net Y is 2 separate pieces: [nYl (line 51), nd (line 17)] | [pYl (line 36), pd (line 18), yp (line 85)] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout
  DEVICE M1 (pmos g=A1 d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout
    layout nmos at x=1.49 y=0.66: gate A1+A2+B1+B2 [enclose_line61 (line 61), ga (line 23), +3 more], source/drain VGND [nd (line 17), nvgndl (line 49), strap_line53 (line 53)], n3 [nd (line 17), nn3ll (line 48), nn3ml (line 50), +1 more, route n3]
    layout nmos at x=2.03 y=0.66: gate A1+A2+B1+B2 [enclose_line61 (line 61), ga (line 23), +3 more], source/drain VGND [nd (line 17), nvgndl (line 49), strap_line53 (line 53)], n3 [nd (line 17), nn3ll (line 48), nn3ml (line 50), +1 more, route n3]
    layout nmos at x=2.57 y=0.66: gate A1+A2+B1+B2 [enclose_line61 (line 61), ga (line 23), +3 more], source/drain Y [nYl (line 51), nd (line 17)], n3 [nd (line 17), nn3ll (line 48), nn3ml (line 50), +1 more, route n3]
    layout nmos at x=3.11 y=0.66: gate A1+A2+B1+B2 [enclose_line61 (line 61), ga (line 23), +3 more], source/drain Y [nYl (line 51), nd (line 17)], n3 [nd (line 17), nn3ll (line 48), nn3ml (line 50), +1 more, route n3]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.