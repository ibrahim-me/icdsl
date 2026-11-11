```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=8 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  gap  = max(0.28, 0.54 - L)          # gate-to-gate gap (contact column + pad pitch)
  dw   = 2*0.265 + 3*L + 2*gap        # two end contacts + 3 gates + 2 gaps
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm
  ga   = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb   = cross [nd, pd] poly w=L left=(ga.right + gap)
  gc   = cross [nd, pd] poly w=L left=(gb.right + gap)

  # n-row diffusion: VGND | A | Y | B | VGND | C | Y
  sn   = array licon in=nd left_of=ga
  dn_ab= array licon in=nd between=[ga, gb]
  dn_bc= array licon in=nd between=[gb, gc]
  dn_r = array licon in=nd right_of=gc
  snl  = enclose sn li
  dn_abl = enclose dn_ab li net=Y
  dn_bcl = enclose dn_bc li
  dn_rl = enclose dn_r li net=Y
  gndn = strap li from=snl to=vgnd_li
  gndn2= strap li from=dn_bcl to=vgnd_li

  # p-row diffusion: VPWR | A | n1 | B | n2 | C | Y
  sp   = array licon in=pd left_of=ga
  dn1  = array licon in=pd between=[ga, gb]
  dn2  = array licon in=pd between=[gb, gc]
  dp_r = array licon in=pd right_of=gc
  spl  = enclose sp li
  n1l  = enclose dn1 li
  n2l  = enclose dn2 li
  dpl  = enclose dp_r li net=Y
  pwrp = strap li from=spl to=vpwr_li

  cb   = max(nd.top + 0.19, snl.top + 0.25, dn_abl.top + 0.25, dn_rl.top + 0.25)
  gca  = contact licon cx=ga.cx bottom=cb
  gcb  = contact licon cx=gb.cx bottom=cb
  gcc  = contact licon cx=gc.cx bottom=cb
  gpa  = enclose gca poly by=minx
  gpb  = enclose gcb poly by=minx
  gpc  = enclose gcc poly by=minx
  gn   = enclose [gca, gcb, gcc] npc
  aa   = enclose gca li net=A
  bb   = enclose gcb li net=B
  cc   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am   = contact mcon in=aa
  ap   = enclose am m1 by=0.06 net=A
  bm   = contact mcon in=bb
  bp   = enclose bm m1 by=0.06 net=B
  cm   = contact mcon in=cc
  cp   = enclose cm m1 by=0.06 net=C
  ym   = contact mcon in=dpl
  yp   = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```