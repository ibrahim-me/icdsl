```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=5 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # gate pitch: room for a contact column (0.28) and for the poly contact pads (0.54)
  gpitch = max(0.28, 0.54 - L)
  dw     = 2*0.265 + 2*L + gpitch          # 0.265 = end contact to diff edge

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate A
  gb = cross [nd, pd] poly w=L left=(ga.right + gpitch)        # gate B

  # n row: Y | A | n1(shared, no contact) | B | VGND
  cn  = array licon in=nd left_of=ga          # Y (n side)
  cv  = array licon in=nd right_of=gb         # VGND
  cnl = enclose cn li net=Y
  cvl = enclose cv li
  gnd = strap li from=cvl to=vgnd_li

  # p row: VPWR | A | Y | B | VPWR
  cp1 = array licon in=pd left_of=ga          # VPWR
  cp2 = array licon in=pd right_of=ga         # Y (p side)
  cp3 = array licon in=pd right_of=gb         # VPWR
  cp1l = enclose cp1 li net=VPWR
  cp2l = enclose cp2 li net=Y
  cp3l = enclose cp3 li net=VPWR
  p1  = strap li from=cp1l to=vpwr_li
  p2  = strap li from=cp3l to=vpwr_li

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, cnl.top + 0.25, cvl.top + 0.25)
  gc1 = contact licon cx=ga.cx bottom=cb
  gc2 = contact licon cx=gb.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gn  = enclose [gc1, gc2] npc
  a   = enclose gc1 li net=A
  b   = enclose gc2 li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output Y: n-side left contact and p-side middle contact do not line up -> route
  route Y layers=m1,m2

  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B
  port A in  on=ap
  port B in  on=bp
  port Y out
end
```