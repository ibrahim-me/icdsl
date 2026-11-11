Judge:
  FAIL DRC      1536 violation(s): 1536 x Active spacing < 80nm (ACTIVE.2)
  FAIL DRC2     foundry KLayout deck: 232 violation(s): 112 x WELL.3: WELL.3 : Minimum spacing of pwell at same potential : 135nm; 112 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm; 4 x ACTIVE.2: ACTIVE.2 : Minimum spacing of active : 80nm; 4 x IMPLANT.4: IMPLANT.4 : Minimum spacing of nimplant/ pimplant  : 45nm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 10/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.freepdk45/a4/judge/sram16x8.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  ok   area     12.34 x 23.55 = 290.7 um2, budget 592, reference 295.8

Tool report:
sram16x8 on freepdk45: 12.34 x 23.555 um (290.67 um2), 11460 shapes, 768 declared devices
connectivity pre-check: 1 short(s), 272 open net(s)
  SHORT BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB5 = BLB6 = BLB7 = VDD = VSS = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9 = XB0_0/Q = XB0_0/QB = XB0_1/Q = XB0_1/QB = XB0_2/Q = XB0_2/QB = XB0_3/Q = XB0_3/QB = XB0_4/Q = XB0_4/QB = XB0_5/Q = XB0_5/QB = XB0_6/Q = XB0_6/QB = XB0_7/Q = XB0_7/QB = XB10_0/Q = XB10_0/QB = XB10_1/Q = XB10_1/QB = XB10_2/Q = XB10_2/QB = XB10_3/Q = XB10_3/QB = XB10_4/Q = XB10_4/QB = XB10_5/Q = XB10_5/QB = XB10_6/Q = XB10_6/QB = XB10_7/Q = XB10_7/QB = XB11_0/Q = XB11_0/QB = XB11_1/Q = XB11_1/QB = XB11_2/Q = XB11_2/QB = XB11_3/Q = XB11_3/QB = XB11_4/Q = XB11_4/QB = XB11_5/Q = XB11_5/QB = XB11_6/Q = XB11_6/QB = XB11_7/Q = XB11_7/QB = XB12_0/Q = XB12_0/QB = XB12_1/Q = XB12_1/QB = XB12_2/Q = XB12_2/QB = XB12_3/Q = XB12_3/QB = XB12_4/Q = XB12_4/QB = XB12_5/Q = XB12_5/QB = XB12_6/Q = XB12_6/QB = XB12_7/Q = XB12_7/QB = XB13_0/Q = XB13_0/QB = XB13_1/Q = XB13_1/QB = XB13_2/Q = XB13_2/QB = XB13_3/Q = XB13_3/QB = XB13_4/Q = XB13_4/QB = XB13_5/Q = XB13_5/QB = XB13_6/Q = XB13_6/QB = XB13_7/Q = XB13_7/QB = XB14_0/Q = XB14_0/QB = XB14_1/Q = XB14_1/QB = XB14_2/Q = XB14_2/QB = XB14_3/Q = XB14_3/QB = XB14_4/Q = XB14_4/QB = XB14_5/Q = XB14_5/QB = XB14_6/Q = XB14_6/QB = XB14_7/Q = XB14_7/QB = XB15_0/Q = XB15_0/QB = XB15_1/Q = XB15_1/QB = XB15_2/Q = XB15_2/QB = XB15_3/Q = XB15_3/QB = XB15_4/Q = XB15_4/QB = XB15_5/Q = XB15_5/QB = XB15_6/Q = XB15_6/QB = XB15_7/Q = XB15_7/QB = XB1_0/Q = XB1_0/QB = XB1_1/Q = XB1_1/QB = XB1_2/Q = XB1_2/QB = XB1_3/Q = XB1_3/QB = XB1_4/Q = XB1_4/QB = XB1_5/Q = XB1_5/QB = XB1_6/Q = XB1_6/QB = XB1_7/Q = XB1_7/QB = XB2_0/Q = XB2_0/QB = XB2_1/Q = XB2_1/QB = XB2_2/Q = XB2_2/QB = XB2_3/Q = XB2_3/QB = XB2_4/Q = XB2_4/QB = XB2_5/Q = XB2_5/QB = XB2_6/Q = XB2_6/QB = XB2_7/Q = XB2_7/QB = XB3_0/Q = XB3_0/QB = XB3_1/Q = XB3_1/QB = XB3_2/Q = XB3_2/QB = XB3_3/Q = XB3_3/QB = XB3_4/Q = XB3_4/QB = XB3_5/Q = XB3_5/QB = XB3_6/Q = XB3_6/QB = XB3_7/Q = XB3_7/QB = XB4_0/Q = XB4_0/QB = XB4_1/Q = XB4_1/QB = XB4_2/Q = XB4_2/QB = XB4_3/Q = XB4_3/QB = XB4_4/Q = XB4_4/QB = XB4_5/Q = XB4_5/QB = XB4_6/Q = XB4_6/QB = XB4_7/Q = XB4_7/QB = XB5_0/Q = XB5_0/QB = XB5_1/Q = XB5_1/QB = XB5_2/Q = XB5_2/QB = XB5_3/Q = XB5_3/QB = XB5_4/Q = XB5_4/QB = XB5_5/Q = XB5_5/QB = XB5_6/Q = XB5_6/QB = XB5_7/Q = XB5_7/QB = XB6_0/Q = XB6_0/QB = XB6_1/Q = XB6_1/QB = XB6_2/Q = XB6_2/QB = XB6_3/Q = XB6_3/QB = XB6_4/Q = XB6_4/QB = XB6_5/Q = XB6_5/QB = XB6_6/Q = XB6_6/QB = XB6_7/Q = XB6_7/QB = XB7_0/Q = XB7_0/QB = XB7_1/Q = XB7_1/QB = XB7_2/Q = XB7_2/QB = XB7_3/Q = XB7_3/QB = XB7_4/Q = XB7_4/QB = XB7_5/Q = XB7_5/QB = XB7_6/Q = XB7_6/QB = XB7_7/Q = XB7_7/QB = XB8_0/Q = XB8_0/QB = XB8_1/Q = XB8_1/QB = XB8_2/Q = XB8_2/QB = XB8_3/Q = XB8_3/QB = XB8_4/Q = XB8_4/QB = XB8_5/Q = XB8_5/QB = XB8_6/Q = XB8_6/QB = XB8_7/Q = XB8_7/QB = XB9_0/Q = XB9_0/QB = XB9_1/Q = XB9_1/QB = XB9_2/Q = XB9_2/QB = XB9_3/Q = XB9_3/QB = XB9_4/Q = XB9_4/QB = XB9_5/Q = XB9_5/QB = XB9_6/Q = XB9_6/QB = XB9_7/Q = XB9_7/QB
      m2 (1.060, 11.518) [sub.py:93]
      via1 (1.060, 0.340) [sub.py:95]
      m1 (0.983, 0.715) in XB0_0 [sub.py:40]
      m1 (6.105, 0.630) [sub.py:104]
      m1 (2.533, 0.715) in XB0_1 [sub.py:40]
      via1 (2.610, 0.340) [sub.py:95]
      m2 (2.610, 11.518) [sub.py:93]
  OPEN  net WL0 is in 17 unconnected pieces:
      m1 (6.105, 0.630) [sub.py:104] (9422 shapes)
      poly (0.135, 0.345) in XB0_0 [sub.py:14] (1 shapes)
      poly (1.155, 0.345) in XB0_0 [sub.py:17] (1 shapes)
      poly (1.685, 0.345) in XB0_1 [sub.py:14] (1 shapes)
      poly (2.705, 0.345) in XB0_1 [sub.py:17] (1 shapes)
  OPEN  net WL1 is in 17 unconnected pieces:
      m1 (6.105, 2.120) [sub.py:104] (9422 shapes)
      poly (0.135, 1.835) in XB1_0 [sub.py:14] (1 shapes)
      poly (1.155, 1.835) in XB1_0 [sub.py:17] (1 shapes)
      poly (1.685, 1.835) in XB1_1 [sub.py:14] (1 shapes)
      poly (2.705, 1.835) in XB1_1 [sub.py:17] (1 shapes)
  OPEN  net WL10 is in 17 unconnected pieces:
      m1 (6.105, 15.530) [sub.py:104] (9422 shapes)
      poly (0.135, 15.245) in XB10_0 [sub.py:14] (1 shapes)
      poly (1.155, 15.245) in XB10_0 [sub.py:17] (1 shapes)
      poly (1.685, 15.245) in XB10_1 [sub.py:14] (1 shapes)
      poly (2.705, 15.245) in XB10_1 [sub.py:17] (1 shapes)
  OPEN  net WL11 is in 17 unconnected pieces:
      m1 (6.105, 17.020) [sub.py:104] (9422 shapes)
      poly (0.135, 16.735) in
