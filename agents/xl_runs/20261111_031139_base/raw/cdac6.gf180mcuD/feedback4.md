Judge:
  FAIL DRC      1352 violation(s): 644 x MiM cap to Metal4 spacing < 1.2um (MIMTM.1); 512 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3); 132 x MiM bottom plate to unrelated metal < 1.2um (MIMTM.1); 64 x Metal4 spacing < 0.28um (M4.2a)
  FAIL DRC2     foundry KLayout deck: 660 violation(s): 308 x MIMTM.1: MIMTM.1 : Minimum MiM bottom plate spacing to the bottom plate metal
            ; 256 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.; 64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.; 32 x M4.2a: M4.2a : min. metal4 spacing : 0.28µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/cdac6.gf180mcuD/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     106.00 x 66.86 = 7087.2 um2, budget 10578, reference 5288.9

Tool report:
DRC (magic drc(full)): 1352 violation(s), boxes in um
   644 x MiM cap to Metal4 spacing < 1.2um (MIMTM.1)   e.g. at (1.300 62.160 6.700 62.700)  (9.300 62.160 14.700 62.700)  (17.300 62.160 22.700 62.700)
   512 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)   e.g. at (1.300 62.500 6.700 62.700)  (1.300 60.140 1.500 62.700)  (1.300 59.860 1.500 60.140)
   132 x MiM bottom plate to unrelated metal < 1.2um (MIMTM.1)   e.g. at (0.900 63.360 64.300 63.640)  (7.860 60.140 8.140 63.360)  (15.860 60.140 16.140 63.360)
    64 x Metal4 spacing < 0.28um (M4.2a)   e.g. at (0.900 63.360 7.100 63.380)  (7.100 63.360 7.380 63.380)  (8.620 63.360 15.100 63.380)
DRC2 (foundry KLayout deck): 660 violation(s), boxes in um
   308 x MIMTM.1: MIMTM.1 : Minimum MiM bottom plate spacing to the bottom plate metal
                      (whether adjacent MiM or routing metal). : 1.2µm   e.g. at (31.729 55.100 33.031 55.360)  (31.729 47.100 33.031 47.360)  (32.140 55.100 39.860 55.360)
   256 x MIMTM.3: MIMTM.3 : Minimum MiM bottom plate overlap of Top plate.   e.g. at (48.899 48.899 49.101 55.101)  (48.899 54.899 55.101 55.101)  (40.899 54.899 47.101 55.101)
    64 x MIMTM.7: MIMTM.7 : Min FuseTop enclosure by CAP_MK: 0um.   e.g. at (1.100 1.100 6.900 6.900)  (9.100 1.100 14.900 6.900)  (17.100 1.100 22.900 6.900)
    32 x M4.2a: M4.2a : min. metal4 spacing : 0.28µm   e.g. at (56.796 55.100 63.204 55.360)  (48.796 55.100 55.204 55.360)  (16.796 31.100 23.204 31.360)
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
  Net: m4_3380_4980#                         |Net: B5
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