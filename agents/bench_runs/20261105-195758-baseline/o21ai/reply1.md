I'll lay out the O21AI with the NMOS row ordered B1, A1, A2 so the diffusion columns are Y | n2 | VGND | n2, and the PMOS row ordered B1, A2, A1 so columns are VPWR | Y | n1 | VPWR. The two n2 columns and the two n1 columns are strapped vertically (they line up across the rows), and the Y column is strapped vertically too, giving each internal net a single contact/met1 pin.

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

  dw  = 4*L + 1.12                      # 4 end contacts (0.265 each) + 3 middle contacts (0.28 each)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # NMOS gates left->right: B1 (M3), A1 (M2), A2 (M5)  -> columns Y | n2 | VGND | n2
  gb  = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # B1
  ga1 = cross [nd, pd] poly w=L left=(gb.right + 0.28)          # A1
  ga2 = cross [nd, pd] poly w=L right=(nd.right - 0.265)        # A2
  # PMOS gates left->right: B1 (M1), A2 (M0), A1 (M4) -> columns VPWR | Y | n1 | VPWR
  # gb, ga2, ga1 already cross pd at those x positions

  sn  = array licon in=nd left_of=gb            # n: Y | n2 | VGND | n2
  dn  = array licon in=nd right_of=ga2
  s1  = array licon in=pd left_of=gb            # p: VPWR | Y | n1 | VPWR
  my  = array licon in=pd right_of=gb
  s2  = array licon in=pd right_of=ga2
  snl = enclose sn li
  dnl = enclose dn li net=n2
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li net=n1
  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=s1l to=vpwr_li
  yn  = strap li from=dnl to=myl net=n2         # joins the two n2 columns
  xn  = strap li from=[dnl, s2l] net=n1         # joins the two n1 columns (aligned vertically)

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gca1= contact licon cx=(ga1.cx + 0.1) bottom=cb
  gca2= contact licon cx=(ga2.cx + 0.05) bottom=cb
  gpb = enclose gcb poly by=minx
  gpa1= enclose gca1 poly by=minx
  gpa2= enclose gca2 poly by=minx
  gn  = enclose [gcb, gca1, gca2] npc
  ab  = enclose gcb li net=B1
  aa1 = enclose gca1 li net=A1
  aa2 = enclose gca2 li net=A2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=B1
  a1m = contact mcon in=aa1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=aa2
  a2p = enclose a2m m1 by=0.06 net=A2
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=bp
  port Y out on=yp
end
```