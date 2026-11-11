pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw1 = 0.265 + L + 0.28                  # left island: end contact | gate | contact
  dw2 = 0.28 + L + 0.265                  # right island: contact | gate | end contact
  gap = 0.80                              # diffusion island break between ga and gn
  cx0 = cell.cx - (dw1 + gap + dw2) / 2
  nd1 = rect diff w=dw1 h=WN cx=cx0 above=ptap
  nd2 = rect diff w=dw2 h=WN cx=(cx0 + dw1/2 + gap + dw2/2) above=ptap
  pd1 = rect diff w=dw1 h=WP cx=cx0 below=ntap
  pd2 = rect diff w=dw2 h=WP cx=(cx0 + dw1/2 + gap + dw2/2) below=ntap
  nim1 = enclose nd1 nsdm
  nim2 = enclose nd2 nsdm
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm
  ga  = cross [nd1, pd1] poly w=L left=(nd1.left + 0.265)
  gn  = cross [nd2, pd2] poly w=L left=(nd2.left + 0.265)

  # left island: VGND | ga(A) | n1   (M2: source VGND, drain n1)
  cn0 = array licon in=nd1 left_of=ga           net=VGND
  cn1 = array licon in=nd1 right_of=ga          net=n1
  cp0 = array licon in=pd1 left_of=ga           net=VPWR
  cp1 = array licon in=pd1 right_of=ga          net=n1
  cn0l = enclose cn0 li net=VGND
  cn1l = enclose cn1 li net=n1
  cp0l = enclose cp0 li net=VPWR
  cp1l = enclose cp1 li net=n1
  gnd0 = strap li from=cn0l to=vgnd_li
  pwr0 = strap li from=cp0l to=vpwr_li

  # right island: X | gn(n1) | VGND   (M0: source X, drain VGND)
  cn2 = array licon in=nd2 left_of=gn           net=X
  cn3 = array licon in=nd2 right_of=gn          net=VGND
  cp2 = array licon in=pd2 left_of=gn           net=X
  cp3 = array licon in=pd2 right_of=gn          net=VPWR
  cn2l = enclose cn2 li net=X
  cn3l = enclose cn3 li net=VGND
  cp2l = enclose cp2 li net=X
  cp3l = enclose cp3 li net=VPWR
  gnd3 = strap li from=cn3l to=vgnd_li
  pwr3 = strap li from=cp3l to=vpwr_li

  # output X: n- and p-side drains line up (left of gn)
  xy  = strap li from=cn2l to=cp2l net=X

  # gate contacts on their own gates, centred (pitch 1.495 keeps poly pads clear)
  cb  = max(nd1.top + 0.19, cn1l.top + 0.25, cn0l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gnall = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  nn  = enclose gcn li net=n1
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  # internal net n1: n-row drain, p-row drain and the n1 gate contact
  route n1 layers=m1,m2

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  xm  = contact mcon in=xy cy=(nd1.cy)
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
