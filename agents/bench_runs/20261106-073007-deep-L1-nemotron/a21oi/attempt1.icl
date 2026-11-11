pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  # ---- diffusion rows ----
  # n-row: VGND - A2 - n1 - A1 - Y - B1 - VGND  (regions: VGND, n1, Y, VGND)
  # p-row: VPWR - A2 - n2 - A1 - n2 - B1 - Y    (regions: VPWR, n2, n2, Y)
  dnw = 0.265 + L + 0.28 + L + 0.28 + L + 0.265   # 4 regions + 3 gates
  nd  = rect diff w=dnw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dnw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # ---- gates (same order both rows: A2, A1, B1) ----
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # ---- diffusion contacts ----
  # n row: VGND(left), n1, Y, VGND(right)
  sn  = array licon in=nd left_of=ga2          # VGND end contact
  dn1 = array licon in=nd between=[ga2, ga1]   # n1 contact
  dny = array licon in=nd between=[ga1, gb1]   # Y contact
  sn2 = array licon in=nd right_of=gb1         # VGND end contact
  # p row: VPWR(left), n2, n2, Y(right)
  sp  = array licon in=pd left_of=ga2          # VPWR end contact
  dn2a= array licon in=pd between=[ga2, ga1]   # n2 contact (left)
  dn2b= array licon in=pd between=[ga1, gb1]   # n2 contact (right)
  dpy = array licon in=pd right_of=gb1         # Y contact
  snl = enclose sn li
  dn1l= enclose dn1 li net=n1
  dnyl= enclose dny li net=Y
  sn2l= enclose sn2 li
  spl = enclose sp li
  dn2al= enclose dn2a li net=n2
  dn2bl= enclose dn2b li net=n2
  dpyl= enclose dpy li net=Y

  # supply straps
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=sn2l to=vgnd_li
  pwr = strap li from=spl to=vpwr_li
  pwr2= strap li from=dn2al to=vpwr_li   # n2 region also ties to VPWR? No - n2 is internal
  # Actually n2 is internal, don't strap to VPWR. VPWR only from source columns.
  # p-row n2 regions: strap between them to share
  n2s = strap li from=dn2al to=dn2bl net=n2

  # output Y: n-side and p-side Y contacts
  ystrap = strap li from=dnyl to=dpyl net=Y

  # ---- gate contacts ----
  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dnyl.top + 0.25, sn2l.top + 0.25)
  gca = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gcb = contact licon cx=(ga1.cx + 0.1) bottom=cb
  gcc = contact licon cx=(gb1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A2
  ab  = enclose gcb li net=A1
  ac  = enclose gcc li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---- ports ----
  a2m = contact mcon in=aa
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=ab
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=ac
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=ystrap
  yp  = enclose ym m1 by=0.06 net=Y
  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port Y  out on=yp
end
