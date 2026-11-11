Judge:
  FAIL DRC      897 violation(s): 512 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4); 384 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4); 1 x Metal5 width < 1.6um (met5.1)
  FAIL DRC2     foundry KLayout deck: 514 violation(s): 512 x via3.2: via3.2 : min. via3 spacing : 0.2um; 2 x m5.1: m5.1 : min. m5 width : 1.6um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     68.80 x 70.76 = 4868.3 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 68.8 x 70.76 um (4868.29 um2), 5052 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 1 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = TOP = VSS
      m3 (55.700, 48.100) [sub.py:34]
      via2 (55.700, 48.100) [sub.py:46]
      m2 (57.000, 49.400) [sub.py:51]
      m2 (57.000, 38.000) [sub.py:51]
      via2 (55.700, 32.900) [sub.py:46]
      m3 (55.700, 32.900) [sub.py:34]
  OPEN  net TOP is in 3 unconnected pieces:
      m3 (-1.500, -2.550) [sub.py:67] (4490 shapes)
      m3 (2.500, 2.500) [sub.py:46] (568 shapes)
      m1 (-4.000, -2.550) [sub.py:64] (2 shapes)
DRC (magic drc(full) sky130A): 897 violation(s), 3 rule(s)
   512 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4)
         at (2.26, 55.84)..(2.64, 55.94)  drawn by sub.py:34 [capm,m3,m4,via3]; sub.py:43 [m5]; sub.py:46 [li,m1,m2,m3,m4,m5,via4]; sub.py:51 [m2]
         at (9.86, 55.84)..(10.24, 55.94)  drawn by sub.py:34 [capm,m3,m4,via3]; sub.py:43 [m5]; sub.py:46 [li,m1,m2,m3,m4,m5,via4]; sub.py:51 [m2]
   384 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
         at (2.36, 55.83)..(2.365, 55.84)  drawn by sub.py:34 [capm,m3,m4]; sub.py:43 [m5]; sub.py:46 [m1,m2,m3,m4,m5,via4]; sub.py:51 [m2]
         at (2.36, 55.57)..(2.365, 55.83)  drawn by sub.py:34 [capm,m3,m4]; sub.py:43 [m5]; sub.py:46 [m1,m2,m3,m4,m5,via4]; sub.py:51 [m2]
     1 x Metal5 width < 1.6um (met5.1)
         at (-2.3, -1.3)..(-2, -0.4)  drawn by sub.py:43 [m5]; sub.py:64 [m1]; sub.py:67 [m5]; sub.py:87 [m1]
DRC (KLayout, sky130A_mr.drc): 514 violation(s), 2 rule(s)
   512 x via3.2: via3.2 : min. via3 spacing : 0.2um
         at (55.427, 55.8)..(55.673, 55.9)  drawn by sub.py:34 [capm,m3,m4,via3]; sub.py:43 [m5]; sub.py:46 [li,m1,m2,m3,m4,m5,mcon,via2,via3,via4]; sub.py:51 [m2]
         at (55.5, 55.727)..(55.6, 55.973)  drawn by sub.py:34 [capm,m3,m4,via3]; sub.py:43 [m5]; sub.py:46 [li,m1,m2,m3,m4,m5,mcon,via2,via3,via4]; sub.py:51 [m2]
     2 x m5.1: m5.1 : min. m5 width : 1.6um
         at (-2.139, -2)..(-0.561, -1.3)  drawn by sub.py:43 [m5]; sub.py:64 [m1]; sub.py:67 [m4,m5]; sub.py:87 [m1]
         at (-2, -2.233)..(-0.7, -1.067)  drawn by sub.py:43 [m5]; sub.py:64 [m1]; sub.py:67 [m3,m4,m5,via4]; sub.py:87 [m1]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: m1_n326_n542#                         |Net: VSS
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    Net: B5                                    |Net: B5
      sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    (no matching net)                          |Net: B4
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
    (no matching net)                          |Net: TOP
                                               |  sky130_fd_pr__cap_mim_m3_1/1 = 7
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a2/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a2/cdac6.extracted.spice
result: VIOLATIONS   (6.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a2/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a2/cdac6.png