Judge:
  FAIL DRC      1674 violation(s): 522 x P-Diffusion overlap of contact < 0.065um (CO.4); 308 x Metal1 width < 0.23um (M1.1); 298 x Metal1 minimum area < 0.1444um^2 (M1.3); 286 x Metal1 spacing < 0.23um (M1.2a); 200 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6); 24 x N-Diffusion overlap of contact < 0.065um (CO.4)
  FAIL DRC2     foundry KLayout deck: 1699 violation(s): 232 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 168 x CO.11: CO.11 : Contact on field oxide is forbidden; 168 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm; 168 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm; 132 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm; 128 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden
  FAIL LVS      Netlists do not match.  (devices layout/ref 120/168; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.gf180mcuD/a4/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     56.00 x 24.57 = 1375.6 um2, budget 1398, reference 698.53

Tool report:
magic DRC: 1674 violation(s)
   522 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (6.595 22.750 6.660 22.815)  (6.660 22.815 6.940 22.880)  (6.940 22.750 7.005 22.815)
   308 x Metal1 width < 0.23um (M1.1)   e.g. at (11.510 22.815 11.520 22.870)  (11.510 22.870 11.520 23.335)  (17.510 22.815 17.520 22.870)
   298 x Metal1 minimum area < 0.1444um^2 (M1.3)   e.g. at (0.430 22.815 0.770 22.870)  (0.430 22.585 0.485 22.815)  (0.430 22.530 0.770 22.585)
   286 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (6.620 22.870 6.695 23.100)  (7.820 22.870 7.895 23.100)  (9.020 22.870 9.095 23.100)
   200 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (6.940 22.585 7.085 22.730)  (8.140 22.585 8.285 22.730)  (9.340 22.585 9.485 22.730)
    24 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (2.885 3.940 3.115 4.005)  (50.885 3.940 51.115 4.005)  (2.885 3.935 2.950 4.000)
    12 x Diffusion contact width < 0.23um (CO.1 + 2 * CO.6)   e.g. at (2.885 22.005 3.115 22.055)  (50.885 22.005 51.115 22.055)  (2.885 4.110 3.115 4.145)
    12 x N-Diffusion spacing to N-well < 0.43um (DF.8)   e.g. at (1.570 19.570 2.860 19.910)  (2.860 19.570 3.140 19.910)  (3.140 19.570 4.430 19.910)
     6 x N-well overlap of N-Ohmic < 0.12um (DF.4a)   e.g. at (2.000 3.910 2.885 4.000)  (2.885 3.910 3.115 4.005)  (3.115 3.910 4.000 4.000)
     4 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6)   e.g. at (2.885 3.905 3.115 4.005)  (2.885 3.915 3.115 4.005)  (50.885 3.905 51.115 4.005)
     2 x P-diffusion and N-ohmic must be over N-well or deep N-well   e.g. at (2.885 3.905 3.115 3.910)  (50.885 3.905 51.115 3.910)
KLayout deck DRC: 1699 violation(s)
   232 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (28.350 16.530 28.450 16.585)  (28.350 22.815 28.450 22.870)  (27.150 16.530 27.250 16.585)
   168 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (27.290 13.770 27.510 13.990)  (28.490 13.770 28.710 13.990)  (32.890 13.770 33.110 13.990)
   168 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm   e.g. at (28.294 12.959 28.906 13.121)  (27.094 13.479 27.706 13.641)  (27.094 12.959 27.706 13.121)
   168 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (26.894 17.059 27.506 17.221)  (26.894 22.179 27.506 22.341)  (26.894 4.179 27.506 4.341)
   132 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm   e.g. at (27.529 16.532 27.571 16.868)  (28.029 16.532 28.071 16.868)  (28.729 16.532 28.771 16.868)
   128 x CO.10: CO.10 : Contact on Poly2 gate over COMP is forbidden   e.g. at (18.660 16.590 18.690 16.810)  (18.910 16.590 18.940 16.810)  (19.860 16.590 19.890 16.810)
   128 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm   e.g. at (18.470 16.590 18.660 16.810)  (18.940 16.590 19.130 16.810)  (19.670 16.590 19.860 16.810)
   128 x DF.6_LV: DF.6_LV : Min. COMP extend beyond gate (it also means source/drain overhang). : 0.24µm   e.g. at (18.430 16.271 18.660 17.129)  (20.140 16.271 20.370 17.129)  (26.830 16.271 27.060 17.129)
   106 x M1.3: M1.3 : Minimum metal1 area : 0.1444µm²   e.g. at (47.230 13.130 47.570 13.470)  (48.430 13.130 48.770 13.470)  (53.230 13.130 53.570 13.470)
    86 x M1.1: M1.1 : min. metal1 width : 0.23µm   e.g. at (11.290 0.665 11.510 1.130)  (17.290 0.665 17.510 1.130)  (23.290 0.665 23.510 1.130)
    77 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwell): 20um   e.g. at (28.030 16.340 28.770 17.060)  (25.630 16.340 26.370 17.060)  (24.430 16.340 25.170 17.060)
    64 x CO.2a: CO.2a : min. contact spacing : 0.25µm   e.g. at (9.090 10.590 9.310 10.810)  (6.690 10.590 6.910 10.810)  (25.890 10.590 26.110 10.810)
LVS: Netlists do not match.   devices layout/ref [120, 168]  nets layout/ref [286, 90]
  pfet_03v3 (148->36)                        |pfet_03v3 (84) **Mismatch**
  nfet_03v3 (84)                             |nfet_03v3 (84)
  Number of devices: 120 **Mismatch**        |Number of devices: 168 **Mismatch**
  Number of nets: 286 **Mismatch**           |Number of nets: 90 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dec4to16                        |Circuit 2: dec4to16
  ---------------------------------------------------------------------------------------
  Net: a_5172_3363#                          |Net: Y0
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3012_2024#                          |Net: Y1
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3252_4563#                          |Net: Y2
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3012_963#                           |Net: Y3
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3972_2163#                          |Net: Y4
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: a_3732_3363#                          |Net: Y5
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |
  Net: Y6                                    |Net: Y6
    pfet_03v3/(1|3) = 8                      |  pfet_03v3/(1|3) = 1
    nfet_03v3/(1|3) = 4                      |  nfet_03v3/(1|3) = 1
                                             |
  Net: Y7                                    |Net: Y7
    pfet_03v3/(1|3) = 8                      |  pfet_03v3/(1|3) = 1
    nfet_03v3/(1|3) = 4                      |  nfet_03v3/(1|3) = 1
                                             |