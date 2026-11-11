Judge:
  FAIL DRC      16032 violation(s): 6400 x N-well overlap of P-Diffusion < 0.43um (DF.7); 3168 x Metal1 spacing < 0.23um (M1.2a); 2560 x N-Diffusion overlap of contact < 0.065um (CO.4); 1536 x Poly overhang of transistor < 0.22um (PL.4); 768 x Diffusion spacing < 0.28um (DF.3a); 768 x Varactor length and width < 1um (DF.1c)
  FAIL DRC2     foundry KLayout deck: 5120 violation(s): 2256 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 512 x CO.11: CO.11 : Contact on field oxide is forbidden; 512 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 384 x DF.3a_LV: DF.3a_LV : Min. COMP Space is : 0.28µm. [P-substrate tap (PCOMP outside NWELL an; 256 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm; 256 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwe
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 768/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/sram16x8.gf180mcuD/a4/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     84.52 x 96.60 = 8164.6 um2, budget 7253, reference 3626.29

Tool report:
sram16x8 on gf180mcuD: 84.52 x 96.6 um (8164.63 um2), 13380 shapes, 768 declared devices
connectivity pre-check: 272 short(s), 290 open net(s)
  SHORT BL0 = BL1 = BL2 = BL3 = BL4 = BL6 = BLB0 = BLB1 = BLB2 = BLB3 = BLB4 = BLB6 = WL0 = WL1 = WL10 = WL11 = WL12 = WL13 = WL14 = WL15 = WL2 = WL3 = WL4 = WL5 = WL6 = WL7 = WL8 = WL9
      m3 (0.980, 48.000) [sub.py:135]
      m3 (22.400, 3.000) [sub.py:123]
      m3 (12.180, 48.000) [sub.py:135]
  SHORT VDD = VSS
      m1 (2.800, 5.885) in XB0_0 [sub.py:29]
      m1 (2.800, 6.115) in XB1_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 11.885) in XB1_0 [sub.py:29]
      m1 (2.800, 12.115) in XB2_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 17.885) in XB2_0 [sub.py:29]
      m1 (2.800, 18.115) in XB3_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 23.885) in XB3_0 [sub.py:29]
      m1 (2.800, 24.115) in XB4_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 29.885) in XB4_0 [sub.py:29]
      m1 (2.800, 30.115) in XB5_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 35.885) in XB5_0 [sub.py:29]
      m1 (2.800, 36.115) in XB6_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 41.885) in XB6_0 [sub.py:29]
      m1 (2.800, 42.115) in XB7_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 47.885) in XB7_0 [sub.py:29]
      m1 (2.800, 48.115) in XB8_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 53.885) in XB8_0 [sub.py:29]
      m1 (2.800, 54.115) in XB9_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 59.885) in XB9_0 [sub.py:29]
      m1 (2.800, 60.115) in XB10_0 [sub.py:28]
  SHORT VDD = VSS
      m1 (2.800, 65.885) in XB10_0 [sub.py:29]
      m1 (2.800, 66.115) in XB11_0 [sub.py:28]
  OPEN  net VDD is in 272 unconnected pieces:
      m1 (2.800, 95.850) [sub.py:149] (451 shapes)
      m1 (2.800, 5.885) in XB0_0 [sub.py:29] (128 shapes)
      m1 (2.800, 11.885) in XB1_0 [sub.py:29] (128 shapes)
      m1 (2.800, 17.885) in XB2_0 [sub.py:29] (128 shapes)
      m1 (2.800, 23.885) in XB3_0 [sub.py:29] (128 shapes)
  OPEN  net VSS is in 272 unconnected pieces:
      m1 (2.800, 0.150) [sub.py:148] (451 shapes)
      m1 (2.800, 6.115) in XB1_0 [sub.py:28] (128 shapes)
      m1 (2.800, 12.115) in XB2_0 [sub.py:28] (128 shapes)
      m1 (2.800, 18.115) in XB3_0 [sub.py:28] (128 shapes)
      m1 (2.800, 24.115) in XB4_0 [sub.py:28] (128 shapes)
  OPEN  net BL1 is in 33 unconnected pieces:
      m3 (12.180, 48.000) [sub.py:135] (1608 shapes)
      m1 (6.580, 1.680) in XB0_1 [sub.py:36] (6 shapes)
      m1 (6.580, 7.680) in XB1_1 [sub.py:36] (6 shapes)
      m1 (6.580, 13.680) in XB2_1 [sub.py:36] (6 shapes)
      m1 (6.580, 19.680) in XB3_1 [sub.py:36] (6 shapes)
  OPEN  net BL3 is in 33 unconnected pieces:
      m3 (34.580, 48.000) [sub.py:135] (1608 shapes)
      m1 (17.780, 1.680) in XB0_3 [sub.py:36] (6 shapes)
      m1 (17.780, 7.680) in XB1_3 [sub.py:36] (6 shapes)
      m1 (17.780, 13.680) in XB2_3 [sub.py:36] (6 shapes)
      m1 (17.780, 19.680) in XB3_3 [sub.py:36] (6 shapes)
  OPEN  net BL5 is in 33 unconnected pieces:
      m3 (56.980, 48.000) [sub.py:135] (83 shapes)
      m1 (28.980, 1.680) in XB0_5 [sub.py:36] (6 shapes)
      m1 (28.980, 7.680) in XB1_5 [sub.py:36] (6 shapes)
      m1 (28.980, 13.680) in XB2_5 [sub.py:36] (6 shapes)
      m1 (28.980, 19.680) in XB3_5 [sub.py:36] (6 shapes)
  OPEN  net BL7 is in 33 unconnected pieces:
      m3 (79.380, 48.000) [sub.py:135] (83 shapes)
      m1 (40.180, 1.680) in XB0_7 [sub.py:36] (6 shapes)
      m1 (40.180, 7.680) in XB1_7 [sub.py:36] (6 shapes)
      m1 (40.180, 13.680) in XB2_7 [sub.py:36] (6 shapes)
      m1 (40.180, 19.680) in XB3_7 [sub.py:36] (6 shapes)
  OPEN  net BLB1 is in 33 unconnected pieces:
      m3 (16.880, 48.000) [sub.py:136] (1608 shapes)
      m1 (11.280, 1.680) in XB0_1 [sub.py:39] (6 shapes)
      m1 (11.280, 7.680) in XB1_1 [sub.py:39] (6 shapes)
      m1 (11.280, 13.680) in XB2_1 [sub.py:39] (6 shapes)
      m1 (11.280, 19.680) in XB3_1 [sub.py:39] (6 shapes)
  OPEN  net BLB3 is in 33 unconnected pieces:
      m3 (39.280, 48.000) [sub.py:136] (1608 shapes)
      m1 (22.480, 1.680) in XB0_3 [sub.py:39] (6 shapes)
      m1 (22.480, 7.680) in XB1_3 [sub.py:39] (6 shapes)
      m1 (22.480, 13.680) in XB2_3 [sub.py:39] (6 shapes)
      m1 (22.480, 19.680) in XB3_3 [sub.py:39] (6 shapes)
  OPEN  net BLB5 is in 33 unconnected pieces:
      m3 (61.680, 48.000) [sub.py:136] (83 shapes)
      m1 (33.680, 1.680) in XB0_5 [sub.py:39] (6 shapes)
      m1 (33.680, 7.680) in XB1_5 [sub.py:39] (6 shapes)
      m1 
