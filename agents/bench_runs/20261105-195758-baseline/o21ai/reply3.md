The `strap` verb only joins two vertically- or horizontally-aligned objects. I'll give the split nets (Y, n2) the same `net=` on both sides and route them on m1 instead of strapping misaligned columns.

```icl
pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=8 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  dw  = 4*L + 1.12
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # gate order left->right: B1, A2, A1 (same for both rows)
  gb  = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # B1
  ga2 = cross [nd, pd] poly w=L left=(gb.right + 0.28)           # A2
  ga1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)         # A1

  # NMOS cols: Y | n2 | VGND | n2
  sn  = array licon in=nd left_of=gb          # col0 Y
  dn1 = array licon in=nd right_of=gb         # col1 n2
  dn2 = array licon in=nd right_of=ga2        # col2 VGND
  dn3 = array licon in=nd right_of=ga1        # col3 n2
  # PMOS cols: VPWR | Y | n1 | VPWR
  s1  = array licon in=pd left_of=gb          # col0 VPWR
  my  = array licon in=pd right_of=gb         # col1 Y
  s2  = array licon in=pd right_of=ga2        # col2 n1
  s3  = array licon in=pd right_of=ga1        # col3 VPWR
  snl = enclose sn li net=Y
  dn1l= enclose dn1 li net=n2
  dn2l= enclose dn2 li
  dn3l= enclose dn3 li net=n2
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li net=n1
  s3l = enclose s3 li
  gnd = strap li from=dn2l to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s3l to=vpwr_li
  route Y layers=m1                           # joins snl (n-col0) and myl (p-col1)
  route n2 layers=m1                          # joins dn1l and dn3l

  cb  = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25)
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gca2= contact licon cx=(ga2.cx + 0.05) bottom=cb
  gca1= contact licon cx=(ga1.cx + 0.1) bottom=cb
  gpb = enclose gcb poly by=minx
  gpa2= enclose gca2 poly by=minx
  gpa1= enclose gca1 poly by=minx
  gn  = enclose [gcb, gca2, gca1] npc
  ab  = enclose gcb li net=B1
  aa2 = enclose gca2 li net=A2
  aa1 = enclose gca1 li net=A1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=B1
  a2m = contact mcon in=aa2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=aa1
  a1p = enclose a1m m1 by=0.06 net=A1
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  n1m = contact mcon in=s2l
  n1p = enclose n1m m1 by=0.06 net=n1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=bp
  port Y out on=yp
end
```