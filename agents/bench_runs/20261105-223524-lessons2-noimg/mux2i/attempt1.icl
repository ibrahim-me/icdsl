pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=12 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # ---- diffusion islands -------------------------------------------------
  ndS  = rect diff w=(L + 0.53) h=WN cx=(cell.cx - 0.92) above=ptap net=n1
  ndA0 = rect diff w=(L + 0.53) h=WN cx=(cell.cx - 0.31) above=ptap net=Y
  ndA1 = rect diff w=(L + 0.53) h=WN cx=(cell.cx + 0.31) above=ptap net=n3
  ndN1 = rect diff w=(L + 0.53) h=WN cx=(cell.cx + 0.92) above=ptap net=n5

  pdS  = rect diff w=(L + 0.53) h=WP cx=(cell.cx - 0.92) below=ntap net=n1
  pdA0 = rect diff w=(L + 0.53) h=WP cx=(cell.cx - 0.31) below=ntap net=n2
  pdA1 = rect diff w=(L + 0.53) h=WP cx=(cell.cx + 0.31) below=ntap net=n4
  pdN1 = rect diff w=(L + 0.53) h=WP cx=(cell.cx + 0.92) below=ntap net=Y

  nimS  = enclose ndS nsdm
  nimA0 = enclose ndA0 nsdm
  nimA1 = enclose ndA1 nsdm
  nimN1 = enclose ndN1 nsdm
  pimS  = enclose pdS psdm
  pimA0 = enclose pdA0 psdm
  pimA1 = enclose pdA1 psdm
  pimN1 = enclose pdN1 psdm

  # ---- gates (one poly line per gate net, crossing both rows) ------------
  gs  = cross [ndS, pdS] poly w=L
  ga0 = cross [ndA0, pdA0] poly w=L left=(gs.right + max(0.28, 0.54 - L))
  ga1 = cross [ndA1, pdA1] poly w=L left=(ga0.right + max(0.28, 0.54 - L))
  gn1 = cross [ndN1, pdN1] poly w=L left=(ga1.right + max(0.28, 0.54 - L))

  # ---- n-side contacts ---------------------------------------------------
  snS  = array licon in=ndS left_of=gs
  dnS  = array licon in=ndS right_of=gs
  snA0 = array licon in=ndA0 left_of=ga0
  dnA0 = array licon in=ndA0 right_of=ga0
  snA1 = array licon in=ndA1 left_of=ga1
  dnA1 = array licon in=ndA1 right_of=ga1
  snN1 = array licon in=ndN1 left_of=gn1
  dnN1 = array licon in=ndN1 right_of=gn1

  snlS  = enclose snS li
  dnlS  = enclose dnS li net=n1
  snlA0 = enclose snA0 li
  dnlA0 = enclose dnA0 li net=Y
  snlA1 = enclose snA1 li
  dnlA1 = enclose dnA1 li net=n3
  snlN1 = enclose snN1 li
  dnlN1 = enclose dnN1 li net=n5

  # ---- p-side contacts ---------------------------------------------------
  spS  = array licon in=pdS left_of=gs
  dpS  = array licon in=pdS right_of=gs
  spA0 = array licon in=pdA0 left_of=ga0
  dpA0 = array licon in=pdA0 right_of=ga0
  spA1 = array licon in=pdA1 left_of=ga1
  dpA1 = array licon in=pdA1 right_of=ga1
  spN1 = array licon in=pdN1 left_of=gn1
  dpN1 = array licon in=pdN1 right_of=gn1

  splS  = enclose spS li
  dplS  = enclose dpS li net=n1
  splA0 = enclose spA0 li
  dplA0 = enclose dpA0 li net=n2
  splA1 = enclose spA1 li
  dplA1 = enclose dpA1 li net=n4
  splN1 = enclose spN1 li
  dplN1 = enclose dpN1 li net=Y

  # ---- supply straps -----------------------------------------------------
  gndS = strap li from=snlS to=vgnd_li
  gndN1 = strap li from=snlN1 to=vgnd_li
  pwrS = strap li from=splS to=vpwr_li
  pwrN1 = strap li from=splN1 to=vpwr_li

  # ---- gate contacts (bottom from n-row items only) ----------------------
  cb = max(ndS.top + 0.19, snlS.top + 0.25, dnlS.top + 0.25,
           snlA0.top + 0.25, dnlA0.top + 0.25,
           snlA1.top + 0.25, dnlA1.top + 0.25,
           snlN1.top + 0.25, dnlN1.top + 0.25)

  gcS  = contact licon cx=(gs.cx - 0.13) bottom=cb
  gcA0 = contact licon cx=(ga0.cx - 0.13) bottom=cb
  gcA1 = contact licon cx=(ga1.cx - 0.13) bottom=cb
  gcN1 = contact licon cx=(gn1.cx - 0.13) bottom=cb

  gpS  = enclose gcS poly by=minx
  gpA0 = enclose gcA0 poly by=minx
  gpA1 = enclose gcA1 poly by=minx
  gpN1 = enclose gcN1 poly by=minx

  gn   = enclose [gcS, gcA0, gcA1, gcN1] npc

  aS   = enclose gcS li net=S
  aA0  = enclose gcA0 li net=A0
  aA1  = enclose gcA1 li net=A1
  aN1  = enclose gcN1 li net=n1

  well y=((ndS.top + 0.34 + pdS.bottom - 0.18) / 2)

  # ---- internal net joins (route on m1,m2) -------------------------------
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route n5 layers=m1,m2

  # ---- output Y: n-side and p-side drains line up vertically ------------
  ystrap = strap li from=dnlA0 to=dplN1 net=Y

  # ---- supply straps for internal source columns -------------------------
  strap li from=dnlA1 to=vgnd_li
  strap li from=dplA0 to=vpwr_li

  # ---- port pins ---------------------------------------------------------
  amS  = contact mcon in=aS
  apS  = enclose amS m1 by=0.06 net=S
  port S in on=apS

  amA0 = contact mcon in=aA0
  apA0 = enclose amA0 m1 by=0.06 net=A0
  port A0 in on=apA0

  amA1 = contact mcon in=aA1
  apA1 = enclose amA1 m1 by=0.06 net=A1
  port A1 in on=apA1

  ym   = contact mcon in=ystrap
  yp   = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
