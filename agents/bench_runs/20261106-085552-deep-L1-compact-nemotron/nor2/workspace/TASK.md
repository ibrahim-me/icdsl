# Task: standard cell `nor2`

Function: Y = !(A | B)
Inputs: A, B; output: Y; internal nets: n1.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/nor2.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell nor2`):
```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=<columns, your choice> height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

## This is a COMPACTION task
`/nor2.icl` already exists: an automatic generator's layout, clean at every sweep point, 2.3 um wide. The SkyWater hd version of this cell is 1.38 um wide (without in-cell taps). Make the cell as NARROW as you can (fewer `width` columns) while it stays clean over the whole sweep (check_sweep). If you cannot get it clean narrower, restore a clean version before you stop.
