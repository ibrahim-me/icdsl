# NAND3 standard cell, level 1 (stdcell). Y = !(A & B & C)
# Columns (um): c0=0.305 gC=0.66 c1=1.015 gB=1.37 c2=1.725 gA=2.08 c3=2.435
# nmos row: VGND | C | n1 | B | n2 | A | Y        pmos row: VPWR | C | Y | B | VPWR | A | Y
pdk sky130A
param L=0.15 H=2.72 WN=0.49 WP=0.75

stdcell nand3 width=6 height=H taps=yes
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  nd  = rect diff xspan=(0.18, 2.56) h=WN above=ptap
  pd  = rect diff xspan=(0.18, 2.56) h=WP below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  g_c = cross [nd, pd] poly w=L cx=0.66
  g_b = cross [nd, pd] poly w=L cx=1.37
  g_a = cross [nd, pd] poly w=L cx=2.08

  # nmos row
  n0  = contact licon in=nd cx=0.305 cy=nd.cy
  n1c = contact licon in=nd cx=1.015 cy=nd.cy
  n2c = contact licon in=nd cx=1.725 cy=nd.cy
  n3  = contact licon in=nd cx=2.435 cy=nd.cy
  n0l = enclose n0 li net=VGND
  n1l = enclose n1c li net=n1
  n2l = enclose n2c li net=n2
  n3l = enclose n3 li net=Y
  gnd = strap li from=n0l to=vgnd_li
  n3m = contact mcon in=n3l
  n3p = enclose n3m m1 by=min net=Y
  n3w = rect m1 w=0.14 cx=2.435 yspan=(nd.cy, 1.615) net=Y

  # pmos row
  p0  = contact licon in=pd cx=0.305 cy=pd.cy
  p1  = contact licon in=pd cx=1.015 cy=pd.cy
  p2  = contact licon in=pd cx=1.725 cy=pd.cy
  p3  = contact licon in=pd cx=2.435 cy=pd.cy
  p0l = enclose p0 li net=VPWR
  p1l = enclose p1 li net=Y
  p2l = enclose p2 li net=VPWR
  p3l = enclose p3 li net=Y
  pwr0 = strap li from=p0l to=vpwr_li
  pwr2 = strap li from=p2l to=vpwr_li
  p1m = contact mcon in=p1l
  p1p = enclose p1m m1 by=min net=Y
  p1w = rect m1 w=0.14 cx=1.015 yspan=(1.475, pd.cy) net=Y
  p3m = contact mcon in=p3l
  p3p = enclose p3m m1 by=min net=Y
  p3w = rect m1 w=0.14 cx=2.435 yspan=(1.475, pd.cy) net=Y

  # Y route across the gap (joins pmos col1 and col3, and nmos col3)
  yr = rect m1 xspan=(1.015, 2.435) yspan=(1.475, 1.615) net=Y

  # gate contacts in the gap on the poly stripes
  gc_c = contact licon cx=0.66 cy=1.185
  gc_b = contact licon cx=1.37 cy=1.185
  gc_a = contact licon cx=2.08 cy=1.185
  gp_c = enclose gc_c poly by=minx
  gp_b = enclose gc_b poly by=minx
  gp_a = enclose gc_a poly by=minx
  li_c = enclose gc_c li net=C
  li_b = enclose gc_b li net=B
  li_a = enclose gc_a li net=A
  am_c = contact mcon in=li_c
  am_b = contact mcon in=li_b
  am_a = contact mcon in=li_a
  ap_c = rect m1 w=0.29 h=0.29 cx=0.66 cy=1.185 net=C
  ap_b = rect m1 w=0.29 h=0.29 cx=1.37 cy=1.185 net=B
  ap_a = rect m1 w=0.29 h=0.29 cx=2.08 cy=1.185 net=A

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  port A in on=ap_a
  port B in on=ap_b
  port C in on=ap_c
  port Y out on=yr
end
