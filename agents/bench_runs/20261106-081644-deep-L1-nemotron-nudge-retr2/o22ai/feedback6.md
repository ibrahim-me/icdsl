Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 88: net 'n3': pin c5l has no legal access point
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n3 is 2 separate pieces: [c2l (line 36), nd1 (line 25)] | [c5l (line 44), nd2 (line 26)] - join them (strap / shared metal / `route n3`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.