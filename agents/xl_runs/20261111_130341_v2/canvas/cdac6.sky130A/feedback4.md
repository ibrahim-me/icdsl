Judge:
  ok   DRC      clean
  FAIL DRC2     foundry KLayout deck: 256 violation(s): 256 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 7/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     76.53 x 54.61 = 4178.9 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 76.53 x 54.605 um (4178.92 um2), 4435 shapes, 64 declared devices
connectivity pre-check: 0 short(s), 1 open net(s)
  OPEN  net TOP is in 5 unconnected pieces:
      capm (2.500, 2.500) [sub.py:19] (3817 shapes)
      capm (51.500, 2.500) [sub.py:19] (273 shapes)
      capm (58.500, 2.500) [sub.py:19] (137 shapes)
      capm (65.500, 2.500) [sub.py:19] (69 shapes)
      capm (72.500, 2.500) [sub.py:19] (69 shapes)
DRC (magic drc(full) sky130A): clean
DRC (KLayout, sky130A_mr.drc): 256 violation(s), 1 rule(s)
   256 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um
         at (37.1, 2.9)..(37.9, 2.9)  drawn by sub.py:19 [capm,m3,m4,via3]; sub.py:52 [m4]; sub.py:56 [m4]; sub.py:58 [via3]
         at (37.1, 2.1)..(37.9, 2.1)  drawn by sub.py:19 [capm,m3,m4,via3]; sub.py:52 [m4]; sub.py:56 [m4]; sub.py:58 [via3]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 7/7, nets 12/8
    Number of nets: 12 **Mismatch**            |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: TOP                                   |Net: TOP
      sky130_fd_pr__cap_mim_m3_1/1 = 3         |  sky130_fd_pr__cap_mim_m3_1/1 = 7
                                               |
    Net: c1_14000_0#                           |(no matching net)
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |
                                               |
    Net: c1_12600_0#                           |(no matching net)
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |
                                               |
    Net: c1_9800_0#                            |(no matching net)
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |
                                               |
    Net: c1_11200_0#                           |(no matching net)
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |
    ---------------------------------------------------------------------------------------
    Netlists do not match.
    Port matching may fail to disambiguate symmetries.
    Subcircuit pins:
    Circuit 1: cdac6                           |Circuit 2: cdac6
    -------------------------------------------|-------------------------------------------
    TOP                                        |TOP
    B1                                         |B0 **Mismatch**
    B2                                         |B1 **Mismatch**
    B3                                         |B2 **Mismatch**
    B0                                         |B3 **Mismatch**
    B5                                         |B4 **Mismatch**
    VSS                                        |B5 **Mismatch**
    B4                                         |VSS **Mismatch**
    ---------------------------------------------------------------------------------------
    Cell pin lists for cdac6 and cdac6 altered to match.
    Device classes cdac6 and cdac6 are equivalent.
    Final result: Top level cell failed pin matching.
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a4/cdac6.extracted.spice
result: VIOLATIONS   (6.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.sky130A/a4/cdac6.png