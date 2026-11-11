Judge:
  FAIL DRC      546 violation(s): 165 x N-Diffusion overlap of contact < 0.065um (CO.4); 150 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6); 108 x P-Diffusion overlap of contact < 0.065um (CO.4); 93 x Metal1 spacing < 0.23um (M1.2a); 8 x Poly overlap of contact < 0.065um (CO.3); 7 x Metal1 minimum area < 0.1444um^2 (M1.3)
  FAIL DRC2     foundry KLayout deck: 586 violation(s): 72 x NP.5b: NP.5b : Extension beyond COMP for the COMP
                  (1) inside LVPWELL (2); 69 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 60 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm; 60 x CO.7: CO.7 : Space from COMP contact to Poly2 : 0.15µm; 60 x DF.6_LV: DF.6_LV : Min. COMP extend beyond gate (it also means source/drain overhang). : 0; 48 x PP.5b: PP.5b : Extension beyond COMP for COMP
                 (1) Inside NWELL (2) outsid
  FAIL LVS      Netlists do not match.  (devices layout/ref 9/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a3/judge/ota_miller.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  ok   area     90.20 x 21.19 = 1911.3 um2, budget 2901, reference 1450.07

Tool report:
magic DRC: 546 violation(s)
   165 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (-0.005 6.050 0.065 6.115)  (0.000 6.050 0.065 6.115)  (-0.005 5.885 0.060 6.115)
   150 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (15.150 15.885 15.290 16.260)  (16.010 16.115 16.150 16.260)  (16.155 15.885 16.295 16.115)
   108 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (14.915 16.050 14.985 16.115)  (14.920 16.050 14.985 16.115)  (14.915 15.885 14.980 16.115)
    93 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (16.370 16.170 16.385 16.400)  (20.850 16.170 20.865 16.400)  (24.830 16.170 24.845 16.400)
     8 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (54.265 10.550 54.495 10.615)  (61.905 10.550 62.135 10.615)  (54.265 10.385 54.330 10.615)
     7 x Metal1 minimum area < 0.1444um^2 (M1.3)   e.g. at (53.250 10.615 53.590 10.670)  (53.200 10.385 53.305 10.615)  (53.250 10.330 53.590 10.385)
     6 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)   e.g. at (64.600 19.400 80.400 19.600)  (64.600 0.400 64.800 19.600)  (64.600 0.400 80.400 0.600)
     3 x Diffusion minimum area < 0.2025um^2 (DF.9)   e.g. at (53.200 10.615 53.640 10.720)  (53.200 10.385 53.305 10.615)  (53.200 10.280 53.640 10.385)
     3 x N-well overlap of P-Diffusion < 0.43um (DF.7)   e.g. at (14.915 15.885 14.920 16.115)  (19.395 15.885 19.400 16.115)  (23.875 15.885 23.880 16.115)
     2 x N-well spacing < 0.6um (NW.2a)   e.g. at (18.970 13.570 19.430 18.430)  (23.450 13.570 23.910 18.430)
     1 x Minimum PPLUS area >= 0.35um^2 (PP.8a)   e.g. at (53.180 10.260 53.660 10.740)
KLayout deck DRC: 586 violation(s)
    72 x NP.5b: NP.5b : Extension beyond COMP for the COMP
                  (1) inside LVPWELL (2) outside Nwell and DNWELL. : 0.16µm   e.g. at (0.000 4.000 0.000 8.000)  (0.000 4.000 0.960 4.000)  (0.960 4.000 0.960 8.000)
    69 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (4.500 6.088 4.715 6.252)  (4.500 5.830 4.660 6.170)  (4.445 6.088 4.660 6.252)
    60 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm   e.g. at (22.599 15.819 22.601 16.181)  (26.359 15.819 26.361 16.181)  (49.719 4.819 49.721 5.181)
    60 x CO.7: CO.7 : Space from COMP contact to Poly2 : 0.15µm   e.g. at (32.050 15.740 32.060 16.260)  (36.030 4.740 36.040 5.260)  (12.400 4.740 12.410 5.260)
    60 x DF.6_LV: DF.6_LV : Min. COMP extend beyond gate (it also means source/drain overhang). : 0.24µm   e.g. at (31.320 13.931 31.550 18.069)  (20.630 13.931 20.860 18.069)  (22.370 13.931 22.600 18.069)
    48 x PP.5b: PP.5b : Extension beyond COMP for COMP
                 (1) Inside NWELL (2) outside LVPWELL but inside DNWELL. : 0.16µm   e.g. at (14.920 14.000 14.920 18.000)  (14.920 18.000 16.380 18.000)  (16.380 14.000 16.380 18.000)
    48 x PP.5dii: PP.5dii : Extension beyond COMP: For Outside DNWELL
                     (ii) For Pplus to NWELL space < 0.43um for Pfield or LVPWELL tap. :    e.g. at (14.920 14.000 14.920 18.000)  (14.920 14.000 16.380 14.000)  (16.380 14.000 16.380 18.000)
    36 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm   e.g. at (49.719 3.999 51.181 4.001)  (46.979 5.999 48.441 6.001)  (43.499 5.999 44.961 6.001)
    30 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (0.370 3.550 0.590 3.770)  (1.610 3.550 1.830 3.770)  (3.850 3.550 4.070 3.770)
    24 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (14.919 17.999 16.381 18.001)  (19.399 13.999 20.861 14.001)  (21.139 17.999 22.601 18.001)
    13 x NP.2: NP.2 : min. nplus spacing : 0.4µm   e.g. at (46.700 4.000 46.980 6.000)  (41.480 4.000 41.760 6.000)  (38.000 4.000 38.280 6.000)
    12 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwell): 20um   e.g. at (14.920 14.000 16.380 18.000)  (16.660 14.000 18.120 18.000)  (19.400 14.000 20.860 18.000)
LVS: Netlists do not match.   devices layout/ref [9, 10]  nets layout/ref [22, 10]
  (no matching element)                      |ppolyf_u (1)
  Number of devices: 9 **Mismatch**          |Number of devices: 10 **Mismatch**
  Number of nets: 22 **Mismatch**            |Number of nets: 10 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: ota_miller                      |Circuit 2: ota_miller
  ---------------------------------------------------------------------------------------
  Net: x                                     |Net: x
    cap_mim_2f0_m4m5_noshield/2 = 1          |  ppolyf_u/(1|2) = 1
                                             |  cap_mim_2f0_m4m5_noshield/1 = 1
                                             |
  Net: INN                                   |Net: INN
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/2 = 1
                                             |
  Net: d1_uq2                                |Net: INP
    pfet_03v3/(1|3) = 2                      |  nfet_03v3/2 = 1
                                             |
  Net: VSS_uq2                               |Net: IB
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 1
                                             |  nfet_03v3/2 = 3
                                             |
  Net: IB_uq4                                |Net: d1
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 2
                                             |
  Net: d2                                    |Net: d2
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 1
                                             |  ppolyf_u/(1|2) = 1
                                             |
  Net: VSS                                   |Net: VSS
    nfet_03v3/4 = 5                          |  nfet_03v3/4 = 5
                                             |  nfet_03v3/(1|3) = 3
                                             |  ppolyf_u/3 = 1
                                             |
  Net: d2_uq2                                |Net: tail
    pfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 3
                                             |