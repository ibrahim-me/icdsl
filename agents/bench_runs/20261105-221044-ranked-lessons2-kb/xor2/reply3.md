```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  gpitch = max(0.28, 0.54 - L)
  endc   = 0.265

  # ---------- gate columns: one poly per net, crossing both rows ----------
  ga  = cross [nd, pd] poly w=L left=(nd.left + endc)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gpitch)
  gn1 = cross [nd, pd] poly w=L left=(gb.right + gpitch)

  # ---------- n-diffusion islands ----------
  nd1 = rect diff w=(2*L + 3*endc) h=WN left=(nd.left)   above=ptap   # VGND A n1 B VGND  (M0,M1)
  nd2 = rect diff w=(2*L + 3*endc) h=WN left=(gn1.right + 0.80) above=ptap  # VGND n1 X B n4 A VGND (M2,M7,M9)
  nd  = rect diff w=(5*L + 6*endc) h=WN cx=cell.cx above=ptap   # keep a single row rect for well/tap
  nim = enclose nd nsdm

  # n-island 1 contacts
  sn1  = array licon in=nd1 left_of=ga
  nn1  = array licon in=nd1 between=[ga, gb] net=n1
  sv1  = array licon in=nd1 right_of=gb net=VGND
  sn1l = enclose sn1 li
  nn1l = enclose nn1 li net=n1
  sv1l = enclose sv1 li net=VGND
  gndn1 = strap li from=sn1l to=vgnd_li
  gndn2 = strap li from=sv1l to=vgnd_li

  # n-island 2 contacts (gate order A,B,n1 within island: A at left, B mid, n1 right)
  ga2  = cross [nd2] poly w=L left=(nd2.left + endc)
  gb2  = cross [nd2] poly w=L left=(ga2.right + gpitch)
  gn2  = cross [nd2] poly w=L left=(gb2.right + gpitch)
  sv2  = array licon in=nd2 left_of=ga2 net=VGND
  dx2  = array licon in=nd2 between=[ga2, gb2] net=X
  dn4  = array licon in=nd2 between=[gb2, gn2] net=n4
  sv3  = array licon in=nd2 right_of=gn2 net=VGND
  sv2l = enclose sv2 li net=VGND
  xl2  = enclose dx2 li net=X
  n4l  = enclose dn4 li net=n4
  sv3l = enclose sv3 li net=VGND
  gndn3 = strap li from=sv2l to=vgnd_li
  gndn4 = strap li from=sv3l to=vgnd_li

  # ---------- p-diffusion islands ----------
  pd1 = rect diff w=(2*L + 3*endc) h=WP left=(pd.left)   below=ntap   # VPWR B n2 A VPWR  (M3,M4)
  pd2 = rect diff w=(2*L + 3*endc) h=WP left=(gn1.right + 0.80) below=ntap  # VPWR A n3 B n1 X n2 VPWR? need fit
  pd  = rect diff w=(5*L + 6*endc) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm

  # p-island 1: VPWR B n2 A VPWR  (M3 g=B, M4 g=A)
  sp1  = array licon in=pd1 left_of=gb net=VPWR
  dn2a = array licon in=pd1 between=[gb, ga] net=n2
  svp1 = array licon in=pd1 right_of=ga net=VPWR
  sp1l = enclose sp1 li net=VPWR
  n2l1 = enclose dn2a li net=n2
  svp1l= enclose svp1 li net=VPWR
  pwrp1 = strap li from=sp1l to=vpwr_li
  pwrp2 = strap li from=svp1l to=vpwr_li

  # p-island 2: VPWR A n3 B n1 X n2 VPWR  (M6 g=A, M5 g=B, M8 g=n1)
  # order left->right: A, B, n1 ; diffs: VPWR | A | n3 | B | n1 | X | n2 | VPWR  -> too wide for 2L+3endc
  pd2 = rect diff w=(4*L + 5*endc) h=WP left=(gn1.right + 0.80) below=ntap  # VPWR A n3 B n1 VPWR? 
  # Use: VPWR | A | n3 | B | n1 | VPWR  (M6,M5) and place M8 (g=n1,s=X,d=n2) needs X,n2
  # Instead: VPWR | A | n3 | B | n1 | X | n2 | VPWR needs 4 gates; we only have A,B,n1 (3). 
  # So split: island2a: VPWR A n3 B n1 VPWR (M6 g=A, M5 g=B); island2b: X n1 n2 with n1 gate (M8)
  # Simplify: make pd2 = VPWR A n3 B n1 VPWR (M6,M5) and put M8 in a 3rd island X n1 n2
  pd2 = rect diff w=(3*L + 4*endc) h=WP left=(gn1.right + 0.80) below=ntap   # VPWR A n3 B n1 VPWR (M6,M5)
  pd3 = rect diff w=(2*L + 3*endc) h=WP left=(pd2.right + 0.80) below=ntap   # X n1 n2 VPWR? M8: s=X d=n2 g=n1 -> X | n1 | n2
  # pd3: left=X, gate n1, right=n2 ; need VPWR? no. M8 s=X d=n2. So diffs: X | n1 | n2. Add VPWR tie? not needed.
  pd3 = rect diff w=(2*L + 3*endc) h=WP left=(pd2.right + 0.80) below=ntap   # X n1 n2

  # p-island 2 contacts (gate order A,B,n1)
  ga3  = cross [pd2] poly w=L left=(pd2.left + endc)
  gb3  = cross [pd2] poly w=L left=(ga3.right + gpitch)
  gn3  = cross [pd2] poly w=L left=(gb3.right + gpitch)
  svp2 = array licon in=pd2 left_of=ga3 net=VPWR
  dn3  = array licon in=pd2 between=[ga3, gb3] net=n3
  dn1p = array licon in=pd2 between=[gb3, gn3] net=n1
  svp3 = array licon in=pd2 right_of=gn3 net=VPWR
  svp2l= enclose svp2 li net=VPWR
  n3l  = enclose dn3 li net=n3
  n1pl = enclose dn1p li net=n1
  svp3l= enclose svp3 li net=VPWR
  pwrp3 = strap li from=svp2l to=vpwr_li
  pwrp4 = strap li from=svp3l to=vpwr_li

  # p-island 3 contacts: X | n1 | n2  (M8 g=n1 s=X d=n2)
  gn4  = cross [pd3] poly w=L left=(pd3.left + endc)
  sx3  = array licon in=pd3 left_of=gn4 net=X
  dn2b = array licon in=pd3 right_of=gn4 net=n2
  sx3l = enclose sx3 li net=X
  n2l2 = enclose dn2b li net=n2

  # ---------- gate contacts (on n-row islands only; cb from n-row items) ----------
  cb = max(nd1.top + 0.19, sn1l.top + 0.25, nn1l.top + 0.25, sv1l.top + 0.25,
              sv2l.top + 0.25, xl2.top + 0.25, n4l.top + 0.25, sv3l.top + 0.25)

  gca  = contact licon cx=(ga.cx)  bottom=cb
  gcb  = contact licon cx=(gb.cx)  bottom=cb
  gcn1 = contact licon cx=(gn1.cx) bottom=cb

  gpa_ = enclose [gca, gcb, gcn1] poly by=minx
  gna  = enclose [gca, gcb, gcn1] npc

  aa = enclose gca  li net=A
  bb = enclose gcb  li net=B
  nn = enclose gcn1 li net=n1

  # ---------- n-well ----------
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------- internal net joins ----------
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route X  layers=m1,m2

  # ---------- input ports ----------
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B

  port A in  on=ap
  port B in  on=bp
  port X out on=xl2
end
```