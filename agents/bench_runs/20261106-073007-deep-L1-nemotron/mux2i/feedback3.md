Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 97: net 'n3': pin sn3bl has no legal access point (blocked by route:n5 on m1: 0.000 < 0.140 um)
  line 99: net 'Y': pin sYnl has no legal access point (blocked by route:n5 on m1: 0.040 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / n3 / n5: joined through contacts/vias: VGND: dvgl (line 48), gnd1 (line 87), gnd2 (line 88), +3 more, template ptap/vgnd; n3: sn3bl (line 51); n5: dn5al (line 50), dn5bl (line 54), route n5
  SHORT VPWR / n1: joined through contacts/vias: VPWR: pwr1 (line 90), pwr2 (line 91), svp1l (line 75), +1 more, template ntap/vpwr; n1: dn1nl (line 56), dn1pl (line 76), sn1g (line 117), route n1
  OPEN net S is 2 separate pieces: [ap (line 127), g1 (line 24), gp1 (line 109), sS1 (line 116)] | [g5 (line 28), gp5 (line 113), sS2 (line 120)] - join them (strap / shared metal / `route S`)
  OPEN net VPWR is 2 separate pieces: [dn1nl (line 56), dn1pl (line 76), g2 (line 25), gp2 (line 110), +7 more, template ntap/vpwr, route n1] | [dvpl (line 84), pd (line 20)] - join them (strap / shared metal / `route VPWR`)
  OPEN net Y is 2 separate pieces: [dYnl (line 52), nd (line 19), sYnl (line 53)] | [dYpl (line 80), pd (line 20), sYpl (line 81), yp (line 133)] - join them (strap / shared metal / `route Y`)
  OPEN net n3 is 2 separate pieces: [nd (line 19), sn3al (line 47)] | [dn5al (line 50), dn5bl (line 54), dvgl (line 48), gnd1 (line 87), +6 more, template ptap/vgnd, route n5] - join them (strap / shared metal / `route n3`)
  DEVICE M0 (pmos g=S d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate S at x=0.63 has VPWR+n1 and VPWR+n1 on its sides; it needs n1 and VPWR: the side labelled VPWR+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=S d=VGND s=n3) has no matching transistor in the layout - the nmos with gate S at x=0.63 has VGND+n3+n5 and n3 on its sides; it needs VGND and n3: the side labelled VGND+n3+n5 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (pmos g=n1 d=n4 s=VPWR) has no matching transistor in the layout
  DEVICE M5 (nmos g=n1 d=n5 s=VGND) has no matching transistor in the layout
  DEVICE M6 (nmos g=S d=n1 s=VGND) has no matching transistor in the layout - the nmos with gate S at x=0.63 has VGND+n3+n5 and n3 on its sides; it needs n1 and VGND: the side labelled VGND+n3+n5 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M8 (nmos g=A1 d=Y s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=2.53 has VGND+n3+n5 and Y on its sides; it needs Y and n3: the side labelled VGND+n3+n5 should be n3 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M9 (nmos g=A0 d=n5 s=Y) has no matching transistor in the layout - the nmos with gate A0 at x=3.48 has VGND+n3+n5 and Y on its sides; it needs n5 and Y: the side labelled VGND+n3+n5 should be n5 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=0.63 y=0.66: gate S [g1 (line 24), gp1 (line 109)], source/drain VGND+n3+n5 [dn5al (line 50), dn5bl (line 54), dvgl (line 48), +7 more], n3 [nd (line 19), sn3al (line 47)]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.