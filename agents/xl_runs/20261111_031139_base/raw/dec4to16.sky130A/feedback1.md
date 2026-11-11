Judge:
  FAIL DRC      3222 violation(s): 672 x Local interconnect overlap of poly contact < 0.08um in one direction (li.5); 568 x Transistor width < 0.42um (diff/tap.2); 470 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8); 440 x Local interconnect minimum area < 0.0561um^2 (li.6); 164 x poly contact spacing to diffusion < 0.19um (licon.14); 164 x poly contact spacing to P-diffusion < 0.235um (licon.9 + psdm.5a)
  FAIL DRC2     foundry KLayout deck: 372 violation(s): 144 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um; 144 x li.6: li.6 : min. li area : 0.0561um²; 48 x poly.2: poly.2 : min. poly spacing : 0.21um; 20 x nwell.1: nwell.1 : min. nwell width : 0.84um; 16 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 48/168; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.sky130A/a1/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     20.00 x 44.60 = 892.0 um2, budget 816, reference 407.56

Tool report:
magic DRC: 3222 violation(s)
   672 x Local interconnect overlap of poly contact < 0.08um in one direction (li.5)   e.g. at (2.755 37.605 2.835 37.685)  (3.005 37.605 3.085 37.685)  (7.755 37.605 7.835 37.685)
   568 x Transistor width < 0.42um (diff/tap.2)   e.g. at (2.500 37.685 3.340 37.700)  (2.500 37.570 2.835 37.685)  (2.835 37.570 3.005 37.685)
   470 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)   e.g. at (3.990 20.550 4.170 20.700)  (3.990 20.100 4.170 20.250)  (8.990 20.550 9.170 20.700)
   440 x Local interconnect minimum area < 0.0561um^2 (li.6)   e.g. at (2.835 38.515 3.005 38.685)  (2.835 38.515 3.005 38.685)  (7.835 38.515 8.005 38.685)
   164 x poly contact spacing to diffusion < 0.19um (licon.14)   e.g. at (2.645 37.700 3.005 37.850)  (3.005 37.700 3.195 37.850)  (7.645 37.700 8.005 37.850)
   164 x poly contact spacing to P-diffusion < 0.235um (licon.9 + psdm.5a)   e.g. at (2.600 37.700 3.005 37.850)  (3.005 37.700 3.240 37.850)  (7.600 37.700 8.005 37.850)
   148 x poly overlap of poly contact < 0.05um (licon.8)   e.g. at (2.835 37.650 3.005 37.685)  (2.835 37.570 3.005 37.620)  (7.835 37.650 8.005 37.685)
   122 x poly overhang of transistor < 0.13um (poly.8)   e.g. at (2.370 20.420 2.500 20.830)  (7.370 20.700 7.500 20.830)  (7.370 20.550 7.500 20.700)
   113 x N-well width < 0.84um (nwell.1)   e.g. at (2.320 38.030 3.520 38.360)  (7.320 38.030 8.520 38.360)  (12.320 38.030 13.520 38.360)
    76 x poly contact width        < 0.17um (licon.1)   e.g. at (2.835 37.685 3.005 37.740)  (7.835 37.685 8.005 37.740)  (12.835 37.685 13.005 37.740)
    72 x All nwells must contain metal-connected N+ taps (nwell.4)   e.g. at (2.320 37.520 3.520 38.030)  (7.320 37.520 8.520 38.030)  (12.320 37.520 13.520 38.030)
    64 x P-Diffusion overhang of pmos < 0.25um (poly.7)   e.g. at (2.250 20.550 2.500 20.700)  (4.230 20.550 4.240 20.700)  (7.250 20.550 7.500 20.700)
KLayout deck DRC: 372 violation(s)
   144 x li.5: li.5 : min. li enclosure of licon of 2 adjacent edges : 0.08um   e.g. at (12.835 29.715 13.005 29.885)  (17.625 35.915 17.795 36.085)  (12.835 38.515 13.005 38.685)
   144 x li.6: li.6 : min. li area : 0.0561um²   e.g. at (17.625 22.315 17.795 22.485)  (12.625 22.315 12.795 22.485)  (17.625 22.715 17.795 22.885)
    48 x poly.2: poly.2 : min. poly spacing : 0.21um   e.g. at (12.370 19.840 13.050 19.970)  (12.695 11.040 13.215 11.170)  (17.695 15.440 18.215 15.570)
    20 x nwell.1: nwell.1 : min. nwell width : 0.84um   e.g. at (0.320 6.720 1.520 7.230)  (5.320 6.720 6.520 7.230)  (10.320 6.720 11.520 7.230)
    16 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (12.625 19.495 12.795 19.665)  (7.625 19.495 7.795 19.665)  (7.625 6.295 7.795 6.465)
LVS: Top level cell failed pin matching.   devices layout/ref [48, 168]  nets layout/ref [96, 90]
  sky130_fd_pr__pfet_01v8 (48)               |sky130_fd_pr__pfet_01v8 (84) **Mismatch**
  (no matching element)                      |sky130_fd_pr__nfet_01v8 (84)
  Number of devices: 48 **Mismatch**         |Number of devices: 168 **Mismatch**
  Number of nets: 96 **Mismatch**            |Number of nets: 90 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dec4to16                        |Circuit 2: dec4to16
  ---------------------------------------------------------------------------------------
  Net: w_1464_3634#                          |Net: VSS
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/(1|3) = 36
                                             |  sky130_fd_pr__nfet_01v8/4 = 84
                                             |
  Net: w_2464_2754#                          |Net: VDD
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__pfet_01v8/(1|3) = 84
                                             |  sky130_fd_pr__pfet_01v8/4 = 84
                                             |
  Net: w_3464_1874#                          |Net: AB0
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__nfet_01v8/2 = 8
                                             |  sky130_fd_pr__pfet_01v8/2 = 8
                                             |
  Net: w_464_1874#                           |Net: AB3
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/2 = 8
                                             |  sky130_fd_pr__pfet_01v8/2 = 8
                                             |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |
  Net: w_464_3634#                           |Net: A0
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/2 = 9
                                             |  sky130_fd_pr__pfet_01v8/2 = 9
                                             |
  Net: w_1464_2754#                          |Net: A3
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/2 = 9
                                             |  sky130_fd_pr__pfet_01v8/2 = 9
                                             |
  Net: w_2464_1874#                          |Net: AB1
    sky130_fd_pr__pfet_01v8/4 = 3            |  sky130_fd_pr__nfet_01v8/2 = 8
                                             |  sky130_fd_pr__pfet_01v8/2 = 8
                                             |  sky130_fd_pr__nfet_01v8/(1|3) = 1