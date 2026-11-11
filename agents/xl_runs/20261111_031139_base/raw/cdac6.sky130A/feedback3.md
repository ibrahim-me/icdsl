Judge:
  ok   DRC      clean
  ok   DRC2     foundry KLayout deck clean
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/7; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/cdac6.sky130A/a3/judge/cdac6.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     177.00 x 128.50 = 22744.5 um2, budget 8511, reference 4255.26

Tool report:
LVS: Top level cell failed pin matching.   devices layout/ref [1, 7]  nets layout/ref [2, 8]
  Number of devices: 1 **Mismatch**          |Number of devices: 7 **Mismatch**
  Number of nets: 2 **Mismatch**             |Number of nets: 8 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: cdac6                           |Circuit 2: cdac6
  ---------------------------------------------------------------------------------------
  Net: c1_7150_7150#                         |Net: VSS
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