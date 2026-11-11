The gates were defined before the diffusion rows. I need to define `nd`/`pd` first, then place gates relative to them.

```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=4 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  # diffusion rows: end regions 0.265 (contact + enclosure + gap to gate), middle = gate gap
  dw = 0.53 + 2*(0.54 - L)
  nd = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate pitch 0.54 keeps the 0.33 poly pads clear; gap = 0.54-L >= 0.28 fits a contact column
  ga = cross [nd, pd] poly w=L left=(cell.cx - 0.54)
  gb = cross [nd, pd] poly w=L left=(ga.right + 0.54 - L)
  gc = cross [nd, pd] poly w=L left=(gb.right + 0.54 - L)

  # n-row: VGND | A | Y | B | VGND | C | Y
  sn  = array licon in=nd left_of=ga
  y1  = array licon in=nd between=[ga, gb] net=Y
  sv  = array licon in=nd between=[gb, gc]
  y2  = array licon in=nd right_of=gc net=Y
  snl = enclose sn li
  y1l = enclose y1 li net=Y
  svl = enclose sv li
  y2l = enclose y2 li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=svl to=vgnd_li

  # p-row: VPWR | A | n1 | B | n2 | C | Y
  sp  = array licon in=pd left_of=ga
  n1c = array licon in=pd between=[ga, gb] net=n1
  n2c = array licon in=pd between=[gb, gc] net=n2
  yp  = array licon in=pd right_of=gc net=Y
  spl = enclose sp li
  n1l = enclose n1c li net=n1
  n2l = enclose n2c li net=n2
  ypl = enclose yp li net=Y
  pwr = strap li from=spl to=vpwr_li
  yst = strap li from=y2l to=ypl

  # gate contacts on their own gates, bottom set from n-row only
  cb = max(nd.top + 0.19, snl.top + 0.25, y1l.top + 0.25, svl.top + 0.25, y2l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A
  bb  = enclose gcb li net=B
  cc  = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input ports on met1
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=cc
  cp  = enclose cm m1 by=0.06 net=C

  # output: join all Y strips on m1/m2, pin on the routed metal
  ym1 = contact mcon in=y1l
  yp1 = enclose ym1 m1 by=0.06 net=Y
  ym2 = contact mcon in=y2l
  yp2 = enclose ym2 m1 by=0.06 net=Y
  yp3 = enclose ypl m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out
end
```