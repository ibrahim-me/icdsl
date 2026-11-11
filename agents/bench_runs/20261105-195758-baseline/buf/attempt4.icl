pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=4 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81                      # n1 | A | VGND | n1 | X  (contact column between gates -> 0.28)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn  = array licon in=nd left_of=ga            # n: n1 | A | VGND | n1 | X
  svn = array licon in=nd right_of=ga           # n-row middle column (VGND)
  dn  = array licon in=nd right_of=gn
  sp  = array licon in=pd left_of=ga            # p: n1 | A | VPWR | n1 | X
  svp = array licon in=pd right_of=ga           # p-row middle column (VPWR)
  dp  = array licon in=pd right_of=gn
  snl = enclose sn li net=n1
  svnl= enclose svn li
  dnl = enclose dn li net=X
  spl = enclose sp li net=n1
  svpl= enclose svp li
  dpl = enclose dp li net=X
  gnd = strap li from=svnl to=vgnd_li           # n-row middle column -> VGND rail
  pwr = strap li from=svpl to=vpwr_li           # p-row middle column -> VPWR rail
  n1s = strap li from=snl to=spl net=n1         # joins n1 diff columns of the two rows
  xs  = strap li from=dnl to=dpl net=X          # joins X diff columns of the two rows

  cb  = max(nd.top + 0.19, snl.top + 0.25, svnl.top + 0.25, dnl.top + 0.25)   # gap above n-row only
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcn = contact licon cx=(gn.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gna = enclose [gca, gcn] npc
  a   = enclose gca li net=A
  n1g = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  n1m = contact mcon in=n1g
  n1p = enclose n1m m1 by=0.06 net=n1
  xm  = contact mcon in=dpl
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
