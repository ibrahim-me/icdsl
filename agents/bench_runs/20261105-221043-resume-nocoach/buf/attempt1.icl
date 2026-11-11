pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81
  gap = max(0.28, 0.54 - L)          # contact column room + poly-pad spacing (0.54 pitch)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # both rows: X | gate n1 | supply | gate A | n1
  gn1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)   # gate n1 (M0 n, M3 p)
  ga  = cross [nd, pd] poly w=L left=(gn1.right + gap)   # gate A  (M2 n, M1 p)
  sn  = array licon in=nd left_of=gn1                    # X (M0 source)
  cn  = array licon in=nd right_of=gn1 left_of=ga        # VGND (M0 drain = M2 source)
  dn  = array licon in=nd right_of=ga                    # n1 (M2 drain)
  sp  = array licon in=pd left_of=gn1                    # X (M3 source)
  cp  = array licon in=pd right_of=gn1 left_of=ga        # VPWR (M1 source = M3 drain)
  dp  = array licon in=pd right_of=ga                    # n1 (M1 drain)
  snl = enclose sn li net=X
  spl = enclose sp li net=X
  cnl = enclose cn li
  cpl = enclose cp li
  dnl = enclose dn li net=n1
  dpl = enclose dp li net=n1
  xst = strap li from=snl to=spl net=X                   # X: n-row and p-row source columns
  nst = strap li from=dnl to=dpl net=n1                  # n1: n-row and p-row drain columns
  gnd = strap li from=cnl to=vgnd_li
  pwr = strap li from=cpl to=vpwr_li
  route X  layers=m1,m2
  route n1 layers=m1,m2
  # gate contacts in the gap between the rows (n-row items only in cb)
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gcn = contact licon cx=gn1.cx bottom=cb
  gca = contact licon cx=ga.cx  bottom=cb
  gpn = enclose gcn poly by=minx
  gpa = enclose gca poly by=minx
  gn  = enclose [gcn, gca] npc
  nn  = enclose gcn li net=n1
  aa  = enclose gca li net=A
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # ports on met1
  nm  = contact mcon in=nn
  np  = enclose nm m1 by=0.06 net=n1
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  xm  = contact mcon in=snl
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
