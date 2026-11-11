pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=7 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # Diffusion columns (left to right): X | gate_n1 | VGND/VPWR | gate_A | n1
  # dw = 2 end contacts (0.265 each) + 3 middle contacts (0.28 each) + 2 gates (L each)
  dw  = 2*0.265 + 3*0.28 + 2*L
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # Gates: gate_n1 then gate_A (same order in both rows)
  gn1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga  = cross [nd, pd] poly w=L left=(gn1.right + max(0.28, 0.54 - L))

  # Diffusion contacts: X | (gn1) | VGND/VPWR | (ga) | n1
  cx  = array licon in=nd left_of=gn1          # n-row X (output)
  cvn = array licon in=nd right_of=gn1         # n-row VGND
  cn1 = array licon in=nd right_of=ga          # n-row n1 (internal)
  cvp = array licon in=pd right_of=gn1         # p-row VPWR
  cp1 = array licon in=pd right_of=ga          # p-row n1 (internal)

  cxl = enclose cx li net=X
  cvnl = enclose cvn li
  cn1l = enclose cn1 li net=n1
  cvpl = enclose cvp li
  cp1l = enclose cp1 li net=n1

  # Supply straps
  gnd = strap li from=cvnl to=vgnd_li
  pwr = strap li from=cvpl to=vpwr_li

  # Gate contacts: cb from n-row items only (lesson 1)
  cb  = max(nd.top + 0.19, cxl.top + 0.25, cn1l.top + 0.25)
  gcn1 = contact licon cx=(gn1.cx - 0.1) bottom=cb
  gca  = contact licon cx=(ga.cx + 0.1) bottom=cb
  gpn1 = enclose gcn1 poly by=minx
  gpa  = enclose gca poly by=minx
  gn   = enclose [gcn1, gca] npc

  # Gate contact li: A on gate_A, n1 on gate_n1
  aa  = enclose gca li net=A
  nn  = enclose gcn1 li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Output: X contact on n-row X column, m1 pin
  xm  = contact mcon in=cxl
  xp  = enclose xm m1 by=0.06 net=X

  # Input A: m1 pin on gate_A contact li
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A

  # Internal net n1: m1 anchors on gate_n1 contact li, n-row n1 contact, p-row n1 contact
  n1n = contact mcon in=nn
  n1pn = enclose n1n m1 by=0.06 net=n1
  n1m = contact mcon in=cn1l
  n1p = enclose n1m m1 by=0.06 net=n1
  n1c = contact mcon in=cp1l
  n1cp = enclose n1c m1 by=0.06 net=n1
  route n1 layers=m1

  port A in  on=ap
  port X out on=xp
end
