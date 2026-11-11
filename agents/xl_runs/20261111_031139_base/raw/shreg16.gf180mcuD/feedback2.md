Judge:
  FAIL DRC      4204 violation(s): 2048 x Only 45 degrees allowed on transistors (PL.6); 870 x Varactor length and width < 1um (DF.1c); 305 x Metal1 minimum area < 0.1444um^2 (M1.3); 228 x Diffusion minimum area < 0.2025um^2 (DF.9); 176 x Metal1 spacing < 0.23um (M1.2a); 129 x N-well overlap of P-Diffusion < 0.43um (DF.7)
  FAIL DRC2     foundry KLayout deck: 3824 violation(s): 960 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm; 672 x CO.11: CO.11 : Contact on field oxide is forbidden; 304 x M1.3: M1.3 : Minimum metal1 area : 0.1444µm²; 160 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 160 x NP.5b: NP.5b : Extension beyond COMP for the COMP
                  (1) inside LVPWELL (2); 160 x NP.5dii: NP.5dii : Extension beyond COMP: For Outside DNWELL, inside Nwell:
              
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 3/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/shreg16.gf180mcuD/a2/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     384.16 x 26.20 = 10065.0 um2, budget 3299, reference 1649.42

Tool report:
DRC (magic drc(full)): 4204 violation(s), boxes in um
  2048 x Only 45 degrees allowed on transistors (PL.6)   e.g. at (4.055 24.355 4.060 24.360)  (4.340 24.355 4.345 24.360)  (4.060 24.180 4.065 24.185)
   870 x Varactor length and width < 1um (DF.1c)   e.g. at (1.340 19.820 1.560 20.180)  (1.560 19.820 2.060 20.180)  (1.060 20.580 1.340 20.820)
   305 x Metal1 minimum area < 0.1444um^2 (M1.3)   e.g. at (4.020 22.910 4.380 23.270)  (10.020 22.910 10.380 23.270)  (13.020 22.910 13.380 23.270)
   228 x Diffusion minimum area < 0.2025um^2 (DF.9)   e.g. at (1.060 19.820 1.340 20.180)  (4.060 19.820 4.340 20.180)  (7.060 20.340 7.340 20.360)
   176 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (4.020 24.435 4.085 24.530)  (4.020 24.370 4.085 24.435)  (4.315 24.435 4.380 24.530)
   129 x N-well overlap of P-Diffusion < 0.43um (DF.7)   e.g. at (0.000 24.115 0.430 24.180)  (0.000 23.885 0.430 24.115)  (0.000 23.820 0.430 23.885)
    96 x N-well overlap of N-Ohmic < 0.12um (DF.4a)   e.g. at (0.000 2.115 0.120 2.180)  (0.000 1.960 0.120 2.115)  (0.000 1.820 0.120 1.960)
    80 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (4.085 24.520 4.315 24.585)  (4.085 24.515 4.150 24.580)  (4.085 24.515 4.150 24.585)
    80 x Diffusion spacing < 0.28um (DF.3a)   e.g. at (21.180 24.340 21.300 24.460)  (45.180 24.340 45.300 24.460)  (69.180 24.340 69.300 24.460)
    64 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (21.385 24.050 21.525 24.115)  (21.460 24.050 21.525 24.115)  (21.385 23.975 21.450 24.040)
    48 x Diffusion contact width < 0.23um (CO.1 + 2 * CO.6)   e.g. at (4.085 24.585 4.315 24.665)  (28.085 24.585 28.315 24.665)  (52.085 24.585 52.315 24.665)
    48 x Metal1 width < 0.23um (M1.1)   e.g. at (1.085 6.000 1.200 6.115)  (4.200 6.000 4.315 6.115)  (7.085 6.000 7.200 6.115)
