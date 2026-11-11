# Task: SKY130 standard cell `maj3_1` in ICL

Function: X = (A&B) | (A&C) | (B&C)
Inputs: A, B, C; output: X; internal nets: n1, n2, n3, n4, n5, n6, n7.
Deliver `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/maj3_1.icl` (block `stdcell maj3_1`), starting from this skeleton - keep the `pdk`, `param`
and `device` lines exactly:
```icl
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=<columns, your choice> height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB
  <your geometry>
  port A in on=<a li or met1 shape>
  port B in on=<a li or met1 shape>
  port C in on=<a li or met1 shape>
  port X out on=<a li or met1 shape>
end
```
Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist. Width: columns of 0.46 um,
enough for L=0.25.

The ICL language: `/home/ibrahim/claude-workspace/icdsl/AGENTS.md` (level 1, `stdcell`). Notes from reviewing earlier attempts:
`/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/lessons.md`. Two verified example cells in this style: `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/examples/inv_1.icl`, `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/examples/nand2_1.icl`.

## Reference library
A library of 208 verified cells (converted from a real standard-cell library, each DRC/LVS clean over the
whole sweep) is in `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/library/`. The two most similar to this task (by transistor structure):
  `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/examples/library_ha_1.icl`  [0.81] ha_1: 14 transistors (7 n / 7 p), inputs A, B; outputs COUT, SUM; COUT = (A&B); SUM = (A&!B) | (!A&B)
  `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/examples/library_mux2_2.icl`  [0.80] mux2_2: 14 transistors (7 n / 7 p), inputs A0, A1, S; outputs X; X = (A0&!S) | (A1&S)

More: `/home/ibrahim/claude-workspace/icdsl/.venv/bin/python /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/search.py` lists the most similar cells; `search.py <text>` searches by
name or function (e.g. `search.py nand`, `search.py "A1&A2"`).

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/maj3_1.icl maj3_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1 --ranked
magic DRC (full) + netgen LVS against the netlist above (the tap rules waived) + rail checks; `--ranked`
names the statements/objects/lines behind each error with concrete edits. Then the sweep (L=0.18; L=0.25; widths x1.25 with H=3.26; widths x1.5 with H=3.8):
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1/maj3_1.icl maj3_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-B-maj3_1 --sweep
`/home/ibrahim/claude-workspace/icdsl/bin/icl inspect <file> --top maj3_1 --param WN=...` lists every object's position and size.
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
