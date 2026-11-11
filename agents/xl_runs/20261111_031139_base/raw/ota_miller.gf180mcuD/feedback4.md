Judge:
  FAIL DRC      110 violation(s): 79 x Metal1 spacing < 0.23um (M1.2a); 8 x Poly overlap of contact < 0.065um (CO.3); 6 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3); 5 x Metal5 width < 0.44um (MT.1); 4 x N-well spacing < 0.6um (NW.2a); 4 x Metal1 minimum area < 0.1444um^2 (M1.3)
  FAIL DRC2     foundry KLayout deck: 188 violation(s): 32 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm; 28 x CO.11: CO.11 : Contact on field oxide is forbidden; 27 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 24 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm; 12 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwe; 12 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [
  FAIL LVS      Netlists do not match.  (devices layout/ref 29/10; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/ota_miller.gf180mcuD/a4/judge/ota_miller.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     103.20 x 38.54 = 3977.3 um2, budget 2901, reference 1450.07

Tool report:
magic DRC: 110 violation(s)
    79 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (26.585 21.800 26.620 21.885)  (26.585 21.885 26.620 22.115)  (26.585 22.115 26.620 22.430)
     8 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (65.265 10.550 65.495 10.615)  (72.905 10.550 73.135 10.615)  (65.265 10.385 65.330 10.615)
     6 x Bottom plate overlap of MiM cap < 0.6um (MIMTM.3)   e.g. at (75.600 19.400 80.400 19.600)  (75.600 0.400 75.800 19.600)  (75.600 0.400 80.400 0.600)
     5 x Metal5 width < 0.44um (MT.1)   e.g. at (75.150 0.000 75.190 0.390)  (75.590 -0.010 75.630 0.000)  (75.190 0.390 75.200 0.430)
     4 x N-well spacing < 0.6um (NW.2a)   e.g. at (16.870 19.570 17.330 24.430)  (19.770 19.570 20.230 24.430)  (22.670 19.570 23.130 24.430)
     4 x Metal1 minimum area < 0.1444um^2 (M1.3)   e.g. at (0.385 11.885 0.615 12.115)  (0.385 3.885 0.615 4.115)  (96.085 25.885 96.315 26.115)
     3 x Diffusion minimum area < 0.2025um^2 (DF.9)   e.g. at (63.700 10.615 64.140 10.720)  (63.700 10.385 63.805 10.615)  (63.700 10.280 64.140 10.385)
     1 x Minimum PPLUS area >= 0.35um^2 (PP.8a)   e.g. at (63.680 10.260 64.160 10.740)
KLayout deck DRC: 188 violation(s)
    32 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm   e.g. at (60.684 7.999 62.016 8.161)  (60.684 5.839 62.016 6.001)  (51.084 5.839 52.416 6.001)
    28 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (0.590 5.550 0.810 5.770)  (2.990 5.550 3.210 5.770)  (5.640 5.550 5.860 5.770)
    27 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (26.390 21.678 26.585 22.322)  (3.725 10.445 3.885 11.075)  (3.800 10.696 3.885 11.354)
    24 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (17.584 19.839 18.916 20.001)  (20.484 23.999 21.816 24.161)  (26.284 19.839 27.116 20.001)
    12 x DF.13_LV: DF.13_LV : Max distance of Nwell tap (NCOMP inside Nwell) from (PCOMP inside Nwell): 20um   e.g. at (14.400 20.000 16.300 24.000)  (17.300 20.000 19.200 24.000)  (20.200 20.000 22.100 24.000)
    12 x MIMTM.2: MIMTM.2 : Minimum MiM bottom plate overlap of Vian-1 layer.
                    [This is applicable for Vian-1 within 1.06um oversize of Fuse   e.g. at (75.199 0.059 75.261 0.716)  (75.189 0.319 75.521 0.391)  (75.519 -0.011 75.591 0.321)
    12 x NP.2: NP.2 : min. nplus spacing : 0.4µm   e.g. at (52.860 5.840 53.040 8.160)  (50.460 5.840 50.640 8.160)  (57.660 5.840 57.840 8.160)
     7 x DF.14_LV: DF.14_LV : Max distance of substrate tap (PCOMP outside Nwell) from (NCOMP outside Nwell): 20um   e.g. at (41.200 6.000 43.100 8.000)  (12.000 6.000 13.900 8.000)  (9.600 6.000 11.500 8.000)
     7 x PP.2: PP.2 : min. pplus spacing : 0.4µm   e.g. at (35.160 19.840 35.340 24.160)  (33.260 19.840 33.440 24.160)  (31.360 19.840 31.540 24.160)
     4 x M1.3: M1.3 : Minimum metal1 area : 0.1444µm²   e.g. at (0.385 3.885 0.615 4.115)  (96.085 3.885 96.315 4.115)  (0.385 11.885 0.615 12.115)
     4 x NW.2b_LV: NW.2b_LV : Min. Nwell Space (Outside DNWELL) [Different potential]: 1.4µm.   e.g. at (25.429 19.569 25.571 24.431)  (22.529 19.569 22.671 24.431)  (16.729 19.569 16.871 24.431)
     4 x PP.5di: PP.5di : Extension beyond COMP: For Outside DNWELL
                    (i) For Pplus to NWELL space >= 0.43um for Pfield or LVPWELL tap. : 0.0   e.g. at (63.700 10.280 63.700 10.720)  (63.700 10.720 64.140 10.720)  (64.140 10.280 64.140 10.720)
LVS: Netlists do not match.   devices layout/ref [29, 10]  nets layout/ref [63, 10]
  nfet_03v3 (16)                             |nfet_03v3 (18->5) **Mismatch**
  pfet_03v3 (12)                             |pfet_03v3 (12->3) **Mismatch**
  cap_mim_2f0_m4m5_noshield (1)              |cap_mim_2f0_m4m5_noshield (1)
  (no matching element)                      |ppolyf_u (1)
  Number of devices: 29 **Mismatch**         |Number of devices: 10 **Mismatch**
  Number of nets: 63 **Mismatch**            |Number of nets: 10 **Mismatch**
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
  Net: INP                                   |Net: INP
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/2 = 1
                                             |
  Net: IB_uq3                                |Net: IB
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 1
                                             |  nfet_03v3/2 = 3
                                             |
  Net: d1                                    |Net: d1
    pfet_03v3/(1|3) = 2                      |  pfet_03v3/(1|3) = 1
                                             |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 2
                                             |
  Net: IB_uq13                               |Net: d2
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 1
                                             |  pfet_03v3/(1|3) = 1
                                             |  pfet_03v3/2 = 1
                                             |  ppolyf_u/(1|2) = 1
                                             |
  Net: VSS                                   |Net: VSS
    nfet_03v3/4 = 16                         |  nfet_03v3/4 = 5
    nfet_03v3/(1|3) = 2                      |  nfet_03v3/(1|3) = 3
                                             |  ppolyf_u/3 = 1
                                             |