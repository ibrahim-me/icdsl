Judge:
  FAIL DRC      11629 violation(s): 2208 x Metal1 spacing < 0.23um (M1.2a); 1504 x Varactor length and width < 1um (DF.1c); 1294 x P-Diffusion overlap of contact < 0.065um (CO.4); 1118 x Poly overhang of transistor < 0.22um (PL.4); 1087 x Poly overlap of contact < 0.065um (CO.3); 672 x Poly contact spacing to diffusion < 0.165um (CO.8 - 2 * CO.6)
  FAIL DRC2     foundry KLayout deck: 4322 violation(s): 1328 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 560 x CO.11: CO.11 : Contact on field oxide is forbidden; 464 x CO.2a: CO.2a : min. contact spacing : 0.25µm; 288 x CO.1: CO.1 : Min/max contact size. : 0.22µm; 224 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm; 208 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 38/352; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/shreg16.gf180mcuD/a4/judge/shreg16.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     208.00 x 14.12 = 2937.0 um2, budget 3299, reference 1649.42

Tool report:
DRC (magic drc(full)): 11629 violation(s), boxes in um
  2208 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (3.300 13.065 3.520 13.110)  (3.300 12.865 3.385 13.065)  (3.385 12.865 3.520 13.065)
  1504 x Varactor length and width < 1um (DF.1c)   e.g. at (11.400 12.860 11.640 13.020)  (11.640 12.860 12.360 13.020)  (11.400 13.075 11.405 13.080)
  1294 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (3.320 12.860 3.360 12.920)  (3.360 12.860 3.385 12.920)  (3.320 12.795 3.360 12.860)
  1118 x Poly overhang of transistor < 0.22um (PL.4)   e.g. at (11.140 13.080 11.360 13.240)  (11.140 13.020 11.360 13.080)  (11.140 12.860 11.360 13.020)
  1087 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (3.385 13.015 3.615 13.065)  (16.385 13.015 16.615 13.065)  (29.385 13.015 29.615 13.065)
   672 x Poly contact spacing to diffusion < 0.165um (CO.8 - 2 * CO.6)   e.g. at (3.450 12.860 3.615 13.025)  (16.450 12.860 16.615 13.025)  (29.450 12.860 29.615 13.025)
   544 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (11.385 13.240 11.400 13.305)  (11.385 13.240 11.405 13.305)  (24.385 13.240 24.400 13.305)
   528 x N-well overlap of P-Diffusion < 0.43um (DF.7)   e.g. at (11.570 12.140 11.640 12.860)  (11.640 12.795 12.000 12.860)  (11.640 12.565 11.795 12.795)
   448 x P-Ohmic overhang of Varactor < 0.32um (FIXME)   e.g. at (1.040 4.640 1.360 4.705)  (1.040 4.705 1.205 5.295)  (1.205 4.705 1.360 5.295)
   320 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6)   e.g. at (3.385 12.835 3.445 12.855)  (3.555 12.835 3.615 12.855)  (16.385 12.835 16.445 12.855)
   304 x N-Ohmic overhang of Varactor < 0.32um (FIXME)   e.g. at (11.400 13.305 11.705 13.400)  (11.405 13.080 11.705 13.305)  (24.400 13.305 24.705 13.400)
   256 x Diffusion contact width < 0.23um (CO.1 + 2 * CO.6)   e.g. at (3.385 13.065 3.615 13.095)  (11.405 13.080 11.615 13.305)  (11.385 13.305 11.400 13.310)
