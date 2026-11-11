Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.42, 'WP': 0.59}: VIOLATIONS  (DRC 10 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 57: net 'n1': pin cn1l has no legal access point (blocked by vgnd on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT X / n1: on li around (1.475, 1.317): shapes of X and n1 overlap/touch there (cn1l (line 24), cp1l (line 36), cxnl (line 25), cxpl (line 37), xy (line 43))
  OPEN net n1 is 2 separate pieces: [cn1l (line 24), cp1l (line 36), cxnl (line 25), cxpl (line 37), +4 more] | [gn (line 16), gpn (line 50), nn (line 53)] - join them (strap / shared metal / `route n1`)
  DEVICE M0 (nmos g=n1 d=VGND s=X) has no matching transistor in the layout - the nmos with gate n1 at x=1.95 has VGND and X+n1 on its sides; it needs VGND and X: the side labelled X+n1 should be X (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout - the pmos with gate A at x=1.0 has VPWR and X+n1 on its sides; it needs n1 and VPWR: the side labelled X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout - the nmos with gate A at x=1.0 has VGND and X+n1 on its sides; it needs n1 and VGND: the side labelled X+n1 should be n1 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (pmos g=n1 d=VPWR s=X) has no matching transistor in the layout - the pmos with gate n1 at x=1.95 has VPWR and X+n1 on its sides; it needs VPWR and X: the side labelled X+n1 should be X (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.0 y=0.625: gate A [ga (line 15), gpa (line 49)], source/drain VGND [cn0l (line 23), cn3l (line 26), gndn (line 27), +2 more], X+n1 [cn1l (line 24), cp1l (line 36), cxnl (line 25), +4 more]
    layout nmos at x=1.95 y=0.625: gate n1 [gn (line 16), gpn (line 50)], source/drain VGND [cn0l (line 23), cn3l (line 26), gndn (line 27), +2 more], X+n1 [cn1l (line 24), cp1l (line 36), cxnl (line 25), +4 more]
    layout pmos at x=1.0 y=2.01: gate A [ga (line 15), gpa (line 49)], source/drain VPWR [cp0l (line 35), cp3l (line 38), pd (line 12), +2 more], X+n1 [cn1l (line 24), cp1l (line 36), cxnl (line 25), +4 more]
    layout pmos at x=1.95 y=2.01: gate n1 [gn (line 16), gpn (line 50)], source/drain VPWR [cp0l (line 35), cp3l (line 38), pd (line 12), +2 more], X+n1 [cn1l (line 24), cp1l (line 36), cxnl (line 25), +4 more]
DRC root causes (ranked; by the statements in your file):
* pwrp2 (line 40: `pwrp2 = strap li from=cp3l to=vpwr_li`) - in 5 of 10 errors: poly.7 x3, licon.1 x1, licon.5a x1
    pwrp2 spans x 2.080..2.250, y 1.845..2.805 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* cp3 (line 34: `cp3 = array licon in=pd right_of=gn`) and shapes built from it (cp3l) - in 5 of 10 errors: poly.7 x3, licon.1 x1, licon.5a x1
    cp3 spans x 2.080..2.250, y 1.925..2.095 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* pd (line 12: `pd  = rect diff w=dw h=WP cx=cell.cx below=ntap`) - in 5 of 10 errors: poly.7 x3, licon.1 x1, licon.5a x1
    pd spans x 0.660..2.100, y 1.715..2.305 um
    its position uses dw (line 10: `dw  = 2*L + 1.14                      # 2 x 0.265 end contacts + 0.80 island break + 2 x L gates`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* cn3 (line 22: `cn3 = array licon in=nd right_of=gn`) and shapes built from it (cn3l) - in 5 of 10 errors: poly.7 x3, licon.1 x1, licon.5a x1
    cn3 spans x 2.080..2.250, y 0.540..0.710 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.