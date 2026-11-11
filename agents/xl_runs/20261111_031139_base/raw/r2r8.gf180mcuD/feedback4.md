Judge:
  FAIL DRC      1384 violation(s): 680 x Metal1 overlap of contact < 0.055um in one direction (CO.6); 402 x Poly overlap of contact < 0.065um (CO.3); 114 x Metal1 overlap of Via1 < 0.06um in one direction (V1.3); 51 x ppolyres minimum width < 0.8um (PRES.1); 51 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7); 43 x Metal1 minimum area < 0.1444um^2 (M1.3)
  FAIL DRC2     foundry KLayout deck: 461 violation(s): 50 x CO.6b: CO.6b : Adjacent metal1 edge overlap : 0.06µm; 50 x PP.9: PP.9 : Overlap of unsalicided Poly2. : 0.18µm; 50 x PRES.5: PRES.5 : Minimum Plus implant overlap of Poly2 resistor: 0.3µm; 50 x PRES.7: PRES.7 : Minimum space from salicide block to contact on Poly2 resistor: 0.22.um; 50 x SB.4: SB.4 : Space from salicide block to contact: 0.15 um; 50 x SB.8: SB.8 : Non-salicided contacts are forbidden.
  FAIL LVS      Top level cell failed pin matching.  (devices layout/ref 1/16; report /home/ibrahim/claude-workspace/icdsl/agents/xl_runs/20261111_031139_base/raw/r2r8.gf180mcuD/a4/judge/r2r8.lvs.txt)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     203.54 x 19.96 = 4062.7 um2, budget 1705, reference 852.06

Tool report:
magic DRC: 1384 violation(s)
   680 x Metal1 overlap of contact < 0.055um in one direction (CO.6)   e.g. at (-0.500 0.060 -0.445 0.115)  (-0.215 0.060 -0.160 0.115)  (-0.500 0.060 -0.445 0.115)
   402 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (-0.510 0.115 -0.150 0.180)  (0.150 0.115 0.510 0.180)  (-0.510 0.115 -0.445 0.180)
   114 x Metal1 overlap of Via1 < 0.06um in one direction (V1.3)   e.g. at (23.810 0.115 23.870 0.130)  (23.810 0.070 23.870 0.115)  (24.130 0.115 24.190 0.130)
    51 x ppolyres minimum width < 0.8um (PRES.1)   e.g. at (-0.445 -0.115 -0.215 0.115)  (0.215 -0.115 0.445 0.115)  (7.555 -0.115 7.785 0.115)
    51 x Unsalicided resistor spacing to poly contact must be 0.22um (PRES/LRES/HRES.7)   e.g. at (-0.440 -0.110 -0.220 0.110)  (0.220 -0.110 0.440 0.110)  (7.560 -0.110 7.780 0.110)
    43 x Metal1 minimum area < 0.1444um^2 (M1.3)   e.g. at (0.215 -0.115 0.445 0.115)  (7.555 -0.115 7.785 0.115)  (8.215 -0.115 8.445 0.115)
    24 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (23.870 -0.115 24.015 0.130)  (23.985 0.115 24.130 0.130)  (24.215 -0.115 24.360 0.115)
    17 x rpp spacing to Cont < 0.215um (PRES.7 - CO.6)   e.g. at (31.785 0.115 32.000 0.330)  (31.785 -0.115 32.000 0.115)  (55.785 0.115 56.000 0.330)
     2 x Metal1 width < 0.23um (M1.1)   e.g. at (-0.560 -4.370 -0.445 -4.270)  (-0.560 -4.385 -0.445 -4.370)
