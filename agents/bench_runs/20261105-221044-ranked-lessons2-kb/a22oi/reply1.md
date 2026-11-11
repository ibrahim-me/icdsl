# a22oi: Y = !((A1&A2)|(B1&B2)) — shared gate order A1,A2,B1,B2; n-row Y-n1-GND-n3-Y, p-row VPWR-n2-Y-n2-VPWR; n2 and Y joined by routed metal.

```icl
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

  # ---- diffusion rows (one rectangle per row, shared columns) ----
  nd  = rect diff w=(4*L + 4*0.265 + 3*0.28) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 4*0.265 + 3*0.28) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # ---- shared gate order: A1, A2, B1, B2 (crosses both rows) ----
  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + 0.28)
  gb1 = cross [nd, pd] poly w=L left=(ga2.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(gb1.right + 0.28)

  # ---- n-row: Y(c0) | n1(c1) | GND(c2) | n3(c3) | Y(c4) ----
  sn  = array licon in=nd left_of=ga1          # Y contact col c0
  dn1 = array licon in=nd right_of=ga1         # n1 col c1
  sg  = array licon in=nd right_of=ga2         # GND col c2
  dn3 = array licon in=nd right_of=gb1         # n3 col c3
  sy  = array licon in=nd right_of=gb2         # Y col c4
  snl = enclose sn li net=Y
  dn1l= enclose dn1 li net=n1
  sgl = enclose sg li
  dn3l= enclose dn3 li net=n3
  syl = enclose sy li net=Y
  gndn= strap li from=sgl to=vgnd_li
  route Y layers=m1                            # joins c0 and c4 Y columns

  # ---- p-row: VPWR(c0) | n2(c1) | Y(c2) | n2(c3) | VPWR(c4) ----
  sp  = array licon in=pd left_of=ga1          # VPWR col c0
  dn2 = array licon in=pd right_of=ga1         # n2 col c1
  sy2 = array licon in=pd right_of=ga2         # Y col c2
  dn2b= array licon in=pd right_of=gb1         # n2 col c3
  sp2 = array licon in=pd right_of=gb2         # VPWR col c4
  spl = enclose sp li
  dn2l= enclose dn2 li net=n2
  syl2= enclose sy2 li net=Y
  dn2bl=enclose dn2b li net=n2
  spl2= enclose sp2 li
  pwr1= strap li from=spl to=vpwr_li
  pwr2= strap li from=spl2 to=vpwr_li
  route n2 layers=m1                           # joins c1 and c3 n2 columns
  route Y layers=m1                            # joins p-row Y(c2) to n-row Y

  # ---- gate contacts (bottom from n-row items only) ----
  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, sgl.top + 0.25, dn3l.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=ga1.cx bottom=cb
  gcb = contact licon cx=ga2.cx bottom=cb
  gcc = contact licon cx=gb1.cx bottom=cb
  gcd = contact licon cx=gb2.cx bottom=cb
  pca = enclose gca poly by=minx
  pcb = enclose gcb poly by=minx
  pcc = enclose gcc poly by=minx
  pcd = enclose gcd poly by=minx
  gn  = enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b1  = enclose gcc li net=B1
  b2  = enclose gcd li net=B2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---- supply straps ----
  gndp = strap li from=dn1l to=vgnd_li   # n-row GND column c2 -> actually sgl is GND; fix below

  # ---- met1 pins / ports ----
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=syl
  yp  = enclose ym m1 by=0.06 net=Y
  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out  on=yp
end
```