Design the standard cell `xor2`: X = A ^ B.
Inputs: A, B; output: X; internal nets: n1, n2, n3, n4.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=<columns, your choice> height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port X out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

Your best attempt so far:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  gapc = max(0.28, 0.54 - L)      # gap with contact column between gates
  gaps = max(0.21, 0.54 - L)      # gap for series node, no contact column
  ndw  = 2*0.265 + 5*L + 3*gapc + gaps
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # n-row: VGND -A- n1 -B- VGND -n1- X -B- n4 -A- VGND
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb1 = cross [nd, pd] poly w=L left=(ga.right + gapc)
  gn1 = cross [nd, pd] poly w=L left=(gb1.right + gapc)
  gb2 = cross [nd, pd] poly w=L left=(gn1.right + gapc)
  ga2 = cross [nd, pd] poly w=L left=(gb2.right + gaps)

  sn   = array licon in=nd left_of=ga
  dn1  = array licon in=nd right_of=ga
  dn2  = array licon in=nd right_of=gb1
  dn3  = array licon in=nd right_of=gn1
  dn4  = array licon in=nd right_of=gb2
  snl  = enclose sn li
  dn1l = enclose dn1 li net=n1
  dn2l = enclose dn2 li net=VGND
  dn3l = enclose dn3 li net=X
  dn4l = enclose dn4 li net=n4
  gnd  = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dn2l to=vgnd_li

  # p-row: VPWR -B- n2 -A- VPWR -A- n3 -B- n1 -n1- X
  gpb = cross [nd, pd] poly w=L left=(pd.left + 0.265)
  gpa = cross [nd, pd] poly w=L left=(gpb.right + gapc)
  gpw = cross [nd, pd] poly w=L left=(gpa.right + gapc)
  gpa2= cross [nd, pd] poly w=L left=(gpw.right + gaps)
  gpn1= cross [nd, pd] poly w=L left=(gpa2.right + gapc)

  sp   = array licon in=pd left_of=gpb
  dn2p = array licon in=pd right_of=gpb
  dpwr = array licon in=pd right_of=gpa
  dn3p = array licon in=pd right_of=gpw
  dn1p = array licon in=pd right_of=gpa2
  dx   = array licon in=pd right_of=gpn1
  spl  = enclose sp li
  dn2pl= enclose dn2p li net=n2
  dpwrl= enclose dpwr li net=VPWR
  dn3pl= enclose dn3p li net=n3
  dn1pl= enclose dn1p li net=n1
  dxl  = enclose dx li net=X
  pwr  = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dpwrl to=vpwr_li

  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25, dn4l.top + 0.25)
  gca  = contact licon cx=ga.cx  bottom=cb
  gcb1 = contact licon cx=gb1.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gcb2 = contact licon cx=gb2.cx bottom=cb
  gca2 = contact licon cx=ga2.cx bottom=cb
  gpb_c = contact licon cx=gpb.cx bottom=cb
  gpa_c = contact licon cx=gpa.cx bottom=cb
  gpw_c = contact licon cx=gpw.cx bottom=cb
  gpa2_c= contact licon cx=gpa2.cx bottom=cb
  gpn1_c= contact licon cx=gpn1.cx bottom=cb

  gpc = enclose [gca, gcb1, gcn1, gcb2, gca2, gpb_c, gpa_c, gpw_c, gpa2_c, gpn1_c] poly by=minx
  gnc = enclose [gca, gcb1, gcn1, gcb2, gca2, gpb_c, gpa_c, gpw_c, gpa2_c, gpn1_c] npc

  aa  = enclose gca  li net=A
  bb1 = enclose gcb1 li net=B
  nn1 = enclose gcn1 li net=n1
  bb2 = enclose gcb2 li net=B
  aa2 = enclose gca2 li net=A
  pbb = enclose gpb_c li net=B
  paa = enclose gpa_c li net=A
  paa2= enclose gpa2_c li net=A
  pnn1= enclose gpn1_c li net=n1

  route n1 layers=m1,m2
  route X layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb1
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=dxl
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A / B / n1: on li around (1.68, 1.18): shapes of A and B overlap/touch there (aa (line 81), pbb (line 86))
  DEVICE M0 (nmos g=A d=n1 s=VGND) has no matching transistor in the layout
  DEVICE M1 (nmos g=B d=VGND s=n1) has no matching transistor in the layout
  DEVICE M2 (nmos g=n1 d=X s=VGND) has no matching transistor in the layout
  DEVICE M3 (pmos g=B d=n2 s=VPWR) has no matching transistor in the layout
  DEVICE M4 (pmos g=A d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M5 (pmos g=B d=n1 s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=A d=n3 s=VPWR) has no matching transistor in the layout
  DEVICE M7 (nmos g=B d=n4 s=X) has no matching transistor in the layout
  DEVICE M8 (pmos g=n1 d=n2 s=X) has no matching transistor in the layout
  DEVICE M9 (nmos g=A d=VGND s=n4) has no matching transistor in the layout
    layout nmos at x=1.68 y=0.66: gate A+B+n1 [ga (line 25), ga2 (line 29), +9 more], source/drain A+B+n1 [dn2l (line 38), gnd (line 41), gnd2 (line 42), +2 more, template ptap/vgnd], VGND [aa (line 81), aa2 (line 85), ap (line 97), +23 more, route n1]
    layout nmos at x=2.22 y=0.66: gate A+B+n1 [ga (line 25), ga2 (line 29), +9 more], source/drain A+B+n1 [aa (line 81), aa2 (line 85), ap (line 97), +23 more, route n1], VGND [dn2l (line 38), gnd (line 41), gnd2 (line 42), +2 more, template ptap/vgnd]
    layout nmos at x=2.76 y=0.66: gate A+B+n1 [ga (line 25), ga2 (line 29), +9 more], source/drain VGND [dn2l (line 38), gnd (line 41), gnd2 (line 42), +2 more, template ptap/vgnd], X [dn3l (line 39), dxl (line 62), nd (line 19), +2 more, route X]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.

NOTES FROM A SENIOR LAYOUT ENGINEER WHO REVIEWED THIS ATTEMPT (follow them):
- All your gates are shorted together (gate A+B+n1): gate contacts of different inputs touch (aa / pbb overlap). One gate contact per gate column, ON its gate, pads 0.21 apart (pitch >= 0.54).
- A plan that works - five gate columns left to right: A, B, A, B, n1:
    n row (one diffusion): VGND | A | n1 | B | VGND | A | (n4 = series, no contact) | B | X | n1 | VGND
    p row island 1:        VPWR | A | n2 | B | VPWR | A | (n3 = series, no contact) | B | n1
    p row island 2 (under the n1 gate only): X | n1 | n2
  Between the 4th gate (B) and the 5th (n1) the p row has a diffusion break (n1 contact, 0.27 spacing, X contact), so that gap is 0.80; the n row uses it for its X contact column.
- Label every contact column with its net; join n1 (n column + p column + the n1 gate contact), n2 (two p columns) and X (n column + p column) with `route <net> layers=m1,m2`, `port X out`.