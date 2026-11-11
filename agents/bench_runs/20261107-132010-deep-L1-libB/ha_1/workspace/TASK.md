# Task: standard cell `ha_1`

Function: COUT = (A&B); SUM = (A&!B) | (!A&B)
Inputs: A, B; output: COUT, SUM; internal nets: n1, n2, n3, n4, n5.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/ha_1.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell ha_1`):
```icl
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell ha_1 width=<columns, your choice> height=H taps=no
  device M0 nmos w=WN2 l=L d=n1 g=B s=n2 b=VNB
  device M1 nmos w=WN2 l=L d=n3 g=n1 s=n4 b=VNB
  device M2 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M3 pmos w=WP l=L d=VPWR g=n1 s=COUT b=VPB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n4 b=VNB
  device M5 pmos w=WP2 l=L d=n3 g=B s=n5 b=VPB
  device M6 pmos w=WP2 l=L d=n5 g=A s=VPWR b=VPB
  device M7 nmos w=WN l=L d=SUM g=n3 s=VGND b=VNB
  device M8 nmos w=WN2 l=L d=n2 g=A s=VGND b=VNB
  device M9 pmos w=WP l=L d=SUM g=n3 s=VPWR b=VPB
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3 b=VPB
  device M11 nmos w=WN2 l=L d=n4 g=B s=VGND b=VNB
  device M12 nmos w=WN l=L d=VGND g=n1 s=COUT b=VNB
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1 b=VPB
  <your geometry>
  port A in on=<a met1 shape>
  port B in on=<a met1 shape>
  port COUT out on=<a met1 shape>
  port SUM out on=<a met1 shape>
end
```
Checked at the nominal parameters, then over the sweep: L=0.18 widths x1.0 H=2.72; L=0.25 widths x1.0 H=2.72; L=0.15 widths x1.25 H=3.26; L=0.15 widths x1.5 H=3.8.
Choose `width` (columns of 0.46 um) large enough for L=0.25.

Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist.

## Reference library
Verified layouts of the most similar library cells (by transistor structure; clean over the whole sweep) are in /examples/:
  /examples/library_maj3_1.icl  [0.81] maj3_1: 14 transistors (7 n / 7 p), inputs A, B, C; outputs X; X = (A&B) | (A&C) | (B&C)
  /examples/library_mux2_2.icl  [0.80] mux2_2: 14 transistors (7 n / 7 p), inputs A0, A1, S; outputs X; X = (A0&!S) | (A1&S)
search_library(query) finds more library cells: an empty query lists the cells most similar to this task's netlist; a name or function fragment (e.g. 'nand', 'mux', 'A1&A2') searches by name/function. get_library_cell(name) copies one into /library/<name>.icl.
