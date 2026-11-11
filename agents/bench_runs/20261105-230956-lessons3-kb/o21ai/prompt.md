Design the standard cell `o21ai`: Y = !((A1 | A2) & B1).
Inputs: A1, A2, B1; output: Y; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from the SKY130 hd library):
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
Keep the `pdk`, `param` and `device` lines exactly. It is checked at the nominal parameters and then swept:
L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x0.85 H=2.72; L=0.15 widths x1.35 H=3.26; L=0.15 widths x1.9 H=4.08. Choose `width` (0.46 um columns) large enough for L=0.25.