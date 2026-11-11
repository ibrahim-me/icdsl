# Task: standard cell `mux2i_1`

Function: Y = (!A0&!S) | (!A1&S)
Inputs: A0, A1, S; output: Y; internal nets: n1, n2, n3, n4, n5.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/mux2i_1.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell mux2i_1`):
```icl
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell mux2i_1 width=<columns, your choice> height=H taps=no
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR b=VPB
  device M1 pmos w=WP l=L d=VPWR g=S s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y b=VPB
  device M3 nmos w=WN l=L d=VGND g=S s=n3 b=VNB
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR b=VPB
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND b=VNB
  device M6 nmos w=WN l=L d=n1 g=S s=VGND b=VNB
  device M7 pmos w=WP l=L d=Y g=A1 s=n4 b=VPB
  device M8 nmos w=WN l=L d=Y g=A1 s=n3 b=VNB
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y b=VNB
  <your geometry>
  port A0 in on=<a met1 shape>
  port A1 in on=<a met1 shape>
  port S in on=<a met1 shape>
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
  /examples/library_a32oi_1.icl  [0.77] a32oi_1: 10 transistors (5 n / 5 p), inputs A1, A2, A3, B1, B2; outputs Y; Y = (!A1&!B1) | (!A1&!B2) | (!A2&!B1) | (!A3&!B1) | (!A2&!B2) | (!A3&!B2)
  /examples/library_o32ai_1.icl  [0.77] o32ai_1: 10 transistors (5 n / 5 p), inputs A1, A2, A3, B1, B2; outputs Y; Y = (!A1&!A2&!A3) | (!B1&!B2)
search_library(query) finds more library cells: an empty query lists the cells most similar to this task's netlist; a name or function fragment (e.g. 'nand', 'mux', 'A1&A2') searches by name/function. get_library_cell(name) copies one into /library/<name>.icl.

## Start from the nearest library cell
`/mux2i_1.icl` already exists: the verified layout of library cell `a32oi_1` (a32oi_1: 10 transistors (5 n / 5 p), inputs A1, A2, A3, B1, B2; outputs Y; Y = (!A1&!B1) | (!A1&!B2) | (!A2&!B1) | (!A3&!B1) | (!A2&!B2) | (!A3&!B2)), with mux2i_1's device lines, parameters and ports put in. 5 of its 10 transistors correspond to transistors of this cell (net labels were renamed to match). Edit it into the layout of this cell: add/remove gate columns, contact columns and li connections so that the drawn transistors match the device lines, then check.
