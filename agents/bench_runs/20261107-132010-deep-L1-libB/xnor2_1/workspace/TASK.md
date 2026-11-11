# Task: standard cell `xnor2_1`

Function: Y = (!A&!B) | (A&B)
Inputs: A, B; output: Y; internal nets: n1, n2, n3, n4.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/xnor2_1.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell xnor2_1`):
```icl
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell xnor2_1 width=<columns, your choice> height=H taps=no
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
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port Y out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x1.25 H=3.26; L=0.15 widths x1.5 H=3.8.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist.

## Reference library
Verified layouts of the most similar library cells (by transistor structure; clean over the whole sweep) are in /examples/:
  /examples/library_o2bb2ai_1.icl  [0.78] o2bb2ai_1: 10 transistors (5 n / 5 p), inputs A1_N, A2_N, B1, B2; outputs Y; Y = (!B1&!B2) | (A1_N&A2_N)
  /examples/library_xor2_1.icl  [0.77] xor2_1: 10 transistors (5 n / 5 p), inputs A, B; outputs X; X = (A&!B) | (!A&B)
search_library(query) finds more library cells: an empty query lists the cells most similar to this task's netlist; a name or function fragment (e.g. 'nand', 'mux', 'A1&A2') searches by name/function. get_library_cell(name) copies one into /library/<name>.icl.
