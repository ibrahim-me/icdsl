The failures come from running full-height vertical `li` straps for X/n1/A through the congested gate-contact gap, causing li/mcon spacing shorts and an open n1 (the gate contact gl1 was never tied to the n1 drain strap). I'll reorder the gates so the internal net n1 sits between the two gates, directly next to its gate contact, and keep every strap short and local.

```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # gate order left->right: A (g1), n1 (g2). n1 strap sits between the gates,
  # right next to the n1 gate contact; X strap is right of g2; rails left of g1.
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # centre-to-centre clearance for gate contacts
  x0 = cell.cx - (0.53 + 2*L + gap)/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # left of g1=A : n=VGND (M2 s), p=VPWR (M1 s)
  cn0 = array licon in=nd1 left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cp0 = array licon in=pd1 left_of=g1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  # between g1=A and g2=n1 : n=n1 (M2 d), p=n1 (M1 d)  -> n1 strap
  cn1 = array licon in=nd1 right_of=g1
  cn1l = enclose cn1 li net=n1
  cp1 = array licon in=pd1 left_of=g2
  cp1l = enclose cp1 li net=n1
  n1s = strap li from=cn1l to=cp1l net=n1
  # right of g2=n1 : n=X (M0 s), p=X (M3 s)  -> X output strap
  cnX = array licon in=nd1 right_of=g2
  cnXl = enclose cnX li net=X
  cpX = array licon in=pd1 right_of=g2
  cpXl = enclose cpX li net=X
  Xs = strap li from=cnXl to=cpXl net=X
  # gate contacts in the gap between the rows; n1 gate contact tied to the n1 strap
  cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cnXl.top + 0.25)
  gcA = contact licon cx=g1.cx bottom=cb
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A
  gcn1 = contact licon cx=g2.cx bottom=cb
  gpn1 = enclose gcn1 poly by=minx
  gln1 = enclose gcn1 li net=n1
  n1j = strap li from=gln1 to=n1s net=n1
  gn = enclose [gcA, gcn1] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  # ports on met1
  aM = contact mcon in=glA
  aP = enclose aM m1 by=0.06 net=A
  port A in on=aP
  xM = contact mcon in=Xs
  xP = enclose xM m1 by=0.06 net=X
  port X out on=xP
end
```