...
t_03v3/2 = 1                          |  nfet_03v3/2 = 2
                                               |
    Net: a_368_712#                            |Net: Q
      pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 2
                                               |  nfet_03v3/2 = 1
                                               |  pfet_03v3/(1|3) = 1
                                               |  pfet_03v3/2 = 1
                                               |
    Net: a_928_712#                            |Net: QB
      pfet_03v3/2 = 1                          |  nfet_03v3/2 = 1
                                               |  nfet_03v3/(1|3) = 2
                                               |  pfet_03v3/2 = 1
                                               |  pfet_03v3/(1|3) = 1
                                               |
    Net: VSUBS                                 |Net: VSS
      nfet_03v3/4 = 4                          |  nfet_03v3/4 = 4
                                               |  nfet_03v3/(1|3) = 2
                                               |
    Net: a_768_256#                            |(no matching net)
      nfet_03v3/2 = 1                          |
                                               |
    Net: a_508_256#                            |(no matching net)
      nfet_03v3/2 = 1                          |
                                               |
    Net: w_n60_624#                            |(no matching net)
      pfet_03v3/4 = 2                          |
                                               |
    Net: a_564_300#                            |(no matching net)
      nfet_03v3/(1|3) = 2                      |
                                               |
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/sram16x8.gf180mcuD/a4/sram16x8.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/sram16x8.gf180mcuD/a4/sram16x8.extracted.spice
result: VIOLATIONS   (13.5 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/sram16x8.gf180mcuD/a4/sram16x8.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_130341_v2/canvas/sram16x8.gf180mcuD/a4/sram16x8.png