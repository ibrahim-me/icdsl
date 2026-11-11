Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT n3 / n5: on li around (2.03, 0.66): shapes of n3 and n5 overlap/touch there (c3l (line 38), c4l (line 40))
  OPEN net S is 2 separate pieces: [g1 (line 21), gl1 (line 64), gp1 (line 63), sp (line 80)] | [g2 (line 22), gl2 (line 67), gp2 (line 66)] - join them (strap / shared metal / `route S`)
  OPEN net Y is 2 separate pieces: [c5l (line 42), nd2 (line 27), yp (line 89)] | [c10l (line 55), pd (line 28)] - join them (strap / shared metal / `route Y`)
  DEVICE M3 (nmos g=S d=VGND s=n3) has no matching transistor in the layout - the nmos with gate S at x=1.76 has VGND and n3+n5 on its sides; it needs VGND and n3: the side labelled n3+n5 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M8 (nmos g=A1 d=Y s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=2.84 has VGND and Y on its sides; it needs Y and n3: the side labelled VGND should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M9 (nmos g=A0 d=n5 s=Y) has no matching transistor in the layout - the nmos with gate A0 at x=2.3 has Y and n3+n5 on its sides; it needs n5 and Y: the side labelled n3+n5 should be n5 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.76 y=0.66: gate S [g2 (line 22), gp2 (line 66)], source/drain VGND [c2l (line 35), c2s (line 36), c6l (line 44), +3 more], n3+n5 [c3l (line 38), c4l (line 40), nd1 (line 26), +1 more]
    layout nmos at x=2.3 y=0.66: gate A0 [g3 (line 23), gp3 (line 69)], source/drain Y [c5l (line 42), nd2 (line 27)], n3+n5 [c3l (line 38), c4l (line 40), nd1 (line 26), +1 more]
    layout nmos at x=2.84 y=0.66: gate A1 [g4 (line 24), gp4 (line 72)], source/drain VGND [c2l (line 35), c2s (line 36), c6l (line 44), +3 more], Y [c5l (line 42), nd2 (line 27)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.