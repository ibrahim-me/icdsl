pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  gpitch = max(0.28, 0.54 - L)          # gate-to-gate L-to-L (contact column between)
  spitch = max(0.21, 0.54 - L)          # series node, no contact between gates
  endc   = 0.265                        # end contact column

  dw = 2*endc + 5*L + 2*gpitch + 2*spitch   # p-row: end S end S end A0 end A1 end n1 end
  ndw1 = 2*endc + 2*L + gpitch              # n island 1: end S end S end
  ndw2 = 2*endc + 2*L + gpitch              # n island 2: end A0 end A1 end
  ndw3 = 2*endc + L                         # n island 3: end n1 end

  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm

  nd1 = rect diff w=ndw1 h=WN cx=cell.cx above=ptap
  nd2 = rect diff w=ndw2 h=WN cx=cell.cx above=ptap
  nd3 = rect diff w=ndw3 h=WN cx=cell.cx above=ptap
  nim1 = enclose nd1 nsdm
  nim2 = enclose nd2 nsdm
  nim3 = enclose nd3 nsdm

  # ---------------- p row: n1 | S | VPWR | S | n2 | A0 | Y | A1 | n4 | n1 | VPWR ----------------
  pg1 = cross [pd] poly w=L left=(pd.left + endc)            # S  : M0 (d=n1,s=VPWR)
  pg2 = cross [pd] poly w=L left=(pg1.right + gpitch)        # S  : M1 (d=VPWR,s=n2)
  pg3 = cross [pd] poly w=L left=(pg2.right + spitch)        # A0 : M2 (d=n2,s=Y)
  pg4 = cross [pd] poly w=L left=(pg3.right + gpitch)        # A1 : M7 (d=Y,s=n4)
  pg5 = cross [pd] poly w=L left=(pg4.right + spitch)        # n1 : M4 (d=n4,s=VPWR)

  ps0 = array licon in=pd left_of=pg1 net=n1
  ps1 = array licon in=pd right_of=pg1 left_of=pg2 net=VPWR
  ps2 = array licon in=pd right_of=pg2 left_of=pg3 net=n2
  ps3 = array licon in=pd right_of=pg3 left_of=pg4 net=Y
  ps4 = array licon in=pd right_of=pg4 left_of=pg5 net=n4
  ps5 = array licon in=pd right_of=pg5 net=VPWR
  ps0l = enclose ps0 li net=n1
  ps1l = enclose ps1 li
  ps2l = enclose ps2 li net=n2
  ps3l = enclose ps3 li net=Y
  ps4l = enclose ps4 li net=n4
  ps5l = enclose ps5 li
  pwr1 = strap li from=ps1l to=vpwr_li
  pwr2 = strap li from=ps5l to=vpwr_li

  # ---------------- n row island 1: n3 | S | VGND | S | n1  (gates pg1, pg2) ----------------
  ng1a = array licon in=nd1 left_of=pg1 net=n3
  ng1b = array licon in=nd1 right_of=pg1 left_of=pg2 net=VGND
  ng1c = array licon in=nd1 right_of=pg2 net=n1
  ng1al = enclose ng1a li net=n3
  ng1bl = enclose ng1b li
  ng1cl = enclose ng1c li net=n1
  gnd1 = strap li from=ng1bl to=vgnd_li

  # ---------------- n row island 2: n5 | A0 | Y | A1 | n3  (gates pg3, pg4) ----------------
  ng2a = array licon in=nd2 left_of=pg3 net=n5
  ng2b = array licon in=nd2 right_of=pg3 left_of=pg4 net=Y
  ng2c = array licon in=nd2 right_of=pg4 net=n3
  ng2al = enclose ng2a li net=n5
  ng2bl = enclose ng2b li net=Y
  ng2cl = enclose ng2c li net=n3

  # ---------------- n row island 3: VGND | n1 | n5  (gate pg5) ----------------
  ng3a = array licon in=nd3 left_of=pg5 net=VGND
  ng3b = array licon in=nd3 right_of=pg5 net=n5
  ng3al = enclose ng3a li
  ng3bl = enclose ng3b li net=n5
  gnd2 = strap li from=ng3al to=vgnd_li

  # ---------------- gate contacts (n-row items only in cb) ----------------
  cb = max(nd1.top + 0.19, ng1al.top + 0.25, ng1bl.top + 0.25, ng1cl.top + 0.25,
              ng2al.top + 0.25, ng2bl.top + 0.25, ng2cl.top + 0.25,
              ng3al.top + 0.25, ng3bl.top + 0.25)
  gcS1 = contact licon cx=pg1.cx bottom=cb
  gcS2 = contact licon cx=pg2.cx bottom=cb
  gcA0 = contact licon cx=pg3.cx bottom=cb
  gcA1 = contact licon cx=pg4.cx bottom=cb
  gcN1 = contact licon cx=pg5.cx bottom=cb
  gpS1 = enclose gcS1 poly by=minx
  gpS2 = enclose gcS2 poly by=minx
  gpA0 = enclose gcA0 poly by=minx
  gpA1 = enclose gcA1 poly by=minx
  gpN1 = enclose gcN1 poly by=minx
  gn   = enclose [gcS1, gcS2, gcA0, gcA1, gcN1] npc
  s    = enclose [gcS1, gcS2] li net=S
  a0   = enclose gcA0 li net=A0
  a1   = enclose gcA1 li net=A1
  n1g  = enclose gcN1 li net=n1

  well y=((nd1.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------------- internal nets: route n1, n3, n5, Y on m1/m2 ----------------
  n1m = contact mcon in=ps0l
  n1p = enclose n1m m1 by=0.06 net=n1
  n1m2= contact mcon in=ng1cl
  n1p2= enclose n1m2 m1 by=0.06 net=n1
  route n1 layers=m1,m2

  n3m = contact mcon in=ng1al
  n3p = enclose n3m m1 by=0.06 net=n3
  n3m2= contact mcon in=ng2cl
  n3p2= enclose n3m2 m1 by=0.06 net=n3
  route n3 layers=m1,m2

  n5m = contact mcon in=ng2al
  n5p = enclose n5m m1 by=0.06 net=n5
  n5m2= contact mcon in=ng3bl
  n5p2= enclose n5m2 m1 by=0.06 net=n5
  route n5 layers=m1,m2

  ym  = contact mcon in=ps3l
  yp  = enclose ym m1 by=0.06 net=Y
  ym2 = contact mcon in=ng2bl
  yp2 = enclose ym2 m1 by=0.06 net=Y
  route Y layers=m1,m2

  # ---------------- ports ----------------
  sm  = contact mcon in=s
  sp  = enclose sm m1 by=0.06 net=S
  a0m = contact mcon in=a0
  a0p = enclose a0m m1 by=0.06 net=A0
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  port S in  on=sp
  port A0 in on=a0p
  port A1 in on=a1p
  port Y out on=yp
end
