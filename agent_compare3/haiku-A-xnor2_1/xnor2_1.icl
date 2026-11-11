pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell xnor2_1 width=9 height=H taps=no
  device M0 pmos w=WP l=L d=VPWR g=A s=n1 b=VPB
  device M1 pmos w=WP l=L d=n1 g=B s=Y b=VPB
  device M2 pmos w=WP l=L d=Y g=n2 s=VPWR b=VPB
  device M3 nmos w=WN l=L d=n3 g=A s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=B s=n4 b=VNB
  device M5 nmos w=WN l=L d=n2 g=B s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=B s=n2 b=VPB
  device M7 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M8 nmos w=WN l=L d=VGND g=A s=n4 b=VNB
  device M9 nmos w=WN l=L d=n4 g=n2 s=Y b=VNB

  # gate columns (left edges): p row A B n2 B A; n row A B n2 with one 0.8 island break before gx4
  gx1 = 0.6
  gx2 = gx1 + 0.54
  gx3 = gx2 + 0.54
  gx4 = gx3 + L + 1.0
  gx5 = gx4 + 0.54
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                      # top of the p row
  gcy = nb + WN + 0.275               # gate contacts (channel, as in the nand2 reference)
  ncy = nb + WN / 2
  pcy = pt - WP / 2
  # contact / strip x positions (all derived from the gate columns)
  xl = gx1 - 0.185                    # left end
  xa = (gx1 + L + gx2) / 2
  xb = (gx2 + L + gx3) / 2
  xy = gx3 + L + 0.185                # n row, right of gate 3 (Y)
  xc = (gx3 + L + gx4) / 2            # island break (p row VPWR)
  xn2 = gx4 - 0.185                   # n row, left of gate 4 (n2)
  xd = (gx4 + L + gx5) / 2
  xr = gx5 + L + 0.185                # right end

  # diffusion
  pdA = rect diff xspan=(xl - 0.165, xr + 0.165) yspan=(pt - WP, pt)
  ndY = rect diff xspan=(xl - 0.165, xy + 0.165) yspan=(nb, nb + WN)
  ndX = rect diff xspan=(xn2 - 0.165, xr + 0.165) yspan=(nb, nb + WN)
  nim = enclose [ndY, ndX] nsdm
  pim = enclose [pdA] psdm

  # poly: one gate column per gate position, crossing both rows; channel pads for the contacts
  pg1 = rect poly xspan=(gx1, gx1 + L) yspan=(0.105, H - 0.105)
  pg2 = rect poly xspan=(gx2, gx2 + L) yspan=(0.105, H - 0.105)
  pg3 = rect poly xspan=(gx3, gx3 + L) yspan=(0.105, H - 0.105)
  pg4 = rect poly xspan=(gx4, gx4 + L) yspan=(0.105, H - 0.105)
  pg5 = rect poly xspan=(gx5, gx5 + L) yspan=(0.105, H - 0.105)
  pp1 = rect poly xspan=(gx1 + L / 2 - 0.165, gx1 + L / 2 + 0.165) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  pp2 = rect poly xspan=(gx2 + L / 2 - 0.165, gx2 + L / 2 + 0.165) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  pp3 = rect poly xspan=(gx3 + L / 2 - 0.165, gx3 + L / 2 + 0.165) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  pp4 = rect poly xspan=(gx4 + L / 2 - 0.165, gx4 + L / 2 + 0.165) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  pp5 = rect poly xspan=(gx5 + L / 2 - 0.165, gx5 + L / 2 + 0.165) yspan=(nb + WN + 0.09, pt - WP - 0.16)
  np1 = rect npc xspan=(gx1 - 0.25, gx5 + L + 0.25) yspan=(nb + WN + 0.03, pt - WP - 0.10)

  # gate contacts in the channel, with local interconnect labelled by net
  gc1 = contact licon cx=(gx1 + L / 2) cy=gcy
  gc2 = contact licon cx=(gx2 + L / 2) cy=gcy
  gc3 = contact licon cx=(gx3 + L / 2) cy=gcy
  gc4 = contact licon cx=(gx4 + L / 2) cy=gcy
  gc5 = contact licon cx=(gx5 + L / 2) cy=gcy
  gl1 = rect li xspan=(gx1 + L / 2 - 0.17, gx1 + L / 2 + 0.17) yspan=(gcy - 0.17, gcy + 0.17) net=A
  gl2 = rect li xspan=(gx2 + L / 2 - 0.17, gx2 + L / 2 + 0.17) yspan=(gcy - 0.17, gcy + 0.17) net=B
  gl3 = rect li xspan=(gx3 + L / 2 - 0.17, gx3 + L / 2 + 0.17) yspan=(gcy - 0.17, gcy + 0.17) net=n2
  gl4 = rect li xspan=(gx4 + L / 2 - 0.17, gx4 + L / 2 + 0.17) yspan=(gcy - 0.17, gcy + 0.17) net=B
  gl5 = rect li xspan=(gx5 + L / 2 - 0.17, gx5 + L / 2 + 0.17) yspan=(gcy - 0.17, gcy + 0.17) net=A

  # n row: diffusion contacts and strips (n4 | A | VGND | B | n4 | n2 | Y  ||  n2 | B | n3 | A | VGND)
  na1 = contact licon cx=xl cy=ncy
  nla1 = rect li xspan=(xl - 0.17, xl + 0.17) yspan=(ncy - 0.17, ncy + 0.17) net=n4
  na2 = contact licon cx=xa cy=ncy
  nla2 = rect li xspan=(xa - 0.17, xa + 0.17) yspan=(-0.085, ncy + 0.17) net=VGND
  mna2 = contact mcon cx=xa cy=0
  na3 = contact licon cx=xb cy=ncy
  nla3 = rect li xspan=(xb - 0.17, xb + 0.17) yspan=(ncy - 0.17, ncy + 0.17) net=n4
  na4 = contact licon cx=xy cy=ncy
  nla4 = rect li xspan=(xy - 0.17, xy + 0.17) yspan=(ncy - 0.17, ncy + 0.17) net=Y
  na5 = contact licon cx=xn2 cy=ncy
  nla5 = rect li xspan=(xn2 - 0.17, xn2 + 0.17) yspan=(ncy - 0.17, ncy + 0.17) net=n2
  na6 = contact licon cx=xd cy=ncy
  nla6 = rect li xspan=(xd - 0.17, xd + 0.17) yspan=(ncy - 0.17, ncy + 0.17) net=n3
  na7 = contact licon cx=xr cy=ncy
  nla7 = rect li xspan=(xr - 0.17, xr + 0.17) yspan=(-0.085, ncy + 0.17) net=VGND
  mna7 = contact mcon cx=xr cy=0

  # p row: diffusion contacts and strips (VPWR | A | n1 | B | Y | n2 | VPWR | B | n2 | A | VPWR)
  pa1 = contact licon cx=xl cy=pcy
  pla1 = rect li xspan=(xl - 0.17, xl + 0.17) yspan=(pcy - 0.17, H + 0.085) net=VPWR
  mpa1 = contact mcon cx=xl cy=H
  pa2 = contact licon cx=xa cy=pcy
  pla2 = rect li xspan=(xa - 0.17, xa + 0.17) yspan=(pcy - 0.17, pcy + 0.17) net=n1
  pa3 = contact licon cx=xb cy=pcy
  pla3 = rect li xspan=(xb - 0.17, xb + 0.17) yspan=(pcy - 0.17, pcy + 0.17) net=Y
  pa4 = contact licon cx=xc cy=pcy
  pla4 = rect li xspan=(xc - 0.17, xc + 0.17) yspan=(pcy - 0.17, H + 0.085) net=VPWR
  mpa4 = contact mcon cx=xc cy=H
  pa5 = contact licon cx=xd cy=pcy
  pla5 = rect li xspan=(xd - 0.17, xd + 0.17) yspan=(pcy - 0.17, pcy + 0.17) net=n2
  pa6 = contact licon cx=xr cy=pcy
  pla6 = rect li xspan=(xr - 0.17, xr + 0.17) yspan=(pcy - 0.17, H + 0.085) net=VPWR
  mpa6 = contact mcon cx=xr cy=H

  # metal: nets joined by the router
  route A layers=m1,m2
  route B layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2
  route n4 layers=m1,m2

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # pins
  port A in
  port B in
  port Y out
end
