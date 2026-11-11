pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=5 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  # Diffusion width: 2 end contacts (0.265 each) + 3 gates (L each) + 2 internal gaps
  gap = max(0.28, 0.54 - L)
  dw  = 2*0.265 + 3*L + 2*gap

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # Gates: same order A, B, C in both rows
  ga = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb = cross [nd, pd] poly w=L left=(ga.right + gap)
  gc = cross [nd, pd] poly w=L left=(gb.right + gap)

  # n-row diffusion contacts: VGND | A | Y | B | VGND | C | Y
  sn  = array licon in=nd left_of=ga          # VGND (M0 source)
  dn1 = array licon in=nd between=[ga, gb]    # Y (M0 drain / M1 source)
  sn2 = array licon in=nd between=[gb, gc]    # VGND (M1 drain / M3 source)
  dn3 = array licon in=nd right_of=gc         # Y (M3 drain)
  snl = enclose sn li
  dn1l = enclose dn1 li net=Y
  sn2l = enclose sn2 li
  dn3l = enclose dn3 li net=Y

  # p-row diffusion contacts: VPWR | A | n1 | B | n2 | C | Y
  sp  = array licon in=pd left_of=ga          # VPWR (M2 source)
  dp1 = array licon in=pd between=[ga, gb]    # n1 (M2 drain / M5 source)
  dp2 = array licon in=pd between=[gb, gc]    # n2 (M5 drain / M4 source)
  dp3 = array licon in=pd right_of=gc         # Y (M4 drain)
  spl = enclose sp li
  dp1l = enclose dp1 li
  dp2l = enclose dp2 li
  dp3l = enclose dp3 li net=Y

  # Supply straps
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=sn2l to=vgnd_li
  pwr = strap li from=spl to=vpwr_li

  # Output Y: route joins n-side Y (dn1l and dn3l) to p-side Y (dp3l)
  route Y layers=m1

  # Gate contacts: sit on their gates (cx = g.cx), cb only from n-row items (lesson 1)
  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, sn2l.top + 0.25, dn3l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc

  # Gate input nets on li
  a = enclose gca li net=A
  b = enclose gcb li net=B
  c = enclose gcc li net=C

  # n-well split
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Ports: gate inputs on met1 over li
  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B
  cm = contact mcon in=c
  cp = enclose cm m1 by=0.06 net=C

  # Output Y pin on met1
  ym = contact mcon in=dn3l
  yp = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
