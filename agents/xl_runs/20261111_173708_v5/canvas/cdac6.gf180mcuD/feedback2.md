Judge:
  FAIL DRC      3 violation(s): 3 x Metal2 spacing < 0.28um (M2.2a)
  FAIL DRC2     foundry KLayout deck: 1 violation(s): 1 x M2.2a: M2.2a : min. metal2 spacing : 0.28µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/cdac6.gf180mcuD/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     86.40 x 82.65 = 7141.0 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 86.4 x 82.65 um (7140.96 um2), 2639 shapes, 64 declared devices
connectivity pre-check: 2 short(s), 7 open net(s)
  SHORT B0 = B1 = B2 = VSS
      m2 (82.100, 72.500) [sub.py:85]
      m2 (82.100, 72.500) [sub.py:85]
  SHORT B2 = B5
      m2 (82.100, 2.600) [sub.py:66]
      m2 (82.100, 2.500) [sub.py:85]
  OPEN  net B5 is in 37 unconnected pieces:
      m2 (82.100, 2.500) [sub.py:85] (8 shapes)
      m2 (82.100, 12.500) [sub.py:85] (5 shapes)
      m2 (82.100, 22.500) [sub.py:85] (5 shapes)
      m2 (82.100, 32.500) [sub.py:85] (5 shapes)
      m2 (82.100, 9.200) [sub.py:66] (3 shapes)
  OPEN  net B4 is in 19 unconnected pieces:
      m2 (82.100, 42.500) [sub.py:85] (5 shapes)
      m2 (82.100, 52.500) [sub.py:85] (5 shapes)
      m2 (82.100, 7.000) [sub.py:66] (3 shapes)
      m4 (2.500, 42.500) [sub.py:37] (1 shapes)
      m4 (12.500, 42.500) [sub.py:37] (1 shapes)
  OPEN  net B3 is in 10 unconnected pieces:
      m2 (82.100, 62.500) [sub.py:85] (5 shapes)
      m2 (82.100, 4.800) [sub.py:66] (3 shapes)
      m4 (2.500, 62.500) [sub.py:37] (1 shapes)
      m4 (12.500, 62.500) [sub.py:37] (1 shapes)
      m4 (22.500, 62.500) [sub.py:37] (1 shapes)
  OPEN  net B2 is in 6 unconnected pieces:
      m2 (82.100, 72.500) [sub.py:85] (20 shapes)
      m2 (82.100, 2.600) [sub.py:66] (8 shapes)
      m4 (2.500, 72.500) [sub.py:37] (1 shapes)
      m4 (12.500, 72.500) [sub.py:37] (1 shapes)
      m4 (22.500, 72.500) [sub.py:37] (1 shapes)
  OPEN  net B1 is in 4 unconnected pieces:
      m2 (82.100, 72.500) [sub.py:85] (20 shapes)
      m2 (82.100, 0.400) [sub.py:66] (3 shapes)
      m4 (42.500, 72.500) [sub.py:37] (1 shapes)
      m4 (52.500, 72.500) [sub.py:37] (1 shapes)
  OPEN  net B0 is in 3 unconnected pieces:
      m2 (82.100, 72.500) [sub.py:85] (20 shapes)
      m2 (82.100, -1.800) [sub.py:66] (3 shapes)
      m4 (62.500, 72.500) [sub.py:37] (1 shapes)
  OPEN  net VSS is in 3 unconnected pieces:
      m2 (82.100, 72.500) [sub.py:85] (20 shapes)
      m2 (82.100, 11.400) [sub.py:66] (3 shapes)
      m4 (72.500, 72.500) [sub.py:37] (1 shapes)
DRC (magic drc(full) gf180mcuD): 3 violation(s), 1 rule(s)
     3 x Metal2 spacing < 0.28um (M2.2a)
         at (81.84, 12.36)..(81.96, 12.53)  drawn by sub.py:51 [m5]; sub.py:85 [m2,m3,via2]; sub.py:86 [m3]
         at (81.96, 12.36)..(82.24, 12.53)  drawn by sub.py:51 [m5]; sub.py:85 [m2,m3,via2]; sub.py:86 [m3]
DRC (KLayout, gf180mcu.drc): 1 violation(s), 1 rule(s)
     1 x M2.2a: M2.2a : min. metal2 spacing : 0.28µm
         at (81.583, 12.25)..(82.617, 12.36)  drawn by sub.py:51 [m5]; sub.py:53 [m5]; sub.py:85 [m2,m3,via2]; sub.py:86 [m3]; sub.py:92 [m2]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 2/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: TOP                                   |Net: TOP
      cap_mim_2f0_m4m5_noshield/1 = 1          |  cap_mim_2f0_m4m5_noshield/1 = 7
                                               |
    Net: m4_1880_11880#                        |Net: B5
      cap_mim_2f0_m4m5_noshield/2 = 1          |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B4
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B3
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B2
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B1
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B0
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: VSS
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Instance: cap_mim_2f0_m4m5_noshield:0      |Instance: cap_mim_2f0_m4m5_noshield:C0
      1 = 1                                    |  1 = 7
      2 = 1                                    |  2 = 1
                                               |
    (no matching instance)                     |Instance: cap_mim_2f0_m4m5_noshield:C1
                                               |  1 = 7
                                               |  2 = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/cdac6.gf180mcuD/a2/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/cdac6.gf180mcuD/a2/cdac6.extracted.spice
result: VIOLATIONS   (8.7 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/cdac6.gf180mcuD/a2/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_173708_v5/canvas/cdac6.gf180mcuD/a2/cdac6.png