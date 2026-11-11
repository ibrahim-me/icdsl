Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 104: net 'Y': no legal path to cpYl, yp2
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  OPEN net Y is 3 separate pieces: [cyl (line 39), nd (line 18), yp (line 102)] | [cpYl (line 56), pd (line 19)] | [yp2 (line 103)] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=S d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M1 (pmos g=S d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M2 (pmos g=A0 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M4 (pmos g=n1 d=n4 s=VPWR) has no matching transistor in the layout
  DEVICE M7 (pmos g=A1 d=Y s=n4) has no matching transistor in the layout
    layout pmos at x=1.22 y=1.93: gate n1 [gN1 (line 24), gpN1 (line 69)], source/drain VPWR [cn1l (line 42), cp1l (line 53), gN1 (line 24), +4 more, route n1], n1 [cpV2l (line 58), cpVl (line 54), pd (line 19), +2 more, template ntap/vpwr]
    layout pmos at x=1.76 y=1.93: gate A0 [gA0 (line 25), gpA0 (line 70)], source/drain VPWR [cpV2l (line 58), cpVl (line 54), pd (line 19), +2 more, template ntap/vpwr], n2 [cp2l (line 55), pd (line 19)]
    layout pmos at x=2.3 y=1.93: gate A1 [gA1 (line 26), gpA1 (line 71)], source/drain Y [cp2l (line 55), pd (line 19)], n2 [cpYl (line 56), pd (line 19)]
    layout pmos at x=2.84 y=1.93: gate S [gS3 (line 27), gpS3 (line 72)], source/drain Y [cpYl (line 56), pd (line 19)], n4 [cp4l (line 57), pd (line 19)]
    layout pmos at x=3.38 y=1.93: gate S [gS6 (line 28), gpS6 (line 73)], source/drain VPWR [cp4l (line 57), pd (line 19)], n4 [cpV2l (line 58), cpVl (line 54), pd (line 19), +2 more, template ntap/vpwr]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.