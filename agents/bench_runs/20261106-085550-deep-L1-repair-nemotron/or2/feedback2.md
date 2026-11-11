Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 27 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* c8 (line 60: `c8 = array licon in=pd2 left_of=g3              # X contact (M5.s)`) and shapes built from it (c8l) - in 11 of 27 errors: poly.7 x6, licon.1 x3, licon.5a x2
    c8 spans x 2.015..2.185, y 1.675..2.185 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* pd2 (line 29: `pd2 = rect diff xspan=(g3x - 0.265, g3x + L + 0.265) yspan=(py1 - WP, py1)     # X-n2-VPWR (M5)`) - in 11 of 27 errors: poly.7 x6, licon.1 x3, licon.5a x2
    pd2 spans x 2.050..2.730, y 1.555..2.305 um
    its position uses py1 (line 13: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses g3x (line 22: `g3x = g2x + L + gbreak`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* nd2 (line 26: `nd2 = rect diff xspan=(g3x - 0.265, g3x + L + 0.265) yspan=(ny0, ny0 + WN)     # VGND-n2-X (M1)`) - in 6 of 27 errors: poly.7 x4, licon.1 x1, licon.5a x1
    nd2 spans x 2.050..2.730, y 0.415..0.905 um
    its position uses ny0 (line 12: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    its position uses g3x (line 22: `g3x = g2x + L + gbreak`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* c4 (line 48: `c4 = array licon in=nd2 left_of=g3              # VGND contact (M1.d)`) and shapes built from it (c4l) - in 6 of 27 errors: poly.7 x4, licon.1 x1, licon.5a x1
    c4 spans x 2.015..2.185, y 0.575..0.745 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.