DRC2 (foundry KLayout deck): 3824 violation(s), boxes in um
   960 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (370.339 19.479 370.501 20.521)  (367.339 19.479 367.501 20.521)  (363.674 24.179 364.061 24.341)
   672 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (349.090 1.160 349.310 1.380)  (352.090 1.160 352.310 1.380)  (373.090 1.160 373.310 1.380)
   304 x M1.3: M1.3 : Minimum metal1 area : 0.1444µm²   e.g. at (301.020 1.090 301.380 1.450)  (304.020 1.090 304.380 1.450)  (325.020 1.090 325.380 1.450)
   160 x CO.1: CO.1 : Min/max contact size. : 0.22µm   e.g. at (367.310 18.980 367.310 19.380)  (367.090 18.980 367.090 19.380)  (343.090 18.980 343.090 19.380)
   160 x NP.5b: NP.5b : Extension beyond COMP for the COMP
                  (1) inside LVPWELL (2) outside Nwell and DNWELL. : 0.16µm   e.g. at (193.060 5.660 193.340 5.660)  (199.060 5.660 199.340 5.660)  (217.060 5.660 217.340 5.660)
   160 x NP.5dii: NP.5dii : Extension beyond COMP: For Outside DNWELL, inside Nwell:
                    (ii) For Nwell overlap of Nplus >= 0.43um. : 0.02µm   e.g. at (193.040 5.660 193.360 5.660)  (199.040 5.660 199.360 5.660)  (217.040 5.660 217.360 5.660)
   128 x DF.9: DF.9 : Min. COMP area (um2). : 0.2025µm²   e.g. at (202.060 5.820 202.340 6.180)  (226.060 5.820 226.340 6.180)  (250.060 5.820 250.340 6.180)
   112 x DF.3b: DF.3b : Min./Max. NCOMP Space to PCOMP in the same well for butted COMP
                  (MOSCAP butting is not allowed): 0 um   e.g. at (192.700 1.660 193.300 1.800)  (216.700 1.660 217.300 1.800)  (240.700 1.660 241.300 1.800)
   112 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (196.020 5.270 196.380 5.450)  (292.315 1.630 292.599 1.700)  (219.801 24.300 220.085 24.370)
   112 x NP.3d: NP.3d : Min/max space to a butted PCOMP: 0um   e.g. at (192.700 1.660 193.300 1.800)  (216.700 1.660 217.300 1.800)  (240.700 1.660 241.300 1.800)
   112 x NP.3e: NP.3e : Space to related PCOMP edge adjacent to a butting edge: 0um   e.g. at (192.700 1.660 193.300 1.800)  (216.700 1.660 217.300 1.800)  (240.700 1.660 241.300 1.800)
   112 x PP.3d: PP.3d : Min/max space to a butted NCOMP: 0um   e.g. at (192.700 1.660 193.300 1.800)  (216.700 1.660 217.300 1.800)  (240.700 1.660 241.300 1.800)
LVS: Top level cell failed pin matching.   devices layout/ref 3/352, nets layout/ref 3/212
  pfet_03v3 (4->2)                           |pfet_03v3 (11) **Mismatch**
  cap_nmos_03v3_b (4->1)                     |(no matching element)
  (no matching element)                      |nfet_03v3 (11)
  Number of devices: 3 **Mismatch**          |Number of devices: 22 **Mismatch**
  Number of nets: 4 **Mismatch**             |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dff                             |Circuit 2: dff
  ---------------------------------------------------------------------------------------
  Net: w_0_0#                                |Net: VSS
    pfet_03v3/(1|3) = 4                      |  nfet_03v3/(1|3) = 7
    pfet_03v3/4 = 2                          |  nfet_03v3/4 = 11
    cap_nmos_03v3_b/2 = 1                    |
                                             |
  Net: a_3168_4684#                          |Net: VDD
    pfet_03v3/2 = 1                          |  pfet_03v3/(1|3) = 7
                                             |  pfet_03v3/4 = 11
                                             |
  Net: a_768_4684#                           |Net: CK
    pfet_03v3/2 = 1                          |  nfet_03v3/2 = 3
                                             |  pfet_03v3/2 = 3
                                             |
  Net: a_768_320#                            |Net: CKB
    cap_nmos_03v3_b/1 = 1                    |  nfet_03v3/(1|3) = 1
                                             |  nfet_03v3/2 = 2
                                             |  pfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 2
                                             |
  (no matching net)                          |Net: mb
                                             |  nfet_03v3/2 = 2
                                             |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 2
                                             |  pfet_03v3/(1|3) = 1
                                             |
  (no matching net)                          |Net: m
                                             |  nfet_03v3/(1|3) = 2
                                             |  nfet_03v3/2 = 1
                                             |  pfet_03v3/(1|3) = 2
                                             |  pfet_03v3/2 = 1
                                             |