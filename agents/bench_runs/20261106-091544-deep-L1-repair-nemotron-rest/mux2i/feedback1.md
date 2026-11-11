Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net n1 is 3 separate pieces: [c3l (line 40), nd1 (line 28)] | [c9l (line 53), pd1 (line 31)] | [g5 (line 27), gl5 (line 77), gp5 (line 76)] - join them (strap / shared metal / `route n1`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.