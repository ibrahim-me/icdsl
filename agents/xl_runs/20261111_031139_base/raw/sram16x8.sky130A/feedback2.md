Judge:
  FAIL DRC      37936 violation(s): 13638 x N-diff distance to P-tap must be < 15.0um (LU.2); 10304 x All nwells must contain metal-connected N+ taps (nwell.4); 7290 x P-diff distance to N-tap must be < 15.0um (LU.3); 6640 x Metal1 overlap of local interconnect contact < 0.03um (met1.4); 32 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4); 32 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)
  FAIL DRC2     foundry KLayout deck: 666 violation(s): 512 x via.1a_b: via.1a_b : maximum length of via : 0.15um; 60 x licon.1: licon.1: min/max. licon length : 0.17um; 60 x ct.1_b: ct.1_b : maximum length of mcon : 0.17um; 15 x ct.4: ct.4 : mcon should covered by li; 9 x m1.4: m1.4 : mcon periphery must be enclosed by m1; 8 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     29400.00 x 77000.00 = 2263800000.0 um2, budget 4210, reference 2104.59

Tool report:
DRC (magic drc(full)): 37936 violation(s), boxes in um
  13638 x N-diff distance to P-tap must be < 15.0um (LU.2)   e.g. at (300.000 550.000 471.840 786.400)  (300.000 786.400 471.840 1100.960)  (300.000 1100.960 471.840 1415.520)
  10304 x All nwells must contain metal-connected N+ taps (nwell.4)   e.g. at (1150.000 250.000 1415.520 471.840)  (1150.000 471.840 1415.520 786.400)  (1150.000 786.400 1415.520 1100.960)
  7290 x P-diff distance to N-tap must be < 15.0um (LU.3)   e.g. at (1300.000 730.000 1375.000 786.400)  (1300.000 550.000 1415.520 730.000)  (1300.000 786.400 1375.000 1100.960)
  6640 x Metal1 overlap of local interconnect contact < 0.03um (met1.4)   e.g. at (115.000 1065.000 115.030 1100.960)  (115.000 1065.000 157.280 1065.030)  (115.000 1234.970 157.280 1235.000)
    32 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4)   e.g. at (1724.945 -75.085 1724.975 -75.055)  (1724.915 -75.055 1724.945 -75.025)  (1875.055 -75.055 1875.085 -75.025)
    32 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)   e.g. at (1724.945 -75.085 1724.975 -75.055)  (1724.915 -75.055 1724.945 -75.025)  (1875.055 -75.055 1875.085 -75.025)
DRC2 (foundry KLayout deck): 666 violation(s), boxes in um
   512 x via.1a_b: via.1a_b : maximum length of via : 0.15um   e.g. at (23325.000 68925.000 23325.000 69075.000)  (23325.000 68925.000 23475.000 68925.000)  (26925.000 64475.000 27075.000 64475.000)
    60 x licon.1: licon.1: min/max. licon length : 0.17um   e.g. at (115.000 2215.000 115.000 2385.000)  (2565.000 915.000 2735.000 915.000)  (2565.000 3915.000 2735.000 3915.000)
    60 x ct.1_b: ct.1_b : maximum length of mcon : 0.17um   e.g. at (115.000 2215.000 115.000 2385.000)  (2565.000 915.000 2735.000 915.000)  (2565.000 3915.000 2735.000 3915.000)
    15 x ct.4: ct.4 : mcon should covered by li   e.g. at (365.000 915.000 535.000 1085.000)  (365.000 3915.000 535.000 4085.000)  (865.000 915.000 1035.000 1085.000)
     9 x m1.4: m1.4 : mcon periphery must be enclosed by m1   e.g. at (1365.000 4000.000 1535.000 4085.000)  (865.000 4000.000 1035.000 4085.000)  (115.000 1065.000 285.000 1235.000)
     8 x m2.4_a: m2.4_a : via in periphery must be enclosed by met2   e.g. at (26925.000 -75.000 27075.000 -55.000)  (23325.000 -75.000 23475.000 -55.000)  (19725.000 -75.000 19875.000 -55.000)
     2 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (1375.000 915.000 1525.000 1085.000)  (875.000 940.000 1025.000 1085.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?