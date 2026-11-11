Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 6 errors, LVS MATCH)
DRC root causes (ranked; by the statements in your file):
* nd1 (line 22: `nd1 = rect diff xspan=(g1.left - 0.18, g3.right + 0.265) yspan=(ny0, ny0 + WN)`) - in 6 of 6 errors: poly.7 x3, licon.1 x2, licon.5a x1
    nd1 spans x 0.610..2.695, y 0.415..0.905 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* c1 (line 27: `c1 = array licon in=nd1 left_of=g1`) and shapes built from it (c1l) - in 6 of 6 errors: poly.7 x3, licon.1 x2, licon.5a x1
    c1 spans x 0.565..0.735, y 0.575..0.745 um
    rule poly.7: the diffusion must extend 0.25 um beyond the gate (room for the source/drain contact)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* g1 (line 19: `g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2`) - in 2 of 6 errors: licon.1 x2
    g1 spans x 0.790..0.940, y 0.285..2.435 um
    its position uses py1 (line 16: `py1 = ntap.bottom - 0.27              # top of the p row`)
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.