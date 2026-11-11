pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=3 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # gate order A | B ; n-side: Y | A | n1 | B | VGND ; p-side: VPWR | A | Y | B | VPWR
  gap = max(0.28, 0.54 - L)                 # contact column (p-side Y) + gate-contact pitch
  span = 2*0.265 + 2*L + gap                # end contacts + two gates + middle gap
  x0 = cell.cx - span/2
  ny0 = ptap.top + 0.27                     # n row bottom (diff-to-tap)
  py1 = ntap.bottom - 0.27                  # p row top

  g1 = cross [nd, pd] poly w=L left=x0                                  # gate A
  g2 = cross [nd, pd] poly w=L left=(g1.right + gap)                    # gate B

  nd  = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN) above=ptap
  pd  = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1) below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  sn  = array licon in=nd left_of=g1            # n-side Y (M3 source)
  dn  = array licon in=nd right_of=g2           # n-side VGND (M2 drain)
  s1  = array licon in=pd left_of=g1            # p-side VPWR (M0 source)
  my  = array licon in=pd right_of=g1           # p-side Y (M0 drain / M1 source)
  s2  = array licon in=pd right_of=g2           # p-side VPWR (M1 drain)

  snl = enclose sn li net=Y
  dnl = enclose dn li
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li

  gnd = strap li from=dnl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li
  yst = strap li from=snl to=myl net=Y          # joins n-side Y to p-side Y

  cb = max(nd.top + 0.19, snl.top + 0.25)       # n-row items only (coach note 1)
  gc1 = contact licon cx=g1.cx bottom=cb        # gate contact on gate A
  gc2 = contact licon cx=g2.cx bottom=cb        # gate contact on gate B
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gn  = enclose [gc1, gc2] npc
  a   = enclose gc1 li net=A
  b   = enclose gc2 li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B
  ym = contact mcon in=myl
  yp = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
