Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 2 separate pieces: [cy2l (line 49), nd2 (line 27)] | [pd1 (line 31), pyl (line 61), yp (line 95)] - join them (strap / shared metal / `route Y`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.