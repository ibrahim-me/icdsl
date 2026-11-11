pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=4 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  # Diffusion rows: n-row above p-tap, p-row below n-tap
  # Width = 2 * (contact_end + gate_to_contact + L/2) = 2 * (0.17 + 0.055 + L/2) = 0.45 + L
  # For L=0.25, width = 0.70. 2 columns (0.92) is plenty.
  dw = L + 0.53
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # Gate
  g   = cross [nd, pd] poly w=L
  
  # Contact columns: Source (VGND/VPWR) and Drain (Y)
  # n-side: VGND (left), Y (right)
  # p-side: VPWR (left), Y (right)
  sn  = array licon in=nd left_of=g
  dn  = array licon in=nd right_of=g
  sp  = array licon in=pd left_of=g
  dp  = array licon in=pd right_of=g
  
  snl = enclose sn li
  dnl = enclose dn li net=Y
  spl = enclose sp li
  dpl = enclose dp li net=Y

  # Supply straps
  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=spl to=vpwr_li

  # Gate contact: centered on gate, bottom cleared of n-row contacts
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gc  = contact licon cx=g.cx bottom=cb
  gp  = enclose gc poly by=minx
  gn  = enclose gc npc
  ga  = enclose gc li net=A

  # N-well split
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Metal 1 connections
  am  = contact mcon in=ga
  ap  = enclose am m1 by=0.06 net=A
  
  ym  = contact mcon in=dnl
  yp  = enclose ym m1 by=0.06 net=Y
  
  # Join p-side drain to n-side drain
  # Since they are aligned vertically in this simple inv, use a strap
  # But to be safe against L/W sweeps, we use route
  route Y layers=m1

  port A in  on=ap
  port Y out on=yp
end
