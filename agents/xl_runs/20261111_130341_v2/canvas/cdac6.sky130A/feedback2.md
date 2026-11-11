Judge:
  FAIL DRC      896 violation(s): 512 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4); 256 x MiM cap contact width < 0.32um (via3.1 + 2 * via3.4); 128 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
  FAIL DRC2     foundry KLayout deck: 512 violation(s): 512 x via3.2: via3.2 : min. via3 spacing : 0.2um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     77.73 x 66.41 = 5161.7 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 77.73 x 66.405 um (5161.66 um2), 4852 shapes, 64 declared devices
connectivity pre-check: 2 short(s), 8 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = TOP = VSS
      m3 (65.500, 2.500) [sub.py:26]
      m3 (37.500, 27.000) [sub.py:37]
      m3 (58.500, 2.500) [sub.py:26]
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = VSS
      m2 (37.500, 63.565) [sub.py:53]
      m2 (37.500, 61.965) [sub.py:53]
  OPEN  net TOP is in 65 unconnected pieces:
      m3 (37.500, 27.000) [sub.py:37] (450 shapes)
      capm (2.500, 2.500) [sub.py:26] (68 shapes)
      capm (2.500, 9.500) [sub.py:26] (68 shapes)
      capm (2.500, 16.500) [sub.py:26] (68 shapes)
      capm (2.500, 23.500) [sub.py:26] (68 shapes)
  OPEN  net B0 is in 2 unconnected pieces:
      m3 (65.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 63.565) [sub.py:53] (58 shapes)
  OPEN  net B1 is in 2 unconnected pieces:
      m3 (58.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 61.965) [sub.py:53] (58 shapes)
  OPEN  net B2 is in 2 unconnected pieces:
      m3 (51.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 60.365) [sub.py:53] (58 shapes)
  OPEN  net B3 is in 2 unconnected pieces:
      m3 (44.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 58.765) [sub.py:53] (58 shapes)
  OPEN  net B4 is in 2 unconnected pieces:
      m3 (30.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 57.165) [sub.py:53] (58 shapes)
  OPEN  net B5 is in 2 unconnected pieces:
      m3 (2.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 55.565) [sub.py:53] (58 shapes)
  OPEN  net VSS is in 2 unconnected pieces:
      m3 (72.500, 2.500) [sub.py:26] (450 shapes)
      m2 (37.500, 65.165) [sub.py:53] (58 shapes)
DRC (magic drc(full) sky130A): 896 violation(s), 3 rule(s)
   512 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4)
         at (0, 51.64)..(0.07, 51.74)  drawn by sub.py:26 [capm,m3]; sub.py:37 [m3]; sub.py:77 [m1,m2,m3]
         at (0.07, 51.36)..(0.17, 51.37)  drawn by sub.py:26 [capm,m3]; sub.py:37 [m3]; sub.py:77 [m1,m2,m3]
   256 x MiM cap contact width < 0.32um (via3.1 + 2 * via3.4)
         at (2.36, 51.66)..(2.64, 51.96)  drawn by sub.py:26 [capm,m3,m4]; sub.py:37 [m3]; sub.py:40 [m3,m4]; sub.py:73 [m1]
         at (2.36, 51.66)..(2.64, 51.96)  drawn by sub.py:26 [capm,m3,m4]; sub.py:37 [m3]; sub.py:40 [m3,m4]; sub.py:73 [m1]
   128 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
         at (0, 51.36)..(0.07, 51.365)  drawn by sub.py:26 [capm,m3]; sub.py:37 [m3]; sub.py:77 [m1,m2,m3]
         at (7, 51.36)..(7.07, 51.365)  drawn by sub.py:26 [capm,m3]; sub.py:37 [m3]; sub.py:77 [m1,m2,m3]
DRC (KLayout, sky130A_mr.drc): 512 violation(s), 1 rule(s)
   512 x via3.2: via3.2 : min. via3 spacing : 0.2um
         at (44.6, 30.527)..(44.7, 30.773)  drawn by sub.py:26 [capm,m3,m4,via3]; sub.py:37 [m3]; sub.py:40 [m3,m4,via3]; sub.py:73 [m1]
         at (44.527, 30.6)..(44.773, 30.7)  drawn by sub.py:26 [capm,m3,m4,via3]; sub.py:37 [m3]; sub.py:40 [m3,m4,via3]; sub.py:73 [m1]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: c1_7000_0#                            |Net: VSS
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                               |
    Net: TOP                                   |Net: TOP
      sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/1 = 7
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
    (no matching net)                          |Net: B5
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a2/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a2/cdac6.extracted.spice
result: VIOLATIONS   (7.9 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a2/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a2/cdac6.png