Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 4 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / Y: on li around (0.977, 1.38): shapes of A and Y overlap/touch there (c1l (line 18), c3l (line 23), gl1 (line 30), ys (line 33))
  DEVICE M0 (nmos g=A d=VGND s=Y) has no matching transistor in the layout
  DEVICE M1 (pmos g=A d=VPWR s=Y) has no matching transistor in the layout
    layout nmos at x=1.15 y=0.66: gate A+Y [g1 (line 12), gp1 (line 29)], source/drain A+Y [c1l (line 18), c3l (line 23), gl1 (line 30), +3 more], VGND [c2l (line 20), c2s (line 21), nd1 (line 13)]
    layout pmos at x=1.15 y=1.93: gate A+Y [g1 (line 12), gp1 (line 29)], source/drain A+Y [c1l (line 18), c3l (line 23), gl1 (line 30), +3 more], VPWR [c4l (line 25), c4s (line 26), pd1 (line 14)]
DRC root causes (ranked; by the statements in your file):
* ys (line 33: `ys = strap li from=c1l to=c3l`) and shapes built from it (ym, yp) - in 4 of 4 errors: mcon.2 x4
    ys spans x 0.850..1.020, y 0.495..2.265 um
    mcon.2: ym [mcon] vs am (line 37) [mcon x 0.935..1.105, y 1.095..1.265]: gap 0.030 um, rule needs >= 0.19 um (short by 0.160 um)
    one fix: move ys up by 0.16 um (or move the other shape the opposite way)
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* gc1 (line 28: `gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb`) and shapes built from it (am, ap, gl1, gp1) - in 4 of 4 errors: mcon.2 x4
    gc1 spans x 0.935..1.105, y 1.095..1.265 um
    mcon.2: am [mcon] vs ym (line 34) [mcon x 0.850..1.020, y 1.295..1.465]: gap 0.030 um, rule needs >= 0.19 um (short by 0.160 um)
    one fix: move gc1 down by 0.16 um - line 28: `bottom=cb` -> `bottom=(cb - 0.16)` (or move the other shape the opposite way)
    its position uses cb (line 27: `cb = max(nd1.top + 0.19, c1l.top + 0.25)`)
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
* g1 (line 12: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A`) - in 2 of 4 errors: mcon.2 x2
    g1 spans x 1.075..1.225, y 0.285..2.435 um
    its position uses ny0 (line 8: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses py1 (line 9: `py1 = ntap.bottom - 0.27              # top of the p row`)
    rule mcon.2: two mcons closer than 0.19 um - e.g. a pin mcon too close to a rail or to another pin's mcon
WARNING inv: port Y: no legal met1/met2 access point for a parent router (0.23 um grid); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
WARNING inv: port A: no legal met1/met2 access point for a parent router (0.23 um grid) (blocked by yp on m1); put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) or keep met1 clear above it
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.