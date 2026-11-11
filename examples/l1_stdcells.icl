# Level 1 - standard cells drawn with relative geometry (no raw design-rule numbers needed:
# 'min' resolves to the rule for the layers involved).
pdk sky130A

stdcell inv1 width=3                       # 1.38 x 2.72 um, rails + taps + n-well from the template
  device MN nmos w=0.52 l=0.15 d=Y g=A s=VGND
  device MP pmos w=0.77 l=0.15 d=Y g=A s=VPWR

  # diffusions: n just above the p-tap, p just below the n-tap (space=min is implied)
  nd  = rect diff w=0.68 h=0.52 cx=cell.cx above=ptap
  pd  = rect diff w=0.68 h=0.77 cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # one gate crossing both diffusions; endcaps are the rule minimum
  g   = cross [nd, pd] poly w=0.15

  # source / drain contact columns beside the gate, with li straps
  sn  = array licon in=nd left_of=g          # gap = licon-to-gate minimum
  dn  = array licon in=nd right_of=g
  sp  = array licon in=pd left_of=g
  dp  = array licon in=pd right_of=g
  snl = enclose sn li
  dnl = enclose dn li
  spl = enclose sp li
  dpl = enclose dp li
  gnd = strap li from=snl to=vgnd_li         # sources to the rails
  pwr = strap li from=spl to=vpwr_li
  y   = strap li from=dnl to=dpl net=Y      # drains joined: output

  # gate contact: left of the output strap, above the n-diffusion
  gc  = contact licon left_of=y xspace=0.17 above=nd     # 0.17 = li spacing to the output strap
  gp  = enclose gc poly by=minx              # poly pad (0.08 on the sides that reach the gate)
  gn  = enclose gc npc
  a   = enclose gc li net=A

  # met1 pins so a parent router can land on them (0.06 enclosure keeps the pad above min area)
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  ym  = contact mcon in=y cy=(y.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port Y out on=yp
end

stdcell nand2 width=4                      # 1.84 x 2.72 um
  device MNA nmos w=0.52 l=0.15 d=n1 g=A s=VGND
  device MNB nmos w=0.52 l=0.15 d=Y  g=B s=n1
  device MPA pmos w=0.77 l=0.15 d=Y  g=A s=VPWR
  device MPB pmos w=0.77 l=0.15 d=Y  g=B s=VPWR

  nd  = rect diff w=1.11 h=0.52 cx=cell.cx above=ptap
  pd  = rect diff w=1.11 h=0.77 cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=0.15 left=(nd.left + 0.265)       # 0.265 = contact + its enclosures
  gb  = cross [nd, pd] poly w=0.15 right=(nd.right - 0.265)

  # n stack: VGND | A gate | n1 (no contact) | B gate | Y
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=gb
  # p side: VPWR | A | Y | B | VPWR  (parallel)
  s1  = array licon in=pd left_of=ga
  my  = array licon in=pd right_of=ga
  s2  = array licon in=pd right_of=gb
  snl = enclose sn li
  dnl = enclose dn li net=Y
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li
  gnd = strap li from=snl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  # gate contacts in the gap between the diffusions, pushed apart so the poly pads clear each other
  gca = contact licon cx=(ga.cx - 0.1) above=nd
  gcb = contact licon cx=(gb.cx + 0.1) above=nd
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gna = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B

  # met1 pins (parent-router friendly); the Y route below must keep clear of A and B
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y

  route Y layers=m1                          # level-4 router joins the Y pin to the n-side drain

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
