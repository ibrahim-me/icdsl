pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + L                       # one gate with end diffusion contacts
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  nd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # Left side: source contacts (VGND on n, VPWR on p)
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c3 = array licon in=pd1 left_of=g1
  c3l = enclose c3 li net=VPWR
  c3s = strap li from=c3l to=vpwr_li
  # Right side: drain contacts (Y on both n and p)
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=Y
  c4 = array licon in=pd1 right_of=g1
  c4l = enclose c4 li net=Y
  # Output strap joins n and p drains on the right side of the gate
  ys = strap li from=c2l to=c4l
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25)
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gn = enclose [gc1] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  # Port A on the gate contact
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  # Port Y on the output strap, placed in the p-row band (away from gate-contact height)
  ym = contact mcon in=ys cy=(py1 - WP/2)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
