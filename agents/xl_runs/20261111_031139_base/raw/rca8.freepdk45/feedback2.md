Judge:
  FAIL DRC      1184 violation(s): 484 x Contact width < 65nm (CONTACT.1); 456 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 228 x Contact spacing < 75nm (CONTACT.2); 8 x Metal1 > 270nm and runlength > 300nm spacing to unrelated m1 < 270nm (METAL1.6); 8 x Metal1 > 500nm and runlength > 1.8um spacing to unrelated m1 < 500nm (METAL1.7)
  FAIL DRC2     foundry KLayout deck: 56 violation(s): 56 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/224; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/rca8.freepdk45/a2/judge/rca8.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  ok   area     38.40 x 4.00 = 153.6 um2, budget 161, reference 80.02

Tool report:
DRC (magic drc(full)): 1184 violation(s), boxes in um
   484 x Contact width < 65nm (CONTACT.1)   e.g. at (0.216 2.126 0.256 2.178)  (0.268 2.126 0.308 2.178)  (0.456 2.126 0.496 2.178)
   456 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (0.216 2.178 0.256 2.182)  (0.216 2.122 0.256 2.126)  (0.456 2.178 0.496 2.182)
   228 x Contact spacing < 75nm (CONTACT.2)   e.g. at (0.216 2.126 0.268 2.178)  (0.456 2.126 0.508 2.178)  (0.696 2.126 0.748 2.178)
     8 x Metal1 > 270nm and runlength > 300nm spacing to unrelated m1 < 270nm (METAL1.6)   e.g. at (3.330 0.570 3.358 2.098)  (7.170 0.570 7.198 2.098)  (11.010 0.570 11.038 2.098)
     8 x Metal1 > 500nm and runlength > 1.8um spacing to unrelated m1 < 500nm (METAL1.7)   e.g. at (3.330 0.570 3.388 2.098)  (7.170 0.570 7.228 2.098)  (11.010 0.570 11.068 2.098)
DRC2 (foundry KLayout deck): 56 violation(s), boxes in um
    56 x CONTACT.1: CONTACT.1 : Minimum/Maximum width of contact : 65nm   e.g. at (2.355 2.658 2.435 2.658)  (2.655 2.658 2.735 2.658)  (2.955 2.658 3.035 2.658)
LVS: Top level cell failed pin matching.   devices layout/ref 2/224, nets layout/ref 5/131
  pmos (28->1)                               |pmos (14) **Mismatch**
  nmos (28->1)                               |nmos (14) **Mismatch**
  Number of devices: 2 **Mismatch**          |Number of devices: 28 **Mismatch**
  Number of nets: 5 **Mismatch**             |Number of nets: 19 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: fa                              |Circuit 2: fa
  ---------------------------------------------------------------------------------------
  Net: B                                     |Net: B
    pmos/(drain|source) = 2                  |  nmos/gate = 4
    nmos/(drain|source) = 2                  |  pmos/gate = 4
                                             |
  Net: a_1308_1018#                          |Net: p3
    pmos/gate = 1                            |  pmos/(drain|source) = 4
                                             |
  Net: w_58_1018#                            |Net: VSS
    pmos/bulk = 1                            |  nmos/(drain|source) = 9
                                             |  nmos/bulk = 14
                                             |
  Net: a_108_218#                            |Net: VDD
    nmos/gate = 1                            |  pmos/(drain|source) = 9
                                             |  pmos/bulk = 14
                                             |
  Net: w_n1073741817_n1073741817#            |Net: A
    nmos/bulk = 1                            |  nmos/gate = 4
                                             |  pmos/gate = 4
                                             |
  (no matching net)                          |Net: n3
                                             |  nmos/(drain|source) = 4
                                             |
  (no matching net)                          |Net: CB
                                             |  nmos/(drain|source) = 2
                                             |  nmos/gate = 2
                                             |  pmos/(drain|source) = 2
                                             |  pmos/gate = 2
                                             |
  (no matching net)                          |Net: n1
                                             |  nmos/(drain|source) = 3
                                             |
  (no matching net)                          |Net: p1