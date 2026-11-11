Judge:
  FAIL DRC      539 violation(s): 312 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3); 152 x MiM cap spacing to via4 < 0.39um (MIMTM.5); 56 x Via4 width < 0.28um (V4.1 + 2 * V4.4); 19 x Metal5 spacing < 0.46um (MT.2a)
  FAIL DRC2     foundry KLayout deck: 125 violation(s): 104 x MIMTM.5: MIMTM.5 : Minimum spacing between top plate and the Vian-1 connecting to the bott; 13 x MT.2a: MT.2a : min. metaltop spacing : 0.46µm; 8 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a1/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     47.30 x 47.30 = 2237.3 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 47.3 x 47.3 um (2237.29 um2), 2739 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = TOP = VSS
      m4 (44.200, 38.600) [sub.py:28]
      m4 (44.200, 33.000) [sub.py:28]
      m4 (44.200, 27.400) [sub.py:28]
DRC (magic drc(full) gf180mcuD): 539 violation(s), 4 rule(s)
   312 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)
         at (2.5, 44.34)..(2.91, 44.94)  drawn by sub.py:28 [cap_mk,capm,m4,m5,via4]; sub.py:37 [m5]; sub.py:51 [m4]; sub.py:59 [m4]
         at (2.5, 43.46)..(2.91, 44.06)  drawn by sub.py:28 [cap_mk,capm,m4,m5,via4]; sub.py:37 [m5]; sub.py:51 [m4]
   152 x MiM cap spacing to via4 < 0.39um (MIMTM.5)
         at (7.69, 44.06)..(7.89, 44.34)  drawn by sub.py:28 [cap_mk,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
         at (13.29, 44.06)..(13.49, 44.34)  drawn by sub.py:28 [cap_mk,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
    56 x Via4 width < 0.28um (V4.1 + 2 * V4.4)
         at (2.31, 44.06)..(2.34, 44.34)  drawn by sub.py:28 [cap_mk,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
         at (7.91, 44.06)..(7.97, 44.34)  drawn by sub.py:28 [cap_mk,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
    19 x Metal5 spacing < 0.46um (MT.2a)
         at (2.86, 44.8)..(2.88, 45.3)  drawn by sub.py:28 [cap_mk,capm,m4,m5]; sub.py:37 [m5]; sub.py:51 [m4]; sub.py:59 [m4]
         at (7.12, 44.84)..(7.14, 45.3)  drawn by sub.py:28 [cap_mk,capm,m4,m5]; sub.py:59 [m4]
DRC (KLayout, gf180mcu.drc): 125 violation(s), 3 rule(s)
   104 x MIMTM.5: MIMTM.5 : Minimum spacing between top plate and the Vian-1 connecting to the bottom plate. : 0.4µm
         at (19.13, 38.108)..(19.3, 39.092)  drawn by sub.py:28 [cap_mk,capm,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
         at (19.13, 32.508)..(19.3, 33.492)  drawn by sub.py:28 [cap_mk,capm,m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
    13 x MT.2a: MT.2a : min. metaltop spacing : 0.46µm
         at (35.14, 44.8)..(35.58, 44.974)  drawn by sub.py:28 [cap_mk,capm,m4,m5]; sub.py:37 [m5]; sub.py:70 [m5]
         at (30.42, 44.8)..(30.86, 44.974)  drawn by sub.py:28 [cap_mk,capm,m4,m5]; sub.py:37 [m5]; sub.py:51 [m4]; sub.py:70 [m5]
     8 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [This is applicable for Vian-1 within 1.06um oversize of FuseTop layer
                    (referenced to virtual bottom plate)]. : 0.4µm
         at (1.899, 15.707)..(2.071, 16.693)  drawn by sub.py:28 [m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
         at (1.899, 4.507)..(2.071, 5.493)  drawn by sub.py:28 [m4]; sub.py:37 [m5]; sub.py:70 [m4,m5,via4]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 1/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 1 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: TOP                                   |Net: TOP
      cap_mim_2f0_m4m5_noshield/1 = 1          |  cap_mim_2f0_m4m5_noshield/1 = 7
      cap_mim_2f0_m4m5_noshield/2 = 1          |
                                               |
    (no matching net)                          |Net: VSS
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: B5
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
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
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Instance: cap_mim_2f0_m4m5_noshield:0      |Instance: cap_mim_2f0_m4m5_noshield:C0
      1 = 2                                    |  1 = 7
      2 = 2                                    |  2 = 1
                                               |
    (no matching instance)                     |Instance: cap_mim_2f0_m4m5_noshield:C1
                                               |  1 = 7
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a1/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a1/cdac6.extracted.spice
result: VIOLATIONS   (7.8 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a1/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/cdac6.gf180mcuD/a1/cdac6.png