Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net A is 2 separate pieces: [ap (line 110), g1 (line 25), gl1 (line 90), gp1 (line 89)] | [g5 (line 29), gl5 (line 102), gp5 (line 101)] - join them (strap / shared metal / `route A`)
  OPEN net B is 2 separate pieces: [bp (line 113), g2 (line 26), gl2 (line 93), gp2 (line 92)] | [g4 (line 28), gl4 (line 99), gp4 (line 98)] - join them (strap / shared metal / `route B`)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.