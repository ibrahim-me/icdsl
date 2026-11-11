The congestion comes from full-height `li` straps running through the gate-contact gap, and from placing drain contact columns immediately next to gate-contact pads (the 0.33-wide poly pad needs 0.17 clearance to other-net li, which a 0.54 gate pitch can't also fit a contact column in). Fix: connect each net with a short vertical strap at its own contact column, then run the nets out horizontally on **metal2** above the contacts (met2 is over routing, no li-li DRC), and drop to met1 only at the port mcon. Gate contacts sit on their own gates; n1 ties its gate contact to the drain strap with a short local link.

```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # gate order: A (g1), n1 (g2); pitch 0.54 so gate-contact pads clear
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  x0 = cell.cx - (0.53 + 2*L + 0.54 - L)/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + 0.54 - L) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
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
  # between g1 and g2 : n=n1 (M2 d), p=n1 (M1 d) -> short vertical n1 strap
  cn1 = array licon in=nd1 right_of=g1
  cn1l = enclose cn1 li net=n1
  cp1 = array licon in=pd1 left_of=g2
  cp1l = enclose cp1 li net=n1
  n1s = strap li from=cn1l to=cp1l net=n1
  # right of g2=n1 : n=X (M0 s), p=X (M3 s) -> short vertical X strap
  cnX = array licon in=nd1 right_of=g2
  cnXl = enclose cnX li net=X
  cpX = array licon in=pd1 right_of=g2
  cpXl = enclose cpX li net=X
  Xs = strap li from=cnXl to=cpXl net=X
  # gate contacts on their own gates; n1 gate contact tied to the n1 strap
  cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cnXl.top + 0.25)
  gcA = contact licon cx=g1.cx bottom=cb
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A
  gcn1 = contact licon cx=g2.cx bottom=cb
  gpn1 = enclose gcn1 poly by=minx
  gln1 = enclose gcn1 li net=n1
  n1j = strap li from=gln1 to=cn1l net=n1
  gn = enclose [gcA, gcn1] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  # metal2 trunks above the straps (no li-li DRC), drop to met1 at the ports
  n1t = strap m2 from=cn1l to=cp1l net=n1
  Xt = strap m2 from=cnXl to=cpXl net=X
  At = strap m2 from=gcA to=gcn1 net=A
  n1m = contact mcon in=n1t
  n1p = enclose n1m m1 by=0.06 net=n1
  Xm = contact mcon in=Xt
  Xp = enclose Xm m1 by=0.06 net=X
  Am = contact mcon in=At
  Ap = enclose Am m1 by=0.06 net=A
  port A in on=Ap
  port X out on=Xp
end
```