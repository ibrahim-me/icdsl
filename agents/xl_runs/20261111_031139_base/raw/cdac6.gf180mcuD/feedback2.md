Judge:
  FAIL DRC      640 violation(s): 640 x MiM cap top plate width < 5um (MIMTM.8a)
  FAIL DRC2     foundry KLayout deck: 128 violation(s): 64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.; 64 x MIMTM.8a: MIMTM.8a : Minimum MIM cap area (defined by FuseTop area): 25µm²
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/cdac6.gf180mcuD/a2/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     122.00 x 62.36 = 7607.9 um2, budget 10578, reference 5288.9

Tool report:
DRC (magic drc(full)): 640 violation(s), boxes in um
   640 x MiM cap top plate width < 5um (MIMTM.8a)   e.g. at (5.000 52.640 6.000 54.000)  (6.000 52.640 7.000 54.000)  (5.000 52.360 6.000 52.640)
DRC2 (foundry KLayout deck): 128 violation(s), boxes in um
    64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.   e.g. at (1.600 1.600 5.400 5.400)  (8.600 1.600 12.400 5.400)  (15.600 1.600 19.400 5.400)
    64 x MIMTM.8a: MIMTM.8a : Minimum MIM cap area (defined by FuseTop area): 25µm²   e.g. at (1.600 1.600 5.400 5.400)  (8.600 1.600 12.400 5.400)  (15.600 1.600 19.400 5.400)
LVS: Top level cell failed pin matching.   devices layout/ref 1/7, nets layout/ref 2/8
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