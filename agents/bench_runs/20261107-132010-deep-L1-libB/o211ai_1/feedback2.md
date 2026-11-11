Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}: VIOLATIONS  (DRC 81 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VPWR / Y / n1: on li around (1.84, 2.15): shapes of VPWR and Y and n1 overlap/touch there (l10 (line 51), l11 (line 52), l12 (line 53), l13 (line 54), l9 (line 50), strap_line88 (line 88), +2 more)
  OPEN net Y is 2 separate pieces: [l8 (line 47), nd2 (line 24)] | [l10 (line 51), l11 (line 52), l12 (line 53), l13 (line 54), +6 more, template vpwr] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout
  DEVICE M1 (pmos g=A1 d=VPWR s=n1) has no matching transistor in the layout
  DEVICE M4 (pmos g=C1 d=VPWR s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout
  DEVICE M7 (pmos g=B1 d=Y s=VPWR) has no matching transistor in the layout
    layout nmos at x=1.035 y=0.56: gate ?11 [g2 (line 33)], source/drain ?1 [nd1 (line 23)], n2 [l6 (line 45), nd1 (line 23), nd2 (line 24)]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=0.495 y=1.985: gate ?10 [g1 (line 32)], source/drain ?6 [pd1 (line 26)], VPWR+Y+n1 [l10 (line 51), l11 (line 52), l12 (line 53), +7 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.035 y=1.985: gate ?11 [g2 (line 33)], source/drain ?6 [pd1 (line 26)], VPWR+Y+n1 [l10 (line 51), l11 (line 52), l12 (line 53), +7 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=1.575 y=1.985: gate ?12 [g3 (line 34)], source/drain ?8 [pd2 (line 27)], VPWR+Y+n1 [l10 (line 51), l11 (line 52), l12 (line 53), +7 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
    layout pmos at x=2.115 y=1.985: gate ?13 [g4 (line 35)], source/drain ?8 [pd2 (line 27)], VPWR+Y+n1 [l10 (line 51), l11 (line 52), l12 (line 53), +7 more]  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion piece with no contact - fine only for a series node)
DRC root causes (ranked; by the statements in your file):
* nd2 (line 24: `nd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN)`) - in 38 of 81 errors: li.6 x10, li.1 x8, li.c1 x8, li.5 x6
    nd2 spans x 1.235..2.455, y 0.235..0.885 um
    its position uses nb (line 19: `nb = 0.235                          # bottom of the n row`)
    its position uses x3 (line 17: `x3 = x2 + L + max(0.28, 0.54 - L)`)
* nd1 (line 23: `nd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN)`) - in 26 of 81 errors: li.5 x8, li.1 x6, li.c1 x6, li.6 x4
    nd1 spans x 0.155..1.375, y 0.235..0.885 um
    its position uses nb (line 19: `nb = 0.235                          # bottom of the n row`)
    its position uses x2 (line 16: `x2 = x1 + L + max(0.28, 0.54 - L)`)
* pd1 (line 26: `pd1 = rect diff xspan=(x1 - 0.265, x2 + L + 0.265) yspan=(pt - WP, pt)`) - in 21 of 81 errors: licon.1 x6, li.5 x5, licon.2 x4, li.1 x3
    pd1 spans x 0.155..1.375, y 1.485..2.485 um
    its position uses x2 (line 16: `x2 = x1 + L + max(0.28, 0.54 - L)`)
    its position uses x1 (line 15: `x1 = 0.42`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.2: two licons closer than 0.17 um
* pd2 (line 27: `pd2 = rect diff xspan=(x3 - 0.265, x4 + L + 0.265) yspan=(pt - WP, pt)`) - in 21 of 81 errors: licon.1 x6, licon.2 x4, li.1 x4, li.c1 x4
    pd2 spans x 1.235..2.455, y 1.485..2.485 um
    its position uses pt (line 20: `pt = H - 0.235                     # top of the p row`)
    its position uses x3 (line 17: `x3 = x2 + L + max(0.28, 0.54 - L)`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.2: two licons closer than 0.17 um
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.
NOTE: this version scores worse (5081) than your best so far (5020); your best version is saved as /best.icl.