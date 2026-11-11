```icl
pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell nor2 width=10 height=H
  device MNA nmos w=WN l=L d=Y g=A s=VGND
  device MNB nmos w=WN l=L d=Y g=B s=VGND
  device MPA pmos w=WP l=L d=n1 g=A s=VPWR
  device MPB pmos w=WP l=L d=Y g=B s=n1

  # NMOS diffusions (parallel, separate)
  dna = rect diff w=(L + 0.53) h=WN above=ptap
  dnb = rect diff w=(L + 0.53) h=WN right_of=dna gap=min cy=dna.cy
  nim = enclose [dna, dnb] nsdm

  # PMOS diffusion (series, shared n1)
  dpw = 2*L + 0.74
  dp  = rect diff w=dpw h=WP below=ntap
  pim = enclose dp psdm

  # Gates
  ga = cross [dna, dp] poly w=L
  gb = cross [dnb, dp] poly w=L right_of=ga gap=min

  # NMOS contacts
  sna = array licon in=dna left_of=ga
  dna_c = array licon in=dna right_of=ga
  snb = array licon in=dnb left_of=gb
  dnb_c = array licon in=dnb right_of=gb
  sna_l = enclose sna li
  dna_l = enclose dna_c li
  snb_l = enclose snb li
  dnb_l = enclose dnb_c li

  # PMOS contacts (outer ends: VPWR and Y)
  sp  = array licon in=dp left_of=ga
  dp_c = array licon in=dp right_of=gb
  sp_l = enclose sp li
  dp_l = enclose dp_c li

  # Local interconnects
  gnd_a = strap li from=sna_l to=vgnd_li
  gnd_b = strap li from=snb_l to=vgnd_li
  y_n   = strap li from=dna_l to=dnb_l net=Y
  pwr_a = strap li from=sp_l to=vpwr_li
  y_p   = strap li from=dp_l to=y_n net=Y

  # Gate contacts to met1 (inputs A and B)
  ac = contact licon left_of=ga xspace=0.17 bottom=max(dna.top + 0.19, dp.top + 0.19)
  ap = enclose ac poly by=minx
  an = enclose ac npc
  am = contact mcon in=an
  a_m1 = enclose am m1 by=0.06 net=A

  bc = contact licon right_of=gb xspace=0.17 bottom=max(dnb.top + 0.19, dp.top + 0.19)
  bp = enclose bc poly by=minx
  bn = enclose bc npc
  bm = contact mcon in=bn
  b_m1 = enclose bm m1 by=0.06 net=B

  # Output Y met1 pin
  ym = contact mcon in=y_n cy=(y_n.top - 0.3)
  y_m1 = enclose ym m1 by=0.06 net=Y

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  port A in  on=a_m1
  port B in  on=b_m1
  port Y out on=y_m1
end
```