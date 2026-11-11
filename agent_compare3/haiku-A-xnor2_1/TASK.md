# Task: SKY130 standard cell `xnor2_1` in ICL

Function: Y = (!A&!B) | (A&B)
Inputs: A, B; output: Y; internal nets: n1, n2, n3, n4.
Deliver `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/xnor2_1.icl` (block `stdcell xnor2_1`), starting from this skeleton - keep the `pdk`, `param`
and `device` lines exactly:
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
  port A in on=<a li or met1 shape>
  port B in on=<a li or met1 shape>
  port Y out on=<a li or met1 shape>
end
```
Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist. Width: columns of 0.46 um,
enough for L=0.25.

The ICL language: `/home/ibrahim/claude-workspace/icdsl/AGENTS.md` (level 1, `stdcell`). Notes from reviewing earlier attempts:
`/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/lessons.md`. Two verified example cells in this style: `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/examples/inv_1.icl`, `/home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/examples/nand2_1.icl`.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/xnor2_1.icl xnor2_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1 --ranked
magic DRC (full) + netgen LVS against the netlist above (the tap rules waived) + rail checks; `--ranked`
names the statements/objects/lines behind each error with concrete edits. Then the sweep (L=0.18; L=0.25; widths x1.25 with H=3.26; widths x1.5 with H=3.8):
    cd /home/ibrahim/claude-workspace/icdsl && ICL_BENCH=/home/ibrahim/claude-workspace/icdsl/library/eval_specs.json .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1/xnor2_1.icl xnor2_1 --log /home/ibrahim/claude-workspace/icdsl/agent_compare3/haiku-A-xnor2_1 --sweep
`/home/ibrahim/claude-workspace/icdsl/bin/icl inspect <file> --top xnor2_1 --param WN=...` lists every object's position and size.
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
Final checker status (first lines) and sweep result, number of checker runs, what was hard (2-4 sentences).
