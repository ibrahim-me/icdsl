Judge:
  FAIL DRC      488 violation(s): 360 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3); 64 x Via4 width < 0.28um (V4.1 + 2 * V4.4); 64 x MiM cap spacing to via4 < 0.39um (MIMTM.5)
  FAIL DRC2     foundry KLayout deck: 72 violation(s): 64 x MIMTM.5: MIMTM.5 : Minimum spacing between top plate and the Vian-1 connecting to the bott; 8 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a3/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     50.30 x 50.00 = 2515.0 um2, budget 10578, reference 5288.9

Tool report:
cdac6 on gf180mcuD: 50.3 x 50 um (2515 um2), 2831 shapes, 64 declared devices
connectivity pre-check: 1 short(s), 0 open net(s)
  SHORT B0 = B1 = B2 = B3 = B4 = B5 = TOP = VSS
      m4 (38.500, 44.500) [sub.py:30]
      m4 (32.500, 44.500) [sub.py:30]
      m4 (26.500, 44.500) [sub.py:30]
DRC (magic drc(full) gf180mcuD): 488 violation(s), 3 rule(s)
   360 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)
         at (0, 44.64)..(0.41, 45.24)  drawn by sub.py:30 [cap_mk,capm,m4,m5,via4]; sub.py:46 [m5]
         at (0, 43.76)..(0.41, 44.36)  drawn by sub.py:30 [cap_mk,capm,m4,m5,via4]; sub.py:46 [m5]
    64 x Via4 width < 0.28um (V4.1 + 2 * V4.4)
         at (-0.19, 44.36)..(-0.16, 44.64)  drawn by sub.py:30 [cap_mk,m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]; sub.py:72 [m5]
         at (5.81, 44.36)..(5.84, 44.64)  drawn by sub.py:30 [cap_mk,m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]
    64 x MiM cap spacing to via4 < 0.39um (MIMTM.5)
         at (0, 44.36)..(0.2, 45.03)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:46 [m5]
         at (6, 44.36)..(6.2, 45.03)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:46 [m5]
DRC (KLayout, gf180mcu.drc): 72 violation(s), 2 rule(s)
    64 x MIMTM.5: MIMTM.5 : Minimum spacing between top plate and the Vian-1 connecting to the bottom plate. : 0.4µm
         at (5.83, 44.008)..(6, 44.992)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]
         at (11.83, 44.008)..(12, 44.992)  drawn by sub.py:30 [cap_mk,capm,m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]
     8 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [This is applicable for Vian-1 within 1.06um oversize of FuseTop layer
                    (referenced to virtual bottom plate)]. : 0.4µm
         at (-0.601, 8.007)..(-0.429, 8.993)  drawn by sub.py:30 [m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]
         at (-0.601, 14.007)..(-0.429, 14.993)  drawn by sub.py:30 [m4]; sub.py:46 [m5]; sub.py:63 [m4,m5,via4]; sub.py:64 [m5]
LVS (netgen): MISMATCH - Top level cell failed pin matching.  devices layout/ref 1/7, nets 1/8
    Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
    Number of nets: 1 **Mismatch**             |Number of nets: 8 **Mismatch**
    ---------------------------------------------------------------------------------------
    NET mismatches: Class fragments follow (with fanout counts):
    Circuit 1: cdac6                           |Circuit 2: cdac6
    ---------------------------------------------------------------------------------------
    Net: B5                                    |Net: B5
      cap_mim_2f0_m4m5_noshield/2 = 1          |  cap_mim_2f0_m4m5_noshield/2 = 1
      cap_mim_2f0_m4m5_noshield/1 = 1          |
                                               |
    (no matching net)                          |Net: VSS
                                               |  cap_mim_2f0_m4m5_noshield/2 = 1
                                               |
    (no matching net)                          |Net: TOP
                                               |  cap_mim_2f0_m4m5_noshield/1 = 7
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
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a3/cdac6.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a3/cdac6.extracted.spice
result: VIOLATIONS   (9.2 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a3/cdac6.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_162346_v3/canvas/cdac6.gf180mcuD/a3/cdac6.png