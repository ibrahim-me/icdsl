Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / Y / n2 / n3: on li around (1.61, 0.37): shapes of VGND and Y and n2 and n3 overlap/touch there (lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), ln3 (line 39), lvgnd_n (line 36))
  SHORT VPWR / Y / n1: on li around (1.61, 2.17): shapes of VPWR and Y and n1 overlap/touch there (lY_p1 (line 44), lY_p2 (line 45), lY_p3 (line 46), ln1 (line 43), lvpwr_p (line 42))
  OPEN net Y is 2 separate pieces: [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), ln3 (line 39), +3 more, template vgnd] | [lY_p1 (line 44), lY_p2 (line 45), lY_p3 (line 46), ln1 (line 43), +3 more, template vpwr] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout
  DEVICE M1 (pmos g=A1 d=VPWR s=n1) has no matching transistor in the layout
  DEVICE M2 (nmos g=A1 d=n2 s=VGND) has no matching transistor in the layout
  DEVICE M3 (nmos g=C1 d=n3 s=Y) has no matching transistor in the layout
  DEVICE M4 (pmos g=C1 d=VPWR s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout
  DEVICE M6 (nmos g=B1 d=n2 s=n3) has no matching transistor in the layout
  DEVICE M7 (pmos g=B1 d=Y s=VPWR) has no matching transistor in the layout
    layout nmos at x=0.475 y=0.675: gate ?10 [gA1 (line 31)], source/drain ?0 [nd1 (line 23)], VGND+Y+n2+n3 [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), +4 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.015 y=0.675: gate ?11 [gA2 (line 32)], source/drain VGND+Y+n2+n3 [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), +4 more], VGND+Y+n2+n3 [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), +4 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.555 y=0.56: gate ?12 [gB1 (line 33)], source/drain VGND+Y+n2+n3 [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), +4 more], VGND+Y+n2+n3 [lY_n (line 40), ln2_bridge (line 38), ln2_nd1 (line 37), +4 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.