Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.65, 'WP': 1.0}: VIOLATIONS  (DRC 32 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / Y: on li around (2.3, 0.41): shapes of VGND and Y overlap/touch there (l1 (line 50), l2 (line 51), l8 (line 57), strap_line96 (line 96), strap_line97 (line 97))
  SHORT A1_N / A2_N / B1 / B2 / VPWR / n1 / n4: on li around (2.3, 2.155): shapes of A1_N and A2_N and B1 and B2 and VPWR and n1 and n4 overlap/touch there (l10 (line 60), l11 (line 61), l12 (line 62), l13 (line 63), l14 (line 64), l16 (line 66), +2 more)
  SHORT A2_N / B2: on li around (1.285, 1.16): shapes of A2_N and B2 overlap/touch there (l4 (line 53), l5 (line 54))
  OPEN net A1_N is 2 separate pieces: [l10 (line 60), l11 (line 61), l12 (line 62), l13 (line 63), +7 more, template vpwr] | [l6 (line 55)] - join them (strap / shared metal / `route A1_N`)
  OPEN net A2_N is 2 separate pieces: [l10 (line 60), l11 (line 61), l12 (line 62), l13 (line 63), +7 more, template vpwr] | [l4 (line 53), l5 (line 54)] - join them (strap / shared metal / `route A2_N`)
  OPEN net B1 is 2 separate pieces: [l10 (line 60), l11 (line 61), l12 (line 62), l13 (line 63), +7 more, template vpwr] | [l3 (line 52)] - join them (strap / shared metal / `route B1`)
  OPEN net B2 is 2 separate pieces: [l10 (line 60), l11 (line 61), l12 (line 62), l13 (line 63), +7 more, template vpwr] | [l4 (line 53), l5 (line 54)] - join them (strap / shared metal / `route B2`)
  DEVICE M0 (pmos g=A2_N d=n1 s=n2) has no matching transistor in the layout
  DEVICE M1 (nmos g=B1 d=n3 s=VGND) has no matching transistor in the layout
  DEVICE M2 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M3 (pmos g=n2 d=Y s=n4) has no matching transistor in the layout
  DEVICE M4 (pmos g=B1 d=VPWR s=n4) has no matching transistor in the layout
  DEVICE M5 (pmos g=B2 d=n4 s=VPWR) has no matching transistor in the layout
  DEVICE M6 (nmos g=A2_N d=n2 s=VGND) has no matching transistor in the layout
DRC root causes (ranked; by the statements in your file):
* pd1 (line 33: `pd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.27) yspan=(pt - WP, pt)   # M4,M5: VPWR-n4-VPWR`) - in 13 of 32 errors: li.5 x5, licon.2 x2, licon.1 x2, licon.5a x2
    pd1 spans x 0.135..1.365, y 1.485..2.485 um
    its position uses pt (line 26: `pt = H - 0.235                     # top of the p row`)
    its position uses x1 (line 20: `x1 = 0.405                          # B1  (M4 pmos, M1 nmos)`)
    rule licon.2: two licons closer than 0.17 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
* nd1 (line 28: `nd1 = rect diff xspan=(x1 - 0.27, x2 + L + 0.27) yspan=(nb, nb + WN)   # M1,M2: VGND-n3-Y`) - in 8 of 32 errors: licon.2 x4, li.3 x2, licon.5c x2
    nd1 spans x 0.135..1.365, y 0.235..0.885 um
    its position uses nb (line 25: `nb = 0.235                          # bottom of the n row`)
    its position uses x1 (line 20: `x1 = 0.405                          # B1  (M4 pmos, M1 nmos)`)
    rule licon.2: two licons closer than 0.17 um
    rule li.3: two li shapes of different nets closer than 0.17 um
* l10 (line 60: `l10 = rect li xspan=(x1 - 0.33, x1 - 0.05) yspan=(pt - WP + 0.02, H + 0.085) net=B1`) - in 8 of 32 errors: licon.2 x2, li.5 x2, licon.5c x2, licon.1 x1
    l10 spans x 0.075..0.355, y 1.505..2.805 um
    its position uses pt (line 26: `pt = H - 0.235                     # top of the p row`)
    its position uses x1 (line 20: `x1 = 0.405                          # B1  (M4 pmos, M1 nmos)`)
    rule licon.2: two licons closer than 0.17 um
* pd2 (line 34: `pd2 = rect diff xspan=(x3 - 0.27, x4 + L + 0.27) yspan=(pt - WP, pt)   # M0,M8: n2-n1-VPWR`) - in 8 of 32 errors: li.5 x4, licon.1 x2, licon.5a x2
    pd2 spans x 1.215..2.445, y 1.485..2.485 um
    its position uses x4 (line 23: `x4 = x3 + L + max(0.28, 0.54 - L)   # A1_N (M8 pmos, M7 nmos)`)
    its position uses pt (line 26: `pt = H - 0.235                     # top of the p row`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.