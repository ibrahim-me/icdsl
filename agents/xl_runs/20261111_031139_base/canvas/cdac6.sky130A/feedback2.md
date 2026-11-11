Judge:
  FAIL DRC      10268 violation(s): 8988 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11); 896 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4); 384 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
  FAIL DRC2     foundry KLayout deck: 308 violation(s): 308 x capm.2b: capm.2b : min. spacing between met3_bot_plate : 1.2um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     50.91 x 54.28 = 2763.1 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 50.905 x 54.28 um (2763.12 um2), 4808 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 1 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = TOP = VSS
      m3 (14.500, 14.500) [sub.py:26]
      via2 (14.500, 14.500) [sub.py:44]
      m2 (14.500, 26.913) [sub.py:48]
      m2 (23.312, 50.640) [sub.py:38]
      m2 (20.500, 26.913) [sub.py:48]
      via2 (20.500, 20.500) [sub.py:44]
      m3 (20.500, 20.500) [sub.py:26]
  OPEN  net TOP is in 65 unconnected pieces:
      m3 (2.500, 2.500) [sub.py:44] (592 shapes)
      capm (2.500, 2.500) [sub.py:26] (66 shapes)
      capm (8.500, 2.500) [sub.py:26] (66 shapes)
      capm (14.500, 2.500) [sub.py:26] (66 shapes)
      capm (20.500, 2.500) [sub.py:26] (66 shapes)
DRC (magic drc(full) sky130A): 10268 violation(s), 3 rule(s)
  8988 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11)
         at (6, 46.76)..(6.48, 47)  drawn by sub.py:26 [capm,m3,m4]
         at (6, 46.44)..(6.24, 46.76)  drawn by sub.py:26 [capm,m3,m4]
   896 x MiM cap spacing to via2 < 0.1um (capm.8 - via2.4)
         at (0, 44.64)..(0.07, 44.74)  drawn by sub.py:26 [capm,m3]; sub.py:60 [m2,m3]; sub.py:64 [m2]
         at (0, 38.64)..(0.07, 38.74)  drawn by sub.py:26 [capm,m3]; sub.py:60 [m2,m3]; sub.py:64 [m2]
   384 x MiM cap spacing to via2 < 0.005um (capm.8 - via2.4)
         at (0, 44.36)..(0.07, 44.365)  drawn by sub.py:26 [capm,m3]; sub.py:60 [m2,m3]; sub.py:64 [m2]
         at (0, 38.36)..(0.07, 38.365)  drawn by sub.py:26 [capm,m3]; sub.py:60 [m2,m3]; sub.py:64 [m2]
DRC (KLayout, sky130A_mr.drc): 308 violation(s), 1 rule(s)
   308 x capm.2b: capm.2b : min. spacing between met3_bot_plate : 1.2um
         at (23.14, 41.86)..(23.86, 47.14)  drawn by sub.py:26 [m3]; sub.py:60 [m2,m3,via2]; sub.py:64 [m2]
         at (23.14, 35.86)..(23.86, 41.14)  drawn by sub.py:26 [m3]; sub.py:60 [m2,m3,via2]; sub.py:64 [m2]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: c1_1200_4800#                         |Net: VSS
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a2/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a2/cdac6.extracted.spice
result: VIOLATIONS   (6.9 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a2/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/cdac6.sky130A/a2/cdac6.png