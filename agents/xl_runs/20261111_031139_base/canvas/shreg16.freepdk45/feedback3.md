Judge:
  FAIL DRC      87 violation(s): 87 x Metal1 > 270nm and runlength > 300nm spacing to unrelated m1 < 270nm (METAL1.6)
  FAIL DRC2     foundry KLayout deck: 57 violation(s): 28 x METAL1.8: METAL1.8 : Minimum spacing of metal1 wider than 900 nm and longer than 2.7 um : ; 14 x METAL1.7: METAL1.7 : Minimum spacing of metal1 wider than 500 nm and longer than 1.8 um : ; 8 x WELL.4: WELL.4 : Minimum width of nwell/pwell : 200nm; 7 x METAL1.6: METAL1.6 : Minimum spacing of metal1 wider than 270 nm and longer than 900 nm : 
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 2/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.freepdk45/a3/judge/shreg16.lvs.txt)
  FAIL pins     top-level pin names differ from the task netlist
  FAIL area     26.33 x 13.82 = 363.9 um2, budget 261, reference 130.23

Tool report:
shreg16 on freepdk45: 26.33 x 13.82 um (363.88 um2), 3602 shapes, 352 declared devices
connectivity pre-check: 1 short(s), 97 open net(s)
  SHORT CK = D = D0 = D1 = D10 = D11 = D12 = D13 = D14 = D15 = D2 = D3 = D4 = D5 = D6 = D7 = D8 = D9 = FF0/CKB = FF0/m = FF0/mb = FF0/n1 = FF0/n2 = FF0/n3 = FF0/n4 = FF0/p1 = FF0/p2 = FF0/p3 = FF0/p4 = FF0/s = FF1/CKB = FF1/m = FF1/mb = FF1/n1 = FF1/n2 = FF1/n3 = FF1/n4 = FF1/p1 = FF1/p2 = FF1/p3 = FF1/p4 = FF1/s = FF10/CKB = FF10/m = FF10/mb = FF10/n1 = FF10/n2 = FF10/n3 = FF10/n4 = FF10/p1 = FF10/p2 = FF10/p3 = FF10/p4 = FF10/s = FF11/CKB = FF11/m = FF11/mb = FF11/n1 = FF11/n2 = FF11/n3 = FF11/n4 = FF11/p1 = FF11/p2 = FF11/p3 = FF11/p4 = FF11/s = FF12/CKB = FF12/m = FF12/mb = FF12/n1 = FF12/n2 = FF12/n3 = FF12/n4 = FF12/p1 = FF12/p2 = FF12/p3 = FF12/p4 = FF12/s = FF13/CKB = FF13/m = FF13/mb = FF13/n1 = FF13/n2 = FF13/n3 = FF13/n4 = FF13/p1 = FF13/p2 = FF13/p3 = FF13/p4 = FF13/s = FF14/CKB = FF14/m = FF14/mb = FF14/n1 = FF14/n2 = FF14/n3 = FF14/n4 = FF14/p1 = FF14/p2 = FF14/p3 = FF14/p4 = FF14/s = FF15/CKB = FF15/m = FF15/mb = FF15/n1 = FF15/n2 = FF15/n3 = FF15/n4 = FF15/p1 = FF15/p2 = FF15/p3 = FF15/p4 = FF15/s = FF2/CKB = FF2/m = FF2/mb = FF2/n1 = FF2/n2 = FF2/n3 = FF2/n4 = FF2/p1 = FF2/p2 = FF2/p3 = FF2/p4 = FF2/s = FF3/CKB = FF3/m = FF3/mb = FF3/n1 = FF3/n2 = FF3/n3 = FF3/n4 = FF3/p1 = FF3/p2 = FF3/p3 = FF3/p4 = FF3/s = FF4/CKB = FF4/m = FF4/mb = FF4/n1 = FF4/n2 = FF4/n3 = FF4/n4 = FF4/p1 = FF4/p2 = FF4/p3 = FF4/p4 = FF4/s = FF5/CKB = FF5/m = FF5/mb = FF5/n1 = FF5/n2 = FF5/n3 = FF5/n4 = FF5/p1 = FF5/p2 = FF5/p3 = FF5/p4 = FF5/s = FF6/CKB = FF6/m = FF6/mb = FF6/n1 = FF6/n2 = FF6/n3 = FF6/n4 = FF6/p1 = FF6/p2 = FF6/p3 = FF6/p4 = FF6/s = FF7/CKB = FF7/m = FF7/mb = FF7/n1 = FF7/n2 = FF7/n3 = FF7/n4 = FF7/p1 = FF7/p2 = FF7/p3 = FF7/p4 = FF7/s = FF8/CKB = FF8/m = FF8/mb = FF8/n1 = FF8/n2 = FF8/n3 = FF8/n4 = FF8/p1 = FF8/p2 = FF8/p3 = FF8/p4 = FF8/s = FF9/CKB = FF9/m = FF9/mb = FF9/n1 = FF9/n2 = FF9/n3 = FF9/n4 = FF9/p1 = FF9/p2 = FF9/p3 = FF9/p4 = FF9/s = Q0 = Q1 = Q10 = Q11 = Q12 = Q13 = Q14 = Q15 = Q2 = Q3 = Q4 = Q5 = Q6 = Q7 = Q8 = Q9 = VDD = VSS = ch0 = ch1 = ch10 = ch11 = ch12 = ch13 = ch14 = ch2 = ch3 = ch4 = ch5 = ch6 = ch7 = ch8 = ch9
      m1 (12.873, 3.100) [sub.py:154]
      m1 (2.360, 3.255) [sub.py:141]
      m1 (2.360, 1.235) in FF1 [sub.py:82]
      m1 (12.640, -0.090) [sub.py:144]
      m1 (0.407, 0.043) in FF0 [sub.py:12]
      m1 (0.240, 0.130) [sub.py:159]
      m1 (-0.300, 0.130) [sub.py:157]
  OPEN  net CK is in 114 unconnected pieces:
      m1 (12.873, 3.100) [sub.py:154] (2964 shapes)
      m2 (25.280, 6.730) [sub.py:151] (2 shapes)
      m2 (0.415, 3.100) in FF0 [sub.py:90] (2 shapes)
      m2 (1.995, 3.100) in FF1 [sub.py:90] (2 shapes)
      m2 (3.575, 3.100) in FF2 [sub.py:90] (2 shapes)
  OPEN  net FF0/CKB is in 5 unconnected pieces:
      m1 (0.407, 0.662) in FF0 [sub.py:12] (2964 shapes)
      poly (0.505, 1.285) in FF0 [sub.py:12] (1 shapes)
      poly (1.145, 1.950) in FF0 [sub.py:16] (1 shapes)
      poly (0.505, 3.765) in FF0 [sub.py:12] (1 shapes)
      poly (1.145, 4.430) in FF0 [sub.py:16] (1 shapes)
  OPEN  net FF0/mb is in 5 unconnected pieces:
      m1 (0.598, 3.143) in FF0 [sub.py:12] (2964 shapes)
      poly (0.505, 2.525) in FF0 [sub.py:12] (1 shapes)
      poly (1.145, 2.570) in FF0 [sub.py:16] (1 shapes)
      poly (0.505, 5.005) in FF0 [sub.py:12] (1 shapes)
      poly (1.145, 5.050) in FF0 [sub.py:16] (1 shapes)
  OPEN  net FF1/CKB is in 5 unconnected pieces:
      m1 (1.988, 0.662) in FF1 [sub.py:12] (2964 shapes)
      poly (2.085, 1.285) in FF1 [sub.py:12] (1 shapes)
      poly (2.725, 1.950) in FF1 [sub.py:16] (1 shapes)
      poly (2.085, 3.765) in FF1 [sub.py:12] (1 shapes)
      poly (2.725, 4.430) in FF1 [sub.py:16] (1 shapes)
  OPEN  net FF1/mb is in 5 unconnected pieces:
      m1 (2.178, 3.143) in FF1 [sub.py:12] (2964 shapes)
      poly (2.085, 2.525) in FF1 [sub.py:12] (1 shapes)
      poly (2.725, 2.570) in FF1 [sub.py:16] (1 shapes)
      poly (2.085, 5.005) in FF1 [sub.py:12] (1 shapes)
      poly (2.725, 5.050) in FF1 [sub.py:16] (1 shapes)
  OPEN  net FF10/CKB is in 5 unconnected pieces:
      m1 (8.307, 7.303) in FF10 [sub.py:12] (2964 shapes)
      poly (8.405, 7.925) in FF10 [sub.py:12] (1 shapes)
      poly (9.045, 8.590) in FF10 [sub.py:16] (1 shapes)
      poly (8.405, 10.405) in FF10 [sub.py:12] (1 shapes)
      poly (9.045, 11.070) in FF10 [sub.py:16] (1 shapes)
  OPEN  net FF10/mb is in 5 unconnected pieces:
  
