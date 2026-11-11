Design the standard cell `o22ai`: Y = !((A1 | A2) & (B1 | B2)).
Inputs: A1, A2, B1, B2; output: Y; internal nets: n1, n2, n3.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3
  <your geometry>
  port A1 in on=<a met1 shape>
  port A2 in on=<a met1 shape>
  port B1 in on=<a met1 shape>
  port B2 in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.

Your best attempt so far:
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=10 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # ---------- diffusion rows ----------
  nd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # ---------- p-row: VPWR-M1(A1)-n1-M0(A2)-Y-M2(B2)-n2-M6(B1)-VPWR ----------
  gp1 = cross [nd, pd] poly w=L left=(pd.left + 0.265)          # A1 (M1)
  gp2 = cross [nd, pd] poly w=L left=(gp1.right + 0.28)         # A2 (M0)
  gp3 = cross [nd, pd] poly w=L left=(gp2.right + 0.28)         # B2 (M2)
  gp4 = cross [nd, pd] poly w=L left=(gp3.right + 0.28)         # B1 (M6)

  pp1 = array licon in=pd left_of=gp1                           # VPWR (M1 s)
  pn1 = array licon in=pd right_of=gp1 left_of=gp2              # n1 (M1 d / M0 s)
  pp2 = array licon in=pd right_of=gp2                          # Y  (M0 d)
  pn2 = array licon in=pd right_of=gp3 left_of=gp4              # n2 (M2 d / M6 s)
  pp4 = array licon in=pd right_of=gp4                          # VPWR (M6 d)

  ppl = enclose pp1 li
  pn1l = enclose pn1 li net=n1
  ppl2 = enclose pp2 li net=Y
  pn2l = enclose pn2 li net=n2
  ppl4 = enclose pp4 li

  vpwr1 = strap li from=ppl to=vpwr_li
  vpwr2 = strap li from=ppl4 to=vpwr_li
  yp1   = strap li from=pn2l to=ppl2 net=Y                      # n2 column -> Y column

  # ---------- n-row: VGND-M7(A1)-n3-M4(B1)-Y-M5(B2)-n3-M3(A2)-VGND ----------
  gn1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # A1 (M7)
  gn2 = cross [nd, pd] poly w=L left=(gn1.right + 0.28)         # B1 (M4)
  gn3 = cross [nd, pd] poly w=L left=(gn2.right + 0.28)         # B2 (M5)
  gn4 = cross [nd, pd] poly w=L left=(gn3.right + 0.28)         # A2 (M3)

  np0 = array licon in=nd left_of=gn1                           # VGND (M7 d)
  nn1 = array licon in=nd right_of=gn1 left_of=gn2              # n3 (M7 s / M4 d)
  np2 = array licon in=nd right_of=gn2                          # Y  (M4 s)
  nn3 = array licon in=nd right_of=gn3 left_of=gn4              # n3 (M5 s / M3 d)
  np4 = array licon in=nd right_of=gn4                          # VGND (M3 s)

  npl0 = enclose np0 li
  nn1l = enclose nn1 li net=n3
  npl2 = enclose np2 li net=Y
  nn3l = enclose nn3 li net=n3
  npl4 = enclose np4 li

  gnd1 = strap li from=npl0 to=vgnd_li
  gnd2 = strap li from=npl4 to=vgnd_li
  yn1  = strap li from=nn1l to=npl2 net=Y                       # n3 column -> Y column

  # m1 access pads for the split internal nets (avoid vgnd rail blockage)
  n3a  = contact mcon in=nn1l
  n3ap = enclose n3a m1 by=0.06 net=n3
  n3b  = contact mcon in=nn3l
  n3bp = enclose n3b m1 by=0.06 net=n3
  ya   = contact mcon in=npl2
  yap  = enclose ya m1 by=0.06 net=Y
  yb   = contact mcon in=ppl2
  ybp  = enclose yb m1 by=0.06 net=Y

  # connect split internal nets over the supply rail (m2/m3)
  route n3 layers=m2,m3
  route Y layers=m2,m3

  # ---------- gate contacts (bottom from n-row items only) ----------
  cb = max(nd.top + 0.19, nn1l.top + 0.25, np2.top + 0.25, nn3l.top + 0.25)

  gca = contact licon cx=gp1.cx bottom=cb
  gcb = contact licon cx=gp2.cx bottom=cb
  gcc = contact licon cx=gp3.cx bottom=cb
  gcd = contact licon cx=gp4.cx bottom=cb
  gce = contact licon cx=gn1.cx bottom=cb
  gcf = contact licon cx=gn2.cx bottom=cb
  gcg = contact licon cx=gn3.cx bottom=cb
  gch = contact licon cx=gn4.cx bottom=cb

  gpa = enclose [gca, gcb, gcc, gcd] poly by=minx
  gpb = enclose [gce, gcf, gcg, gch] poly by=minx
  gnpc = enclose [gca, gcb, gcc, gcd, gce, gcf, gcg, gch] npc

  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1
  a1n = enclose gce li net=A1
  b1n = enclose gcf li net=B1
  b2n = enclose gcg li net=B2
  a2n = enclose gch li net=A2

  route A1 layers=m1,m2
  route A2 layers=m1,m2
  route B1 layers=m1,m2
  route B2 layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------- ports on met1 ----------
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=ppl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end
```
Its check report:
Check result at {'L': 0.15, 'H': 2.72, 'WN': 0.49, 'WP': 0.75}: VIOLATIONS  (DRC 0 errors, LVS MISMATCH)
ROUTING FAILED (the rest of the cell was built; these nets are left unconnected):
  line 76: net 'Y': pin npl2+yn1+yap has no legal access point
  line 104: net 'A2': pin a2n has no legal access point (blocked by b2p on m1: 0.000 < 0.140 um)
  line 105: net 'B1': pin b1n has no legal access point (blocked by n3ap on m1: 0.000 < 0.140 um)
  -> an access point is an mcon + met1 pad (~0.29 um square) on the li pin, 0.14 um clear of other met1 (rails, pins, routes). Give the pin room, use an li strap instead, or move the blocking met1.
CONNECTIVITY (fix these first - they are why LVS fails):
  SHORT Y / n3: on li around (2.085, 0.66): shapes of Y and n3 overlap/touch there (nn1l (line 55), npl2 (line 56), yn1 (line 62))
  SHORT Y / n2: on li around (2.515, 1.93): shapes of Y and n2 overlap/touch there (pn2l (line 35), ppl2 (line 34), yp1 (line 40))
  SHORT A1 / A2 / B1 / B2: on li around (2.085, 1.18): shapes of A2 and B1 overlap/touch there (a2 (line 95), b1n (line 99))
  OPEN net Y is 2 separate pieces: [n3ap (line 66), n3bp (line 68), nd (line 15), nn1l (line 55), +4 more, route n3] | [pd (line 16), pn2l (line 35), ppl2 (line 34), ybp (line 72), +2 more] - join them (strap / shared metal / `route Y`)
  DEVICE M0 (pmos g=A2 d=Y s=n1) has no matching transistor in the layout
  DEVICE M1 (pmos g=A1 d=n1 s=VPWR) has no matching transistor in the layout
  DEVICE M2 (pmos g=B2 d=n2 s=Y) has no matching transistor in the layout
  DEVICE M3 (nmos g=A2 d=n3 s=VGND) has no matching transistor in the layout
  DEVICE M4 (nmos g=B1 d=n3 s=Y) has no matching transistor in the layout
  DEVICE M5 (nmos g=B2 d=Y s=n3) has no matching transistor in the layout
  DEVICE M6 (pmos g=B1 d=VPWR s=n2) has no matching transistor in the layout
  DEVICE M7 (nmos g=A1 d=VGND s=n3) has no matching transistor in the layout
    layout nmos at x=1.655 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain VGND [gnd1 (line 60), gnd2 (line 61), nd (line 15), +2 more, template ptap/vgnd], Y+n3 [n3ap (line 66), n3bp (line 68), nd (line 15), +5 more, route n3]
    layout nmos at x=2.085 y=0.66: gate A1+A2+B1+B2 [gn1 (line 43), gn2 (line 44), +8 more], source/drain Y+n3 [n3ap (line 66), n3bp (line 68), nd (line 15), +5 more, route n3], Y+n3 [n3ap (line 66), n3bp (line 68), nd (line 15), +5 more, route n3]
Fix the first items first (the attached image is your layout, DRC errors boxed in red). Return the complete corrected file.

NOTES FROM A SENIOR LAYOUT ENGINEER WHO REVIEWED THIS ATTEMPT (follow them):
- A gate column is shared by the n row and the p row, so the gate order must be the SAME in both rows. You drew two sets of four gates (gp1..gp4 and gn1..gn4) on top of each other - every gate is shorted to every other. Draw only FOUR gates.
- Use the gate order A2, B2, B1, A1:
    p row: n1 | A2 | Y | B2 | (n2, series node: no contact) | B1 | VPWR | A1 | n1
    n row: VGND | A2 | n3 | B2 | Y | B1 | n3 | A1 | VGND
- Gaps: max(0.28, 0.54 - L) where a contact column sits between two gates, max(0.21, 0.54 - L) at the series node.
- Join n1 (both p-row ends), n3 (two n columns) and Y (n column + p column) with `route n1/n3/Y layers=m1,m2`, `port Y out`. One mcon + met1 pad per gate contact for the inputs.