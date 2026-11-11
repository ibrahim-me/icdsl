pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  gap_ab = max(0.28, 0.54 - L)
  gap_bc = 0.80

  # n-row: VGND-A1-n2-A2 |break| Y-B1-Y
  ndl_w = 0.265 + L + gap_ab + L + 0.265
  ndr_w = 0.265 + L + 0.265
  ndl = rect diff w=ndl_w h=WN cx=(cell.cx - (ndl_w + gap_bc + ndr_w)/2 + ndl_w/2) above=ptap
  ndr = rect diff w=ndr_w h=WN right_of=ndl gap=gap_bc above=ptap
  nim = enclose ndl nsdm
  nim2 = enclose ndr nsdm

  # p-row: n1-A1-VPWR |break| Y-A2-n1 |break| VPWR-B1-Y
  pd1_w = 0.265 + L + gap_bc + L + 0.265
  pd2_w = 0.265 + L + gap_bc + L + 0.265
  pd3_w = 0.265 + L + 0.265
  pdw = pd1_w + gap_bc + pd2_w + gap_bc + pd3_w
  pd1 = rect diff w=pd1_w h=WP cx=(cell.cx - pdw/2 + pd1_w/2) below=ntap
  pd2 = rect diff w=pd2_w h=WP right_of=pd1 gap=gap_bc below=ntap
  pd3 = rect diff w=pd3_w h=WP right_of=pd2 gap=gap_bc below=ntap
  pim = enclose [pd1, pd2, pd3] psdm

  # Gates: A1, A2, B1 - same x positions for both rows
  # n-row: ga in ndl, gb in ndl, gc in ndr
  # p-row: ga in pd1, gb in pd2, gc in pd3
  ga  = cross [ndl, pd1] poly w=L left=(ndl.left + 0.265)
  gb  = cross [ndl, pd2] poly w=L left=(ga.right + gap_ab)
  gc  = cross [ndr, pd3] poly w=L left=(ndr.left + 0.265)

  # n-row contacts
  sn  = array licon in=ndl left_of=ga          # VGND (M2 source)
  n2c = array licon in=ndl between=[ga, gb]    # n2 (M2 drain, M5 source)
  dnl = array licon in=ndl right_of=gb         # VGND (M5 drain)
  snl = enclose sn li
  n2l = enclose n2c li net=n2
  dnll = enclose dnl li net=VGND
  n3c = array licon in=ndr left_of=gc          # Y (M3 source)
  n4c = array licon in=ndr right_of=gc         # Y (M3 drain)
  n3l = enclose n3c li net=Y
  n4l = enclose n4c li net=Y

  # p-row contacts
  s1  = array licon in=pd1 left_of=ga          # n1 (M4 source)
  d1  = array licon in=pd1 right_of=ga         # VPWR (M4 drain)
  s1l = enclose s1 li net=n1
  d1l = enclose d1 li net=VPWR
  s2  = array licon in=pd2 left_of=gb          # Y (M0 source)
  d2  = array licon in=pd2 right_of=gb         # n1 (M0 drain)
  s2l = enclose s2 li net=Y
  d2l = enclose d2 li net=n1
  s3  = array licon in=pd3 left_of=gc          # VPWR (M1 source)
  d3  = array licon in=pd3 right_of=gc         # Y (M1 drain)
  s3l = enclose s3 li net=VPWR
  d3l = enclose d3 li net=Y

  # Supply straps
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dnll to=vgnd_li
  p1  = strap li from=d1l to=vpwr_li
  p2  = strap li from=s3l to=vpwr_li

  # Gate contacts - shifted to avoid diffusion contacts
  cb  = max(ndl.top + 0.19, snl.top + 0.25, n2l.top + 0.25, dnll.top + 0.25, n3l.top + 0.25, n4l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A1
  b   = enclose gcb li net=A2
  c   = enclose gcc li net=B1
  well y=((ndl.top + 0.34 + pd1.bottom - 0.18) / 2)

  # Port contacts
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A1
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=A2
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=B1

  # Output Y: n-row right + p-row right + p-row middle-left
  ym  = contact mcon in=n4l
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  # Internal net n1: p-row left + p-row middle-right
  n1m = contact mcon in=s1l
  n1p = enclose n1m m1 by=0.06 net=n1
  route n1 layers=m1,m2

  # Internal net n2: n-row middle + n-row right
  n2m = contact mcon in=n2l
  n2p = enclose n2m m1 by=0.06 net=n2
  route n2 layers=m1,m2

  port A1 in  on=ap
  port A2 in  on=bp
  port B1 in  on=cp
  port Y out on=yp
end
