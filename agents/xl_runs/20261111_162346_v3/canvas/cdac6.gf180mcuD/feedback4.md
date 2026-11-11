Judge:
  ok   DRC      clean
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     74.00 x 74.00 = 5476.0 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 74 x 74 um (5476 um2), 2824 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 7 open net(s)
  SHORT B0 = B1 = B2 = VSS
      m3 (72.850, 65.500) [sub.py:78]
      m3 (72.850, 65.500) [sub.py:78]
      m3 (72.850, 65.500) [sub.py:78]
  OPEN  net B5 is in 33 unconnected pieces:
      m3 (72.850, 16.000) [sub.py:78] (130 shapes)
      m4 (2.500, 2.500) [sub.py:30] (1 shapes)
      m4 (11.500, 2.500) [sub.py:30] (1 shapes)
      m4 (20.500, 2.500) [sub.py:30] (1 shapes)
      m4 (29.500, 2.500) [sub.py:30] (1 shapes)
  OPEN  net B4 is in 17 unconnected pieces:
      m3 (72.850, 43.000) [sub.py:78] (66 shapes)
      m4 (2.500, 38.500) [sub.py:30] (1 shapes)
      m4 (11.500, 38.500) [sub.py:30] (1 shapes)
      m4 (20.500, 38.500) [sub.py:30] (1 shapes)
      m4 (29.500, 38.500) [sub.py:30] (1 shapes)
  OPEN  net B3 is in 9 unconnected pieces:
      m3 (72.850, 56.500) [sub.py:78] (34 shapes)
      m4 (2.500, 56.500) [sub.py:30] (1 shapes)
      m4 (11.500, 56.500) [sub.py:30] (1 shapes)
      m4 (20.500, 56.500) [sub.py:30] (1 shapes)
      m4 (29.500, 56.500) [sub.py:30] (1 shapes)
  OPEN  net B2 is in 5 unconnected pieces:
      m3 (72.850, 65.500) [sub.py:78] (40 shapes)
      m4 (2.500, 65.500) [sub.py:30] (1 shapes)
      m4 (11.500, 65.500) [sub.py:30] (1 shapes)
      m4 (20.500, 65.500) [sub.py:30] (1 shapes)
      m4 (29.500, 65.500) [sub.py:30] (1 shapes)
  OPEN  net B1 is in 3 unconnected pieces:
      m3 (72.850, 65.500) [sub.py:78] (40 shapes)
      m4 (38.500, 65.500) [sub.py:30] (1 shapes)
      m4 (47.500, 65.500) [sub.py:30] (1 shapes)
  OPEN  net B0 is in 2 unconnected pieces:
      m3 (72.850, 65.500) [sub.py:78] (40 shapes)
      m4 (56.500, 65.500) [sub.py:30] (1 shapes)
  OPEN  net VSS is in 2 unconnected pieces:
      m3 (72.850, 65.500) [sub.py:78] (40 shapes)
      m4 (65.500, 65.500) [sub.py:30] (1 shapes)
DRC (magic drc(full) gf180mcuD): clean
DRC (KLayout, gf180mcu.drc): clean  (not judged on a block: DCF.1a DCF.1b M1.4 M2.4 M3.4 PL.8)
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
    Net: m4_n120_12480#                        |Net: B5
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a4/cdac6.extracted.spice
result: VIOLATIONS   (7.5 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a4/cdac6.png