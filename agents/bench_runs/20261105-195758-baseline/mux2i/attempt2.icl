pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # ---- n-diffusion row (NMOS): n3 | S | VGND | S | n1 | n1 | n5 | A0 | Y | A1 | n3
  nd  = rect diff w=(5*L + 4*0.28 + 2*0.265) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  gn3 = cross [nd] poly w=L left=(nd.left + 0.265) net=S
  gn6 = cross [nd] poly w=L right_of=gn3 gap=0.28 net=S
  gn5 = cross [nd] poly w=L right_of=gn6 gap=0.21 net=n1
  gn9 = cross [nd] poly w=L right_of=gn5 gap=0.28 net=A0
  gn8 = cross [nd] poly w=L right_of=gn9 gap=0.28 net=A1

  cn3l = array licon in=nd left_of=gn3
  cn3r = array licon in=nd right_of=gn3 left_of=gn6 gap=min
  cn1l = array licon in=nd right_of=gn6 left_of=gn5 gap=min
  cn1r = array licon in=nd right_of=gn5 left_of=gn9 gap=min
  cn5l = array licon in=nd right_of=gn9 left_of=gn8 gap=min
  cn5r = array licon in=nd right_of=gn8

  cn3ll = enclose cn3l li net=n3
  cn3rr = enclose cn3r li net=VGND
  cn1ll = enclose cn1l li net=VGND
  cn1rr = enclose cn1r li net=n1
  cn5ll = enclose cn5l li net=n5
  cn5rr = enclose cn5r li net=n5

  gndn = strap li from=cn3rr to=vgnd_li
  gndn2 = strap li from=cn1ll to=vgnd_li
  n5n  = strap li from=cn5ll to=cn5rr net=n5

  # ---- p-diffusion row (PMOS): n1 | S | VPWR | S | n2 | A0 | Y | n4 | n1 | n1 | VPWR
  pd  = rect diff w=(5*L + 4*0.28 + 2*0.265) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm
  gp0 = cross [pd] poly w=L left=(pd.left + 0.265) net=S
  gp1 = cross [pd] poly w=L right_of=gp0 gap=0.28 net=S
  gp2 = cross [pd] poly w=L right_of=gp1 gap=0.28 net=A0
  gp4 = cross [pd] poly w=L right_of=gp2 gap=0.28 net=n1
  gp7 = cross [pd] poly w=L right_of=gp4 gap=0.28 net=A1

  cp1l = array licon in=pd left_of=gp0
  cp1r = array licon in=pd right_of=gp0 left_of=gp1 gap=min
  cp2l = array licon in=pd right_of=gp1 left_of=gp2 gap=min
  cp2r = array licon in=pd right_of=gp2 left_of=gp4 gap=min
  cp4l = array licon in=pd right_of=gp4 left_of=gp7 gap=min
  cp4r = array licon in=pd right_of=gp7

  cp1ll = enclose cp1l li net=n1
  cp1rr = enclose cp1r li net=VPWR
  cp2ll = enclose cp2l li net=VPWR
  cp2rr = enclose cp2r li net=n2
  cp4ll = enclose cp4l li net=n4
  cp4rr = enclose cp4r li net=VPWR

  pwrp1 = strap li from=cp1rr to=vpwr_li
  pwrp2 = strap li from=cp2ll to=vpwr_li
  pwrp3 = strap li from=cp4rr to=vpwr_li
  n1p   = strap li from=cp1ll to=cp4rr net=n1

  # ---- gate contacts in the gap between the rows
  cb = max(nd.top + 0.19, cn3ll.top + 0.25, cn3rr.top + 0.25,
              cn1ll.top + 0.25, cn1rr.top + 0.25, cn5ll.top + 0.25, cn5rr.top + 0.25)

  gc0 = contact licon cx=(gp0.cx - 0.1) bottom=cb net=S
  gc1 = contact licon cx=(gp1.cx + 0.1) bottom=cb net=S
  gc2 = contact licon cx=(gp2.cx - 0.1) bottom=cb net=A0
  gc4 = contact licon cx=(gp4.cx + 0.1) bottom=cb net=n1
  gc7 = contact licon cx=(gp7.cx + 0.1) bottom=cb net=A1
  gc3 = contact licon cx=(gn3.cx - 0.1) bottom=cb net=S
  gc6 = contact licon cx=(gn6.cx + 0.1) bottom=cb net=S
  gc5 = contact licon cx=(gn5.cx - 0.1) bottom=cb net=n1
  gc9 = contact licon cx=(gn9.cx + 0.1) bottom=cb net=A0
  gc8 = contact licon cx=(gn8.cx + 0.1) bottom=cb net=A1

  gp0p = enclose [gc0, gc3] poly by=minx
  gp1p = enclose [gc1, gc6] poly by=minx
  gp2p = enclose gc2 poly by=minx
  gp4p = enclose gc4 poly by=minx
  gp7p = enclose gc7 poly by=minx
  gn3p = enclose gc3 poly by=minx
  gn6p = enclose gc6 poly by=minx
  gn5p = enclose gc5 poly by=minx
  gn9p = enclose gc9 poly by=minx
  gn8p = enclose gc8 poly by=minx

  gnall = enclose [gc0, gc1, gc2, gc4, gc7, gc3, gc6, gc5, gc9, gc8] npc

  # ---- port pins on met1
  s0m = contact mcon in=enclose gc0 li net=S
  s0p = enclose s0m m1 by=0.06 net=S
  s1m = contact mcon in=enclose gc1 li net=S
  s1p = enclose s1m m1 by=0.06 net=S
  a0m = contact mcon in=enclose gc2 li net=A0
  a0p = enclose a0m m1 by=0.06 net=A0
  n1m = contact mcon in=enclose gc4 li net=n1
  n1p = enclose n1m m1 by=0.06 net=n1
  a1m = contact mcon in=enclose gc7 li net=A1
  a1p = enclose a1m m1 by=0.06 net=A1

  ym  = contact mcon in=enclose cp2rr li net=Y
  yp  = enclose ym m1 by=0.06 net=Y

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  port S  in  on=s0p
  port A0 in  on=a0p
  port A1 in  on=a1p
  port Y  out on=yp
end
