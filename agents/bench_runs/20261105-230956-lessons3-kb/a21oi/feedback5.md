Your last change made things worse (score 1000000 vs best 5021). Here is your BEST version so far - continue from it, not from the last one:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  gap = max(0.28, 0.54 - L)

  # NMOS row: VGND | A2 | n1 | A1 | Y | B1 | VGND  (M0, M5, M3)
  nd  = rect diff w=(3*L + 2*gap + 2*0.265) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  ga2 = cross [nd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd] poly w=L left=(ga2.right + gap)
  gb1 = cross [nd] poly w=L left=(ga1.right + gap)

  sn  = array licon in=nd left_of=ga2
  cn1 = array licon in=nd between=[ga2, ga1]
  cy  = array licon in=nd between=[ga1, gb1]
  cs  = array licon in=nd right_of=gb1
  snl = enclose sn li
  cn1l= enclose cn1 li net=n1
  cyl = enclose cy li net=Y
  csl = enclose cs li
  gndn= strap li from=snl to=vgnd_li
  gnds= strap li from=csl to=vgnd_li

  # PMOS row: island1 VPWR | A1 | n2a | A2 | VPWR  (M1, M4)
  #         island2 n2b | B1 | Y                  (M2), 0.80 island break
  pdw = 2*L + 0.53 + gap
  pd1 = rect diff w=pdw h=WP cx=(cell.cx - (0.80 + pdw)/2) below=ntap
  pd2 = rect diff w=(2*L + 0.53 + gap) h=WP cx=(cell.cx + (0.80 + pdw)/2) below=ntap
  pim1= enclose pd1 psdm
  pim2= enclose pd2 psdm

  pa1 = cross [pd1] poly w=L left=(pd1.left + 0.265)
  pa2 = cross [pd1] poly w=L left=(pa1.right + gap)
  pb1 = cross [pd2] poly w=L left=(pd2.left + 0.265)

  sp1 = array licon in=pd1 left_of=pa1
  cn2a= array licon in=pd1 between=[pa1, pa2]
  sp2 = array licon in=pd1 right_of=pa2
  cn2b= array licon in=pd2 left_of=pb1
  cy2 = array licon in=pd2 right_of=pb1
  sp1l = enclose sp1 li
  cn2al= enclose cn2a li net=n2
  sp2l = enclose sp2 li
  cn2bl= enclose cn2b li net=n2
  cy2l = enclose cy2 li net=Y
  pwr1= strap li from=sp1l to=vpwr_li
  pwr2= strap li from=sp2l to=vpwr_li

  # gate contacts: all on the OUTER side away from the centre, same height cb
  cb = max(nd.top + 0.19, snl.top + 0.25, cn1l.top + 0.25, cyl.top + 0.25, csl.top + 0.25)
  gca2 = contact licon cx=(ga2.cx - 0.13) bottom=cb
  gca1 = contact licon cx=(ga1.cx - 0.13) bottom=cb
  gcb1 = contact licon cx=(gb1.cx + 0.13) bottom=cb
  gpa1 = contact licon cx=(pa1.cx - 0.13) bottom=cb
  gpa2 = contact licon cx=(pa2.cx + 0.13) bottom=cb
  gpb1 = contact licon cx=(pb1.cx + 0.13) bottom=cb

  enclose [gca2, gca1, gcb1, gpa1, gpa2, gpb1] poly by=minx
  enclose [gca2, gca1, gcb1, gpa1, gpa2, gpb1] npc
  a2 = enclose gca2 li net=A2
  a1 = enclose gca1 li net=A1
  b1 = enclose gcb1 li net=B1

  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  # input port pins on met1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1

  # output: n-side Y (cyl) and p-side Y (cy2l) joined by metal route
  ym = contact mcon in=cyl
  yp = enclose ym m1 by=0.06 net=Y

  route Y layers=m1,m2
  route n1 layers=m1,m2
  route n2 layers=m1,m2

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out  on=yp
end
```
Its check result:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 21 errors, LVS MISMATCH)
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT A1 / A2 / B1: joined through contacts/vias: A1: a1 (line 69), a1p (line 78); A2: a2 (line 68), a2p (line 76); B1: b1 (line 70), b1p (line 80)
DRC root causes (ranked; by the statements in your file):
* enclose_line66 (line 66: `enclose [gca2, gca1, gcb1, gpa1, gpa2, gpb1] poly by=minx`) - in 18 of 21 errors: poly.2 x18
    enclose_line66 spans x 0.265..2.875, y 1.045..1.315 um
    poly.2: enclose_line66 [poly] vs pa1 (line 40) [poly x 0.485..0.635, y 1.425..2.435]: gap 0.110 um, rule needs >= 0.21 um (short by 0.100 um)
    one fix: move enclose_line66 down by 0.1 um (or move the other shape the opposite way)
    poly.2: enclose_line66 [poly] vs pa2 (line 41) [poly x 1.025..1.175, y 1.425..2.435]: gap 0.110 um, rule needs >= 0.21 um (short by 0.100 um)
    poly.2: enclose_line66 [poly] vs pb1 (line 42) [poly x 2.505..2.655, y 1.425..2.435]: gap 0.110 um, rule needs >= 0.21 um (short by 0.100 um)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca1 (line 60: `gca1 = contact licon cx=(ga1.cx - 0.13) bottom=cb`) and shapes built from it (a1, a1m, a1p) - in 6 of 21 errors: poly.2 x6
    gca1 spans x 1.625..1.795, y 1.095..1.265 um
    its position uses cb (line 58: `cb = max(nd.top + 0.19, snl.top + 0.25, cn1l.top + 0.25, cyl.top + 0.25, csl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gcb1 (line 61: `gcb1 = contact licon cx=(gb1.cx + 0.13) bottom=cb`) and shapes built from it (b1, b1m, b1p) - in 6 of 21 errors: poly.2 x6
    gcb1 spans x 2.425..2.595, y 1.095..1.265 um
    its position uses cb (line 58: `cb = max(nd.top + 0.19, snl.top + 0.25, cn1l.top + 0.25, cyl.top + 0.25, csl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
* gca2 (line 59: `gca2 = contact licon cx=(ga2.cx - 0.13) bottom=cb`) and shapes built from it (a2, a2m, a2p) - in 4 of 21 errors: poly.2 x4
    gca2 spans x 1.085..1.255, y 1.095..1.265 um
    its position uses cb (line 58: `cb = max(nd.top + 0.19, snl.top + 0.25, cn1l.top + 0.25, cyl.top + 0.25, csl.top + 0.25)`)
    rule poly.2: two poly shapes closer than 0.21 um - usually gate-contact pads of neighbouring gates side by side; stagger them vertically (one gate contact higher than the next) or widen the gate pitch
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.