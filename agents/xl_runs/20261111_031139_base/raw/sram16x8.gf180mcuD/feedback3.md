Judge:
  FAIL DRC      34040 violation(s): 7040 x N-Diffusion overlap of contact < 0.065um (CO.4); 4640 x N-Diffusion spacing to N-well < 0.43um (DF.8); 3200 x Varactor length and width < 1um (DF.1c); 2464 x Poly spacing to diffusion < 0.1um (PL.5a); 2192 x N-well overlap of N-Ohmic < 0.12um (DF.4a); 2080 x Diffusion contact width < 0.23um (CO.1 + 2 * CO.6)
  FAIL DRC2     foundry KLayout deck: 8272 violation(s): 768 x V1.3a: V1.3a : metal1 overlap of via1 >= 0; 768 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 768 x NP.3a: NP.3a : Space to PCOMP for PCOMP:
                  (1) Inside Nwell (2) Outside LV; 768 x NP.3ci: NP.3ci : Space to PCOMP: For Outside DNWELL:
                   (i) For PCOMP spac; 768 x PP.3cii: PP.3cii : Space to NCOMP: For Outside DNWELL, inside Nwell:
                     ; 512 x DF.14_LV: DF.14_LV : Max distance of substrate tap (PCOMP outside Nwell) from (NCOMP outsi
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 772/768; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/sram16x8.gf180mcuD/a3/judge/sram16x8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     41.04 x 88.83 = 3645.6 um2, budget 7253, reference 3626.29

Tool report:
DRC (magic drc(full)): 34040 violation(s), boxes in um
  7040 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (1.060 79.895 1.130 79.960)  (1.130 79.830 1.195 79.895)  (1.060 79.895 1.125 79.960)
  4640 x N-Diffusion spacing to N-well < 0.43um (DF.8)   e.g. at (3.950 79.020 4.040 80.400)  (4.320 79.020 4.380 80.400)  (3.950 78.740 4.040 79.020)
  3200 x Varactor length and width < 1um (DF.1c)   e.g. at (1.400 78.740 1.680 79.020)  (1.680 78.740 2.130 79.020)  (1.130 79.665 1.335 79.740)
  2464 x Poly spacing to diffusion < 0.1um (PL.5a)   e.g. at (0.720 80.340 0.760 80.400)  (0.720 80.340 0.760 80.400)  (2.680 80.340 2.720 80.400)
  2192 x N-well overlap of N-Ohmic < 0.12um (DF.4a)   e.g. at (1.130 79.895 1.250 80.400)  (1.130 79.665 1.250 79.895)  (1.130 79.020 1.250 79.665)
  2080 x Diffusion contact width < 0.23um (CO.1 + 2 * CO.6)   e.g. at (1.125 79.665 1.135 79.895)  (1.335 79.665 1.365 79.895)  (2.675 78.770 2.685 78.990)
  2048 x Metal1 overlap of Via1 < 0.06um in one direction (V1.3)   e.g. at (0.210 77.070 0.270 77.130)  (0.530 77.070 0.590 77.130)  (4.130 77.070 4.190 77.130)
  1664 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6)   e.g. at (1.125 79.665 1.335 79.895)  (1.135 79.665 1.335 79.895)  (6.255 79.665 6.465 79.895)
  1536 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (3.010 76.800 3.155 76.875)  (4.385 76.645 4.405 76.875)  (3.935 76.520 3.950 76.665)
  1536 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (4.205 78.195 4.260 78.480)  (9.335 78.195 9.390 78.480)  (14.465 78.195 14.520 78.480)
  1160 x n-ohmic spacing to PMOS gate < 0.32um (NP.4b + PP.4c)   e.g. at (1.360 80.140 1.400 80.400)  (6.490 80.140 6.530 80.400)  (11.620 80.140 11.660 80.400)
  1024 x Metal2 overlap of Via1 < 0.01um (V1.4)   e.g. at (4.720 78.070 4.980 78.080)  (4.720 77.820 4.730 78.080)  (4.720 77.820 4.980 77.830)
