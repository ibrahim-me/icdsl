Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}: VIOLATIONS  (DRC 295 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 90: net 'n4': pin ln4pD has no legal access point
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / VGND / VPWR / Y / n1 / n2 / n3 / n4 / n5: on li around (2.3, 0.4): shapes of VGND and Y and n1 and n3 and n5 overlap/touch there (lVGNDnA (line 69), lVGNDnB (line 71), lVGNDnD (line 75), lVGNDnD2 (line 77), lYnC (line 74), ln1nA (line 70), +3 more)
  SHORT Y / n3: on li around (3.142, 0.57): shapes of Y and n3 overlap/touch there (lYnE (line 79), ln3nE (line 78))
  SHORT S / VPWR: joined through contacts/vias: S: liS (line 82); VPWR: lVPWRpA (line 57)
  OPEN net VPWR is 2 separate pieces: [gA1 (line 46), gN1 (line 45), lVGNDnA (line 69), lVGNDnB (line 71), +30 more, template vgnd/vpwr, route n1] | [gS (line 43), lVPWRpA (line 57), liS (line 82), pdA (line 27)] - join them (strap / shared metal / `route VPWR`)
  OPEN net Y is 2 separate pieces: [gA1 (line 46), gN1 (line 45), lVGNDnA (line 69), lVGNDnB (line 71), +30 more, template vgnd/vpwr, route n1] | [lYnE (line 79), ln3nE (line 78), ndE (line 39)] - join them (strap / shared metal / `route Y`)
  OPEN net n3 is 2 separate pieces: [gA1 (line 46), gN1 (line 45), lVGNDnA (line 69), lVGNDnB (line 71), +30 more, template vgnd/vpwr, route n1] | [lYnE (line 79), ln3nE (line 78), ndE (line 39)] - join them (strap / shared metal / `route n3`)
  DEVICE M0 (pmos g=S d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M1 (pmos g=S d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M2 (pmos g=A0 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate A0 at x=1.555 has A1+VGND+VPWR+Y+n1+n2+n3+n4+n5 and A1+VGND+VPWR+Y+n1+n2+n3+n4+n5 on its sides; it needs n2 and Y: the side labelled A1+VGND+VPWR+Y+n1+n2+n3+n4+n5 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=S d=VGND s=n3) has no matching transistor in the layout
  DEVICE M4 (pmos g=n1 d=n4 s=VPWR) has no matching transistor in the layout
  DEVICE M5 (nmos g=n1 d=n5 s=VGND) has no matching transistor in the layout
  DEVICE M6 (nmos g=S d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M7 (pmos g=A1 d=Y s=n4) has no matching transistor in the layout
DRC root causes (ranked; by the statements in your file):
* pdD (line 30: `pdD = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP, pt)        # VPWR | n4  (M4)`) - in 39 of 150 errors: li.3 x24, li.1 x4, li.c1 x4, li.5 x4
    pdD spans x 2.240..2.920, y 1.485..2.485 um
    its position uses pt (line 24: `pt = H - 0.235                     # top of the p row`)
    its position uses x3 (line 21: `x3 = x2 + L + 0.80                  # gate n1 (break: p-row Y vs VPWR, n-row Y vs VGND)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
* ndD (line 38: `ndD = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN)        # VGND | n5  (M5)`) - in 29 of 150 errors: li.3 x19, li.1 x5, li.c1 x5
    ndD spans x 2.240..2.920, y 0.235..0.885 um
    its position uses nb (line 23: `nb = 0.235                          # bottom of the n row`)
    its position uses x3 (line 21: `x3 = x2 + L + 0.80                  # gate n1 (break: p-row Y vs VPWR, n-row Y vs VGND)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
* gN1 (line 45: `gN1 = cross [ndD, pdD] poly w=L cx=x3`) - in 26 of 150 errors: li.3 x17, li.5 x5, licon.1 x2, li.1 x1
    gN1 spans x 2.430..2.580, y 0.105..2.615 um
    its position uses x3 (line 21: `x3 = x2 + L + 0.80                  # gate n1 (break: p-row Y vs VPWR, n-row Y vs VGND)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* pdE (line 31: `pdE = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)        # n4 | Y     (M7)`) - in 24 of 150 errors: li.3 x17, li.1 x3, li.c1 x3, li.5 x1
    pdE spans x 2.670..3.350, y 1.485..2.485 um
    its position uses pt (line 24: `pt = H - 0.235                     # top of the p row`)
    its position uses x4 (line 22: `x4 = x3 + L + 0.28                  # gate A1 (share n4 on p-row; n-row n5 vs n3 needs break but p-row shares)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
WARNING mux2i_1: port S: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by route:n1 on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING mux2i_1: port A0: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by route:n1 on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (5295) than your best so far (5170); your best version is saved as /best.icl.