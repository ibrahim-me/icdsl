Judge:
  FAIL DRC      8890 violation(s): 1792 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6); 992 x P-Diffusion overlap of contact < 0.065um (CO.4); 910 x Varactor length and width < 1um (DF.1c); 832 x Poly overlap of contact < 0.065um (CO.3); 828 x Poly overhang of transistor < 0.22um (PL.4); 576 x N-Diffusion overlap of contact < 0.065um (CO.4)
  FAIL DRC2     foundry KLayout deck: 2962 violation(s): 576 x CO.11: CO.11 : Contact on field oxide is forbidden; 512 x CO.7: CO.7 : Space from COMP contact to Poly2 : 0.15µm; 368 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm; 224 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm; 192 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm; 176 x CO.2a: CO.2a : min. contact spacing : 0.25µm
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  ok   area     208.00 x 14.12 = 2937.0 um2, budget 3299, reference 1649.42

Tool report:
DRC (magic drc(full)): 8890 violation(s), boxes in um
  1792 x Diffusion contact spacing to poly < 0.145um (CO.7 - 2 * CO.6)   e.g. at (2.860 12.675 2.885 12.760)  (2.860 12.385 2.980 12.675)  (3.115 12.675 3.140 12.760)
   992 x P-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (2.820 12.860 2.860 12.920)  (2.860 12.905 2.885 12.920)  (2.860 12.860 2.885 12.905)
   910 x Varactor length and width < 1um (DF.1c)   e.g. at (1.640 8.820 1.960 8.885)  (1.960 8.820 2.360 8.885)  (1.640 8.885 1.665 9.115)
   832 x Poly overlap of contact < 0.065um (CO.3)   e.g. at (2.885 12.860 2.925 12.905)  (2.885 12.860 2.950 12.905)  (2.820 12.790 2.860 12.860)
   828 x Poly overhang of transistor < 0.22um (PL.4)   e.g. at (4.140 8.660 4.360 8.820)  (4.140 8.640 4.360 8.660)  (4.140 8.600 4.360 8.640)
   576 x N-Diffusion overlap of contact < 0.065um (CO.4)   e.g. at (10.795 12.550 10.865 12.615)  (10.800 12.550 10.865 12.615)  (10.795 12.385 10.860 12.615)
   542 x P-Ohmic overhang of Varactor < 0.32um (FIXME)   e.g. at (1.040 4.640 1.360 4.885)  (1.040 4.885 1.105 5.115)  (1.105 4.885 1.335 5.115)
   416 x Metal1 spacing < 0.23um (M1.2a)   e.g. at (1.580 9.115 1.650 9.200)  (3.080 9.180 3.150 9.200)  (4.580 9.180 4.650 9.200)
   368 x Poly contact spacing to diffusion < 0.165um (CO.8 - 2 * CO.6)   e.g. at (2.950 12.860 3.115 12.905)  (15.950 12.860 16.115 12.905)  (28.950 12.860 29.115 12.905)
   352 x N-well overlap of P-Diffusion < 0.43um (DF.7)   e.g. at (1.105 5.030 1.335 5.115)  (1.105 5.030 1.335 5.115)  (1.665 5.030 1.895 5.115)
   224 x Diffusion contact spacing < 0.24um (CO.2a - 2 * CO.6)   e.g. at (2.885 12.675 3.075 12.855)  (2.925 12.675 3.115 12.855)  (15.885 12.675 16.075 12.855)
   192 x N-Ohmic overhang of Varactor < 0.32um (FIXME)   e.g. at (4.040 8.660 4.360 8.820)  (4.040 8.820 4.360 8.885)  (4.040 8.885 4.105 9.115)
DRC2 (foundry KLayout deck): 2962 violation(s), boxes in um
   576 x CO.11: CO.11 : Contact on field oxide is forbidden   e.g. at (183.390 8.040 183.610 8.260)  (184.890 8.040 185.110 8.260)  (186.390 8.040 186.610 8.260)
   512 x CO.7: CO.7 : Space from COMP contact to Poly2 : 0.15µm   e.g. at (204.140 12.243 204.170 12.757)  (198.140 12.243 198.170 12.757)  (197.830 12.243 197.860 12.757)
   368 x M1.2a: M1.2a : min. metal1 spacing : 0.23µm   e.g. at (197.920 4.800 198.080 4.820)  (196.420 4.800 196.580 4.820)  (183.420 4.800 183.580 4.820)
   224 x NP.5a: NP.5a : Overlap of N-channel gate. : 0.23µm   e.g. at (189.194 1.679 189.806 1.841)  (189.194 1.159 189.806 1.321)  (187.694 1.159 188.306 1.321)
   192 x PP.5a: PP.5a : Overlap of P-channel gate. : 0.23µm   e.g. at (200.694 9.359 201.306 9.521)  (200.694 8.479 201.306 8.641)  (187.694 9.359 188.306 9.521)
   176 x CO.2a: CO.2a : min. contact spacing : 0.25µm   e.g. at (158.830 12.437 158.890 12.853)  (171.650 12.610 172.070 12.680)  (120.110 1.147 120.170 1.563)
    96 x PP.6: PP.6 : Overlap with PCOMP butted to NCOMP. : 0.22µm   e.g. at (147.040 4.640 147.960 4.660)  (134.040 9.340 134.960 9.360)  (131.040 5.340 131.960 5.360)
    80 x NP.2: NP.2 : min. nplus spacing : 0.4µm   e.g. at (54.120 8.660 54.380 9.340)  (41.120 8.660 41.380 9.340)  (28.120 8.660 28.380 9.340)
    80 x PP.2: PP.2 : min. pplus spacing : 0.4µm   e.g. at (73.120 11.980 73.380 13.020)  (60.120 11.980 60.380 13.020)  (58.620 11.980 58.880 13.020)
    64 x CO.3: CO.3 : Poly2 overlap of contact. : 0.07µm   e.g. at (2.859 1.099 3.141 1.384)  (15.859 1.099 16.141 1.384)  (28.859 1.099 29.141 1.384)
    64 x CO.4: CO.4 : COMP overlap of contact. : 0.07µm   e.g. at (5.890 0.990 6.110 1.320)  (18.890 0.990 19.110 1.320)  (31.890 0.990 32.110 1.320)
    64 x NP.5b: NP.5b : Extension beyond COMP for the COMP
                  (1) inside LVPWELL (2) outside Nwell and DNWELL. : 0.16µm   e.g. at (1.040 4.660 1.960 4.660)  (4.040 4.660 4.960 4.660)  (14.040 4.660 14.960 4.660)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?