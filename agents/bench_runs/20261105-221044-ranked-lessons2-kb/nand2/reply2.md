```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  gap  = max(0.28, 0.54 - L)          # gate-centre pitch = L + gap >= 0.54 (gate-contact pads)
  dw   = 2*0.265 + 2*L + gap          # end contacts + two gates + inter-gate gap

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gap)

  # n row: Y | M3(A) | n1 | M2(B) | VGND   (n1 is a series node, no contact)
  nY  = array licon in=nd left_of=ga
  nV  = array licon in=nd right_of=gb
  nYl = enclose nY li net=Y
  nVl = enclose nV li
  gnd = strap li from=nVl to=vgnd_li

  # p row: VPWR | M0(A) | Y | M1(B) | VPWR   (Y contact sits on the n-side Y column)
  pV1 = array licon in=pd left_of=ga
  pV2 = array licon in=pd right_of=gb
  pV1l = enclose pV1 li
  pV2l = enclose pV2 li
  pwr1 = strap li from=pV1l to=vpwr_li
  pwr2 = strap li from=pV2l to=vpwr_li

  # gate contacts on their own gates, in the gap between the rows (n-row items only)
  cb = max(nd.top + 0.19, nYl.top + 0.25, nVl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  route Y layers=m1,m2                    # joins n-side Y (left of A) to p-side Y pin

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=nYl
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
```