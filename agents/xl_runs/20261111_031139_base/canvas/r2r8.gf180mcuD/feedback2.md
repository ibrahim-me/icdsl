Judge:
  FAIL DRC      25 violation(s): 16 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7); 9 x Metal1 spacing < 0.23um (M1.2a)
  FAIL DRC2     foundry KLayout deck: 57 violation(s): 32 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 16 x CO.2a: CO.2a : min. contact spacing : 0.25µm; 9 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 16/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a2/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     63.62 x 26.32 = 1674.5 um2, budget 1705, reference 852.06

Tool report:
r2r8 on gf180mcuD: 63.62 x 26.32 um (1674.48 um2), 266 shapes, 25 declared devices
connectivity pre-check: 3 short(s), 1 open net(s)
  SHORT B1 = n1 = x1
      m1 (21.500, -3.020) [sub.py:22]
      m1 (22.835, -1.240) [sub.py:35]
      m1 (23.830, 0.500) [sub.py:22]
  SHORT B3 = n3 = x3
      m1 (35.500, -3.020) [sub.py:22]
      m1 (36.835, -1.240) [sub.py:35]
      m1 (37.830, 0.500) [sub.py:22]
  SHORT B5 = n5 = x5
      m1 (49.500, -3.020) [sub.py:22]
      m1 (50.835, -1.240) [sub.py:35]
      m1 (51.830, 0.500) [sub.py:22]
  OPEN  net OUT is in 2 unconnected pieces:
      m1 (65.830, 0.500) [sub.py:22] (5 shapes)
      m1 (63.500, 2.320) [sub.py:22] (4 shapes)
DRC (magic drc(full) gf180mcuD): 25 violation(s), 2 rule(s)
    16 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7)
         at (9.94, 0.625)..(10.06, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
         at (16.94, 0.625)..(17.06, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
     9 x Metal1 spacing < 0.23um (M1.2a)
         at (10.055, 0.85)..(10.175, 0.905)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
         at (10.055, 0.095)..(10.175, 0.15)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
DRC (KLayout, gf180mcu.drc): 57 violation(s), 3 rule(s)
    32 x CO.1: CO.1 : Min/max contact size. : 0.22µm
         at (63.845, 8.87)..(63.845, 9.13)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
         at (63.625, 8.87)..(63.625, 9.13)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
    16 x CO.2a: CO.2a : min. contact spacing : 0.25µm
         at (58.94, 0.625)..(59.06, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
         at (51.94, 0.625)..(52.06, 0.845)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
     9 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm
         at (23.945, 0.84)..(24.055, 0.905)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
         at (51.945, 0.84)..(52.055, 0.905)  drawn by sub.py:22 [contact,m1,poly,pplus]; sub.py:35 [m1]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 16/16, nets 16/17
    Number of nets: 16 **Mismatch**            |Number of nets: 17 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: r2r8                            |Circuit 2: r2r8
    ---------------------------------------------------------------------------------------
    Net: a_2800_428#                           |Net: n0
      ppolyf_u/(1|2) = 3                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: a_11200_428#                          |Net: n1
      ppolyf_u/(1|2) = 3                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: a_8400_428#                           |Net: n2
      ppolyf_u/(1|2) = 3                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: a_5600_428#                           |Net: n3
      ppolyf_u/(1|2) = 3                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: VSUBS                                 |Net: n4
      ppolyf_u/3 = 16                          |  ppolyf_u/(1|2) = 3
                                               |
    Net: B5                                    |Net: n5
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: B3                                    |Net: n6
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 3
                                               |
    Net: B1                                    |Net: VSS
      ppolyf_u/(1|2) = 4                       |  ppolyf_u/(1|2) = 1
                                               |  ppolyf_u/3 = 16
                                               |
    (no matching net)                          |Net: OUT
                                               |  ppolyf_u/(1|2) = 2
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    Net: B7                                    |Net: B7
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    Net: B6                                    |Net: B6
      ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                               |
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a2/r2r8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a2/r2r8.extracted.spice
result: VIOLATIONS   (9.2 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a2/r2r8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/r2r8.gf180mcuD/a2/r2r8.png