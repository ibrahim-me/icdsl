Judge:
  FAIL DRC      616 violation(s): 320 x MiM cap cannot overlap via3 (MIMTM.10); 168 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3); 64 x MiM cap top plate width < 5um (MIMTM.8a); 64 x Via3 width < 0.28um (V3.1 + 2 * V3.4)
  FAIL DRC2     foundry KLayout deck: 64 violation(s): 64 x MIMTM.10: MIMTM.10 : (a) There cannot be any Vian-2 touching MIM bottom plate Metaln-1.
  
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     47.30 x 49.04 = 2319.6 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 47.3 x 49.04 um (2319.59 um2), 2910 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = VSS
      m4 (44.200, 38.600) [sub.py:30]
      m4 (38.600, 33.000) [sub.py:30]
      m4 (36.100, 22.400) [sub.py:50]
      m4 (38.600, 21.800) [sub.py:30]
      m4 (44.200, 27.400) [sub.py:30]
DRC (magic drc(full) gf180mcuD): 616 violation(s), 4 rule(s)
   320 x MiM cap cannot overlap via3 (MIMTM.10)
         at (2.5, 44.48)..(2.55, 44.53)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
         at (2.5, 38.88)..(2.55, 38.93)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
   168 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)
         at (7.36, 44.48)..(7.5, 45.08)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]
         at (7.36, 43.6)..(7.5, 45.08)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]
    64 x MiM cap top plate width < 5um (MIMTM.8a)
         at (2.5, 44.2)..(2.64, 44.48)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
         at (8.1, 44.2)..(8.24, 44.48)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
    64 x Via3 width < 0.28um (V3.1 + 2 * V3.4)
         at (2.5, 44.2)..(2.64, 44.48)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
         at (2.5, 38.6)..(2.64, 38.88)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
DRC (KLayout, gf180mcu.drc): 64 violation(s), 1 rule(s)
    64 x MIMTM.10: MIMTM.10 : (a) There cannot be any Vian-2 touching MIM bottom plate Metaln-1.
                      (b) MIM bottom plate Metaln-1 can only be connected through the higher Via (Vian-1).
         at (2.5, 5.01)..(2.63, 5.27)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
         at (8.1, 5.01)..(8.23, 5.27)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:36 [m5]; sub.py:50 [m4]; sub.py:80 [m4]; sub.py:82 [m3,m4,via3]; (+1 more lines)
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a2/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a2/cdac6.extracted.spice
result: VIOLATIONS   (9.3 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a2/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a2/cdac6.png