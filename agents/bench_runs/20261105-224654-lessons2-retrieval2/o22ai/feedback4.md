Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 96: net 'Y': no legal path to cp2l, cp5l
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 3 separate pieces: [cn4l (line 44), ndB (line 26), yp (line 91)] | [cp2l (line 54), pdA (line 27)] | [cp5l (line 62), pdB (line 28)] - join them (strap / shared metal / `route Y`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.