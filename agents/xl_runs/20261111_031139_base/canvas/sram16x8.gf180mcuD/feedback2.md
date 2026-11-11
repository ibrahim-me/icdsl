Judge:
  FAIL DRC      18560 violation(s): 4480 x Varactor length and width < 1um (DF.1c); 2176 x N-Diffusion overlap of contact < 0.065um (CO.4); 2048 x Diffusion spacing < 0.28um (DF.3a); 2048 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6); 1408 x Metal2 spacing < 0.28um (M2.2a); 1280 x Via2 spacing < 0.24um (V2.2a - 2 * V2.3)
  FAIL DRC2     foundry KLayout deck: 8320 violation(s): 768 x DF.11: DF.11 : Min. Length of butting COMP edge. : 0.3µm; 640 x V1.2a: V1.2a : min. via1 spacing : 0.26µm; 640 x V2.2a: V2.2a : min. via2 spacing : 0.26µm; 640 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 512 x DF.3b: DF.3b : Min./Max. NCOMP Space to PCOMP in the same well for butted COMP
           ; 512 x NP.3d: NP.3d : Min/max space to a butted PCOMP: 0um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.gf180mcuD/a2/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     58.28 x 79.20 = 4615.8 um2, budget 7253, reference 3626.29

Tool report:
sram16x8 on gf180mcuD: 58.28 x 79.2 um (4615.78 um2), 21382 shapes, 768 declared devices
connectivity pre-check: 385 short(s), 272 open net(s)
  SHORT BL = BL0 = BL1 = BL2 = BL3 = BL4 = BL5 = BL6 = BL7 = BLB = BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB5 = BLB6 = BLB7 = VDD = VSS = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9 = XB0_0/Q = XB0_0/QB = XB0_1/Q = XB0_1/QB = XB0_2/Q = XB0_2/QB = XB0_3/Q = XB0_3/QB = XB0_4/Q = XB0_4/QB = XB0_5/Q = XB0_5/QB = XB0_6/Q = XB0_6/QB = XB0_7/Q = XB0_7/QB = XB10_0/Q = XB10_0/QB = XB10_1/Q = XB10_1/QB = XB10_2/Q = XB10_2/QB = XB10_3/Q = XB10_3/QB = XB10_4/Q = XB10_4/QB = XB10_5/Q = XB10_5/QB = XB10_6/Q = XB10_6/QB = XB10_7/Q = XB10_7/QB = XB11_0/Q = XB11_0/QB = XB11_1/Q = XB11_1/QB = XB11_2/Q = XB11_2/QB = XB11_3/Q = XB11_3/QB = XB11_4/Q = XB11_4/QB = XB11_5/Q = XB11_5/QB = XB11_6/Q = XB11_6/QB = XB11_7/Q = XB11_7/QB = XB12_0/Q = XB12_0/QB = XB12_1/Q = XB12_1/QB = XB12_2/Q = XB12_2/QB = XB12_3/Q = XB12_3/QB = XB12_4/Q = XB12_4/QB = XB12_5/Q = XB12_5/QB = XB12_6/Q = XB12_6/QB = XB12_7/Q = XB12_7/QB = XB13_0/Q = XB13_0/QB = XB13_1/Q = XB13_1/QB = XB13_2/Q = XB13_2/QB = XB13_3/Q = XB13_3/QB = XB13_4/Q = XB13_4/QB = XB13_5/Q = XB13_5/QB = XB13_6/Q = XB13_6/QB = XB13_7/Q = XB13_7/QB = XB14_0/Q = XB14_0/QB = XB14_1/Q = XB14_1/QB = XB14_2/Q = XB14_2/QB = XB14_3/Q = XB14_3/QB = XB14_4/Q = XB14_4/QB = XB14_5/Q = XB14_5/QB = XB14_6/Q = XB14_6/QB = XB14_7/Q = XB14_7/QB = XB15_0/Q = XB15_0/QB = XB15_1/Q = XB15_1/QB = XB15_2/Q = XB15_2/QB = XB15_3/Q = XB15_3/QB = XB15_4/Q = XB15_4/QB = XB15_5/Q = XB15_5/QB = XB15_6/Q = XB15_6/QB = XB15_7/Q = XB15_7/QB = XB1_0/Q = XB1_0/QB = XB1_1/Q = XB1_1/QB = XB1_2/Q = XB1_2/QB = XB1_3/Q = XB1_3/QB = XB1_4/Q = XB1_4/QB = XB1_5/Q = XB1_5/QB = XB1_6/Q = XB1_6/QB = XB1_7/Q = XB1_7/QB = XB2_0/Q = XB2_0/QB = XB2_1/Q = XB2_1/QB = XB2_2/Q = XB2_2/QB = XB2_3/Q = XB2_3/QB = XB2_4/Q = XB2_4/QB = XB2_5/Q = XB2_5/QB = XB2_6/Q = XB2_6/QB = XB2_7/Q = XB2_7/QB = XB3_0/Q = XB3_0/QB = XB3_1/Q = XB3_1/QB = XB3_2/Q = XB3_2/QB = XB3_3/Q = XB3_3/QB = XB3_4/Q = XB3_4/QB = XB3_5/Q = XB3_5/QB = XB3_6/Q = XB3_6/QB = XB3_7/Q = XB3_7/QB = XB4_0/Q = XB4_0/QB = XB4_1/Q = XB4_1/QB = XB4_2/Q = XB4_2/QB = XB4_3/Q = XB4_3/QB = XB4_4/Q = XB4_4/QB = XB4_5/Q = XB4_5/QB = XB4_6/Q = XB4_6/QB = XB4_7/Q = XB4_7/QB = XB5_0/Q = XB5_0/QB = XB5_1/Q = XB5_1/QB = XB5_2/Q = XB5_2/QB = XB5_3/Q = XB5_3/QB = XB5_4/Q = XB5_4/QB = XB5_5/Q = XB5_5/QB = XB5_6/Q = XB5_6/QB = XB5_7/Q = XB5_7/QB = XB6_0/Q = XB6_0/QB = XB6_1/Q = XB6_1/QB = XB6_2/Q = XB6_2/QB = XB6_3/Q = XB6_3/QB = XB6_4/Q = XB6_4/QB = XB6_5/Q = XB6_5/QB = XB6_6/Q = XB6_6/QB = XB6_7/Q = XB6_7/QB = XB7_0/Q = XB7_0/QB = XB7_1/Q = XB7_1/QB = XB7_2/Q = XB7_2/QB = XB7_3/Q = XB7_3/QB = XB7_4/Q = XB7_4/QB = XB7_5/Q = XB7_5/QB = XB7_6/Q = XB7_6/QB = XB7_7/Q = XB7_7/QB = XB8_0/Q = XB8_0/QB = XB8_1/Q = XB8_1/QB = XB8_2/Q = XB8_2/QB = XB8_3/Q = XB8_3/QB = XB8_4/Q = XB8_4/QB = XB8_5/Q = XB8_5/QB = XB8_6/Q = XB8_6/QB = XB8_7/Q = XB8_7/QB = XB9_0/Q = XB9_0/QB = XB9_1/Q = XB9_1/QB = XB9_2/Q = XB9_2/QB = XB9_3/Q = XB9_3/QB = XB9_4/Q = XB9_4/QB = XB9_5/Q = XB9_5/QB = XB9_6/Q = XB9_6/QB = XB9_7/Q = XB9_7/QB
      m3 (2.095, 0.230) [sub.py:133]
      m3 (2.095, 0.230) in XB0_0 [sub.py:61]
  SHORT XB0_0/Q = XB0_0/QB
      m1 (5.595, 0.180) in XB0_0 [sub.py:50]
      m1 (5.595, 0.180) in XB0_0 [sub.py:50]
  SHORT XB0_0/Q = XB0_0/QB
      poly (3.935, 0.360) in XB0_0 [sub.py:50]
      poly (3.935, 0.360) in XB0_0 [sub.py:50]
  SHORT XB0_0/Q = XB0_0/QB
      poly (5.195, 0.180) in XB0_0 [sub.py:50]
      poly (5.195, 0.180) in XB0_0 [sub.py:50]
  SHORT XB0_1/Q = XB0_1/QB
      m1 (12.730, 0.180) in XB0_1 [sub.py:50]
      m1 (12.730, 0.180) in XB0_1 [sub.py:50]
  SHORT XB0_1/Q = XB0_1/QB
      poly (11.070, 0.360) in XB0_1 [sub.py:50]
      poly (11.070, 0.360) in XB0_1 [sub.py:50]
  SHORT XB0_1/Q = XB0_1/QB
      poly (12.330, 0.180) in XB0_1 [sub.py:50]
      poly (12.330, 0.180) in XB0_1 [sub.py:50]
  SHORT XB0_2/Q = XB0_2/QB
      m1 (19.865, 0.180) in XB0_2 [sub.py:50]
      m1 (19.865, 0.180) in XB0_2 [sub.py:50]
  SHORT XB0_2/Q = XB0_2/QB
      poly (18.205, 0.360) in XB0_2 [sub.py:50]
      poly (18.205, 0.360) in XB0_2 [sub.py:50]
  SHORT XB0_2/Q = XB0_2/QB
      poly (19.465, 0.180) in XB0_2 [sub.py:50]
      poly (19.465, 0.180) in XB0_2 [sub.py:50]
  SHORT XB0_3/Q = XB0_3/QB
      m1 (27.000, 0.180) in XB0_3 [sub.py:50]
      m1 (27.000, 0.180) in XB0_3 [sub.py:50]
  SHORT XB0_3/Q = XB0_3/QB
      poly (25.340, 0
...
                            |  pfet_03v3/2 = 1
                                               |
    (no matching net)                          |Net: QB
                                               |  nfet_03v3/2 = 1
                                               |  nfet_03v3/(1|3) = 2
                                               |  pfet_03v3/2 = 1
                                               |  pfet_03v3/(1|3) = 1
                                               |
    (no matching net)                          |Net: WL
                                               |  nfet_03v3/2 = 2
                                               |
    (no matching net)                          |Net: VSS
                                               |  nfet_03v3/4 = 4
                                               |  nfet_03v3/(1|3) = 2
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    Net: BL                                    |Net: VDD
      pfet_03v3/(1|3) = 2                      |  pfet_03v3/(1|3) = 2
      pfet_03v3/4 = 1                          |  pfet_03v3/4 = 2
      cap_nmos_03v3_b/2 = 1                    |
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    Net: a_759_n44#                            |Net: BLB
      pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                               |
    Net: a_1011_n44#                           |Net: BL
      cap_nmos_03v3_b/1 = 1                    |  nfet_03v3/(1|3) = 1
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.gf180mcuD/a2/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.gf180mcuD/a2/sram16x8.extracted.spice
result: VIOLATIONS   (40.3 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.gf180mcuD/a2/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/sram16x8.gf180mcuD/a2/sram16x8.png