Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 28 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT Y / n2: on li around (2.15, 1.93): shapes of Y and n2 overlap/touch there (cp3l (line 56), cp4l (line 58))
  DEVICE M0 (nmos g=B1 d=n1 s=Y) has no matching transistor in the layout - the nmos with gate B1 at x=1.88 has Y+n2 and n1 on its sides; it needs n1 and Y: the side labelled Y+n2 should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=A2 d=n2 s=VPWR) has no matching transistor in the layout - the pmos with gate A2 at x=0.8 has VPWR and Y+n2 on its sides; it needs n2 and VPWR: the side labelled Y+n2 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (pmos g=A1 d=VPWR s=n2) has no matching transistor in the layout - the pmos with gate A1 at x=1.34 has Y+n2 and Y+n2 on its sides; it needs VPWR and n2: the side labelled Y+n2 should be VPWR (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M5 (pmos g=B2 d=Y s=n2) has no matching transistor in the layout
  DEVICE M6 (nmos g=A1 d=Y s=n3) has no matching transistor in the layout - the nmos with gate A1 at x=1.34 has Y+n2 and n3 on its sides; it needs Y and n3: the side labelled Y+n2 should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M7 (pmos g=B1 d=n2 s=Y) has no matching transistor in the layout - the pmos with gate B1 at x=1.88 has Y+n2 and Y+n2 on its sides; it needs n2 and Y: the side labelled Y+n2 should be n2 (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=1.34 y=0.66: gate A1 [g2 (line 23), gp2 (line 69)], source/drain Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more], n3 [cn1l (line 38), nd (line 27)]
    layout nmos at x=1.88 y=0.66: gate B1 [g3 (line 24), gp3 (line 72)], source/drain Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more], n1 [cn3l (line 42), nd (line 27)]
    layout pmos at x=0.8 y=1.93: gate A2 [g1 (line 22), gp1 (line 66)], source/drain VPWR [cp0l (line 49), cp0s (line 50), cp5l (line 60), +3 more], Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more]
    layout pmos at x=1.34 y=1.93: gate A1 [g2 (line 23), gp2 (line 69)], source/drain Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more], Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more]
    layout pmos at x=1.88 y=1.93: gate B1 [g3 (line 24), gp3 (line 72)], source/drain Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more], Y+n2 [cn2l (line 40), cp1l (line 52), cp2l (line 54), +4 more]
DRC root causes (ranked; by the statements in your file):
* nwell (line 79: `well y=((max(nd.top) + 0.34 + min(pd.bottom) - 0.18) / 2)`) - in 22 of 28 errors: diff/tap.8 x16, diff/tap.10 x4, nwell.2a x1, nwell.1 x1
    nwell spans x 0.000..3.220, y 1.310..3.045 um
    nwell.2a: nwell [nwell] vs g3 (line 24) [poly x 1.805..1.955, y 0.285..2.435]: they overlap by 1.125 um, rule needs >= 1.27 um (short by 2.395 um)
    one fix: move nwell left by 2.4 um (or move the other shape the opposite way)
* pd (line 28: `pd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)`) and shapes built from it (pim) - in 21 of 28 errors: diff/tap.8 x16, diff/tap.10 x2, nwell.2a x1, nwell.1 x1
    pd spans x 0.460..2.220, y 1.555..2.305 um
    its position uses py1 (line 18: `py1 = ntap.bottom - 0.27`)
* pbreak (line 29: `pbreak = rect diff w=0.80 h=WP left=(g3.right + 0.265 + 0.40) bottom=(py1 - WP)`) - in 18 of 28 errors: diff/tap.8 x12, licon.1 x2, licon.5a x2, nwell.1 x1
    pbreak spans x 2.620..3.420, y 1.555..2.305 um
    its position uses py1 (line 18: `py1 = ntap.bottom - 0.27`)
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* cp5 (line 59: `cp5 = array licon in=pbreak right_of=g4`) and shapes built from it (cp5l) - in 4 of 28 errors: licon.1 x2, licon.5a x2
    cp5 spans x 2.550..2.720, y 1.675..2.185 um
    rule licon.1: a contact is not exactly 0.17 x 0.17 - usually two shapes merged/overlapping into a template contact (often your shape sits on the tap row)
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.