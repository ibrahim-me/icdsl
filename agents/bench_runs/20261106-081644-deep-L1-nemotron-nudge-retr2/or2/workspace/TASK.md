# Task: standard cell `or2`

Function: X = A | B (NOR2 + inverter)
Inputs: A, B; output: X; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/or2.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell or2`):
```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=<columns, your choice> height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port X out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

Verified layouts of similar cells (clean over the whole sweep) are in /examples/verified_and2.icl, /examples/verified_nand3.icl.
