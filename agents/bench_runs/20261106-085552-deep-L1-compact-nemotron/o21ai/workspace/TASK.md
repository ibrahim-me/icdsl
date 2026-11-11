# Task: standard cell `o21ai`

Function: Y = !((A1 | A2) & B1)
Inputs: A1, A2, B1; output: Y; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/o21ai.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell o21ai`):
```icl
pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2
  <your geometry>
  port A1 in on=<a met1 shape>
  port A2 in on=<a met1 shape>
  port B1 in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

## This is a COMPACTION task
`/o21ai.icl` already exists: an automatic generator's layout, clean at every sweep point, 3.22 um wide. The SkyWater hd version of this cell is 1.84 um wide (without in-cell taps). Make the cell as NARROW as you can (fewer `width` columns) while it stays clean over the whole sweep (check_sweep). If you cannot get it clean narrower, restore a clean version before you stop.
