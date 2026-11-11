Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  DEVICE M7 (pmos g=B1 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B1 at x=1.88 has VPWR and n2 on its sides; it needs n2 and Y: the side labelled VPWR should be Y (wrong net label on that contact column, or the gates are in the wrong order)
    layout pmos at x=1.88 y=1.93: gate B1 [g3 (line 24), gp3 (line 69)], source/drain VPWR [cp0l (line 48), cp0s (line 49), cp2l (line 53), +2 more], n2 [cp1l (line 51), cp3l (line 56), pd (line 28)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.