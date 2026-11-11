Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 2 separate pieces: [cn2l (line 36), nd (line 25), yp (line 83)] | [cp1l (line 47), pd (line 26)] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout - the pmos with gate A2 at x=1.26 has VPWR and Y on its sides; it needs Y and n1: the side labelled VPWR should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B2 at x=2.34 has n1 and n2 on its sides; it needs n2 and Y: the side labelled n1 should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout - the pmos with gate B1 at x=1.8 has Y and n2 on its sides; it needs VPWR and n2: the side labelled Y should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
    layout pmos at x=1.26 y=1.93: gate A2 [gA2 (line 21), gpA2 (line 57)], source/drain VPWR [cp0l (line 44), cp0s (line 45), cp4l (line 53), +2 more], Y [cp1l (line 47), pd (line 26)]
    layout pmos at x=1.8 y=1.93: gate B1 [gB1 (line 22), gpB1 (line 60)], source/drain Y [cp1l (line 47), pd (line 26)], n2 [cp2l (line 49), pd (line 26)]
    layout pmos at x=2.34 y=1.93: gate B2 [gB2 (line 23), gpB2 (line 63)], source/drain n1 [cp3l (line 51), pd (line 26)], n2 [cp2l (line 49), pd (line 26)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.