Judge:
  FAIL DRC      19532 violation(s): 7104 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4); 3350 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a); 2791 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8); 1885 x Metal1 spacing < 0.14um (met1.2); 1262 x Metal2 spacing < 0.14um (met2.2); 659 x N-well width < 0.84um (nwell.1)
  FAIL DRC2     foundry KLayout deck: 871 violation(s): 380 x m1.2: m1.2 : min. m1 spacing : 0.14um; 145 x m1.7: m1.7 : min. m1 with holes area : 0.14um²; 96 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2; 67 x via.5a: via.5a : min. m1 enclosure of 0.15um via of 2 adjacent edges : 0.085um; 36 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 33 x via.2: via.2 : min. via spacing : 0.17um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 17/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/shreg16.sky130A/a4/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     177.00 x 10.81 = 1913.4 um2, budget 1857, reference 928.02

Tool report:
DRC (magic drc(full)): 19532 violation(s), boxes in um
  7104 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4)   e.g. at (5.840 10.990 5.870 11.020)  (6.130 10.990 6.160 11.020)  (5.840 10.990 5.870 11.020)
  3350 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)   e.g. at (5.840 11.000 5.870 11.020)  (6.130 11.000 6.160 11.020)  (16.840 11.000 16.870 11.020)
  2791 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)   e.g. at (5.925 10.220 6.075 10.400)  (16.925 10.220 17.075 10.400)  (27.925 10.220 28.075 10.400)
  1885 x Metal1 spacing < 0.14um (met1.2)   e.g. at (5.870 9.500 5.940 9.630)  (4.560 7.190 4.600 7.330)  (5.870 9.370 5.940 9.630)
  1262 x Metal2 spacing < 0.14um (met2.2)   e.g. at (10.270 7.530 10.370 7.790)  (10.130 7.530 10.230 7.790)  (21.270 7.530 21.370 7.790)
   659 x N-well width < 0.84um (nwell.1)   e.g. at (2.255 2.110 2.585 2.160)  (2.255 2.160 2.585 2.840)  (2.255 2.840 2.585 2.890)
   593 x P-diff distance to N-tap must be < 15.0um (LU.3)   e.g. at (1.725 9.080 1.925 9.920)  (2.075 9.080 2.275 9.920)  (2.925 9.080 3.125 9.920)
   576 x P-Diffusion overhang of pmos < 0.25um (poly.7)   e.g. at (1.675 9.080 1.725 9.920)  (2.275 9.080 2.325 9.920)  (2.875 9.080 2.925 9.920)
   432 x N-well spacing < 1.27um (nwell.2a)   e.g. at (2.645 2.840 3.155 2.890)  (2.645 2.160 3.155 2.840)  (2.645 2.110 3.155 2.160)
   289 x Via1 spacing < 0.06um (via.2 - 2 * via.4a)   e.g. at (3.070 3.930 3.090 4.190)  (3.140 3.930 3.260 3.950)  (3.260 3.930 3.330 3.950)
   211 x All nwells must contain metal-connected N+ taps (nwell.4)   e.g. at (1.200 10.100 10.800 10.400)  (12.200 10.100 21.800 10.400)  (23.200 10.100 32.800 10.400)
   160 x Min area of metal1 holes > 0.14um^2 (met1.7)   e.g. at (10.340 10.135 10.460 10.620)  (21.340 10.135 21.460 10.620)  (32.340 10.135 32.460 10.620)
DRC2 (foundry KLayout deck): 871 violation(s), boxes in um
   380 x m1.2: m1.2 : min. m1 spacing : 0.14um   e.g. at (175.340 10.135 175.460 10.620)  (153.340 10.135 153.460 10.620)  (164.100 9.232 164.200 9.688)
   145 x m1.7: m1.7 : min. m1 with holes area : 0.14um²   e.g. at (175.300 3.590 175.330 4.530)  (175.170 4.790 175.330 4.830)  (174.140 3.590 174.260 4.530)
    96 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2   e.g. at (159.925 10.815 160.075 10.965)  (148.925 10.815 149.075 10.965)  (38.925 10.815 39.075 10.965)
    67 x via.5a: via.5a : min. m1 enclosure of 0.15um via of 2 adjacent edges : 0.085um   e.g. at (142.325 3.385 142.575 3.675)  (56.425 3.525 56.575 3.675)  (65.325 3.385 65.575 3.675)
    36 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (9.445 8.415 9.475 8.585)  (9.325 8.415 9.355 8.585)  (8.245 8.415 8.275 8.585)
    33 x via.2: via.2 : min. via spacing : 0.17um   e.g. at (137.805 0.915 137.925 1.165)  (170.805 0.915 170.925 1.165)  (82.805 0.915 82.925 1.165)
    30 x via.1a_a: via.1a_a : min. width of via outside of moduleCut : 0.15um   e.g. at (10.325 3.525 10.575 3.535)  (10.425 3.394 10.475 3.666)  (21.325 3.525 21.575 3.535)
    19 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um   e.g. at (4.555 8.415 4.645 8.585)  (3.355 8.415 3.445 8.585)  (4.815 8.415 4.915 8.585)
    16 x m1.6: m1.6 : min. m1 area : 0.083um²   e.g. at (12.370 3.470 12.630 3.730)  (23.370 3.470 23.630 3.730)  (34.370 3.470 34.630 3.730)
    16 x m2.6: m2.6 : min. m2 area : 0.0676um²   e.g. at (9.430 -0.030 9.570 0.250)  (9.430 9.750 9.570 10.030)  (9.430 3.060 9.570 3.340)
    15 x via.1a: via.1a : via outside of moduleCut should be rectangular   e.g. at (10.325 3.385 10.575 3.675)  (21.325 3.385 21.575 3.675)  (32.325 3.385 32.575 3.675)
     8 x m2.2: m2.2 : min. m2 spacing : 0.14um   e.g. at (9.430 4.840 9.570 4.860)  (9.430 4.540 9.570 4.560)  (9.430 3.940 9.570 3.960)
LVS: Top level cell failed pin matching.   devices layout/ref 17/352, nets layout/ref 68/212
  sky130_fd_pr__pfet_01v8 (18)               |sky130_fd_pr__pfet_01v8 (11) **Mismatch**
  (no matching element)                      |sky130_fd_pr__nfet_01v8 (11)
  Number of devices: 18 **Mismatch**         |Number of devices: 22 **Mismatch**
  Number of nets: 65 **Mismatch**            |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dff                             |Circuit 2: dff
  ---------------------------------------------------------------------------------------
  Net: a_1475_258#                           |Net: VSS
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 7
                                             |  sky130_fd_pr__nfet_01v8/4 = 11
                                             |
  Net: a_1405_258#                           |Net: VDD
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__pfet_01v8/(1|3) = 7
                                             |  sky130_fd_pr__pfet_01v8/4 = 11
                                             |
  Net: a_1175_1616#                          |Net: CK
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/2 = 3
                                             |  sky130_fd_pr__pfet_01v8/2 = 3
                                             |
  Net: a_1105_1616#                          |Net: CKB
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__nfet_01v8/2 = 2
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 2
                                             |
  Net: a_1295_258#                           |Net: mb
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/2 = 2
                                             |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 2
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |
  Net: a_1225_258#                           |Net: m
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  Net: a_1115_258#                           |Net: s
    sky130_fd_pr__pfet_01v8/(1|3) = 1        |  sky130_fd_pr__nfet_01v8/(1|3) = 2