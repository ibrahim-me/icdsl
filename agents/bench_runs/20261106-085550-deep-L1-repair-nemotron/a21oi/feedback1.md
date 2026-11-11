Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n2 is 2 separate pieces: [c4l (line 35), pd1 (line 23)] | [c6l (line 40), pd1 (line 23)] - join them (strap / shared metal / `route n2`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.