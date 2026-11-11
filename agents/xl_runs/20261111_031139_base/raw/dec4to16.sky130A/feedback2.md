Judge:
  FAIL DRC      4525 violation(s): 1136 x Local interconnect spacing < 0.17um (li.3); 856 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8); 592 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a); 576 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4); 320 x P-diff distance to N-tap must be < 15.0um (LU.3); 220 x Metal1 spacing < 0.14um (met1.2)
  FAIL DRC2     foundry KLayout deck: 388 violation(s): 229 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um; 64 x difftap.3: difftap.3 : min. difftap spacing : 0.27um; 36 x m1.1: m1.1 : min. m1 width : 0.14um; 29 x m1.2: m1.2 : min. m1 spacing : 0.14um; 16 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 4 x m1.6: m1.6 : min. m1 area : 0.083um²
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 113/168; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/dec4to16.sky130A/a2/judge/dec4to16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     6183.57 x 43.00 = 265893.5 um2, budget 816, reference 407.56

Tool report:
magic DRC: 4525 violation(s)
  1136 x Local interconnect spacing < 0.17um (li.3)   e.g. at (4.255 36.615 4.585 36.665)  (8.255 36.615 8.585 36.665)  (12.255 36.615 12.585 36.665)
   856 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)   e.g. at (2.600 34.800 3.020 34.980)  (6.600 34.800 7.020 34.980)  (10.600 34.800 11.020 34.980)
   592 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)   e.g. at (4.260 37.100 4.290 37.130)  (4.550 37.100 4.580 37.130)  (8.260 37.100 8.290 37.130)
   576 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4)   e.g. at (2.640 34.600 2.670 34.630)  (2.930 34.600 2.960 34.630)  (2.670 34.630 2.700 34.660)
   320 x P-diff distance to N-tap must be < 15.0um (LU.3)   e.g. at (4.000 36.800 4.840 37.050)  (8.000 36.800 8.840 37.050)  (12.000 36.800 12.840 37.050)
   220 x Metal1 spacing < 0.14um (met1.2)   e.g. at (2.670 34.510 2.930 34.630)  (6.670 34.510 6.930 34.630)  (10.670 34.510 10.930 34.630)
   192 x Diffusion spacing < 0.27um (diff/tap.3)   e.g. at (3.650 20.800 3.710 21.050)  (4.700 20.800 4.760 21.050)  (5.750 20.800 5.810 21.050)
   164 x N-well width < 0.84um (nwell.1)   e.g. at (3.200 34.470 3.260 34.980)  (2.420 35.180 2.470 35.310)  (2.420 34.980 2.470 35.180)
   144 x N-well spacing < 1.27um (nwell.2a)   e.g. at (2.420 22.470 3.200 22.500)  (6.420 22.470 7.200 22.500)  (10.420 22.470 11.200 22.500)
    96 x P-Diffusion overhang of pmos < 0.25um (poly.7)   e.g. at (2.565 20.800 2.600 21.050)  (6.590 20.800 6.600 21.050)  (2.565 20.400 2.600 21.050)
    80 x All nwells must contain metal-connected N+ taps (nwell.4)   e.g. at (3.820 36.220 5.020 37.230)  (7.820 36.220 9.020 37.230)  (11.820 36.220 13.020 37.230)
    72 x Metal1 minimum area < 0.083um^2 (met1.6)   e.g. at (4.290 36.870 4.550 37.130)  (8.290 36.870 8.550 37.130)  (12.290 36.870 12.550 37.130)
KLayout deck DRC: 388 violation(s)
   229 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um   e.g. at (10.635 19.110 10.645 19.595)  (10.305 19.250 10.635 19.280)  (10.635 18.750 10.645 19.235)
    64 x difftap.3: difftap.3 : min. difftap spacing : 0.27um   e.g. at (4.490 20.400 4.700 20.670)  (12.490 8.400 12.500 9.150)  (8.490 8.400 8.700 8.670)
    36 x m1.1: m1.1 : min. m1 width : 0.14um   e.g. at (6183.430 34.599 6183.500 34.771)  (6183.379 34.650 6183.551 34.720)  (7.020 8.449 7.090 8.621)
    29 x m1.2: m1.2 : min. m1 spacing : 0.14um   e.g. at (2.531 26.630 3.069 26.650)  (2.531 34.630 3.069 34.650)  (6.531 22.630 7.069 22.650)
    16 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (12.625 20.740 12.795 20.800)  (8.625 20.740 8.795 20.800)  (4.625 8.740 4.795 8.800)
     4 x m1.6: m1.6 : min. m1 area : 0.083um²   e.g. at (2.290 2.870 2.550 3.130)  (0.670 0.370 0.930 0.630)  (0.740 2.030 0.880 2.500)
     4 x via.5a: via.5a : min. m1 enclosure of 0.15um via of 2 adjacent edges : 0.085um   e.g. at (0.725 0.425 0.875 0.575)  (2.345 2.925 2.495 3.075)  (0.735 0.425 0.885 0.575)
     4 x m2.5: m2.5 : min. m2 enclosure of via of 2 adjacent edges : 0.085um   e.g. at (0.725 0.425 0.875 0.575)  (2.345 2.925 2.495 3.075)  (0.735 0.425 0.885 0.575)
     2 x poly.1a: poly.1a : min. poly width : 0.15um   e.g. at (0.343 0.720 0.597 0.800)  (1.023 0.720 1.277 0.800)
LVS: Top level cell failed pin matching.   devices layout/ref [113, 168]  nets layout/ref [248, 90]
  sky130_fd_pr__pfet_01v8 (8)                |sky130_fd_pr__pfet_01v8 (4) **Mismatch**
  (no matching element)                      |sky130_fd_pr__nfet_01v8 (4)
  Number of devices: 8                       |Number of devices: 8
  Number of nets: 18 **Mismatch**            |Number of nets: 10 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: nand4                           |Circuit 2: nand4
  ---------------------------------------------------------------------------------------
  Net: a_120_304#                            |Net: x1
    sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |
  Net: a_120_232#                            |Net: x2
    sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |
  Net: a_120_160#                            |Net: x3
    sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |
  Net: a_750_480#                            |Net: A
    sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  Net: a_120_480#                            |Net: B
    sky130_fd_pr__pfet_01v8/(1|3) = 2        |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  Net: a_94_274#                             |Net: C
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  Net: a_94_130#                             |Net: D
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  Net: a_94_346#                             |Net: VSS
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__nfet_01v8/4 = 4
                                             |
  Net: a_94_202#                             |Net: Y
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 4