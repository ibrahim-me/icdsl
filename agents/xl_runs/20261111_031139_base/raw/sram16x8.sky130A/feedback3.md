Judge:
  FAIL DRC      70440 violation(s): 21584 x Metal1 spacing < 0.14um (met1.2); 7136 x Metal1 overlap of local interconnect contact < 0.06um in one direction (met1.5); 5120 x Diffusion spacing < 0.27um (diff/tap.3); 4864 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9); 3584 x N-well overlap of N-tap < 0.18um (diff/tap.10); 3328 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)
  FAIL DRC2     foundry KLayout deck: 5783 violation(s): 4915 x m1.2: m1.2 : min. m1 spacing : 0.14um; 480 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um; 128 x m1.7: m1.7 : min. m1 with holes area : 0.14um²; 119 x ct.2: ct.2 : min. mcon spacing : 0.19um; 112 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um; 12 x m1.5: m1.5 : min. m1 enclosure of mcon of 2 adjacent edges : 0.06um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 386/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/sram16x8.sky130A/a3/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     29.45 x 77.00 = 2267.7 um2, budget 4210, reference 2104.59

Tool report:
DRC (magic drc(full)): 70440 violation(s), boxes in um
  21584 x Metal1 spacing < 0.14um (met1.2)   e.g. at (1.700 73.115 1.705 73.255)  (1.700 73.000 1.705 73.085)  (1.700 73.085 1.705 73.255)
  7136 x Metal1 overlap of local interconnect contact < 0.06um in one direction (met1.5)   e.g. at (0.805 73.025 0.835 73.085)  (1.065 73.025 1.095 73.085)  (0.865 73.115 0.925 73.145)
  5120 x Diffusion spacing < 0.27um (diff/tap.3)   e.g. at (0.800 71.510 0.870 72.915)  (0.800 72.915 0.865 73.050)  (0.865 72.915 0.870 73.050)
  4864 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9)   e.g. at (0.800 71.690 1.100 72.030)  (0.855 70.750 1.100 71.090)  (0.810 69.550 1.100 69.760)
  3584 x N-well overlap of N-tap < 0.18um (diff/tap.10)   e.g. at (2.740 70.085 2.920 70.750)  (2.740 69.915 2.815 70.085)  (2.815 69.915 2.920 70.085)
  3328 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)   e.g. at (1.300 71.510 1.410 71.690)  (1.300 72.915 1.365 73.050)  (1.365 72.915 1.410 73.050)
  2560 x P-Diffusion overhang of pmos < 0.25um (poly.7)   e.g. at (1.825 73.050 2.475 73.120)  (1.825 72.870 2.000 73.050)  (2.300 72.870 2.475 73.050)
  2496 x mcon.spacing < 0.19um (mcon.2)   e.g. at (2.815 72.915 2.925 73.085)  (2.625 72.915 2.735 73.085)  (3.065 72.915 3.175 73.085)
  2016 x Local interconnect spacing < 0.17um (li.3)   e.g. at (3.635 70.235 3.785 70.315)  (3.635 70.165 3.715 70.235)  (3.715 70.165 3.785 70.235)
  1664 x N-Diffusion overhang of nFET < 0.25um (poly.7)   e.g. at (0.125 71.510 0.300 71.760)  (3.250 71.510 3.300 71.760)  (3.300 71.510 3.475 71.760)
  1536 x Diffusion contact spacing < 0.17um (licon.2)   e.g. at (2.815 72.915 2.905 73.050)  (3.065 72.915 3.155 73.050)  (3.365 72.915 3.405 73.050)
  1392 x N-well width < 0.84um (nwell.1)   e.g. at (1.150 73.400 1.230 74.020)  (1.150 73.350 1.230 73.400)  (2.080 73.400 3.050 74.020)
