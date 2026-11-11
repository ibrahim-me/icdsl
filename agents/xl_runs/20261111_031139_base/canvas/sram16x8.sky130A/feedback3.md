Judge:
  FAIL DRC      60695 violation(s): 18176 x P-tap overlap of P-tap contact < 0.12um in one direction (licon.7); 7680 x Metal1 spacing < 0.14um (met1.2); 7552 x Local interconnect spacing < 0.17um (li.3); 5248 x Diffusion spacing < 0.27um (diff/tap.3); 3968 x P-tap spacing to N-well < 0.13um (diff/tap.11); 2688 x P-tap spacing to N-well < 0.005um (diff/tap.11)
  FAIL DRC2     foundry KLayout deck: 462 violation(s): 396 x m1.2: m1.2 : min. m1 spacing : 0.14um; 23 x m1.7: m1.7 : min. m1 with holes area : 0.14um²; 17 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um; 8 x licon.1: licon.1: min/max. licon length : 0.17um; 4 x difftap.3: difftap.3 : min. difftap spacing : 0.27um; 3 x licon.13_a: licon.13_a:  licon on diff in periphery can't overlap npc
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.sky130A/a3/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     44.45 x 104.60 = 4649.5 um2, budget 4210, reference 2104.59

Tool report:
sram16x8 on sky130A: 44.45 x 104.6 um (4649.47 um2), 16436 shapes, 1024 declared devices
connectivity pre-check: 265 short(s), 290 open net(s)
  SHORT BL0 = BLB0
      m2 (4.600, 52.300) [sub.py:80]
      m2 (4.555, 2.800) in XB0_0 [sub.py:51]
  SHORT BL1 = BLB1
      m2 (10.100, 52.300) [sub.py:80]
      m2 (10.055, 2.800) in XB0_1 [sub.py:51]
  SHORT BL2 = BLB2
      m2 (15.600, 52.300) [sub.py:80]
      m2 (15.555, 2.800) in XB0_2 [sub.py:51]
  SHORT BL3 = BLB3
      m2 (21.100, 52.300) [sub.py:80]
      m2 (21.055, 2.800) in XB0_3 [sub.py:51]
  SHORT BL4 = BLB4
      m2 (26.600, 52.300) [sub.py:80]
      m2 (26.555, 2.800) in XB0_4 [sub.py:51]
  SHORT BL5 = BLB5
      m2 (32.100, 52.300) [sub.py:80]
      m2 (32.055, 2.800) in XB0_5 [sub.py:51]
  SHORT BL6 = BLB6
      m2 (37.600, 52.300) [sub.py:80]
      m2 (37.555, 2.800) in XB0_6 [sub.py:51]
  SHORT BL7 = BLB7
      m2 (43.100, 52.300) [sub.py:80]
      m2 (43.055, 2.800) in XB0_7 [sub.py:51]
  SHORT BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB5 = BLB6 = BLB7 = VDD = VSS = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9
      m1 (4.555, 0.620) in XB0_0 [sub.py:46]
      m1 (4.750, 52.300) [sub.py:93]
      m1 (22.000, 4.900) [sub.py:86]
      m1 (10.250, 52.300) [sub.py:93]
      m1 (10.055, 0.620) in XB0_1 [sub.py:46]
  SHORT VDD = VSS = XB0_0/Q = XB0_0/QB
      li (2.325, 1.320) in XB0_0 [sub.py:18]
      mcon (2.325, 1.500) in XB0_0 [sub.py:34]
      m1 (2.755, 1.500) in XB0_0 [sub.py:28]
      mcon (2.755, 1.500) in XB0_0 [sub.py:34]
      li (2.755, 1.320) in XB0_0 [sub.py:18]
      li (2.755, 1.110) in XB0_0 [sub.py:15]
  SHORT VDD = VSS = XB0_1/Q = XB0_1/QB
      li (7.825, 1.320) in XB0_1 [sub.py:18]
      mcon (7.825, 1.500) in XB0_1 [sub.py:34]
      m1 (8.255, 1.500) in XB0_1 [sub.py:28]
      mcon (8.255, 1.500) in XB0_1 [sub.py:34]
      li (8.255, 1.320) in XB0_1 [sub.py:18]
      li (8.255, 1.110) in XB0_1 [sub.py:15]
  SHORT VDD = VSS = XB0_2/Q = XB0_2/QB
      li (13.325, 1.320) in XB0_2 [sub.py:18]
      mcon (13.325, 1.500) in XB0_2 [sub.py:34]
      m1 (13.755, 1.500) in XB0_2 [sub.py:28]
      mcon (13.755, 1.500) in XB0_2 [sub.py:34]
      li (13.755, 1.320) in XB0_2 [sub.py:18]
      li (13.755, 1.110) in XB0_2 [sub.py:15]
  OPEN  net VDD is in 385 unconnected pieces:
      m1 (4.750, 52.300) [sub.py:93] (2742 shapes)
      li (2.325, 1.320) in XB0_0 [sub.py:18] (49 shapes)
      li (7.825, 1.320) in XB0_1 [sub.py:18] (49 shapes)
      li (13.325, 1.320) in XB0_2 [sub.py:18] (49 shapes)
      li (18.825, 1.320) in XB0_3 [sub.py:18] (49 shapes)
  OPEN  net VSS is in 257 unconnected pieces:
      m1 (5.650, 52.300) [sub.py:94] (2742 shapes)
      li (2.755, 1.110) in XB0_0 [sub.py:15] (49 shapes)
      li (8.255, 1.110) in XB0_1 [sub.py:15] (49 shapes)
      li (13.755, 1.110) in XB0_2 [sub.py:15] (49 shapes)
      li (19.255, 1.110) in XB0_3 [sub.py:15] (49 shapes)
  OPEN  net BL0 is in 49 unconnected pieces:
      m2 (4.600, 52.300) [sub.py:80] (34 shapes)
      m1 (1.425, 0.620) in XB0_0 [sub.py:45] (3 shapes)
      m1 (1.425, 7.220) in XB1_0 [sub.py:45] (3 shapes)
      m1 (1.425, 13.820) in XB2_0 [sub.py:45] (3 shapes)
      m1 (1.425, 20.420) in XB3_0 [sub.py:45] (3 shapes)
  OPEN  net BL1 is in 49 unconnected pieces:
      m2 (10.100, 52.300) [sub.py:80] (34 shapes)
      m1 (6.925, 0.620) in XB0_1 [sub.py:45] (3 shapes)
      m1 (6.925, 7.220) in XB1_1 [sub.py:45] (3 shapes)
      m1 (6.925, 13.820) in XB2_1 [sub.py:45] (3 shapes)
      m1 (6.925, 20.420) in XB3_1 [sub.py:45] (3 shapes)
  OPEN  net BL2 is in 49 unconnected pieces:
      m2 (15.600, 52.300) [sub.py:80] (34 shapes)
      m1 (12.425, 0.620) in XB0_2 [sub.py:45] (3 shapes)
      m1 (12.425, 7.220) in XB1_2 [sub.py:45] (3 shapes)
      m1 (12.425, 13.820) in XB2_2 [sub.py:45] (3 shapes)
      m1 (12.425, 20.420) in XB3_2 [sub.py:45] (3 shapes)
  OPEN  net BL3 is in 49 unconnected pieces:
      m2 (21.100, 52.300) [sub.py:80] (34 shapes)
      m1 (17.925, 0.620) in XB0_3 [sub.py:45] (3 shapes)
      m1 (17.925, 7.220) in XB1_3 [sub.py:45] (3 shapes)
      m1 (17.925, 13.820) in XB2_3 [sub.py:45] (3 shapes)
      m1 (17.925, 20.420) in XB3_3 [sub.py:45] (3 shapes)
  OPEN  net BL4 is in 49 unconnected pieces:
      m2 (26.600, 52.300) [sub.py:80] (34 shapes)
      m1 (23.425, 0.620) in XB0_4 [sub.py:45] (3 shapes)
      m1 (23.425, 7.220) in XB1_4 [sub.py:45] (3 shapes)
      m1 (23.425, 13.820) in XB2_4 [sub.py:45] (3 shapes)
...
                 |Net: QB
      sky130_fd_pr__nfet_01v8/4 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                               |
    Net: a_583_772#                            |Net: WL
      sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/2 = 2
                                               |
    Net: a_500_772#                            |Net: VSS
      sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/4 = 4
                                               |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: a_553_746#                            |Net: VDD
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__pfet_01v8/4 = 2
                                               |
    Net: w_284_736#                            |(no matching net)
      sky130_fd_pr__pfet_01v8/4 = 1            |
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    Net: a_140_180#                            |Net: BLB
      sky130_fd_pr__nfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |
    Net: a_223_180#                            |Net: BL
      sky130_fd_pr__nfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.sky130A/a3/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.sky130A/a3/sram16x8.extracted.spice
result: VIOLATIONS   (12.3 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.sky130A/a3/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.sky130A/a3/sram16x8.png