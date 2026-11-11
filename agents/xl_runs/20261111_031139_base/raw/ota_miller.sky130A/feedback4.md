Judge:
  FAIL DRC      6837 violation(s): 2982 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8); 1573 x All nwells must contain metal-connected N+ taps (nwell.4); 950 x P-diff distance to N-tap must be < 15.0um (LU.3); 342 x N-diff distance to P-tap must be < 15.0um (LU.2); 192 x Diffusion contact to gate < 0.055um (licon.11); 176 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)
  FAIL DRC2     foundry KLayout deck: 10698 violation(s): 10004 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um; 376 x licon.1: licon.1: min/max. licon length : 0.17um; 112 x via.1a_b: via.1a_b : maximum length of via : 0.15um; 84 x m2.4: m2.4 : min. m2 enclosure of via : 0.055um; 60 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap); 28 x m2.5: m2.5 : min. m2 enclosure of via of 2 adjacent edges : 0.085um
  FAIL LVS      magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)  (devices layout/ref ?/?; report -)
  FAIL pins     not confirmed (LVS failed)
  FAIL area     176000.00 x 40700.00 = 7163200000.0 um2, budget 2648, reference 1323.89

Tool report:
DRC (magic drc(full)): 6837 violation(s), boxes in um
  2982 x N-well overlap of P-Diffusion < 0.18um (diff/tap.8)   e.g. at (119.820 2625.000 120.000 2625.130)  (119.820 2600.000 120.000 2625.000)  (119.820 2599.820 120.000 2600.000)
  1573 x All nwells must contain metal-connected N+ taps (nwell.4)   e.g. at (119.820 2599.820 157.280 2673.760)  (119.820 2673.760 157.280 2988.320)  (119.820 2988.320 157.280 3302.880)
   950 x P-diff distance to N-tap must be < 15.0um (LU.3)   e.g. at (0.000 2625.000 120.000 2673.760)  (-15.000 2600.000 120.000 2625.000)  (119.820 2599.820 120.000 2600.000)
   342 x N-diff distance to P-tap must be < 15.0um (LU.2)   e.g. at (0.000 1500.000 120.000 1730.080)  (0.000 1730.080 120.000 2044.640)  (0.000 2044.640 120.000 2359.200)
   192 x Diffusion contact to gate < 0.055um (licon.11)   e.g. at (120.000 2585.000 157.280 2585.055)  (119.945 2415.000 157.280 2415.055)  (120.000 2585.000 157.280 2585.055)
   176 x Metal1 overlap of Via1 < 0.03um in one direction (via.5a - via.4a)   e.g. at (1924.945 -75.085 1924.975 -75.055)  (1924.915 -75.055 1924.945 -75.025)  (1924.945 2354.915 1924.975 2354.945)
   172 x N-Diffusion spacing to N-well < 0.34um (diff/tap.9)   e.g. at (119.820 2600.000 157.280 2600.340)  (119.820 2599.820 120.160 2600.340)  (119.820 2599.820 120.000 2600.160)
   112 x Metal2 overlap of Via1 < 0.03um in one direction (met2.5 - met2.4)   e.g. at (1924.915 75.025 1924.945 75.055)  (1924.945 75.055 1924.975 75.085)  (1924.945 -75.085 1924.975 -75.055)
    79 x N-well overlap of N-tap < 0.18um (diff/tap.10)   e.g. at (149999.817 1499.870 149999.867 1730.080)  (149999.867 1499.870 149999.997 1730.080)  (149999.817 1499.820 149999.997 1499.870)
    72 x nFET cannot abut P-diffusion (diff/tap.3)   e.g. at (119.730 2600.000 120.000 2600.270)  (120.000 2599.820 120.270 2600.000)  (1380.000 2600.000 1380.270 2600.270)
    72 x N-Diffusion overhang of nFET < 0.25um (poly.7)   e.g. at (119.750 2600.000 120.000 2600.070)  (119.820 2599.820 120.000 2600.000)  (1380.000 2600.000 1380.250 2600.070)
    72 x pFET cannot abut N-diffusion (diff/tap.3)   e.g. at (120.000 2600.000 120.090 2600.270)  (120.000 2600.000 120.270 2600.090)  (1379.910 2600.000 1380.000 2600.270)
DRC2 (foundry KLayout deck): 10698 violation(s), boxes in um
  10004 x via3.1_b: via3.1_b : maximum length of via3 : 0.2um   e.g. at (124100.000 25600.000 124100.000 25800.000)  (124300.000 25600.000 124300.000 25800.000)  (143700.000 25600.000 143700.000 25800.000)
   376 x licon.1: licon.1: min/max. licon length : 0.17um   e.g. at (157085.000 14415.000 157085.000 14585.000)  (150915.000 2585.000 151085.000 2585.000)  (156915.000 14585.000 157085.000 14585.000)
   112 x via.1a_b: via.1a_b : maximum length of via : 0.15um   e.g. at (19575.000 12425.000 19575.000 12575.000)  (19425.000 12425.000 19425.000 12575.000)  (19425.000 15355.000 19575.000 15355.000)
    84 x m2.4: m2.4 : min. m2 enclosure of via : 0.055um   e.g. at (22925.000 2355.000 22925.000 2505.000)  (22925.000 2505.000 23000.055 2505.000)  (8925.000 2355.000 8925.000 2505.000)
    60 x licon.17: licon.17 : Licons may not overlap both poly and (diff or tap)   e.g. at (45720.000 2415.000 45795.000 2585.000)  (43705.000 2415.000 43780.000 2585.000)  (76120.000 15415.000 76195.000 15585.000)
    28 x m2.5: m2.5 : min. m2 enclosure of via of 2 adjacent edges : 0.085um   e.g. at (15925.000 3355.000 16075.000 3505.000)  (15925.000 13155.000 16075.000 13305.000)  (19425.000 2355.000 19575.000 2505.000)
     8 x via2.1a_b: via2.1a_b : maximum length of via2 : 0.2um   e.g. at (33400.000 15300.000 33400.000 15500.000)  (33400.000 15500.000 33600.000 15500.000)  (33600.000 15300.000 33600.000 15500.000)
     8 x m3.4: m3.4 : min. m3 enclosure of via2 : 0.065um   e.g. at (19400.000 35500.000 19400.000 35700.000)  (19600.000 35500.000 19600.000 35700.000)  (19400.000 35500.000 19600.000 35500.000)
     7 x via2.4: via2.4 : min. m2 enclosure of via2 : 0.04um   e.g. at (33400.000 15300.000 33400.000 15500.000)  (33400.000 15500.000 33500.040 15500.000)  (19400.000 35500.000 19400.000 35700.000)
     4 x via3.4: via3.4 : min. m3 enclosure of via3 : 0.06um   e.g. at (19400.000 35500.000 19400.000 35700.000)  (19400.000 35700.000 19600.000 35700.000)  (19600.000 35500.000 19600.000 35700.000)
     4 x m4.3: m4.3 : min. m4 enclosure of via3 : 0.065um   e.g. at (19400.000 35500.000 19400.000 35700.000)  (19400.000 35500.000 19600.000 35500.000)  (19400.000 35700.000 19600.000 35700.000)
     2 x via2.5: via2.5 : min. m3 enclosure of via2 of 2 adjacent edges : 0.085um   e.g. at (33400.000 15300.000 33600.000 15500.000)  (19400.000 35500.000 19600.000 35700.000)
LVS: magic extraction did not finish in 180 s (a layout with very many errors or shorts takes this long; a correct layout of this size takes seconds)   devices layout/ref ?/?, nets layout/ref ?/?