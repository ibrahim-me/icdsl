Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75, 'WP2': 0.52}: VIOLATIONS  (DRC 2 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT VGND / Y: on li around (1.38, 0.37): shapes of VGND and Y overlap/touch there (c5l (line 46), c5s (line 47), c7l (line 51), c7s (line 52), c8l (line 56))
  DEVICE M0 (pmos g=A2 d=n1 s=Y) has no matching transistor in the layout - the pmos with gate A2 at x=1.38 has VGND+Y and n1 on its sides; it needs n1 and Y: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M1 (pmos g=B1 d=Y s=VPWR) has no matching transistor in the layout - the pmos with gate B1 at x=1.92 has VGND+Y and VPWR on its sides; it needs Y and VPWR: the side labelled VGND+Y should be Y (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M2 (nmos g=A1 d=n2 s=VGND) has no matching transistor in the layout - the nmos with gate A1 at x=0.84 has VGND+Y and n2 on its sides; it needs n2 and VGND: the side labelled VGND+Y should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
  DEVICE M3 (nmos g=B1 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=A2 d=VGND s=n2) has no matching transistor in the layout - the nmos with gate A2 at x=1.38 has VGND+Y and n2 on its sides; it needs VGND and n2: the side labelled VGND+Y should be VGND (wrong net label on that contact column, or the gates are in the wrong order)
    layout nmos at x=0.84 y=0.66: gate A1 [g1 (line 19), gp1 (line 63)], source/drain VGND+Y [c3l (line 39), c5l (line 46), c5s (line 47), +5 more], n2 [c6l (line 49), c9l (line 58), nd1 (line 28)]
    layout nmos at x=1.38 y=0.66: gate A2 [g2 (line 20), gp2 (line 66)], source/drain VGND+Y [c3l (line 39), c5l (line 46), c5s (line 47), +5 more], n2 [c6l (line 49), c9l (line 58), nd1 (line 28)]
    layout pmos at x=1.38 y=1.93: gate A2 [g2 (line 20), gp2 (line 66)], source/drain VGND+Y [c3l (line 39), c5l (line 46), c5s (line 47), +5 more], n1 [c2l (line 37), pd1 (line 24)]
    layout pmos at x=1.92 y=1.93: gate B1 [g3 (line 21), gp3 (line 69)], source/drain VGND+Y [c3l (line 39), c5l (line 46), c5s (line 47), +5 more], VPWR [c1l (line 34), c1s (line 35), c4l (line 41), +2 more]
DRC root causes (ranked; by the statements in your file):
* nd2 (line 29: `nd2 = rect diff xspan=(g2.right + 0.80, g3.right + 0.265) yspan=(ny0, ny0 + WN)`) - in 1 of 2 errors: diff/tap.1 x1
    nd2 spans x 2.255..2.260, y 0.415..0.905 um
    its position uses ny0 (line 15: `ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)`)
    rule diff/tap.1: a diffusion strip narrower than 0.15 um
* c7 (line 50: `c7 = array licon in=nd1 right_of=g2`) and shapes built from it (c7l) - in 1 of 2 errors: licon.5a x1
    c7 spans x 1.510..1.680, y 0.575..0.745 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c8 (line 55: `c8 = array licon in=nd2 left_of=g3`) and shapes built from it (c8l) - in 1 of 2 errors: licon.5a x1
    c8 spans x 1.620..1.790, y 0.575..0.745 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
* c7s (line 52: `c7s = strap li from=c7l to=vgnd_li`) - in 1 of 2 errors: licon.5a x1
    c7s spans x 1.510..1.680, y -0.085..0.825 um
    rule licon.5a: diffusion must enclose its contact by 0.04 um - the contact is outside / at the edge of the diffusion
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.