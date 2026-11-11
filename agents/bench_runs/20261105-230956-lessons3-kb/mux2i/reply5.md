```icl
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

  dw  = 2*0.265 + 0.28 + 3*L + 2*max(0.28, 0.54 - L)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gS  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  g1  = cross [nd, pd] poly w=L left=(gS.right + max(0.28, 0.54 - L))
  gA1 = cross [nd, pd] poly w=L left=(g1.right + max(0.28, 0.54 - L))
  gA0 = cross [nd, pd] poly w=L left=(gA1.right + max(0.28, 0.54 - L))

  cnVa  = array licon in=nd left_of=gS
  cn3   = array licon in=nd between=[gS, g1]
  cnY   = array licon in=nd between=[g1, gA1]
  cn5   = array licon in=nd between=[gA1, gA0]
  cn1   = array licon in=nd right_of=gA0
  cnVra = array licon in=nd right_of=cn1
  cnVl  = enclose cnVa li net=VGND
  cnVrl = enclose cnVra li net=VGND
  cn3l  = enclose cn3 li net=n3
  cnYl  = enclose cnY li net=Y
  cn5l  = enclose cn5 li net=n5
  cn1l  = enclose cn1 li net=n1
  gndn  = strap li from=cnVl to=vgnd_li
  gndn2 = strap li from=cnVrl to=vgnd_li

  cpVa  = array licon in=pd left_of=gS
  cp2   = array licon in=pd between=[gS, g1]
  cpY   = array licon in=pd between=[g1, gA1]
  cp4   = array licon in=pd between=[gA1, gA0]
  cpVra = array licon in=pd right_of=gA0
  cpVrra= array licon in=pd right_of=cpVra
  cpVl  = enclose cpVa li net=VPWR
  cpVrl = enclose cpVra li net=VPWR
  cpVrrl= enclose cpVrra li net=VPWR
  cp2l  = enclose cp2 li net=n2
  cpYl  = enclose cpY li net=Y
  cp4l  = enclose cp4 li net=n4
  pwrp  = strap li from=cpVl to=vpwr_li
  pwrp2 = strap li from=cpVrl to=vpwr_li
  pwrp3 = strap li from=cpVrrl to=vpwr_li

  cb = max(nd.top + 0.19, cnVl.top + 0.25, cn3l.top + 0.25, cnYl.top + 0.25, cn5l.top + 0.25, cn1l.top + 0.25)
  gcS = contact licon cx=(gS.cx - 0.09) bottom=cb
  gc1 = contact licon cx=(g1.cx - 0.09) bottom=cb
  gcA1= contact licon cx=(gA1.cx - 0.09) bottom=cb
  gcA0= contact licon cx=(gA0.cx - 0.09) bottom=cb
  gpS = enclose gcS poly by=minx
  gp1 = enclose gc1 poly by=minx
  gpA1= enclose gcA1 poly by=minx
  gpA0= enclose gcA0 poly by=minx
  gn  = enclose [gcS, gc1, gcA1, gcA0] npc
  aS  = enclose gcS li net=S
  a1  = enclose gc1 li net=n1
  aA1 = enclose gcA1 li net=A1
  aA0 = enclose gcA0 li net=A0

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  sm  = contact mcon in=cnVl
  sp  = enclose sm m1 by=0.06 net=VGND
  pm  = contact mcon in=cpVl
  pp  = enclose pm m1 by=0.06 net=VPWR

  ystrap = strap li from=cnYl to=cpYl net=Y
  ym     = contact mcon in=ystrap cy=nd.cy
  yp     = enclose ym m1 by=0.06 net=Y

  sM  = contact mcon in=aS
  sP  = enclose sM m1 by=0.06 net=S
  a0M = contact mcon in=aA0
  a0P = enclose a0M m1 by=0.06 net=A0
  a1M = contact mcon in=aA1
  a1P = enclose a1M m1 by=0.06 net=A1

  n1j = strap li from=a1 to=cn1l net=n1

  port VGND ground on=sp
  port VPWR power  on=pp
  port S   in      on=sP
  port A0  in      on=a0P
  port A1  in      on=a1P
  port Y   out     on=yp
end
```