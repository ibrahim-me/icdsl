Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 66: net 'n1': pin nn has no legal access point (blocked by xp on m1: 0.020 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT X / n1: on li around (1.342, 1.38): shapes of X and n1 overlap/touch there (nn (line 56), sxnl (line 29), sxpl (line 40), yx (line 63))
  OPEN net n1 is 3 separate pieces: [gn (line 20), gpn (line 52), nd (line 15), nn (line 56), +5 more] | [nd (line 15), sn1l (line 32)] | [pd (line 16), spnl (line 42)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout
  DEVICE M5 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=1.515 y=0.66: gate X+n1 [gn (line 20), gpn (line 52)], source/drain VGND [gn (line 20), gpn (line 52), nd (line 15), +6 more], X+n1 [gndn (line 33), nd (line 15), svnl (line 30), template ptap/vgnd]
    layout pmos at x=1.515 y=1.93: gate X+n1 [gn (line 20), gpn (line 52)], source/drain VPWR [gn (line 20), gpn (line 52), nd (line 15), +6 more], X+n1 [pd (line 16), pwr1 (line 44), pwr2 (line 45), +2 more, template ntap/vpwr]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.