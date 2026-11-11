```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=10 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  nd  = rect diff w=(4*L + 1.855) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.855) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order n2, A, B (left to right) - same for both rows
  gn2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L left=(gn2.right + max(0.28, 0.54 - L))
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))

  # NMOS row (left to right): X | n2 | VGND | A | n2 | B | VGND
  cnx = array licon in=nd left_of=gn2
  cn2 = array licon in=nd between=[gn2, ga]
  cv1 = array licon in=nd between=[ga, gb]
  cvg = array licon in=nd right_of=gb
  cnxl = enclose cnx li net=X
  cn2l = enclose cn2 li net=n2
  cv1l = enclose cv1 li
  cvgl = enclose cvg li
  gndn = strap li from=cv1l to=vgnd_li
  gndg = strap li from=cvgl to=vgnd_li

  # PMOS row (left to right): X | n2 | VPWR | A | n1 | B | n2
  cpx = array licon in=pd left_of=gn2
  cp2 = array licon in=pd between=[gn2, ga]
  cpw = array licon in=pd between=[ga, gb]
  cp1 = array licon in=pd right_of=gb
  cpxl = enclose cpx li net=X
  cp2l = enclose cp2 li net=n2
  cpwl = enclose cpw li
  cp1l = enclose cp1 li net=n1
  pwr1 = strap li from=cpwl to=vpwr_li

  # output strap joins n-side X and p-side X (same x, left of gate n2)
  xst  = strap li from=cnxl to=cpxl net=X

  # gate contacts ON their own gates (clear of the X strap on the left)
  cb = max(nd.top + 0.19, cnxl.top + 0.25, cn2l.top + 0.25, cv1l.top + 0.25, cvgl.top + 0.25)
  gc2 = contact licon cx=gn2.cx bottom=cb
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gc2, gca, gcb] npc
  a2  = enclose gc2 li net=n2
  aa  = enclose gca li net=A
  ab  = enclose gcb li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # internal net n2: n-row n2 diff + p-row n2 diff + gate contact, joined on m1/m2
  n2n = contact mcon in=cn2l
  n2p = enclose n2n m1 by=0.06 net=n2
  n2p2 = contact mcon in=cp2l
  n2p3 = enclose n2p2 m1 by=0.06 net=n2
  n2g = contact mcon in=a2
  n2g2 = enclose n2g m1 by=0.06 net=n2
  route n2 layers=m1,m2

  # internal net n1: p-row n1 diffusion (series M0/M4 share diffusion)
  n1l = enclose cp1 li net=n1

  # input pins
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=ab
  bp = enclose bm m1 by=0.06 net=B

  # output pin on routed met1 (xst carries net X)
  route X layers=m1
  xp = enclose xst m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```