Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WN2': 0.42, 'WP': 0.75, 'WP2': 0.42}: VIOLATIONS  (DRC 12 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 64: net 'n2': pin a2 has no legal access point
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT X / n2: on li around (0.662, 1.38): shapes of X and n2 overlap/touch there (a2 (line 58), pxl (line 42), sxl (line 30), xst (line 47))
  OPEN net n2 is 3 separate pieces: [a2 (line 58), gn2 (line 21), gp2 (line 54), nd (line 16), +5 more] | [n2l (line 32), nd (line 16)] | [pn2l (line 45)] - join them (strap / shared metal / `route n2`)
  DEVICE M1 (nmos g=n2 d=VGND s=X) has no matching transistor in the layout
  DEVICE M2 (nmos g=B d=VGND s=n2) has no matching transistor in the layout
  DEVICE M4 (pmos g=B d=n2 s=n1) has no matching transistor in the layout
  DEVICE M5 (pmos g=n2 d=VPWR s=X) has no matching transistor in the layout
    layout nmos at x=0.835 y=0.66: gate X+n2 [gn2 (line 21), gp2 (line 54)], source/drain VGND [gnd1 (line 34), gnd2 (line 35), nd (line 16), +2 more], X+n2 [a2 (line 58), nd (line 16), pd (line 17), +3 more]
    layout pmos at x=0.835 y=1.93: gate X+n2 [gn2 (line 21), gp2 (line 54)], source/drain VPWR [pd (line 17), pvl (line 43), pwr (line 46)], X+n2 [a2 (line 58), nd (line 16), pd (line 17), +3 more]
DRC root causes (ranked; by the statements in your file):
* pd (line 17: `pd  = rect diff w=dw h=WP cx=cell.cx below=ntap`) - in 5 of 12 errors: poly.4 x5
    pd spans x 0.495..1.805, y 1.555..2.305 um
    poly.4: pd [diff] vs gb (line 23) [poly x 1.840..1.990, y 0.285..2.435]: gap 0.035 um, rule needs >= 0.075 um (short by 0.040 um)
    one fix: move pd left by 0.04 um - line 17: `cx=cell.cx` -> `cx=(cell.cx - 0.04)` (or move the other shape the opposite way)
    its position uses dw (line 14: `dw    = 0.53 + 2*pitch                 # 2 x 0.265 end contacts + 2 gate gaps`)
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
* nd (line 16: `nd  = rect diff w=dw h=WN cx=cell.cx above=ptap`) - in 3 of 12 errors: poly.4 x3
    nd spans x 0.495..1.805, y 0.415..0.905 um
    poly.4: nd [diff] vs gb (line 23) [poly x 1.840..1.990, y 0.285..2.435]: gap 0.035 um, rule needs >= 0.075 um (short by 0.040 um)
    one fix: move nd left by 0.04 um - line 16: `cx=cell.cx` -> `cx=(cell.cx - 0.04)` (or move the other shape the opposite way)
    its position uses dw (line 14: `dw    = 0.53 + 2*pitch                 # 2 x 0.265 end contacts + 2 gate gaps`)
    rule poly.4: poly closer than 0.075 um to a diffusion it does not cross
* gca (line 52: `gca = contact licon cx=(ga.cx - 0.13) bottom=cb`) and shapes built from it (ap, gpa) - in 3 of 12 errors: poly.2 x3
    gca spans x 1.160..1.330, y 1.095..1.265 um
    poly.2: gpa [poly] vs gn2 (line 21) [poly x 0.760..0.910, y 0.285..2.435]: gap 0.170 um, rule needs >= 0.21 um (short by 0.040 um)
    one fix: move gca right by 0.04 um - line 52: `cx=(ga.cx - 0.13)` -> `cx=(ga.cx - 0.13 + 0.04)` (or move the other shape the opposite way)
    its position uses cb (line 50: `cb  = max(nd.top + 0.19, svl.top + 0.25, n2l.top + 0.25, sv2l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gc2 (line 51: `gc2 = contact licon cx=(gn2.cx - 0.13) bottom=cb`) and shapes built from it (gp2) - in 1 of 12 errors: poly.2 x1
    gc2 spans x 0.620..0.790, y 1.095..1.265 um
    its position uses cb (line 50: `cb  = max(nd.top + 0.19, svl.top + 0.25, n2l.top + 0.25, sv2l.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.