...
                                  |
    Net: a_22_49#                              |Net: QB
      nmos/gate = 1                            |  nmos/gate = 1
                                               |  nmos/(drain|source) = 2
                                               |  pmos/gate = 1
                                               |  pmos/(drain|source) = 1
                                               |
    Net: BL                                    |Net: BL
      nmos/(drain|source) = 1                  |  nmos/(drain|source) = 1
                                               |
    Net: a_226_49#                             |Net: BLB
      nmos/gate = 1                            |  nmos/(drain|source) = 1
                                               |
    Net: a_90_189#                             |Net: VSS
      pmos/gate = 1                            |  nmos/bulk = 4
                                               |  nmos/(drain|source) = 2
                                               |
    Net: w_48_180#                             |Net: VDD
      pmos/bulk = 1                            |  pmos/(drain|source) = 2
                                               |  pmos/bulk = 2
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    Net: w_n1073741817_n1073741817#            |Net: WL
      nmos/bulk = 2                            |  nmos/gate = 2
    ---------------------------------------------------------------------------------------
    DEVICE mismatches: Class fragments follow (with node fanout counts):
    Circuit 1: sram6t                          |Circuit 2: sram6t
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.freepdk45/a4/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.freepdk45/a4/sram16x8.extracted.spice
result: VIOLATIONS   (7.2 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.freepdk45/a4/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.freepdk45/a4/sram16x8.png