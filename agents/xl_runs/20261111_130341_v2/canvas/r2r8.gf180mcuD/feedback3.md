Judge:
  FAIL DRC      8 violation(s): 8 x Metal1 spacing < 0.23um (M1.2a)
  FAIL DRC2     foundry KLayout deck: 8 violation(s): 8 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 16/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a3/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     88.11 x 22.62 = 1993.0 um2, budget 1705, reference 852.06

Tool report:
r2r8 on gf180mcuD: 88.11 x 22.62 um (1993.05 um2), 290 shapes, 25 declared devices
connectivity pre-check: 9 short(s), 2 open net(s)
  SHORT B0 = n0 = t = x0
      m1 (18.500, 15.670) [sub.py:62]
      m1 (18.500, 14.830) [sub.py:90]
      m1 (20.000, 10.500) [sub.py:74]
      m1 (21.670, 10.500) [sub.py:33]
  SHORT B1 = n1 = x1
      m1 (28.500, 15.670) [sub.py:62]
      m1 (28.500, 14.830) [sub.py:90]
      m1 (28.330, 10.500) [sub.py:33]
  SHORT B2 = n2 = x2
      m1 (38.500, 15.670) [sub.py:62]
      m1 (38.500, 14.830) [sub.py:90]
      m1 (38.330, 10.500) [sub.py:33]
  SHORT B3 = n3 = x3
      m1 (48.500, 15.670) [sub.py:62]
      m1 (48.500, 14.830) [sub.py:90]
      m1 (48.330, 10.500) [sub.py:33]
  SHORT B4 = n4 = x4
      m1 (58.500, 15.670) [sub.py:62]
      m1 (58.500, 14.830) [sub.py:90]
      m1 (58.330, 10.500) [sub.py:33]
  SHORT B5 = n5 = x5
      m1 (68.500, 15.670) [sub.py:62]
      m1 (68.500, 14.830) [sub.py:90]
      m1 (68.330, 10.500) [sub.py:33]
  SHORT B6 = n6 = x6
      m1 (78.500, 15.670) [sub.py:62]
      m1 (78.500, 14.830) [sub.py:90]
      m1 (78.330, 10.500) [sub.py:33]
  SHORT B7 = OUT = x7
      m1 (88.500, 15.670) [sub.py:62]
      m1 (88.500, 14.830) [sub.py:90]
      m1 (88.330, 10.500) [sub.py:33]
  SHORT n0 = t
      m1 (11.670, 10.500) [sub.py:33]
      m1 (10.000, 10.500) [sub.py:74]
      m1 (8.330, 10.500) [sub.py:33]
  OPEN  net n0 is in 2 unconnected pieces:
      m1 (21.670, 10.500) [sub.py:33] (30 shapes)
      m1 (11.670, 10.500) [sub.py:33] (9 shapes)
  OPEN  net t is in 2 unconnected pieces:
      m1 (18.330, 10.500) [sub.py:33] (30 shapes)
      m1 (8.330, 10.500) [sub.py:33] (9 shapes)
DRC (magic drc(full) gf180mcuD): 8 violation(s), 1 rule(s)
     8 x Metal1 spacing < 0.23um (M1.2a)
         at (17.77, 9.7)..(18.2, 9.73)  drawn by sub.py:33 [pplus,sab]; sub.py:88 [m1]; sub.py:90 [m1]
         at (27.77, 9.7)..(28.2, 9.73)  drawn by sub.py:33 [pplus,sab]; sub.py:88 [m1]; sub.py:90 [m1]
DRC (KLayout, gf180mcu.drc): 8 violation(s), 1 rule(s)
     8 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm
         at (17.886, 9.5)..(18.2, 9.7)  drawn by sub.py:33 [pplus]; sub.py:86 [m1]; sub.py:88 [m1]; sub.py:90 [m1]
         at (27.886, 9.5)..(28.2, 9.7)  drawn by sub.py:33 [pplus]; sub.py:86 [m1]; sub.py:88 [m1]; sub.py:90 [m1]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 16/16, nets 10/17
    Number of nets: 10 **Mismatch**            |Number of nets: 17 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: r2r8                            |Circuit 2: r2r8
    ---------------------------------------------------------------------------------------
    Net: B2                                    |Net: B2
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B3                                    |Net: B3
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B6                                    |Net: B6
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B1                                    |Net: B1
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B5                                    |Net: B5
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B0                                    |Net: B0
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B4                                    |Net: B4
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: VSUBS                                 |Net: n5
      ppolyf_u/3 = 16                          |  ppolyf_u/(1|2) = 3
                                               |
    Net: B7                                    |Net: B7
      ppolyf_u/(1|2) = 3                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: VSS                                   |Net: VSS
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |  ppolyf_u/3 = 16
                                               |
    (no matching net)                          |Net: n1
                                               |  ppolyf_u/(1|2) = 3
                                               |
    (no matching net)                          |Net: n6
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a3/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a3/r2r8.extracted.spice
result: VIOLATIONS   (7.1 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a3/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/r2r8.gf180mcuD/a3/r2r8.png