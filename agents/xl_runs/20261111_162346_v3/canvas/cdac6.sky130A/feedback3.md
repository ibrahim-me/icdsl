Judge:
  ok   DRC      clean
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a3/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     67.80 x 75.90 = 5146.0 um2, budget 8511, reference 4255.26

Tool report:
cdac6 on sky130A: 67.8 x 75.9 um (5146.02 um2), 4784 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 7 open net(s)
  SHORT B0 = B1 = B2 = VSS
      m2 (55.700, 52.550) [sub.py:89]
      via (55.700, 52.550) [sub.py:144]
      m1 (55.700, 34.400) [sub.py:139]
      via (55.700, 37.350) [sub.py:144]
      m2 (55.700, 37.350) [sub.py:89]
  OPEN  net B5 is in 34 unconnected pieces:
      m2 (13.900, 6.950) [sub.py:89] (121 shapes)
      m2 (-2.000, 64.250) [sub.py:127] (5 shapes)
      m3 (2.500, 2.500) [sub.py:40] (1 shapes)
      m3 (2.500, 10.100) [sub.py:40] (1 shapes)
      m3 (2.500, 17.700) [sub.py:40] (1 shapes)
  OPEN  net B4 is in 18 unconnected pieces:
      m2 (36.700, 6.950) [sub.py:89] (65 shapes)
      m2 (-2.000, 65.950) [sub.py:127] (5 shapes)
      m3 (32.900, 2.500) [sub.py:40] (1 shapes)
      m3 (32.900, 10.100) [sub.py:40] (1 shapes)
      m3 (32.900, 17.700) [sub.py:40] (1 shapes)
  OPEN  net B3 is in 10 unconnected pieces:
      m2 (48.100, 6.950) [sub.py:89] (37 shapes)
      m2 (-2.000, 67.650) [sub.py:127] (5 shapes)
      m3 (48.100, 2.500) [sub.py:40] (1 shapes)
      m3 (48.100, 10.100) [sub.py:40] (1 shapes)
      m3 (48.100, 17.700) [sub.py:40] (1 shapes)
  OPEN  net B2 is in 6 unconnected pieces:
      m2 (55.700, 6.950) [sub.py:89] (52 shapes)
      m2 (-2.000, 69.350) [sub.py:127] (5 shapes)
      m3 (55.700, 2.500) [sub.py:40] (1 shapes)
      m3 (55.700, 10.100) [sub.py:40] (1 shapes)
      m3 (55.700, 17.700) [sub.py:40] (1 shapes)
  OPEN  net B1 is in 4 unconnected pieces:
      m2 (55.700, 37.350) [sub.py:89] (52 shapes)
      m2 (-2.000, 71.050) [sub.py:127] (5 shapes)
      m3 (55.700, 32.900) [sub.py:40] (1 shapes)
      m3 (55.700, 40.500) [sub.py:40] (1 shapes)
  OPEN  net B0 is in 3 unconnected pieces:
      m2 (55.700, 52.550) [sub.py:89] (52 shapes)
      m2 (-2.000, 72.750) [sub.py:127] (5 shapes)
      m3 (55.700, 48.100) [sub.py:40] (1 shapes)
  OPEN  net VSS is in 3 unconnected pieces:
      m2 (55.700, 61.850) [sub.py:89] (52 shapes)
      m2 (-2.000, 74.450) [sub.py:127] (5 shapes)
      m3 (55.700, 55.700) [sub.py:40] (1 shapes)
DRC (magic drc(full) sky130A): clean
DRC (KLayout, sky130A_mr.drc): clean
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: TOP                                   |Net: TOP
      sky130_fd_pr__cap_mim_m3_1/1 = 1         |  sky130_fd_pr__cap_mim_m3_1/1 = 7
                                               |
    Net: m3_7572_10612#                        |Net: B5
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a3/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a3/cdac6.extracted.spice
result: VIOLATIONS   (5.4 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a3/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.sky130A/a3/cdac6.png