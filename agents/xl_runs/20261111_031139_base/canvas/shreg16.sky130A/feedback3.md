Judge:
  FAIL DRC      1919 violation(s): 640 x poly spacing to diffusion tap < 0.055um (poly.5); 384 x mcon.spacing < 0.19um (mcon.2); 320 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9); 320 x N-Diffusion spacing to N-well < 0.005um (diff/tap.9); 192 x N-diff distance to P-tap must be < 15.0um (LU.2); 47 x N-well spacing < 1.27um (nwell.2a)
  FAIL DRC2     foundry KLayout deck: 44 violation(s): 16 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um; 16 x via.2: via.2 : min. via spacing : 0.17um; 12 x ct.2: ct.2 : min. mcon spacing : 0.19um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 64/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a3/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     152.99 x 20.33 = 3110.3 um2, budget 1857, reference 928.02

Tool report:
shreg16 on sky130A: 152.99 x 20.33 um (3110.29 um2), 6308 shapes, 352 declared devices
connectivity pre-check: 17 short(s), 84 open net(s)
  SHORT CK = D = FF0/CKB = FF0/m = FF0/mb = FF0/n1 = FF0/n2 = FF0/n3 = FF0/n4 = FF0/p1 = FF0/p2 = FF0/p3 = FF0/p4 = FF0/s = Q0 = VDD = VSS
      m1 (0.940, 1.525) in FF0 [sub.py:100]
      m1 (4.475, 4.010) in FF0 [sub.py:63]
      m1 (2.440, 1.525) in FF0 [sub.py:97]
  SHORT CK = FF1/CKB = FF1/m = FF1/mb = FF1/n1 = FF1/n2 = FF1/n3 = FF1/n4 = FF1/p1 = FF1/p2 = FF1/p3 = FF1/p4 = FF1/s = Q0 = Q1 = VDD = VSS
      m1 (10.540, 1.525) in FF1 [sub.py:100]
      m1 (10.755, 2.515) in FF1 [sub.py:77]
  SHORT CK = FF10/CKB = FF10/m = FF10/mb = FF10/n1 = FF10/n2 = FF10/n3 = FF10/n4 = FF10/p1 = FF10/p2 = FF10/p3 = FF10/p4 = FF10/s = Q10 = Q9 = VDD = VSS
      m1 (96.940, 1.525) in FF10 [sub.py:100]
      m1 (97.155, 2.515) in FF10 [sub.py:77]
  SHORT CK = FF11/CKB = FF11/m = FF11/mb = FF11/n1 = FF11/n2 = FF11/n3 = FF11/n4 = FF11/p1 = FF11/p2 = FF11/p3 = FF11/p4 = FF11/s = Q10 = Q11 = VDD = VSS
      m1 (106.540, 1.525) in FF11 [sub.py:100]
      m1 (106.755, 2.515) in FF11 [sub.py:77]
  SHORT CK = FF12/CKB = FF12/m = FF12/mb = FF12/n1 = FF12/n2 = FF12/n3 = FF12/n4 = FF12/p1 = FF12/p2 = FF12/p3 = FF12/p4 = FF12/s = Q11 = Q12 = VDD = VSS
      m1 (116.140, 1.525) in FF12 [sub.py:100]
      m1 (116.355, 2.515) in FF12 [sub.py:77]
  SHORT CK = FF13/CKB = FF13/m = FF13/mb = FF13/n1 = FF13/n2 = FF13/n3 = FF13/n4 = FF13/p1 = FF13/p2 = FF13/p3 = FF13/p4 = FF13/s = Q12 = Q13 = VDD = VSS
      m1 (125.740, 1.525) in FF13 [sub.py:100]
      m1 (129.275, 4.010) in FF13 [sub.py:63]
      m1 (125.955, 2.515) in FF13 [sub.py:77]
  SHORT CK = FF14/CKB = FF14/m = FF14/mb = FF14/n1 = FF14/n2 = FF14/n3 = FF14/n4 = FF14/p1 = FF14/p2 = FF14/p3 = FF14/p4 = FF14/s = Q13 = Q14 = VDD = VSS
      m1 (135.340, 1.525) in FF14 [sub.py:100]
      m1 (135.555, 2.515) in FF14 [sub.py:77]
  SHORT CK = FF15/CKB = FF15/m = FF15/mb = FF15/n1 = FF15/n2 = FF15/n3 = FF15/n4 = FF15/p1 = FF15/p2 = FF15/p3 = FF15/p4 = FF15/s = Q14 = Q15 = VDD = VSS
      m1 (144.940, 1.525) in FF15 [sub.py:100]
      m1 (145.155, 2.515) in FF15 [sub.py:77]
  SHORT CK = FF2/CKB = FF2/m = FF2/mb = FF2/n1 = FF2/n2 = FF2/n3 = FF2/n4 = FF2/p1 = FF2/p2 = FF2/p3 = FF2/p4 = FF2/s = Q1 = Q2 = VDD = VSS
      m1 (20.140, 1.525) in FF2 [sub.py:100]
      m1 (20.355, 2.515) in FF2 [sub.py:77]
  SHORT CK = FF3/CKB = FF3/m = FF3/mb = FF3/n1 = FF3/n2 = FF3/n3 = FF3/n4 = FF3/p1 = FF3/p2 = FF3/p3 = FF3/p4 = FF3/s = Q2 = Q3 = VDD = VSS
      m1 (29.740, 1.525) in FF3 [sub.py:100]
      m1 (33.275, 4.010) in FF3 [sub.py:63]
      m1 (29.955, 2.515) in FF3 [sub.py:77]
  SHORT CK = FF4/CKB = FF4/m = FF4/mb = FF4/n1 = FF4/n2 = FF4/n3 = FF4/n4 = FF4/p1 = FF4/p2 = FF4/p3 = FF4/p4 = FF4/s = Q3 = Q4 = VDD = VSS
      m1 (39.340, 1.525) in FF4 [sub.py:100]
      m1 (39.555, 2.515) in FF4 [sub.py:77]
  SHORT CK = FF5/CKB = FF5/m = FF5/mb = FF5/n1 = FF5/n2 = FF5/n3 = FF5/n4 = FF5/p1 = FF5/p2 = FF5/p3 = FF5/p4 = FF5/s = Q4 = Q5 = VDD = VSS
      m1 (48.940, 1.525) in FF5 [sub.py:100]
      m1 (49.155, 2.515) in FF5 [sub.py:77]
  OPEN  net CK is in 113 unconnected pieces:
      m1 (0.940, 1.525) in FF0 [sub.py:100] (346 shapes)
      m1 (10.540, 1.525) in FF1 [sub.py:100] (346 shapes)
      m1 (20.140, 1.525) in FF2 [sub.py:100] (346 shapes)
      m1 (29.740, 1.525) in FF3 [sub.py:100] (346 shapes)
      m1 (39.340, 1.525) in FF4 [sub.py:100] (346 shapes)
  OPEN  net VDD is in 17 unconnected pieces:
      m1 (4.690, 7.420) in FF0 [sub.py:63] (346 shapes)
      m1 (14.290, 7.420) in FF1 [sub.py:63] (346 shapes)
      m1 (23.890, 7.420) in FF2 [sub.py:63] (346 shapes)
      m1 (33.490, 7.420) in FF3 [sub.py:63] (346 shapes)
      m1 (43.090, 7.420) in FF4 [sub.py:63] (346 shapes)
  OPEN  net VSS is in 17 unconnected pieces:
      m1 (4.475, 4.010) in FF0 [sub.py:63] (346 shapes)
      m1 (14.075, 4.010) in FF1 [sub.py:63] (346 shapes)
      m1 (23.675, 4.010) in FF2 [sub.py:63] (346 shapes)
      m1 (33.275, 4.010) in FF3 [sub.py:63] (346 shapes)
      m1 (42.875, 4.010) in FF4 [sub.py:63] (346 shapes)
  OPEN  net Q0 is in 7 unconnected pieces:
      m1 (6.940, 7.925) in FF0 [sub.py:103] (346 shapes)
      m1 (12.040, 1.525) in FF1 [sub.py:97] (346 shapes)
      m2 (6.940, 20.450) [sub.py:147] (5 shapes)
      poly (0.940, 7.210) in FF0 [sub.py:15] (1 shapes)
      poly (0.940, 10.620) in FF0 [sub.py:19] (1 shapes)
  OPEN  net Q1 is in 7 unconnected pieces:
      m1 (16.540, 7.925)
