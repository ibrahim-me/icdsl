pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  # ---- diffusion widths (follows L for sweep) ----
  # NMOS: VGND|A2|n3|A1|Y|B1|n1|B2|VGND  (4 gates, 3 internal contact gaps, 2 end contacts)
  dwn = 4*L + 2*0.265 + 3*0.28
  # PMOS islands: 2 gates each
  dwp = 2*L + 0.81

  # gate pitch: 0.28 = room for contact column; 0.54-L = gate-contact pad clearance
  gpitch = max(0.28, 0.54 - L)

  # ---- diffusion islands ----
  nd  = rect diff w=dwn h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm

  pd1 = rect diff w=dwp h=WP cx=cell.cx below=ntap
  pim1 = enclose pd1 psdm

  pd2 = rect diff w=dwp h=WP cx=cell.cx below=ntap
  pim2 = enclose pd2 psdm

  # ---- gates (common order A2, A1, B1, B2) ----
  ga2 = cross [nd, pd1] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd1] poly w=L left=(ga2.right + gpitch)
  gb1 = cross [nd, pd2] poly w=L left=(ga1.right + gpitch)
  gb2 = cross [nd, pd2] poly w=L left=(gb1.right + gpitch)

  # ---- NMOS contacts: VGND | A2 | n3 | A1 | Y | B1 | n1 | B2 | VGND ----
  sn3  = array licon in=nd left_of=ga2           # VGND (M3 source)
  n3n  = array licon in=nd between=[ga2, ga1]    # n3 (M3 drain, M6 source)
  y1n  = array licon in=nd between=[ga1, gb1]    # Y (M6 drain, M0 source)
  n1n  = array licon in=nd between=[gb1, gb2]    # n1 (M0 drain, M4 source)
  sn4  = array licon in=nd right_of=gb2          # VGND (M4 drain)
  sn3l = enclose sn3 li
  n3nl = enclose n3n li net=n3
  y1nl = enclose y1n li net=Y
  n1nl = enclose n1n li net=n1
  sn4l = enclose sn4 li

  # ---- PMOS island 1 contacts: VPWR | A2 | n2 | A1 | VPWR ----
  sp1  = array licon in=pd1 left_of=ga2          # VPWR (M1 source)
  n2a  = array licon in=pd1 between=[ga2, ga1]   # n2 (M1 drain, M2 source)
  sp2  = array licon in=pd1 right_of=ga1         # VPWR (M2 drain)
  sp1l = enclose sp1 li
  n2al = enclose n2a li net=n2
  sp2l = enclose sp2 li

  # ---- PMOS island 2 contacts: Y | B1 | n2 | B2 | Y ----
  sy1  = array licon in=pd2 left_of=gb1          # Y (M7 source)
  n2b  = array licon in=pd2 between=[gb1, gb2]   # n2 (M7 drain, M5 source)
  sy2  = array licon in=pd2 right_of=gb2         # Y (M5 drain)
  sy1l = enclose sy1 li net=Y
  n2bl = enclose n2b li net=n2
  sy2l = enclose sy2 li net=Y

  # ---- gate contacts ----
  cb = max(nd.top + 0.19, sn3l.top + 0.25, n3nl.top + 0.25, y1nl.top + 0.25,
              n1nl.top + 0.25, sn4l.top + 0.25,
              sp1l.top + 0.25, n2al.top + 0.25, sp2l.top + 0.25,
              sy1l.top + 0.25, n2bl.top + 0.25, sy2l.top + 0.25)

  gca2 = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gca1 = contact licon cx=(ga1.cx - 0.1) bottom=cb
  gcb1 = contact licon cx=(gb1.cx + 0.1) bottom=cb
  gcb2 = contact licon cx=(gb2.cx + 0.1) bottom=cb

  gpa2 = enclose gca2 poly by=minx
  gpa1 = enclose gca1 poly by=minx
  gpb1 = enclose gcb1 poly by=minx
  gpb2 = enclose gcb2 poly by=minx

  gn = enclose [gca2, gca1, gcb1, gcb2] npc

  a2 = enclose gca2 li net=A2
  a1 = enclose gca1 li net=A1
  b1 = enclose gcb1 li net=B1
  b2 = enclose gcb2 li net=B2

  # ---- supply straps ----
  gnd1 = strap li from=sn3l to=vgnd_li
  gnd2 = strap li from=sn4l to=vgnd_li
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=sp2l to=vpwr_li

  # ---- internal nets ----
  route n3 layers=m1          # n3nl only (NMOS)
  route n1 layers=m1          # n1nl only (NMOS)
  route n2 layers=m1,m2       # n2al (PMOS isl1) and n2bl (PMOS isl2)

  # ---- output Y ----
  # y1nl (NMOS), sy1l & sy2l (PMOS isl2) - join with route
  route Y layers=m1,m2

  # ---- well ----
  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  # ---- ports ----
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2

  ym = contact mcon in=sy1l
  yp = enclose ym m1 by=0.06 net=Y
  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end