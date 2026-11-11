```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=11 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  gpitch = max(0.28, 0.54 - L)          # gate-to-gate gap; 0.54 pitch keeps 0.33 poly pads 0.21 apart
  # n-row: VGND | A | Y | B | VGND | C | Y  (M0,M1,M3 pull Y to VGND)
  nd  = rect diff w=(4*WN + 3*L + 2*gpitch + 2*0.21) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  # p-row: VPWR | A | n1 | B | n2 | C | Y  (series stack VPWR-n1-n2-Y)
  pd  = rect diff w=(4*WP + 3*L + 2*gpitch + 2*0.21) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gpitch)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gpitch)

  # n-row contact columns
  sn0 = array licon in=nd left_of=ga
  dy1 = array licon in=nd between=[ga, gb]
  sv2 = array licon in=nd between=[gb, gc]
  dy3 = array licon in=nd right_of=gc
  sn0l = enclose sn0 li
  dy1l = enclose dy1 li net=Y
  sv2l = enclose sv2 li
  dy3l = enclose dy3 li net=Y
  g0  = strap li from=sn0l to=vgnd_li
  g2  = strap li from=sv2l to=vgnd_li

  # p-row contact columns
  sp0 = array licon in=pd left_of=ga
  sn2 = array licon in=pd between=[gb, gc]
  sy3 = array licon in=pd right_of=gc
  sp0l = enclose sp0 li
  sn2l = enclose sn2 li
  sy3l = enclose sy3 li net=Y
  p0  = strap li from=sp0l to=vpwr_li

  # gate contacts: bottom set by n-row items only; centred on their own gate
  cb  = max(nd.top + 0.19, sn0l.top + 0.25, dy1l.top + 0.25, sv2l.top + 0.25, dy3l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A
  bb  = enclose gcb li net=B
  cc  = enclose gcc li net=C

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)   # n-well split midway between the diffusions

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=cc
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=sy3l
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```