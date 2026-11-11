Check result at {'W': 1.0, 'L': 0.5}: CONSTRAINTS  (DRC 0 errors, LVS MATCH, size [9.2, 12.88] um)
LAYOUT CONSTRAINTS (measured on your geometry):
  FAILED area: cell is 9.20 x 12.88 um = 118.5 um2 (budget 86.0 um2 at these parameters)
     how: make it smaller: stack the pattern rows tightly (gap=min), put taps next to the devices instead of in separate rows, fewer dummies, align objects so the bounding box has no empty corners
  satisfied: interdigitated (order left to right ABBA (A=M1, B=M2); M1 centroid (4.600, 5.465), M2 ); interdigitated (order left to right ABBA (A=M3, B=M4); M3 centroid (4.600, 10.220), M4)
WARNING ota5t_small: guardring GP: made room by moving PLOAD (and what is placed relative to it) above by 1.38 um
WARNING ota5t_small: guardring GN: made room by moving PLOAD (and what is placed relative to it) above by 0.92 um
Fix the first items first (the attached image is your layout). Return the complete corrected file.