...
      |
    Net: w_173_237#                            |Net: VDD
      pmos/bulk = 1                            |  pmos/(drain|source) = 7
                                               |  pmos/bulk = 11
                                               |
    Net: a_78_1229#                            |Net: CK
      nmos/gate = 1                            |  nmos/gate = 3
                                               |  pmos/gate = 3
                                               |
    Net: w_n1073741817_n1073741817#            |Net: CKB
      nmos/bulk = 1                            |  nmos/(drain|source) = 1
                                               |  nmos/gate = 2
                                               |  pmos/(drain|source) = 1
                                               |  pmos/gate = 2
                                               |
    (no matching net)                          |Net: mb
                                               |  nmos/gate = 2
                                               |  nmos/(drain|source) = 1
                                               |  pmos/gate = 2
                                               |  pmos/(drain|source) = 1
                                               |
    (no matching net)                          |Net: m
                                               |  nmos/(drain|source) = 2
                                               |  nmos/gate = 1
                                               |  pmos/(drain|source) = 2
                                               |  pmos/gate = 1
                                               |
    (no matching net)                          |Net: s
                                               |  nmos/(drain|source) = 2
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.freepdk45/a3/shreg16.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.freepdk45/a3/shreg16.extracted.spice
result: VIOLATIONS   (5.7 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.freepdk45/a3/shreg16.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.freepdk45/a3/shreg16.png