DRC2 (foundry KLayout deck): 8272 violation(s), boxes in um
   768 x V1.3a: V1.3a : metal1 overlap of via1 >= 0   e.g. at (35.500 66.780 35.760 66.925)  (40.630 66.780 40.890 66.925)  (35.500 70.980 35.760 71.125)
   768 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (34.810 74.941 34.985 75.145)  (34.810 69.421 34.985 69.625)  (39.940 86.415 40.115 86.619)
   768 x NP.3a: NP.3a : Space to PCOMP for PCOMP:
                  (1) Inside Nwell (2) Outside LVPWELL but inside DNWELL. : 0.16µm   e.g. at (37.470 86.354 37.590 88.306)  (37.470 72.254 37.590 74.806)  (32.340 86.354 32.460 88.306)
   768 x NP.3ci: NP.3ci : Space to PCOMP: For Outside DNWELL:
                   (i) For PCOMP space to Nwell < 0.43um. : 0.16µm   e.g. at (37.470 86.354 37.590 88.306)  (37.470 72.254 37.590 74.806)  (32.340 86.354 32.460 88.306)
   768 x PP.3cii: PP.3cii : Space to NCOMP: For Outside DNWELL, inside Nwell:
                     (ii) NWELL Overlap of NCOMP 0.43um. : 0.16µm   e.g. at (32.180 85.592 32.240 86.608)  (37.310 80.072 37.370 81.088)  (39.530 81.672 39.590 82.680)
   512 x DF.14_LV: DF.14_LV : Max distance of substrate tap (PCOMP outside Nwell) from (NCOMP outside Nwell): 20um   e.g. at (31.180 66.840 31.540 71.640)  (31.820 66.840 31.910 71.640)  (34.730 66.840 34.820 71.640)
   512 x DF.16_LV: DF.16_LV : Min. space from (Nwell outside DNWELL) to (NCOMP outside Nwell and DNWELL). : 0.43µm   e.g. at (16.520 38.810 16.520 44.470)  (19.340 44.330 19.340 49.990)  (11.390 44.330 11.390 49.990)
   512 x PL.5a_LV: PL.5a_LV : Space from field Poly2 to unrelated COMP Spacer from field Poly2 to Guard-ring. : 0.1µm   e.g. at (38.310 81.960 38.370 82.400)  (40.170 81.960 40.230 82.400)  (38.310 76.440 38.370 76.880)
   512 x PL.5b_LV: PL.5b_LV : Space from field Poly2 to related COMP. : 0.1µm   e.g. at (38.310 81.960 38.370 82.400)  (40.170 81.960 40.230 82.400)  (38.310 76.440 38.370 76.880)
   512 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (37.369 80.372 37.591 80.788)  (39.309 81.972 39.531 82.388)  (39.309 78.574 39.471 79.186)
   256 x V1.4a: V1.4a : metal2 overlap of via1 >= 0.01 upper_metal   e.g. at (25.240 44.700 25.500 44.960)  (30.370 44.700 30.630 44.960)  (35.500 44.700 35.760 44.960)
   256 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm   e.g. at (21.559 53.056 21.591 53.404)  (21.559 47.536 21.591 47.884)  (31.819 47.536 31.851 47.884)
LVS: Top level cell failed pin matching.   devices layout/ref 772/768, nets layout/ref 260/290
  nfet_03v3 (768->258)                       |nfet_03v3 (512) **Mismatch**
  pfet_03v3 (512->257)                       |pfet_03v3 (256) **Mismatch**
  cap_nmos_03v3_b (512->257)                 |(no matching element)
  Number of devices: 772 **Mismatch**        |Number of devices: 768 **Mismatch**
  Number of nets: 260 **Mismatch**           |Number of nets: 290 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: sram16x8                        |Circuit 2: sram16x8
  ---------------------------------------------------------------------------------------
  Net: WL9                                   |Net: WL9
    nfet_03v3/2 = 2                          |  nfet_03v3/2 = 16
    nfet_03v3/(1|3) = 515                    |
    pfet_03v3/(1|3) = 513                    |
    pfet_03v3/2 = 1                          |
    pfet_03v3/4 = 257                        |
    cap_nmos_03v3_b/1 = 1                    |
    cap_nmos_03v3_b/2 = 257                  |
                                             |
  Net: VSUBS                                 |Net: VDD
    nfet_03v3/4 = 258                        |  pfet_03v3/(1|3) = 256
                                             |  pfet_03v3/4 = 256
                                             |
  Net: /CELL_84/a_536_120#                   |Net: BL0
    pfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 16
                                             |
  Net: /CELL_84/a_864_120#                   |Net: BLB0
    nfet_03v3/(1|3) = 1                      |  nfet_03v3/(1|3) = 16
                                             |
  Net: /CELL_84/a_492_952#                   |Net: BL1
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 16
    cap_nmos_03v3_b/1 = 1                    |
    nfet_03v3/2 = 1                          |
                                             |
  Net: /CELL_84/a_164_632#                   |Net: BLB1
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 16
    nfet_03v3/2 = 1                          |
    cap_nmos_03v3_b/1 = 1                    |
                                             |
  Net: /CELL_62/a_492_952#                   |Net: BL2
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 16