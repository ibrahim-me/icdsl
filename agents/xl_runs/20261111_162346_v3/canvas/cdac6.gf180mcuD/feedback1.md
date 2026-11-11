Judge:
  ok   DRC      clean
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a1/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     50.30 x 50.00 = 2515.0 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 50.3 x 50 um (2515 um2), 2639 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = VSS
      m4 (38.500, 44.500) [sub.py:44]
      m4 (20.700, 41.850) [sub.py:72]
      m4 (26.500, 44.500) [sub.py:44]
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
    Net: B5                                    |Net: B5
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a1/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a1/cdac6.extracted.spice
result: VIOLATIONS   (7.4 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a1/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a1/cdac6.png