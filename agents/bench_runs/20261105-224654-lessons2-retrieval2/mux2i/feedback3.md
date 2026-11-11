Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 104: net 'n5': pin c4l has no legal access point (blocked by route:n3 on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n5 is 2 separate pieces: [c4l (line 42), nd2 (line 27)] | [c7l (line 49), nd3 (line 28)] - join them (strap / shared metal / `route n5`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.