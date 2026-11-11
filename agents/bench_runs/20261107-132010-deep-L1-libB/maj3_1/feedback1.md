Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WN2': 0.42, 'WP': 1.0, 'WP2': 0.42}: VIOLATIONS  (DRC 136 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / VPWR: on li around (2.99, 2.44): shapes of A and VPWR overlap/touch there (l10 (line 60), l15 (line 65))
  SHORT B / n1: on li around (0.755, 2.35): shapes of B and n1 overlap/touch there (l11 (line 61), l16 (line 66))
  SHORT C / n6: on li around (1.295, 2.35): shapes of C and n6 overlap/touch there (l12 (line 62), l17 (line 67))
  SHORT n1 / n3: on li around (2.04, 2.145): shapes of n1 and n3 overlap/touch there (l13 (line 63), l18 (line 68))
  OPEN net A is 2 separate pieces: [l10 (line 60), l15 (line 65), pd1 (line 37), template vpwr] | [l6 (line 55)] - join them (strap / shared metal / `route A`)
  OPEN net B is 2 separate pieces: [l11 (line 61), l16 (line 66), pd1 (line 37), pd2 (line 38)] | [l7 (line 56)] - join them (strap / shared metal / `route B`)
  OPEN net C is 2 separate pieces: [l12 (line 62), l17 (line 67), pd1 (line 37), pd2 (line 38), +1 more] | [l8 (line 57)] - join them (strap / shared metal / `route C`)
  OPEN net n1 is 2 separate pieces: [l11 (line 61), l16 (line 66), pd1 (line 37), pd2 (line 38)] | [l13 (line 63), l18 (line 68), pd2 (line 38), pd3 (line 39), +1 more] - join them (strap / shared metal / `route n1`)
  OPEN net n3 is 3 separate pieces: [l3 (line 52), nd1 (line 31), nd2 (line 32), nd3 (line 33)] | [l13 (line 63), l18 (line 68), pd2 (line 38), pd3 (line 39), +1 more] | [l9 (line 58)] - join them (strap / shared metal / `route n3`)
  DEVICE M0 (pmos g=A d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M3 (nmos g=n3 d=VGND s=X) has no matching transistor in the layout
  DEVICE M5 (nmos g=A d=n5 s=VGND) has no matching transistor in the layout
  DEVICE M6 (pmos g=B d=n3 s=n6) has no matching transistor in the layout
  DEVICE M7 (pmos g=C d=n6 s=VPWR) has no matching transistor in the layout
DRC root causes (ranked; by the statements in your file):
* pd2 (line 38: `pd2 = rect diff xspan=(x2 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)`) - in 36 of 136 errors: li.3 x35, li.c2 x1
    pd2 spans x 0.675..1.895, y 2.065..2.485 um
    its position uses x2 (line 24: `x2 = x1 + L + max(0.28, 0.54 - L)  # gate B`)
    its position uses pt (line 28: `pt = H - 0.235                     # top of the p row`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
* pd3 (line 39: `pd3 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)`) - in 35 of 136 errors: li.3 x35
    pd3 spans x 1.215..2.845, y 2.065..2.485 um
    its position uses pt (line 28: `pt = H - 0.235                     # top of the p row`)
    its position uses x3 (line 25: `x3 = x2 + L + max(0.28, 0.54 - L)  # gate C`)
    rule li.3: two li shapes of different nets closer than 0.17 um
* p4 (line 47: `p4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)`) - in 35 of 136 errors: li.3 x34, li.5 x1
    p4 spans x 2.430..2.580, y 0.105..2.615 um
    its position uses x4 (line 26: `x4 = x3 + L + 0.80                 # gate n3 (island break: 0.80 gap)`)
    rule li.3: two li shapes of different nets closer than 0.17 um
* pd1 (line 37: `pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP2, pt)`) - in 32 of 136 errors: li.3 x31, li.c2 x1
    pd1 spans x 0.135..1.355, y 2.065..2.485 um
    its position uses x2 (line 24: `x2 = x1 + L + max(0.28, 0.54 - L)  # gate B`)
    its position uses x1 (line 23: `x1 = 0.40                          # gate A`)
    rule li.3: two li shapes of different nets closer than 0.17 um
    rule li.c2: two li shapes closer than 0.14 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.