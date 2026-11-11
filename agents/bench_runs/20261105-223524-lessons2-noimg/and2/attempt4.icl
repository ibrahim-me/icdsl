pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  pitch = max(0.28, 0.54 - L)
  end   = 0.265

  # ---------- n-row islands ----------
  nd1 = rect diff w=(2*L + 2*end + pitch) h=WN cx=cell.cx above=ptap   # n1 | A | n2 | B | VGND
  nd2 = rect diff w=(L + 2*end) h=WN right_of=nd1 xspace=0.80           # VGND | n1 | X

  # ---------- p-row islands ----------
  pd1 = rect diff w=(2*L + 2*end + pitch) h=WP cx=cell.cx below=ntap   # VPWR | A | n1 | B | VPWR
  pd2 = rect diff w=(L + 2*end) h=WP right_of=pd1 xspace=0.80           # VPWR | n1 | X

  nim1 = enclose nd1 nsdm
  nim2 = enclose nd2 nsdm
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  # ---------- gates ----------
  ga = cross [nd1, pd1] poly w=L left=(nd1.left + end)          # gate A : M2 / M1
  gb = cross [nd1, pd1] poly w=L left=(ga.right + pitch)        # gate B : M4 / M3
  gn = cross [nd2, pd2] poly w=L left=(nd2.left + end)          # gate n1: M0 / M5

  # ---------- n-row contacts ----------
  sn  = array licon in=nd1 left_of=ga            # n1 (drain of M2)
  dn  = array licon in=nd1 right_of=gb           # VGND (source of M4)
  mid = array licon in=nd1 between=[ga, gb]      # n2 (shared M2 source / M4 drain)
  s0  = array licon in=nd2 left_of=gn            # VGND (drain of M0)
  d0  = array licon in=nd2 right_of=gn           # X   (source of M0)

  snl = enclose sn li net=n1
  dnl = enclose dn li
  xml = enclose mid li net=n2
  s0l = enclose s0 li
  d0l = enclose d0 li net=X

  gndn = strap li from=dnl to=vgnd_li
  gnd0 = strap li from=s0l to=vgnd_li cx=s0l.cx

  # ---------- p-row contacts ----------
  s1  = array licon in=pd1 left_of=ga            # VPWR (drain of M1)
  d3  = array licon in=pd1 right_of=gb           # VPWR (source of M3)
  midp= array licon in=pd1 between=[ga, gb]      # n1 (shared M1 source / M3 drain)
  d5  = array licon in=pd2 left_of=gn            # VPWR (drain of M5)
  s5  = array licon in=pd2 right_of=gn           # X   (source of M5)

  p1l = enclose s1 li
  p2l = enclose d3 li
  n1l = enclose midp li net=n1
  d5l = enclose d5 li
  s5l = enclose s5 li net=X

  p1  = strap li from=p1l to=vpwr_li
  p2  = strap li from=p2l to=vpwr_li
  p5  = strap li from=d5l to=vpwr_li cx=d5l.cx

  # ---------- gate contacts ----------
  cb = max(nd1.top + 0.19, snl.top + 0.25, dnl.top + 0.25, xml.top + 0.25)

  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb

  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx

  gna = enclose [gca, gcb, gcn] npc

  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  nn = enclose gcn li net=n1

  # ---------- n-well split ----------
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  # ---------- metal1 pins ----------
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bb
  bp = enclose bm m1 by=0.06 net=B

  xm = contact mcon in=d0l
  xp = enclose xm m1 by=0.06 net=X

  # ---------- internal nets n1, n2 ----------
  route n1 layers=m1,m2   # joins snl, n1l, nn (gate contact)
  route n2 layers=m1,m2   # joins xml (shared n2 diffusion)

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
