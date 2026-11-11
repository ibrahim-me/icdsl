pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=8 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  dw  = 2*L + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  gc  = cross [nd, pd] poly w=L left=(nd.left + 0.265)     # A2
  ga  = cross [nd, pd] poly w=L cx=cell.cx                 # A1
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265)   # B1

  # n-row: VGND | A2 | n1 | A1 | Y | B1 | VGND  (n1 series, no contact)
  sn  = array licon in=nd left_of=gc
  dn  = array licon in=nd right_of=gb
  s1  = array licon in=nd right_of=gc
  d1  = array licon in=nd left_of=ga
  s2  = array licon in=nd right_of=ga
  d2  = array licon in=nd left_of=gb
  snl = enclose sn li
  dnl = enclose dn li net=VGND
  s1l = enclose s1 li net=n1
  d1l = enclose d1 li net=n1
  s2l = enclose s2 li net=Y
  d2l = enclose d2 li net=Y
  gnd1 = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dnl to=vgnd_li
  n1j = strap li from=s1l to=d1l net=n1
  yj  = strap li from=s2l to=d2l net=Y

  # p-row: VPWR | A1 | n2 | B1 | Y ; VPWR | A2 | n2  (A1,A2 parallel to n2)
  sp  = array licon in=pd left_of=ga
  dp  = array licon in=pd right_of=gb
  s1p = array licon in=pd right_of=ga
  d1p = array licon in=pd left_of=gb
  s2p = array licon in=pd left_of=gc
  d2p = array licon in=pd right_of=gc
  spl = enclose sp li net=VPWR
  dpl = enclose dp li net=Y
  s1pl = enclose s1p li net=n2
  d1pl = enclose d1p li net=n2
  s2pl = enclose s2p li net=VPWR
  d2pl = enclose d2p li net=n2
  pwr1 = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dpl to=vpwr_li
  n2j = strap li from=s1pl to=d1pl net=n2
  vpj = strap li from=s2pl to=d2pl net=VPWR

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s1l.top + 0.25, d1l.top + 0.25, s2l.top + 0.25, d2l.top + 0.25, spl.top + 0.25, dpl.top + 0.25, s1pl.top + 0.25, d1pl.top + 0.25, s2pl.top + 0.25, d2pl.top + 0.25)
  gca = contact licon cx=(gc.cx - 0.12) bottom=cb
  gaa = contact licon cx=ga.cx bottom=cb
  gbb = contact licon cx=(gb.cx + 0.12) bottom=cb
  gpa = enclose gca poly by=minx
  gqa = enclose gaa poly by=minx
  gpb = enclose gbb poly by=minx
  gna = enclose [gca, gaa, gbb] npc
  a2  = enclose gca li net=A2
  a1  = enclose gaa li net=A1
  b1  = enclose gbb li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=dnl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port Y out on=yp
end
