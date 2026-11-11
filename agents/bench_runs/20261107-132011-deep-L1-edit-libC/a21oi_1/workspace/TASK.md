# Task: standard cell `a21oi_1`

Function: Y = (!A1&!B1) | (!A2&!B1)
Inputs: A1, A2, B1; output: Y; internal nets: n1, n2.
Supplies VPWR/VGND come from the template rails. The transistor netlist is fixed (from SkyWater sky130_fd_sc_hd).

Write the layout to `/a21oi_1.icl`, starting from this skeleton (keep the `pdk`, `param` and `device`
lines exactly; the block must be `stdcell a21oi_1`):
```icl
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell a21oi_1 width=<columns, your choice> height=H taps=no
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND b=VNB
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR b=VPB
  device M2 pmos w=WP l=L d=Y g=B1 s=n2 b=VPB
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y b=VNB
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2 b=VPB
  device M5 nmos w=WN l=L d=Y g=A1 s=n1 b=VNB
  <your geometry>
  port A1 in on=<a met1 shape>
  port A2 in on=<a met1 shape>
  port B1 in on=<a met1 shape>
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
  /examples/library_a211oi_1.icl  [0.70] a211oi_1: 8 transistors (4 n / 4 p), inputs A1, A2, B1, C1; outputs Y; Y = (!A1&!B1&!C1) | (!A2&!B1&!C1)
  /examples/library_lpflow_isobufsrc_1.icl  [0.68] lpflow_isobufsrc_1: 6 transistors (3 n / 3 p), inputs A, SLEEP; outputs X; X = (A&!SLEEP)
search_library(query) finds more library cells: an empty query lists the cells most similar to this task's netlist; a name or function fragment (e.g. 'nand', 'mux', 'A1&A2') searches by name/function. get_library_cell(name) copies one into /library/<name>.icl.

## Start from the nearest library cell
`/a21oi_1.icl` already exists: the verified layout of library cell `a211oi_1` (a211oi_1: 8 transistors (4 n / 4 p), inputs A1, A2, B1, C1; outputs Y; Y = (!A1&!B1&!C1) | (!A2&!B1&!C1)), with a21oi_1's device lines, parameters and ports put in. 5 of its 8 transistors correspond to transistors of this cell (net labels were renamed to match). Edit it into the layout of this cell: add/remove gate columns, contact columns and li connections so that the drawn transistors match the device lines, then check.