DRC2 (foundry KLayout deck): 4322 violation(s), boxes in um
  1328 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (196.508 8.690 196.902 8.800)  (202.615 9.115 202.710 9.380)  (195.750 9.115 195.890 9.200)
   560 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (185.390 0.880 185.610 1.100)  (189.390 0.810 189.610 1.100)  (191.390 0.880 191.610 1.100)
   464 x CO.2a: CO.2a : min. contact spacing : 0.25µm   e.g. at (189.610 1.228 189.800 1.412)  (185.145 12.790 185.445 12.840)  (195.440 12.430 195.660 12.570)
   288 x CO.1: CO.1 : Min/max contact size. : 0.22µm   e.g. at (200.200 8.710 200.200 9.290)  (199.980 8.710 199.980 9.290)  (202.200 8.710 202.200 9.290)
   224 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm   e.g. at (191.194 1.679 191.806 1.841)  (191.194 1.159 191.806 1.321)  (185.194 1.159 185.806 1.321)
   208 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (202.194 9.359 202.806 9.521)  (189.194 9.359 189.806 9.521)  (189.194 8.479 189.806 8.641)
   128 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm   e.g. at (111.359 0.810 111.641 1.314)  (124.359 0.810 124.641 1.314)  (137.359 0.810 137.641 1.314)
    96 x M1.1: M1.1 : min. metal1 width : 0.23µm   e.g. at (5.385 4.820 5.615 5.000)  (5.416 4.885 5.699 5.000)  (5.500 4.820 5.615 5.084)
    96 x PP.6: PP.6 : Overlap with PCOMP butted to NCOMP. : 0.22µm   e.g. at (186.910 5.340 188.090 5.360)  (169.910 4.640 171.090 4.660)  (186.910 4.640 188.090 4.660)
    80 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm   e.g. at (3.390 1.120 3.610 1.320)  (16.390 1.120 16.610 1.320)  (29.390 1.120 29.610 1.320)
    64 x CO.8: CO.8 : Space from Poly2 contact to COMP : 0.17µm   e.g. at (105.225 4.600 105.775 4.640)  (66.225 4.600 66.775 4.640)  (57.225 4.600 57.775 4.640)
    64 x DF.11: DF.11 : Min. Length of butting COMP edge. : 0.3µm   e.g. at (114.910 12.140 114.910 12.300)  (114.800 12.300 114.910 12.300)  (115.400 12.860 115.400 13.020)
LVS: Top level cell failed pin matching.   devices layout/ref 38/352, nets layout/ref 23/212
  nfet_03v3 (6->2)                           |nfet_03v3 (11) **Mismatch**
  pfet_03v3 (7->4)                           |pfet_03v3 (11) **Mismatch**
  cap_nmos_03v3_b (3->2)                     |(no matching element)
  Number of devices: 8 **Mismatch**          |Number of devices: 22 **Mismatch**
  Number of nets: 8 **Mismatch**             |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: dff                             |Circuit 2: dff
  ---------------------------------------------------------------------------------------
  Net: w_0_1400#                             |Net: n1
    nfet_03v3/(1|3) = 4                      |  nfet_03v3/(1|3) = 2
    nfet_03v3/4 = 2                          |
    nfet_03v3/2 = 1                          |
    pfet_03v3/(1|3) = 6                      |
    pfet_03v3/4 = 4                          |
    pfet_03v3/2 = 1                          |
    cap_nmos_03v3_b/2 = 2                    |
                                             |
  Net: a_1872_220#                           |Net: n2
    nfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 2
                                             |
  Net: a_1472_2384#                          |Net: n3
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 2
                                             |
  Net: a_1072_1684#                          |Net: n4
    pfet_03v3/2 = 1                          |  nfet_03v3/(1|3) = 2
                                             |
  Net: a_1128_1728#                          |Net: D
    pfet_03v3/(1|3) = 1                      |  nfet_03v3/2 = 1
                                             |  pfet_03v3/2 = 1
                                             |
  Net: a_982_1728#                           |Net: p1
    pfet_03v3/(1|3) = 1                      |  pfet_03v3/(1|3) = 2
                                             |
  Net: a_272_1720#                           |Net: p2
    cap_nmos_03v3_b/1 = 1                    |  pfet_03v3/(1|3) = 2
                                             |
  Net: a_2272_2384#                          |Net: p3
    pfet_03v3/2 = 1                          |  pfet_03v3/(1|3) = 2
    cap_nmos_03v3_b/1 = 1                    |