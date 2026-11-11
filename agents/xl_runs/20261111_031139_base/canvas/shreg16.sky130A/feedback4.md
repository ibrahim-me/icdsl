Judge:
  FAIL DRC      1105 violation(s): 384 x mcon.spacing < 0.19um (mcon.2); 352 x P-diff distance to N-tap must be < 15.0um (LU.3); 352 x N-diff distance to P-tap must be < 15.0um (LU.2); 17 x All nwells must contain metal-connected N+ taps (nwell.4)
  FAIL DRC2     foundry KLayout deck: 28 violation(s): 16 x via.2: via.2 : min. via spacing : 0.17um; 12 x ct.2: ct.2 : min. mcon spacing : 0.19um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 64/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a4/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     153.64 x 20.43 = 3138.9 um2, budget 1857, reference 928.02

Tool report:
shreg16 on sky130A: 153.64 x 20.43 um (3138.87 um2), 6260 shapes, 352 declared devices
connectivity pre-check: 17 short(s), 84 open net(s)
  SHORT CK = D = FF0/CKB = FF0/m = FF0/mb = FF0/n1 = FF0/n2 = FF0/n3 = FF0/n4 = FF0/p1 = FF0/p2 = FF0/p3 = FF0/p4 = FF0/s = Q0 = VDD = VSS
      m1 (0.840, 1.425) in FF0 [sub.py:93]
      m1 (4.625, 5.310) in FF0 [sub.py:63]
      m1 (2.440, 1.425) in FF0 [sub.py:93]
  SHORT CK = FF1/CKB = FF1/m = FF1/mb = FF1/n1 = FF1/n2 = FF1/n3 = FF1/n4 = FF1/p1 = FF1/p2 = FF1/p3 = FF1/p4 = FF1/s = Q0 = Q1 = VDD = VSS
      m1 (10.440, 1.425) in FF1 [sub.py:93]
      m1 (10.655, 3.200) in FF1 [sub.py:63]
  SHORT CK = FF10/CKB = FF10/m = FF10/mb = FF10/n1 = FF10/n2 = FF10/n3 = FF10/n4 = FF10/p1 = FF10/p2 = FF10/p3 = FF10/p4 = FF10/s = Q10 = Q9 = VDD = VSS
      m1 (96.840, 1.425) in FF10 [sub.py:93]
      m1 (97.055, 3.200) in FF10 [sub.py:63]
  SHORT CK = FF11/CKB = FF11/m = FF11/mb = FF11/n1 = FF11/n2 = FF11/n3 = FF11/n4 = FF11/p1 = FF11/p2 = FF11/p3 = FF11/p4 = FF11/s = Q10 = Q11 = VDD = VSS
      m1 (106.440, 1.425) in FF11 [sub.py:93]
      m1 (106.655, 3.200) in FF11 [sub.py:63]
  SHORT CK = FF12/CKB = FF12/m = FF12/mb = FF12/n1 = FF12/n2 = FF12/n3 = FF12/n4 = FF12/p1 = FF12/p2 = FF12/p3 = FF12/p4 = FF12/s = Q11 = Q12 = VDD = VSS
      m1 (116.040, 1.425) in FF12 [sub.py:93]
      m1 (116.255, 3.200) in FF12 [sub.py:63]
  SHORT CK = FF13/CKB = FF13/m = FF13/mb = FF13/n1 = FF13/n2 = FF13/n3 = FF13/n4 = FF13/p1 = FF13/p2 = FF13/p3 = FF13/p4 = FF13/s = Q12 = Q13 = VDD = VSS
      m1 (125.640, 1.425) in FF13 [sub.py:93]
      m1 (129.425, 5.310) in FF13 [sub.py:63]
      m1 (125.855, 3.200) in FF13 [sub.py:63]
  SHORT CK = FF14/CKB = FF14/m = FF14/mb = FF14/n1 = FF14/n2 = FF14/n3 = FF14/n4 = FF14/p1 = FF14/p2 = FF14/p3 = FF14/p4 = FF14/s = Q13 = Q14 = VDD = VSS
      m1 (135.240, 1.425) in FF14 [sub.py:93]
      m1 (139.025, 5.310) in FF14 [sub.py:63]
      m1 (135.455, 3.200) in FF14 [sub.py:63]
  SHORT CK = FF15/CKB = FF15/m = FF15/mb = FF15/n1 = FF15/n2 = FF15/n3 = FF15/n4 = FF15/p1 = FF15/p2 = FF15/p3 = FF15/p4 = FF15/s = Q14 = Q15 = VDD = VSS
      m1 (144.840, 1.425) in FF15 [sub.py:93]
      m1 (145.055, 3.200) in FF15 [sub.py:63]
  SHORT CK = FF2/CKB = FF2/m = FF2/mb = FF2/n1 = FF2/n2 = FF2/n3 = FF2/n4 = FF2/p1 = FF2/p2 = FF2/p3 = FF2/p4 = FF2/s = Q1 = Q2 = VDD = VSS
      m1 (20.040, 1.425) in FF2 [sub.py:93]
      m1 (20.255, 3.200) in FF2 [sub.py:63]
  SHORT CK = FF3/CKB = FF3/m = FF3/mb = FF3/n1 = FF3/n2 = FF3/n3 = FF3/n4 = FF3/p1 = FF3/p2 = FF3/p3 = FF3/p4 = FF3/s = Q2 = Q3 = VDD = VSS
      m1 (29.640, 1.425) in FF3 [sub.py:93]
      m1 (33.425, 5.310) in FF3 [sub.py:63]
      m1 (29.855, 3.200) in FF3 [sub.py:63]
  SHORT CK = FF4/CKB = FF4/m = FF4/mb = FF4/n1 = FF4/n2 = FF4/n3 = FF4/n4 = FF4/p1 = FF4/p2 = FF4/p3 = FF4/p4 = FF4/s = Q3 = Q4 = VDD = VSS
      m1 (39.240, 1.425) in FF4 [sub.py:93]
      m1 (43.025, 5.310) in FF4 [sub.py:63]
      m1 (39.455, 3.200) in FF4 [sub.py:63]
  SHORT CK = FF5/CKB = FF5/m = FF5/mb = FF5/n1 = FF5/n2 = FF5/n3 = FF5/n4 = FF5/p1 = FF5/p2 = FF5/p3 = FF5/p4 = FF5/s = Q4 = Q5 = VDD = VSS
      m1 (48.840, 1.425) in FF5 [sub.py:93]
      m1 (49.055, 3.200) in FF5 [sub.py:63]
  OPEN  net CK is in 113 unconnected pieces:
      m1 (0.840, 1.425) in FF0 [sub.py:93] (342 shapes)
      m1 (10.440, 1.425) in FF1 [sub.py:93] (342 shapes)
      m1 (20.040, 1.425) in FF2 [sub.py:93] (342 shapes)
      m1 (29.640, 1.425) in FF3 [sub.py:93] (342 shapes)
      m1 (39.240, 1.425) in FF4 [sub.py:93] (342 shapes)
  OPEN  net VDD is in 17 unconnected pieces:
      m1 (4.840, 10.120) in FF0 [sub.py:63] (342 shapes)
      m1 (14.440, 10.120) in FF1 [sub.py:63] (342 shapes)
      m1 (24.040, 10.120) in FF2 [sub.py:63] (342 shapes)
      m1 (33.640, 10.120) in FF3 [sub.py:63] (342 shapes)
      m1 (43.240, 10.120) in FF4 [sub.py:63] (342 shapes)
  OPEN  net VSS is in 17 unconnected pieces:
      m1 (4.625, 5.310) in FF0 [sub.py:63] (342 shapes)
      m1 (14.225, 5.310) in FF1 [sub.py:63] (342 shapes)
      m1 (23.825, 5.310) in FF2 [sub.py:63] (342 shapes)
      m1 (33.425, 5.310) in FF3 [sub.py:63] (342 shapes)
      m1 (43.025, 5.310) in FF4 [sub.py:63] (342 shapes)
  OPEN  net Q0 is in 7 unconnected pieces:
      m1 (7.240, 10.625) in FF0 [sub.py:93] (342 shapes)
      m1 (12.040, 1.425) in FF1 [sub.py:93] (342 shapes)
      m2 (7.240, 20.450) [sub.py:144] (5 shapes)
      poly (0.840, 9.910) in FF0 [sub.py:14] (1 shapes)
      poly (0.840, 14.720) in FF0 [sub.py:18] 
...
                                        |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |
    Net: a_1113_994#                           |Net: n2
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: a_473_2834#                           |Net: n3
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: w_4_924#                              |Net: n4
      sky130_fd_pr__pfet_01v8/4 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: w_4_2764#                             |Net: D
      sky130_fd_pr__pfet_01v8/4 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |
    Net: a_153_1914#                           |Net: p1
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    Net: a_1753_74#                            |Net: p2
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    Net: a_1783_100#                           |Net: p3
      sky130_fd_pr__nfet_01v8/(1|3) = 1        |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    Net: VSUBS                                 |Net: p4
      sky130_fd_pr__nfet_01v8/4 = 2            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    (no matching net)                          |Net: VSS
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a4/shreg16.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a4/shreg16.extracted.spice
result: VIOLATIONS   (7.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a4/shreg16.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a4/shreg16.png