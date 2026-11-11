pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=8 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  # Gate order (left to right): A, B, n1  -- same for n and p rows, full sharing, no breaks
  # n-row: n1 | A | n2 | B | VGND | n1 | X
  # p-row: VPWR | A | n1 | B | VPWR | n1 | X
  dw  = 4*L + 4*0.265 + 3*0.28        # 4 diffusion columns + end contacts + 3 inter-gate contact columns
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate A
  gb = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))   # gate B
  gn = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))   # gate n1

  # n-row diffusion columns: n1 | n2 | VGND | X  (left to right)
  cn1 = array licon in=nd left_of=ga            # n1 (M2.d) -- left of gate A
  cn2 = array licon in=nd between=[ga, gb]      # n2 (M2.s = M4.d) -- between A and B
  cvn = array licon in=nd between=[gb, gn]      # VGND (M4.s = M0.d) -- between B and n1
  cx  = array licon in=nd right_of=gn           # X (M0.s) -- right of gate n1

  # p-row diffusion columns: VPWR | n1 | VPWR | X  (left to right)
  cpw = array licon in=pd left_of=ga            # VPWR (M1.d) -- left of gate A
  cpn = array licon in=pd between=[ga, gb]      # n1 (M1.s = M3.d) -- between A and B
  cpw2 = array licon in=pd between=[gb, gn]     # VPWR (M3.s = M5.d) -- between B and n1
  cpx = array licon in=pd right_of=gn           # X (M5.s) -- right of gate n1

  cn1l = enclose cn1 li net=n1
  cn2l = enclose cn2 li
  cvnl = enclose cvn li
  cxl  = enclose cx li net=X
  cpwl = enclose cpw li
  cpnl = enclose cpn li net=n1
  cpw2l = enclose cpw2 li
  cpxl = enclose cpx li net=X

  # Supply straps
  gnd = strap li from=cvnl to=vgnd_li
  pwr1 = strap li from=cpwl to=vpwr_li
  pwr2 = strap li from=cpw2l to=vpwr_li

  # Gate contacts: bottom set by n-row only (lesson 1). Shift symmetrically by 0.1 so contacts
  # on adjacent gates keep 0.17 edge-to-edge (pitch 0.54 - 0.2 = 0.34 center-to-center).
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25, cvnl.top + 0.25, cxl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcn = contact licon cx=(gn.cx - 0.1) bottom=cb     # shift left, away from output strap on right
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gn_all = enclose [gca, gcb, gcn] npc

  # Gate contact li nets: n1 gate contact carries net n1 (drives inverter)
  a  = enclose gca li net=A
  b  = enclose gcb li net=B
  n1 = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Input pins
  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B

  # Output X: n and p drains line up (rightmost column) -> strap
  yx = strap li from=cxl to=cpxl net=X
  xm = contact mcon in=yx cy=(pd.cy - 0.3)
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp

  # Internal net n1: n-row col0 and p-row col1 don't line up -> route
  route n1 layers=m1,m2

  port A in  on=ap
  port B in  on=bp
end
