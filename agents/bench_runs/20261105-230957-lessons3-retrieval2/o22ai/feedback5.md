Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 97: net 'Y': pin cy2l has no legal access point (blocked by route:n3 on m1: 0.025 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 2 separate pieces: [cy2l (line 49), nd2 (line 27)] | [pd1 (line 31), pyl (line 61), yp (line 95)] - join them (strap / shared metal / `route Y`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.