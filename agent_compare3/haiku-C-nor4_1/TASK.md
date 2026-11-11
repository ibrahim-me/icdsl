# Task: SKY130 standard cell `nor4_1` in ICL

Function: Y = (!A&!B&!C&!D)
Inputs: A, B, C, D; output: Y; internal nets: n1, n2, n3.
Deliver `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/nor4_1.icl` (block `stdcell nor4_1`), starting from this skeleton - keep the `pdk`, `param`
and `device` lines exactly:
```icl
pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=<columns, your choice> height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB
  <your geometry>
  port A in on=<a li or met1 shape>
  port B in on=<a li or met1 shape>
  port C in on=<a li or met1 shape>
  port D in on=<a li or met1 shape>
  port Y out on=<a li or met1 shape>
end
```
Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist. Width: columns of 0.46 um,
enough for L=0.25.

The ICL language: `/home/ibrahim/claude-workspace/icdsl/AGENTS.md` (level 1, `stdcell`). Notes from reviewing earlier attempts:
`/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/lessons.md`. Two verified example cells in this style: `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/examples/inv_1.icl`, `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/examples/nand2_1.icl`.

## Reference library
A library of 208 verified cells (converted from a real standard-cell library, each DRC/LVS clean over the
whole sweep) is in `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/library/`. The two most similar to this task (by transistor structure):
  `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/examples/library_a2111oi_0.icl`  [0.77] a2111oi_0: 10 transistors (5 n / 5 p), inputs A1, A2, B1, C1, D1; outputs Y; Y = (!A1&!B1&!C1&!D1) | (!A2&!B1&!C1&!D1)
  `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/examples/library_nor3b_1.icl`  [0.75] nor3b_1: 8 transistors (4 n / 4 p), inputs A, B, C_N; outputs Y; Y = (!A&!B&C_N)

More: `/home/ibrahim/claude-workspace/icdsl/.venv/bin/python /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/search.py` lists the most similar cells; `search.py <text>` searches by
name or function (e.g. `search.py nand`, `search.py "A1&A2"`).

## Start from the nearest library cell
`/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/nor4_1.icl` already exists: the verified layout of library cell `a2111oi_0` with nor4_1's device lines,
parameters and ports put in. 7 of its 10 transistors correspond to transistors of this cell (net labels were
renamed to match). Edit it into the layout of this cell (add/remove gate columns, contact columns and li
connections so the drawn transistors match the device lines), then check.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/nor4_1.icl nor4_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1 --ranked
magic DRC (full) + netgen LVS against the netlist above (the tap rules waived) + rail checks; `--ranked`
names the statements/objects/lines behind each error with concrete edits. Then the sweep (L=0.18; L=0.25; widths x1.25 with H=3.26; widths x1.5 with H=3.8):
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1/nor4_1.icl nor4_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-C-nor4_1 --sweep
`/home/ibrahim/claude-workspace/icdsl/bin/icl inspect <file> --top nor4_1 --param WN=...` lists every object's position and size.
Positions must follow the parameters (L, WN.., WP.., H) so the sweep is clean too.

## Budget and rules
Stop when the checker says CLEAN and the sweep is clean, or after 25 checker runs / about 45 minutes of
work; keep your best version at the deliverable path.
Do NOT read or copy anything outside your own directory except /home/ibrahim/claude-workspace/icdsl/AGENTS.md, /home/ibrahim/claude-workspace/icdsl/bin/icl
and the checker command below. In particular not: /home/ibrahim/claude-workspace/icdsl/library/ (the converted PDK cells - your
directory has the part you may use), the sky130_fd_sc_hd layouts in /home/ibrahim/claude-workspace/icdsl/pdk/, agents/bench_runs/,
agent_compare*/ (other than your own directory), /tmp. Write only inside your own directory. Do not
launch other agents.

## Report (your final message)
Final checker status (first lines) and sweep result, number of checker runs, what was hard (2-4 sentences), and which library cells you used and how.
