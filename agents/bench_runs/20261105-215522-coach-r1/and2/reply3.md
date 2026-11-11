```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  gap = max(0.28, 0.54 - L)          # gate pitch = L + gap = 0.54 (gate-contact pads clear)
  dw  = 3*L + 2*0.265 + 2*gap        # end contacts + 3 gates + 2 gaps
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  gn  = cross [nd, pd] poly w=L left=(nd.left + 0.265)   # gate n1
  gb  = cross [nd, pd] poly w=L left=(gn.right + gap)    # gate B
  ga  = cross [nd, pd] poly w=L left=(gb.right + gap)    # gate A

  # n row: X | VGND | n2 | n1   (gates n1, B, A)
  sxn = array licon in=nd left_of=gn net=X
  svn = array licon in=nd right_of=gn net=VGND
  sn2 = array licon in=nd right_of=gb net=n2
  sn1 = array licon in=nd right_of=ga net=n1
  sxnl = enclose sxn li net=X
  svnl = enclose svn li net=VGND
  sn2l = enclose sn2 li net=n2
  sn1l = enclose sn1 li net=n1
  gndn = strap li from=svnl to=vgnd_li

  # p row: X | VPWR | n1 | VPWR   (gates n1, B, A)
  sxp = array licon in=pd left_of=gn net=X
  sp1 = array licon in=pd right_of=gn net=VPWR
  spn = array licon in=pd right_of=gb net=n1
  sp2 = array licon in=pd right_of=ga net=VPWR
  sxpl = enclose sxp li net=X
  spl1 = enclose sp1 li net=VPWR
  spnl = enclose spn li net=n1
  spl2 = enclose sp2 li net=VPWR
  pwr1 = strap li from=spl1 to=vpwr_li
  pwr2 = strap li from=spl2 to=vpwr_li

  # gate contacts in the gap between rows (cb from n-row items only).
  # n1 gate contact shifted right so its poly pad clears the X strap (left of gn);
  # B and A gate contacts centred on their gates (pitch 0.54 keeps pads 0.21 apart).
  cb = max(nd.top + 0.19, sn1l.top + 0.25, sn2l.top + 0.25, svnl.top + 0.25, sxnl.top + 0.25)
  gcn = contact licon cx=(gn.cx + 0.13) bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gca = contact licon cx=ga.cx bottom=cb
  gpn = enclose gcn poly by=minx
  gpb = enclose gcb poly by=minx
  gpa = enclose gca poly by=minx
  gnall = enclose [gcn, gcb, gca] npc
  nn = enclose gcn li net=n1
  bb = enclose gcb li net=B
  aa = enclose gca li net=A

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output X: n-side and p-side drains line up vertically (both left_of=gn)
  yx = strap li from=sxnl to=sxpl net=X

  # internal net n1: sn1l (n row), spnl (p row), nn (gate contact) joined by m1/m2
  route n1 layers=m1,m2

  # input / output met1 pins
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bb
  bp = enclose bm m1 by=0.06 net=B
  xm = contact mcon in=yx cy=(nd.top + (pd.bottom - nd.top)/2)
  xp = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```