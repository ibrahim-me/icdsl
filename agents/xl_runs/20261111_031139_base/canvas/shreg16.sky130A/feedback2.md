Judge:
  FAIL DRC      1991 violation(s): 640 x poly spacing to diffusion tap < 0.055um (poly.5); 384 x mcon.spacing < 0.19um (mcon.2); 320 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9); 320 x N-Diffusion spacing to N-well < 0.005um (diff/tap.9); 192 x N-diff distance to P-tap must be < 15.0um (LU.2); 75 x Metal1 > 3um spacing to unrelated m1 < 0.28um (met1.3b)
  FAIL DRC2     foundry KLayout deck: 151 violation(s): 45 x m1.3ab: m1.3ab : min. 3um.m1 spacing m1 : 0.28um; 30 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um; 24 x nsdm.1: nsdm.1 : min. nsdm spacing in periphery : 0.38um; 24 x psdm.1: psdm.1 : min. psdm spacing in periphery : 0.38um; 16 x via.2: via.2 : min. via spacing : 0.17um; 12 x ct.2: ct.2 : min. mcon spacing : 0.19um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a2/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     105.99 x 17.73 = 1879.2 um2, budget 1857, reference 928.02

Tool report:
shreg16 on sky130A: 105.99 x 17.73 um (1879.2 um2), 6308 shapes, 352 declared devices
connectivity pre-check: 17 short(s), 84 open net(s)
  SHORT CK = D = FF0/CKB = FF0/m = FF0/mb = FF0/n1 = FF0/n2 = FF0/n3 = FF0/n4 = FF0/p1 = FF0/p2 = FF0/p3 = FF0/p4 = FF0/s = Q0 = VDD = VSS
      m1 (1.140, 1.725) in FF0 [sub.py:93]
      m1 (3.675, 3.910) in FF0 [sub.py:57]
      m1 (2.240, 1.725) in FF0 [sub.py:90]
  SHORT CK = FF1/CKB = FF1/m = FF1/mb = FF1/n1 = FF1/n2 = FF1/n3 = FF1/n4 = FF1/p1 = FF1/p2 = FF1/p3 = FF1/p4 = FF1/s = Q0 = Q1 = VDD = VSS
      m1 (7.740, 1.725) in FF1 [sub.py:93]
      m1 (7.955, 2.565) in FF1 [sub.py:71]
  SHORT CK = FF10/CKB = FF10/m = FF10/mb = FF10/n1 = FF10/n2 = FF10/n3 = FF10/n4 = FF10/p1 = FF10/p2 = FF10/p3 = FF10/p4 = FF10/s = Q10 = Q9 = VDD = VSS
      m1 (67.140, 1.725) in FF10 [sub.py:93]
      m1 (67.355, 2.565) in FF10 [sub.py:71]
  SHORT CK = FF11/CKB = FF11/m = FF11/mb = FF11/n1 = FF11/n2 = FF11/n3 = FF11/n4 = FF11/p1 = FF11/p2 = FF11/p3 = FF11/p4 = FF11/s = Q10 = Q11 = VDD = VSS
      m1 (73.740, 1.725) in FF11 [sub.py:93]
      m1 (73.955, 2.565) in FF11 [sub.py:71]
  SHORT CK = FF12/CKB = FF12/m = FF12/mb = FF12/n1 = FF12/n2 = FF12/n3 = FF12/n4 = FF12/p1 = FF12/p2 = FF12/p3 = FF12/p4 = FF12/s = Q11 = Q12 = VDD = VSS
      m1 (80.340, 1.725) in FF12 [sub.py:93]
      m1 (80.555, 2.565) in FF12 [sub.py:71]
  SHORT CK = FF13/CKB = FF13/m = FF13/mb = FF13/n1 = FF13/n2 = FF13/n3 = FF13/n4 = FF13/p1 = FF13/p2 = FF13/p3 = FF13/p4 = FF13/s = Q12 = Q13 = VDD = VSS
      m1 (86.940, 1.725) in FF13 [sub.py:93]
      m1 (87.155, 2.565) in FF13 [sub.py:71]
  SHORT CK = FF14/CKB = FF14/m = FF14/mb = FF14/n1 = FF14/n2 = FF14/n3 = FF14/n4 = FF14/p1 = FF14/p2 = FF14/p3 = FF14/p4 = FF14/s = Q13 = Q14 = VDD = VSS
      m1 (93.540, 1.725) in FF14 [sub.py:93]
      m1 (93.755, 2.565) in FF14 [sub.py:71]
  SHORT CK = FF15/CKB = FF15/m = FF15/mb = FF15/n1 = FF15/n2 = FF15/n3 = FF15/n4 = FF15/p1 = FF15/p2 = FF15/p3 = FF15/p4 = FF15/s = Q14 = Q15 = VDD = VSS
      m1 (100.140, 1.725) in FF15 [sub.py:93]
      m1 (100.355, 2.565) in FF15 [sub.py:71]
  SHORT CK = FF2/CKB = FF2/m = FF2/mb = FF2/n1 = FF2/n2 = FF2/n3 = FF2/n4 = FF2/p1 = FF2/p2 = FF2/p3 = FF2/p4 = FF2/s = Q1 = Q2 = VDD = VSS
      m1 (14.340, 1.725) in FF2 [sub.py:93]
      m1 (14.555, 2.565) in FF2 [sub.py:71]
  SHORT CK = FF3/CKB = FF3/m = FF3/mb = FF3/n1 = FF3/n2 = FF3/n3 = FF3/n4 = FF3/p1 = FF3/p2 = FF3/p3 = FF3/p4 = FF3/s = Q2 = Q3 = VDD = VSS
      m1 (20.940, 1.725) in FF3 [sub.py:93]
      m1 (21.155, 2.565) in FF3 [sub.py:71]
  SHORT CK = FF4/CKB = FF4/m = FF4/mb = FF4/n1 = FF4/n2 = FF4/n3 = FF4/n4 = FF4/p1 = FF4/p2 = FF4/p3 = FF4/p4 = FF4/s = Q3 = Q4 = VDD = VSS
      m1 (27.540, 1.725) in FF4 [sub.py:93]
      m1 (27.755, 2.565) in FF4 [sub.py:71]
  SHORT CK = FF5/CKB = FF5/m = FF5/mb = FF5/n1 = FF5/n2 = FF5/n3 = FF5/n4 = FF5/p1 = FF5/p2 = FF5/p3 = FF5/p4 = FF5/s = Q4 = Q5 = VDD = VSS
      m1 (34.140, 1.725) in FF5 [sub.py:93]
      m1 (34.355, 2.565) in FF5 [sub.py:71]
  OPEN  net CK is in 113 unconnected pieces:
      m1 (1.140, 1.725) in FF0 [sub.py:93] (346 shapes)
      m1 (7.740, 1.725) in FF1 [sub.py:93] (346 shapes)
      m1 (14.340, 1.725) in FF2 [sub.py:93] (346 shapes)
      m1 (20.940, 1.725) in FF3 [sub.py:93] (346 shapes)
      m1 (27.540, 1.725) in FF4 [sub.py:93] (346 shapes)
  OPEN  net VDD is in 17 unconnected pieces:
      m1 (3.890, 7.020) in FF0 [sub.py:57] (346 shapes)
      m1 (10.490, 7.020) in FF1 [sub.py:57] (346 shapes)
      m1 (17.090, 7.020) in FF2 [sub.py:57] (346 shapes)
      m1 (23.690, 7.020) in FF3 [sub.py:57] (346 shapes)
      m1 (30.290, 7.020) in FF4 [sub.py:57] (346 shapes)
  OPEN  net VSS is in 17 unconnected pieces:
      m1 (3.675, 3.910) in FF0 [sub.py:57] (346 shapes)
      m1 (10.275, 3.910) in FF1 [sub.py:57] (346 shapes)
      m1 (16.875, 3.910) in FF2 [sub.py:57] (346 shapes)
      m1 (23.475, 3.910) in FF3 [sub.py:57] (346 shapes)
      m1 (30.075, 3.910) in FF4 [sub.py:57] (346 shapes)
  OPEN  net Q0 is in 7 unconnected pieces:
      m1 (5.540, 7.525) in FF0 [sub.py:96] (346 shapes)
      m1 (8.840, 1.725) in FF1 [sub.py:90] (346 shapes)
      m2 (5.540, 18.050) [sub.py:140] (5 shapes)
      poly (1.140, 6.810) in FF0 [sub.py:14] (1 shapes)
      poly (1.140, 9.920) in FF0 [sub.py:18] (1 shapes)
  OPEN  net Q1 is in 7 unconnected pieces:
      m1 (12.140, 7.525) in FF1 [sub.py:96] (346 shapes)
      m1 (15.440, 1.725) in FF2 [sub.py:90] (346 shapes)
      m2 (12.140, 18.050) [sub.p
...
  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__nfet_01v8/2 = 2
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 2
                                               |
    Net: a_1093_134#                           |Net: mb
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 2
                                               |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 2
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                               |
    Net: a_1313_134#                           |Net: m
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |
    Net: a_1343_160#                           |Net: s
      sky130_fd_pr__nfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |
    Net: VSUBS                                 |Net: n1
      sky130_fd_pr__nfet_01v8/4 = 2            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a2/shreg16.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a2/shreg16.extracted.spice
result: VIOLATIONS   (7.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a2/shreg16.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a2/shreg16.png