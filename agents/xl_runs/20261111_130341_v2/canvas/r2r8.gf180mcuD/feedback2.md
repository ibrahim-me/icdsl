Judge:
  ok   DRC      clean
  FAIL DRC2     foundry KLayout deck: 22 violation(s): 22 x PP.2: PP.2 : min. pplus spacing : 0.4µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 9/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a2/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     79.62 x 13.60 = 1082.8 um2, budget 1705, reference 852.06

Tool report:
r2r8 on gf180mcuD: 79.62 x 13.6 um (1082.83 um2), 276 shapes, 25 declared devices
connectivity pre-check: 4 short(s), 0 open net(s)
  SHORT B0 = n0 = t = x0
      m1 (24.670, 4.500) [sub.py:63]
      m1 (24.670, 4.500) [sub.py:72]
      m1 (16.670, 4.500) [sub.py:63]
      m1 (12.670, 4.500) [sub.py:72]
      m1 (8.670, 4.500) [sub.py:63]
  SHORT B1 = n1 = x1
      m1 (48.670, 4.500) [sub.py:63]
      m1 (48.670, 4.500) [sub.py:72]
      m1 (40.000, 4.500) [sub.py:72]
      m1 (39.330, 4.500) [sub.py:63]
  SHORT B2 = B3 = B4 = B5 = B6 = n2 = n3 = n4 = n5 = n6 = x2 = x3 = x4 = x5 = x6
      m1 (72.670, 4.500) [sub.py:63]
      m1 (72.670, 7.350) [sub.py:72]
      m1 (72.670, 10.500) [sub.py:63]
      m1 (72.000, 10.500) [sub.py:72]
      m1 (56.670, 10.500) [sub.py:72]
      m1 (56.670, 10.500) [sub.py:63]
  SHORT B7 = x7
      m1 (32.670, 16.500) [sub.py:63]
      m1 (35.330, 16.500) [sub.py:72]
      m1 (31.330, 16.500) [sub.py:63]
DRC (magic drc(full) gf180mcuD): clean
DRC (KLayout, gf180mcu.drc): 22 violation(s), 1 rule(s)
    22 x PP.2: PP.2 : min. pplus spacing : 0.4µm
         at (7.81, 9.7)..(8.19, 11.3)  drawn by sub.py:63 [pplus]; sub.py:72 [m1]
         at (71.81, 3.7)..(72.19, 5.3)  drawn by sub.py:63 [pplus]; sub.py:72 [m1]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 9/16, nets 7/17
    ppolyf_u (25->9)                           |ppolyf_u (25->16) **Mismatch**
    Number of devices: 9 **Mismatch**          |Number of devices: 16 **Mismatch**
    Number of nets: 7 **Mismatch**             |Number of nets: 17 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: r2r8                            |Circuit 2: r2r8
    ---------------------------------------------------------------------------------------
    Net: B6                                    |Net: B6
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B0                                    |Net: B0
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B1                                    |Net: B1
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: VSUBS                                 |Net: n3
      ppolyf_u/3 = 9                           |  ppolyf_u/(1|2) = 3
                                               |
    Net: VSS                                   |Net: VSS
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |  ppolyf_u/3 = 16
                                               |
    (no matching net)                          |Net: n5
                                               |  ppolyf_u/(1|2) = 3
                                               |
    (no matching net)                          |Net: n1
                                               |  ppolyf_u/(1|2) = 3
                                               |
    (no matching net)                          |Net: n2
                                               |  ppolyf_u/(1|2) = 3
                                               |
    (no matching net)                          |Net: B2
                                               |  ppolyf_u/(1|2) = 1
                                               |
    (no matching net)                          |Net: B3
                                               |  ppolyf_u/(1|2) = 1
                                               |
    (no matching net)                          |Net: B4
                                               |  ppolyf_u/(1|2) = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a2/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a2/r2r8.extracted.spice
result: VIOLATIONS   (7.5 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a2/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a2/r2r8.png