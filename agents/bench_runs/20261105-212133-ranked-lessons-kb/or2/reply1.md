```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  nd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # gate order left->right: B, A, n2  (shared nodes n2/n1/VPWR sit between gates)
  gb  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L left=(gb.right + 0.28)
  gn2 = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  # nd columns: c0=VGND c1=n2 c2=VGND c3=X   |  pd columns: c0=n2 c1=n1 c2=VPWR c3=X
  sn  = array licon in=nd left_of=gb            # c0 VGND
  dn1 = array licon in=nd right_of=gb           # c1 n2
  dn2 = array licon in=nd right_of=ga           # c2 VGND
  dx  = array licon in=nd right_of=gn2          # c3 X
  sp  = array licon in=pd left_of=gb            # c0 n2
  dp  = array licon in=pd right_of=gb           # c1 n1
  dvp = array licon in=pd right_of=ga           # c2 VPWR
  dxp = array licon in=pd right_of=gn2          # c3 X
  snl = enclose sn li
  dn1l= enclose dn1 li net=n2
  dn2l= enclose dn2 li
  dxl = enclose dx li net=X
  spl = enclose sp li net=n2
  dpl = enclose dp li net=n1
  dvpl= enclose dvp li
  dxpl= enclose dxp li net=X
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=dn2l to=vgnd_li
  p1  = strap li from=dpl to=vpwr_li            # n1 column -> VPWR rail (M0 source)
  p2  = strap li from=dvpl to=vpwr_li           # c2 VPWR -> VPWR rail
  n2st= strap li from=dn1l to=spl net=n2        # join nd n2 (c1) and pd n2 (c0)
  xst = strap li from=dxl to=dxpl net=X         # join nd X (c3) and pd X (c3)
  # gate contacts in gap between rows, on their own gate lines
  cb  = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dxl.top + 0.25)
  gcb = contact licon cx=gb.cx bottom=cb
  gca = contact licon cx=ga.cx bottom=cb
  gn2c= contact licon cx=gn2.cx bottom=cb
  gcbp= enclose gcb poly by=minx
  gcap= enclose ga poly by=minx        # enclose ga (shape) by minx around contact gca
  gn2p= enclose gn2c poly by=minx
  gn  = enclose [gcb, gca, gn2c] npc
  ab  = enclose gcb li net=B
  aa  = enclose gca li net=A
  an2 = enclose gn2c li net=n2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # input ports on met1
  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=B
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  # output X on met1 (n-side and p-side X straps already joined)
  xm  = contact mcon in=dxl
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```