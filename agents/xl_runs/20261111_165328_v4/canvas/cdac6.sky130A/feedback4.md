Judge:
  FAIL DRC      517 violation(s): 389 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4); 128 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/cdac6.sky130A/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     72.60 x 64.14 = 4656.6 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 72.6 x 64.14 um (4656.56 um2), 4594 shapes, 64 declared devices
connectivity pre-check: 2 short(s), 4 open net(s)
  SHORT B0 = B1 = B2 = VSS
      m3 (2.500, 34.500) [sub.py:39]
      via2 (-0.070, 34.500) [sub.py:95]
      m2 (-1.700, 41.250) [sub.py:100]
      m2 (-1.700, 24.250) [sub.py:100]
      via2 (-0.070, 18.500) [sub.py:95]
      m3 (2.500, 18.500) [sub.py:39]
  SHORT B3 = B4 = B5
      m3 (34.500, 34.500) [sub.py:39]
      via2 (31.930, 34.500) [sub.py:64]
      m2 (42.950, 34.000) [sub.py:114]
      via2 (47.930, 34.500) [sub.py:64]
      m3 (50.500, 34.500) [sub.py:39]
  OPEN  net B5 is in 30 unconnected pieces:
      m3 (26.500, 34.500) [sub.py:39] (45 shapes)
      m3 (10.500, 2.500) [sub.py:39] (5 shapes)
      m3 (26.500, 2.500) [sub.py:39] (5 shapes)
      m3 (42.500, 2.500) [sub.py:39] (5 shapes)
      m3 (58.500, 2.500) [sub.py:39] (5 shapes)
  OPEN  net B4 is in 16 unconnected pieces:
      m3 (50.500, 34.500) [sub.py:39] (45 shapes)
      m3 (18.500, 2.500) [sub.py:39] (5 shapes)
      m3 (50.500, 2.500) [sub.py:39] (5 shapes)
      m3 (18.500, 10.500) [sub.py:39] (5 shapes)
      m3 (50.500, 10.500) [sub.py:39] (5 shapes)
  OPEN  net B3 is in 8 unconnected pieces:
      m3 (34.500, 34.500) [sub.py:39] (45 shapes)
      m3 (34.500, 2.500) [sub.py:39] (5 shapes)
      m3 (34.500, 10.500) [sub.py:39] (5 shapes)
      m3 (34.500, 18.500) [sub.py:39] (5 shapes)
      m3 (34.500, 26.500) [sub.py:39] (5 shapes)
  OPEN  net TOP is in 2 unconnected pieces:
      capm (2.500, 2.500) [sub.py:39] (4225 shapes)
      m4 (67.000, 32.000) [sub.py:48] (5 shapes)
DRC (magic drc(full) sky130A): 517 violation(s), 2 rule(s)
   389 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4)
         at (0, 58.64)..(0.07, 58.74)  drawn by sub.py:100 [m2]; sub.py:39 [capm,m3]; sub.py:45 [m4]; sub.py:93 [m2]; sub.py:95 [m2,m3]; (+1 more lines)
         at (0.07, 58.64)..(0.17, 58.74)  drawn by sub.py:39 [capm,m3]; sub.py:45 [m4]; sub.py:93 [m2]; sub.py:95 [m2,m3]
   128 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
         at (0, 58.36)..(0.07, 58.365)  drawn by sub.py:100 [m2]; sub.py:39 [capm,m3]; sub.py:45 [m4]; sub.py:93 [m2]; sub.py:95 [m2,m3]; (+1 more lines)
         at (8, 58.36)..(8.07, 58.365)  drawn by sub.py:39 [capm,m3]; sub.py:45 [m4]; sub.py:62 [m2]; sub.py:64 [m2,m3]
DRC (KLayout, sky130A_mr.drc): clean
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 3/7, nets 4/8
    Number of devices: 3 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 4 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: c1_0_0#                               |Net: VSS
      sky130_fd_pr__cap_mim_m3_1/1 = 3         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    Net: m2_7866_9980#                         |Net: B3
      sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    Net: B2                                    |Net: B2
      sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    Net: B5                                    |Net: B5
      sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B4
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B1
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B0
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: TOP
                                               |  sky130_fd_pr__cap_mim_m3_1/1 = 7
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Instance: sky130_fd_pr__cap_mim_m3_1:0     |Instance: sky130_fd_pr__cap_mim_m3_1:C0
      1 = 3                                    |  1 = 7
      2 = 1                                    |  2 = 1
                                               |
    Instance: sky130_fd_pr__cap_mim_m3_1:8     |Instance: sky130_fd_pr__cap_mim_m3_1:C1
      1 = 3                                    |  1 = 7
      2 = 1                                    |  2 = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/cdac6.sky130A/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/cdac6.sky130A/a4/cdac6.extracted.spice
result: VIOLATIONS   (6.8 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/cdac6.sky130A/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_165328_v4/canvas/cdac6.sky130A/a4/cdac6.png