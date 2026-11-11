Judge:
  FAIL DRC      256 violation(s): 256 x MiM cap contact width < 0.32um (via3.1 + 2 * via3.4)
  FAIL DRC2     foundry KLayout deck: 512 violation(s): 512 x via3.2: via3.2 : min. via3 spacing : 0.2um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     78.00 x 107.00 = 8346.0 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 78 x 107 um (8346 um2), 4587 shapes, 64 declared devices
connectivity pre-check: 65 short(s), 8 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = VSS
      m1 (36.000, 11.000) [sub.py:56]
      m1 (74.500, 7.420) [sub.py:81]
      m1 (36.000, 8.400) [sub.py:56]
  SHORT B0 = TOP
      m3 (2.500, 83.500) [sub.py:25]
      m3 (2.500, 83.500) [sub.py:45]
  SHORT B1 = TOP
      m3 (2.500, 74.500) [sub.py:25]
      m3 (2.500, 74.500) [sub.py:45]
  SHORT B1 = TOP
      m3 (11.500, 74.500) [sub.py:25]
      m3 (11.500, 74.500) [sub.py:45]
  SHORT B2 = TOP
      m3 (2.500, 65.500) [sub.py:25]
      m3 (2.500, 65.500) [sub.py:45]
  SHORT B2 = TOP
      m3 (11.500, 65.500) [sub.py:25]
      m3 (11.500, 65.500) [sub.py:45]
  SHORT B2 = TOP
      m3 (20.500, 65.500) [sub.py:25]
      m3 (20.500, 65.500) [sub.py:45]
  SHORT B2 = TOP
      m3 (29.500, 65.500) [sub.py:25]
      m3 (29.500, 65.500) [sub.py:45]
  SHORT B3 = TOP
      m3 (2.500, 56.500) [sub.py:25]
      m3 (2.500, 56.500) [sub.py:45]
  SHORT B3 = TOP
      m3 (11.500, 56.500) [sub.py:25]
      m3 (11.500, 56.500) [sub.py:45]
  SHORT B3 = TOP
      m3 (20.500, 56.500) [sub.py:25]
      m3 (20.500, 56.500) [sub.py:45]
  SHORT B3 = TOP
      m3 (29.500, 56.500) [sub.py:25]
      m3 (29.500, 56.500) [sub.py:45]
  OPEN  net TOP is in 65 unconnected pieces:
      capm (2.500, 2.500) [sub.py:25] (4418 shapes)
      m3 (2.500, 2.500) [sub.py:45] (2 shapes)
      m3 (11.500, 2.500) [sub.py:45] (2 shapes)
      m3 (20.500, 2.500) [sub.py:45] (2 shapes)
      m3 (29.500, 2.500) [sub.py:45] (2 shapes)
  OPEN  net B5 is in 34 unconnected pieces:
      m1 (36.000, -2.000) [sub.py:56] (47 shapes)
      m3 (2.500, 2.500) [sub.py:25] (2 shapes)
      m3 (11.500, 2.500) [sub.py:25] (2 shapes)
      m3 (20.500, 2.500) [sub.py:25] (2 shapes)
      m3 (29.500, 2.500) [sub.py:25] (2 shapes)
  OPEN  net B4 is in 18 unconnected pieces:
      m1 (36.000, 0.600) [sub.py:56] (47 shapes)
      m3 (2.500, 38.500) [sub.py:25] (2 shapes)
      m3 (11.500, 38.500) [sub.py:25] (2 shapes)
      m3 (20.500, 38.500) [sub.py:25] (2 shapes)
      m3 (29.500, 38.500) [sub.py:25] (2 shapes)
  OPEN  net B3 is in 9 unconnected pieces:
      m1 (36.000, 3.200) [sub.py:56] (47 shapes)
      m3 (2.500, 56.500) [sub.py:25] (2 shapes)
      m3 (11.500, 56.500) [sub.py:25] (2 shapes)
      m3 (20.500, 56.500) [sub.py:25] (2 shapes)
      m3 (29.500, 56.500) [sub.py:25] (2 shapes)
  OPEN  net B2 is in 5 unconnected pieces:
      m1 (36.000, 5.800) [sub.py:56] (47 shapes)
      m3 (2.500, 65.500) [sub.py:25] (2 shapes)
      m3 (11.500, 65.500) [sub.py:25] (2 shapes)
      m3 (20.500, 65.500) [sub.py:25] (2 shapes)
      m3 (29.500, 65.500) [sub.py:25] (2 shapes)
  OPEN  net B1 is in 3 unconnected pieces:
      m1 (36.000, 8.400) [sub.py:56] (47 shapes)
      m3 (2.500, 74.500) [sub.py:25] (2 shapes)
      m3 (11.500, 74.500) [sub.py:25] (2 shapes)
  OPEN  net B0 is in 2 unconnected pieces:
      m1 (36.000, 11.000) [sub.py:56] (47 shapes)
      m3 (2.500, 83.500) [sub.py:25] (2 shapes)
  OPEN  net VSS is in 2 unconnected pieces:
      m1 (36.000, 13.600) [sub.py:56] (47 shapes)
      m3 (2.500, 92.500) [sub.py:25] (2 shapes)
DRC (magic drc(full) sky130A): 256 violation(s), 1 rule(s)
   256 x MiM cap contact width < 0.32um (via3.1 + 2 * via3.4)
         at (2.36, 92.66)..(2.64, 92.96)  drawn by sub.py:25 [capm,m3,m4]; sub.py:45 [m3,m4]; sub.py:49 [m4]; sub.py:74 [m2]
         at (2.36, 92.66)..(2.64, 92.96)  drawn by sub.py:25 [capm,m3,m4]; sub.py:45 [m3,m4]; sub.py:49 [m4]; sub.py:74 [m2]
DRC (KLayout, sky130A_mr.drc): 512 violation(s), 1 rule(s)
   512 x via3.2: via3.2 : min. via3 spacing : 0.2um
         at (65.527, 56.6)..(65.773, 56.7)  drawn by sub.py:25 [capm,m3,m4,via3]; sub.py:45 [m3,m4,via3]; sub.py:49 [m4]; sub.py:74 [m2]
         at (65.6, 56.227)..(65.7, 56.473)  drawn by sub.py:25 [capm,m3,m4,via3]; sub.py:45 [m3,m4,via3]; sub.py:49 [m4]; sub.py:74 [m2]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ------------------------------------------------------------
...
                                  |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B3
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B2
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B1
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B0
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: VSS
                                               |  sky130_fd_pr__cap_mim_m3_1/2 = 1
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Instance: sky130_fd_pr__cap_mim_m3_1:0     |Instance: sky130_fd_pr__cap_mim_m3_1:C0
      1 = 1                                    |  1 = 7
      2 = 1                                    |  2 = 1
                                               |
    (no matching instance)                     |Instance: sky130_fd_pr__cap_mim_m3_1:C1
                                               |  1 = 7
                                               |  2 = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a4/cdac6.extracted.spice
result: VIOLATIONS   (6.1 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a4/cdac6.png