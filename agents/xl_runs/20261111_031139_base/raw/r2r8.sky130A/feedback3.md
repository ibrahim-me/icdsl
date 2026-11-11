Judge:
  FAIL DRC      56 violation(s): 50 x poly overlap of poly contact < 0.05um (licon.8); 6 x Local interconnect spacing < 0.17um (li.3)
  FAIL DRC2     foundry KLayout deck: 3 violation(s): 3 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um
  FAIL LVS      (netgen produced no result)  (devices layout/ref ?/?; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.sky130A/a3/judge/r2r8.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     50.24 x 37.17 = 1867.4 um2, budget 1630, reference 814.74

Tool report:
magic DRC: 56 violation(s)
    50 x poly overlap of poly contact < 0.05um (licon.8)   e.g. at (2.015 38.415 2.050 38.585)  (7.950 38.415 7.985 38.585)  (11.015 38.415 11.050 38.585)
     6 x Local interconnect spacing < 0.17um (li.3)   e.g. at (-6.170 38.160 -5.830 38.170)  (-6.170 38.330 -5.830 38.340)  (-6.170 29.660 -5.830 29.670)
KLayout deck DRC: 3 violation(s)
     3 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um   e.g. at (-6.170 38.170 -5.830 38.330)  (-6.170 29.670 -5.830 29.830)  (-6.170 2.170 -5.830 2.330)
LVS: (netgen produced no result)   devices layout/ref None  nets layout/ref None