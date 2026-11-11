Judge:
  ok   DRC      clean
  FAIL DRC2     foundry KLayout deck: 440 violation(s): 376 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.; 64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/cdac6.gf180mcuD/a3/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     114.00 x 103.36 = 11783.0 um2, budget 10578, reference 5288.9

Tool report:
DRC2 (foundry KLayout deck): 440 violation(s), boxes in um
   376 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.   e.g. at (64.399 55.399 64.601 61.601)  (67.073 61.399 70.601 61.601)  (70.399 55.399 70.601 61.601)
    64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.   e.g. at (1.600 1.600 7.400 7.400)  (10.600 1.600 16.400 7.400)  (19.600 1.600 25.400 7.400)
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
  Net: m4_280_280#                           |Net: B5
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