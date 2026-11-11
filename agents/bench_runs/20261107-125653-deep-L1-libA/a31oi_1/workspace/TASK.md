# Task: standard cell `a31oi_1`

Function: Y = (!A1&!B1) | (!A2&!B1) | (!A3&!B1)
Inputs: A1, A2, A3, B1; output: Y; internal nets: n1, n2, n3.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/a31oi_1.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell a31oi_1`):
```icl
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a31oi_1 width=<columns, your choice> height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=B1 s=Y b=VPB
  device M1 nmos w=WN l=L d=n2 g=A1 s=Y b=VNB
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n1 b=VPB
  device M3 nmos w=WN l=L d=n3 g=A2 s=n2 b=VNB
  device M4 nmos w=WN l=L d=Y g=B1 s=VGND b=VNB
  device M5 nmos w=WN l=L d=VGND g=A3 s=n3 b=VNB
  device M6 pmos w=WP l=L d=VPWR g=A3 s=n1 b=VPB
  device M7 pmos w=WP l=L d=n1 g=A2 s=VPWR b=VPB
  <your geometry>
  port A1 in on=<a met1 shape>
  port A2 in on=<a met1 shape>
  port A3 in on=<a met1 shape>
  port B1 in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x1.25 H=3.26; L=0.15 widths x1.5 H=3.8.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist.
