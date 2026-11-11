Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net A is 2 separate pieces: [ap (line 79), g1 (line 23), gl1 (line 63), gp1 (line 62)] | [g3 (line 25), gl3 (line 69), gp3 (line 68)] - join them (strap / shared metal / `route A`)
  OPEN net B is 2 separate pieces: [bp (line 82), g2 (line 24), gl2 (line 66), gp2 (line 65)] | [g4 (line 26), gl4 (line 72), gp4 (line 71)] - join them (strap / shared metal / `route B`)
  OPEN net X is 2 separate pieces: [c4l (line 42), nd1 (line 28), xp (line 85)] | [c10l (line 57), pd2 (line 30)] - join them (strap / shared metal / `route X`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.