KLayout deck DRC: 461 violation(s)
    50 x CO.6b: CO.6b : Adjacent metal1 edge overlap : 0.06µm   e.g. at (111.560 -0.110 111.780 0.110)  (104.220 -0.110 104.440 0.110)  (103.560 -0.110 103.780 0.110)
    50 x PP.9: PP.9 : Overlap of unsalicided Poly2. : 0.18µm   e.g. at (92.699 -0.680 92.721 0.680)  (99.279 -0.680 99.301 0.680)  (84.699 -0.680 84.721 0.680)
    50 x PRES.5: PRES.5 : Minimum Plus implant overlap of Poly2 resistor: 0.3µm   e.g. at (124.699 -0.801 124.701 0.801)  (147.299 -0.801 147.301 0.801)  (108.699 -0.801 108.701 0.801)
    50 x PRES.7: PRES.7 : Minimum space from salicide block to contact on Poly2 resistor: 0.22.um   e.g. at (111.560 -0.110 111.780 0.110)  (104.220 -0.110 104.440 0.110)  (103.560 -0.110 103.780 0.110)
    50 x SB.4: SB.4 : Space from salicide block to contact: 0.15 um   e.g. at (-0.440 -0.110 -0.220 0.110)  (0.220 -0.110 0.440 0.110)  (7.560 -0.110 7.780 0.110)
    50 x SB.8: SB.8 : Non-salicided contacts are forbidden.   e.g. at (-0.440 -0.110 -0.220 0.110)  (0.220 -0.110 0.440 0.110)  (7.560 -0.110 7.780 0.110)
    50 x SB.10: SB.10 : Poly2 extension beyond related salicide block. : 0.22µm   e.g. at (92.600 -0.684 92.720 0.684)  (99.280 -0.684 99.400 0.684)  (91.280 -0.684 91.400 0.684)
    43 x M1.3: M1.3 : Minimum metal1 area : 0.1444µm²   e.g. at (0.215 -0.115 0.445 0.115)  (7.555 -0.115 7.785 0.115)  (8.215 -0.115 8.445 0.115)
    25 x PRES.9a: PRES.9a : Pplus Poly2 resistor shall be covered by RES_MK marking.
                    RES_MK length shall be coincide with resistor length (   e.g. at (181.000 -0.500 187.000 0.500)  (29.000 -0.500 35.000 0.500)  (165.000 -0.500 171.000 0.500)
    16 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (96.115 -0.115 96.215 0.115)  (95.785 -0.115 95.885 0.115)  (192.115 -0.115 192.215 0.115)
    15 x CO.6a: CO.6a : Metal1 EOL overlap (<0.34µm lines) : 0.06µm   e.g. at (31.555 -0.110 31.560 0.110)  (32.440 -0.110 32.445 0.110)  (55.555 -0.110 55.560 0.110)
    10 x V1.3a: V1.3a : metal1 overlap of via1 >= 0   e.g. at (-8.130 -4.630 -7.870 -4.370)  (23.870 -0.130 24.130 0.130)  (47.870 -0.130 48.130 0.130)
LVS: Top level cell failed pin matching.   devices layout/ref [1, 16]  nets layout/ref [3, 17]
  ppolyf_u (25->1)                           |ppolyf_u (25->16) **Mismatch**
  Number of devices: 1 **Mismatch**          |Number of devices: 16 **Mismatch**
  Number of nets: 3 **Mismatch**             |Number of nets: 17 **Mismatch**
  ---------------------------------------------------------------------------------------
  NET mismatches: Class fragments follow (with fanout counts):
  Circuit 1: r2r8                            |Circuit 2: r2r8
  ---------------------------------------------------------------------------------------
  Net: a_7911_n23#                           |Net: B0
    ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                             |
  Net: a_8043_n23#                           |Net: B1
    ppolyf_u/(1|2) = 1                       |  ppolyf_u/(1|2) = 1
                                             |
  Net: VSUBS                                 |Net: B2
    ppolyf_u/3 = 1                           |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: B3
                                             |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: B4
                                             |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: B5
                                             |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: B6
                                             |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: B7
                                             |  ppolyf_u/(1|2) = 1
                                             |
  (no matching net)                          |Net: VSS
                                             |  ppolyf_u/(1|2) = 1
                                             |  ppolyf_u/3 = 16
                                             |
  (no matching net)                          |Net: n0
                                             |  ppolyf_u/(1|2) = 3
                                             |
  (no matching net)                          |Net: n1
                                             |  ppolyf_u/(1|2) = 3