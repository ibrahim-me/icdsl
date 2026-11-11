Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net VGND is 2 separate pieces: [c1l (line 30), nd1 (line 25)] | [c3l (line 34), c3s (line 35), nd1 (line 25), template ptap/vgnd] - join them (strap / shared metal / `route VGND`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.