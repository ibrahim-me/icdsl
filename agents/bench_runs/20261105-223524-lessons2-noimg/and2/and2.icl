pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  pitch = max(0.28, 0.54 - L)
  end   = 0.265

  # ---------- n-row: X | n1 | VGND | n2 | n1 ----------
  nd  = rect diff w=(5*L + 4*end + 2*pitch) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm

  ga = cross nd poly w=L left=(nd.left + end + L + end)            # gate A : M2
  gb = cross nd poly w=L left=(ga.right + pitch)                   # gate B : M4
  gn = cross nd poly w=L left=(nd.left + end)                      # gate n1: M0

  cn1 = array licon in=nd right_of=ga            # n1 (drain of M2)
  cn2 = array licon in=nd between=[gb, gn]       # n2 (shared M4 drain / M2 source)
  cg  = array licon in=nd between=[gn, gb]       # VGND (shared M0 drain / M4 source)
  cx  = array licon in=nd left_of=gn             # X   (source of M0)

  cn1l = enclose cn1 li net=n1
  cn2l = enclose cn2 li net=n2
  cgl  = enclose cg li
  cxl  = enclose cx li net=X

  gnd = strap li from=cgl to=vgnd_li

  # ---------- p-row: n1 | A | VPWR | B | n1 | n1 | VPWR | X ----------
  pd  = rect diff w=(8*L + 7*end + pitch) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm

  pa = cross pd poly w=L left=(pd.left + end)                      # gate A : M1
  pb = cross pd poly w=L left=(pa.right + L + end)                 # gate B : M3
  pn = cross pd poly w=L left=(pb.right + pitch + end + L + end)   # gate n1: M5

  cp1 = array licon in=pd left_of=pa           # n1 (source of M1)
  cp2 = array licon in=pd between=[pa, pb]     # VPWR (shared M1 drain / M3 source)
  cp3 = array licon in=pd right_of=pb          # n1 (drain of M3)
  cp4 = array licon in=pd between=[pn, pn]     # n1 (gate contact pad)
  cp5 = array licon in=pd left_of=pn           # VPWR (drain of M5)
  cp6 = array licon in=pd right_of=pn          # X   (source of M5)

  cp1l = enclose cp1 li net=n1
  cp2l = enclose cp2 li
  cp3l = enclose cp3 li net=n1
  cp4l = enclose cp4 li net=n1
  cp5l = enclose cp5 li
  cp6l = enclose cp6 li net=X

  p1 = strap li from=cp2l to=vpwr_li
  p5 = strap li from=cp5l to=vpwr_li cx=cp5l.cx

  # ---------- gate contacts ----------
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cgl.top + 0.25, cn2l.top + 0.25, cxl.top + 0.25)

  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gcp = contact licon cx=pn.cx bottom=cb

  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gpp = enclose gcp poly by=minx

  gna = enclose [gca, gcb, gcn, gcp] npc

  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  nn = enclose gcn li net=n1
  np = enclose gcp li net=n1

  # ---------- n-well split ----------
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------- metal1 pins ----------
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bb
  bp = enclose bm m1 by=0.06 net=B

  xm = contact mcon in=cxl
  xp = enclose xm m1 by=0.06 net=X

  # ---------- internal nets n1, n2 ----------
  nmc = contact mcon in=nn
  nmp = enclose nmc m1 net=n1
  route n1 layers=m1,m2   # joins cn1l, cp1l, cp3l, cp4l, nmp
  route n2 layers=m1,m2   # joins cn2l

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
