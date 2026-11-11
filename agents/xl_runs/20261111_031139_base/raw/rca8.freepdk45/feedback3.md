Judge:
  FAIL DRC      2381 violation(s): 1126 x Contact spacing < 75nm (CONTACT.2); 452 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4); 450 x Contact width < 65nm (CONTACT.1); 249 x Metal1 spacing < 65nm (METAL1.2); 104 x N-well spacing < 135nm (WELL.3)
  FAIL DRC2     foundry KLayout deck: 142 violation(s): 56 x CONTACT.2: CONTACT.2 : Minimum spacing of contact : 75nm; 34 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm; 26 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm; 26 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/224; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/rca8.freepdk45/a3/judge/rca8.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     52.64 x 4.20 = 221.1 um2, budget 161, reference 80.02

Tool report:
DRC (magic drc(full)): 2381 violation(s), boxes in um
  1126 x Contact spacing < 75nm (CONTACT.2)   e.g. at (0.290 2.326 0.316 2.378)  (0.376 2.326 0.402 2.378)  (0.626 2.326 0.652 2.378)
   452 x Diffusion overlap of diffusion contact < 5nm in one direction (CONTACT.4)   e.g. at (0.296 2.378 0.336 2.382)  (0.296 2.322 0.336 2.326)  (0.632 2.378 0.672 2.382)
   450 x Contact width < 65nm (CONTACT.1)   e.g. at (0.296 2.326 0.336 2.378)  (0.342 2.326 0.376 2.378)  (0.632 2.326 0.672 2.378)
   249 x Metal1 spacing < 65nm (METAL1.2)   e.g. at (0.290 0.426 0.308 0.662)  (0.290 0.374 0.308 0.426)  (0.376 0.426 0.394 0.662)
   104 x N-well spacing < 135nm (WELL.3)   e.g. at (0.492 2.236 0.584 2.468)  (0.828 2.236 0.920 2.468)  (1.164 2.236 1.256 2.468)
DRC2 (foundry KLayout deck): 142 violation(s), boxes in um
    56 x CONTACT.2: CONTACT.2 : Minimum spacing of contact : 75nm   e.g. at (2.107 2.908 2.150 2.973)  (2.000 2.908 2.042 2.973)  (1.580 2.908 1.623 2.973)
    34 x METAL1.2: METAL1.2 : Minimum spacing of metal1 : 65nm   e.g. at (5.468 0.418 5.510 0.828)  (5.888 0.532 5.930 0.828)  (0.320 0.418 0.362 0.828)
    26 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm   e.g. at (5.215 2.795 5.235 3.085)  (4.795 2.795 4.815 3.085)  (3.955 2.795 3.975 3.085)
    26 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm   e.g. at (5.635 2.795 5.655 3.085)  (4.375 2.795 4.395 3.085)  (3.535 2.795 3.555 3.085)
LVS: Top level cell failed pin matching.   devices layout/ref 2/224, nets layout/ref 5/131
  nmos (28->1)                               |nmos (14) **Mismatch**
  Number of devices: 15 **Mismatch**         |Number of devices: 28 **Mismatch**
  Number of nets: 31 **Mismatch**            |Number of nets: 19 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: fa                              |Circuit 2: fa
  ---------------------------------------------------------------------------------------
  Net: a_1996_1118#                          |Net: VSS
    pmos/gate = 1                            |  nmos/(drain|source) = 9
                                             |  nmos/bulk = 14
                                             |
  Net: a_1156_1189#                          |Net: VDD
    pmos/gate = 1                            |  pmos/(drain|source) = 9
                                             |  pmos/bulk = 14
                                             |
  Net: a_1660_1189#                          |Net: A
    pmos/gate = 1                            |  nmos/gate = 4
                                             |  pmos/gate = 4
                                             |
  Net: B                                     |Net: B
    pmos/(drain|source) = 28                 |  nmos/gate = 4
    nmos/(drain|source) = 2                  |  pmos/gate = 4
                                             |
  Net: a_2332_1189#                          |Net: CB
    pmos/gate = 1                            |  nmos/(drain|source) = 2
                                             |  nmos/gate = 2
                                             |  pmos/(drain|source) = 2
                                             |  pmos/gate = 2
                                             |
  Net: a_988_1189#                           |Net: n1
    pmos/gate = 1                            |  nmos/(drain|source) = 3
                                             |
  Net: a_1324_1118#                          |Net: p1
    pmos/gate = 1                            |  pmos/(drain|source) = 3
                                             |
  Net: a_1492_1189#                          |Net: CIN
    pmos/gate = 1                            |  nmos/gate = 3
                                             |  pmos/gate = 3
                                             |
  Net: a_2164_1189#                          |Net: SB