...
fet_01v8/(1|3) = 2
                                               |
    Net: a_173_94#                             |Net: n3
      sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: a_173_2014#                           |Net: n4
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                               |
    Net: a_1673_734#                           |Net: D
      sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |
    Net: w_1584_724#                           |Net: p1
      sky130_fd_pr__pfet_01v8/4 = 1            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    Net: Q                                     |Net: Q
      sky130_fd_pr__nfet_01v8/(1|3) = 3        |  sky130_fd_pr__nfet_01v8/(1|3) = 1
      sky130_fd_pr__pfet_01v8/(1|3) = 4        |  sky130_fd_pr__pfet_01v8/(1|3) = 1
      sky130_fd_pr__pfet_01v8/4 = 1            |  sky130_fd_pr__pfet_01v8/2 = 1
                                               |  sky130_fd_pr__nfet_01v8/2 = 1
                                               |
    Net: VSUBS                                 |Net: p3
      sky130_fd_pr__nfet_01v8/4 = 2            |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    (no matching net)                          |Net: p4
                                               |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                               |
    (no matching net)                          |Net: VSS
    full report: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a3/shreg16.lvs.txt   extracted: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a3/shreg16.extracted.spice
result: VIOLATIONS   (6.0 s)   gds: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a3/shreg16.gds   image: /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/canvas/shreg16.sky130A/a3/shreg16.png