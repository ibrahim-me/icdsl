Judge:
  FAIL DRC      12 violation(s): 12 x Metal4 > 0.3um spacing to unrelated m4 < 0.3um (M4.2b)
  FAIL DRC2     foundry KLayout deck: 24 violation(s): 23 x MIMTM.1: MIMTM.1 : Minimum MiM bottom plate spacing to the bottom plate metal
            ; 1 x M4.2b: M4.2b : Space to wide Metal4 (length & width > 10um) : 0.3µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     25.50 x 112.78 = 2875.9 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 25.5 x 112.78 um (2875.89 um2), 2582 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = VSS
      m4 (5.600, 102.000) [sub.py:45]
      m4 (11.800, 99.800) [sub.py:70]
      m4 (5.600, 94.920) [sub.py:45]
DRC (magic drc(full) gf180mcuD): 12 violation(s), 1 rule(s)
    12 x Metal4 > 0.3um spacing to unrelated m4 < 0.3um (M4.2b)
         at (0, 69.26)..(2.5, 69.28)  drawn by sub.py:45 [m4]; sub.py:51 [m5]; sub.py:70 [m4]
         at (0, 69.56)..(2.5, 69.58)  drawn by sub.py:45 [m4]; sub.py:51 [m5]; sub.py:70 [m4]
DRC (KLayout, gf180mcu.drc): 24 violation(s), 2 rule(s)
    23 x MIMTM.1: MIMTM.1 : Minimum MiM bottom plate spacing to the bottom plate metal
                      (whether adjacent MiM or routing metal). : 1.2µm
         at (23.6, 83.86)..(25.5, 84.74)  drawn by sub.py:45 [m4]; sub.py:51 [m5]; sub.py:70 [m4]
         at (0.873, 96.12)..(2.5, 96.4)  drawn by sub.py:45 [m4]; sub.py:51 [m5]; sub.py:70 [m4]
     1 x M4.2b: M4.2b : Space to wide Metal4 (length & width > 10um) : 0.3µm
         at (8.592, 103.2)..(14.408, 103.48)  drawn by sub.py:45 [m4]; sub.py:51 [m5]; sub.py:70 [m4]
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
    Net: B1                                    |Net: B1
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
    (no matching net)                          |Net: B5
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a4/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a4/cdac6.extracted.spice
result: VIOLATIONS   (7.9 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a4/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a4/cdac6.png