Check result at {'W': 1.0, 'L': 0.5}: CONSTRAINTS  (DRC 0 errors, LVS MATCH, size [11.96, 7.82] um)
LAYOUT CONSTRAINTS (measured on your geometry):
  FAILED area: cell is 11.96 x 7.82 um = 93.5 um2 (budget 86.0 um2 at these parameters)
     how: make it smaller: stack the pattern rows tightly (gap=min), put taps next to the devices instead of in separate rows, fewer dummies, align objects so the bounding box has no empty corners
  satisfied: interdigitated (order left to right ABBA (A=M1, B=M2); M1 centroid (3.680, 3.165), M2 ); interdigitated (order left to right ABBA (A=M3, B=M4); M3 centroid (3.680, 5.620), M4 )
Fix the first items first (the attached image is your layout). Return the complete corrected file.