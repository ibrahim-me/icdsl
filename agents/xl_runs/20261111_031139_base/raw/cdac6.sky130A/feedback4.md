Judge:
  FAIL DRC      14 violation(s): 14 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11)
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/cdac6.sky130A/a4/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     117.50 x 193.28 = 22710.4 um2, budget 8511, reference 4255.26

Tool report:
magic DRC: 14 violation(s)
    14 x MiM cap spacing to unrelated metal3 < 1.34um (capm.11)   e.g. at (8.000 22.000 8.340 23.340)  (8.000 22.000 8.340 27.000)  (8.000 25.660 8.340 27.000)
LVS: Top level cell failed pin matching.   devices layout/ref [1, 7]  nets layout/ref [2, 8]
  Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
  Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: cdac6                           |Circuit 2: cdac6
  ---------------------------------------------------------------------------------------
  Net: c1_200_9800#                          |Net: VSS
    sky130_fd_pr__cap_mim_m3_1/1 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  Net: B5                                    |Net: B5
    sky130_fd_pr__cap_mim_m3_1/2 = 1         |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: B4
                                             |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: B3
                                             |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: B2
                                             |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: B1
                                             |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: B0
                                             |  sky130_fd_pr__cap_mim_m3_1/2 = 1
                                             |
  (no matching net)                          |Net: TOP
                                             |  sky130_fd_pr__cap_mim_m3_1/1 = 7
  ---------------------------------------------------------------------------------------
  DEVICE mismatches: Class fragments follow (with node fanout counts):
  Circuit 1: cdac6                           |Circuit 2: cdac6
  ---------------------------------------------------------------------------------------
  Instance: sky130_fd_pr__cap_mim_m3_1:0     |Instance: sky130_fd_pr__cap_mim_m3_1:C0
    1 = 1                                    |  1 = 7
    2 = 1                                    |  2 = 1
                                             |
  (no matching instance)                     |Instance: sky130_fd_pr__cap_mim_m3_1:C1
                                             |  1 = 7
                                             |  2 = 1