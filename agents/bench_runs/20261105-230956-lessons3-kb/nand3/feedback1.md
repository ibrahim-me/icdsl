Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 20 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 64: net 'Y': pin yp1 has no legal access point (blocked by vgnd on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / Y: on m1 around (1.38, 0.132): shapes of VGND and Y overlap/touch there (yp1 (line 63), template vgnd)
  SHORT VPWR / Y: on li around (1.38, 2.2): shapes of VPWR and Y overlap/touch there (o1l (line 35), o2l (line 36), p1 (line 39), p2 (line 40), s1l (line 34), s3l (line 37), +1 more)
  OPEN net Y is 2 separate pieces: [gnd (line 38), nd (line 17), snl (line 32), yp1 (line 63), template ptap/vgnd] | [o1l (line 35), o2l (line 36), p1 (line 39), p2 (line 40), +4 more, template ntap/vpwr] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A d=VPWR s=Y) has no matching transistor in the layout - the pmos with gate A at x=0.84 has VPWR+Y and VPWR+Y on its sides; it needs VPWR and Y: the side labelled VPWR+Y should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=C d=VGND s=n1) has no matching transistor in the layout - the nmos with gate C at x=1.92 has ?14 and ?2 on its sides; it needs VGND and n1: the side labelled ?14 should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=A d=n2 s=Y) has no matching transistor in the layout - the nmos with gate A at x=0.84 has ?1 and VGND+Y on its sides; it needs n2 and Y: the side labelled ?1 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M4 (pmos g=C d=VPWR s=Y) has no matching transistor in the layout - the pmos with gate C at x=1.92 has VPWR+Y and VPWR+Y on its sides; it needs VPWR and Y: the side labelled VPWR+Y should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (pmos g=B d=Y s=VPWR) has no matching transistor in the layout - the pmos with gate B at x=1.38 has VPWR+Y and VPWR+Y on its sides; it needs Y and VPWR: the side labelled VPWR+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=0.84 y=0.66: gate A [ga (line 22), gpa (line 47)], source/drain ?1 [nd (line 17)], VGND+Y [gnd (line 38), nd (line 17), snl (line 32)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout nmos at x=1.92 y=0.66: gate C [gcg (line 24), gpc (line 49)], source/drain ?14 [dnl (line 33), nd (line 17)], ?2 [nd (line 17)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=0.84 y=1.93: gate A [ga (line 22), gpa (line 47)], source/drain VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more], VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more]
    layout pmos at x=1.38 y=1.93: gate B [gb (line 23), gpb (line 48)], source/drain VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more], VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more]
    layout pmos at x=1.92 y=1.93: gate C [gcg (line 24), gpc (line 49)], source/drain VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more], VPWR+Y [o1l (line 35), o2l (line 36), p1 (line 39), +5 more]
DRC root causes (ranked; by the statements in your file):
* pd (line 18: `pd  = rect diff w=pdw h=WP cx=cell.cx below=ntap`) - in 18 of 20 errors: poly.7 x10, licon.1 x4, licon.5a x4
    pd spans x 0.610..2.150, y 1.555..2.305 um
    its position uses pdw (line 15: `pdw = 0.53 + 3*L + 2*0.28          # p-row: VPWR | A | Y | B | VPWR | C | Y`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* p1 (line 39: `p1  = strap li from=s1l to=vpwr_li`) - in 9 of 20 errors: poly.7 x5, licon.1 x2, licon.5a x2
    p1 spans x 0.540..0.710, y 1.595..2.805 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* s1 (line 28: `s1  = array licon in=pd left_of=ga            # VPWR`) and shapes built from it (s1l) - in 9 of 20 errors: poly.7 x5, licon.1 x2, licon.5a x2
    s1 spans x 0.540..0.710, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* s3 (line 31: `s3  = array licon in=pd right_of=gcg          # Y`) and shapes built from it (s3l) - in 9 of 20 errors: poly.7 x5, licon.1 x2, licon.5a x2
    s3 spans x 2.050..2.220, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
WARNING nand3: port Y: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by vgnd on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.