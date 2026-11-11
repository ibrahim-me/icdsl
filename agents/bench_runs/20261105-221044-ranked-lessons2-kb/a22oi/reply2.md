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

  gap = max(0.28, 0.54 - L)            # contact column + poly-pad spacing
  dw  = 2*0.265 + 4*L + 3*gap          # diffusion width: end margins + 4 gates + 3 gaps

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # shared gate order: A1, A2, B2, B1  (works for both rows)
  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + gap)
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + gap)
  gb1 = cross [nd, pd] poly w=L left=(gb2.right + gap)

  # ---- n-row: Y | n3 | GND | n1 | Y   (gates A1 A2 B2 B1) ----
  sn  = array licon in=nd left_of=ga1          # c0 = Y
  dn3 = array licon in=nd right_of=ga1         # c1 = n3
  sg  = array licon in=nd right_of=ga2         # c2 = GND
  dn1 = array licon in=nd right_of=gb2         # c3 = n1
  sy  = array licon in=nd right_of=gb1         # c4 = Y
  snl = enclose sn li net=Y
  dn3l= enclose dn3 li net=n3
  sgl = enclose sg li
  dn1l= enclose dn1 li net=n1
  syl = enclose sy li net=Y
  gndn= strap li from=sgl to=vgnd_li
  route Y layers=m1                            # joins c0 and c4 Y columns

  # ---- p-row: VPWR | n2 | VPWR | n2 | Y   (gates A1 A2 B2 B1) ----
  sp  = array licon in=pd left_of=ga1          # c0 = VPWR
  dn2 = array licon in=pd right_of=ga1         # c1 = n2
  sp2 = array licon in=pd right_of=ga2         # c2 = VPWR
  dn2b= array licon in=pd right_of=gb2         # c3 = n2
  sy2 = array licon in=pd right_of=gb1         # c4 = Y
  spl = enclose sp li
  dn2l= enclose dn2 li net=n2
  spl2= enclose sp2 li
  dn2bl=enclose dn2b li net=n2
  syl2= enclose sy2 li net=Y
  pwr1= strap li from=spl to=vpwr_li
  pwr2= strap li from=spl2 to=vpwr_li
  route n2 layers=m1                           # joins c1 and c3 n2 columns
  route Y layers=m1                            # joins p-row Y(c4) to n-row Y

  # ---- gate contacts: bottom from n-row items only; stagger x to keep poly pads 0.21 apart ----
  cb = max(nd.top + 0.19, snl.top + 0.25, dn3l.top + 0.25, sgl.top + 0.25, dn1l.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=(ga1.cx - 0.13) bottom=cb
  gcb = contact licon cx=(ga2.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gb2.cx - 0.13) bottom=cb
  gcd = contact licon cx=(gb1.cx + 0.13) bottom=cb
  pca = enclose gca poly by=minx
  pcb = enclose gcb poly by=minx
  pcc = enclose gcc poly by=minx
  pcd = enclose gcd poly by=minx
  gn  = enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

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