DRC2 (foundry KLayout deck): 5783 violation(s), boxes in um
  4915 x m1.2: m1.2 : min. m1 spacing : 0.14um   e.g. at (14.350 66.800 14.485 66.852)  (14.350 66.548 14.485 66.600)  (14.350 71.400 14.485 71.452)
   480 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um   e.g. at (22.750 36.550 23.350 37.050)  (19.750 36.600 21.050 37.000)  (1.150 36.600 2.938 37.050)
   128 x m1.7: m1.7 : min. m1 with holes area : 0.14um²   e.g. at (24.600 57.600 24.650 59.100)  (28.200 57.600 28.250 59.100)  (28.200 62.200 28.250 63.700)
   119 x ct.2: ct.2 : min. mcon spacing : 0.19um   e.g. at (14.335 51.604 14.515 51.746)  (14.335 42.404 14.515 42.546)  (14.335 60.804 14.515 60.946)
   112 x li.3: li.3 : min. li spacing outside or crossing areaid:ce : 0.17um   e.g. at (14.415 69.835 14.435 70.315)  (14.415 60.635 14.435 61.115)  (14.415 14.635 14.435 15.115)
    12 x m1.5: m1.5 : min. m1 enclosure of mcon of 2 adjacent edges : 0.06um   e.g. at (3.365 0.915 3.535 1.085)  (3.365 3.915 3.535 4.085)  (1.365 3.915 1.535 4.085)
     7 x MR_licon.SP.1: MR_licon.SP.1: min. licon spacing in periphery : 0.17um   e.g. at (0.285 0.915 0.365 1.235)  (3.235 0.915 3.365 1.085)  (3.235 3.915 3.365 4.085)
     3 x difftap.3: difftap.3 : min. difftap spacing : 0.27um   e.g. at (0.600 0.550 0.800 4.050)  (1.100 0.550 1.300 4.050)  (2.300 0.550 2.500 4.050)
     2 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (1.375 0.915 1.525 1.085)  (0.875 0.940 1.025 1.085)
     2 x m1.6: m1.6 : min. m1 area : 0.083um²   e.g. at (0.085 1.035 0.315 1.265)  (0.085 3.335 0.315 3.565)
     1 x nsdm.1: nsdm.1 : min. nsdm spacing in periphery : 0.38um   e.g. at (0.650 0.500 0.750 4.100)
     1 x psdm.1: psdm.1 : min. psdm spacing in periphery : 0.38um   e.g. at (1.650 0.500 1.950 4.100)
LVS: Top level cell failed pin matching.   devices layout/ref 386/768, nets layout/ref 131/290
  sky130_fd_pr__nfet_01v8 (4->2)             |sky130_fd_pr__nfet_01v8 (4) **Mismatch**
  sky130_fd_pr__cap_var_lvt (1)              |(no matching element)
  sky130_fd_pr__pfet_01v8 (5->2)             |sky130_fd_pr__pfet_01v8 (2)
  Number of devices: 5 **Mismatch**          |Number of devices: 6 **Mismatch**
  Number of nets: 4 **Mismatch**             |Number of nets: 7 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: sram6t                          |Circuit 2: sram6t
  ---------------------------------------------------------------------------------------
  Net: WL                                    |Net: WL
    sky130_fd_pr__nfet_01v8/(1|3) = 4        |  sky130_fd_pr__nfet_01v8/2 = 2
    sky130_fd_pr__nfet_01v8/4 = 2            |
    sky130_fd_pr__cap_var_lvt/2 = 1          |
    sky130_fd_pr__cap_var_lvt/(1|3) = 1      |
    sky130_fd_pr__pfet_01v8/(1|3) = 4        |
    sky130_fd_pr__pfet_01v8/4 = 2            |
                                             |
  Net: a_75_418#                             |Net: QB
    sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
    sky130_fd_pr__cap_var_lvt/(1|3) = 1      |  sky130_fd_pr__nfet_01v8/(1|3) = 2
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |
  (no matching net)                          |Net: Q
                                             |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |  sky130_fd_pr__nfet_01v8/2 = 1
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 1
                                             |  sky130_fd_pr__pfet_01v8/2 = 1
                                             |
  (no matching net)                          |Net: VSS
                                             |  sky130_fd_pr__nfet_01v8/4 = 4
                                             |  sky130_fd_pr__nfet_01v8/(1|3) = 2
                                             |
  (no matching net)                          |Net: VDD
                                             |  sky130_fd_pr__pfet_01v8/(1|3) = 2
                                             |  sky130_fd_pr__pfet_01v8/4 = 2
  ---------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------
  Net: a_415_606#                            |Net: BLB
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1