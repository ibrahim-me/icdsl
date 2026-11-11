Judge:
  FAIL DRC      15224 violation(s): 2816 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9); 2688 x Diffusion spacing < 0.27um (diff/tap.3); 2304 x P-Diffusion overhang of pmos < 0.25um (poly.7); 2304 x N-Diffusion overhang of nFET < 0.25um (poly.7); 1536 x Transistor width < 0.42um (diff/tap.2); 1024 x mcon.spacing < 0.19um (mcon.2)
  FAIL DRC2     foundry KLayout deck: 614 violation(s): 600 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um; 5 x nsdm.2: nsdm.2 : min. nsdm width in periphery : 0.38um; 3 x psdm.2: psdm.2 : min. psdm width in periphery : 0.38um; 2 x difftap.3: difftap.3 : min. difftap spacing : 0.27um; 2 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 2 x ct.2: ct.2 : min. mcon spacing : 0.19um
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 386/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/sram16x8.sky130A/a4/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     40.60 x 83.40 = 3386.0 um2, budget 4210, reference 2104.59

Tool report:
DRC (magic drc(full)): 15224 violation(s), boxes in um
  2816 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9)   e.g. at (3.675 79.235 3.840 79.500)  (3.675 79.065 3.715 79.235)  (3.715 79.065 3.840 79.235)
  2688 x Diffusion spacing < 0.27um (diff/tap.3)   e.g. at (2.550 77.710 2.695 79.065)  (2.550 79.065 2.590 79.235)  (2.590 79.065 2.695 79.235)
  2304 x P-Diffusion overhang of pmos < 0.25um (poly.7)   e.g. at (2.725 79.235 2.800 79.315)  (2.725 79.065 2.760 79.235)  (2.760 79.065 2.800 79.235)
  2304 x N-Diffusion overhang of nFET < 0.25um (poly.7)   e.g. at (0.475 77.710 0.675 77.960)  (3.475 79.010 3.675 79.260)  (3.925 79.010 4.125 79.260)
  1536 x Transistor width < 0.42um (diff/tap.2)   e.g. at (0.505 77.290 0.675 77.710)  (0.675 77.290 0.725 77.710)  (1.675 77.290 1.845 77.710)
  1024 x mcon.spacing < 0.19um (mcon.2)   e.g. at (0.065 78.875 0.115 78.885)  (0.065 78.875 0.235 78.885)  (5.065 78.875 5.115 78.885)
   768 x pFET cannot abut N-diffusion (diff/tap.3)   e.g. at (2.975 78.380 3.070 79.065)  (2.655 77.710 2.800 77.980)  (2.550 77.710 2.695 77.980)
   512 x Diffusion contact to gate < 0.055um (licon.11)   e.g. at (2.965 79.065 3.125 79.120)  (3.125 79.065 3.135 79.120)  (2.225 75.935 2.375 75.990)
   384 x P-tap contact width     < 0.17um (licon.1)   e.g. at (0.235 78.715 0.245 78.885)  (5.235 78.715 5.245 78.885)  (10.235 78.715 10.245 78.885)
   256 x Varactor N-well must not contain P+ diffusion (varac.7)   e.g. at (2.175 75.500 2.425 79.500)  (2.925 75.500 3.175 79.500)  (7.175 75.500 7.425 79.500)
   256 x Varactor width < 1um (var.2)   e.g. at (2.925 77.290 3.175 77.710)  (2.175 77.290 2.425 77.710)  (7.925 77.290 8.175 77.710)
   256 x poly overhang of transistor < 0.13um (poly.8)   e.g. at (2.550 77.290 2.555 77.710)  (2.795 77.290 2.800 77.710)  (7.550 77.290 7.555 77.710)
DRC2 (foundry KLayout deck): 614 violation(s), boxes in um
   600 x nwell.2a: nwell.2a : min. nwell spacing (merged if less) : 1.27um   e.g. at (21.850 39.800 23.500 40.200)  (21.850 39.800 23.500 40.200)  (6.850 39.800 8.500 40.200)
     5 x nsdm.2: nsdm.2 : min. nsdm width in periphery : 0.38um   e.g. at (0.615 0.440 0.985 4.560)  (1.365 0.440 1.735 4.560)  (3.615 0.440 3.985 4.560)
     3 x psdm.2: psdm.2 : min. psdm width in periphery : 0.38um   e.g. at (2.115 0.440 2.485 4.560)  (2.865 0.440 3.235 4.560)  (0.015 0.440 0.385 4.560)
     2 x difftap.3: difftap.3 : min. difftap spacing : 0.27um   e.g. at (2.425 0.500 2.550 4.500)  (2.800 0.500 2.925 4.500)
     2 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (2.975 4.065 3.125 4.220)  (2.225 0.780 2.375 0.935)
     2 x ct.2: ct.2 : min. mcon spacing : 0.19um   e.g. at (0.065 0.935 0.285 1.115)  (0.065 3.885 0.285 4.065)
LVS: Top level cell failed pin matching.   devices layout/ref 386/768, nets layout/ref 131/290
  sky130_fd_pr__nfet_01v8 (6->2)             |sky130_fd_pr__nfet_01v8 (4) **Mismatch**
  sky130_fd_pr__cap_var_lvt (1)              |(no matching element)
  Number of devices: 5 **Mismatch**          |Number of devices: 6 **Mismatch**
  Number of nets: 4 **Mismatch**             |Number of nets: 7 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: sram6t                          |Circuit 2: sram6t
  ---------------------------------------------------------------------------------------
  Net: WL                                    |Net: WL
    sky130_fd_pr__pfet_01v8/(1|3) = 4        |  sky130_fd_pr__nfet_01v8/2 = 2
    sky130_fd_pr__pfet_01v8/4 = 2            |
    sky130_fd_pr__nfet_01v8/(1|3) = 4        |
    sky130_fd_pr__nfet_01v8/4 = 2            |
    sky130_fd_pr__cap_var_lvt/2 = 1          |
    sky130_fd_pr__cap_var_lvt/(1|3) = 1      |
                                             |
  Net: a_145_458#                            |Net: QB
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/2 = 1
    sky130_fd_pr__nfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 2
    sky130_fd_pr__cap_var_lvt/(1|3) = 1      |  sky130_fd_pr__pfet_01v8/2 = 1
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
  Net: a_595_676#                            |Net: BLB
    sky130_fd_pr__pfet_01v8/2 = 1            |  sky130_fd_pr__nfet_01v8/(1|3) = 1
                                             |